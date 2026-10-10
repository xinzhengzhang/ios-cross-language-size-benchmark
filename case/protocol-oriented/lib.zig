// iOS Size Benchmark - Test Case Implementation
// Generated with Claude AI (https://claude.ai)
//
// Zig port of the "protocol-oriented" case. Zig has no protocols, so the
// composed `AdvancedShape` protocol (Drawable + Colorable + Transformable +
// Animatable) is modeled idiomatically two ways, mirroring the two dispatch
// styles the source compares:
//   * DYNAMIC (protocol-witness / existential) dispatch -> a `union(enum)`
//     (`Shape` / `InheritanceShape`) dispatched by `switch` with `inline else`.
//     This is the honest Zig analogue of a closed set of conformers behind a
//     runtime-polymorphic reference.
//   * STATIC (generic specialization) dispatch -> a comptime
//     `fn(comptime T: type, ...)` monomorphized per concrete conformer, exactly
//     like Swift's `testGenericDispatch<T: AdvancedShape>`.
// Protocol default implementations (transform / applyColor from Colorable,
// animate from Animatable) become shared code on a common `ShapeBase` plus a
// free function (`defaultAnimate`) the conformers call — the Zig stand-in for
// Swift's `extension` default methods. The inheritance hierarchy keeps its own
// `animate` (it embeds the dynamic type name) to preserve the behavioral
// difference the source benchmarks. A single exported entry exercises every
// type so nothing is dead-code eliminated.

const std = @import("std");
const Allocator = std.mem.Allocator;

// Shared mutable state + protocol default implementations. Colorable.applyColor
// and Transformable.transform live here once and are reused by every conformer.
const ShapeBase = struct {
    id: []const u8,
    color: []const u8,
    scale: f64 = 1.0,
    rotation: f64 = 0.0,

    fn transform(self: *ShapeBase, scale: f64, rotation: f64) void {
        self.scale *= scale;
        self.rotation += rotation;
    }
    fn applyColor(self: *ShapeBase, color: []const u8) void {
        self.color = color;
    }
};

// Animatable default implementation (protocol-extension analogue).
fn defaultAnimate(a: Allocator, duration: f64) ![]u8 {
    return std.fmt.allocPrint(a, "Animating for {d} seconds", .{duration});
}

// --- Concrete conformers (value types implementing AdvancedShape) ----------
const Circle = struct {
    base: ShapeBase,
    radius: f64,
    fn area(self: Circle) f64 {
        return std.math.pi * self.radius * self.radius * self.base.scale * self.base.scale;
    }
    fn draw(self: Circle, a: Allocator) ![]u8 {
        return std.fmt.allocPrint(a, "Drawing circle with radius {d} at rotation {d}", .{ self.radius * self.base.scale, self.base.rotation });
    }
};

const Rectangle = struct {
    base: ShapeBase,
    width: f64,
    height: f64,
    fn area(self: Rectangle) f64 {
        return self.width * self.height * self.base.scale * self.base.scale;
    }
    fn draw(self: Rectangle, a: Allocator) ![]u8 {
        return std.fmt.allocPrint(a, "Drawing rectangle {d}x{d} at rotation {d}", .{ self.width * self.base.scale, self.height * self.base.scale, self.base.rotation });
    }
};

const Triangle = struct {
    base: ShapeBase,
    tbase: f64,
    height: f64,
    fn area(self: Triangle) f64 {
        return 0.5 * self.tbase * self.height * self.base.scale * self.base.scale;
    }
    fn draw(self: Triangle, a: Allocator) ![]u8 {
        return std.fmt.allocPrint(a, "Drawing triangle with base {d} and height {d}", .{ self.tbase * self.base.scale, self.height * self.base.scale });
    }
};

// AdvancedShape as a tagged union -> dynamic (witness-table-style) dispatch.
// `inline else` generates one switch prong per variant so each delegates to the
// concrete method, the Zig analogue of a protocol witness table lookup.
const Shape = union(enum) {
    circle: Circle,
    rectangle: Rectangle,
    triangle: Triangle,

    fn id(self: Shape) []const u8 {
        return switch (self) {
            inline else => |v| v.base.id,
        };
    }
    fn color(self: Shape) []const u8 {
        return switch (self) {
            inline else => |v| v.base.color,
        };
    }
    fn area(self: Shape) f64 {
        return switch (self) {
            inline else => |v| v.area(),
        };
    }
    fn draw(self: Shape, a: Allocator) ![]u8 {
        return switch (self) {
            inline else => |v| v.draw(a),
        };
    }
    // Animatable default implementation shared by all conformers.
    fn animate(self: Shape, a: Allocator, duration: f64) ![]u8 {
        _ = self;
        return defaultAnimate(a, duration);
    }
    // Mutable protocol methods route through the shared ShapeBase defaults.
    fn basePtr(self: *Shape) *ShapeBase {
        return switch (self.*) {
            inline else => |*v| &v.base,
        };
    }
    fn transform(self: *Shape, scale: f64, rotation: f64) void {
        self.basePtr().transform(scale, rotation);
    }
    fn applyColor(self: *Shape, c: []const u8) void {
        self.basePtr().applyColor(c);
    }
};

// Drawable default implementation (protocol-extension analogue).
fn describeShape(a: Allocator, shape: Shape) ![]u8 {
    return std.fmt.allocPrint(a, "Shape with area: {d}", .{shape.area()});
}

// --- Inheritance hierarchy (comparison tier) ------------------------------
// Same shapes, but animate() embeds the concrete type name, so it cannot share
// the Animatable default — it stays variant-specific via its own switch.
const InheritanceShape = union(enum) {
    circle: Circle,
    rectangle: Rectangle,
    triangle: Triangle,

    fn area(self: InheritanceShape) f64 {
        return switch (self) {
            inline else => |v| v.area(),
        };
    }
    fn draw(self: InheritanceShape, a: Allocator) ![]u8 {
        return switch (self) {
            inline else => |v| v.draw(a),
        };
    }
    fn simpleName(self: InheritanceShape) []const u8 {
        return switch (self) {
            .circle => "InheritanceCircle",
            .rectangle => "InheritanceRectangle",
            .triangle => "InheritanceTriangle",
        };
    }
    fn animate(self: InheritanceShape, a: Allocator, duration: f64) ![]u8 {
        return std.fmt.allocPrint(a, "Animating {s} for {d} seconds", .{ self.simpleName(), duration });
    }
    fn description(self: InheritanceShape, a: Allocator) ![]u8 {
        return std.fmt.allocPrint(a, "Shape with area: {d}", .{self.area()});
    }
    fn basePtr(self: *InheritanceShape) *ShapeBase {
        return switch (self.*) {
            inline else => |*v| &v.base,
        };
    }
    fn transform(self: *InheritanceShape, scale: f64, rotation: f64) void {
        self.basePtr().transform(scale, rotation);
    }
    fn applyColor(self: *InheritanceShape, c: []const u8) void {
        self.basePtr().applyColor(c);
    }
};

// --- Processor over the dynamic-dispatch union ----------------------------
const ShapeProcessor = struct {
    fn processAnyShapes(a: Allocator, shapes: []const Shape) ![][]u8 {
        var result: std.ArrayList([]u8) = .empty;
        for (shapes) |s| {
            const d = try s.draw(a);
            const an = try s.animate(a, 1.0);
            try result.append(a, try std.fmt.allocPrint(a, "{s}: {s} - Area: {d} - {s}", .{ s.id(), d, s.area(), an }));
        }
        return result.toOwnedSlice(a);
    }

    fn findLargestShape(shapes: []const Shape) ?usize {
        var largest: ?usize = null;
        for (shapes, 0..) |s, i| {
            if (largest == null or s.area() > shapes[largest.?].area()) largest = i;
        }
        return largest;
    }

    fn processDrawableColorableShapes(a: Allocator, shapes: []const Shape) ![][]u8 {
        var result: std.ArrayList([]u8) = .empty;
        for (shapes) |s| {
            const d = try s.draw(a);
            try result.append(a, try std.fmt.allocPrint(a, "{s} with color {s}", .{ d, s.color() }));
        }
        return result.toOwnedSlice(a);
    }

    // Generic (statically specialized) processing over a concrete conformer T,
    // mirroring Swift's `processShapes<T: AdvancedShape>`.
    fn processShapes(a: Allocator, comptime T: type, shapes: []const T) ![][]u8 {
        var result: std.ArrayList([]u8) = .empty;
        for (shapes) |s| {
            const d = try s.draw(a);
            const an = try defaultAnimate(a, 1.0);
            try result.append(a, try std.fmt.allocPrint(a, "{s}: {s} - Area: {d} - {s}", .{ s.base.id, d, s.area(), an }));
        }
        return result.toOwnedSlice(a);
    }
};

// Protocol-witness-table performance probe. Rendering goes through a stack
// FixedBufferAllocator so dispatch is exercised without unbounded heap growth;
// timing is dropped (size/speed tier), the folded length feeds doNotOptimizeAway.
const ProtocolPerformanceTester = struct {
    fn testProtocolDispatch(shapes: []const Shape, iterations: usize) i64 {
        var scratch: [256]u8 = undefined;
        var sink: i64 = 0;
        var iter: usize = 0;
        while (iter < iterations) : (iter += 1) {
            var totalArea: f64 = 0.0;
            for (shapes) |s| {
                totalArea += s.area();
                var fba = std.heap.FixedBufferAllocator.init(&scratch);
                const fa = fba.allocator();
                const d = s.draw(fa) catch "";
                const an = s.animate(fa, 0.1) catch "";
                sink += @intCast(d.len + an.len);
            }
            std.mem.doNotOptimizeAway(totalArea);
        }
        return sink;
    }

    fn testInheritanceDispatch(shapes: []const InheritanceShape, iterations: usize) i64 {
        var scratch: [256]u8 = undefined;
        var sink: i64 = 0;
        var iter: usize = 0;
        while (iter < iterations) : (iter += 1) {
            var totalArea: f64 = 0.0;
            for (shapes) |s| {
                totalArea += s.area();
                var fba = std.heap.FixedBufferAllocator.init(&scratch);
                const fa = fba.allocator();
                const d = s.draw(fa) catch "";
                const an = s.animate(fa, 0.1) catch "";
                sink += @intCast(d.len + an.len);
            }
            std.mem.doNotOptimizeAway(totalArea);
        }
        return sink;
    }

    fn testGenericDispatch(comptime T: type, shapes: []const T, iterations: usize) i64 {
        var scratch: [256]u8 = undefined;
        var sink: i64 = 0;
        var iter: usize = 0;
        while (iter < iterations) : (iter += 1) {
            var totalArea: f64 = 0.0;
            for (shapes) |s| {
                totalArea += s.area();
                var fba = std.heap.FixedBufferAllocator.init(&scratch);
                const fa = fba.allocator();
                const d = s.draw(fa) catch "";
                const an = defaultAnimate(fa, 0.1) catch "";
                sink += @intCast(d.len + an.len);
            }
            std.mem.doNotOptimizeAway(totalArea);
        }
        return sink;
    }
};

// Comparable conformer -> compareTo + sort by area.
const ComparableCircle = struct {
    base: ShapeBase,
    radius: f64,
    fn area(self: ComparableCircle) f64 {
        return std.math.pi * self.radius * self.radius * self.base.scale * self.base.scale;
    }
    fn lessThan(_: void, lhs: ComparableCircle, rhs: ComparableCircle) bool {
        return lhs.area() < rhs.area();
    }
};

// Factories (associated-type protocol analogue) producing concrete conformers.
const CircleFactory = struct {
    fn createShape(id: []const u8, rand: std.Random) Circle {
        return .{ .base = .{ .id = id, .color = "red" }, .radius = @floatFromInt(rand.intRangeAtMost(i64, 1, 10)) };
    }
};
const RectangleFactory = struct {
    fn createShape(id: []const u8, rand: std.Random) Rectangle {
        return .{ .base = .{ .id = id, .color = "blue" }, .width = @floatFromInt(rand.intRangeAtMost(i64, 1, 10)), .height = @floatFromInt(rand.intRangeAtMost(i64, 1, 10)) };
    }
};

fn runProtocolOrientedComparison(a: Allocator) !void {
    const count: usize = 1000;

    // Protocol-oriented shapes (dynamic dispatch via the Shape union).
    var protocolShapes: std.ArrayList(Shape) = .empty;
    var i: usize = 0;
    while (i < count) : (i += 1) {
        switch (i % 3) {
            0 => try protocolShapes.append(a, .{ .circle = .{ .base = .{ .id = try std.fmt.allocPrint(a, "circle_{d}", .{i}), .color = "red" }, .radius = @floatFromInt(i % 10 + 1) } }),
            1 => try protocolShapes.append(a, .{ .rectangle = .{ .base = .{ .id = try std.fmt.allocPrint(a, "rect_{d}", .{i}), .color = "blue" }, .width = @floatFromInt(i % 8 + 1), .height = @floatFromInt(i % 6 + 1) } }),
            else => try protocolShapes.append(a, .{ .triangle = .{ .base = .{ .id = try std.fmt.allocPrint(a, "triangle_{d}", .{i}), .color = "green" }, .tbase = @floatFromInt(i % 7 + 1), .height = @floatFromInt(i % 5 + 1) } }),
        }
    }

    // Inheritance-hierarchy shapes (dynamic dispatch via InheritanceShape).
    var inheritanceShapes: std.ArrayList(InheritanceShape) = .empty;
    i = 0;
    while (i < count) : (i += 1) {
        switch (i % 3) {
            0 => try inheritanceShapes.append(a, .{ .circle = .{ .base = .{ .id = try std.fmt.allocPrint(a, "circle_{d}", .{i}), .color = "red" }, .radius = @floatFromInt(i % 10 + 1) } }),
            1 => try inheritanceShapes.append(a, .{ .rectangle = .{ .base = .{ .id = try std.fmt.allocPrint(a, "rect_{d}", .{i}), .color = "blue" }, .width = @floatFromInt(i % 8 + 1), .height = @floatFromInt(i % 6 + 1) } }),
            else => try inheritanceShapes.append(a, .{ .triangle = .{ .base = .{ .id = try std.fmt.allocPrint(a, "triangle_{d}", .{i}), .color = "green" }, .tbase = @floatFromInt(i % 7 + 1), .height = @floatFromInt(i % 5 + 1) } }),
        }
    }

    // Processing.
    const protocolResults = try ShapeProcessor.processAnyShapes(a, protocolShapes.items[0..10]);
    const largest = ShapeProcessor.findLargestShape(protocolShapes.items);

    // "filterIsInstance" -> pull concrete conformers out of the union.
    var circles: std.ArrayList(Circle) = .empty;
    var rectangles: std.ArrayList(Rectangle) = .empty;
    for (protocolShapes.items) |s| switch (s) {
        .circle => |c| try circles.append(a, c),
        .rectangle => |r| try rectangles.append(a, r),
        else => {},
    };

    const circleResults = try ShapeProcessor.processShapes(a, Circle, circles.items);
    const rectangleResults = try ShapeProcessor.processShapes(a, Rectangle, rectangles.items);
    const drawableColorableShapes = try ShapeProcessor.processDrawableColorableShapes(a, protocolShapes.items);
    const describeFirst = try describeShape(a, protocolShapes.items[0]);

    // Dispatch probes.
    const protocolTime = ProtocolPerformanceTester.testProtocolDispatch(protocolShapes.items, 100);
    const inheritanceTime = ProtocolPerformanceTester.testInheritanceDispatch(inheritanceShapes.items, 100);
    const genericCircleTime = ProtocolPerformanceTester.testGenericDispatch(Circle, circles.items, 100);
    const genericRectangleTime = ProtocolPerformanceTester.testGenericDispatch(Rectangle, rectangles.items, 100);

    // Factories.
    var prng = std.Random.DefaultPrng.init(0);
    const rand = prng.random();
    var factoryCircles: std.ArrayList(Circle) = .empty;
    var factoryRectangles: std.ArrayList(Rectangle) = .empty;
    i = 0;
    while (i < 100) : (i += 1) {
        try factoryCircles.append(a, CircleFactory.createShape(try std.fmt.allocPrint(a, "factory_circle_{d}", .{i}), rand));
        try factoryRectangles.append(a, RectangleFactory.createShape(try std.fmt.allocPrint(a, "factory_rect_{d}", .{i}), rand));
    }

    // Comparable sort by area.
    var comparableCircles: std.ArrayList(ComparableCircle) = .empty;
    i = 0;
    while (i < 100) : (i += 1) {
        try comparableCircles.append(a, .{ .base = .{ .id = try std.fmt.allocPrint(a, "comp_circle_{d}", .{i}), .color = "red" }, .radius = @floatFromInt(i % 10 + 1) });
    }
    std.mem.sort(ComparableCircle, comparableCircles.items, {}, ComparableCircle.lessThan);

    // transform / applyColor (protocol default implementations).
    protocolShapes.items[0].transform(2.0, 1.0);
    protocolShapes.items[0].applyColor("purple");
    inheritanceShapes.items[0].transform(2.0, 1.0);
    inheritanceShapes.items[0].applyColor("purple");
    const inheritanceDesc = try inheritanceShapes.items[0].description(a);

    std.mem.doNotOptimizeAway(protocolShapes.items.len);
    std.mem.doNotOptimizeAway(inheritanceShapes.items.len);
    std.mem.doNotOptimizeAway(protocolResults.len);
    std.mem.doNotOptimizeAway(if (largest) |idx| protocolShapes.items[idx].area() else 0);
    std.mem.doNotOptimizeAway(circleResults.len);
    std.mem.doNotOptimizeAway(rectangleResults.len);
    std.mem.doNotOptimizeAway(drawableColorableShapes.len);
    std.mem.doNotOptimizeAway(describeFirst.len);
    std.mem.doNotOptimizeAway(protocolTime);
    std.mem.doNotOptimizeAway(inheritanceTime);
    std.mem.doNotOptimizeAway(genericCircleTime);
    std.mem.doNotOptimizeAway(genericRectangleTime);
    std.mem.doNotOptimizeAway(factoryCircles.items.len);
    std.mem.doNotOptimizeAway(factoryRectangles.items.len);
    std.mem.doNotOptimizeAway(comparableCircles.items.len);
    std.mem.doNotOptimizeAway(inheritanceDesc.len);
}

pub fn runBenchmark() void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    runProtocolOrientedComparison(arena.allocator()) catch {};
}

export fn bench_run() void {
    runBenchmark();
}


