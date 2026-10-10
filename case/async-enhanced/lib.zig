// iOS Size Benchmark - Test Case Implementation
// Generated with Claude AI (https://claude.ai)
//
// Zig 0.16 port of the "async-enhanced" case (lib.ts is the source of truth).
// Structured concurrency maps onto the new std.Io interface: `await delay(n)`
// -> `try delayMs(io, n)`; the parallel-fan-out `Promise.all([...])` -> an
// array of `io.async(...)` Futures awaited in turn; the suspending coroutine
// `Semaphore` -> a plain counting gate (shape preserved; the size tier never
// runs it). Kotlin sealed classes become tagged unions + `switch`. The
// portable thread-pool backend (std.Io.Threaded) drives the whole graph, kept
// alive by one exported entry (bench_run -> runBenchmark, the DCE root).

const std = @import("std");
const Io = std.Io;
const Allocator = std.mem.Allocator;

const Err = Io.Cancelable || Allocator.Error;

fn delayMs(io: Io, ms: i64) Io.Cancelable!void {
    try Io.sleep(io, Io.Duration.fromMilliseconds(ms), .awake);
}

var rng_state: std.atomic.Value(u64) = .init(0x2545f4914f6cdd1d);
fn randomId() i64 {
    const x = rng_state.fetchAdd(0x9E3779B97F4A7C15, .monotonic);
    const z = (x ^ (x >> 31)) *% 0x2545F4914F6CDD1D;
    return 1 + @as(i64, @intCast((z ^ (z >> 29)) % 10000));
}

fn lowerDup(a: Allocator, s: []const u8) []u8 {
    const out = a.alloc(u8, s.len) catch return &.{};
    for (s, 0..) |c, i| out[i] = std.ascii.toLower(c);
    return out;
}
fn containsIgnoreCase(a: Allocator, haystack: []const u8, needle_lower: []const u8) bool {
    return std.mem.indexOf(u8, lowerDup(a, haystack), needle_lower) != null;
}

// Coroutine-style counting semaphore (acquire/release shape preserved; no real
// suspension — the size tier compiles but never executes this).
const Semaphore = struct {
    permits: i64,
    fn init(permits: i64) Semaphore {
        return .{ .permits = permits };
    }
    fn acquire(self: *Semaphore) void {
        if (self.permits > 0) self.permits -= 1;
    }
    fn release(self: *Semaphore) void {
        self.permits += 1;
    }
};

// ----- Data classes + sealed hierarchies ------------------------------------

const CountMap = std.StringHashMapUnmanaged(i64);

const User = struct {
    id: i64,
    name: []const u8,
    email: []const u8,
    age: i64,
    fn copy(self: User, name: []const u8) User {
        return .{ .id = self.id, .name = name, .email = self.email, .age = self.age };
    }
};
const Product = struct {
    id: i64,
    name: []const u8,
    price: f64,
    category: []const u8,
    fn copyPrice(self: Product, price: f64) Product {
        return .{ .id = self.id, .name = self.name, .price = price, .category = self.category };
    }
};
const Order = struct { id: i64, userId: i64, products: []const Product, total: f64 };
const OrderRequest = struct { userId: i64, productIds: []const i64 };
const ProductMetrics = struct {
    totalCount: i64,
    averagePrice: f64,
    categoryCount: i64,
    priceRangeDistribution: CountMap,
};

// sealed class WorkflowResult -> tagged union
const WorkflowSuccess = struct {
    createdUser: User,
    updatedUser: User,
    retrievedUser: ?User,
    allUsersCount: i64,
    searchResultsCount: i64,
    deleteSuccess: bool,
};
const WorkflowResult = union(enum) {
    success: WorkflowSuccess,
    err: []const u8,
};

// sealed class OrderPipelineResult -> tagged union
const OrderPipelineResult = union(enum) {
    success: Order,
    err: []const u8,
};

// sealed class OrderResult -> tagged union
const OrderFailed = struct { userId: i64, message: []const u8 };
const OrderResult = union(enum) {
    success: Order,
    failed: OrderFailed,
};

// Triple<String, String, Int> for batch user creation.
const UserTriple = struct { name: []const u8, email: []const u8, age: i64 };

// ----- Services -------------------------------------------------------------

const AsyncUserService = struct {
    fn createUser(_: AsyncUserService, io: Io, name: []const u8, email: []const u8, age: i64) Err!User {
        try delayMs(io, 10);
        return .{ .id = randomId(), .name = name, .email = email, .age = age };
    }
    fn updateUser(_: AsyncUserService, io: Io, a: Allocator, user: User) Err!User {
        try delayMs(io, 5);
        return user.copy(try std.fmt.allocPrint(a, "{s}_updated", .{user.name}));
    }
    fn deleteUser(_: AsyncUserService, io: Io, userId: i64) Err!bool {
        try delayMs(io, 5);
        _ = userId;
        return true;
    }
    fn getUserById(_: AsyncUserService, io: Io, a: Allocator, userId: i64) Err!?User {
        try delayMs(io, 10);
        return .{ .id = userId, .name = try std.fmt.allocPrint(a, "User{d}", .{userId}), .email = try std.fmt.allocPrint(a, "user{d}@email.com", .{userId}), .age = 25 };
    }
    fn getAllUsers(_: AsyncUserService, io: Io, a: Allocator) Err![]User {
        try delayMs(io, 50);
        var list: std.ArrayList(User) = .empty;
        var i: i64 = 1;
        while (i <= 100) : (i += 1) try list.append(a, .{ .id = i, .name = try std.fmt.allocPrint(a, "User{d}", .{i}), .email = try std.fmt.allocPrint(a, "user{d}@email.com", .{i}), .age = 20 + @mod(i, 50) });
        return list.toOwnedSlice(a);
    }
    fn searchUsers(self: AsyncUserService, io: Io, a: Allocator, query: []const u8) Err![]User {
        const users = try self.getAllUsers(io, a);
        try delayMs(io, 20);
        const q = lowerDup(a, query);
        var out: std.ArrayList(User) = .empty;
        for (users) |u| if (containsIgnoreCase(a, u.name, q)) try out.append(a, u);
        return out.toOwnedSlice(a);
    }
    fn batchCreateUsers(self: AsyncUserService, io: Io, a: Allocator, triples: []const UserTriple) Err![]User {
        var futs: std.ArrayList(Io.Future(Err!User)) = .empty;
        for (triples) |t| try futs.append(a, io.async(AsyncUserService.createUser, .{ self, io, t.name, t.email, t.age }));
        var out: std.ArrayList(User) = .empty;
        for (futs.items) |*f| try out.append(a, try f.await(io));
        return out.toOwnedSlice(a);
    }
    fn processUserWorkflow(self: AsyncUserService, io: Io, a: Allocator, userIndex: i64) Err!WorkflowResult {
        var createF = io.async(AsyncUserService.createUser, .{ self, io, try std.fmt.allocPrint(a, "User{d}", .{userIndex}), try std.fmt.allocPrint(a, "user{d}@email.com", .{userIndex}), 25 + @mod(userIndex, 50) });
        var allF = io.async(AsyncUserService.getAllUsers, .{ self, io, a });
        var searchF = io.async(AsyncUserService.searchUsers, .{ self, io, a, "User" });
        const createdUser = try createF.await(io);
        const allUsers = try allF.await(io);
        const searchResults = try searchF.await(io);
        const updatedUser = try self.updateUser(io, a, createdUser);
        const retrievedUser = try self.getUserById(io, a, updatedUser.id);
        const deleteResult = try self.deleteUser(io, updatedUser.id);
        return .{ .success = .{ .createdUser = createdUser, .updatedUser = updatedUser, .retrievedUser = retrievedUser, .allUsersCount = @intCast(allUsers.len), .searchResultsCount = @intCast(searchResults.len), .deleteSuccess = deleteResult } };
    }
};

const AsyncProductService = struct {
    fn createProduct(_: AsyncProductService, io: Io, name: []const u8, price: f64, category: []const u8) Err!Product {
        try delayMs(io, 15);
        return .{ .id = randomId(), .name = name, .price = price, .category = category };
    }
    fn updateProduct(_: AsyncProductService, io: Io, product: Product) Err!Product {
        try delayMs(io, 8);
        return product.copyPrice(product.price * 1.1);
    }
    fn getAllProducts(_: AsyncProductService, io: Io, a: Allocator) Err![]Product {
        try delayMs(io, 60);
        var list: std.ArrayList(Product) = .empty;
        var i: i64 = 1;
        while (i <= 500) : (i += 1) try list.append(a, .{ .id = i, .name = try std.fmt.allocPrint(a, "Product{d}", .{i}), .price = 50.0 + @as(f64, @floatFromInt(@mod(i, 200))), .category = try std.fmt.allocPrint(a, "Category{d}", .{@mod(i, 10)}) });
        return list.toOwnedSlice(a);
    }
    fn getProductsByCategory(self: AsyncProductService, io: Io, a: Allocator, category: []const u8) Err![]Product {
        const products = try self.getAllProducts(io, a);
        try delayMs(io, 30);
        var out: std.ArrayList(Product) = .empty;
        for (products) |p| if (std.mem.eql(u8, p.category, category)) try out.append(a, p);
        return out.toOwnedSlice(a);
    }
    fn getProductById(_: AsyncProductService, io: Io, a: Allocator, productId: i64) Err!?Product {
        try delayMs(io, 12);
        return .{ .id = productId, .name = try std.fmt.allocPrint(a, "Product{d}", .{productId}), .price = 99.99, .category = "Electronics" };
    }
    fn batchProcessProducts(self: AsyncProductService, io: Io, a: Allocator, productIds: []const i64) Err!std.AutoHashMapUnmanaged(i64, ?Product) {
        var futs: std.ArrayList(Io.Future(Err!?Product)) = .empty;
        for (productIds) |id| try futs.append(a, io.async(AsyncProductService.getProductById, .{ self, io, a, id }));
        var result: std.AutoHashMapUnmanaged(i64, ?Product) = .empty;
        for (productIds, 0..) |id, i| try result.put(a, id, try futs.items[i].await(io));
        return result;
    }
    fn calculateProductMetrics(_: AsyncProductService, a: Allocator, products: []const Product) Err!ProductMetrics {
        var sum: f64 = 0;
        for (products) |p| sum += p.price;
        const averagePrice: f64 = if (products.len > 0) sum / @as(f64, @floatFromInt(products.len)) else 0;

        var categoryGroups: std.StringHashMapUnmanaged(std.ArrayList(Product)) = .empty;
        for (products) |p| {
            const gop = try categoryGroups.getOrPut(a, p.category);
            if (!gop.found_existing) gop.value_ptr.* = .empty;
            try gop.value_ptr.append(a, p);
        }

        var priceRanges: std.StringHashMapUnmanaged(std.ArrayList(Product)) = .empty;
        for (products) |p| {
            const key: []const u8 = if (p.price < 50) "Low" else if (p.price < 100) "Medium" else "High";
            const gop = try priceRanges.getOrPut(a, key);
            if (!gop.found_existing) gop.value_ptr.* = .empty;
            try gop.value_ptr.append(a, p);
        }

        var dist: CountMap = .empty;
        var it = priceRanges.iterator();
        while (it.next()) |e| try dist.put(a, e.key_ptr.*, @intCast(e.value_ptr.items.len));

        return .{ .totalCount = @intCast(products.len), .averagePrice = averagePrice, .categoryCount = @intCast(categoryGroups.count()), .priceRangeDistribution = dist };
    }
};

const AsyncOrderService = struct {
    fn createOrder(_: AsyncOrderService, io: Io, userId: i64, products: []const Product) Err!Order {
        try delayMs(io, 25);
        var total: f64 = 0;
        for (products) |p| total += p.price;
        return .{ .id = randomId(), .userId = userId, .products = products, .total = total };
    }
    fn checkInventory(_: AsyncOrderService, io: Io, productId: i64) Err!bool {
        try delayMs(io, 10);
        return @mod(productId, 10) != 0;
    }
    fn processPayment(_: AsyncOrderService, io: Io, amount: f64) Err!bool {
        try delayMs(io, 100);
        return amount > 0;
    }
    fn updateInventory(_: AsyncOrderService, io: Io, products: []const Product) Err!bool {
        try delayMs(io, 20);
        _ = products;
        return true;
    }
    fn sendNotification(_: AsyncOrderService, io: Io, userId: i64, orderId: i64) Err!bool {
        try delayMs(io, 15);
        _ = userId;
        _ = orderId;
        return true;
    }
    fn recordAnalytics(_: AsyncOrderService, io: Io, order: Order) Err!bool {
        try delayMs(io, 5);
        _ = order;
        return true;
    }
    fn processOrderPipeline(self: AsyncOrderService, io: Io, a: Allocator, userId: i64, productIds: []const i64) Err!OrderPipelineResult {
        const ps = AsyncProductService{};
        // Stage 1: fetch product info in parallel
        var fetchFuts: std.ArrayList(Io.Future(Err!?Product)) = .empty;
        for (productIds) |id| try fetchFuts.append(a, io.async(AsyncProductService.getProductById, .{ ps, io, a, id }));
        var products: std.ArrayList(Product) = .empty;
        for (fetchFuts.items) |*f| if (try f.await(io)) |p| try products.append(a, p);
        if (products.items.len != productIds.len) return .{ .err = "Some products not found" };

        // Stage 2: validate inventory (parallel)
        var invFuts: std.ArrayList(Io.Future(Err!bool)) = .empty;
        for (products.items) |p| try invFuts.append(a, io.async(AsyncOrderService.checkInventory, .{ self, io, p.id }));
        for (invFuts.items) |*f| if (!(try f.await(io))) return .{ .err = "Insufficient inventory" };

        // Stage 3: create order and process payment (serial)
        const order = try self.createOrder(io, userId, products.items);
        const paid = try self.processPayment(io, order.total);
        if (!paid) return .{ .err = "Payment failed" };

        // Stage 4: follow-up operations in parallel
        var invUpdF = io.async(AsyncOrderService.updateInventory, .{ self, io, products.items });
        var notifF = io.async(AsyncOrderService.sendNotification, .{ self, io, userId, order.id });
        var anaF = io.async(AsyncOrderService.recordAnalytics, .{ self, io, order });
        _ = try invUpdF.await(io);
        _ = try notifF.await(io);
        _ = try anaF.await(io);
        return .{ .success = order };
    }
    fn processOneOrder(self: AsyncOrderService, io: Io, a: Allocator, sem: *Semaphore, request: OrderRequest) Err!OrderResult {
        sem.acquire();
        defer sem.release();
        const result = try self.processOrderPipeline(io, a, request.userId, request.productIds);
        return switch (result) {
            .success => |o| .{ .success = o },
            .err => |m| .{ .failed = .{ .userId = request.userId, .message = m } },
        };
    }
    fn batchProcessOrders(self: AsyncOrderService, io: Io, a: Allocator, orderRequests: []const OrderRequest) Err![]OrderResult {
        // Concurrency limit to avoid resource exhaustion.
        var semaphore = Semaphore.init(10);
        var futs: std.ArrayList(Io.Future(Err!OrderResult)) = .empty;
        for (orderRequests) |req| try futs.append(a, io.async(AsyncOrderService.processOneOrder, .{ self, io, a, &semaphore, req }));
        var out: std.ArrayList(OrderResult) = .empty;
        for (futs.items) |*f| try out.append(a, try f.await(io));
        return out.toOwnedSlice(a);
    }
};

const AsyncBenchmarkService = struct {
    userService: AsyncUserService = .{},
    productService: AsyncProductService = .{},
    orderService: AsyncOrderService = .{},

    fn runComplexAsyncWorkflow(self: AsyncBenchmarkService, io: Io, a: Allocator, iterations: i64) Err!void {
        // Stage 1: parallel user workflows
        var userFuts: std.ArrayList(Io.Future(Err!WorkflowResult)) = .empty;
        var index: i64 = 1;
        while (index <= iterations) : (index += 1) try userFuts.append(a, io.async(AsyncUserService.processUserWorkflow, .{ self.userService, io, a, index }));

        // Stage 2: product batch processing
        var productIds: std.ArrayList(i64) = .empty;
        var i: i64 = 1;
        while (i <= 100) : (i += 1) try productIds.append(a, i);
        var productBatchF = io.async(AsyncProductService.batchProcessProducts, .{ self.productService, io, a, productIds.items });

        // Stage 3: wait for user workflows
        var successfulUsers: std.ArrayList(WorkflowSuccess) = .empty;
        for (userFuts.items) |*f| switch (try f.await(io)) {
            .success => |s| try successfulUsers.append(a, s),
            .err => {},
        };

        // Stage 4: product metrics computation
        var batchResult = try productBatchF.await(io);
        var products: std.ArrayList(Product) = .empty;
        var vit = batchResult.valueIterator();
        while (vit.next()) |v| if (v.*) |p| try products.append(a, p);
        const metrics = try self.productService.calculateProductMetrics(a, products.items);

        // Stage 5: batch order processing
        var orderRequests: std.ArrayList(OrderRequest) = .empty;
        const takenCount: usize = @min(successfulUsers.items.len, 20);
        var idx: usize = 0;
        while (idx < takenCount) : (idx += 1) {
            const n: usize = 3 + (idx % 5);
            const slice = productIds.items[0..@min(n, productIds.items.len)];
            try orderRequests.append(a, .{ .userId = successfulUsers.items[idx].createdUser.id, .productIds = slice });
        }
        const orderResults = try self.orderService.batchProcessOrders(io, a, orderRequests.items);

        var successfulOrders: i64 = 0;
        var totalRevenue: f64 = 0;
        for (orderResults) |r| switch (r) {
            .success => |o| {
                successfulOrders += 1;
                totalRevenue += o.total;
            },
            .failed => {},
        };

        // console.log output replaced by observable sinks (DATA/compute kept live).
        std.mem.doNotOptimizeAway(successfulUsers.items.len);
        std.mem.doNotOptimizeAway(products.items.len);
        std.mem.doNotOptimizeAway(metrics.averagePrice);
        std.mem.doNotOptimizeAway(metrics.categoryCount);
        std.mem.doNotOptimizeAway(successfulOrders);
        std.mem.doNotOptimizeAway(totalRevenue);
    }

    fn runStressWorker(self: AsyncBenchmarkService, io: Io, a: Allocator, workerId: i64, operations: i64) Err![]const u8 {
        var successCount: i64 = 0;
        const errorCount: i64 = 0;
        var opIndex: i64 = 0;
        while (opIndex < operations) : (opIndex += 1) {
            switch (@mod(opIndex, 4)) {
                0 => {
                    const user = try self.userService.createUser(io, try std.fmt.allocPrint(a, "Worker{d}_User{d}", .{ workerId, opIndex }), try std.fmt.allocPrint(a, "email{d}@test.com", .{opIndex}), 25);
                    _ = try self.userService.updateUser(io, a, user);
                    successCount += 1;
                },
                1 => {
                    const product = try self.productService.createProduct(io, try std.fmt.allocPrint(a, "Product{d}", .{opIndex}), 99.99, try std.fmt.allocPrint(a, "Category{d}", .{@mod(opIndex, 5)}));
                    _ = try self.productService.updateProduct(io, product);
                    successCount += 1;
                },
                2 => {
                    _ = try self.productService.getProductsByCategory(io, a, try std.fmt.allocPrint(a, "Category{d}", .{@mod(opIndex, 5)}));
                    successCount += 1;
                },
                else => {
                    _ = try self.userService.searchUsers(io, a, "User");
                    successCount += 1;
                },
            }
        }
        return std.fmt.allocPrint(a, "Worker {d}: {d} successes, {d} errors", .{ workerId, successCount, errorCount });
    }

    fn runConcurrentStressTest(self: AsyncBenchmarkService, io: Io, a: Allocator, concurrencyLevel: i64, operations: i64) Err!void {
        var workerFuts: std.ArrayList(Io.Future(Err![]const u8)) = .empty;
        var workerId: i64 = 1;
        while (workerId <= concurrencyLevel) : (workerId += 1) try workerFuts.append(a, io.async(AsyncBenchmarkService.runStressWorker, .{ self, io, a, workerId, operations }));
        var totalLen: usize = 0;
        for (workerFuts.items) |*f| totalLen += (try f.await(io)).len;
        std.mem.doNotOptimizeAway(totalLen);
    }
};

// ----- Driver ---------------------------------------------------------------

const IosSizeBenchmark = struct {
    benchmarkService: AsyncBenchmarkService = .{},

    fn runWorkflows(self: *IosSizeBenchmark, io: Io, a: Allocator) void {
        self.benchmarkService.runComplexAsyncWorkflow(io, a, 50) catch {};
        self.benchmarkService.runConcurrentStressTest(io, a, 10, 20) catch {};
    }
};

pub fn runBenchmark() void {
    var threaded: Io.Threaded = .init(std.heap.smp_allocator, .{});
    defer threaded.deinit();
    const io = threaded.io();
    var bench = IosSizeBenchmark{};
    bench.runWorkflows(io, std.heap.smp_allocator);
}

// DCE root: the single exported symbol keeps the whole graph alive.
export fn bench_run() void {
    runBenchmark();
}