#!/bin/bash
#
# Zig Compilation Script — iOS size tier
#
# Builds case/<name>/lib.zig into a single iOS arm64 relocatable object with
#   zig build-obj lib.zig -target aarch64-ios -O ReleaseSmall
# and measures its __TEXT/__DATA with `xcrun size`, matching the marginal
# per-case code size measured for the other languages.
#
# Unlike the scriptc tier there is NO separate shared runtime floor: Zig has
# no managed runtime (no RC, no GC, no stdlib prebuild cache). Everything the
# case transitively uses — allocator shims, panic handler, monomorphized
# generics/containers — is inlined into this one object, so the whole object
# *is* the user-marginal cost. That is the honest "extreme control group"
# measurement: a systems language with a near-zero runtime.
#
# DCE root: each lib.zig ends with `export fn bench_run() void { runBenchmark(); }`
# (the Zig analogue of lib.ts's exported entry / Swift's `public`), which keeps
# the whole transitive graph in the object.
#
# Usage: ./compile_zig.sh <case_name>
# Output (stdout, last line): TEXT DATA
# Exit non-zero if the case does not compile for the iOS static tier (e.g.
# async/async-enhanced, which Zig 0.16 cannot express — no stable async/await).

set -euo pipefail

CASE_NAME="${1:?usage: compile_zig.sh <case_name>}"
CASE_DIR="case/$CASE_NAME"
LIB_ZIG="$CASE_DIR/lib.zig"

ZIG="${ZIG:-$HOME/.native/toolchains/zig-0.16.0/zig}"
if [ ! -x "$ZIG" ]; then
  echo "zig: compiler not found/executable at '$ZIG' (set \$ZIG)" >&2
  exit 3
fi

if [ ! -f "$LIB_ZIG" ]; then
  echo "zig: no lib.zig for case '$CASE_NAME'" >&2
  exit 2
fi

OUT_DIR="$CASE_DIR/.zig"
rm -rf "$OUT_DIR"
mkdir -p "$OUT_DIR"
OBJ="$OUT_DIR/program.o"

# -ios target without a version builds a plain relocatable object; ReleaseSmall
# is the -Os-parity profile used across the size tier.
if ! "$ZIG" build-obj "$LIB_ZIG" \
        -target aarch64-ios -O ReleaseSmall -femit-bin="$OBJ" \
        --cache-dir "$OUT_DIR/.cache" \
        > "$OUT_DIR/build.log" 2>&1; then
  echo "zig: build failed for '$CASE_NAME'" >&2
  sed 's/^/  /' "$OUT_DIR/build.log" >&2
  exit 1
fi

if [ ! -f "$OBJ" ]; then
  echo "zig: program.o not produced for '$CASE_NAME'" >&2
  exit 4
fi

read -r TEXT DATA < <(python3 - "$OBJ" <<'PY'
import subprocess, sys
out = subprocess.run(["xcrun","size","-arch","arm64",sys.argv[1]],
                     capture_output=True, text=True).stdout.strip().splitlines()
parts = out[1].split() if len(out) >= 2 else ["0","0"]
print(parts[0], parts[1])
PY
)

echo "$TEXT $DATA"
