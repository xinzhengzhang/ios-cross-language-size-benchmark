# iOS Size Benchmark - Cross-Language Comparison

[English](README.md) | [中文](README_CN.md)

### Overview

This project provides a comprehensive benchmark for comparing binary size impact across **Kotlin Native**, **Swift**, **Objective-C**, **scriptc** (an experimental TypeScript-to-native compiler), and **Zig** implementations on iOS. It recreates exact Bazel compilation commands to measure and compare the compiled binary sizes of equivalent functionality implemented in different languages.

**Zig** (0.16.0) is the **extreme control group** for both size and speed: a systems
language with a *near-zero runtime* — manual memory, no reference counting, no GC, and no
stdlib prebuild cache. It is the floor datapoint for where a language lands once every
other runtime cost (RC/GC/metadata/dispatch) is stripped away. Toolchain:
`~/.native/toolchains/zig-0.16.0/zig` (override via `$ZIG`).

> **Design deep-dive:** [`doc/design-tradeoffs.md`](doc/design-tradeoffs.md) analyzes the
> per-language design tradeoffs from both the size and execution-speed angles — why ObjC
> stays smallest on most cases, why scriptc trades binary size for speed via inlining/
> monomorphization, and the concurrency/artifact-form assumptions behind scriptc's runtime
> (currently in Chinese).

### License and Attribution

This project is licensed under the MIT License. All test case implementations in the `case/` directory were generated using **Claude AI** (https://claude.ai) and demonstrate equivalent functionality across the five languages for educational and comparison purposes.

### Environment Requirements

#### Current Testing Environment
- **Kotlin Native**: 2.4.20
- **Swift**: Apple Swift version 6.3.3 (swiftlang-6.3.3.1.3 clang-2100.1.1.101)
- **Apple Clang**: version 21.0.0 (clang-2100.1.1.101)
- **iOS SDK**: 26.5
- **Xcode**: 26.6 (build 17F113)
- **Zig**: 0.16.0 (path `~/.native/toolchains/zig-0.16.0/zig`, override via `$ZIG`)

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

# 4. Verify Zig 0.16.0 (override path via $ZIG)
~/.native/toolchains/zig-0.16.0/zig version

# 5. Run all benchmarks
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

Our comprehensive testing with Kotlin Native 2.4.20, Swift 6.3.3, Apple Clang 21.0.0 (Xcode 26.6, iOS SDK 26.5), scriptc 0.2.7, and Zig 0.16.0 reveals significant differences in binary size across languages and use cases.

#### Summary Table

All sizes in bytes (final = TEXT×0.7 + DATA×0.2). scriptc and Zig both measure the
marginal user object `program.o` (see their tier sections); `async`/`async-enhanced` are
N/A for scriptc only (`--lib` mode requires an async-free graph, `SC4005`). Zig ports both
cases on `std.Io` (the 0.16 structured-concurrency API) over the `std.Io.Threaded`
thread-pool backend — see footnote ².

| Case | ObjC | Swift | Kotlin | scriptc | Zig | Best | Swift/ObjC | Kotlin/ObjC | scriptc/ObjC | Zig/ObjC |
|------|------|-------|--------|---------|-----|------|-----------|------------|--------------|----------|
| **async** | 77,596 | 203,335 | 193,298 | N/A¹ | 125,385² | **ObjC** | 2.62x | 2.49x | — | 1.62x |
| **async-enhanced** | 25,089 | 81,174 | 68,407 | N/A¹ | 122,659² | **ObjC** | 3.24x | 2.73x | — | 4.89x |
| **callback** | 47,163 | 58,821 | 97,688 | 98,194 | **25,235** | **Zig** | 1.25x | 2.07x | 2.08x | 0.54x |
| **collection-minimal** | 4,854 | 6,958 | 6,803 | 5,972 | 8,224 | **ObjC** | 1.43x | 1.40x | 1.23x | 1.69x |
| **data-classes** | 24,588 | 115,725 | 91,197 | 130,563 | 42,424 | **ObjC** | 4.71x | 3.71x | 5.31x | 1.73x |
| **data-classes-enhanced** | 14,061 | 111,797 | 36,078 | 34,088 | 16,074 | **ObjC** | 7.95x | 2.57x | 2.42x | 1.14x |
| **extension-functions** | 28,204 | 32,898 | 47,819 | 104,889 | 39,846 | **ObjC** | 1.17x | 1.70x | 3.72x | 1.41x |
| **functional-style** | 13,398 | 44,172 | 34,968 | 90,539 | 23,771 | **ObjC** | 3.30x | 2.61x | 6.76x | 1.77x |
| **generics-heavy** | 11,572 | 29,855 | 20,542 | 38,551 | **5,976** | **Zig** | 2.58x | 1.78x | 3.33x | 0.52x |
| **inheritance-deep** | 8,926 | 15,309 | 33,458 | 26,095 | **650**³ | **Zig**³ | 1.72x | 3.75x | 2.92x | 0.07x |
| **json-serialization** | 14,037 | 45,667 | 47,782 | 23,391 | 59,743 | **ObjC** | 3.25x | 3.40x | 1.67x | 4.26x |
| **many-classes** | 17,672 | 18,066 | 23,483 | 36,580 | **427**³ | **Zig**³ | 1.02x | 1.33x | 2.07x | 0.02x |
| **null-safety** | 23,079 | 33,955 | 26,822 | 49,211 | 33,656 | **ObjC** | 1.47x | 1.16x | 2.13x | 1.46x |
| **protocol-oriented** | 12,289 | 28,820 | 21,807 | 45,710 | 17,624 | **ObjC** | 2.35x | 1.77x | 3.72x | 1.43x |
| **scope-functions** | 29,879 | 46,200 | 56,063 | 97,107 | **22,520** | **Zig** | 1.55x | 1.88x | 3.25x | 0.75x |
| **string-processing** | 17,366 | 42,131 | 27,238 | 41,320 | 24,693 | **ObjC** | 2.43x | 1.57x | 2.38x | 1.42x |
| **variable-capture** | 8,569 | 16,392 | 13,484 | 16,275 | 9,608 | **ObjC** | 1.91x | 1.57x | 1.90x | 1.12x |

¹ async-free module graph required by scriptc `--lib` mode (`SC4005`).  ² Zig uses the
0.16 `std.Io` API (`io.async`/`Future`/`Group`) on the `std.Io.Threaded` thread-pool
backend; that runtime inlines whole into `program.o` (no shared floor), making these the
two largest Zig cases — the ~297 KB DATA is the thread-pool runtime, not the workload.
³ `inheritance-deep` and `many-classes` are comptime constant-folded away under
ReleaseSmall — see the honesty caveat below; these are not real dispatch costs.

#### Key Findings

**🏆 Objective-C produces the smallest binaries on most cases, but no longer universally.**
ObjC wins **12 of the 17 cases** (every row except Zig's 5 wins), making it the default
pick for size-critical work — including both `async` cases, where Zig's `std.Io.Threaded`
runtime makes it the largest (1.62x / 4.89x ObjC). **Zig wins 5** — callback (0.54x),
generics-heavy (0.52x), scope-functions (0.75x), and the two comptime-folded cases
inheritance-deep (0.07x) and many-classes (0.02x). On data/json/string/async-heavy cases
Zig lands mid-pack to large (json-serialization 4.26x ObjC — `std.json` is pulled in
whole) because the real work can't be folded and Zig has no shared stdlib to offload to.

> **⚠️ Honesty caveat — comptime constant-folding.** Zig's `inheritance-deep` (650 B) and
> `many-classes` (427 B) are near-empty objects, **not** evidence that Zig does
> polymorphism 40x smaller. The idiomatic Zig here is an `enum` + `switch` whose branches
> return constants over comptime-known inputs, which ReleaseSmall **constant-folds away
> entirely**. The other languages retain runtime dispatch and type metadata and cannot
> fold. Read these two rows as "the optimizer erased a comptime-knowable workload," not as
> steady-state dispatch cost. (The sub-40 ns speed numbers for the same two cases confirm
> it — see the speed tier.)

**📊 Language Performance Patterns:**
- **Swift penalty ranges from 1.02x to 7.95x** larger than Objective-C
- **Kotlin penalty ranges from 1.16x to 3.75x** larger than Objective-C  
- **Zig vs ObjC ranges from 0.02x (folded) to 4.26x** — smaller than ObjC on its 5 wins,
  larger on data/json/string-heavy cases with no shared stdlib floor to offload to
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

### Zig (systems language) tier

A fifth implementation, `case/*/lib.zig`, is compiled with **Zig 0.16.0** (`compile_zig.sh`,
path `~/.native/toolchains/zig-0.16.0/zig`, override via `$ZIG`) as the **extreme control
group**: a systems language with manual memory, no reference counting, no GC, and no
stdlib prebuild cache.

**What is measured.** `zig build-obj lib.zig -target aarch64-ios -O ReleaseSmall` emits
**one relocatable `program.o`**. Unlike scriptc there is **no separate shared runtime
floor** — Zig has no RC/GC/stdlib cache, so everything the case uses (allocator shims,
panic handler, monomorphized generics/containers) is inlined into that single object. The
whole object *is* the user-marginal cost: the honest floor of a near-zero-runtime systems
language. DCE root: `export fn bench_run() void { runBenchmark(); }`.

**Idiomatic, not 1:1.** Polymorphism uses tagged unions + `switch`, generics use comptime
`fn(comptime T: type) type`, and lambdas use explicit closure-structs or `*const fn`
pointers (Zig has no closures). These are genuine structural differences, documented, not
hand-tuned equivalents.

**async is built, and it's expensive.** Both `async`/`async-enhanced` port onto the 0.16
`std.Io` API (`io.async` → `Future`, `std.Io.Group` for structured fan-out) running on the
portable `std.Io.Threaded` thread-pool backend. Unlike the other languages there is no
shared concurrency runtime to amortize: the whole thread pool inlines into `program.o`
(~297 KB DATA each), so these are the **two largest Zig cases** (125,385 / 122,659) rather
than N/A. scriptc still can't build them (`SC4005`).

> **⚠️ Honesty caveat (size).** `inheritance-deep` (650 B) and `many-classes` (427 B) are
> near-empty because their idiomatic Zig — an `enum`/`switch` returning constants over
> comptime-known inputs — is **constant-folded away under ReleaseSmall**. These reflect the
> optimizer erasing a comptime-knowable workload, not steady-state dispatch cost. Do not
> read Zig as "40x smaller at polymorphism."

**Extreme-control-group framing (vs scriptc).** Both scriptc and Zig inline/monomorphize
into the user object and have small-to-no runtime, but Zig goes further — manual memory, no
RC at all, no GC. Zig is therefore the floor datapoint: where a near-zero-runtime systems
language lands once every other language's runtime cost is stripped away. The gap between
Zig and the rest *is* the runtime tax (RC/GC/metadata/dispatch) the others pay.

**Commands.** `./compile_zig.sh <case>` builds the iOS size tier (prints `TEXT DATA`); Zig
participates in `./benchmark_speed.sh` automatically.

Zig's per-case numbers and `Zig/ObjC` ratios are in the Summary Table above.

## Execution speed (macOS)

Size is only half the story. `./benchmark_speed.sh` measures how fast each language runs
the **same per-case `runBenchmark` workload** as a native **macOS** executable (a
companion to the iOS size tier). `results_speed.csv` holds the raw numbers.

**Methodology** (see `benchmark_speed.sh` header for details):
- Native macOS host executables, **-Os parity** with the size tier: `clang -Os`,
  `swiftc -Osize`, `konanc -opt`, scriptc default/release, Zig `-O ReleaseSmall` — *not* a
  speed-tuned build.
- The driver constructs a **fresh `IosSizeBenchmark` per iteration** (stateless unit;
  matches scriptc's free-function `runBenchmark`). Per-iter time =
  `(minWall(N) − minWall(0)) / N` — the 0-iteration run isolates process startup, which
  is subtracted so per-language launch cost doesn't bias the result. Each measurement
  does a warmup run, then takes the min of 5 samples. Zig uses the **same
  baseline-subtraction**: with no `argv` API in 0.16, the iteration count is **baked in**
  at build time (built at 0 and N), per-iter = `(wall(N) − wall(0)) / N`, exactly like
  scriptc.
- `N` is calibrated per case (same `N` across languages) to a ~0.5 s base run. Heavy
  cases (ms-scale per call) land at small `N`; light cases at large `N` (shown below).

**Coverage caveats:** `async`/`async-enhanced` are excluded (their drivers sleep).
ObjC is N/A for 4 cases and Swift for 1 (extension-functions) — those cases call
declared-but-unimplemented methods and crash at runtime (fine for the size tier, which
never executes them). The Kotlin `json-serialization` build links the
kotlinx-serialization compiler plugin plus the macOS `serialization-core`/`-json` klibs
(fetched once to `~/.cache`), so it is measured, not N/A. **These are the *idiomatic*
implementations (identical to the size tier), not hand-tuned equivalents** — so speed
reflects idiomatic implementation cost, not pure language speed. The extreme spreads
(e.g. string-processing: ObjC's `NSString` primitives vs. others' manual string work)
are real implementation differences. Zig participates with its baked-iteration driver
(see methodology); `async`/`async-enhanced` are excluded here for every language (their
drivers sleep), even though Zig *can* build them for the size tier.

| Case | N | ObjC | Swift | Kotlin | scriptc | Zig | Fastest |
|------|---|------|-------|--------|---------|-----|---------|
| **callback** | 10 | N/A | 104.76 ms | 108.55 ms | 71.06 ms | 38.41 ms | **Zig** |
| **collection-minimal** | 32,627 | N/A | 15.0 µs | 30.0 µs | 18.6 µs | 10.8 µs | **Zig** |
| **data-classes** | 4,253 | N/A | 130.1 µs | 949.3 µs | 581.7 µs | 344.0 µs | **Swift** |
| **data-classes-enhanced** | 557 | 442.7 µs | 856.5 µs | 488.0 µs | 296.1 µs | 149.4 µs | **Zig** |
| **extension-functions** | 947 | N/A | N/A | 260.6 µs | 89.9 µs | 27.5 µs | **Zig** |
| **functional-style** | 5,915 | 53.8 µs | 47.5 µs | 19.9 µs | 33.0 µs | 8.1 µs | **Zig** |
| **generics-heavy** | 39,412 | 2.4 µs | 10.0 µs | 2.0 µs | 8.2 µs | 1.77 µs | **Zig** |
| **inheritance-deep** | 213,151 | 1.2 µs | 1.4 µs | 436 ns | 3.4 µs | 34.8 ns³ | **Zig**³ |
| **json-serialization** | 14 | 22.01 ms | 47.07 ms | 23.33 ms | 5.22 ms | 6.66 ms | **scriptc** |
| **many-classes** | 58,054 | 6.9 µs | 8.1 µs | 2.3 µs | 3.7 µs | 39.9 ns³ | **Zig**³ |
| **null-safety** | 4,809 | 98.8 µs | 83.8 µs | 13.5 µs | 10.0 µs | 3.2 µs | **Zig** |
| **protocol-oriented** | 10 | 249.30 ms | 53.78 ms | 112.05 ms | 33.42 ms | 51.40 ms | **scriptc** |
| **scope-functions** | 7,015 | 77.9 µs | 40.2 µs | 17.2 µs | 23.6 µs | 12.3 µs | **Zig** |
| **string-processing** | 10 | 1.95 ms | 161.71 ms | 108.64 ms | 28.71 ms | 12.60 ms | **ObjC** |
| **variable-capture** | 15 | 130.06 ms | 24.36 ms | 34.23 ms | 17.51 ms | 1.42 ms | **Zig** |

³ `inheritance-deep` (34.8 ns) and `many-classes` (39.9 ns) are comptime constant-folded —
empty-loop territory, not real dispatch cost. See the honesty caveat below.

Geomean ns/iter **vs the fastest language in each case** (1.00 = always fastest; computed
over each language's runnable cases, so case sets differ):

| Language | Geomean vs fastest | Cases |
|----------|-------------------|-------|
| zig | **1.26x** | 15 |
| scriptc | 4.81x | 15 |
| kotlin | 5.96x | 15 |
| swift | 8.51x | 14 |
| objc | 9.94x | 11 |

**Findings:**
- **Zig is the overall speed leader** — geomean **1.26x** vs the fastest-in-case, fastest
  on **11 of 15** cases. Its comptime monomorphization plus manual memory (no RC/GC) strip
  the runtime tax the others pay; the gap between Zig and the rest *is* that tax. It loses
  four: data-classes (to Swift), string-processing (to ObjC), and json-serialization +
  protocol-oriented (both to scriptc, whose per-call-site specialization edges Zig on those
  two heavy indirect-dispatch cases).
- **scriptc's old crown is superseded.** The previous run called scriptc fastest at 1.93x;
  with Zig taking most cases, scriptc now sits at **4.81x** geomean, still fastest on the
  two heavy indirect-dispatch cases above. Its per-call-site specialization and generic
  monomorphization — the same mechanisms that *inflate its binary* (size tier) — are what
  keep its execution fast.

  > **⚠️ Honesty caveat (speed).** Zig's `inheritance-deep` (34.8 ns) and `many-classes`
  > (39.9 ns) sit in empty-loop territory because the comptime-knowable `enum`/`switch`
  > workload is **constant-folded away under ReleaseSmall** — the same erasure that makes
  > these two size rows near-empty (650 B / 427 B). These are *not* steady-state dispatch
  > numbers; the other languages retain runtime dispatch and cannot fold. Do not read Zig
  > as doing polymorphism 40x faster.
- **Size↔speed is one coin.** Zig reinforces the thesis: comptime monomorphization + manual
  memory make it broadly fastest *and* small, and where that same comptime evaluation can
  see the whole workload (inheritance-deep, many-classes) it erases the code entirely —
  tiny size and empty runtime, same mechanism on both axes.
- ObjC's idiomatic implementations are bimodal: sometimes dramatically fast
  (string-processing 1.95 ms) and sometimes dramatically slow (protocol-oriented 249 ms,
  variable-capture 130 ms) — a reminder these measure idiomatic code, not the language.

#### Detailed Results

The benchmark generates `results.csv` with complete metrics (sample, all five languages):
```csv
case,variant,language,success,text_size,data_size,final_size,lines_of_code
collection-minimal,-Os,objc,true,5999,3276,4854,212
collection-minimal,-Os,swift,true,9702,832,6958,168
collection-minimal,-Os,kotlin,true,8839,3080,6803,154
collection-minimal,-Os,scriptc,true,8236,1033,5972,192
collection-minimal,-Os,zig,true,11705,152,8224,149
json-serialization,-Os,objc,true,17281,9700,14037,376
json-serialization,-Os,swift,true,61771,12136,45667,247
json-serialization,-Os,kotlin,true,61773,22704,47782,207
json-serialization,-Os,scriptc,true,32520,3137,23391,275
async,-Os,objc,true,104617,21820,77596,2122
async,-Os,swift,true,284694,20248,203335,1452
async,-Os,kotlin,true,238147,132976,193298,1005
async,-Os,scriptc,false,0,0,0,1117
...  # full 5-language matrix (17 cases) in results.csv
```
