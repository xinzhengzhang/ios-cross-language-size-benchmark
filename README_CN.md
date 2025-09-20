# iOS 大小基准测试 - 跨语言比较

## 项目概述

本项目提供了一个全面的基准测试，用于比较 **Kotlin Native**、**Swift** 和 **Objective-C** 在 iOS 平台上的二进制大小影响。通过精确重现 Bazel 编译命令，测量和比较不同语言实现的等效功能的编译后二进制大小。

## 许可证与声明

本项目采用 MIT 许可证发布。`case/` 目录中的所有测试用例实现均由 **Claude AI** (https://claude.ai) 生成，用于展示三种语言的等效功能实现，仅供教育和比较用途。

## 环境要求

### 当前测试环境
- **Kotlin Native**: 2.2.20（最低要求版本）
- **Swift**: Apple Swift version 6.1.2 (swiftlang-6.1.2.1.2 clang-1700.0.13.5)
- **swift-driver**: version 1.120.5  
- **Apple Clang**: version 17.0.0 (clang-1700.0.13.5)
- **iOS SDK**: 15.0+（使用 iOS 18.5 测试）
- **Xcode**: 16.4.0.16F6

### 环境配置
```bash
# 1. 安装 Kotlin Native (2.2.20+)
export KOTLIN_NATIVE_DIST=/path/to/kotlin-native-macos-aarch64-2.2.20

# 2. 验证 Swift/Xcode 安装
xcrun swift --version
xcrun --sdk iphoneos --show-sdk-version

# 3. 验证 bc 计算器
which bc

# 4. 运行所有基准测试
./benchmark_all_cases.sh
```

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

使用 Kotlin Native 2.2.20、Swift 6.1.2 和 Apple Clang 17.0.0 进行的全面测试显示，不同语言和使用场景下的二进制大小存在显著差异。

### 结果汇总表

| 测试用例 | Objective-C (字节) | Swift (字节) | Kotlin (字节) | 最优语言 | Swift vs ObjC | Kotlin vs ObjC |
|------|-------|-------|--------|-------------|-------------|-------------|
| **async** | 76,347 | 162,332 | 163,086 | **Objective-C** | 2.13x | 2.14x |
| **async-enhanced** | 24,538 | 86,128 | 57,952 | **Objective-C** | 3.51x | 2.36x |
| **callback** | 46,104 | 60,846 | 90,173 | **Objective-C** | 1.32x | 1.96x |
| **collection-minimal** | 4,793 | 6,974 | 6,809 | **Objective-C** | 1.46x | 1.42x |
| **data-classes** | 23,466 | 126,322 | 88,722 | **Objective-C** | 5.38x | 3.78x |
| **data-classes-enhanced** | 13,325 | 118,380 | 36,283 | **Objective-C** | 8.88x | 2.72x |
| **extension-functions** | 27,639 | 34,333 | 45,784 | **Objective-C** | 1.24x | 1.66x |
| **functional-style** | 13,182 | 44,550 | 29,721 | **Objective-C** | 3.38x | 2.25x |
| **generics-heavy** | 11,119 | 31,246 | 18,534 | **Objective-C** | 2.81x | 1.67x |
| **inheritance-deep** | 8,481 | 15,374 | 31,501 | **Objective-C** | 1.81x | 3.71x |
| **json-serialization** | 13,306 | 46,498 | 20,190 | **Objective-C** | 3.49x | 1.52x |
| **many-classes** | 17,036 | 18,055 | 23,646 | **Objective-C** | 1.06x | 1.39x |
| **null-safety** | 21,990 | 34,190 | 25,593 | **Objective-C** | 1.55x | 1.16x |
| **protocol-oriented** | 12,286 | 29,105 | 21,754 | **Objective-C** | 2.37x | 1.77x |
| **scope-functions** | 28,759 | 46,948 | 54,803 | **Objective-C** | 1.63x | 1.91x |
| **string-processing** | 17,223 | 44,030 | 26,077 | **Objective-C** | 2.56x | 1.51x |
| **variable-capture** | 8,457 | 16,289 | 13,134 | **Objective-C** | 1.93x | 1.55x |

### 关键发现

**🏆 Objective-C 在所有测试用例中都产生最小的二进制文件**，是大小关键应用的明确赢家。

**📊 语言性能模式：**
- **Swift 开销范围从 1.06x 到 8.88x** 大于 Objective-C
- **Kotlin 开销范围从 1.16x 到 3.78x** 大于 Objective-C  
- **Swift 最差用例**: data-classes-enhanced (8.88x), data-classes (5.38x)
- **Swift 最佳用例**: many-classes (1.06x), extension-functions (1.24x)

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

### 详细结果

基准测试生成包含完整指标的 `results.csv`：
```csv
case,variant,language,success,text_size,data_size,final_size,lines_of_code
async-enhanced,-Os,objc,true,31709,11708,24538,731
async-enhanced,-Os,swift,true,120807,7816,86128,462
async-enhanced,-Os,kotlin,true,70205,44040,57952,308
async,-Os,objc,true,102833,21820,76347,2122
async,-Os,swift,true,225800,21360,162332,1452
async,-Os,kotlin,true,194987,132976,163086,1005
callback,-Os,objc,true,60261,19608,46104,1448
callback,-Os,swift,true,84631,8024,60846,944
callback,-Os,kotlin,true,105749,80744,90173,907
collection-minimal,-Os,objc,true,5911,3276,4793,212
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

### 指标说明
- **case**: 测试用例名称
- **variant**: 变体（通常为 base）
- **language**: 编程语言（kotlin/swift/objc）
- **success**: 编译是否成功
- **text_size**: TEXT 段大小（可执行代码）
- **data_size**: DATA 段大小（初始化数据）
- **final_size**: 最终加权大小 (TEXT×0.7 + DATA×0.2)
- **lines_of_code**: 代码行数
