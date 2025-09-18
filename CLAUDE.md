# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is an iOS Size Benchmark project that compares code size impact across Kotlin Native, Swift, and Objective-C implementations. It recreates exact Bazel compilation commands extracted from `bazel aquery` to measure and compare the compiled binary sizes of equivalent functionality implemented in different languages.

## Core Commands

### Running Benchmarks
```bash
# Run all test cases and generate comprehensive report
./benchmark_all_cases.sh

# Run specific test case only
./benchmark_all_cases.sh callback

# Run individual compilation steps
./compile_objc.sh    # Objective-C compilation with wrapped_clang
./compile_swift.sh   # Swift compilation with worker + params
./compile_kotlin.sh  # Kotlin Native compilation with wrapper + dual params
```

### System Requirements

#### Kotlin Native (Required: >= 2.2.20)
```bash
# Download from https://kotlinlang.org/docs/native.html
export KOTLIN_NATIVE_DIST=/path/to/kotlin-native-macos-aarch64-2.2.20

# Verify version meets minimum requirement
$KOTLIN_NATIVE_DIST/bin/kotlinc-native -version
# Must show: kotlinc-native 2.2.20 or later
```

#### Swift Toolchain (Xcode)
```bash
# Install Xcode command line tools
xcode-select --install

# Verify Swift version and iOS SDK
xcrun swift --version                    # Should show Swift 5.9+
xcrun --sdk iphoneos --show-sdk-version  # Should show iOS SDK 15.0+
xcrun --sdk iphoneos --show-sdk-path     # Verify iOS SDK path exists
```

#### Additional Tools
```bash
# Verify bc is available
which bc
```

### Auto-Detection and Validation
The benchmark scripts automatically:
- **Kotlin Native**: Search common installation paths and validate version >= 2.2.20
- **Swift/Xcode**: Verify iOS SDK availability and set required environment variables
- **Missing Tools**: Provide specific installation instructions for failed prerequisites

### Environment Variables (Set Automatically)
```bash
# iOS compilation (set by compile scripts)
export APPLE_SDK_PLATFORM=iPhoneOS
export APPLE_SDK_VERSION_OVERRIDE=18.5
export XCODE_VERSION_OVERRIDE=16.4.0.16F6

# Kotlin Native (user must set)
export KOTLIN_NATIVE_DIST=/path/to/kotlin-native-distribution

# Java (usually auto-detected)
export JAVA_HOME=$(/usr/libexec/java_home)
```

### Common Issues and Solutions

#### Kotlin Native Version Too Old
```bash
# Error: "Kotlin Native version X.X.X is less than required version 2.2.20"
# Solution: Download newer version from kotlinlang.org
export KOTLIN_NATIVE_DIST=/path/to/kotlin-native-macos-aarch64-2.2.20
```

#### iOS SDK Not Found
```bash
# Error: iOS SDK path issues
# Solution: Reinstall Xcode command line tools
sudo xcode-select --reset
xcode-select --install
```

#### Swift Compilation Fails
```bash
# Error: Swift worker or params file issues
# Solution: Verify Xcode installation and iOS SDK
xcrun --sdk iphoneos --show-sdk-path  # Should return valid path
```

## Architecture

### Directory Structure
- `case/*/` - Test cases with equivalent implementations (lib.kt, lib.swift, lib.m)
- `bazel-workspace/` - Exact recreation of Bazel's build directory structure
- `results.csv` - Generated benchmark results with size metrics

### Test Case Categories
Each test case in `case/` contains three equivalent implementations:
- **Data-focused**: `data-classes`, `data-classes-enhanced` - Different data modeling approaches
- **Concurrency**: `async`, `async-enhanced` - Async programming patterns 
- **Language Features**: `generics-heavy`, `inheritance-deep`, `protocol-oriented` - Language-specific patterns
- **Functional**: `functional-style`, `extension-functions` - Functional programming styles
- **Optimization**: `collection-minimal` - Size-optimized implementations

### Compilation Pipeline
1. **Source Replacement**: Copies test case files to Bazel workspace structure
2. **Exact Recreation**: Uses identical compiler flags and paths as Bazel
3. **Size Analysis**: Measures TEXT and DATA sections, applies weighting formula (TEXT×0.7 + DATA×0.2)
4. **Cross-Language Comparison**: Generates relative size metrics per test case

## Key Implementation Details

### Swift Properties Access Modifiers
All properties in public Swift types must be marked as `public` for external module access:
```swift
public struct Example {
    public let property: String
    public var computed: String { ... }
}
```

### Bazel Command Recreation
The project preserves exact Bazel compilation behavior:
- **Environment Variables**: `APPLE_SDK_PLATFORM`, `XCODE_VERSION_OVERRIDE`, etc.
- **Tool Wrappers**: Mock wrapped_clang, worker tools with path translation
- **Params Files**: Process @file.params mechanism identically to Bazel
- **Output Paths**: Generate files in identical `bazel-out/...` hierarchy

### Size Calculation
Final size metric uses weighted formula accounting for typical iOS binary composition:
- TEXT section weight: 0.7 (executable code)
- DATA section weight: 0.2 (initialized data)

## Test Case Rules and Conventions

### Fundamental Requirements

#### Equivalent Functionality Across Languages
Each test case must implement **identical functionality** in all three languages:
- **lib.kt** (Kotlin Native) - Leverages language-specific features for concise implementation
- **lib.swift** (Swift) - Manual implementation of equivalent behavior
- **lib.m** (Objective-C) - Complete manual boilerplate implementation

#### Swift Access Modifier Rules
**CRITICAL**: All Swift types and properties must be marked `public` to prevent dead code elimination:
```swift
public struct Example {
    public let property: String        // Must be public
    public var computed: String { }    // Must be public
    public func method() { }           // Must be public
}
```
**Reason**: Swift's optimizer (opt) performs dead code elimination on `internal` types/members not used within the module, invalidating size comparisons.

#### Cross-Language Naming Consistency
Maintain equivalent naming patterns:
- **Classes/Structs**: `Person`, `Address`, `Employee` (same across all languages)
- **Properties**: `firstName`, `lastName`, `age` (camelCase in Swift/Kotlin, equivalent in Objective-C)
- **Methods**: `fullName()`, `isAdult()`, `copy()` (preserve semantic equivalence)

### Implementation Patterns by Language

#### Kotlin Native (`lib.kt`)
- Use `data class` for automatic equals/hashCode/toString/copy generation
- Leverage properties with custom getters: `val fullName: String get() = "$firstName $lastName"`
- Utilize language features like sealed classes, extension functions, inline functions
- Take advantage of null safety and smart casting

#### Swift (`lib.swift`) 
- Manual implementation of all functionality Kotlin generates automatically
- Implement custom `copy()` methods with default parameters
- Manual `Equatable`/`Hashable` conformance (often auto-synthesized)
- Use value semantics with structs where appropriate
- Computed properties for derived values

#### Objective-C (`lib.m`)
- Extensive manual boilerplate for all functionality
- Manual `@property` declarations with proper nullability annotations
- Custom initializers with full parameter lists
- Manual implementation of `isEqual:`, `hash`, `description`
- Manual copy methods and factory methods

### Case Categories and Goals

#### Data Modeling Cases
- **data-classes**: Basic structures - tests overhead of manual vs automatic implementation
- **data-classes-enhanced**: Complex nested structures, generics, protocols

#### Concurrency Cases
- **async**: Basic async patterns
- **async-enhanced**: Advanced async/await, structured concurrency

#### Language Feature Cases
- **generics-heavy**: Generic collections and type constraints
- **inheritance-deep**: Class hierarchies vs protocol composition
- **protocol-oriented**: Protocol-oriented programming patterns

#### Functional Programming Cases
- **functional-style**: Higher-order functions, immutability patterns
- **extension-functions**: Extension methods and utility functions

### Size Optimization Considerations

#### What Gets Measured
- **TEXT section**: Executable code (primary factor, weight 0.7)
- **DATA section**: Initialized data (secondary factor, weight 0.2)
- **Line count**: Development cost reference

#### Common Pitfalls
1. **Swift Dead Code Elimination**: Missing `public` modifiers result in artificially small binaries
2. **Inconsistent Functionality**: Different logic implementations invalidate comparisons
3. **Unused Code**: All implemented functionality should be theoretically accessible

### Working with Test Cases

#### Adding New Test Cases
1. Create directory: `case/new-case-name/`
2. Implement equivalent functionality ensuring:
   - Kotlin leverages language features for conciseness
   - Swift manually implements what Kotlin auto-generates
   - Objective-C provides complete manual boilerplate
3. **All Swift types/properties must be `public`**
4. Verify functional equivalence across implementations
5. Run benchmark: `./benchmark_all_cases.sh new-case-name`

#### Modifying Existing Cases
- **Never break functional equivalence** between language implementations
- **Always maintain `public` modifiers** in Swift code
- Test changes across all three languages simultaneously
- Verify size differences reflect intended language feature impacts

#### Validating Case Quality
```bash
# Test specific case
./benchmark_all_cases.sh your-case-name

# Check for compilation errors
./compile_swift.sh && ./compile_objc.sh && ./compile_kotlin.sh

# Verify non-zero sizes (indicates code wasn't stripped)
grep "your-case-name" results.csv
```

### Results Analysis
The benchmark generates `results.csv` with columns:
- `case, variant, language, success, text_size, data_size, final_size, lines_of_code`
- Use for cross-language size comparison and identifying optimization opportunities
- Compare relative size ratios between languages for each case