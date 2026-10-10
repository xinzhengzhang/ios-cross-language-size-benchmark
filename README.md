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

All sizes in bytes (final = TEXT×0.7 + DATA×0.2). scriptc measures the marginal user
object `program.o` (see the scriptc tier section); `async`/`async-enhanced` are N/A for
scriptc (`SC4005`).

| Case | ObjC | Swift | Kotlin | scriptc | Best | Swift/ObjC | Kotlin/ObjC | scriptc/ObjC |
|------|------|-------|--------|---------|------|-----------|------------|--------------|
| **async** | 77,596 | 203,335 | 193,298 | N/A¹ | **ObjC** | 2.62x | 2.49x | — |
| **async-enhanced** | 25,089 | 81,174 | 68,407 | N/A¹ | **ObjC** | 3.24x | 2.73x | — |
| **callback** | 47,163 | 58,821 | 97,688 | 98,194 | **ObjC** | 1.25x | 2.07x | 2.08x |
| **collection-minimal** | 4,854 | 6,958 | 6,803 | 5,972 | **ObjC** | 1.43x | 1.40x | 1.23x |
| **data-classes** | 24,588 | 115,725 | 91,197 | 130,563 | **ObjC** | 4.71x | 3.71x | 5.31x |
| **data-classes-enhanced** | 14,061 | 111,797 | 36,078 | 34,088 | **ObjC** | 7.95x | 2.57x | 2.42x |
| **extension-functions** | 28,204 | 32,898 | 47,819 | 104,889 | **ObjC** | 1.17x | 1.70x | 3.72x |
| **functional-style** | 13,398 | 44,172 | 34,968 | 90,539 | **ObjC** | 3.30x | 2.61x | 6.76x |
| **generics-heavy** | 11,572 | 29,855 | 20,542 | 38,551 | **ObjC** | 2.58x | 1.78x | 3.33x |
| **inheritance-deep** | 8,926 | 15,309 | 33,458 | 26,095 | **ObjC** | 1.72x | 3.75x | 2.92x |
| **json-serialization** | 14,037 | 45,667 | 47,782 | 23,391 | **ObjC** | 3.25x | 3.40x | 1.67x |
| **many-classes** | 17,672 | 18,066 | 23,483 | 36,580 | **ObjC** | 1.02x | 1.33x | 2.07x |
| **null-safety** | 23,079 | 33,955 | 26,822 | 49,211 | **ObjC** | 1.47x | 1.16x | 2.13x |
| **protocol-oriented** | 12,289 | 28,820 | 21,807 | 45,710 | **ObjC** | 2.35x | 1.77x | 3.72x |
| **scope-functions** | 29,879 | 46,200 | 56,063 | 97,107 | **ObjC** | 1.55x | 1.88x | 3.25x |
| **string-processing** | 17,366 | 42,131 | 27,238 | 41,320 | **ObjC** | 2.43x | 1.57x | 2.38x |
| **variable-capture** | 8,569 | 16,392 | 13,484 | 16,275 | **ObjC** | 1.91x | 1.57x | 1.90x |

¹ async-free module graph required by scriptc `--lib` mode (`SC4005`).

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

### scriptc (TypeScript → native) tier

A fourth implementation, `case/*/lib.ts`, is compiled with **scriptc 0.2.7** (an
experimental TypeScript-to-native compiler) and measured by `./compile_scriptc.sh`.

**What is measured.** scriptc builds an iOS arm64 static library whose archive contains
exactly one *user* object (`program.o`) plus the compiler's runtime objects (`scr_*.o`).
We measure **`program.o` only** — the user's marginal code — because it is the fair
analogue of the Kotlin Native number (whose stdlib lives in a separate, uncounted
prebuild cache). The scriptc runtime objects are a shared, fixed floor (≈616 KB TEXT /
≈80 KB DATA, reported separately), not charged to the case.

**async is N/A.** scriptc's `--lib` mode requires an async-free module graph, so `async`
and `async-enhanced` cannot be built for this tier (compiler error `SC4005`).

**Entry contract.** Each `lib.ts` exports a top-level `runBenchmark(): void` that
transitively exercises every type — the scriptc analogue of Swift's `public` requirement,
preventing dead-code elimination.

scriptc's per-case numbers and `scriptc/ObjC` ratios are in the Summary Table above.

**Why the spread (0.49x–2.59x vs Kotlin, geomean ~1.35x).** scriptc has almost no shared
stdlib floor in `program.o`: unlike Kotlin Native (which routes `map`/`filter`/generics to
a shared, uncounted stdlib), scriptc **specializes per call-site and monomorphizes
generics inline** into the user object (like C++ templates). So lambda/collection/generic-
heavy cases balloon (`functional-style` 2.59x, `extension-functions` 2.19x), while
data-class and deep-inheritance cases — where Kotlin's own synthesized members and
type-info are counted — come out *smaller* (`json-serialization` 0.49x, `inheritance-deep`
0.78x, `collection-minimal` 0.88x). It trades binary size for speed and a self-contained
artifact; see the macOS execution-speed tier below.

## Execution speed (macOS)

Size is only half the story. `./benchmark_speed.sh` measures how fast each language runs
the **same per-case `runBenchmark` workload** as a native **macOS** executable (a
companion to the iOS size tier). `results_speed.csv` holds the raw numbers.

**Methodology** (see `benchmark_speed.sh` header for details):
- Native macOS host executables, **-Os parity** with the size tier: `clang -Os`,
  `swiftc -Osize`, `konanc -opt`, scriptc default/release — *not* a speed-tuned build.
- The driver constructs a **fresh `IosSizeBenchmark` per iteration** (stateless unit;
  matches scriptc's free-function `runBenchmark`). Per-iter time =
  `(minWall(N) − minWall(0)) / N` — the 0-iteration run isolates process startup, which
  is subtracted so per-language launch cost doesn't bias the result. Each measurement
  does a warmup run, then takes the min of 5 samples.
- `N` is calibrated per case (same `N` across languages) to a ~0.5 s base run. Heavy
  cases (ms-scale per call) land at small `N`; light cases at large `N` (shown below).

**Coverage caveats:** `async`/`async-enhanced` are excluded (their drivers sleep).
ObjC is N/A for 4 cases and Swift/Kotlin for 1 each — those cases call
declared-but-unimplemented methods and crash at runtime (fine for the size tier, which
never executes them). **These are the *idiomatic* implementations (identical to the size
tier), not hand-tuned equivalents** — so speed reflects idiomatic implementation cost,
not pure language speed. The extreme spreads (e.g. string-processing: ObjC's `NSString`
primitives vs. others' manual string work) are real implementation differences.

| Case | N | ObjC | Swift | Kotlin | scriptc | Fastest |
|------|---|------|-------|--------|---------|---------|
| **callback** | 10 | N/A | 73.36 ms | 68.95 ms | 37.05 ms | **scriptc** |
| **collection-minimal** | 42,510 | N/A | 10.0 µs | 21.9 µs | 15.0 µs | **swift** |
| **data-classes** | 5,656 | N/A | 72.3 µs | 658.6 µs | 441.0 µs | **swift** |
| **data-classes-enhanced** | 561 | 348.7 µs | 650.6 µs | 369.3 µs | 223.8 µs | **scriptc** |
| **extension-functions** | 3,212 | N/A | N/A | 127.2 µs | 50.5 µs | **scriptc** |
| **functional-style** | 10,585 | 49.4 µs | 43.4 µs | 19.1 µs | 30.1 µs | **kotlin** |
| **generics-heavy** | 57,033 | 2.2 µs | 6.8 µs | 1.6 µs | 7.7 µs | **kotlin** |
| **inheritance-deep** | 375,645 | 1.1 µs | 1.2 µs | 389 ns | 3.5 µs | **kotlin** |
| **json-serialization** | 12 | 19.84 ms | 34.11 ms | N/A | 5.19 ms | **scriptc** |
| **many-classes** | 58,873 | 6.0 µs | 6.8 µs | 1.9 µs | 3.2 µs | **kotlin** |
| **null-safety** | 5,319 | 90.8 µs | 87.1 µs | 14.0 µs | 9.7 µs | **scriptc** |
| **protocol-oriented** | 10 | 224.70 ms | 54.07 ms | 86.86 ms | 36.11 ms | **scriptc** |
| **scope-functions** | 11,854 | 68.1 µs | 39.6 µs | 17.4 µs | 20.8 µs | **kotlin** |
| **string-processing** | 10 | 1.68 ms | 161.19 ms | 101.62 ms | 27.25 ms | **objc** |
| **variable-capture** | 23 | 125.16 ms | 21.37 ms | 33.98 ms | 15.48 ms | **scriptc** |

Geomean ns/iter **vs the fastest language in each case** (1.00 = always fastest; computed
over each language's runnable cases, so case sets differ):

| Language | Geomean vs fastest | Cases |
|----------|-------------------|-------|
| scriptc | **1.93x** | 15 |
| kotlin | 2.22x | 14 |
| objc | 3.17x | 11 |
| swift | 3.27x | 14 |

**Findings:**
- **No single winner** — the fastest language is case-dependent: Kotlin wins the light
  generic/class-heavy cases (generics-heavy, many-classes, inheritance-deep,
  scope-functions, functional-style), scriptc wins the heavy OO/data cases (callback,
  data-classes-enhanced, json-serialization, protocol-oriented, variable-capture,
  null-safety, extension-functions), Swift wins the two data-centric light cases, and
  ObjC wins string-processing by two orders of magnitude (optimized `NSString`).
- **scriptc has the best geomean (1.93x)** and is fastest or near-fastest on the heavy
  cases — the flip side of its size cost: the per-call-site specialization and generic
  monomorphization that *inflate its binary* (size tier) are exactly what make its
  **execution fast**. Size traded for speed, as its docs advertise.
- ObjC's idiomatic implementations are bimodal: sometimes dramatically fast
  (string-processing 1.7 ms) and sometimes dramatically slow (protocol-oriented 225 ms,
  variable-capture 125 ms) — a reminder these measure idiomatic code, not the language.

#### Detailed Results

The benchmark generates `results.csv` with complete metrics (sample, all four languages):
```csv
case,variant,language,success,text_size,data_size,final_size,lines_of_code
collection-minimal,-Os,objc,true,5999,3276,4854,212
collection-minimal,-Os,swift,true,9702,832,6958,168
collection-minimal,-Os,kotlin,true,8839,3080,6803,154
collection-minimal,-Os,scriptc,true,8236,1033,5972,192
json-serialization,-Os,objc,true,17281,9700,14037,376
json-serialization,-Os,swift,true,61771,12136,45667,247
json-serialization,-Os,kotlin,true,61773,22704,47782,207
json-serialization,-Os,scriptc,true,32520,3137,23391,275
async,-Os,objc,true,104617,21820,77596,2122
async,-Os,swift,true,284694,20248,203335,1452
async,-Os,kotlin,true,238147,132976,193298,1005
async,-Os,scriptc,false,0,0,0,1117
...  # full 4-language matrix (17 cases) in results.csv
```
