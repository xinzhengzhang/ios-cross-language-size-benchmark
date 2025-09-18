#!/bin/bash

# Objective-C Compilation Script - Exact Bazel Command Recreation
# Executes the exact subcommand from bazel aquery

set -e

# Work in the standalone directory (simulating bazel execroot/_main)
# All paths in the bazel command are relative to this directory

# Set environment variables exactly as bazel does
export APPLE_SDK_PLATFORM=iPhoneOS
export APPLE_SDK_VERSION_OVERRIDE=18.5
export PATH=/bin:/usr/bin:/usr/local/bin
export XCODE_VERSION_OVERRIDE=16.4.0.16F6
export DEVELOPER_DIR=$(xcode-select -p)

# Create output directories
mkdir -p bazel-workspace/bazel-out/ios_arm64-opt-ios-arm64-min15.0-applebin_ios-ST-659a08be7a88/bin/examples/ios-size-benchmark/_objs/objc_library/arc

echo "Compiling Objective-C with exact bazel command..."

# Execute the exact bazel command
exec env - \
    APPLE_SDK_PLATFORM=iPhoneOS \
    APPLE_SDK_VERSION_OVERRIDE=18.5 \
    PATH=/bin:/usr/bin:/usr/local/bin \
    XCODE_VERSION_OVERRIDE=16.4.0.16F6 \
  bazel-workspace/bazel-out/darwin_arm64-opt-exec-ST-d57f47055a04/bin/external/apple_support~/crosstool/wrapped_clang \
    -target arm64-apple-ios15.0 \
    '-D_FORTIFY_SOURCE=1' \
    -fstack-protector \
    -fcolor-diagnostics \
    -Wall \
    -Wthread-safety \
    -Wself-assign \
    -fno-omit-frame-pointer \
    -g0 \
    -Os \
    -DNDEBUG \
    '-DNS_BLOCK_ASSERTIONS=1' \
    '-fdebug-prefix-map=__BAZEL_EXECUTION_ROOT__=.' \
    '-fdebug-prefix-map=__BAZEL_XCODE_DEVELOPER_DIR__=/PLACEHOLDER_DEVELOPER_DIR' \
    '-Werror=incompatible-sysroot' \
    -Wshorten-64-to-32 \
    -Wbool-conversion \
    -Wconstant-conversion \
    -Wduplicate-method-match \
    -Wempty-body \
    -Wenum-conversion \
    -Wint-conversion \
    -Wunreachable-code \
    -Wmismatched-return-types \
    -Wundeclared-selector \
    -Wuninitialized \
    -Wunused-function \
    -Wunused-variable \
    -iquote bazel-workspace \
    -iquote bazel-workspace/bazel-out/ios_arm64-opt-ios-arm64-min15.0-applebin_ios-ST-659a08be7a88/bin \
    -MD \
    -MF bazel-workspace/bazel-out/ios_arm64-opt-ios-arm64-min15.0-applebin_ios-ST-659a08be7a88/bin/examples/ios-size-benchmark/_objs/objc_library/arc/lib.d \
    -DOS_IOS \
    -fno-autolink \
    -isysroot __BAZEL_XCODE_SDKROOT__ \
    -F__BAZEL_XCODE_SDKROOT__/System/Library/Frameworks \
    -F__BAZEL_XCODE_DEVELOPER_DIR__/Platforms/iPhoneOS.platform/Developer/Library/Frameworks \
    -fobjc-arc \
    -Wno-deprecated-declarations \
    -Os \
    '-DNDEBUG=1' \
    -Wno-unused-variable \
    -Winit-self \
    -Wno-extra \
    -c bazel-workspace/examples/ios-size-benchmark/src/iosMain/objc/lib.m \
    -o bazel-workspace/bazel-out/ios_arm64-opt-ios-arm64-min15.0-applebin_ios-ST-659a08be7a88/bin/examples/ios-size-benchmark/_objs/objc_library/arc/lib.o