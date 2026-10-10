// iOS Size Benchmark - Test Case Implementation
// Generated with Claude AI (https://claude.ai)
//
// Zig port of the "inheritance-deep" case. Zig has no class inheritance, so the
// three 8-level hierarchies (Entity/Service/Manager) are modeled idiomatically
// as tagged unions dispatched by `switch` — the honest Zig analogue of a
// polymorphic `instanceof` chain, and a genuine structural difference from the
// Kotlin/Swift/ObjC/TS versions (documented, not a 1:1 mirror). The five
// interfaces + three hybrid classes become structs with explicit methods. A
// single exported entry exercises every variant so nothing is DCE'd.

const std = @import("std");

const Entity = enum {
    base,
    abstract,
    core,
    standard,
    advanced,
    premium,
    elite,
    ultimate,

    fn getId(self: Entity) i64 {
        return switch (self) {
            .base => 0,
            .abstract => 1,
            .core => 2,
            .standard => 3,
            .advanced => 4,
            .premium => 5,
            .elite => 6,
            .ultimate => 7,
        };
    }
    fn getName(self: Entity) []const u8 {
        return switch (self) {
            .base => "base",
            .abstract => "abstract",
            .core => "core",
            .standard => "standard",
            .advanced => "advanced",
            .premium => "premium",
            .elite => "elite",
            .ultimate => "ultimate",
        };
    }
    fn getType(_: Entity) []const u8 {
        return "entity";
    }
    fn validate(_: Entity) bool {
        return true;
    }
    fn process(_: Entity) []const u8 {
        return "processed";
    }
    fn getCategory(self: Entity) []const u8 {
        return switch (self) {
            .abstract => "abstract",
            else => "core",
        };
    }
    fn initialize(_: Entity) bool {
        return true;
    }
    fn configure(_: Entity) []const u8 {
        return "configured";
    }
    fn getVersion(self: Entity) []const u8 {
        return switch (self) {
            .core => "1.0",
            else => "1.1",
        };
    }
    fn setup(_: Entity) bool {
        return true;
    }
    fn prepare(_: Entity) []const u8 {
        return "prepared";
    }
    fn getFormat(self: Entity) []const u8 {
        return switch (self) {
            .standard => "standard",
            else => "advanced",
        };
    }
    fn activate(_: Entity) bool {
        return true;
    }
    fn execute(_: Entity) []const u8 {
        return "executed";
    }
    fn getLevel(self: Entity) i64 {
        return switch (self) {
            .advanced => 10,
            .premium => 20,
            .elite => 30,
            .ultimate => 50,
            else => 0,
        };
    }
    fn enhance(_: Entity) bool {
        return true;
    }
    fn optimize(_: Entity) []const u8 {
        return "optimized";
    }
    fn getFeatures(self: Entity) i64 { // length of the feature list
        return switch (self) {
            .elite => 3,
            else => 2,
        };
    }
    fn upgrade(_: Entity) bool {
        return true;
    }
    fn customize(_: Entity) []const u8 {
        return "customized";
    }
    fn getPriority(self: Entity) i64 {
        return switch (self) {
            .ultimate => 0,
            else => 1,
        };
    }
    fn accelerate(_: Entity) bool {
        return true;
    }
    fn specialize(_: Entity) []const u8 {
        return "specialized";
    }
    fn getCapabilities(_: Entity) i64 { // Map size
        return 2;
    }
    fn transcend(_: Entity) bool {
        return true;
    }
    fn perfect(_: Entity) []const u8 {
        return "perfected";
    }
};

const Service = enum {
    base,
    abstract,
    core,
    standard,
    advanced,
    premium,
    elite,
    ultimate,

    fn start(_: Service) bool {
        return true;
    }
    fn reset(_: Service) bool {
        return true;
    }
    fn monitor(_: Service) []const u8 {
        return "monitoring";
    }
    fn getStatus(self: Service) []const u8 {
        return switch (self) {
            .base => "base",
            .abstract => "abstract",
            .core => "core",
            .standard => "standard",
            .advanced => "advanced",
            .premium => "premium",
            .elite => "elite",
            .ultimate => "ultimate",
        };
    }
    fn process(_: Service) bool {
        return true;
    }
    fn scale(_: Service) bool {
        return true;
    }
    fn distribute(_: Service) []const u8 {
        return "distributed";
    }
    fn accelerate(_: Service) bool {
        return true;
    }
    fn cache(_: Service) bool {
        return true;
    }
    fn replicate(_: Service) []const u8 {
        return "replicated";
    }
    fn parallelize(_: Service) bool {
        return true;
    }
    fn cluster(_: Service) bool {
        return true;
    }
    fn orchestrate(_: Service) []const u8 {
        return "orchestrated";
    }
    fn autoScale(_: Service) bool {
        return true;
    }
    fn selfHeal(_: Service) bool {
        return true;
    }
    fn transcend(_: Service) []const u8 {
        return "transcended";
    }
};

const Manager = enum {
    base,
    abstract,
    core,
    standard,
    advanced,
    premium,
    elite,
    ultimate,

    fn manage(_: Manager) bool {
        return true;
    }
    fn coordinate(_: Manager) bool {
        return true;
    }
    fn delegate(_: Manager) bool {
        return true;
    }
    fn report(_: Manager) []const u8 {
        return "reported";
    }
    fn supervise(self: Manager) []const u8 {
        return switch (self) {
            .base => "base",
            .abstract => "abstract",
            .core => "core",
            .standard => "standard",
            .advanced => "advanced",
            .premium => "premium",
            .elite => "elite",
            .ultimate => "ultimate",
        };
    }
    fn visualize(_: Manager) bool {
        return true;
    }
    fn predict(_: Manager) bool {
        return true;
    }
    fn transcend(_: Manager) []const u8 {
        return "transcended";
    }
    fn evolve(_: Manager) bool {
        return true;
    }
    fn singularize(_: Manager) bool {
        return true;
    }
    fn infinity(_: Manager) []const u8 {
        return "infinite";
    }
};

// Interfaces -> explicit methods on the hybrid structs below.
const HybridEntity = struct {
    fn processData(_: HybridEntity) []const u8 {
        return "hybrid-processed";
    }
    fn cache(_: HybridEntity) bool {
        return true;
    }
    fn invalidate(_: HybridEntity) bool {
        return true;
    }
    fn serialize(_: HybridEntity) []const u8 {
        return "serialized-hybrid";
    }
    fn deserialize(_: HybridEntity, _: []const u8) bool {
        return true;
    }
    fn transcend(_: HybridEntity) bool {
        return true;
    }
    fn perfect(_: HybridEntity) []const u8 {
        return "perfected";
    }
};

const SuperHybridService = struct {
    fn optimize(_: SuperHybridService) bool {
        return true;
    }
    fn benchmark(_: SuperHybridService) i64 {
        return 99;
    }
    fn scale(_: SuperHybridService, _: f64) bool {
        return true;
    }
    fn getCapacity(_: SuperHybridService) i64 {
        return 1000;
    }
    fn processData(_: SuperHybridService) []const u8 {
        return "super-hybrid-processed";
    }
    fn transcend(_: SuperHybridService) []const u8 {
        return "transcended";
    }
};

const MegaHybridManager = struct {
    fn cache(_: MegaHybridManager) bool {
        return true;
    }
    fn invalidate(_: MegaHybridManager) bool {
        return true;
    }
    fn serialize(_: MegaHybridManager) []const u8 {
        return "mega-serialized";
    }
    fn deserialize(_: MegaHybridManager, _: []const u8) bool {
        return true;
    }
    fn optimize(_: MegaHybridManager) bool {
        return true;
    }
    fn benchmark(_: MegaHybridManager) i64 {
        return 100;
    }
    fn scale(_: MegaHybridManager, _: f64) bool {
        return true;
    }
    fn getCapacity(_: MegaHybridManager) i64 {
        return 10000;
    }
    fn infinity(_: MegaHybridManager) []const u8 {
        return "infinite";
    }
};

const Benchmark = struct {
    sink: i64 = 0,
    fn note(self: *Benchmark, s: []const u8) void {
        self.sink += @intCast(s.len);
    }
    fn flag(self: *Benchmark, b: bool) void {
        self.sink += @intFromBool(b);
    }
    fn num(self: *Benchmark, n: i64) void {
        self.sink += n;
    }

    fn run(self: *Benchmark) void {
        const entities = [_]Entity{ .base, .abstract, .core, .standard, .advanced, .premium, .elite, .ultimate };
        for (entities) |e| switch (e) {
            .ultimate => {
                self.num(e.getId());
                self.note(e.getName());
                self.note(e.getType());
                self.flag(e.validate());
                self.note(e.process());
                self.num(e.getCapabilities());
                self.flag(e.transcend());
                self.note(e.perfect());
            },
            .elite => {
                self.num(e.getId());
                self.note(e.getName());
                self.num(e.getFeatures());
                self.num(e.getPriority());
                self.flag(e.accelerate());
                self.note(e.specialize());
            },
            .premium => {
                self.num(e.getId());
                self.note(e.getName());
                self.num(e.getFeatures());
                self.flag(e.upgrade());
                self.note(e.customize());
            },
            .advanced => {
                self.num(e.getId());
                self.num(e.getLevel());
                self.flag(e.enhance());
                self.note(e.optimize());
            },
            .standard => {
                self.num(e.getId());
                self.note(e.getFormat());
                self.flag(e.activate());
                self.note(e.execute());
            },
            .core => {
                self.num(e.getId());
                self.note(e.getVersion());
                self.flag(e.setup());
                self.note(e.prepare());
            },
            .abstract => {
                self.num(e.getId());
                self.note(e.getCategory());
                self.flag(e.initialize());
                self.note(e.configure());
            },
            .base => {
                self.num(e.getId());
                self.note(e.getName());
                self.flag(e.validate());
                self.note(e.process());
            },
        };

        const services = [_]Service{ .base, .abstract, .core, .standard, .advanced, .premium, .elite, .ultimate };
        for (services) |s| switch (s) {
            .ultimate => {
                self.flag(s.start());
                self.note(s.getStatus());
                self.flag(s.autoScale());
                self.flag(s.selfHeal());
                self.note(s.transcend());
            },
            .elite => {
                self.flag(s.start());
                self.note(s.getStatus());
                self.flag(s.parallelize());
                self.flag(s.cluster());
                self.note(s.orchestrate());
            },
            .premium => {
                self.flag(s.start());
                self.note(s.getStatus());
                self.flag(s.accelerate());
                self.flag(s.cache());
                self.note(s.replicate());
            },
            .advanced => {
                self.flag(s.process());
                self.flag(s.scale());
                self.note(s.distribute());
            },
            else => {
                self.flag(s.start());
                self.note(s.getStatus());
                self.flag(s.reset());
                self.note(s.monitor());
            },
        };

        const managers = [_]Manager{ .base, .abstract, .core, .standard, .advanced, .premium, .elite, .ultimate };
        for (managers) |m| switch (m) {
            .ultimate => {
                self.flag(m.manage());
                self.note(m.supervise());
                self.flag(m.evolve());
                self.flag(m.singularize());
                self.note(m.infinity());
            },
            .elite => {
                self.flag(m.manage());
                self.flag(m.visualize());
                self.flag(m.predict());
                self.note(m.transcend());
            },
            else => {
                self.flag(m.manage());
                self.flag(m.coordinate());
                self.note(m.supervise());
                self.flag(m.delegate());
                self.note(m.report());
            },
        };

        const he = HybridEntity{};
        self.note(he.processData());
        self.flag(he.cache());
        self.flag(he.invalidate());
        self.note(he.serialize());
        self.flag(he.deserialize("x"));
        self.flag(he.transcend());
        self.note(he.perfect());

        const shs = SuperHybridService{};
        self.flag(shs.optimize());
        self.num(shs.benchmark());
        self.flag(shs.scale(2.0));
        self.num(shs.getCapacity());
        self.note(shs.processData());
        self.note(shs.transcend());

        const mhm = MegaHybridManager{};
        self.flag(mhm.cache());
        self.flag(mhm.invalidate());
        self.note(mhm.serialize());
        self.flag(mhm.deserialize("y"));
        self.flag(mhm.optimize());
        self.num(mhm.benchmark());
        self.flag(mhm.scale(10.0));
        self.num(mhm.getCapacity());
        self.note(mhm.infinity());

        std.mem.doNotOptimizeAway(self.sink);
    }
};

pub fn runBenchmark() void {
    var b = Benchmark{};
    b.run();
}

export fn bench_run() void {
    runBenchmark();
}
