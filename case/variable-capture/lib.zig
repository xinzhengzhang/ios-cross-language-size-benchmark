// iOS Size Benchmark - Test Case Implementation
// Generated with Claude AI (https://claude.ai)
//
// Zig port of the "variable-capture" case. This case is all about closures
// capturing many surrounding variables (strings, arrays, maps, mutable string
// builders, byte arrays, numbers, object refs), including nested and recursive
// closures. Zig has NO closures, so the idiomatic mapping — and the whole point
// of this port — is: each capturing closure becomes an explicit struct that
// stores the captured fields and exposes a `call` method. The captured state is
// made visible in the type instead of hidden in a compiler-synthesized
// environment. Stateless work stays as plain functions.
//
// Other idiom mappings: Kotlin `data class`/Swift `class` -> plain struct;
// `StringBuilder`/`NSMutableString` -> a small MutableString over an unmanaged
// ArrayList(u8); `List<Any>`/`Map<String, Any>` -> a narrow `Scalar`/
// `CaptureValue` tagged union (the honest set of values this case stores),
// matching the scriptc tier. Printing is dropped and replaced with
// `doNotOptimizeAway` so every capture is observably used. The Kotlin/Swift
// "async" lambda is invoked directly, so this port stays synchronous too.

const std = @import("std");
const Allocator = std.mem.Allocator;

// `string | number` from the TS source.
const Scalar = union(enum) {
    str: []const u8,
    num: i64,
};

// `string | number | Scalar[]` — every value kind stored in the dicts.
const CaptureValue = union(enum) {
    str: []const u8,
    num: i64,
    arr: []const Scalar,
};

const CaptureMap = std.StringHashMapUnmanaged(CaptureValue);
const Entry = struct { key: []const u8, val: CaptureValue };

fn makeMap(a: Allocator, entries: []const Entry) !CaptureMap {
    var m: CaptureMap = .empty;
    for (entries) |e| try m.put(a, e.key, e.val);
    return m;
}

// Consume a captured value so the capture is not dead-code eliminated; stands
// in for the TS `console.log` of each item.
fn useScalar(s: Scalar) void {
    switch (s) {
        .str => |x| std.mem.doNotOptimizeAway(x.len),
        .num => |x| std.mem.doNotOptimizeAway(x),
    }
}
fn useValue(v: CaptureValue) void {
    switch (v) {
        .str => |x| std.mem.doNotOptimizeAway(x.len),
        .num => |x| std.mem.doNotOptimizeAway(x),
        .arr => |x| std.mem.doNotOptimizeAway(x.len),
    }
}

// Mirrors the mutable, by-reference capture semantics of StringBuilder /
// NSMutableString: closures capture a *pointer* and mutate shared state.
const MutableString = struct {
    value: std.ArrayList(u8) = .empty,

    fn init(a: Allocator, initial: []const u8) !MutableString {
        var m: MutableString = .{};
        try m.value.appendSlice(a, initial);
        return m;
    }
    fn append(self: *MutableString, a: Allocator, s: []const u8) !void {
        try self.value.appendSlice(a, s);
    }
    fn len(self: MutableString) usize {
        return self.value.items.len;
    }
};

// All strings in this case are ASCII, so their UTF-8 encoding is the byte
// slice itself; only the resulting length is observed. (`ByteArray` / `Data`.)
fn utf8Encode(a: Allocator, text: []const u8) ![]const u8 {
    return a.dupe(u8, text);
}

// Kotlin `data class DataContainer`; only field access is exercised.
const DataContainer = struct {
    stringValue: []const u8,
    arrayValue: []const Scalar,
    dictValue: CaptureMap,
    mutableString: *MutableString,
    dataValue: []const u8,
};

// --- The closures, modeled as explicit capture structs. ---------------------

// Innermost closure: captures str2, container2, and a *mutable* ref it appends
// to ("_deep"). Built from the enclosing NestedClosure's own captures.
const DeepClosure = struct {
    str2: []const u8,
    container2: DataContainer,
    mutable2: *MutableString,

    fn call(self: DeepClosure, a: Allocator) !void {
        std.mem.doNotOptimizeAway(self.str2.len);
        std.mem.doNotOptimizeAway(self.container2.stringValue.len);
        try self.mutable2.append(a, "_deep");
    }
};

// Middle closure: captures a subset of the outer locals and in turn constructs
// the DeepClosure from those captures — the explicit form of nested capture.
const NestedClosure = struct {
    str1: []const u8,
    str2: []const u8,
    str3: []const u8,
    container1: DataContainer,
    container2: DataContainer,
    container3: DataContainer,
    num1: f64,
    num3: f64,
    mutable2: *MutableString,

    fn call(self: NestedClosure, a: Allocator) !void {
        std.mem.doNotOptimizeAway(self.str1.len);
        std.mem.doNotOptimizeAway(self.str3.len);
        std.mem.doNotOptimizeAway(self.container1.stringValue.len);
        std.mem.doNotOptimizeAway(self.container3.stringValue.len);
        std.mem.doNotOptimizeAway(self.num1);
        std.mem.doNotOptimizeAway(self.num3);

        const deep = DeepClosure{
            .str2 = self.str2,
            .container2 = self.container2,
            .mutable2 = self.mutable2,
        };
        try deep.call(a);
    }
};

// The big closure capturing "many variables": five of every kind, plus a
// pointer to the service so it can update the shared sink. Captures are stored
// as fixed arrays; `mutables` is a pointer-to-array so appends mutate the
// originals (by-reference capture).
const ComplexClosure = struct {
    strs: [5][]const u8,
    arrays: [5][]const Scalar,
    dicts: [5]CaptureMap,
    mutables: *[5]MutableString,
    datas: [5][]const u8,
    containers: [5]DataContainer,
    nums: [5]f64,
    svc: *CaptureTestService,

    fn call(self: ComplexClosure, a: Allocator) !void {
        for (self.strs) |s| std.mem.doNotOptimizeAway(s.len);
        for (self.arrays) |arr| for (arr) |s| useScalar(s);
        for (self.dicts) |d| {
            var it = d.valueIterator();
            while (it.next()) |v| useValue(v.*);
        }
        for (self.mutables) |*m| try m.append(a, "_modified");
        for (self.datas) |dta| std.mem.doNotOptimizeAway(dta.len);
        for (self.containers) |c| std.mem.doNotOptimizeAway(c.stringValue.len);

        var calculation: f64 = 0;
        for (self.nums) |n| calculation += n;
        self.svc.sink += @as(i64, @intFromFloat(@trunc(calculation))) +
            @as(i64, @intCast(self.mutables[0].len())) +
            @as(i64, @intCast(self.containers[4].dataValue.len));

        const nested = NestedClosure{
            .str1 = self.strs[0],
            .str2 = self.strs[1],
            .str3 = self.strs[2],
            .container1 = self.containers[0],
            .container2 = self.containers[1],
            .container3 = self.containers[2],
            .num1 = self.nums[0],
            .num3 = self.nums[2],
            .mutable2 = &self.mutables[1],
        };
        try nested.call(a);
    }
};

// The directly-invoked "async" closure: a small subset of the captures.
const AsyncClosure = struct {
    str1: []const u8,
    str5: []const u8,
    container1: DataContainer,
    num1: f64,
    num5: f64,
    svc: *CaptureTestService,

    fn call(self: AsyncClosure) void {
        std.mem.doNotOptimizeAway(self.str1.len);
        std.mem.doNotOptimizeAway(self.str5.len);
        std.mem.doNotOptimizeAway(self.container1.stringValue.len);
        const asyncCalc = self.num1 * self.num5;
        self.svc.sink += @as(i64, @intFromFloat(@trunc(asyncCalc)));
    }
};

// The recursive closure: captures its depth-local state and a service pointer,
// then recurses through the service (the explicit form of a self-referential
// capturing lambda).
const RecursiveClosure = struct {
    depth: i64,
    depthString: []const u8,
    depthArray: []const Scalar,
    depthDict: CaptureMap,
    depthMutable: *MutableString,
    depthData: []const u8,
    svc: *CaptureTestService,

    fn call(self: RecursiveClosure, a: Allocator) Allocator.Error!void {
        std.mem.doNotOptimizeAway(self.depthString.len);
        for (self.depthArray) |s| useScalar(s);
        var it = self.depthDict.valueIterator();
        while (it.next()) |v| useValue(v.*);

        try self.depthMutable.append(a, "_processed");
        self.svc.sink += @as(i64, @intCast(self.depthMutable.len())) +
            @as(i64, @intCast(self.depthData.len));

        try self.svc.nestedCaptureTest(a, self.depth - 1);
    }
};

const CaptureTestService = struct {
    // Accumulated so the captured work is observably used.
    sink: i64 = 0,

    fn performVariableCaptureStressTest(self: *CaptureTestService, a: Allocator) !void {
        var i: i64 = 1;
        while (i <= 1000) : (i += 1) {
            try self.createComplexClosureWithManyCaptures(a, i);
            if (@mod(i, 100) == 0) try self.nestedCaptureTest(a, 10);
        }
    }

    fn createComplexClosureWithManyCaptures(self: *CaptureTestService, a: Allocator, iteration: i64) !void {
        const strs: [5][]const u8 = .{
            try std.fmt.allocPrint(a, "String_{d}", .{iteration}),
            try std.fmt.allocPrint(a, "AnotherString_{d}", .{iteration * 2}),
            try std.fmt.allocPrint(a, "ThirdString_{d}", .{iteration * 3}),
            try std.fmt.allocPrint(a, "FourthString_{d}", .{iteration * 4}),
            try std.fmt.allocPrint(a, "FifthString_{d}", .{iteration * 5}),
        };

        const arrays: [5][]const Scalar = .{
            try a.dupe(Scalar, &[_]Scalar{ .{ .num = iteration }, .{ .num = iteration * 2 }, .{ .num = iteration * 3 } }),
            try a.dupe(Scalar, &[_]Scalar{ .{ .str = strs[0] }, .{ .str = strs[1] }, .{ .str = strs[2] } }),
            try a.dupe(Scalar, &[_]Scalar{ .{ .num = iteration + 100 }, .{ .num = iteration + 200 }, .{ .num = iteration + 300 } }),
            try a.dupe(Scalar, &[_]Scalar{ .{ .str = strs[3] }, .{ .str = strs[4] }, .{ .str = try std.fmt.allocPrint(a, "Extra_{d}", .{iteration}) } }),
            try a.dupe(Scalar, &[_]Scalar{ .{ .num = @mod(iteration, 10) }, .{ .num = @mod(iteration, 20) }, .{ .num = @mod(iteration, 30) } }),
        };

        const dicts: [5]CaptureMap = .{
            try makeMap(a, &[_]Entry{ .{ .key = "key1", .val = .{ .str = strs[0] } }, .{ .key = "key2", .val = .{ .num = iteration } }, .{ .key = "key3", .val = .{ .arr = arrays[0] } } }),
            try makeMap(a, &[_]Entry{ .{ .key = "data", .val = .{ .str = strs[1] } }, .{ .key = "count", .val = .{ .num = iteration * 2 } }, .{ .key = "items", .val = .{ .arr = arrays[1] } } }),
            try makeMap(a, &[_]Entry{ .{ .key = "id", .val = .{ .num = iteration } }, .{ .key = "name", .val = .{ .str = strs[2] } }, .{ .key = "values", .val = .{ .arr = arrays[2] } } }),
            try makeMap(a, &[_]Entry{ .{ .key = "type", .val = .{ .str = strs[3] } }, .{ .key = "index", .val = .{ .num = iteration * 4 } }, .{ .key = "list", .val = .{ .arr = arrays[3] } } }),
            try makeMap(a, &[_]Entry{ .{ .key = "category", .val = .{ .str = strs[4] } }, .{ .key = "size", .val = .{ .num = iteration * 5 } }, .{ .key = "elements", .val = .{ .arr = arrays[4] } } }),
        };

        var mutables: [5]MutableString = undefined;
        mutables[0] = try MutableString.init(a, try std.fmt.allocPrint(a, "Mutable_{d}", .{iteration}));
        mutables[1] = try MutableString.init(a, try std.fmt.allocPrint(a, "Dynamic_{d}", .{iteration * 2}));
        mutables[2] = try MutableString.init(a, try std.fmt.allocPrint(a, "Buffer_{d}", .{iteration * 3}));
        mutables[3] = try MutableString.init(a, try std.fmt.allocPrint(a, "Content_{d}", .{iteration * 4}));
        mutables[4] = try MutableString.init(a, try std.fmt.allocPrint(a, "Text_{d}", .{iteration * 5}));

        const datas: [5][]const u8 = .{
            try utf8Encode(a, strs[0]),
            try utf8Encode(a, strs[1]),
            try utf8Encode(a, strs[2]),
            try utf8Encode(a, strs[3]),
            try utf8Encode(a, strs[4]),
        };

        var containers: [5]DataContainer = undefined;
        for (0..5) |k| containers[k] = .{
            .stringValue = strs[k],
            .arrayValue = arrays[k],
            .dictValue = dicts[k],
            .mutableString = &mutables[k],
            .dataValue = datas[k],
        };

        const it_f: f64 = @floatFromInt(iteration);
        const nums: [5]f64 = .{ it_f, it_f * 1.5, it_f * 2.5, it_f * 3.5, it_f * 4.5 };

        const complex = ComplexClosure{
            .strs = strs,
            .arrays = arrays,
            .dicts = dicts,
            .mutables = &mutables,
            .datas = datas,
            .containers = containers,
            .nums = nums,
            .svc = self,
        };
        try complex.call(a);

        const asyncClosure = AsyncClosure{
            .str1 = strs[0],
            .str5 = strs[4],
            .container1 = containers[0],
            .num1 = nums[0],
            .num5 = nums[4],
            .svc = self,
        };
        asyncClosure.call();
    }

    fn nestedCaptureTest(self: *CaptureTestService, a: Allocator, depth: i64) Allocator.Error!void {
        if (depth <= 0) return;

        const depthString = try std.fmt.allocPrint(a, "Depth_{d}", .{depth});
        const depthArray = try a.dupe(Scalar, &[_]Scalar{ .{ .num = depth }, .{ .num = depth * 10 }, .{ .num = depth * 100 } });
        const depthDict = try makeMap(a, &[_]Entry{
            .{ .key = "level", .val = .{ .num = depth } },
            .{ .key = "data", .val = .{ .str = depthString } },
        });
        var depthMutable = try MutableString.init(a, try std.fmt.allocPrint(a, "Mutable_Depth_{d}", .{depth}));
        const depthData = try utf8Encode(a, depthString);

        const recursive = RecursiveClosure{
            .depth = depth,
            .depthString = depthString,
            .depthArray = depthArray,
            .depthDict = depthDict,
            .depthMutable = &depthMutable,
            .depthData = depthData,
            .svc = self,
        };
        try recursive.call(a);
    }
};

const IosSizeBenchmark = struct {
    captureTestService: CaptureTestService = .{},

    fn runBenchmark(self: *IosSizeBenchmark, a: Allocator) !void {
        try self.captureTestService.performVariableCaptureStressTest(a);
        std.mem.doNotOptimizeAway(self.captureTestService.sink);
    }
};

fn doTheWork(a: Allocator) !void {
    var bench = IosSizeBenchmark{};
    try bench.runBenchmark(a);
}

pub fn runBenchmark() void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    doTheWork(arena.allocator()) catch {};
}

export fn bench_run() void {
    runBenchmark();
}
