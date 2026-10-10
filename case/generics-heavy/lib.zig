// iOS Size Benchmark - Test Case Implementation
// Generated with Claude AI (https://claude.ai)
//
// Zig port of the "generics-heavy" case. Idiomatic Zig models generics with
// comptime `fn(comptime T: type) type` factories (monomorphized per
// instantiation, like C++ templates) and models the TS lambdas as named
// functions / comptime function parameters (Zig has no closures). A single
// exported entry exercises every instantiation so nothing is DCE'd.

const std = @import("std");

// std.AutoHashMap can't hash slices ([]const u8); pick StringHashMap for
// string keys and AutoHashMap otherwise. Both share the same unmanaged API
// (.put(a,k,v) / .get(k) / .count()), so the generic factories below are
// agnostic to which one they get.
fn MapType(comptime K: type, comptime V: type) type {
    return if (K == []const u8)
        std.StringHashMapUnmanaged(V)
    else
        std.AutoHashMapUnmanaged(K, V);
}

fn Container(comptime T: type) type {
    return struct {
        value: T,
        const Self = @This();
        fn get(self: Self) T {
            return self.value;
        }
        fn map(self: Self, comptime R: type, transform: fn (T) R) Container(R) {
            return .{ .value = transform(self.value) };
        }
        fn flatMap(self: Self, comptime R: type, transform: fn (T) Container(R)) Container(R) {
            return transform(self.value);
        }
    };
}

fn Pair(comptime T: type, comptime U: type) type {
    return struct {
        first: T,
        second: U,
        const Self = @This();
        fn mapFirst(self: Self, comptime R: type, transform: fn (T) R) Pair(R, U) {
            return .{ .first = transform(self.first), .second = self.second };
        }
        fn mapSecond(self: Self, comptime R: type, transform: fn (U) R) Pair(T, R) {
            return .{ .first = self.first, .second = transform(self.second) };
        }
        fn mapBoth(self: Self, comptime R: type, comptime S: type, tf: fn (T) R, ts: fn (U) S) Pair(R, S) {
            return .{ .first = tf(self.first), .second = ts(self.second) };
        }
    };
}

fn Triple(comptime T: type, comptime U: type, comptime V: type) type {
    return struct {
        first: T,
        second: U,
        third: V,
        const Self = @This();
        fn mapFirst(self: Self, comptime R: type, transform: fn (T) R) Triple(R, U, V) {
            return .{ .first = transform(self.first), .second = self.second, .third = self.third };
        }
        fn mapSecond(self: Self, comptime R: type, transform: fn (U) R) Triple(T, R, V) {
            return .{ .first = self.first, .second = transform(self.second), .third = self.third };
        }
        fn mapThird(self: Self, comptime R: type, transform: fn (V) R) Triple(T, U, R) {
            return .{ .first = self.first, .second = self.second, .third = transform(self.third) };
        }
    };
}

fn GenericList(comptime T: type) type {
    return struct {
        items: std.ArrayList(T) = .empty,
        const Self = @This();
        fn add(self: *Self, a: std.mem.Allocator, item: T) !void {
            try self.items.append(a, item);
        }
        fn get(self: Self, index: usize) ?T {
            return if (index < self.items.items.len) self.items.items[index] else null;
        }
        fn map(self: Self, a: std.mem.Allocator, comptime R: type, transform: fn (T) R) !GenericList(R) {
            var result: GenericList(R) = .{};
            for (self.items.items) |it| try result.add(a, transform(it));
            return result;
        }
        fn filter(self: Self, a: std.mem.Allocator, predicate: fn (T) bool) !Self {
            var result: Self = .{};
            for (self.items.items) |it| if (predicate(it)) try result.add(a, it);
            return result;
        }
        fn fold(self: Self, comptime R: type, initial: R, op: fn (R, T) R) R {
            var acc = initial;
            for (self.items.items) |it| acc = op(acc, it);
            return acc;
        }
    };
}

fn GenericMap(comptime K: type, comptime V: type) type {
    return struct {
        items: MapType(K, V) = .empty,
        const Self = @This();
        fn put(self: *Self, a: std.mem.Allocator, key: K, value: V) !void {
            try self.items.put(a, key, value);
        }
        fn get(self: Self, key: K) ?V {
            return self.items.get(key);
        }
    };
}

fn Cache(comptime K: type, comptime V: type) type {
    return struct {
        storage: MapType(K, V) = .empty,
        const Self = @This();
        fn get(self: Self, key: K) ?V {
            return self.storage.get(key);
        }
        fn put(self: *Self, a: std.mem.Allocator, key: K, value: V) !void {
            try self.storage.put(a, key, value);
        }
        fn getOrCompute(self: *Self, a: std.mem.Allocator, key: K, compute: fn (K) V) !V {
            if (self.storage.get(key)) |v| return v;
            const computed = compute(key);
            try self.storage.put(a, key, computed);
            return computed;
        }
    };
}

fn Repository(comptime Entity: type, comptime Id: type) type {
    return struct {
        entities: MapType(Id, Entity) = .empty,
        const Self = @This();
        fn save(self: *Self, a: std.mem.Allocator, id: Id, entity: Entity) !void {
            try self.entities.put(a, id, entity);
        }
        fn findById(self: Self, id: Id) ?Entity {
            return self.entities.get(id);
        }
        fn count(self: Self) usize {
            return self.entities.count();
        }
    };
}

fn Pipeline(comptime T: type) type {
    return struct {
        stages: std.ArrayList(*const fn (T) T) = .empty,
        const Self = @This();
        fn addStage(self: *Self, a: std.mem.Allocator, stage: *const fn (T) T) !void {
            try self.stages.append(a, stage);
        }
        fn execute(self: Self, input: T) T {
            var acc = input;
            for (self.stages.items) |stage| acc = stage(acc);
            return acc;
        }
    };
}

// Named functions standing in for the TS lambdas (Zig has no closures).
fn dbl(x: i64) i64 {
    return x * 2;
}
fn inc(x: i64) i64 {
    return x + 1;
}
fn strLen(s: []const u8) i64 {
    return @intCast(s.len);
}
fn lenGt3(s: []const u8) bool {
    return s.len > 3;
}
fn addLen(acc: i64, s: []const u8) i64 {
    return acc + @as(i64, @intCast(s.len));
}
fn isPositive(x: i64) bool {
    return x > 0;
}
fn identity(x: i64) i64 {
    return x;
}
fn upperFirst(s: []const u8) []const u8 {
    return s; // identity stand-in for a stage
}

fn runGenerics(a: std.mem.Allocator) !void {
    const stringContainer = Container([]const u8){ .value = "test" };
    const numberContainer = Container(i64){ .value = 42 };

    const mappedNumber = numberContainer.map(i64, dbl);
    const flatMapped = numberContainer.flatMap(i64, struct {
        fn f(x: i64) Container(i64) {
            return .{ .value = x + 1 };
        }
    }.f);
    std.mem.doNotOptimizeAway(stringContainer.get().len);
    std.mem.doNotOptimizeAway(mappedNumber.get());
    std.mem.doNotOptimizeAway(flatMapped.get());

    const pair = Pair([]const u8, i64){ .first = "hello", .second = 42 };
    const mappedPair = pair.mapFirst(i64, strLen);
    const bothPair = pair.mapBoth(i64, i64, strLen, inc);
    const triple = Triple([]const u8, i64, i64){ .first = "a", .second = 1, .third = 2 };
    const mappedTriple = triple.mapSecond(i64, dbl);
    std.mem.doNotOptimizeAway(mappedPair.first);
    std.mem.doNotOptimizeAway(bothPair.first + bothPair.second);
    std.mem.doNotOptimizeAway(mappedTriple.second);

    var stringList = GenericList([]const u8){};
    try stringList.add(a, "test");
    try stringList.add(a, "example");
    const firstItem = stringList.get(0);
    const mappedList = try stringList.map(a, i64, strLen);
    const filteredList = try stringList.filter(a, lenGt3);
    const folded = stringList.fold(i64, 0, addLen);
    std.mem.doNotOptimizeAway(firstItem.?.len);
    std.mem.doNotOptimizeAway(mappedList.items.items.len);
    std.mem.doNotOptimizeAway(filteredList.items.items.len);
    std.mem.doNotOptimizeAway(folded);

    var stringMap = GenericMap([]const u8, i64){};
    try stringMap.put(a, "key1", 10);
    try stringMap.put(a, "key2", 20);
    std.mem.doNotOptimizeAway(stringMap.get("key1").?);

    var cache = Cache([]const u8, i64){};
    try cache.put(a, "test", 42);
    const cached = try cache.getOrCompute(a, "new", strLen);
    std.mem.doNotOptimizeAway(cached);
    std.mem.doNotOptimizeAway(cache.get("test").?);

    var repo = Repository([]const u8, i64){};
    try repo.save(a, 1, "entity1");
    try repo.save(a, 2, "entity2");
    std.mem.doNotOptimizeAway(repo.findById(1).?.len);
    std.mem.doNotOptimizeAway(repo.count());

    var pipeline = Pipeline(i64){};
    try pipeline.addStage(a, &dbl);
    try pipeline.addStage(a, &inc);
    std.mem.doNotOptimizeAway(pipeline.execute(10));

    // Interface-style dispatch modeled as plain functions.
    std.mem.doNotOptimizeAway(strLen("hello"));
    std.mem.doNotOptimizeAway(@intFromBool(isPositive(42)));
}

pub fn runBenchmark() void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    runGenerics(arena.allocator()) catch {};
}

export fn bench_run() void {
    runBenchmark();
}
