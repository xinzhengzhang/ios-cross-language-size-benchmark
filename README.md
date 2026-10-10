# iOS Size Benchmark - Cross-Language Comparison

[English](README.md) | [中文](README_CN.md)

### Overview

This project provides a comprehensive benchmark for comparing binary size impact across **Kotlin Native**, **Swift**, and **Objective-C** implementations on iOS. It recreates exact Bazel compilation commands to measure and compare the compiled binary sizes of equivalent functionality implemented in different languages.

### License and Attribution

This project is licensed under the MIT License. All test case implementations in the `case/` directory were generated using **Claude AI** (https://claude.ai) and demonstrate equivalent functionality across the three languages for educational and comparison purposes.

### Environment Requirements

#### Current Testing Environment
- **Kotlin Native**: 2.4.20
- **Swift**: Apple Swift version 6.3.3 (swiftlang-6.3.3.1.3 clang-2100.1.1.101)
- **Apple Clang**: version 21.0.0 (clang-2100.1.1.101)
- **iOS SDK**: 26.5
- **Xcode**: 26.6 (build 17F113)

> **Kotlin cache model note:** Kotlin Native 2.4.20 removed the manual per-library
> `-Xadd-cache` prebuild protocol the original pipeline replayed. `compile_kotlin.sh`
> now builds the user library's static cache via konanc's auto-cache against the 2.4.20
> distribution — the same measured artifact (`libexamples_…library-cache.a`, measured by
> `xcrun size`), only the dependency-cache mechanism differs. One side effect: 2.4.20's
> auto-cache requires every dependency cached, so `json-serialization` now counts the
> user-instantiated serializers in the measured object (they were externalized under 2.2),
> which is why its Kotlin number rose.

#### Setup Instructions
```bash
# 1. Install Kotlin Native (2.4.20)
export KOTLIN_NATIVE_DIST=/path/to/kotlin-native-prebuilt-macos-aarch64-2.4.20

# 2. Verify Swift/Xcode installation
xcrun swift --version
xcrun --sdk iphoneos --show-sdk-version

# 3. Verify bc calculator
which bc

# 4. Run all benchmarks
./benchmark_all_cases.sh
```

### Test Cases Overview

Our benchmark includes **16 comprehensive test cases** designed to evaluate different aspects of language features and their impact on binary size:

#### Data Modeling & Structure
- **`data-classes`**: Basic data structures comparison
  - *Kotlin*: `data class` with automatic methods generation
  - *Swift*: Manual struct implementation with computed properties
  - *Objective-C*: Complete manual boilerplate with properties and methods

- **`data-classes-enhanced`**: Complex nested structures with generics
  - *Kotlin*: Sealed classes, nested data classes, generic constraints
  - *Swift*: Enum associated values, nested types, Copy-on-Write optimization
  - *Objective-C*: Manual hierarchy simulation with extensive boilerplate

- **`many-classes`**: Multiple class definitions impact
  - Tests code size scaling with increasing number of type definitions
  - Evaluates per-class overhead across languages

#### Asynchronous Programming
- **`async`**: Basic asynchronous patterns
  - *Kotlin*: Coroutines with suspend functions
  - *Swift*: async/await with Task API
  - *Objective-C*: GCD with completion blocks

- **`async-enhanced`**: Advanced concurrency features
  - *Kotlin*: Structured concurrency, channels, flows
  - *Swift*: Actor model, TaskGroup, concurrent collections
  - *Objective-C*: Complex GCD patterns with synchronization

#### Language-Specific Features
- **`generics-heavy`**: Generic type system impact
  - Tests template/generic instantiation overhead
  - Compares type erasure vs. specialized implementations

- **`inheritance-deep`**: Class hierarchy vs. composition
  - *Kotlin*: Deep inheritance chains with overrides
  - *Swift*: Protocol composition and class inheritance
  - *Objective-C*: Traditional OOP hierarchy patterns

- **`protocol-oriented`**: Protocol-oriented programming
  - *Kotlin*: Interface delegation and implementations
  - *Swift*: Protocol extensions with default implementations
  - *Objective-C*: Protocol adoption with manual implementation

#### Functional Programming
- **`functional-style`**: Higher-order functions and immutability
  - Tests functional programming paradigms impact on size
  - Compares map/filter/reduce implementations

- **`extension-functions`**: Extension methods and utilities
  - *Kotlin*: Extension functions and properties
  - *Swift*: Extensions with computed properties and methods
  - *Objective-C*: Category-based extensions

- **`scope-functions`**: Scoping and context manipulation
  - *Kotlin*: `let`, `run`, `apply`, `also`, `with` functions
  - *Swift*: Manual scoping patterns
  - *Objective-C*: Block-based scoping simulation

#### Advanced Features
- **`null-safety`**: Null handling patterns
  - *Kotlin*: Built-in null safety with `?` and `!!`
  - *Swift*: Optional types with `?` and `!`
  - *Objective-C*: Manual nullability annotations and checks

- **`json-serialization`**: Data serialization impact
  - Tests serialization framework overhead
  - Compares automatic vs. manual serialization

- **`string-processing`**: String manipulation operations
  - Tests string processing algorithms and utilities
  - Compares string interpolation and formatting approaches

- **`variable-capture`**: Closure and capture patterns
  - Tests variable capture overhead in closures/lambdas
  - Analyzes memory management implications

#### Optimization-Focused Cases
- **`collection-minimal`**: Size-optimized implementations
  - Minimal collection operations avoiding complex abstractions
  - Focuses on achieving smallest possible binary size
  - Baseline for optimization comparisons

- **`callback`**: Callback pattern implementations
  - Tests different callback/delegate pattern approaches
  - Compares functional vs. object-oriented callback styles

### Key Features

#### Exact Bazel Recreation
- Preserves identical compiler flags and environment variables
- Uses exact tool wrappers and params file processing
- Maintains identical `bazel-out/` directory structure

#### Comprehensive Metrics
- **TEXT Section**: Executable code size (weight: 0.7)
- **DATA Section**: Initialized data size (weight: 0.2)  
- **Final Size**: Weighted combination for realistic binary impact
- **Lines of Code**: Development cost reference

#### Swift Compilation Specifics
All Swift types must be marked `public` to prevent dead code elimination by the optimizer:
```swift
public struct Example {
    public let property: String    // Must be public
    public var computed: String { get { ... } }
    public func method() { ... }
}
```

### Benchmark Results

Our comprehensive testing with Kotlin Native 2.4.20, Swift 6.3.3, and Apple Clang 21.0.0 (Xcode 26.6, iOS SDK 26.5) reveals significant differences in binary size across languages and use cases.

#### Summary Table

| Case | Objective-C (bytes) | Swift (bytes) | Kotlin (bytes) | Best Language | Swift vs ObjC | Kotlin vs ObjC |
|------|-------|-------|--------|-------------|-------------|-------------|
| **async** | 77,596 | 203,335 | 193,298 | **Objective-C** | 2.62x | 2.49x |
| **async-enhanced** | 25,089 | 81,174 | 68,407 | **Objective-C** | 3.24x | 2.73x |
| **callback** | 47,163 | 58,821 | 97,688 | **Objective-C** | 1.25x | 2.07x |
| **collection-minimal** | 4,854 | 6,958 | 6,803 | **Objective-C** | 1.43x | 1.40x |
| **data-classes** | 24,588 | 115,725 | 91,197 | **Objective-C** | 4.71x | 3.71x |
| **data-classes-enhanced** | 14,061 | 111,797 | 36,078 | **Objective-C** | 7.95x | 2.57x |
| **extension-functions** | 28,204 | 32,898 | 47,819 | **Objective-C** | 1.17x | 1.70x |
| **functional-style** | 13,398 | 44,172 | 34,968 | **Objective-C** | 3.30x | 2.61x |
| **generics-heavy** | 11,572 | 29,855 | 20,542 | **Objective-C** | 2.58x | 1.78x |
| **inheritance-deep** | 8,926 | 15,309 | 33,458 | **Objective-C** | 1.72x | 3.75x |
| **json-serialization** | 14,037 | 45,667 | 47,782 | **Objective-C** | 3.25x | 3.40x |
| **many-classes** | 17,672 | 18,066 | 23,483 | **Objective-C** | 1.02x | 1.33x |
| **null-safety** | 23,079 | 33,955 | 26,822 | **Objective-C** | 1.47x | 1.16x |
| **protocol-oriented** | 12,289 | 28,820 | 21,807 | **Objective-C** | 2.35x | 1.77x |
| **scope-functions** | 29,879 | 46,200 | 56,063 | **Objective-C** | 1.55x | 1.88x |
| **string-processing** | 17,366 | 42,131 | 27,238 | **Objective-C** | 2.43x | 1.57x |
| **variable-capture** | 8,569 | 16,392 | 13,484 | **Objective-C** | 1.91x | 1.57x |

#### Key Findings

**🏆 Objective-C consistently produces the smallest binaries** across all test cases, making it the clear winner for size-critical applications.

**📊 Language Performance Patterns:**
- **Swift penalty ranges from 1.02x to 7.95x** larger than Objective-C
- **Kotlin penalty ranges from 1.16x to 3.75x** larger than Objective-C  
- **Worst Swift cases**: data-classes-enhanced (7.95x), data-classes (4.71x)
- **Best Swift cases**: many-classes (1.02x), extension-functions (1.17x)

**⚡ Development Efficiency vs. Size Trade-offs:**

1. **Data Structure Features** (data-classes, data-classes-enhanced):
   - Kotlin's automatic generation vs Swift's manual implementation both carry significant overhead
   - Swift's extensive runtime metadata for features like `Codable` creates the largest binaries
   - Objective-C's manual approach, while verbose, produces minimal runtime overhead

2. **Language Convenience Features** (async, functional-style, scope-functions):
   - Modern language features (async/await, functional programming) add substantial binary size
   - Swift's advanced type system and runtime features create significant overhead
   - Kotlin's coroutines are more efficient than Swift's concurrency but still cost more than GCD

3. **Simple Operations** (collection-minimal, variable-capture):
   - When avoiding complex language features, size differences are minimized
   - All languages can be efficient for basic operations

#### Size Analysis Methodology

Results use weighted formula: **Final Size = TEXT × 0.7 + DATA × 0.2**
- **TEXT Section**: Executable code (primary factor)  
- **DATA Section**: Initialized data (secondary factor)
- **Lines of Code**: Development cost reference

#### Detailed Results

The benchmark generates `results.csv` with complete metrics:
```csv
case,variant,language,success,text_size,data_size,final_size,lines_of_code
async-enhanced,-Os,objc,true,32497,11708,25089,731
async-enhanced,-Os,swift,true,113944,7064,81174,462
async-enhanced,-Os,kotlin,true,85141,44040,68407,308
async,-Os,objc,true,104617,21820,77596,2122
async,-Os,swift,true,284694,20248,203335,1452
async,-Os,kotlin,true,238147,132976,193298,1005
callback,-Os,objc,true,61773,19608,47163,1448
callback,-Os,swift,true,81826,7712,58821,944
callback,-Os,kotlin,true,116485,80744,97688,907
collection-minimal,-Os,objc,true,5999,3276,4854,212
collection-minimal,-Os,swift,true,9707,896,6974,168
collection-minimal,-Os,kotlin,true,8847,3080,6809,154
data-classes-enhanced,-Os,objc,true,16151,10096,13325,381
data-classes-enhanced,-Os,swift,true,161777,25680,118380,505
data-classes-enhanced,-Os,kotlin,true,47741,14320,36283,317
data-classes,-Os,objc,true,29423,14348,23466,917
data-classes,-Os,swift,true,176673,13256,126322,1093
data-classes,-Os,kotlin,true,119520,25288,88722,683
extension-functions,-Os,objc,true,34350,17968,27639,1296
extension-functions,-Os,swift,true,48213,2920,34333,707
extension-functions,-Os,kotlin,true,60884,15824,45784,546
functional-style,-Os,objc,true,16839,6976,13182,486
functional-style,-Os,swift,true,62244,4896,44550,425
functional-style,-Os,kotlin,true,34481,27920,29721,280
generics-heavy,-Os,objc,true,13356,8848,11119,336
generics-heavy,-Os,swift,true,42477,7560,31246,259
generics-heavy,-Os,kotlin,true,21929,15920,18534,197
inheritance-deep,-Os,objc,true,8566,12424,8481,368
inheritance-deep,-Os,swift,true,17942,14072,15374,355
inheritance-deep,-Os,kotlin,true,40702,15048,31501,390
json-serialization,-Os,objc,true,16237,9700,13306,376
json-serialization,-Os,swift,true,62940,12200,46498,247
json-serialization,-Os,kotlin,true,26369,8656,20190,207
many-classes,-Os,objc,true,17523,23852,17036,928
many-classes,-Os,swift,true,21491,15056,18055,546
many-classes,-Os,kotlin,true,29174,16120,23646,385
null-safety,-Os,objc,true,27672,13096,21990,949
null-safety,-Os,swift,true,46368,8664,34190,822
null-safety,-Os,kotlin,true,33812,9624,25593,418
protocol-oriented,-Os,objc,true,14232,11620,12286,535
protocol-oriented,-Os,swift,true,40145,5016,29105,358
protocol-oriented,-Os,kotlin,true,27779,11544,21754,315
scope-functions,-Os,objc,true,35385,19948,28759,1087
scope-functions,-Os,swift,true,63946,10928,46948,829
scope-functions,-Os,kotlin,true,73289,17504,54803,698
string-processing,-Os,objc,true,21997,9124,17223,660
string-processing,-Os,swift,true,61581,4616,44030,600
string-processing,-Os,kotlin,true,32912,15192,26077,449
variable-capture,-Os,objc,true,10952,3952,8457,196
variable-capture,-Os,swift,true,22756,1800,16289,184
variable-capture,-Os,kotlin,true,16795,6888,13134,175
```
