// iOS Size Benchmark - Test Case Implementation
// Generated with Claude AI (https://claude.ai)
//
// Zig port of the "functional-style" case. The TS/Kotlin version is built on
// higher-order functions, closures and immutability. Zig has NO closures, so:
//   * A pure lambda becomes a named top-level function, passed as a
//     `*const fn(...)` pointer (map/filter/fold/pipe take these).
//   * A transform that allocates (string ops build new buffers) threads the
//     allocator explicitly as its first arg — the honest Zig analogue of a
//     captured runtime, instead of a hidden closure environment.
//   * A lambda that CAPTURES state (LambdaFactory's `(m)=>(n)=>n*m`,
//     measureAndExecute's `() => ...strings...`) becomes an explicit closure
//     struct holding the captured field + an `apply` method.
// map/filter/fold/flatMap are generic helpers over slices (comptime element
// type + fn param), mirroring the generics-heavy port. A single exported entry
// exercises every type/method so nothing is dead-code eliminated.

const std = @import("std");

const Str = []const u8;
// Function-pointer aliases standing in for the TS lambda value types.
const StrOp = *const fn (std.mem.Allocator, Str) anyerror!Str; // allocating string transform
const StrPred = *const fn (Str) bool;
const StrSink = *const fn (Str) void;
const ChainOp = *const fn (std.mem.Allocator, Str) anyerror!?Str; // may short-circuit to null

fn Pair(comptime A: type, comptime B: type) type {
    return struct { first: A, second: B };
}

// ---- Free string helpers (TS top-level functions) ----
fn reverseString(a: std.mem.Allocator, s: Str) !Str {
    const out = try a.alloc(u8, s.len);
    var i: usize = 0;
    while (i < s.len) : (i += 1) out[i] = s[s.len - 1 - i];
    return out;
}
fn capitalizeFirst(a: std.mem.Allocator, s: Str) !Str {
    if (s.len == 0) return s;
    const out = try a.dupe(u8, s);
    out[0] = std.ascii.toUpper(out[0]);
    return out;
}
fn isLetterOrDigit(ch: u8) bool {
    return (ch >= '0' and ch <= '9') or (ch >= 'A' and ch <= 'Z') or (ch >= 'a' and ch <= 'z');
}
fn allLetterOrDigit(text: Str) bool {
    for (text) |ch| if (!isLetterOrDigit(ch)) return false;
    return true;
}
// Kotlin String.toIntOrNull(): null for blank/non-integer input.
fn toIntOrNull(text: Str) ?i64 {
    if (text.len == 0) return null;
    var start: usize = 0;
    var sign: i64 = 1;
    const f = text[0];
    if (f == '-' or f == '+') {
        if (text.len == 1) return null;
        if (f == '-') sign = -1;
        start = 1;
    }
    var value: i64 = 0;
    var i: usize = start;
    while (i < text.len) : (i += 1) {
        const c = text[i];
        if (c < '0' or c > '9') return null;
        value = value * 10 + @as(i64, @intCast(c - '0'));
    }
    return sign * value;
}

// Allocating string transforms (StrOp-compatible: fn(allocator, Str) !Str).
fn upperStr(a: std.mem.Allocator, s: Str) !Str {
    const out = try a.alloc(u8, s.len);
    for (s, 0..) |ch, i| out[i] = std.ascii.toUpper(ch);
    return out;
}
fn lowerStr(a: std.mem.Allocator, s: Str) !Str {
    const out = try a.alloc(u8, s.len);
    for (s, 0..) |ch, i| out[i] = std.ascii.toLower(ch);
    return out;
}
fn trimStr(a: std.mem.Allocator, s: Str) !Str {
    _ = a;
    return std.mem.trim(u8, s, " \t\n\r");
}
fn spaceToUnderscore(a: std.mem.Allocator, s: Str) !Str {
    const out = try a.dupe(u8, s);
    for (out) |*ch| if (ch.* == ' ') {
        ch.* = '_';
    };
    return out;
}
fn processedPrefix(a: std.mem.Allocator, s: Str) !Str {
    return std.fmt.allocPrint(a, "processed_{s}", .{s});
}
fn condPrefix(a: std.mem.Allocator, s: Str) !Str {
    return std.fmt.allocPrint(a, "cond_{s}", .{s});
}
fn loggedPrefix(a: std.mem.Allocator, s: Str) !Str {
    return std.fmt.allocPrint(a, "logged_{s}", .{s});
}
fn fallbackPrefix(a: std.mem.Allocator, s: Str) !Str {
    return std.fmt.allocPrint(a, "fallback_{s}", .{s});
}
fn eventPrefix(a: std.mem.Allocator, s: Str) !Str {
    return std.fmt.allocPrint(a, "EVENT_{s}", .{s});
}
// Pure scalar lambdas.
fn multiplyBy2(x: i64) i64 {
    return x * 2;
}
fn add10(x: i64) i64 {
    return x + 10;
}
fn add(x: i64, y: i64) i64 {
    return x + y;
}
fn times3Maybe(x: i64) ?i64 {
    return x * 3;
}
fn selectorId(x: i64) i64 {
    return x;
}

// map/filter/fold transform & predicate stand-ins (allocator threaded where
// a result is heap-allocated; pure ones ignore the allocator).
fn dblAlloc(a: std.mem.Allocator, x: i64) !i64 {
    _ = a;
    return x * 2;
}
fn mul3Alloc(a: std.mem.Allocator, x: i64) !i64 {
    _ = a;
    return x * 3;
}
fn strLenAlloc(a: std.mem.Allocator, s: Str) !i64 {
    _ = a;
    return @intCast(s.len);
}
fn isEven(x: i64) bool {
    return @mod(x, 2) == 0;
}
fn gt3(x: i64) bool {
    return x > 3;
}
fn lenGt5(s: Str) bool {
    return s.len > 5;
}
fn lenGt4(s: Str) bool {
    return s.len > 4;
}
fn addI64(acc: i64, n: i64) i64 {
    return acc + n;
}
fn maxLenOp(acc: i64, s: Str) i64 {
    return @max(acc, @as(i64, @intCast(s.len)));
}
fn firstCharStr(s: Str) Str {
    return s[0..1];
}
fn explodeNum(a: std.mem.Allocator, n: i64) ![]const i64 {
    const out = try a.alloc(i64, 2);
    out[0] = n;
    out[1] = n * 10;
    return out;
}
fn splitChars(a: std.mem.Allocator, s: Str) ![]const Str {
    const out = try a.alloc(Str, s.len);
    for (s, 0..) |_, i| out[i] = s[i .. i + 1];
    return out;
}

// LambdaFactory lambdas (the closure-returning factories collapse to these).
fn validateStr(s: Str) bool {
    return s.len > 0 and s.len > 3 and allLetterOrDigit(s);
}
fn transformText(a: std.mem.Allocator, s: Str) !Str {
    var buf: std.ArrayList(u8) = .empty;
    var it = std.mem.tokenizeScalar(u8, s, ' ');
    var first = true;
    while (it.next()) |tok| {
        if (!first) try buf.append(a, ' ');
        first = false;
        for (tok, 0..) |ch, i| {
            const lc = std.ascii.toLower(ch);
            try buf.append(a, if (i == 0) std.ascii.toUpper(lc) else lc);
        }
    }
    return buf.toOwnedSlice(a);
}
fn aggregate(numbers: []const i64) i64 {
    var acc: i64 = 0;
    for (numbers) |n| if (n > 0) {
        acc += n * n;
    };
    return acc;
}
fn complexProcess(a: std.mem.Allocator, strings: []const Str) !std.StringHashMapUnmanaged(i64) {
    var grouped: std.StringHashMapUnmanaged(std.ArrayList(Str)) = .empty;
    for (strings) |it| if (it.len > 0) {
        const gop = try grouped.getOrPut(a, it[0..1]);
        if (!gop.found_existing) gop.value_ptr.* = .empty;
        try gop.value_ptr.append(a, it);
    };
    var result: std.StringHashMapUnmanaged(i64) = .empty;
    var vit = grouped.iterator();
    while (vit.next()) |e| if (e.value_ptr.items.len > 1)
        try result.put(a, e.key_ptr.*, @intCast(e.value_ptr.items.len));
    return result;
}
fn fizzBuzz(a: std.mem.Allocator, num: i64) !Str {
    if (@mod(num, 15) == 0) return "FizzBuzz";
    if (@mod(num, 3) == 0) return "Fizz";
    if (@mod(num, 5) == 0) return "Buzz";
    return std.fmt.allocPrint(a, "{d}", .{num});
}
// Higher-order utilities (Kotlin `object` singleton -> namespace struct of
// generic fns over slices). map/flatMap thread the allocator through the
// transform; filter/fold take pure fn pointers.
const FunctionalUtils = struct {
    fn map(a: std.mem.Allocator, comptime T: type, comptime R: type, list: []const T, transform: *const fn (std.mem.Allocator, T) anyerror!R) ![]R {
        var out: std.ArrayList(R) = .empty;
        for (list) |x| try out.append(a, try transform(a, x));
        return out.toOwnedSlice(a);
    }
    fn filter(a: std.mem.Allocator, comptime T: type, list: []const T, predicate: *const fn (T) bool) ![]T {
        var out: std.ArrayList(T) = .empty;
        for (list) |x| if (predicate(x)) try out.append(a, x);
        return out.toOwnedSlice(a);
    }
    fn fold(comptime T: type, comptime R: type, list: []const T, initial: R, op: *const fn (R, T) R) R {
        var acc = initial;
        for (list) |x| acc = op(acc, x);
        return acc;
    }
    fn flatMap(a: std.mem.Allocator, comptime T: type, comptime R: type, list: []const T, transform: *const fn (std.mem.Allocator, T) anyerror![]const R) ![]R {
        var out: std.ArrayList(R) = .empty;
        for (list) |x| for (try transform(a, x)) |r| try out.append(a, r);
        return out.toOwnedSlice(a);
    }
    // compose: `f ∘ g`. The TS closure becomes a comptime-generated function.
    fn compose(comptime T: type, comptime R: type, comptime S: type, comptime f: fn (R) S, comptime g: fn (T) R) fn (T) S {
        return struct {
            fn c(x: T) S {
                return f(g(x));
            }
        }.c;
    }
    // pipe: left-to-right application of a run-time list of fn pointers.
    fn pipe(value: i64, functions: []const *const fn (i64) i64) i64 {
        var acc = value;
        for (functions) |fnp| acc = fnp(acc);
        return acc;
    }
    fn bind(comptime T: type, comptime R: type, value: ?T, transform: *const fn (T) ?R) ?R {
        return if (value) |v| transform(v) else null;
    }
    fn unit(a: std.mem.Allocator, comptime T: type, value: T) ![]T {
        const out = try a.alloc(T, 1);
        out[0] = value;
        return out;
    }
};

// curry/partial capture a runtime value -> explicit closure structs.
fn Curried(comptime f: fn (i64, i64) i64) type {
    return struct {
        x: i64,
        fn apply(self: @This(), y: i64) i64 {
            return f(self.x, y);
        }
    };
}
// NumberProcessor: `(m)=>(n)=>n*m` collapsed to one captured closure.
const NumberProcessor = struct {
    multiplier: i64,
    fn apply(self: NumberProcessor, n: i64) i64 {
        return n * self.multiplier;
    }
};
// StringProcessor: `(prefix)=>(text)=>"prefix: text"`.
const StringProcessor = struct {
    prefix: Str,
    fn apply(self: StringProcessor, a: std.mem.Allocator, text: Str) !Str {
        return std.fmt.allocPrint(a, "{s}: {s}", .{ self.prefix, text });
    }
};
// NestedFn: `(inner)=>(x)=>inner(inner(x))` captures the inner fn pointer.
const NestedFn = struct {
    f: *const fn (i64) i64,
    fn apply(self: NestedFn, x: i64) i64 {
        return self.f(self.f(x));
    }
};

const LambdaFactory = struct {
    fn createNumberProcessor(_: LambdaFactory, m: i64) NumberProcessor {
        return .{ .multiplier = m };
    }
    fn createStringProcessor(_: LambdaFactory, p: Str) StringProcessor {
        return .{ .prefix = p };
    }
    fn createValidator(_: LambdaFactory) StrPred {
        return &validateStr;
    }
    fn createTransformer(_: LambdaFactory) StrOp {
        return &transformText;
    }
    fn createAggregator(_: LambdaFactory) *const fn ([]const i64) i64 {
        return &aggregate;
    }
    fn createComplexProcessor(_: LambdaFactory) *const fn (std.mem.Allocator, []const Str) anyerror!std.StringHashMapUnmanaged(i64) {
        return &complexProcess;
    }
    fn createNestedFunction(_: LambdaFactory, f: *const fn (i64) i64) NestedFn {
        return .{ .f = f };
    }
    fn createConditionalFunction(_: LambdaFactory) *const fn (std.mem.Allocator, i64) anyerror!Str {
        return &fizzBuzz;
    }
};
const DataProcessor = struct {
    processors: std.ArrayList(StrOp) = .empty,
    fn addProcessor(self: *DataProcessor, a: std.mem.Allocator, p: StrOp) !*DataProcessor {
        try self.processors.append(a, p);
        return self;
    }
    fn process(self: *const DataProcessor, a: std.mem.Allocator, data: Str) !Str {
        var acc = data;
        for (self.processors.items) |p| acc = try p(a, acc);
        return acc;
    }
    fn processMany(self: *const DataProcessor, a: std.mem.Allocator, data: []const Str) ![]Str {
        var out: std.ArrayList(Str) = .empty;
        for (data) |it| try out.append(a, try self.process(a, it));
        return out.toOwnedSlice(a);
    }
    fn processAsync(self: *const DataProcessor, a: std.mem.Allocator, data: Str, callback: StrSink) !void {
        callback(try self.process(a, data));
    }
    fn processConditional(_: *const DataProcessor, a: std.mem.Allocator, data: Str, condition: StrPred, processor: StrOp) !Str {
        return if (condition(data)) try processor(a, data) else data;
    }
};

const EventHandler = struct {
    handlers: std.ArrayList(StrSink) = .empty,
    filters: std.ArrayList(StrPred) = .empty,
    transformers: std.ArrayList(StrOp) = .empty,
    fn addHandler(self: *EventHandler, a: std.mem.Allocator, h: StrSink) !*EventHandler {
        try self.handlers.append(a, h);
        return self;
    }
    fn addFilter(self: *EventHandler, a: std.mem.Allocator, f: StrPred) !*EventHandler {
        try self.filters.append(a, f);
        return self;
    }
    fn addTransformer(self: *EventHandler, a: std.mem.Allocator, t: StrOp) !*EventHandler {
        try self.transformers.append(a, t);
        return self;
    }
    fn handle(self: *const EventHandler, a: std.mem.Allocator, event: Str) !void {
        for (self.filters.items) |f| if (!f(event)) return;
        var transformed = event;
        for (self.transformers.items) |t| transformed = try t(a, transformed);
        for (self.handlers.items) |h| h(transformed);
    }
    fn handleMany(self: *const EventHandler, a: std.mem.Allocator, events: []const Str) !void {
        for (events) |e| try self.handle(a, e);
    }
    fn handleWithCallback(self: *const EventHandler, a: std.mem.Allocator, event: Str, callback: StrSink) !void {
        try self.handle(a, event);
        callback(event);
    }
};

// Stream-like immutable pipeline. Every stage returns a new stream over a
// freshly allocated slice, so stages thread the allocator (map/flatMap/take/
// drop/sortedBy/distinct); filter/fold/reduce take pure fn pointers.
fn FunctionalStream(comptime T: type) type {
    return struct {
        data: []const T,
        const Self = @This();
        fn map(self: Self, a: std.mem.Allocator, comptime R: type, transform: *const fn (std.mem.Allocator, T) anyerror!R) !FunctionalStream(R) {
            var out: std.ArrayList(R) = .empty;
            for (self.data) |x| try out.append(a, try transform(a, x));
            return .{ .data = try out.toOwnedSlice(a) };
        }
        fn filter(self: Self, a: std.mem.Allocator, predicate: *const fn (T) bool) !Self {
            var out: std.ArrayList(T) = .empty;
            for (self.data) |x| if (predicate(x)) try out.append(a, x);
            return .{ .data = try out.toOwnedSlice(a) };
        }
        fn flatMap(self: Self, a: std.mem.Allocator, comptime R: type, transform: *const fn (std.mem.Allocator, T) anyerror![]const R) !FunctionalStream(R) {
            var out: std.ArrayList(R) = .empty;
            for (self.data) |x| for (try transform(a, x)) |r| try out.append(a, r);
            return .{ .data = try out.toOwnedSlice(a) };
        }
        fn forEach(self: Self, action: *const fn (T) void) void {
            for (self.data) |x| action(x);
        }
        fn fold(self: Self, comptime R: type, initial: R, op: *const fn (R, T) R) R {
            var acc = initial;
            for (self.data) |x| acc = op(acc, x);
            return acc;
        }
        // Kotlin List.reduce throws on empty; here the caller guarantees non-empty.
        fn reduce(self: Self, op: *const fn (T, T) T) T {
            var acc = self.data[0];
            var i: usize = 1;
            while (i < self.data.len) : (i += 1) acc = op(acc, self.data[i]);
            return acc;
        }
        fn take(self: Self, n: usize) Self {
            return .{ .data = self.data[0..@min(n, self.data.len)] };
        }
        fn drop(self: Self, n: usize) Self {
            return .{ .data = self.data[@min(n, self.data.len)..] };
        }
        fn zip(self: Self, a: std.mem.Allocator, other: Self) ![]Pair(T, T) {
            const n = @min(self.data.len, other.data.len);
            const out = try a.alloc(Pair(T, T), n);
            var i: usize = 0;
            while (i < n) : (i += 1) out[i] = .{ .first = self.data[i], .second = other.data[i] };
            return out;
        }
        fn groupBy(self: Self, a: std.mem.Allocator, keySelector: *const fn (T) Str) !std.StringHashMapUnmanaged(std.ArrayList(T)) {
            var result: std.StringHashMapUnmanaged(std.ArrayList(T)) = .empty;
            for (self.data) |item| {
                const gop = try result.getOrPut(a, keySelector(item));
                if (!gop.found_existing) gop.value_ptr.* = .empty;
                try gop.value_ptr.append(a, item);
            }
            return result;
        }
        fn sortedBy(self: Self, a: std.mem.Allocator, comptime selector: fn (T) i64) !Self {
            const copy = try a.dupe(T, self.data);
            std.mem.sort(T, copy, {}, struct {
                fn lt(_: void, x: T, y: T) bool {
                    return selector(x) < selector(y);
                }
            }.lt);
            return .{ .data = copy };
        }
        fn distinct(self: Self, a: std.mem.Allocator) !Self {
            var out: std.ArrayList(T) = .empty;
            for (self.data) |item| {
                var seen = false;
                for (out.items) |e| if (e == item) {
                    seen = true;
                    break;
                };
                if (!seen) try out.append(a, item);
            }
            return .{ .data = try out.toOwnedSlice(a) };
        }
        fn toList(self: Self) []const T {
            return self.data;
        }
    };
}
const FunctionalSideEffects = struct {
    logs: std.ArrayList(Str) = .empty,
    counters: std.StringHashMapUnmanaged(i64) = .empty,
    fn logAndProcess(self: *FunctionalSideEffects, a: std.mem.Allocator, text: Str, processor: StrOp) !Str {
        try self.logs.append(a, try std.fmt.allocPrint(a, "Processing: {s}", .{text}));
        const result = try processor(a, text);
        try self.logs.append(a, try std.fmt.allocPrint(a, "Result: {s}", .{result}));
        return result;
    }
    fn countAndFilter(self: *FunctionalSideEffects, a: std.mem.Allocator, items: []const Str, predicate: StrPred) ![]Str {
        try self.counters.put(a, "total", @intCast(items.len));
        var out: std.ArrayList(Str) = .empty;
        for (items) |item| {
            const key = if (predicate(item)) "passed" else "failed";
            try self.counters.put(a, key, (self.counters.get(key) orelse 0) + 1);
            if (predicate(item)) try out.append(a, item);
        }
        return out.toOwnedSlice(a);
    }
    // The TS operation `() => ...strings...` captures `strings`; modeled as an
    // explicit closure object passed as `anytype` with an `apply` method.
    fn measureAndExecute(self: *FunctionalSideEffects, a: std.mem.Allocator, operation: anytype) !Pair(Str, i64) {
        const startTime = self.getCurrentTimeMillis();
        const result = try operation.apply(a);
        const endTime = self.getCurrentTimeMillis();
        try self.logs.append(a, try std.fmt.allocPrint(a, "Operation took {d}ms", .{endTime - startTime}));
        return .{ .first = result, .second = endTime - startTime };
    }
    fn getCurrentTimeMillis(_: *FunctionalSideEffects) i64 {
        return 0;
    }
};

// Closure object for measureAndExecute: reverse each string, join with ','.
const ReverseJoinOp = struct {
    items: []const Str,
    fn apply(self: ReverseJoinOp, a: std.mem.Allocator) !Str {
        var buf: std.ArrayList(u8) = .empty;
        for (self.items, 0..) |s, i| {
            if (i != 0) try buf.append(a, ',');
            try buf.appendSlice(a, try reverseString(a, s));
        }
        return buf.toOwnedSlice(a);
    }
};

const FunctionalChain = struct {
    handlers: std.ArrayList(ChainOp) = .empty,
    fn addHandler(self: *FunctionalChain, a: std.mem.Allocator, h: ChainOp) !*FunctionalChain {
        try self.handlers.append(a, h);
        return self;
    }
    fn handle(self: *const FunctionalChain, a: std.mem.Allocator, input: Str) !?Str {
        var current: ?Str = input;
        for (self.handlers.items) |h| current = if (current) |c| try h(a, c) else null;
        return current;
    }
    fn handleWithFallback(self: *const FunctionalChain, a: std.mem.Allocator, input: Str, fallback: StrOp) !Str {
        return (try self.handle(a, input)) orelse try fallback(a, input);
    }
};

// Chain handler lambdas (short-circuit to null).
fn chainUpper(a: std.mem.Allocator, s: Str) !?Str {
    return if (s.len > 0) try upperStr(a, s) else null;
}
fn chainLong(a: std.mem.Allocator, s: Str) !?Str {
    return if (s.len > 3) try std.fmt.allocPrint(a, "LONG_{s}", .{s}) else null;
}
fn chainReplaceL(a: std.mem.Allocator, s: Str) !?Str {
    if (std.mem.indexOfScalar(u8, s, 'L') == null) return null;
    const out = try a.dupe(u8, s);
    for (out) |*ch| if (ch.* == 'L') {
        ch.* = 'X';
    };
    return out;
}

// Higher-order chaining: trim -> lower -> spaces_to_'_' -> "final_" prefix.
fn finalProcess(a: std.mem.Allocator, s: Str) !Str {
    const t = try trimStr(a, s);
    const low = try lowerStr(a, t);
    const us = try spaceToUnderscore(a, low);
    return std.fmt.allocPrint(a, "final_{s}", .{us});
}

// Functional error handling via toIntOrNull.
fn safeProcess(input: Str) ?Str {
    const parsed = toIntOrNull(input) orelse return null;
    if (parsed > 0) return "positive";
    if (parsed < 0) return "negative";
    return "zero";
}

// Sinks for callbacks/handlers (closures over external state become sinks that
// keep their input observable so nothing is optimized away).
fn eventLogHandler(s: Str) void {
    std.mem.doNotOptimizeAway(s.len);
}
fn eventCountHandler(s: Str) void {
    std.mem.doNotOptimizeAway(s.len);
}
fn asyncSink(s: Str) void {
    std.mem.doNotOptimizeAway(s.len);
}
fn callbackSink(s: Str) void {
    std.mem.doNotOptimizeAway(s.len);
}
fn doTheWork(a: std.mem.Allocator) !void {
    var dataProcessor: DataProcessor = .{};
    var eventHandler: EventHandler = .{};
    var sideEffects: FunctionalSideEffects = .{};
    const lambdaFactory: LambdaFactory = .{};
    var functionalChain: FunctionalChain = .{};

    const numbers = [_]i64{ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 };
    const strings = [_]Str{ "hello", "world", "functional", "programming", "kotlin", "lambdas" };

    // Map / filter / fold via the generic higher-order utilities.
    const doubled = try FunctionalUtils.map(a, i64, i64, &numbers, &dblAlloc);
    const uppercased = try FunctionalUtils.map(a, Str, Str, &strings, &upperStr);
    const lengths = try FunctionalUtils.map(a, Str, i64, &strings, &strLenAlloc);
    const evens = try FunctionalUtils.filter(a, i64, &numbers, &isEven);
    const longStrings = try FunctionalUtils.filter(a, Str, &strings, &lenGt5);
    const validStrings = try FunctionalUtils.filter(a, Str, &strings, lambdaFactory.createValidator());
    const sum = FunctionalUtils.fold(i64, i64, &numbers, 0, &addI64);
    const maxLength = FunctionalUtils.fold(Str, i64, &strings, 0, &maxLenOp);
    // Fold producing a concatenated string (allocating reduce done inline).
    var concatBuf: std.ArrayList(u8) = .empty;
    for (strings) |s| try concatBuf.print(a, " {s}", .{s});
    const concatenated = try concatBuf.toOwnedSlice(a);

    // Function composition and currying/partial application.
    const composed = FunctionalUtils.compose(i64, i64, i64, add10, multiplyBy2);
    var composedResults: std.ArrayList(i64) = .empty;
    for (numbers) |n| try composedResults.append(a, composed(n));
    const add5 = Curried(add){ .x = 5 };
    var addedResults: std.ArrayList(i64) = .empty;
    for (numbers) |n| try addedResults.append(a, add5.apply(n));

    // Data processing pipeline.
    _ = try dataProcessor.addProcessor(a, &trimStr);
    _ = try dataProcessor.addProcessor(a, &lowerStr);
    _ = try dataProcessor.addProcessor(a, &spaceToUnderscore);
    _ = try dataProcessor.addProcessor(a, &processedPrefix);
    const processedStrings = try dataProcessor.processMany(a, &strings);

    // Event handling pipeline.
    _ = try eventHandler.addFilter(a, &validateStr);
    _ = try eventHandler.addFilter(a, &lenGt4);
    _ = try eventHandler.addTransformer(a, &upperStr);
    _ = try eventHandler.addTransformer(a, &eventPrefix);
    _ = try eventHandler.addHandler(a, &eventLogHandler);
    _ = try eventHandler.addHandler(a, &eventCountHandler);
    try eventHandler.handleMany(a, &strings);

    // Stream operations over numbers.
    const stream = FunctionalStream(i64){ .data = &numbers };
    const streamFiltered = try stream.filter(a, &gt3);
    const streamMapped = try streamFiltered.map(a, i64, &mul3Alloc);
    const streamTaken = streamMapped.take(5);
    const streamResult = streamTaken.fold(i64, 0, &addI64);

    // Stream operations over strings.
    const stringStream = FunctionalStream(Str){ .data = &strings };
    const stringFiltered = try stringStream.filter(a, &lenGt4);
    const stringMapped = try stringFiltered.map(a, Str, &upperStr);
    var groupedResults = try stringMapped.groupBy(a, &firstCharStr);

    // Nested lambda + FizzBuzz.
    const doubleDouble = lambdaFactory.createNestedFunction(&multiplyBy2);
    var nestedResults: std.ArrayList(i64) = .empty;
    for (numbers) |n| try nestedResults.append(a, doubleDouble.apply(n));
    const conditionalFunc = lambdaFactory.createConditionalFunction();
    var fizzBuzzResults: std.ArrayList(Str) = .empty;
    var fb: i64 = 1;
    while (fb <= 20) : (fb += 1) try fizzBuzzResults.append(a, try conditionalFunc(a, fb));

    // Side effects.
    const countedStrings = try sideEffects.countAndFilter(a, &strings, struct {
        fn hasA(s: Str) bool {
            return std.mem.indexOfScalar(u8, s, 'a') != null;
        }
    }.hasA);
    const measured = try sideEffects.measureAndExecute(a, ReverseJoinOp{ .items = &strings });
    const measuredResult = measured.first;
    const duration = measured.second;

    // Functional chain.
    _ = try functionalChain.addHandler(a, &chainUpper);
    _ = try functionalChain.addHandler(a, &chainLong);
    _ = try functionalChain.addHandler(a, &chainReplaceL);
    var chainResults: std.ArrayList(Str) = .empty;
    for (strings) |s| if (try functionalChain.handle(a, s)) |h| try chainResults.append(a, h);

    // Complex: filter>3 -> reverse -> group by length -> join upper with '|'.
    var complexFiltered: std.ArrayList(Str) = .empty;
    for (strings) |s| if (s.len > 3) try complexFiltered.append(a, try reverseString(a, s));
    var complexGrouped: std.AutoHashMapUnmanaged(usize, std.ArrayList(Str)) = .empty;
    for (complexFiltered.items) |it| {
        const gop = try complexGrouped.getOrPut(a, it.len);
        if (!gop.found_existing) gop.value_ptr.* = .empty;
        try gop.value_ptr.append(a, it);
    }
    var complexResults: std.AutoHashMapUnmanaged(usize, Str) = .empty;
    var cit = complexGrouped.iterator();
    while (cit.next()) |e| {
        var joined: std.ArrayList(u8) = .empty;
        for (e.value_ptr.items, 0..) |it, i| {
            if (i != 0) try joined.append(a, '|');
            try joined.appendSlice(a, try upperStr(a, it));
        }
        if (joined.items.len > 10) try complexResults.put(a, e.key_ptr.*, try joined.toOwnedSlice(a));
    }

    // Higher-order function chaining + functional error handling.
    const finalResults = try FunctionalUtils.map(a, Str, Str, &strings, &finalProcess);
    const errorInputs = [_]Str{ "1", "abc", "-5", "0", "xyz" };
    var errorHandledResults: std.ArrayList(Str) = .empty;
    for (errorInputs) |v| if (safeProcess(v)) |m| try errorHandledResults.append(a, m);

    // Remaining API surface (flatMap, partial, pipe, bind, unit, async,
    // conditional, callback, the rest of the stream ops, factory closures).
    const flatMapped = try FunctionalUtils.flatMap(a, i64, i64, &numbers, &explodeNum);
    const partialAdd = Curried(add){ .x = 100 };
    var partialResults: std.ArrayList(i64) = .empty;
    for (numbers) |n| try partialResults.append(a, partialAdd.apply(n));
    const piped = FunctionalUtils.pipe(5, &.{ &multiplyBy2, &add10 });
    const bound = FunctionalUtils.bind(i64, i64, 7, &times3Maybe);
    const maybe = FunctionalUtils.bind(i64, i64, null, &times3Maybe);
    const unitList = try FunctionalUtils.unit(a, Str, "solo");

    try dataProcessor.processAsync(a, "async input", &asyncSink);
    const conditional = try dataProcessor.processConditional(a, "cond", &lenGt4, &condPrefix);
    try eventHandler.handleWithCallback(a, "direct", &callbackSink);

    const baseStringStream = FunctionalStream(Str){ .data = &strings };
    const flatStream = try baseStringStream.flatMap(a, Str, &splitChars);
    flatStream.forEach(&struct {
        fn noop(_: Str) void {}
    }.noop);
    const flatStreamList = flatStream.toList();
    const reduceStream = FunctionalStream(i64){ .data = &numbers };
    const streamReduced = reduceStream.reduce(&add);
    const dropStream = FunctionalStream(i64){ .data = &numbers };
    const dropped = dropStream.drop(3).toList();
    const zipStream = FunctionalStream(i64){ .data = &numbers };
    const zipped = try zipStream.zip(a, FunctionalStream(i64){ .data = doubled });
    const sortSrc = [_]i64{ 3, 1, 2 };
    const sortStream = FunctionalStream(i64){ .data = &sortSrc };
    const sorted = (try sortStream.sortedBy(a, selectorId)).toList();
    const distinctSrc = [_]i64{ 1, 1, 2, 3, 3 };
    const distinctStream = FunctionalStream(i64){ .data = &distinctSrc };
    const distinctValues = (try distinctStream.distinct(a)).toList();

    const numberFn = lambdaFactory.createNumberProcessor(3);
    const numberFnResult = numberFn.apply(4);
    const stringFn = lambdaFactory.createStringProcessor("prefix");
    const stringFnResult = try stringFn.apply(a, "body");
    const transformer = lambdaFactory.createTransformer();
    const transformed = try transformer(a, "hello world functional");
    const aggregator = lambdaFactory.createAggregator();
    const aggregated = aggregator(&numbers);
    const complexProcessor = lambdaFactory.createComplexProcessor();
    var complexMap = try complexProcessor(a, &strings);
    const fallbackResult = try functionalChain.handleWithFallback(a, "", &fallbackPrefix);
    // Exercise logAndProcess directly (the TS handler captures sideEffects).
    const logged = try sideEffects.logAndProcess(a, "entry", &loggedPrefix);

    std.mem.doNotOptimizeAway(doubled.len);
    std.mem.doNotOptimizeAway(uppercased.len);
    std.mem.doNotOptimizeAway(lengths.len);
    std.mem.doNotOptimizeAway(evens.len);
    std.mem.doNotOptimizeAway(longStrings.len);
    std.mem.doNotOptimizeAway(validStrings.len);
    std.mem.doNotOptimizeAway(sum);
    std.mem.doNotOptimizeAway(maxLength);
    std.mem.doNotOptimizeAway(concatenated.len);
    std.mem.doNotOptimizeAway(composedResults.items.len);
    std.mem.doNotOptimizeAway(addedResults.items.len);
    std.mem.doNotOptimizeAway(processedStrings.len);
    std.mem.doNotOptimizeAway(streamResult);
    std.mem.doNotOptimizeAway(groupedResults.count());
    std.mem.doNotOptimizeAway(nestedResults.items.len);
    std.mem.doNotOptimizeAway(fizzBuzzResults.items.len);
    std.mem.doNotOptimizeAway(countedStrings.len);
    std.mem.doNotOptimizeAway(measuredResult.len);
    std.mem.doNotOptimizeAway(duration);
    std.mem.doNotOptimizeAway(chainResults.items.len);
    std.mem.doNotOptimizeAway(complexResults.count());
    std.mem.doNotOptimizeAway(finalResults.len);
    std.mem.doNotOptimizeAway(errorHandledResults.items.len);
    std.mem.doNotOptimizeAway(flatMapped.len);
    std.mem.doNotOptimizeAway(partialResults.items.len);
    std.mem.doNotOptimizeAway(piped);
    std.mem.doNotOptimizeAway(bound.?);
    std.mem.doNotOptimizeAway(@intFromBool(maybe == null));
    std.mem.doNotOptimizeAway(unitList.len);
    std.mem.doNotOptimizeAway(conditional.len);
    std.mem.doNotOptimizeAway(flatStreamList.len);
    std.mem.doNotOptimizeAway(streamReduced);
    std.mem.doNotOptimizeAway(dropped.len);
    std.mem.doNotOptimizeAway(zipped.len);
    std.mem.doNotOptimizeAway(sorted.len);
    std.mem.doNotOptimizeAway(distinctValues.len);
    std.mem.doNotOptimizeAway(numberFnResult);
    std.mem.doNotOptimizeAway(stringFnResult.len);
    std.mem.doNotOptimizeAway(transformed.len);
    std.mem.doNotOptimizeAway(aggregated);
    std.mem.doNotOptimizeAway(complexMap.count());
    std.mem.doNotOptimizeAway(fallbackResult.len);
    std.mem.doNotOptimizeAway(logged.len);
    std.mem.doNotOptimizeAway(sideEffects.logs.items.len);
    std.mem.doNotOptimizeAway(sideEffects.counters.count());
}

pub fn runBenchmark() void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    doTheWork(arena.allocator()) catch {};
}

export fn bench_run() void {
    runBenchmark();
}
