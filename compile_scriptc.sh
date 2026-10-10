#!/bin/bash
#
# scriptc (TypeScript-to-native) Compilation Script — iOS library mode
#
# Builds case/<name>/lib.ts into an iOS arm64 static library archive with
#   SCRIPTC_TARGET=aarch64-apple-ios scriptc build --lib --profile ...
# then extracts the single USER program object (program.o) from the archive
# and measures its __TEXT/__DATA with `xcrun size`, matching the marginal
# per-case code size measured for Kotlin Native (whose stdlib lives in a
# separate, uncounted prebuild cache). The scriptc runtime objects (scr_*.o)
# bundled in the archive are the shared runtime floor and are reported
# separately, not charged to the case.
#
# Usage: ./compile_scriptc.sh <case_name>
# Output (stdout, last line): TEXT_user DATA_user TEXT_floor DATA_floor
# Exit non-zero if the case does not compile for the iOS static tier.

set -euo pipefail

CASE_NAME="${1:?usage: compile_scriptc.sh <case_name>}"
CASE_DIR="case/$CASE_NAME"
LIB_TS="$CASE_DIR/lib.ts"

if [ ! -f "$LIB_TS" ]; then
  echo "scriptc: no lib.ts for case '$CASE_NAME'" >&2
  exit 2
fi

# Locate the installed iOS runtime pack (pinned to scriptc --version).
PACK="node_modules/@scriptc/runtime-ios-arm64"
if [ ! -f "$PACK/runtime-pack.json" ]; then
  echo "scriptc: iOS runtime pack missing; run: npm install @scriptc/runtime-ios-arm64@$(scriptc --version)" >&2
  exit 3
fi

export SCRIPTC_TARGET=aarch64-apple-ios
export SCRIPTC_RUNTIME_PACK="$PWD/$PACK"

OUT_DIR="$CASE_DIR/.scriptc"
rm -rf "$OUT_DIR"
mkdir -p "$OUT_DIR"
PROFILE="$OUT_DIR/app.profile.json"

# Generate the library profile. The single exported entry (runBenchmark)
# transitively references every type in the case, preventing dead-code
# elimination — the scriptc analogue of the Swift `public` requirement.
cat > "$PROFILE" <<JSON
{
  "profile_format": 1,
  "name": "${CASE_NAME}_bench",
  "entry": "lib.mts",
  "emission": "llvm",
  "exports": [
    { "export": "runBenchmark", "symbol": "bench_run", "params": [], "returns": "void" }
  ],
  "abi": {
    "prefix": "bench_",
    "init_symbol": "bench_init",
    "sink_register_symbol": "bench_sink_register"
  }
}
JSON

# Build the archive (profile.entry is resolved relative to the profile file).
# Build as an ES module (.mts) so `export` is honored regardless of the
# nearest package.json "type"; the source stays lib.ts to parallel the other
# languages' lib.{kt,swift,m}.
cp "$LIB_TS" "$OUT_DIR/lib.mts"
if ! scriptc build --lib --profile "$PROFILE" -o "$OUT_DIR/${CASE_NAME}.lib.a" > "$OUT_DIR/build.log" 2>&1; then
  echo "scriptc: build failed for '$CASE_NAME'" >&2
  sed 's/^/  /' "$OUT_DIR/build.log" >&2
  exit 1
fi

ARCHIVE="$OUT_DIR/${CASE_NAME}.lib.a"

# Extract members and measure. program.o = user code; scr_*.o = runtime floor.
WORK="$OUT_DIR/extract"
rm -rf "$WORK"; mkdir -p "$WORK"
( cd "$WORK" && ar x "$PWD/../${CASE_NAME}.lib.a" 2>/dev/null || ar x "../${CASE_NAME}.lib.a" )

measure() { # sum __TEXT and __DATA across the given object files
  python3 - "$@" <<'PY'
import subprocess, sys
tt = dd = 0
for o in sys.argv[1:]:
    out = subprocess.run(["xcrun","size","-arch","arm64",o],
                         capture_output=True, text=True).stdout.strip().splitlines()
    if len(out) >= 2:
        parts = out[1].split()
        tt += int(parts[0]); dd += int(parts[1])
print(tt, dd)
PY
}

USER_OBJ="$WORK/program.o"
if [ ! -f "$USER_OBJ" ]; then
  echo "scriptc: program.o not found in archive for '$CASE_NAME'" >&2
  exit 4
fi

read -r TEXT_USER DATA_USER < <(measure "$USER_OBJ")
# shellcheck disable=SC2046
read -r TEXT_FLOOR DATA_FLOOR < <(measure $(ls "$WORK"/scr_*.o 2>/dev/null))

echo "$TEXT_USER $DATA_USER $TEXT_FLOOR $DATA_FLOOR"
