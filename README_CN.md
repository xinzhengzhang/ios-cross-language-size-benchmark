# iOS 大小基准测试 - 跨语言比较

## 项目概述

本项目提供了一个全面的基准测试，用于比较 **Kotlin Native**、**Swift**、**Objective-C**、**scriptc**（实验性 TypeScript→原生编译器）和 **Zig** 在 iOS 平台上的二进制大小影响。通过精确重现 Bazel 编译命令，测量和比较不同语言实现的等效功能的编译后二进制大小。

**Zig 0.16.0** 作为第 5 种语言加入，定位为性能与体积的「极致对照组」——一门近乎零运行时的系统语言：手动内存管理、无引用计数、无 GC、无 stdlib 预构建缓存。工具链路径 `~/.native/toolchains/zig-0.16.0/zig`（可用 `$ZIG` 覆盖）。它把其他语言运行时都要付出的代价剥到最底，是衡量「当运行时成本几乎归零时能落到哪里」的地板数据点。

> **设计深读：** [`doc/design-tradeoffs.md`](doc/design-tradeoffs.md) 从体积与执行速度两个
> 维度分析各语言的设计取舍——为什么 ObjC 在多数（而非全部）用例上体积最小、scriptc 与 Zig
> 如何用内联/单态化以体积换速度，以及 Zig 作为近乎零运行时系统语言的「极致对照组」定位。

## 许可证与声明

本项目采用 MIT 许可证发布。`case/` 目录中的所有测试用例实现均由 **Claude AI** (https://claude.ai) 生成，用于展示多种语言的等效功能实现，仅供教育和比较用途。

## 环境要求

### 当前测试环境
- **Kotlin Native**: 2.4.20
- **Swift**: Apple Swift version 6.3.3 (swiftlang-6.3.3.1.3 clang-2100.1.1.101)
- **Apple Clang**: version 21.0.0 (clang-2100.1.1.101)
- **Zig**: 0.16.0，路径 `~/.native/toolchains/zig-0.16.0/zig`（可用 `$ZIG` 覆盖）
- **iOS SDK**: 26.5
- **Xcode**: 26.6（build 17F113）

> **Kotlin 缓存模型说明：** Kotlin Native 2.4.20 移除了原管道逐字复现的「手动逐库
> `-Xadd-cache` 预构建」协议。`compile_kotlin.sh` 现改用 konanc 的 auto-cache 基于
> 2.4.20 发行版构建用户库的 static cache——测量的仍是同一产物
> （`libexamples_…library-cache.a`，用 `xcrun size` 测量），仅依赖缓存机制不同。
> 一个副作用：2.4.20 的 auto-cache 要求所有依赖都被缓存，因此 `json-serialization`
> 现在把用户实例化的序列化器也计入了被测对象（2.2 下这些是外部引用、不计入），
> 这就是其 Kotlin 数字上升的原因。

### 环境配置
```bash
# 1. 安装 Kotlin Native (2.4.20)
export KOTLIN_NATIVE_DIST=/path/to/kotlin-native-prebuilt-macos-aarch64-2.4.20

# 2. 验证 Swift/Xcode 安装
xcrun swift --version
xcrun --sdk iphoneos --show-sdk-version

# 3. 验证 bc 计算器
which bc

# 4. 验证 Zig 0.16.0（路径可用 $ZIG 覆盖）
~/.native/toolchains/zig-0.16.0/zig version

# 5. 运行所有基准测试
./benchmark_all_cases.sh

# 单独构建某个用例的 Zig iOS 体积档（打印 TEXT DATA）
./compile_zig.sh <case>
```

> **Zig 说明：** Zig 0.16.0 默认路径 `~/.native/toolchains/zig-0.16.0/zig`，可用 `$ZIG`
> 覆盖。`./compile_zig.sh <case>` 产出 iOS 体积档并打印 `TEXT DATA`；Zig 已自动参与
> `./benchmark_speed.sh` 的速度档。

## 测试用例详解

我们的基准测试包含 **16 个综合测试用例**，旨在评估不同语言特性及其对二进制大小的影响：

### 数据建模与结构

#### `data-classes` - 基础数据结构比较
- **Kotlin**: `data class` 自动生成方法
  - 自动生成 `equals()`、`hashCode()`、`toString()`、`copy()` 方法
  - 简洁的语法，零样板代码
- **Swift**: 手动 struct 实现，包含计算属性
  - 手动实现所有 Kotlin 自动生成的功能
  - 使用计算属性和自定义初始化器
- **Objective-C**: 完整的手动样板代码，包含属性和方法
  - 大量手动样板代码实现所有功能
  - 传统的属性声明和方法实现

#### `data-classes-enhanced` - 复杂嵌套结构与泛型
- **Kotlin**: 密封类、嵌套数据类、泛型约束
  - 密封类层次结构，泛型数据类型
  - 复杂的嵌套结构和类型约束
- **Swift**: 枚举关联值、嵌套类型、Copy-on-Write 优化
  - 枚举关联值模拟密封类功能
  - 手动 Copy-on-Write 优化实现
- **Objective-C**: 手动层次结构模拟，大量样板代码
  - 完整手动实现所有高级特性
  - 大量类和协议定义

#### `many-classes` - 多类定义影响
- 测试随着类型定义数量增加的代码大小扩展性
- 评估各语言的单类开销
- 分析类型系统对二进制大小的影响

### 异步编程

#### `async` - 基础异步模式
- **Kotlin**: 协程与挂起函数
  - `suspend` 函数和 `coroutineScope`
  - 结构化并发模式
- **Swift**: async/await 与 Task API
  - 原生 async/await 语法
  - Task 和 TaskGroup 并发控制
- **Objective-C**: GCD 与完成回调
  - Grand Central Dispatch 模式
  - 传统的 completion block 回调

#### `async-enhanced` - 高级并发特性
- **Kotlin**: 结构化并发、通道、流
  - Channel 和 Flow 响应式编程
  - 复杂的并发控制和错误处理
- **Swift**: Actor 模型、TaskGroup、并发集合
  - Actor 隔离和数据竞争保护
  - 并发集合和异步序列
- **Objective-C**: 复杂 GCD 模式与同步
  - 高级 GCD 队列管理
  - 手动同步和线程安全实现

### 语言特定特性

#### `generics-heavy` - 泛型类型系统影响
- 测试模板/泛型实例化开销
- 比较类型擦除 vs. 特化实现
- 评估泛型约束和类型推断的成本

#### `inheritance-deep` - 类层次 vs. 组合
- **Kotlin**: 深度继承链与重写
  - 多层类继承结构
  - 方法重写和多态调用
- **Swift**: 协议组合与类继承
  - 协议组合模式
  - 类继承和协议一致性
- **Objective-C**: 传统 OOP 层次模式
  - 经典的类层次结构
  - 传统的面向对象编程模式

#### `protocol-oriented` - 协议导向编程
- **Kotlin**: 接口委托与实现
  - 接口默认实现和委托
  - 多接口实现模式
- **Swift**: 协议扩展与默认实现
  - 协议扩展的默认实现
  - 协议组合和条件一致性
- **Objective-C**: 协议采用与手动实现
  - 传统协议采用模式
  - 手动实现所有协议方法

### 函数式编程

#### `functional-style` - 高阶函数与不可变性
- 测试函数式编程范式对大小的影响
- 比较 map/filter/reduce 实现
- 评估高阶函数和闭包的开销

#### `extension-functions` - 扩展方法与工具
- **Kotlin**: 扩展函数与属性
  - 为现有类型添加新功能
  - 扩展属性和函数的实现
- **Swift**: 扩展计算属性与方法
  - Extension 添加新功能
  - 计算属性和方法扩展
- **Objective-C**: 基于分类的扩展
  - Category 机制扩展类功能
  - 传统的分类实现模式

#### `scope-functions` - 作用域与上下文操作
- **Kotlin**: `let`、`run`、`apply`、`also`、`with` 函数
  - 作用域函数的不同用途
  - 上下文切换和对象配置
- **Swift**: 手动作用域模式
  - 手动实现作用域控制
  - 闭包模拟作用域函数
- **Objective-C**: 基于块的作用域模拟
  - Block 实现作用域控制
  - 手动的上下文管理

### 高级特性

#### `null-safety` - 空值处理模式
- **Kotlin**: 内置空安全 `?` 和 `!!`
  - 编译时空安全检查
  - 安全调用和强制解包
- **Swift**: 可选类型 `?` 和 `!`
  - Optional 类型系统
  - 可选绑定和强制解包
- **Objective-C**: 手动空性注解与检查
  - 手动 nullability 注解
  - 运行时空指针检查

#### `json-serialization` - 数据序列化影响
- 测试序列化框架开销
- 比较自动 vs. 手动序列化
- 评估不同序列化策略的成本

#### `string-processing` - 字符串操作
- 测试字符串处理算法与工具
- 比较字符串插值与格式化方法
- 评估字符串操作的性能影响

#### `variable-capture` - 闭包与捕获模式
- 测试闭包/lambda 中变量捕获开销
- 分析内存管理影响
- 比较不同捕获策略的成本

### 优化导向用例

#### `collection-minimal` - 大小优化实现
- 最小化集合操作，避免复杂抽象
- 专注于实现最小可能的二进制大小
- 优化比较的基准线
- 避免高阶函数和复杂数据结构

#### `callback` - 回调模式实现
- 测试不同回调/委托模式方法
- 比较函数式 vs. 面向对象回调风格
- 评估回调机制的开销

## 核心特性

### 精确 Bazel 重现
- 保留相同的编译器标志和环境变量
- 使用完全相同的工具包装器和参数文件处理
- 维护相同的 `bazel-out/` 目录结构

### 全面指标
- **TEXT 段**: 可执行代码大小（权重：0.7）
- **DATA 段**: 初始化数据大小（权重：0.2）
- **最终大小**: 加权组合，反映真实二进制影响
- **代码行数**: 开发成本参考

### Swift 编译特性
所有 Swift 类型必须标记为 `public` 以防止死代码消除：
```swift
public struct Example {
    public let property: String    // 必须是 public
    public var computed: String { get { ... } }
    public func method() { ... }
}
```

**原因**: Swift 的优化器（opt）会对模块内未使用的 `internal` 类型/成员进行死代码消除，这会影响大小比较的准确性。

## 基准测试结果

使用 Kotlin Native 2.4.20、Swift 6.3.3、Apple Clang 21.0.0 和 Zig 0.16.0（Xcode 26.6，iOS SDK 26.5）进行的全面测试显示，不同语言和使用场景下的二进制大小存在显著差异。

### 结果汇总表

所有数字单位为字节（final = TEXT×0.7 + DATA×0.2）。scriptc 测的是边际用户对象
`program.o`（见下方 scriptc 档说明）；Zig 测的是单个可重定位 `program.o`（见下方 Zig 档
说明）。`async`/`async-enhanced` 对 scriptc 为 N/A（`SC4005`），对 Zig 为 N/A（Zig 0.16
无稳定 async/await）。

| 测试用例 | ObjC | Swift | Kotlin | scriptc | Zig | 最优 | Swift/ObjC | Kotlin/ObjC | scriptc/ObjC | Zig/ObjC |
|------|------|-------|--------|---------|-----|------|-----------|------------|--------------|----------|
| **async** | 77,596 | 203,335 | 193,298 | N/A¹ | N/A² | **ObjC** | 2.62x | 2.49x | — | — |
| **async-enhanced** | 25,089 | 81,174 | 68,407 | N/A¹ | N/A² | **ObjC** | 3.24x | 2.73x | — | — |
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

¹ scriptc `--lib` 模式要求 async-free 模块图（`SC4005`）。
² Zig 0.16 无稳定 async/await。
³ comptime 常量折叠——`inheritance-deep`（650 B）和 `many-classes`（427 B）之所以近乎为空，
是因为惯用 Zig 实现（enum + `switch`，分支返回常量，输入在 comptime 已知）在 ReleaseSmall
下被整段常量折叠消除。这些数字反映的是优化器抹掉了一个 comptime 可知的工作负载，**不是稳态
分派成本**；其他语言保留运行时分派/元数据，无法折叠。切勿解读为「Zig 的多态快/小 40 倍」。

### 关键发现

**🏆 ObjC 不再普遍最小。** 在 15 个可运行用例里 ObjC 仍赢下 10 个，但 **Zig 赢了 5 个**
（callback、generics-heavy、inheritance-deep、many-classes、scope-functions）。在数据类/
JSON/字符串这类重用例上，Zig 落在中游到偏大（`json-serialization` 达 ObjC 的 4.26x——
`std.json` 被整体拉进来），因为真实工作无法被折叠，而它又没有共享 stdlib 可以外部化。

> **诚实提醒（务必注意）：** Zig 在 `inheritance-deep`（650 B）和 `many-classes`（427 B）上
> 的极小数字是 **comptime 常量折叠**的产物，不是「多态小 40 倍」。惯用 Zig 用 enum + `switch`
> 且分支在 comptime 已知，ReleaseSmall 下被整段消除。请始终连同此前提一起解读这两个数字。

**📊 语言性能模式：**
- **Swift 开销范围从 1.06x 到 8.88x** 大于 Objective-C
- **Kotlin 开销范围从 1.16x 到 3.78x** 大于 Objective-C  
- **Swift 最差用例**: data-classes-enhanced (8.88x), data-classes (5.38x)
- **Swift 最佳用例**: many-classes (1.06x), extension-functions (1.24x)
- **Zig 作为极致对照组**：剥掉引用计数/GC/元数据后，近乎零运行时的系统语言落在哪里——在
  真实工作无法折叠的重用例上它并不占优（json 4.26x ObjC），这反过来说明它赢下的那些用例靠
  的是 comptime 单态化与无共享运行时底座，而非魔法。

**⚡ 开发效率与大小权衡：**

1. **数据结构特性** (data-classes, data-classes-enhanced):
   - Kotlin 的自动生成和 Swift 的手动实现都带来显著开销
   - Swift 的广泛运行时元数据（如 `Codable`）创建最大的二进制文件
   - Objective-C 的手动方法虽然冗长，但产生最小的运行时开销

2. **语言便利特性** (async, functional-style, scope-functions):
   - 现代语言特性（async/await、函数式编程）增加了大量二进制大小
   - Swift 的高级类型系统和运行时特性创建显著开销
   - Kotlin 的协程比 Swift 的并发更高效，但仍比 GCD 成本更高

3. **简单操作** (collection-minimal, variable-capture):
   - 避免复杂语言特性时，大小差异最小化
   - 所有语言在基本操作上都可以高效

### 大小分析方法

结果使用加权公式：**最终大小 = TEXT × 0.7 + DATA × 0.2**
- **TEXT 段**: 可执行代码（主要因素）
- **DATA 段**: 初始化数据（次要因素）
- **代码行数**: 开发成本参考

### scriptc（TypeScript → 原生）档

第四种实现 `case/*/lib.ts` 由 **scriptc 0.2.7**（实验性的 TypeScript-to-native 编译器）
编译，用 `./compile_scriptc.sh` 测量。

**测量的是什么。** scriptc 构建一个 iOS arm64 静态库，其归档里恰好有一个*用户*对象
（`program.o`）加上编译器的运行时对象（`scr_*.o`）。我们**只测 `program.o`**——用户的
边际代码——因为它是与 Kotlin Native 数字对等的口径（Kotlin 的 stdlib 住在单独的、不计入
的预构建缓存里）。scriptc 的运行时对象是共享的固定地板（约 616 KB TEXT / 约 80 KB
DATA，单独报告），不计入用例。

**async 为 N/A。** scriptc 的 `--lib` 模式要求模块图 async-free，因此 `async` 和
`async-enhanced` 无法构建此档（编译错误 `SC4005`）。

**入口约定。** 每个 `lib.ts` 导出一个顶层 `runBenchmark(): void`，传递性地使用每个
类型——相当于 Swift `public` 要求的 scriptc 版本，防止死代码消除。

scriptc 各用例的数字和 `scriptc/ObjC` 倍率见上方结果汇总表。

**为什么差异这么大（相对 Kotlin 0.49x–2.59x，几何平均 ~1.35x）。** scriptc 在
`program.o` 里几乎没有共享 stdlib 地板：不像 Kotlin Native 把 `map`/`filter`/泛型路由到
共享的、不计入的 stdlib，scriptc **按调用点特化、把泛型单态化内联**进用户对象（类似 C++
模板）。所以 lambda/集合/泛型密集的用例膨胀（`functional-style` 2.59x、
`extension-functions` 2.19x），而数据类和深继承用例——Kotlin 自己合成的成员和类型信息被
计入——反而更小（`json-serialization` 0.49x、`inheritance-deep` 0.78x、
`collection-minimal` 0.88x）。它用体积换速度和自包含产物；见下方 macOS 执行速度档。

### Zig（系统语言 · 极致对照组）档

第五种实现 `case/*/lib.zig` 由 **Zig 0.16.0** 编译，用 `./compile_zig.sh <case>` 测量。

**测量的是什么。** `zig build-obj lib.zig -target aarch64-ios -O ReleaseSmall` 产出**一个**
可重定位的 `program.o`。与 scriptc 不同，Zig **没有单独的共享运行时底座**：它没有 RC/GC/
stdlib 缓存，所以用例用到的一切——分配器垫片、panic 处理、单态化后的泛型/容器——都内联进
这一个对象里，整个对象*就是*用户的边际成本。这是「系统语言、近乎零运行时」的诚实地板。
DCE 根：`export fn bench_run() void { runBenchmark(); }`。

**速度：迭代次数烘焙进去。** 速度档为原生 macOS 可执行文件，迭代次数**烘焙进二进制**
（Zig 0.16 没有 `argv` API）——在 0 和 N 两处各构建一次，每次迭代 =
`(wall(N) − wall(0))/N`，与 scriptc 的基线相减法完全一致。通过 `-O ReleaseSmall` 实现
与 size 档的 -Os 对齐。

**惯用，而非 1:1。** 多态用 tagged union / `switch`，泛型用 comptime
`fn(comptime T: type) type`，lambda 用显式 closure-struct 或 `*const fn` 指针（Zig 没有
闭包）。这些是真实的结构差异，都已记录。

**async / async-enhanced 为 N/A。** Zig 0.16 没有稳定的 async/await（与 scriptc 平行）。

> **诚实提醒（体积与速度处均需注意）：** `inheritance-deep`（650 B，34.8 ns）和
> `many-classes`（427 B，39.9 ns）之所以近乎为空，是因为惯用 Zig——enum + `switch` 且分支
> 返回常量、输入在 comptime 已知——在 ReleaseSmall 下被**整段常量折叠消除**。亚 40 ns 的
> 计时（空循环量级）即是佐证。这些数字反映优化器抹掉了一个 comptime 可知的工作负载，**不是
> 稳态分派成本**；其他语言保留运行时分派/元数据，无法折叠。切勿解读为「Zig 的多态快/小 40
> 倍」。

**极致对照组框架（相对 scriptc）。** 两者都把代码内联/单态化进用户对象、都几乎没有运行时，
但 Zig 走得更远——**手动内存、完全无 RC、无 GC**。所以 Zig 是地板数据点：Zig 与其余语言之间
的差距，*正是*其他语言付出的运行时税（RC/GC/元数据/分派）。这同一套 comptime 单态化 + 手动
内存既让它普遍最快，也在它能看见整个工作负载时（inheritance-deep、many-classes）把代码整段
抹掉（极小体积 + 空运行时）——同一机制，两个维度。

## 执行速度（macOS）

体积只是一半。`./benchmark_speed.sh` 测量每种语言（含 Zig）把**同一个 `runBenchmark`
工作负载**作为原生 **macOS** 可执行文件运行的速度（size 档的姊妹篇）。原始数字在
`results_speed.csv`。本次为全部 5 种语言的一次全新重跑，所有绝对数值都已更新。

**方法**（细节见 `benchmark_speed.sh` 头部）：
- 原生 macOS 可执行文件，与 size 档 **-Os 对齐**：`clang -Os`、`swiftc -Osize`、
  `konanc -opt`、scriptc 默认/release——不是为速度调优的构建。
- 驱动每次迭代**构造一个全新的 `IosSizeBenchmark`**（无状态单元；与 scriptc 的自由函数
  `runBenchmark` 一致）。每次迭代耗时 = `(minWall(N) − minWall(0)) / N`——0 次迭代的运行
  隔离出进程启动开销并被减掉，使各语言的启动成本不产生偏差。每次测量先做一次 warmup，
  再取 5 个样本的最小值。
- `N` 按用例标定（各语言同一个 `N`），使 N 次运行约 0.5 秒。重的用例（每次调用毫秒级）
  落在小 `N`，轻的用例在大 `N`（见下表）。

**覆盖说明：** `async`/`async-enhanced` 被排除（其驱动会 sleep；Zig 0.16 也无稳定
async/await）。ObjC 有 4 个用例、Swift 有 1 个用例（extension-functions）为 N/A——这些用例
调用了声明但未实现的方法，运行时崩溃（对 size 档无妨，它从不执行）。Kotlin 的 `json-serialization` 构建会链接
kotlinx-serialization 编译器插件以及 macOS 版的 `serialization-core`/`-json` klib（首次运行
拉取到 `~/.cache`），因此被正常测量、不再是 N/A。**这些是各语言的*惯用*实现（与 size 档完全
相同），不是手工对齐的等价实现**——所以速度反映的是惯用实现的成本，而非纯语言速度。极端的
差距（如 string-processing：ObjC 的 `NSString` 原语 vs 其他语言的手写字符串处理）是真实的
实现差异。

| 用例 | N | ObjC | Swift | Kotlin | scriptc | Zig | 最快 |
|------|---|------|-------|--------|---------|-----|------|
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

³ comptime 常量折叠——`inheritance-deep`（34.8 ns）和 `many-classes`（39.9 ns）落在空循环
量级，是优化器抹掉 comptime 可知工作负载的结果，**不是稳态分派成本**（见上方诚实提醒）。

相对**每个用例中最快语言**的几何平均（1.00 = 总是最快；按各语言可运行的用例计算，用例集不同）：

| 语言 | 相对最快几何平均 | 用例数 |
|------|-----------------|--------|
| zig | **1.26x** | 15 |
| scriptc | 4.81x | 15 |
| kotlin | 5.96x | 15 |
| swift | 8.51x | 14 |
| objc | 9.94x | 11 |

**发现：**
- **Zig 是新的整体速度冠军（几何平均 1.26x，15 个用例中 11 个最快）。** 它只输 4 个：
  `data-classes`（输给 Swift）、`string-processing`（输给 ObjC），以及 `json-serialization`
  和 `protocol-oriented`（都输给 scriptc——这两个重间接分派用例上，scriptc 的按调用点特化
  仍略胜 Zig 一筹）。此前「scriptc 最快（1.93x）」的说法已被取代；scriptc 现在是 4.81x，
  因为 Zig 在大多数用例上夺冠。
- **为什么是 Zig：** comptime 单态化 + 手动内存让它广泛领先——Zig 与其余语言之间的差距，
  *正是*其他语言付出的运行时税（RC/GC/元数据/分派）。这与它在体积上的表现是同一枚硬币的两面。
- > **诚实提醒：** `inheritance-deep`（34.8 ns）和 `many-classes`（39.9 ns）落在空循环量级，
  > 是 comptime 常量折叠抹掉了一个 comptime 可知的工作负载，**不是稳态分派成本**。切勿解读为
  > 「Zig 的多态快 40 倍」；其他语言保留运行时分派、无法折叠。
- **其余语言：** Kotlin（5.96x）仍在轻量泛型/类密集用例上接近 Zig；scriptc 保住两个重用例
  的头名；Swift 赢在 `data-classes`；ObjC 在 string-processing 上快两个数量级（优化的
  `NSString`），其惯用实现仍呈两极——时而极快时而极慢（protocol-oriented 249 ms、
  variable-capture 130 ms）——再次提醒这测的是惯用代码，而非语言本身。

### 详细结果

基准测试生成包含完整指标的 `results.csv`（样例，五种语言）：
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
...  # 完整五语言矩阵（17 个用例）见 results.csv
```

### 指标说明
- **case**: 测试用例名称
- **variant**: 变体（通常为 base）
- **language**: 编程语言（kotlin/swift/objc/scriptc/zig）
- **success**: 编译是否成功
- **text_size**: TEXT 段大小（可执行代码）
- **data_size**: DATA 段大小（初始化数据）
- **final_size**: 最终加权大小 (TEXT×0.7 + DATA×0.2)
- **lines_of_code**: 代码行数
