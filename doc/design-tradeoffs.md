# 语言设计取舍:体积与执行速度

本文从**代码体积**(iOS)与**执行速度**(macOS)两个维度,记录 Objective-C、Swift、
Kotlin Native、scriptc(TypeScript→native,0.2.7)、Zig(0.16.0)五种实现的设计取舍。所有
数字取自本仓库 `results.csv`(体积)与 `results_speed.csv`(速度),工具链为 Xcode 26.6 /
iOS SDK 26.5 / Swift 6.3.3 / Apple Clang 21 / Kotlin Native 2.4.20 / Zig 0.16.0。

> **一句话结论**:没有全能赢家。体积上 ObjC 不再恒定最小——它仍赢 15 个可运行用例中的 10 个,
> 但 Zig 凭近零运行时拿下 5 个;速度上 Zig 几何平均最快(1.26x,11/15 用例最快)。而体积与
> 速度往往是**同一枚硬币的两面**——让 scriptc / Zig 把代码内联、单态化进用户对象的机制,
> 恰恰是让它们执行快的机制。

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

## 2. 五种语言的设计定位

- **Objective-C**:手写样板,几乎没有编译器生成的元数据。运行时是薄薄一层 `objc_msgSend`
  动态分发。付出的是开发成本,换来的是最小二进制。
- **Swift**:值语义 + 丰富的运行时元数据(protocol witness tables、type metadata、
  Codable 反射)。安全与表达力的代价是最大的二进制。
- **Kotlin Native**:自动生成 data class 成员、协程状态机;stdlib 外置于共享缓存。GC 托管内存。
- **scriptc**:把泛型单态化、集合操作按调用点特化,**内联进用户对象**(类 C++ 模板);
  引用计数 + 环收集,无追踪式 GC;JS 的 worker-isolate 并发模型。
- **Zig**(极致对照组):**近乎零运行时**的系统语言——手动内存、**完全无引用计数**、
  **无 GC**、无 stdlib 预构建缓存。它与 scriptc 同向:都把代码内联/单态化进用户对象、运行时
  很小或没有;但 Zig 走得更远——内存完全手动、RC/GC 完全不存在。因此 Zig 是**地板数据点**:
  当其他语言的运行时成本被逐一剥离后,一个近零运行时的系统语言最终落在哪里。换言之,**Zig
  与其余语言的差距,就是其余语言付出的运行时税**(RC / GC / 元数据 / 动态分发)。

---

## 3. 体积维度的取舍

部分用例(final_size,字节,越小越好):

| 用例 | ObjC | Swift | Kotlin | scriptc | Zig | Zig/ObjC |
|------|------|-------|--------|---------|-----|----------|
| collection-minimal | **4,854** | 6,958 | 6,803 | 5,972 | 8,224 | 1.69x |
| data-classes | **24,588** | 115,725 | 91,197 | 130,563 | 42,424 | 1.73x |
| data-classes-enhanced | **14,061** | 111,797 | 36,078 | 34,088 | 16,074 | 1.14x |
| json-serialization | **14,037** | 45,667 | 47,782 | 23,391 | 59,743 | 4.26x |
| functional-style | **13,398** | 44,172 | 34,968 | 90,539 | 23,771 | 1.77x |
| callback | 47,163 | 58,821 | 97,688 | 98,194 | **25,235** | 0.54x |
| generics-heavy | 11,572 | 29,855 | 20,542 | 38,551 | **5,976** | 0.52x |
| scope-functions | 29,879 | 46,200 | 56,063 | 97,107 | **22,520** | 0.75x |
| inheritance-deep | 8,926 | 15,309 | 33,458 | 26,095 | **650**³ | 0.07x |
| many-classes | 17,672 | 18,066 | 23,483 | 36,580 | **427**³ | 0.02x |

³ comptime 常量折叠所致,见 §7 诚实度边界——非稳态体积。

**ObjC 不再恒定最小,但仍是最稳的小。** 在 15 个可运行用例里 ObjC 赢 10 个,**Zig 凭近零
运行时拿下另外 5 个**(callback、generics-heavy、inheritance-deep、many-classes、
scope-functions)。ObjC 赢的那些,胜在几乎不生成元数据:手写的 `isEqual:`/`hash`/
`description` 虽啰嗦,但编译出的指令少、无反射表,是体积关键型 App 稳妥的默认选项。

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

**Zig 两极更极端——地板与重活并存。** 一方面,它在控制流/派发型用例里极小甚至近乎为零:
callback 0.54x ObjC、generics-heavy 0.52x,inheritance-deep / many-classes 更是只有 650B /
427B(0.07x / 0.02x)——后两者是 comptime 常量折叠把整段 workload 抹掉的结果(见 §7),不是
稳态体积。另一方面,data/json/string 这类真·重活用例里 Zig 居中到偏大:json-serialization
达 ObjC 的 **4.26x**(把整个 `std.json` 拉了进来)。原因同样是"用户对象里几乎没有共享地板":
真正的工作既折不掉,又没有共享 stdlib 可甩,只能连同用到的 allocator shim、panic handler、
单态化容器一起塞进那一个 `program.o`。

> 这里埋下了与速度维度的伏笔:**内联与单态化是体积膨胀的来源,也是执行加速的来源。**

---

## 4. 执行速度维度的取舍

相对**每个用例内最快语言**的几何平均(1.00 = 总是最快):

| 语言 | 几何平均 vs 最快 | 可运行用例数 |
|------|-----------------|-------------|
| zig | **1.26x** | 15 |
| scriptc | 4.81x | 15 |
| kotlin | 5.96x | 15 |
| swift | 8.51x | 14 |
| objc | 9.94x | 11 |

**Zig 成为总体最快**(几何平均 1.26x,15 个用例里 11 个最快)——comptime 单态化 + 手动内存
让它几乎在所有形态上领先。此前"scriptc 最快(1.93x)"的结论就此被取代:scriptc 现在是
4.81x,因为大多数用例的冠军被 Zig 拿走。Zig **只输 4 个**:data-classes(输给 Swift)、
string-processing(输给 ObjC),以及 json-serialization(6.66ms vs scriptc 5.22ms)和
protocol-oriented(51.4ms vs 33.4ms)这两个重间接派发用例输给 scriptc——那里 scriptc 的
"按调用点特化"仍能比 Zig 的派发再省一手。其余各家的分布:

- **Zig 赢绝大多数**:callback、collection-minimal、data-classes-enhanced、
  extension-functions、functional-style、generics-heavy、null-safety、scope-functions、
  variable-capture,以及 inheritance-deep / many-classes(后两者是 comptime 折叠,见 §7)。
- **scriptc 赢 json-serialization、protocol-oriented** 两个重间接派发用例。
- **Swift 赢 data-classes**(130µs,值语义 + 轻量数据构造);**ObjC 在 string-processing
  快两个数量级**(优化的 `NSString` 原语 1.95ms vs 其他手写字符串处理 12–161ms)。

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

**Zig 为什么再快一档**:它把 scriptc 的"编译期全知"推到极限——comptime 单态化把泛型/容器
在编译期铺平成直接代码,而内存完全手动、**无引用计数、无 GC**,连 scriptc 那层非原子 RC 与
free-list 的簿记都省了。于是 Zig 成了"运行时税"被剥到最低的地板:它与其余语言的速度差距,
基本就等于其余语言为 RC / GC / 元数据 / 间接派发付的账。scriptc 之所以还能在
json-serialization、protocol-oriented 上反超,靠的是按调用点特化在重间接派发处比 Zig 的
派发再省一手——这正是两种"编译期全知"模型在同一光谱上的细微分野。

**代价的另一面**:让 `program.o` 膨胀的单态化内联(§3),正是这里的加速来源。
**体积换速度**对 scriptc 与 Zig 同时成立。

**ObjC 的惯用实现两极**:string-processing 极快(NSString),protocol-oriented 225ms /
variable-capture 125ms 极慢——再次提醒这测的是惯用代码,不是语言本身。

---

## 5. 交叉洞察:体积与速度是同一枚硬币

每种语言的核心机制同时决定了它的体积与速度特征,方向往往相反:

| 机制 | 体积影响 | 速度影响 |
|------|----------|----------|
| Zig:comptime 单态化 + 手动内存 | 控制流/派发型用例**极小** | 代码铺平成直接调用 → **普遍最快** |
| Zig:comptime 能看见整个 workload | 把代码整段**抹掉**(inheritance-deep 650B、many-classes 427B) | 空运行时 → sub-40ns(见 §7) |
| Zig:**无 RC、无 GC**、无共享 stdlib | 真·重活(json 4.26x ObjC)**偏大** | 省掉一切运行时税,但折不掉的工作塞进自己 |
| scriptc:单态化 + 按调用点特化**内联** | 用户对象**膨胀** | 直接调用、可内联 → **快** |
| scriptc:非原子 RC + 无 GC + free-list | 运行时地板小、确定性 | 省原子操作/GC 暂停 → **快** |
| Kotlin:stdlib 路由到**共享缓存** | 用户模块**省体积** | 泛型/集合走共享实现,轻量场景快 |
| Kotlin:追踪式 GC | — | 分配密集场景**还账变慢** |
| Swift:运行时元数据 + 原子 ARC | 元数据**最大体积** | witness 分发 + 原子计数偏慢 |
| ObjC:手写、无元数据 + `objc_msgSend` | **常小体积** | 动态分发慢,但原语(NSString)可极快 |

**Zig 把这枚硬币翻到了底**:同一个 comptime 机制,在两个维度上同时发力——单态化 + 手动内存
让它普遍最快;而当这份编译期求值恰好能看见整个 workload(inheritance-deep、many-classes)时,
它干脆把代码**整段抹掉**,于是极小体积与近乎空的运行时同时出现。**同一机制,两个维度。**

**选型启示**:
- **体积优先**(App 瘦身、动态库下发):ObjC 稳居小体积默认(10/15),控制流/派发型用例
  Zig 更小(5/15);数据/序列化重活慎用 Zig(无共享 stdlib,json 达 4.26x ObjC)。
- **执行速度优先**(整体热路径):Zig 近零运行时,几何平均 1.26x、11/15 最快。
- **重间接派发热路径**(序列化、协议分发密集):scriptc 的按调用点特化仍能反超 Zig。
- **轻量泛型/类**:Zig 的 comptime 单态化普遍最快;Kotlin 次之。
- "体积换速度"不是口号,是可观测的同一机制的两面——scriptc 与 Zig 都如此;Zig 更是把近零
  运行时作为地板,其与各家的差距就是各家付的运行时税(见 §2)。采用 scriptc 还需接受其
  并发/形态前提(见 §6)。

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
- **Zig 的 comptime 常量折叠**:`inheritance-deep`(650 B / 34.8 ns)与 `many-classes`
  (427 B / 39.9 ns)接近"空",是因为地道的 Zig 写法——用 enum + `switch`、各分支直接返回常量,
  且输入在 comptime 已知——在 `ReleaseSmall` 下被**整段常量折叠**掉了。sub-40ns 的计时
  (空循环量级)正好佐证这点。这两个数字反映的是**优化器抹掉了一个 comptime 可知的 workload**,
  不是稳态的派发成本;其他语言保留运行时派发/元数据,无法折叠。因此**不要**据此宣称
  "Zig 的多态快/小 40 倍"——那是折叠假象,体积与速度两处都已显式标注(§3、§4)。
- **Zig async/async-enhanced 体积很大,非 N/A**:两个用例都移植到 0.16 的 `std.Io`
  结构化并发 API(`io.async`/`Future`/`Group`),跑在 `std.Io.Threaded` 线程池后端上。该线程池
  运行时整段内联进 `program.o`(每个约 297 KB DATA,无共享底座),使它们成为 Zig 最大的两个
  用例(125,385 / 122,659)。scriptc 仍因 `--lib` 的 async-free 约束无法构建(`SC4005`)。速度档
  则对所有语言排除这两个用例(驱动 sleep)。
- 本文中标注"实证"的部分来自产物反汇编/符号表;并发语义与运行时职责的因果链部分为基于
  符号与标准模型的**推断**,未逐一端到端复现(如多线程宿主触发竞争、loop 的队列抽取顺序)。
