// iOS Size Benchmark - Test Case Implementation
// Generated with Claude AI (https://claude.ai)
//
// Zig port of the "collection-minimal" case. Idiomatic Zig: explicit allocator
// (a per-run arena), unmanaged std containers, error unions. A single exported
// entry (bench_run -> runBenchmark) exercises every type so nothing is
// dead-code eliminated, matching the Swift `public` requirement.

const std = @import("std");

const MinimalCollectionProcessor = struct {
    fn processBasicArray(a: std.mem.Allocator, size: usize) ![]i64 {
        var list: std.ArrayList(i64) = .empty;
        var i: usize = 0;
        while (i < size) : (i += 1) try list.append(a, @as(i64, @intCast(i)) * 2);
        for (list.items) |*v| v.* += 1;
        return list.toOwnedSlice(a);
    }

    fn processBasicList(a: std.mem.Allocator, size: usize) ![][]u8 {
        var list: std.ArrayList([]u8) = .empty;
        var i: usize = 0;
        while (i < size) : (i += 1)
            try list.append(a, try std.fmt.allocPrint(a, "Item{d}", .{i}));
        return list.toOwnedSlice(a);
    }

    fn processBasicMap(a: std.mem.Allocator, size: usize) !std.AutoHashMapUnmanaged(i64, []u8) {
        var dict: std.AutoHashMapUnmanaged(i64, []u8) = .empty;
        var i: usize = 0;
        while (i < size) : (i += 1)
            try dict.put(a, @intCast(i), try std.fmt.allocPrint(a, "Value{d}", .{i}));
        return dict;
    }

    fn filterEvenNumbers(a: std.mem.Allocator, numbers: []const i64) ![]i64 {
        var result: std.ArrayList(i64) = .empty;
        for (numbers) |num| if (@mod(num, 2) == 0) try result.append(a, num);
        return result.toOwnedSlice(a);
    }

    fn doubleNumbers(a: std.mem.Allocator, numbers: []const i64) ![]i64 {
        var result: std.ArrayList(i64) = .empty;
        for (numbers) |num| try result.append(a, num * 2);
        return result.toOwnedSlice(a);
    }

    fn sumNumbers(numbers: []const i64) i64 {
        var sum: i64 = 0;
        for (numbers) |num| sum += num;
        return sum;
    }

    fn findFirst(numbers: []const i64, target: i64) i64 {
        for (numbers, 0..) |n, i| if (n == target) return @intCast(i);
        return -1;
    }

    fn simpleSort(a: std.mem.Allocator, numbers: []const i64) ![]i64 {
        const result = try a.dupe(i64, numbers);
        const n = result.len;
        if (n == 0) return result;
        var i: usize = 0;
        while (i < n - 1) : (i += 1) {
            var j: usize = 0;
            while (j < n - i - 1) : (j += 1) {
                if (result[j] > result[j + 1]) {
                    const tmp = result[j];
                    result[j] = result[j + 1];
                    result[j + 1] = tmp;
                }
            }
        }
        return result;
    }
};

const SimpleUser = struct { id: i64, name: []const u8 };
const SimpleProduct = struct { id: i64, price: f64 };

const MinimalDataProcessor = struct {
    fn createUsers(a: std.mem.Allocator, count: usize) ![]SimpleUser {
        var users: std.ArrayList(SimpleUser) = .empty;
        var i: usize = 0;
        while (i < count) : (i += 1)
            try users.append(a, .{ .id = @intCast(i), .name = try std.fmt.allocPrint(a, "User{d}", .{i}) });
        return users.toOwnedSlice(a);
    }

    fn createProducts(a: std.mem.Allocator, count: usize) ![]SimpleProduct {
        var products: std.ArrayList(SimpleProduct) = .empty;
        var i: usize = 0;
        while (i < count) : (i += 1)
            try products.append(a, .{ .id = @intCast(i), .price = 10.0 + @as(f64, @floatFromInt(i)) });
        return products.toOwnedSlice(a);
    }

    fn processUserData(a: std.mem.Allocator, users: []const SimpleUser) ![]u8 {
        var buf: std.ArrayList(u8) = .empty;
        for (users) |u| try buf.print(a, "{d}:{s};", .{ u.id, u.name });
        return buf.toOwnedSlice(a);
    }

    fn calculateTotal(products: []const SimpleProduct) f64 {
        var total: f64 = 0.0;
        for (products) |p| total += p.price;
        return total;
    }
};

fn runMinimalTest(a: std.mem.Allocator) !void {
    const array = try MinimalCollectionProcessor.processBasicArray(a, 100);
    const doubled = try MinimalCollectionProcessor.doubleNumbers(a, array);
    const filtered = try MinimalCollectionProcessor.filterEvenNumbers(a, doubled);
    const sorted = try MinimalCollectionProcessor.simpleSort(a, filtered);
    const sum = MinimalCollectionProcessor.sumNumbers(sorted);
    const index = MinimalCollectionProcessor.findFirst(sorted, 50);

    const stringArray = try MinimalCollectionProcessor.processBasicList(a, 50);
    var dictionary = try MinimalCollectionProcessor.processBasicMap(a, 50);

    const users = try MinimalDataProcessor.createUsers(a, 20);
    const products = try MinimalDataProcessor.createProducts(a, 20);
    const userData = try MinimalDataProcessor.processUserData(a, users);
    const total = MinimalDataProcessor.calculateTotal(products);

    std.mem.doNotOptimizeAway(array.len);
    std.mem.doNotOptimizeAway(doubled.len);
    std.mem.doNotOptimizeAway(filtered.len);
    std.mem.doNotOptimizeAway(sorted.len);
    std.mem.doNotOptimizeAway(sum);
    std.mem.doNotOptimizeAway(index);
    std.mem.doNotOptimizeAway(stringArray.len);
    std.mem.doNotOptimizeAway(dictionary.count());
    std.mem.doNotOptimizeAway(users.len);
    std.mem.doNotOptimizeAway(products.len);
    std.mem.doNotOptimizeAway(userData.len);
    std.mem.doNotOptimizeAway(total);
}

pub fn runBenchmark() void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    runMinimalTest(arena.allocator()) catch {};
}

export fn bench_run() void {
    runBenchmark();
}
