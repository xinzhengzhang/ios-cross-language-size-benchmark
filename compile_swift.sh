#!/bin/bash

# Swift Compilation Script - Exact Bazel Command Recreation
# Executes the exact subcommand from bazel aquery

set -e

# Work in the standalone directory (simulating bazel execroot/_main)
# All paths in the bazel command are relative to this directory

# Set environment variables exactly as bazel does
export APPLE_SDK_PLATFORM=iPhoneOS
export APPLE_SDK_VERSION_OVERRIDE=18.5
export PATH=/bin:/usr/bin:/usr/local/bin
export XCODE_VERSION_OVERRIDE=16.4.0.16F6

# Create output directories
mkdir -p bazel-workspace/bazel-out/ios_arm64-opt-ios-arm64-min15.0-applebin_ios-ST-659a08be7a88/bin/examples/ios-size-benchmark/_objs/swift_library
mkdir -p bazel-workspace/bazel-out/ios_arm64-opt-ios-arm64-min15.0-applebin_ios-ST-659a08be7a88/bin/examples/ios-size-benchmark

# Prepare params file with real iOS SDK path
IOS_SDK=$(xcrun --sdk iphoneos --show-sdk-path)
PARAMS_FILE="bazel-workspace/bazel-out/ios_arm64-opt-ios-arm64-min15.0-applebin_ios-ST-659a08be7a88/bin/examples/ios-size-benchmark/examples_ios_size_benchmark_swift_library.swiftmodule-0.params"
TEMP_PARAMS="${PARAMS_FILE}.actual"

sed -e "s|__IOS_SDK_PATH__|$IOS_SDK|g" \
    -e "s|^bazel-out/|bazel-workspace/bazel-out/|g" \
    -e "s|^examples/|bazel-workspace/examples/|g" \
    -e '/^#/d' "$PARAMS_FILE" > "$TEMP_PARAMS"

echo "Compiling Swift with exact bazel command..."
echo "Using params file: $TEMP_PARAMS"

# Execute the exact bazel command
exec env - \
    APPLE_SDK_PLATFORM=iPhoneOS \
    APPLE_SDK_VERSION_OVERRIDE=18.5 \
    PATH=/bin:/usr/bin:/usr/local/bin \
    XCODE_VERSION_OVERRIDE=16.4.0.16F6 \
  bazel-workspace/bazel-out/darwin_arm64-opt-exec-ST-d57f47055a04/bin/external/rules_swift~/tools/worker \
    @"$TEMP_PARAMS"