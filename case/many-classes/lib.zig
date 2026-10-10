// iOS Size Benchmark - Test Case Implementation
// Generated with Claude AI (https://claude.ai)
//
// Zig port of the "many-classes" case. The point of the case is per-type
// overhead, so all 20 Entity + 10 Service + 5 Manager types are kept as
// distinct structs with their own methods. Zig has no classes or runtime
// `instanceof`, so the heterogeneous entity/service/manager arrays are modeled
// as `union(enum)`s dispatched by `switch` — the honest analogue of the
// Kotlin `when (x is T)` / TS `instanceof` chains. The dispatch uses
// `inline else`, which monomorphizes the arm per concrete variant, so every
// type's methods stay referenced (nothing DCE'd) while the body is written
// once. A single exported entry exercises every type, matching Swift `public`.

const std = @import("std");

// Entity structs (20 entities). Each carries id/name/value and the same three
// methods; only the `process` multiplier differs, mirroring the source. Zig
// has no in-place string uppercasing without allocation and `transform().id`
// is all the benchmark reads, so `transform` reuses `name` as-is.
const Entity01 = struct {
    id: i64,
    name: []const u8,
    value: f64,
    fn process(self: Entity01) f64 {
        return self.value * 1.1;
    }
    fn validate(self: Entity01) bool {
        return self.id > 0 and self.name.len > 0;
    }
    fn transform(self: Entity01) Entity01 {
        return .{ .id = self.id + 1, .name = self.name, .value = self.value * 2 };
    }
};
const Entity02 = struct {
    id: i64,
    name: []const u8,
    value: f64,
    fn process(self: Entity02) f64 {
        return self.value * 1.2;
    }
    fn validate(self: Entity02) bool {
        return self.id > 0 and self.name.len > 0;
    }
    fn transform(self: Entity02) Entity02 {
        return .{ .id = self.id + 1, .name = self.name, .value = self.value * 2 };
    }
};
const Entity03 = struct {
    id: i64,
    name: []const u8,
    value: f64,
    fn process(self: Entity03) f64 {
        return self.value * 1.3;
    }
    fn validate(self: Entity03) bool {
        return self.id > 0 and self.name.len > 0;
    }
    fn transform(self: Entity03) Entity03 {
        return .{ .id = self.id + 1, .name = self.name, .value = self.value * 2 };
    }
};
const Entity04 = struct {
    id: i64,
    name: []const u8,
    value: f64,
    fn process(self: Entity04) f64 {
        return self.value * 1.4;
    }
    fn validate(self: Entity04) bool {
        return self.id > 0 and self.name.len > 0;
    }
    fn transform(self: Entity04) Entity04 {
        return .{ .id = self.id + 1, .name = self.name, .value = self.value * 2 };
    }
};
const Entity05 = struct {
    id: i64,
    name: []const u8,
    value: f64,
    fn process(self: Entity05) f64 {
        return self.value * 1.5;
    }
    fn validate(self: Entity05) bool {
        return self.id > 0 and self.name.len > 0;
    }
    fn transform(self: Entity05) Entity05 {
        return .{ .id = self.id + 1, .name = self.name, .value = self.value * 2 };
    }
};
const Entity06 = struct {
    id: i64,
    name: []const u8,
    value: f64,
    fn process(self: Entity06) f64 {
        return self.value * 1.6;
    }
    fn validate(self: Entity06) bool {
        return self.id > 0 and self.name.len > 0;
    }
    fn transform(self: Entity06) Entity06 {
        return .{ .id = self.id + 1, .name = self.name, .value = self.value * 2 };
    }
};
const Entity07 = struct {
    id: i64,
    name: []const u8,
    value: f64,
    fn process(self: Entity07) f64 {
        return self.value * 1.7;
    }
    fn validate(self: Entity07) bool {
        return self.id > 0 and self.name.len > 0;
    }
    fn transform(self: Entity07) Entity07 {
        return .{ .id = self.id + 1, .name = self.name, .value = self.value * 2 };
    }
};
const Entity08 = struct {
    id: i64,
    name: []const u8,
    value: f64,
    fn process(self: Entity08) f64 {
        return self.value * 1.8;
    }
    fn validate(self: Entity08) bool {
        return self.id > 0 and self.name.len > 0;
    }
    fn transform(self: Entity08) Entity08 {
        return .{ .id = self.id + 1, .name = self.name, .value = self.value * 2 };
    }
};
const Entity09 = struct {
    id: i64,
    name: []const u8,
    value: f64,
    fn process(self: Entity09) f64 {
        return self.value * 1.9;
    }
    fn validate(self: Entity09) bool {
        return self.id > 0 and self.name.len > 0;
    }
    fn transform(self: Entity09) Entity09 {
        return .{ .id = self.id + 1, .name = self.name, .value = self.value * 2 };
    }
};
const Entity10 = struct {
    id: i64,
    name: []const u8,
    value: f64,
    fn process(self: Entity10) f64 {
        return self.value * 2.0;
    }
    fn validate(self: Entity10) bool {
        return self.id > 0 and self.name.len > 0;
    }
    fn transform(self: Entity10) Entity10 {
        return .{ .id = self.id + 1, .name = self.name, .value = self.value * 2 };
    }
};
const Entity11 = struct {
    id: i64,
    name: []const u8,
    value: f64,
    fn process(self: Entity11) f64 {
        return self.value * 2.1;
    }
    fn validate(self: Entity11) bool {
        return self.id > 0 and self.name.len > 0;
    }
    fn transform(self: Entity11) Entity11 {
        return .{ .id = self.id + 1, .name = self.name, .value = self.value * 2 };
    }
};
const Entity12 = struct {
    id: i64,
    name: []const u8,
    value: f64,
    fn process(self: Entity12) f64 {
        return self.value * 2.2;
    }
    fn validate(self: Entity12) bool {
        return self.id > 0 and self.name.len > 0;
    }
    fn transform(self: Entity12) Entity12 {
        return .{ .id = self.id + 1, .name = self.name, .value = self.value * 2 };
    }
};
const Entity13 = struct {
    id: i64,
    name: []const u8,
    value: f64,
    fn process(self: Entity13) f64 {
        return self.value * 2.3;
    }
    fn validate(self: Entity13) bool {
        return self.id > 0 and self.name.len > 0;
    }
    fn transform(self: Entity13) Entity13 {
        return .{ .id = self.id + 1, .name = self.name, .value = self.value * 2 };
    }
};
const Entity14 = struct {
    id: i64,
    name: []const u8,
    value: f64,
    fn process(self: Entity14) f64 {
        return self.value * 2.4;
    }
    fn validate(self: Entity14) bool {
        return self.id > 0 and self.name.len > 0;
    }
    fn transform(self: Entity14) Entity14 {
        return .{ .id = self.id + 1, .name = self.name, .value = self.value * 2 };
    }
};
const Entity15 = struct {
    id: i64,
    name: []const u8,
    value: f64,
    fn process(self: Entity15) f64 {
        return self.value * 2.5;
    }
    fn validate(self: Entity15) bool {
        return self.id > 0 and self.name.len > 0;
    }
    fn transform(self: Entity15) Entity15 {
        return .{ .id = self.id + 1, .name = self.name, .value = self.value * 2 };
    }
};
const Entity16 = struct {
    id: i64,
    name: []const u8,
    value: f64,
    fn process(self: Entity16) f64 {
        return self.value * 2.6;
    }
    fn validate(self: Entity16) bool {
        return self.id > 0 and self.name.len > 0;
    }
    fn transform(self: Entity16) Entity16 {
        return .{ .id = self.id + 1, .name = self.name, .value = self.value * 2 };
    }
};
const Entity17 = struct {
    id: i64,
    name: []const u8,
    value: f64,
    fn process(self: Entity17) f64 {
        return self.value * 2.7;
    }
    fn validate(self: Entity17) bool {
        return self.id > 0 and self.name.len > 0;
    }
    fn transform(self: Entity17) Entity17 {
        return .{ .id = self.id + 1, .name = self.name, .value = self.value * 2 };
    }
};
const Entity18 = struct {
    id: i64,
    name: []const u8,
    value: f64,
    fn process(self: Entity18) f64 {
        return self.value * 2.8;
    }
    fn validate(self: Entity18) bool {
        return self.id > 0 and self.name.len > 0;
    }
    fn transform(self: Entity18) Entity18 {
        return .{ .id = self.id + 1, .name = self.name, .value = self.value * 2 };
    }
};
const Entity19 = struct {
    id: i64,
    name: []const u8,
    value: f64,
    fn process(self: Entity19) f64 {
        return self.value * 2.9;
    }
    fn validate(self: Entity19) bool {
        return self.id > 0 and self.name.len > 0;
    }
    fn transform(self: Entity19) Entity19 {
        return .{ .id = self.id + 1, .name = self.name, .value = self.value * 2 };
    }
};
const Entity20 = struct {
    id: i64,
    name: []const u8,
    value: f64,
    fn process(self: Entity20) f64 {
        return self.value * 3.0;
    }
    fn validate(self: Entity20) bool {
        return self.id > 0 and self.name.len > 0;
    }
    fn transform(self: Entity20) Entity20 {
        return .{ .id = self.id + 1, .name = self.name, .value = self.value * 2 };
    }
};

// Service structs (10 services, 5 methods each).
const Service01 = struct {
    fn method01(_: Service01) []const u8 {
        return "Service01.method01";
    }
    fn method02(_: Service01) []const u8 {
        return "Service01.method02";
    }
    fn method03(_: Service01) []const u8 {
        return "Service01.method03";
    }
    fn method04(_: Service01) []const u8 {
        return "Service01.method04";
    }
    fn method05(_: Service01) []const u8 {
        return "Service01.method05";
    }
};
const Service02 = struct {
    fn method01(_: Service02) []const u8 {
        return "Service02.method01";
    }
    fn method02(_: Service02) []const u8 {
        return "Service02.method02";
    }
    fn method03(_: Service02) []const u8 {
        return "Service02.method03";
    }
    fn method04(_: Service02) []const u8 {
        return "Service02.method04";
    }
    fn method05(_: Service02) []const u8 {
        return "Service02.method05";
    }
};
const Service03 = struct {
    fn method01(_: Service03) []const u8 {
        return "Service03.method01";
    }
    fn method02(_: Service03) []const u8 {
        return "Service03.method02";
    }
    fn method03(_: Service03) []const u8 {
        return "Service03.method03";
    }
    fn method04(_: Service03) []const u8 {
        return "Service03.method04";
    }
    fn method05(_: Service03) []const u8 {
        return "Service03.method05";
    }
};
const Service04 = struct {
    fn method01(_: Service04) []const u8 {
        return "Service04.method01";
    }
    fn method02(_: Service04) []const u8 {
        return "Service04.method02";
    }
    fn method03(_: Service04) []const u8 {
        return "Service04.method03";
    }
    fn method04(_: Service04) []const u8 {
        return "Service04.method04";
    }
    fn method05(_: Service04) []const u8 {
        return "Service04.method05";
    }
};
const Service05 = struct {
    fn method01(_: Service05) []const u8 {
        return "Service05.method01";
    }
    fn method02(_: Service05) []const u8 {
        return "Service05.method02";
    }
    fn method03(_: Service05) []const u8 {
        return "Service05.method03";
    }
    fn method04(_: Service05) []const u8 {
        return "Service05.method04";
    }
    fn method05(_: Service05) []const u8 {
        return "Service05.method05";
    }
};
const Service06 = struct {
    fn method01(_: Service06) []const u8 {
        return "Service06.method01";
    }
    fn method02(_: Service06) []const u8 {
        return "Service06.method02";
    }
    fn method03(_: Service06) []const u8 {
        return "Service06.method03";
    }
    fn method04(_: Service06) []const u8 {
        return "Service06.method04";
    }
    fn method05(_: Service06) []const u8 {
        return "Service06.method05";
    }
};
const Service07 = struct {
    fn method01(_: Service07) []const u8 {
        return "Service07.method01";
    }
    fn method02(_: Service07) []const u8 {
        return "Service07.method02";
    }
    fn method03(_: Service07) []const u8 {
        return "Service07.method03";
    }
    fn method04(_: Service07) []const u8 {
        return "Service07.method04";
    }
    fn method05(_: Service07) []const u8 {
        return "Service07.method05";
    }
};
const Service08 = struct {
    fn method01(_: Service08) []const u8 {
        return "Service08.method01";
    }
    fn method02(_: Service08) []const u8 {
        return "Service08.method02";
    }
    fn method03(_: Service08) []const u8 {
        return "Service08.method03";
    }
    fn method04(_: Service08) []const u8 {
        return "Service08.method04";
    }
    fn method05(_: Service08) []const u8 {
        return "Service08.method05";
    }
};
const Service09 = struct {
    fn method01(_: Service09) []const u8 {
        return "Service09.method01";
    }
    fn method02(_: Service09) []const u8 {
        return "Service09.method02";
    }
    fn method03(_: Service09) []const u8 {
        return "Service09.method03";
    }
    fn method04(_: Service09) []const u8 {
        return "Service09.method04";
    }
    fn method05(_: Service09) []const u8 {
        return "Service09.method05";
    }
};
const Service10 = struct {
    fn method01(_: Service10) []const u8 {
        return "Service10.method01";
    }
    fn method02(_: Service10) []const u8 {
        return "Service10.method02";
    }
    fn method03(_: Service10) []const u8 {
        return "Service10.method03";
    }
    fn method04(_: Service10) []const u8 {
        return "Service10.method04";
    }
    fn method05(_: Service10) []const u8 {
        return "Service10.method05";
    }
};

// Manager structs (5 managers, 10 methods each; the benchmark calls 5 of them,
// mirroring the Kotlin/TS source). Unreferenced methods are DCE'd here just as
// an optimizer would elsewhere.
const Manager01 = struct {
    fn initialize(_: Manager01) []const u8 {
        return "Manager01.initialize";
    }
    fn configure(_: Manager01) []const u8 {
        return "Manager01.configure";
    }
    fn start(_: Manager01) []const u8 {
        return "Manager01.start";
    }
    fn stop(_: Manager01) []const u8 {
        return "Manager01.stop";
    }
    fn restart(_: Manager01) []const u8 {
        return "Manager01.restart";
    }
    fn pause(_: Manager01) []const u8 {
        return "Manager01.pause";
    }
    fn @"resume"(_: Manager01) []const u8 {
        return "Manager01.resume";
    }
    fn reset(_: Manager01) []const u8 {
        return "Manager01.reset";
    }
    fn cleanup(_: Manager01) []const u8 {
        return "Manager01.cleanup";
    }
    fn validate(_: Manager01) []const u8 {
        return "Manager01.validate";
    }
};
const Manager02 = struct {
    fn initialize(_: Manager02) []const u8 {
        return "Manager02.initialize";
    }
    fn configure(_: Manager02) []const u8 {
        return "Manager02.configure";
    }
    fn start(_: Manager02) []const u8 {
        return "Manager02.start";
    }
    fn stop(_: Manager02) []const u8 {
        return "Manager02.stop";
    }
    fn restart(_: Manager02) []const u8 {
        return "Manager02.restart";
    }
    fn pause(_: Manager02) []const u8 {
        return "Manager02.pause";
    }
    fn @"resume"(_: Manager02) []const u8 {
        return "Manager02.resume";
    }
    fn reset(_: Manager02) []const u8 {
        return "Manager02.reset";
    }
    fn cleanup(_: Manager02) []const u8 {
        return "Manager02.cleanup";
    }
    fn validate(_: Manager02) []const u8 {
        return "Manager02.validate";
    }
};
const Manager03 = struct {
    fn initialize(_: Manager03) []const u8 {
        return "Manager03.initialize";
    }
    fn configure(_: Manager03) []const u8 {
        return "Manager03.configure";
    }
    fn start(_: Manager03) []const u8 {
        return "Manager03.start";
    }
    fn stop(_: Manager03) []const u8 {
        return "Manager03.stop";
    }
    fn restart(_: Manager03) []const u8 {
        return "Manager03.restart";
    }
    fn pause(_: Manager03) []const u8 {
        return "Manager03.pause";
    }
    fn @"resume"(_: Manager03) []const u8 {
        return "Manager03.resume";
    }
    fn reset(_: Manager03) []const u8 {
        return "Manager03.reset";
    }
    fn cleanup(_: Manager03) []const u8 {
        return "Manager03.cleanup";
    }
    fn validate(_: Manager03) []const u8 {
        return "Manager03.validate";
    }
};
const Manager04 = struct {
    fn initialize(_: Manager04) []const u8 {
        return "Manager04.initialize";
    }
    fn configure(_: Manager04) []const u8 {
        return "Manager04.configure";
    }
    fn start(_: Manager04) []const u8 {
        return "Manager04.start";
    }
    fn stop(_: Manager04) []const u8 {
        return "Manager04.stop";
    }
    fn restart(_: Manager04) []const u8 {
        return "Manager04.restart";
    }
    fn pause(_: Manager04) []const u8 {
        return "Manager04.pause";
    }
    fn @"resume"(_: Manager04) []const u8 {
        return "Manager04.resume";
    }
    fn reset(_: Manager04) []const u8 {
        return "Manager04.reset";
    }
    fn cleanup(_: Manager04) []const u8 {
        return "Manager04.cleanup";
    }
    fn validate(_: Manager04) []const u8 {
        return "Manager04.validate";
    }
};
const Manager05 = struct {
    fn initialize(_: Manager05) []const u8 {
        return "Manager05.initialize";
    }
    fn configure(_: Manager05) []const u8 {
        return "Manager05.configure";
    }
    fn start(_: Manager05) []const u8 {
        return "Manager05.start";
    }
    fn stop(_: Manager05) []const u8 {
        return "Manager05.stop";
    }
    fn restart(_: Manager05) []const u8 {
        return "Manager05.restart";
    }
    fn pause(_: Manager05) []const u8 {
        return "Manager05.pause";
    }
    fn @"resume"(_: Manager05) []const u8 {
        return "Manager05.resume";
    }
    fn reset(_: Manager05) []const u8 {
        return "Manager05.reset";
    }
    fn cleanup(_: Manager05) []const u8 {
        return "Manager05.cleanup";
    }
    fn validate(_: Manager05) []const u8 {
        return "Manager05.validate";
    }
};

// Heterogeneous collections -> tagged unions (the honest Zig analogue of the
// instanceof/when-is dispatch over a mixed array).
const AnyEntity = union(enum) {
    e01: Entity01,
    e02: Entity02,
    e03: Entity03,
    e04: Entity04,
    e05: Entity05,
    e06: Entity06,
    e07: Entity07,
    e08: Entity08,
    e09: Entity09,
    e10: Entity10,
    e11: Entity11,
    e12: Entity12,
    e13: Entity13,
    e14: Entity14,
    e15: Entity15,
    e16: Entity16,
    e17: Entity17,
    e18: Entity18,
    e19: Entity19,
    e20: Entity20,
};

const AnyService = union(enum) {
    s01: Service01,
    s02: Service02,
    s03: Service03,
    s04: Service04,
    s05: Service05,
    s06: Service06,
    s07: Service07,
    s08: Service08,
    s09: Service09,
    s10: Service10,
};

const AnyManager = union(enum) {
    m01: Manager01,
    m02: Manager02,
    m03: Manager03,
    m04: Manager04,
    m05: Manager05,
};

fn runManyClasses() void {
    const entities = [_]AnyEntity{
        .{ .e01 = .{ .id = 1, .name = "test", .value = 1.0 } },
        .{ .e02 = .{ .id = 2, .name = "test", .value = 2.0 } },
        .{ .e03 = .{ .id = 3, .name = "test", .value = 3.0 } },
        .{ .e04 = .{ .id = 4, .name = "test", .value = 4.0 } },
        .{ .e05 = .{ .id = 5, .name = "test", .value = 5.0 } },
        .{ .e06 = .{ .id = 6, .name = "test", .value = 6.0 } },
        .{ .e07 = .{ .id = 7, .name = "test", .value = 7.0 } },
        .{ .e08 = .{ .id = 8, .name = "test", .value = 8.0 } },
        .{ .e09 = .{ .id = 9, .name = "test", .value = 9.0 } },
        .{ .e10 = .{ .id = 10, .name = "test", .value = 10.0 } },
        .{ .e11 = .{ .id = 11, .name = "test", .value = 11.0 } },
        .{ .e12 = .{ .id = 12, .name = "test", .value = 12.0 } },
        .{ .e13 = .{ .id = 13, .name = "test", .value = 13.0 } },
        .{ .e14 = .{ .id = 14, .name = "test", .value = 14.0 } },
        .{ .e15 = .{ .id = 15, .name = "test", .value = 15.0 } },
        .{ .e16 = .{ .id = 16, .name = "test", .value = 16.0 } },
        .{ .e17 = .{ .id = 17, .name = "test", .value = 17.0 } },
        .{ .e18 = .{ .id = 18, .name = "test", .value = 18.0 } },
        .{ .e19 = .{ .id = 19, .name = "test", .value = 19.0 } },
        .{ .e20 = .{ .id = 20, .name = "test", .value = 20.0 } },
    };

    const services = [_]AnyService{
        .{ .s01 = .{} }, .{ .s02 = .{} }, .{ .s03 = .{} }, .{ .s04 = .{} }, .{ .s05 = .{} },
        .{ .s06 = .{} }, .{ .s07 = .{} }, .{ .s08 = .{} }, .{ .s09 = .{} }, .{ .s10 = .{} },
    };

    const managers = [_]AnyManager{
        .{ .m01 = .{} }, .{ .m02 = .{} }, .{ .m03 = .{} }, .{ .m04 = .{} }, .{ .m05 = .{} },
    };

    var processSum: f64 = 0.0;
    var validCount: i64 = 0;
    var transformSum: i64 = 0;
    var serviceChars: i64 = 0;
    var managerChars: i64 = 0;

    // `inline else` monomorphizes the body per concrete variant, so every
    // type's methods stay referenced — the Zig analogue of the instanceof chain.
    for (entities) |ent| switch (ent) {
        inline else => |e| {
            processSum += e.process();
            if (e.validate()) validCount += 1;
            transformSum += e.transform().id;
        },
    };

    for (services) |svc| switch (svc) {
        inline else => |s| {
            serviceChars += @as(i64, @intCast(s.method01().len));
            serviceChars += @as(i64, @intCast(s.method02().len));
            serviceChars += @as(i64, @intCast(s.method03().len));
            serviceChars += @as(i64, @intCast(s.method04().len));
            serviceChars += @as(i64, @intCast(s.method05().len));
        },
    };

    for (managers) |mgr| switch (mgr) {
        inline else => |m| {
            managerChars += @as(i64, @intCast(m.initialize().len));
            managerChars += @as(i64, @intCast(m.configure().len));
            managerChars += @as(i64, @intCast(m.start().len));
            managerChars += @as(i64, @intCast(m.stop().len));
            managerChars += @as(i64, @intCast(m.cleanup().len));
        },
    };

    std.mem.doNotOptimizeAway(processSum);
    std.mem.doNotOptimizeAway(validCount);
    std.mem.doNotOptimizeAway(transformSum);
    std.mem.doNotOptimizeAway(serviceChars);
    std.mem.doNotOptimizeAway(managerChars);
}

pub fn runBenchmark() void {
    runManyClasses();
}

export fn bench_run() void {
    runBenchmark();
}
