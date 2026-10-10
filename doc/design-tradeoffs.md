# 语言设计取舍:体积与执行速度

本文从**代码体积**(iOS)与**执行速度**(macOS)两个维度,记录 Objective-C、Swift、
Kotlin Native、scriptc(TypeScript→native,0.2.7)四种实现的设计取舍。所有数字取自本仓库
`results.csv`(体积)与 `results_speed.csv`(速度),工具链为 Xcode 26.6 / iOS SDK 26.5 /
Swift 6.3.3 / Apple Clang 21 / Kotlin Native 2.4.20。

> **一句话结论**:没有全能赢家。体积上 ObjC 恒定最小;速度上没有单一冠军,但 scriptc
> 几何平均最快(1.93x)。而体积与速度往往是**同一枚硬币的两面**——让 scriptc 二进制膨胀的
> 机制,恰恰是让它执行快的机制。

---

## 1. 度量口径(先说清楚比什么)

- **体积**:`final = TEXT×0.7 + DATA×0.2`,对编译后归属到**用户模块**的产物做 `xcrun size`。
  Kotlin 测用户 library-cache(stdlib 在不计入的共享缓存);scriptc 测单个用户对象
  `program.o`(运行时 `scr_*.o` 是约 616KB 的共享地板,单独报告)。两者口径对等:都是
  "编译后落在你模块里的边际字节",不是源码行数直译。
- **速度**:原生 macOS 可执行文件,与体积档 **-Os 对齐**(clang -Os / swiftc -Osize /
  konanc -opt / scriptc release)。每次迭代构造一个全新的 `IosSizeBenchmark`;
  per-iter = `(wall(N) − wall(0)) / N`,warmup + min-of-5,N 按用例标定到约 0.5s。
- **这是惯用实现,不是手工对齐的等价实现**。各语言用各自地道的写法(与体积档完全相同的
  源码),所以极端差距是真实的实现差异,不是语言极限。部分用例因调用未实现方法而运行时
  崩溃 → 记 N/A;`async`/`async-enhanced` 因驱动 sleep 被排除。

---

## 2. 四种语言的设计定位

- **Objective-C**:手写样板,几乎没有编译器生成的元数据。运行时是薄薄一层 `objc_msgSend`
  动态分发。付出的是开发成本,换来的是最小二进制。
- **Swift**:值语义 + 丰富的运行时元数据(protocol witness tables、type metadata、
  Codable 反射)。安全与表达力的代价是最大的二进制。
- **Kotlin Native**:自动生成 data class 成员、协程状态机;stdlib 外置于共享缓存。GC 托管内存。
- **scriptc**:把泛型单态化、集合操作按调用点特化,**内联进用户对象**(类 C++ 模板);
  引用计数 + 环收集,无追踪式 GC;JS 的 worker-isolate 并发模型。

---

## 3. 体积维度的取舍

部分用例(final_size,字节,越小越好):

| 用例 | ObjC | Swift | Kotlin | scriptc |
|------|------|-------|--------|---------|
| collection-minimal | **4,854** | 6,958 | 6,803 | 5,972 |
| data-classes | **24,588** | 115,725 | 91,197 | 130,563 |
| data-classes-enhanced | **14,061** | 111,797 | 36,078 | 34,088 |
| json-serialization | **14,037** | 45,667 | 47,782 | 23,391 |
| functional-style | **13,398** | 44,172 | 34,968 | 90,539 |
| inheritance-deep | **8,926** | 15,309 | 33,458 | 26,095 |

**ObjC 在全部 17 个用例恒定最小**(约为次优的 1.1x–8x)。原因是它几乎不生成元数据:手写的
`isEqual:`/`hash`/`description` 虽啰嗦,但编译出的指令少、无反射表。体积关键型 App 的首选。

**Swift 体积最大**(data-classes-enhanced 达 ObjC 的 7.95x)。代价来自运行时元数据:每个类型
的 type metadata、每个协议一致性的 witness table、`Codable` 的反射支持。这些是 Swift 安全与
动态特性的物理成本,优化器也难以完全剥离。

**Kotlin 居中**。自动生成的 data class 成员、协程机器确实占体积,但 stdlib 住在**不计入的
共享缓存**里,所以用户模块只背自己的边际代码。注意一个口径细节:2.4.20 的 auto-cache 要求
所有依赖缓存,`json-serialization` 因此把用户实例化的序列化器算进了被测对象(2.2 下这些是
外部引用),数字从 20,190 升到 47,782——这是**边界移动**,不是退化。

**scriptc 两极分化**(相对 Kotlin 0.49x–2.59x)。关键在它**用户对象里几乎没有共享 stdlib
地板**:不像 Kotlin 把 `map`/`filter`/泛型路由到共享 stdlib,scriptc 按调用点特化、把泛型
单态化**内联**进 `program.o`。于是:

- lambda/集合/泛型密集的用例**膨胀**:functional-style 2.59x、extension-functions 2.19x。
- data class / 深继承 / 序列化用例**反而更小**:json-serialization 0.49x、inheritance-deep
  0.78x——因为这些场景 Kotlin 自己合成的成员和类型信息被计入,而 scriptc 的更紧凑。

> 这里埋下了与速度维度的伏笔:**内联与单态化是体积膨胀的来源,也是执行加速的来源。**

---

## 4. 执行速度维度的取舍

相对**每个用例内最快语言**的几何平均(1.00 = 总是最快):

| 语言 | 几何平均 vs 最快 | 可运行用例数 |
|------|-----------------|-------------|
| scriptc | **1.93x** | 15 |
| kotlin | 2.29x | 15 |
| objc | 3.17x | 11 |
| swift | 3.27x | 14 |

**没有单一赢家**,快慢取决于用例形态:

- **Kotlin 赢轻量泛型/类密集用例**(generics-heavy、many-classes、inheritance-deep、
  scope-functions、functional-style)——单次纳秒级,GC 没来得及还账,JIT 式优化到位。
- **scriptc 赢重 OO/数据/闭包用例**(callback、data-classes-enhanced、json-serialization、
  protocol-oriented、variable-capture、null-safety、extension-functions)。
- **Swift 赢两个数据为主的轻量用例**;**ObjC 在 string-processing 快两个数量级**(优化的
  `NSString` 原语 1.68ms vs 其他手写字符串处理 27–161ms)。

**scriptc 为什么在重用例快**(反汇编实证,见 §6):四个机制叠加,全部是"编译期全知 +
线程封闭默认"的产物——

1. **非原子引用计数**:每类型的 retain/release 是普通 `ldr/add/str`,无原子 RMW、无屏障。
   Swift ARC / ObjC ARC 的计数是**原子**的(跨线程安全),每次 retain 付一次原子操作;
   分配密集用例(百万次对象生灭)这里省掉的量累积成毫秒级差距。
2. **单态化直接调用**:null-safety 的 program.o 里 97% 是直接 `bl`(2306 vs 72 间接 `blr`)。
   protocol-oriented 这种,其他语言每次走 witness table / vtable / `objc_msgSend` 的间接跳转,
   预测失败代价高;scriptc 编译期定地址 → 可内联、可预测。
3. **无追踪式 GC**:计数归零即刻释放(确定性),无 mark-sweep、无 safepoint 暂停。Kotlin 的
   追踪 GC 在分配密集用例(data-classes 658µs vs scriptc 441µs)替代码还账。
4. **内联 free-list 分配器**:释放即挂回按大小分桶的空闲链表,无锁、无通用 `malloc` 开销。

**代价的另一面**:让 program.o 膨胀的单态化内联(§3),正是这里的加速来源。**体积换速度。**
而 scriptc 输掉的用例(inheritance-deep、generics-heavy、many-classes,均 Kotlin 赢)都是
单次纳秒级的轻量场景——那里它的固定开销与少量间接调用占比显出来,优势被摊薄。

**ObjC 的惯用实现两极**:string-processing 极快(NSString),protocol-oriented 225ms /
variable-capture 125ms 极慢——再次提醒这测的是惯用代码,不是语言本身。

---

## 5. 交叉洞察:体积与速度是同一枚硬币

每种语言的核心机制同时决定了它的体积与速度特征,方向往往相反:

| 机制 | 体积影响 | 速度影响 |
|------|----------|----------|
| scriptc:单态化 + 按调用点特化**内联** | 用户对象**膨胀** | 直接调用、可内联 → **快** |
| scriptc:非原子 RC + 无 GC + free-list | 运行时地板小、确定性 | 省原子操作/GC 暂停 → **快** |
| Kotlin:stdlib 路由到**共享缓存** | 用户模块**省体积** | 泛型/集合走共享实现,轻量场景快 |
| Kotlin:追踪式 GC | — | 分配密集场景**还账变慢** |
| Swift:运行时元数据 + 原子 ARC | 元数据**最大体积** | witness 分发 + 原子计数偏慢 |
| ObjC:手写、无元数据 + `objc_msgSend` | **最小体积** | 动态分发慢,但原语(NSString)可极快 |

**选型启示**:
- **体积优先**(App 瘦身、动态库下发):ObjC > Kotlin ≈ scriptc(视场景)> Swift。
- **重计算热路径**(OO/闭包/序列化密集):scriptc 的"编译期全知"模型优势明显。
- **轻量泛型/类**:Kotlin 单次开销最低。
- scriptc 的"体积换速度"不是口号,是可观测的同一机制的两面;它适合"愿意用体积换热路径
  性能、且能接受其并发/形态前提"的场景(见 §6)。

---

## 6. scriptc 的前提:并发模型与产物形态

scriptc 上面的速度优势(非原子 RC 尤其)建立在一组**前提假设**上,理解它才能判断能否安全采用。

**并发:worker-isolate 模型(JS 式)。** 运行时有两级引用计数——线程封闭对象走非原子路径,
显式共享对象(`SharedArrayBuffer`/`Atomics`)走**原子**路径(`ldaxr/stlxr`)。普通对象在语言
层面**无法意外跨线程**:线程间只能通过结构化克隆(深拷贝)、transfer(移交所有权)或
`SharedArrayBuffer`(独立类型)通信,前两者的结果仍是单线程独占。所以非原子 RC 是**正确**的,
不是偷懒——编译器也无需逃逸分析去"猜某参数是否多线程",因为可共享的东西是**独立类型/显式
API**,从类型即可见。默认廉价、共享 opt-in、无法意外逃逸。

**产物形态决定能力:**

| 维度 | `--emit=exe`(独立程序) | `--lib`(链进宿主) |
|------|------------------------|-------------------|
| event loop / runloop | **自带**(`_scr_loop_run` + 定时器/microtask/IO 轮询,按需 DCE) | **无** |
| async/await | 允许 | **禁止**(`SC4005`:入口可达图必须 async-free) |
| 运行时上下文 | 自管,worker 模型保证单线程封闭 | **进程全局、无 TLS** |
| 线程安全责任 | 运行时自己保证 | **甩给宿主** |

- **exe 模式**自己就是宿主,链入完整事件循环(实测:async exe 比 sync exe 多约 115 个
  `scr_` 符号,含 `_scr_loop_run`/`_scr_timer_*`/`_scr_promise_*`/`_scr_resume_fiber`),
  worker-isolate 模型保证每个 isolate 内单线程。
- **lib 模式**是被动代码单元:不链 event loop、不装信号处理、不建线程(SC4005 hint 原文)。
  导出 `<prefix>_init` / `<prefix>_run` / `<prefix>_sink_register`,宿主先 init 再 run,
  带参数走 `str_in/out`、`bytes_in/out`、`i64_in` 等 marshalling helper 过 ABI 边界。
  **但上下文是进程全局、无 TLS**:若宿主从多线程并发调入,会在全局 arena 与非原子计数上
  据竞争 → 内存损坏。入口的 `callback_entry_guard` 是**重入闩,不是互斥锁**。

**从外部入口调用的安全规则**(单一进程全局上下文):
1. **串行化入口**:用一把锁包住 `<prefix>_run`,或固定到一个专用线程。
2. **不要指望"每线程一实例"**:状态进程全局,同进程无法天然多上下文。
3. **跨线程只传值不传引用**:结果 marshal 成宿主类型拷出,别把 scriptc 对象引用泄漏到他线程
   (会同踩非原子 RC 和全局 arena 两个雷)。

> 换言之:exe 模式下"单线程封闭"是**语言保证**;lib 模式下它降级为**宿主的义务**。SC4005 的
> "creates no threads"承诺的是"库自己不开线程",**不是**"库可被多线程安全调用"。

---

## 7. 诚实度边界

- **惯用实现,非手工对齐**:速度/体积反映各语言地道写法的成本,极端差距是真实实现差异。
- **N/A**:部分 ObjC 用例(及 Swift 的 extension-functions)调用声明但未实现的方法,运行时
  崩溃 → 速度档记 N/A(体积档从不执行,无妨);`async`/`async-enhanced` 排除(驱动 sleep)。
- **json-serialization 的 Kotlin 体积**是 2.4.20 缓存边界移动的结果,与 2.2 的旧值不可直接比。
- 本文中标注"实证"的部分来自产物反汇编/符号表;并发语义与运行时职责的因果链部分为基于
  符号与标准模型的**推断**,未逐一端到端复现(如多线程宿主触发竞争、loop 的队列抽取顺序)。
