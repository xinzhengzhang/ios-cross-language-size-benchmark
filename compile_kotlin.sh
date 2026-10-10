#!/bin/bash

# Kotlin Native Prebuild Script - Exact Bazel Command Recreation
# Executes the KotlinNativePrebuild subcommand from bazel aquery

set -e

# Work in the standalone directory (simulating bazel execroot/_main)
# All paths in the bazel command are relative to this directory

# Set environment variables exactly as bazel does
export JAVA_HOME=${JAVA_HOME:-$(/usr/libexec/java_home)}

# Create output directories
mkdir -p bazel-workspace/bazel-out/ios_arm64-opt-ios-arm64-min15.0-applebin_ios-ST-659a08be7a88/bin/examples/ios-size-benchmark/ios_size_benchmark_library

# Prepare params files with real Kotlin Native paths
if [ -z "$KOTLIN_NATIVE_DIST" ]; then
    echo "Error: KOTLIN_NATIVE_DIST environment variable not set"
    echo "Please download Kotlin/Native compiler and set KOTLIN_NATIVE_DIST"
    exit 1
fi

# Check Kotlin Native version >= 2.2.20
check_kotlin_native_version() {
    local kotlin_native_version
    kotlin_native_version=$("$KOTLIN_NATIVE_DIST/bin/kotlinc-native" -version 2>&1 | head -1 | sed 's/.*kotlinc-native \([0-9][0-9]*\.[0-9][0-9]*\.[0-9][0-9]*\).*/\1/')
    
    if [ -z "$kotlin_native_version" ]; then
        echo "Error: Unable to determine Kotlin Native version"
        exit 1
    fi
    
    # Convert version to comparable format (e.g., 2.2.20 -> 20220)
    local current_version_num
    current_version_num=$(echo "$kotlin_native_version" | awk -F. '{printf "%d%02d%02d", $1, $2, $3}')
    local required_version_num=20220  # 2.2.20
    
    if [ "$current_version_num" -lt "$required_version_num" ]; then
        echo "Error: Kotlin Native version $kotlin_native_version is less than required version 2.2.20"
        echo "Please upgrade your Kotlin Native installation"
        exit 1
    fi
    
    echo "Kotlin Native version $kotlin_native_version meets requirement (>= 2.2.20)"
}

check_kotlin_native_version

PARAMS_FILE_0="bazel-workspace/bazel-out/ios_arm64-opt-ios-arm64-min15.0-applebin_ios-ST-659a08be7a88/bin/examples/ios-size-benchmark/ios_size_benchmark_library/examples_ios-size-benchmark_ios_size_benchmark_library.klib-0.params"
PARAMS_FILE_1="bazel-workspace/bazel-out/ios_arm64-opt-ios-arm64-min15.0-applebin_ios-ST-659a08be7a88/bin/examples/ios-size-benchmark/ios_size_benchmark_library/examples_ios-size-benchmark_ios_size_benchmark_library.klib-1.params"

TEMP_PARAMS_0="${PARAMS_FILE_0}.actual"
TEMP_PARAMS_1="${PARAMS_FILE_1}.actual"

# Copy first params file and remove bazel-workspace prefix
cp "$PARAMS_FILE_0" "$TEMP_PARAMS_0"

# Remove bazel-workspace prefix from paths in the first params file
sed -i '' -e "s|^bazel-workspace/||g" \
         -e "s|bazel-workspace/||g" \
         "$TEMP_PARAMS_0"

# The captured params reference the kotlinx-serialization compiler plugin jar at a
# frozen Bazel path that does not exist locally. Resolve the version-matched plugin
# from the Gradle cache and rewrite the -Xplugin entry (mirrors the stdlib-path
# substitution below). Only json-serialization needs it, but konanc loads the plugin
# for every compilation, so a stale path fails all cases.
KOTLIN_VERSION=$("$KOTLIN_NATIVE_DIST/bin/kotlinc-native" -version 2>&1 | sed -n 's/.*kotlinc-native \([0-9][0-9.]*\).*/\1/p')
SERIALIZATION_PLUGIN=$(find "$HOME/.gradle/caches" -iname "kotlin-serialization-compiler-plugin-embeddable-${KOTLIN_VERSION}.jar" 2>/dev/null | head -1)
[ -z "$SERIALIZATION_PLUGIN" ] && SERIALIZATION_PLUGIN=$(find "$HOME/.gradle/caches" -iname "kotlin-serialization-compiler-plugin-embeddable-*.jar" 2>/dev/null | head -1)
if [ -n "$SERIALIZATION_PLUGIN" ]; then
    echo "Using kotlinx-serialization plugin: $SERIALIZATION_PLUGIN"
    sed -i '' -e "s|-Xplugin=.*serialization-compiler-plugin[^[:space:]]*\.jar|-Xplugin=$SERIALIZATION_PLUGIN|g" "$TEMP_PARAMS_0"
else
    echo "Warning: kotlinx-serialization compiler plugin not found in ~/.gradle; stripping -Xplugin (json-serialization may fail)"
    sed -i '' -e "/-Xplugin=.*serialization-compiler-plugin/d" "$TEMP_PARAMS_0"
fi

# '-no-endorsed-libs' was removed in Kotlin 2.4.20 (warning-only, but strip for clean output).
sed -i '' -e "/^-no-endorsed-libs$/d" "$TEMP_PARAMS_0"

# Prepare second params file with real paths
KOTLIN_STDLIB_PATH="$KOTLIN_NATIVE_DIST/klib/common"
DEPENDENCIES_URL="ignore"

sed -e "s|__KOTLIN_NATIVE_STDLIB_PATH__|$KOTLIN_STDLIB_PATH|g" \
    -e "s|__DEPENDENCIES_URL__|$DEPENDENCIES_URL|g" \
    "$PARAMS_FILE_1" > "$TEMP_PARAMS_1"

echo "Compiling Kotlin Native with exact bazel command..."
echo "Using params files: $TEMP_PARAMS_0, $TEMP_PARAMS_1"

# Change to bazel-workspace directory and execute the exact bazel command
cd bazel-workspace
env - \
    JAVA_HOME="$JAVA_HOME" \
  $KOTLIN_NATIVE_DIST/bin/konanc \
    @"../$TEMP_PARAMS_0" \
    @"../$TEMP_PARAMS_1"
cd ..

# --- Build the user library static cache (the measured artifact) ---
#
# Kotlin Native 2.4.20 removed the manual per-library -Xadd-cache prebuild protocol that
# the frozen 2.2-era Bazel pipeline replayed here (its static_cache driver now resolves
# stdlib/platform libraries from the compiler distribution itself and rejects caching an
# externally-pathed stdlib: "library to cache ... not found among resolved libraries").
#
# We reproduce the SAME measured artifact — the user library compiled to a STATIC_CACHE,
# with stdlib / platform / kotlinx deps living in separate (uncounted) caches, measured by
# `xcrun size` on libexamples_...library-cache.a — using konanc's current auto-cache. The
# dependency caches (stdlib, platform, atomicfu, coroutines, serialization) are built from
# the 2.4.20 distribution and the committed maven klibs; only the user cache is measured.
REL_OUT="bazel-out/ios_arm64-opt-ios-arm64-min15.0-applebin_ios-ST-659a08be7a88/bin"
USER_KLIB="$REL_OUT/examples/ios-size-benchmark/ios_size_benchmark_library/examples_ios-size-benchmark_ios_size_benchmark_library.klib"
USER_CACHE_DIR="$REL_OUT/examples/ios-size-benchmark/ios_size_benchmark_library/prebuild_static_cache"
MVN="external/rules_gradle_external~~gradle~maven_deps_native_ios_arm64/flatten_artifacts"
# Shared dependency-cache dir: dist + maven caches are built once and reused across cases.
AUTO_CACHE_DIR="${KOTLIN_PREBUILD_CACHE:-$HOME/.cache/ios-size-benchmark/kn-autocache-2.4.20}"
mkdir -p "$AUTO_CACHE_DIR"

echo "Building user library static cache (konanc 2.4.20 auto-cache)..."
cd bazel-workspace

# kotlinx dependency klibs the user library may reference. Passing all of them is safe:
# unreferenced deps land in their own (uncounted) caches, not the measured user cache.
LFLAGS=()
for dep in \
  org.jetbrains.kotlinx_atomicfu-iosarm64_atomicfu.klib \
  org.jetbrains.kotlinx_atomicfu-iosarm64_atomicfu-cinterop-interop.klib \
  org.jetbrains.kotlinx_kotlinx-coroutines-core-iosarm64_kotlinx-coroutines-core-iosArm64Main.klib \
  org.jetbrains.kotlinx_kotlinx-serialization-core-iosarm64_kotlinx-serialization-core.klib \
  org.jetbrains.kotlinx_kotlinx-serialization-json-iosarm64_kotlinx-serialization-json.klib ; do
  [ -e "$MVN/$dep" ] && LFLAGS+=( -l "$PWD/$MVN/$dep" )
done

rm -rf "$USER_CACHE_DIR"; mkdir -p "$USER_CACHE_DIR"
env - \
    JAVA_HOME="$JAVA_HOME" \
  $KOTLIN_NATIVE_DIST/bin/konanc \
    -g -p static_cache -target ios_arm64 \
    -Xoverride-konan-properties='clangDebugFlags.ios_arm64=-Os -mllvm -fast-isel=false -mllvm -global-isel=false' \
    -Xadd-cache="$PWD/$USER_KLIB" \
    -Xcache-directory="$USER_CACHE_DIR" \
    -Xauto-cache-from="$KOTLIN_NATIVE_DIST" \
    -Xauto-cache-from="$PWD/$MVN" \
    -Xauto-cache-dir="$AUTO_CACHE_DIR" \
    "${LFLAGS[@]}"
cd ..