#!/bin/bash
#
# macOS Execution-Speed Benchmark — ObjC / Swift / Kotlin Native / scriptc
#
# A companion to the size benchmark. Instead of iOS binary size, this measures
# how fast each language runs the SAME per-case workload (runBenchmark) as a
# native macOS executable.
#
# Methodology:
#   * Native macOS executables (host arm64), built with the size-optimized profile
#     that parallels the size tier (-Os parity): clang -Os, swiftc -Osize,
#     konanc -opt, scriptc default/release. NOT a speed-tuned build.
#   * Wall-clock with startup baseline: each driver loops runBenchmark either 0 or N
#     times (iters from argv; scriptc bakes it in). per-iter = (minWall(N) -
#     minWall(0)) / N. The 0-iteration run isolates process startup + arg parse, so
#     subtracting it removes per-language launch bias — without needing an in-language
#     clock. Each measurement does an untimed warmup run, then takes the min of REPS
#     timed samples (steady-state, least-noisy).
#   * The driver constructs a FRESH IosSizeBenchmark per iteration (see speed/main.*),
#     so the unit is one stateless run; reusing one instance would let stateful cases
#     accumulate across calls (super-linear) and diverge from scriptc's free-function
#     runBenchmark, which builds fresh state each call.
#   * N is calibrated per case (same N across languages) so the N run takes ~TARGET_SEC.
#   * All driver console output (print/println/NSLog/console.log) is discarded.
#   * async / async-enhanced are excluded (their drivers sleep — they'd measure
#     delays, not language speed).
#   * Any (case, language) that does not build or crashes at runtime is recorded
#     N/A with a reason (several ObjC cases call declared-but-unimplemented helper
#     methods — fine for the size tier, which never executes them).
#
# Output: results_speed.csv  (case,language,ns_per_iter,iters,status)

set -uo pipefail

KN="${KOTLIN_NATIVE_DIST:-$HOME/.konan/kotlin-native-prebuilt-macos-aarch64-2.4.20}"
SPEED_DIR="speed"
BUILD=".speedbuild"
OUT="results_speed.csv"
TARGET_SEC="${SPEED_TARGET_SEC:-0.5}"
REPS="${SPEED_REPS:-5}"

LANGS=(objc swift kotlin scriptc)
EXCLUDE=" async async-enhanced "

# --- kotlinx-serialization support for the Kotlin macOS speed build ------------
# json-serialization/lib.kt uses @Serializable + Json{}, which need (a) the
# kotlinx-serialization compiler plugin (a host-JVM, target-agnostic jar) and
# (b) the macOS klibs of serialization-core/-json. The size tier gets these from
# the captured Bazel graph (iOS klibs, unusable for a macos_arm64 host build), so
# the speed tier fetches the matching version once into a cache dir — mirroring
# the size tier's ~/.cache auto-cache dir. serialization-core depends only on
# stdlib (bundled in the dist); no atomicfu/coroutines are needed for this case.
SER_VER="${KOTLIN_SERIALIZATION_VERSION:-1.7.3}"
SER_CACHE="${KOTLIN_SERIALIZATION_MACOS_CACHE:-$HOME/.cache/ios-size-benchmark/kn-serialization-macos-$SER_VER}"
KV=$(basename "$KN" | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' | head -1)
SER_PLUGIN=$(find "$HOME/.gradle/caches" -iname "kotlin-serialization-compiler-plugin-embeddable-${KV}.jar" 2>/dev/null | head -1)
[ -z "$SER_PLUGIN" ] && SER_PLUGIN=$(find "$HOME/.gradle/caches" -iname "kotlin-serialization-compiler-plugin-embeddable-*.jar" 2>/dev/null | head -1)
SER_CORE="$SER_CACHE/kotlinx-serialization-core-macosarm64-$SER_VER.klib"
SER_JSON="$SER_CACHE/kotlinx-serialization-json-macosarm64-$SER_VER.klib"
ensure_ser_klibs() { # fetch the two macOS klibs once; 0 if both present
  [ -f "$SER_CORE" ] && [ -f "$SER_JSON" ] && return 0
  mkdir -p "$SER_CACHE"
  local base="https://repo1.maven.org/maven2/org/jetbrains/kotlinx"
  for art in kotlinx-serialization-core-macosarm64 kotlinx-serialization-json-macosarm64; do
    local f="$SER_CACHE/$art-$SER_VER.klib"
    [ -f "$f" ] || curl -fsSL -o "$f" "$base/$art/$SER_VER/$art-$SER_VER.klib" || return 1
  done
  [ -f "$SER_CORE" ] && [ -f "$SER_JSON" ]
}

rm -rf "$BUILD"; mkdir -p "$BUILD"
echo "case,language,ns_per_iter,iters,status" > "$OUT"

# --- build helpers: echo the runnable command for <case> at a given iters ------
# Native builds ignore iters (passed at runtime via argv); scriptc bakes it in.
build_objc()   { xcrun clang -Os -fobjc-arc -framework Foundation \
                   "case/$1/lib.m" "$SPEED_DIR/main.m" -o "$BUILD/$1.objc" 2>/dev/null; }
build_swift()  { xcrun swiftc -Osize \
                   "case/$1/lib.swift" "$SPEED_DIR/main.swift" -o "$BUILD/$1.swift" 2>/dev/null; }
build_kotlin() { # cases using kotlinx-serialization need the plugin + macOS klibs
  local extra=()
  if grep -qE '@Serializable|kotlinx\.serialization' "case/$1/lib.kt" 2>/dev/null; then
    { [ -n "$SER_PLUGIN" ] && ensure_ser_klibs; } || return 1  # unmet deps -> N/A
    extra=( -Xplugin="$SER_PLUGIN" -l "$SER_CORE" -l "$SER_JSON" )
  fi
  "$KN/bin/konanc" -opt -produce program -target macos_arm64 \
    -entry kntr.examples.ios.size.benchmark.main \
    ${extra[@]+"${extra[@]}"} \
    "case/$1/lib.kt" "$SPEED_DIR/main.kt" -o "$BUILD/$1.kotlin" >/dev/null 2>&1; }
# scriptc: codegen a single-file program (case lib + a top-level loop baked at iters)
build_scriptc_at() { # <case> <iters> -> $BUILD/<case>.scriptc.<iters>
  local c="$1" it="$2" src="$BUILD/$1.sc.$2.mts"
  { cat "case/$c/lib.ts"; printf '\nfor (let _i = 0; _i < %s; _i++) { runBenchmark(); }\n' "$it"; } > "$src"
  scriptc build "$src" --emit=exe -o "$BUILD/$c.scriptc.$it" >/dev/null 2>&1
}

# resolve the runnable command for a prepared (case,lang) at iters
run_cmd() { # <case> <lang> <iters>  -> prints the command, or nothing if unavailable
  local c="$1" l="$2" it="$3"
  case "$l" in
    objc)    echo "$BUILD/$c.objc $it" ;;
    swift)   echo "$BUILD/$c.swift $it" ;;
    kotlin)  echo "$BUILD/$c.kotlin.kexe $it" ;;
    scriptc) echo "$BUILD/$c.scriptc.$it" ;;  # must be pre-built at this iters
  esac
}
measure()  { python3 "$SPEED_DIR/measure.py" "$REPS" $1; }  # min over REPS samples
measure1() { python3 "$SPEED_DIR/measure.py" 1 $1; }         # single sample (calibration)

# --- main loop -----------------------------------------------------------------
ONLY="${1:-}"   # optional: run a single case
for d in case/*/; do
  c=$(basename "$d")
  case "$EXCLUDE" in *" $c "*) continue ;; esac
  [ -n "$ONLY" ] && [ "$c" != "$ONLY" ] && continue

  # Build native exes once; note which languages are available & smoke-run OK.
  # (bash 3.2 on macOS has no associative arrays — use plain ok_<lang> vars.)
  ok_objc=0; ok_swift=0; ok_kotlin=0; ok_scriptc=0
  build_objc   "$c" && "$BUILD/$c.objc" 3   >/dev/null 2>&1 && ok_objc=1
  build_swift  "$c" && "$BUILD/$c.swift" 3  >/dev/null 2>&1 && ok_swift=1
  build_kotlin "$c" && "$BUILD/$c.kotlin.kexe" 3 >/dev/null 2>&1 && ok_kotlin=1
  build_scriptc_at "$c" 3 && "$BUILD/$c.scriptc.3" >/dev/null 2>&1 && ok_scriptc=1

  # Calibrate N once per case (same N for all languages). Adaptive 1-rep probe via
  # a runnable NATIVE ref (argv-based, no rebuild): start small and ramp up only
  # until the probe is long enough to estimate reliably — heavy cases stop at the
  # smallest probe, light cases ramp up. Target ~TARGET_SEC for the base (N) run.
  N=""
  for ref in swift objc kotlin; do
    eval "[ \"\${ok_$ref}\" = 1 ]" || continue
    p=64; t=""
    while :; do
      t=$(measure1 "$(run_cmd "$c" "$ref" "$p")")
      [ "$t" = ERR ] && { t=""; break; }
      python3 -c "import sys;sys.exit(0 if float('$t')>=0.03 else 1)" && break
      [ "$p" -ge 500000 ] && break
      p=$((p*8))
    done
    [ -z "$t" ] && continue
    N=$(python3 -c "t=float('$t');n=round($p*$TARGET_SEC/t) if t>0 else 300000;print(max(10,min(3000000,n)))")
    echo "  [$c] N=$N (probe $p -> ${t}s via $ref)"
    break
  done
  # Fallback: no native runnable — calibrate with a single scriptc probe build.
  if [ -z "$N" ] && [ "$ok_scriptc" = 1 ]; then
    build_scriptc_at "$c" 2000 >/dev/null 2>&1
    t=$(measure1 "$(run_cmd "$c" scriptc 2000)")
    [ "$t" != ERR ] && N=$(python3 -c "t=float('$t');print(max(10,min(3000000,round(2000*$TARGET_SEC/t) if t>0 else 300000)))")
    [ -n "$N" ] && echo "  [$c] N=$N (scriptc probe)"
  fi
  if [ -z "$N" ]; then
    echo "  [$c] no runnable language — skipping"
    for l in "${LANGS[@]}"; do echo "$c,$l,,0,N/A(no-run)" >> "$OUT"; done
    continue
  fi
  for l in "${LANGS[@]}"; do
    if ! eval "[ \"\${ok_$l}\" = 1 ]"; then
      echo "$c,$l,,0,N/A(build-or-crash)" >> "$OUT"; continue
    fi
    if [ "$l" = scriptc ]; then
      build_scriptc_at "$c" 0    >/dev/null 2>&1   # startup-only baseline
      build_scriptc_at "$c" "$N" >/dev/null 2>&1
    fi
    # Baseline-subtraction: time the process doing 0 iterations (pure startup +
    # arg parse) and N iterations; per-iter = (work - startup) / N. Subtracting a
    # small, stable startup term removes per-language process-launch bias without
    # the noise of differencing two large wall-times (as a two-point N/2N would).
    t0=$(measure "$(run_cmd "$c" "$l" 0)")
    tN=$(measure "$(run_cmd "$c" "$l" "$N")")
    if [ "$t0" = ERR ] || [ "$tN" = ERR ]; then
      echo "$c,$l,,0,N/A(run-fail)" >> "$OUT"; continue
    fi
    ns=$(python3 -c "print(round((($tN)-($t0))/$N*1e9, 2))")
    echo "$c,$l,$ns,$N,ok" >> "$OUT"
    echo "    $c/$l: ${ns} ns/iter (N=$N)"
  done
done

echo
echo "=== results_speed.csv written ($(($(wc -l < "$OUT")-1)) rows) ==="
python3 "$SPEED_DIR/summarize.py"

