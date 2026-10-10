// iOS Size Benchmark - Test Case Implementation
// Generated with Claude AI (https://claude.ai)
//
// Zig 0.16 port of the "async" case (lib.ts is the source of truth). Zig 0.16
// has no `async`/`await` keywords; concurrency is expressed through the new
// std.Io interface. Each TS `async` method becomes an ordinary function taking
// an `io: Io` and returning an error union; `await delay(n)` becomes
// `try delayMs(io, n)` (a cooperative Io.sleep); and the structured fan-out
// `Promise.all(jobs)` becomes an `Io.Group` of `io.async` tasks awaited
// together. The portable thread-pool backend (std.Io.Threaded) drives it, so
// the 1000 workflow jobs run concurrently just like Promise.all. Idiomatic,
// not 1:1: no closures, manual allocation, tagged-union AnyValue. One exported
// entry (bench_run -> runBenchmark) keeps the whole graph alive (DCE root).

const std = @import("std");
const Io = std.Io;
const Allocator = std.mem.Allocator;

// delay + allocation errors, merged (every service method can do both).
const Err = Io.Cancelable || Allocator.Error;

// Cooperative sleep standing in for TS `delay(ms)` (setTimeout). `.awake` is
// the monotonic-equivalent clock in Zig 0.16 (CLOCK_MONOTONIC analogue).
fn delayMs(io: Io, ms: i64) Io.Cancelable!void {
    try Io.sleep(io, Io.Duration.fromMilliseconds(ms), .awake);
}

// Thread-safe global PRNG (Weyl sequence) standing in for Math.random(); the
// 1000 jobs run across threads, so id generation must be race-free.
var rng_state: std.atomic.Value(u64) = .init(0x853c49e6748fea9b);
fn nextU64() u64 {
    const x = rng_state.fetchAdd(0x9E3779B97F4A7C15, .monotonic);
    const z = (x ^ (x >> 31)) *% 0x2545F4914F6CDD1D;
    return z ^ (z >> 29);
}
fn randomId() i64 {
    return 1 + @as(i64, @intCast(nextU64() % 10000));
}
fn randomInRange(min: i64, max: i64) i64 {
    const span: u64 = @intCast(max - min + 1);
    return min + @as(i64, @intCast(nextU64() % span));
}

fn stringHashCode(s: []const u8) i32 {
    var h: i32 = 0;
    for (s) |c| h = h *% 31 +% @as(i32, c);
    return h;
}

fn lowerDup(a: Allocator, s: []const u8) []u8 {
    const out = a.alloc(u8, s.len) catch return &.{};
    for (s, 0..) |c, i| out[i] = std.ascii.toLower(c);
    return out;
}
fn containsIgnoreCase(a: Allocator, haystack: []const u8, needle_lower: []const u8) bool {
    return std.mem.indexOf(u8, lowerDup(a, haystack), needle_lower) != null;
}

const AnyValue = union(enum) {
    str: []const u8,
    num: f64,
};
const StrMap = std.StringHashMapUnmanaged(AnyValue);
const BoolMap = std.StringHashMapUnmanaged(bool);

// ----- Data classes ---------------------------------------------------------

const UserProfile = struct {
    id: i64,
    name: []const u8,
    email: []const u8,
    age: i64,
    fn copy(self: UserProfile, name: []const u8) UserProfile {
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
const Order = struct {
    id: i64,
    userId: i64,
    products: []const Product,
    total: f64,
    fn copyTotal(self: Order, total: f64) Order {
        return .{ .id = self.id, .userId = self.userId, .products = self.products, .total = total };
    }
};
const Review = struct {
    id: i64,
    userId: i64,
    productId: i64,
    rating: i64,
    comment: []const u8,
    fn copyComment(self: Review, comment: []const u8) Review {
        return .{ .id = self.id, .userId = self.userId, .productId = self.productId, .rating = self.rating, .comment = comment };
    }
};
const Category = struct {
    id: i64,
    name: []const u8,
    description: []const u8,
    fn copyDescription(self: Category, description: []const u8) Category {
        return .{ .id = self.id, .name = self.name, .description = description };
    }
};
const Inventory = struct {
    productId: i64,
    quantity: i64,
    location: []const u8,
    fn copyQuantity(self: Inventory, quantity: i64) Inventory {
        return .{ .productId = self.productId, .quantity = quantity, .location = self.location };
    }
};
const Payment = struct { id: i64, orderId: i64, amount: f64, method: []const u8 };
const Shipping = struct { id: i64, orderId: i64, address: []const u8, status: []const u8 };
const Notification = struct { id: i64, userId: i64, message: []const u8, kind: []const u8 };
const Analytics = struct { id: i64, event: []const u8, data: StrMap };

// ----- Services -------------------------------------------------------------

const UserService = struct {
    fn createUser(_: UserService, io: Io, name: []const u8, email: []const u8, age: i64) Err!UserProfile {
        try delayMs(io, 50);
        return .{ .id = randomId(), .name = name, .email = email, .age = age };
    }
    fn updateUser(_: UserService, io: Io, a: Allocator, user: UserProfile) Err!UserProfile {
        try delayMs(io, 30);
        return user.copy(try std.fmt.allocPrint(a, "{s}_updated", .{user.name}));
    }
    fn deleteUser(_: UserService, io: Io, userId: i64) Err!bool {
        try delayMs(io, 20);
        _ = userId;
        return true;
    }
    fn getUserById(_: UserService, io: Io, a: Allocator, userId: i64) Err!?UserProfile {
        try delayMs(io, 10);
        return .{ .id = userId, .name = try std.fmt.allocPrint(a, "User{d}", .{userId}), .email = try std.fmt.allocPrint(a, "user{d}@email.com", .{userId}), .age = 25 };
    }
    fn getAllUsers(_: UserService, io: Io, a: Allocator) Err![]UserProfile {
        try delayMs(io, 100);
        var list: std.ArrayList(UserProfile) = .empty;
        var i: i64 = 1;
        while (i <= 100) : (i += 1) try list.append(a, .{ .id = i, .name = try std.fmt.allocPrint(a, "User{d}", .{i}), .email = try std.fmt.allocPrint(a, "user{d}@email.com", .{i}), .age = 20 + @mod(i, 50) });
        return list.toOwnedSlice(a);
    }
    fn searchUsers(self: UserService, io: Io, a: Allocator, query: []const u8) Err![]UserProfile {
        try delayMs(io, 80);
        const users = try self.getAllUsers(io, a);
        const q = lowerDup(a, query);
        var out: std.ArrayList(UserProfile) = .empty;
        for (users) |u| if (containsIgnoreCase(a, u.name, q)) try out.append(a, u);
        return out.toOwnedSlice(a);
    }
    fn validateUser(_: UserService, user: UserProfile) bool {
        return std.mem.indexOfScalar(u8, user.email, '@') != null and user.name.len > 0 and user.age > 0;
    }
    fn getUsersByAge(self: UserService, io: Io, a: Allocator, minAge: i64, maxAge: i64) Err![]UserProfile {
        try delayMs(io, 60);
        const users = try self.getAllUsers(io, a);
        var out: std.ArrayList(UserProfile) = .empty;
        for (users) |u| if (u.age >= minAge and u.age <= maxAge) try out.append(a, u);
        return out.toOwnedSlice(a);
    }
    fn getUserCount(_: UserService, io: Io) Err!i64 {
        try delayMs(io, 15);
        return 1000;
    }
    fn isEmailTaken(_: UserService, io: Io, email: []const u8) Err!bool {
        try delayMs(io, 25);
        return @mod(stringHashCode(email), 10) == 0;
    }
};

const ProductService = struct {
    fn createProduct(_: ProductService, io: Io, name: []const u8, price: f64, category: []const u8) Err!Product {
        try delayMs(io, 45);
        return .{ .id = randomId(), .name = name, .price = price, .category = category };
    }
    fn updateProduct(_: ProductService, io: Io, product: Product) Err!Product {
        try delayMs(io, 35);
        return product.copyPrice(product.price * 1.1);
    }
    fn deleteProduct(_: ProductService, io: Io, productId: i64) Err!bool {
        try delayMs(io, 20);
        _ = productId;
        return true;
    }
    fn getProductById(_: ProductService, io: Io, a: Allocator, productId: i64) Err!?Product {
        try delayMs(io, 12);
        return .{ .id = productId, .name = try std.fmt.allocPrint(a, "Product{d}", .{productId}), .price = 99.99, .category = "General" };
    }
    fn getAllProducts(_: ProductService, io: Io, a: Allocator) Err![]Product {
        try delayMs(io, 90);
        const cats = [_][]const u8{ "Electronics", "Books", "Clothing", "Food", "Toys" };
        var list: std.ArrayList(Product) = .empty;
        var i: i64 = 1;
        while (i <= 100) : (i += 1) try list.append(a, .{ .id = i, .name = try std.fmt.allocPrint(a, "Product{d}", .{i}), .price = @as(f64, @floatFromInt(@mod(i, 1000))) + 0.99, .category = cats[@intCast(@mod(i, 5))] });
        return list.toOwnedSlice(a);
    }
    fn searchProducts(self: ProductService, io: Io, a: Allocator, query: []const u8) Err![]Product {
        try delayMs(io, 75);
        const products = try self.getAllProducts(io, a);
        const q = lowerDup(a, query);
        var out: std.ArrayList(Product) = .empty;
        for (products) |p| if (containsIgnoreCase(a, p.name, q)) try out.append(a, p);
        return out.toOwnedSlice(a);
    }
    fn getProductsByCategory(self: ProductService, io: Io, a: Allocator, category: []const u8) Err![]Product {
        try delayMs(io, 55);
        const products = try self.getAllProducts(io, a);
        var out: std.ArrayList(Product) = .empty;
        for (products) |p| if (std.mem.eql(u8, p.category, category)) try out.append(a, p);
        return out.toOwnedSlice(a);
    }
    fn getProductsByPriceRange(self: ProductService, io: Io, a: Allocator, minPrice: f64, maxPrice: f64) Err![]Product {
        try delayMs(io, 50);
        const products = try self.getAllProducts(io, a);
        var out: std.ArrayList(Product) = .empty;
        for (products) |p| if (p.price >= minPrice and p.price <= maxPrice) try out.append(a, p);
        return out.toOwnedSlice(a);
    }
    fn getFeaturedProducts(self: ProductService, io: Io, a: Allocator) Err![]Product {
        try delayMs(io, 40);
        const products = try self.getAllProducts(io, a);
        const n: usize = @min(products.len, 10);
        return products[0..n];
    }
    fn getProductCount(_: ProductService, io: Io) Err!i64 {
        try delayMs(io, 15);
        return 500;
    }
    fn calculateDiscount(_: ProductService, io: Io, product: Product, percentage: f64) Err!f64 {
        try delayMs(io, 10);
        return product.price * (1.0 - percentage / 100.0);
    }
    fn isProductAvailable(_: ProductService, io: Io, productId: i64) Err!bool {
        try delayMs(io, 18);
        return @mod(productId, 7) != 0;
    }
};

const OrderService = struct {
    fn createOrder(_: OrderService, io: Io, userId: i64, products: []const Product) Err!Order {
        try delayMs(io, 60);
        var total: f64 = 0;
        for (products) |p| total += p.price;
        return .{ .id = randomId(), .userId = userId, .products = products, .total = total };
    }
    fn updateOrder(_: OrderService, io: Io, order: Order) Err!Order {
        try delayMs(io, 40);
        return order.copyTotal(order.total * 1.05);
    }
    fn cancelOrder(_: OrderService, io: Io, orderId: i64) Err!bool {
        try delayMs(io, 30);
        _ = orderId;
        return true;
    }
    fn getOrderById(_: OrderService, io: Io, a: Allocator, orderId: i64) Err!?Order {
        try delayMs(io, 15);
        _ = a;
        return .{ .id = orderId, .userId = 1, .products = &.{}, .total = 199.99 };
    }
    fn getOrdersByUser(_: OrderService, io: Io, a: Allocator, userId: i64) Err![]Order {
        try delayMs(io, 70);
        var list: std.ArrayList(Order) = .empty;
        var i: i64 = 1;
        while (i <= 20) : (i += 1) try list.append(a, .{ .id = i, .userId = userId, .products = &.{}, .total = @as(f64, @floatFromInt(@mod(i, 500))) + 0.99 });
        return list.toOwnedSlice(a);
    }
    fn getAllOrders(_: OrderService, io: Io, a: Allocator) Err![]Order {
        try delayMs(io, 95);
        var list: std.ArrayList(Order) = .empty;
        var i: i64 = 1;
        while (i <= 100) : (i += 1) try list.append(a, .{ .id = i, .userId = @mod(i, 50) + 1, .products = &.{}, .total = @as(f64, @floatFromInt(@mod(i, 1000))) + 0.99 });
        return list.toOwnedSlice(a);
    }
    fn getOrdersByStatus(self: OrderService, io: Io, a: Allocator, status: []const u8) Err![]Order {
        try delayMs(io, 65);
        _ = status;
        const orders = try self.getAllOrders(io, a);
        const n: usize = @min(orders.len, 50);
        return orders[0..n];
    }
    fn getOrdersByDateRange(self: OrderService, io: Io, a: Allocator, start: i64, end: i64) Err![]Order {
        try delayMs(io, 55);
        _ = start;
        _ = end;
        return self.getAllOrders(io, a);
    }
    fn calculateOrderTotal(_: OrderService, io: Io, order: Order) Err!f64 {
        try delayMs(io, 20);
        var total: f64 = 0;
        for (order.products) |p| total += p.price;
        return total;
    }
    fn applyDiscount(_: OrderService, io: Io, order: Order, percentage: f64) Err!Order {
        try delayMs(io, 25);
        return order.copyTotal(order.total * (1.0 - percentage / 100.0));
    }
    fn getOrderCount(_: OrderService, io: Io) Err!i64 {
        try delayMs(io, 15);
        return 750;
    }
    fn getOrdersByPriceRange(self: OrderService, io: Io, a: Allocator, minTotal: f64, maxTotal: f64) Err![]Order {
        try delayMs(io, 50);
        const orders = try self.getAllOrders(io, a);
        var out: std.ArrayList(Order) = .empty;
        for (orders) |o| if (o.total >= minTotal and o.total <= maxTotal) try out.append(a, o);
        return out.toOwnedSlice(a);
    }
};

const ReviewService = struct {
    fn createReview(_: ReviewService, io: Io, userId: i64, productId: i64, rating: i64, comment: []const u8) Err!Review {
        try delayMs(io, 40);
        return .{ .id = randomId(), .userId = userId, .productId = productId, .rating = rating, .comment = comment };
    }
    fn updateReview(_: ReviewService, io: Io, a: Allocator, review: Review) Err!Review {
        try delayMs(io, 30);
        return review.copyComment(try std.fmt.allocPrint(a, "{s} (edited)", .{review.comment}));
    }
    fn deleteReview(_: ReviewService, io: Io, reviewId: i64) Err!bool {
        try delayMs(io, 20);
        _ = reviewId;
        return true;
    }
    fn flagReview(_: ReviewService, io: Io, reviewId: i64) Err!bool {
        try delayMs(io, 22);
        return @mod(reviewId, 3) == 0;
    }
    fn getReviewById(_: ReviewService, io: Io, productId: i64) Err!?Review {
        try delayMs(io, 12);
        return .{ .id = 1, .userId = 1, .productId = productId, .rating = 5, .comment = "Great" };
    }
    fn getReviewsByProduct(_: ReviewService, io: Io, a: Allocator, productId: i64) Err![]Review {
        try delayMs(io, 70);
        var list: std.ArrayList(Review) = .empty;
        var i: i64 = 1;
        while (i <= 30) : (i += 1) try list.append(a, .{ .id = i, .userId = @mod(i, 50) + 1, .productId = productId, .rating = randomInRange(1, 5), .comment = "Review" });
        return list.toOwnedSlice(a);
    }
    fn getReviewsByUser(_: ReviewService, io: Io, a: Allocator, userId: i64) Err![]Review {
        try delayMs(io, 65);
        var list: std.ArrayList(Review) = .empty;
        var i: i64 = 1;
        while (i <= 15) : (i += 1) try list.append(a, .{ .id = i, .userId = userId, .productId = @mod(i, 100) + 1, .rating = randomInRange(1, 5), .comment = "Review" });
        return list.toOwnedSlice(a);
    }
    fn getReviewsByRating(self: ReviewService, io: Io, a: Allocator, rating: i64) Err![]Review {
        try delayMs(io, 55);
        const reviews = try self.getReviewsByProduct(io, a, 1);
        var out: std.ArrayList(Review) = .empty;
        for (reviews) |r| if (r.rating == rating) try out.append(a, r);
        return out.toOwnedSlice(a);
    }
    fn getAverageRating(self: ReviewService, io: Io, a: Allocator, productId: i64) Err!f64 {
        try delayMs(io, 45);
        const reviews = try self.getReviewsByProduct(io, a, productId);
        if (reviews.len == 0) return 0;
        var sum: i64 = 0;
        for (reviews) |r| sum += r.rating;
        return @as(f64, @floatFromInt(sum)) / @as(f64, @floatFromInt(reviews.len));
    }
    fn getReviewCount(_: ReviewService, io: Io) Err!i64 {
        try delayMs(io, 15);
        return randomInRange(100, 1000);
    }
    fn searchReviews(self: ReviewService, io: Io, a: Allocator, query: []const u8) Err![]Review {
        try delayMs(io, 60);
        _ = query;
        const reviews = try self.getReviewsByProduct(io, a, 1);
        const n: usize = @min(reviews.len, @as(usize, @intCast(randomInRange(1, 10))));
        return reviews[0..n];
    }
    fn getTopReviews(self: ReviewService, io: Io, a: Allocator, limit: i64) Err![]Review {
        try delayMs(io, 50);
        const reviews = try self.getReviewsByProduct(io, a, 1);
        const n: usize = @min(reviews.len, @as(usize, @intCast(limit)));
        return reviews[0..n];
    }
};

const CategoryService = struct {
    fn createCategory(_: CategoryService, io: Io, name: []const u8, description: []const u8) Err!Category {
        try delayMs(io, 35);
        return .{ .id = randomId(), .name = name, .description = description };
    }
    fn updateCategory(_: CategoryService, io: Io, a: Allocator, category: Category) Err!Category {
        try delayMs(io, 28);
        return category.copyDescription(try std.fmt.allocPrint(a, "{s} (updated)", .{category.description}));
    }
    fn deleteCategory(_: CategoryService, io: Io, categoryId: i64) Err!bool {
        try delayMs(io, 20);
        _ = categoryId;
        return true;
    }
    fn getCategoryById(_: CategoryService, io: Io, a: Allocator, categoryId: i64) Err!?Category {
        try delayMs(io, 12);
        return .{ .id = categoryId, .name = try std.fmt.allocPrint(a, "Category{d}", .{categoryId}), .description = "A category" };
    }
    fn getAllCategories(_: CategoryService, io: Io, a: Allocator) Err![]Category {
        try delayMs(io, 60);
        var list: std.ArrayList(Category) = .empty;
        var i: i64 = 1;
        while (i <= 50) : (i += 1) try list.append(a, .{ .id = i, .name = try std.fmt.allocPrint(a, "Category{d}", .{i}), .description = "Description" });
        return list.toOwnedSlice(a);
    }
    fn searchCategories(self: CategoryService, io: Io, a: Allocator, query: []const u8) Err![]Category {
        try delayMs(io, 50);
        const cats = try self.getAllCategories(io, a);
        const q = lowerDup(a, query);
        var out: std.ArrayList(Category) = .empty;
        for (cats) |c| if (containsIgnoreCase(a, c.name, q)) try out.append(a, c);
        return out.toOwnedSlice(a);
    }
    fn getCategoryCount(_: CategoryService, io: Io) Err!i64 {
        try delayMs(io, 15);
        return 50;
    }
    fn getPopularCategories(self: CategoryService, io: Io, a: Allocator, limit: i64) Err![]Category {
        try delayMs(io, 45);
        const cats = try self.getAllCategories(io, a);
        const n: usize = @min(cats.len, @as(usize, @intCast(limit)));
        return cats[0..n];
    }
    fn getCategoryTree(self: CategoryService, io: Io, a: Allocator) Err!usize {
        try delayMs(io, 40);
        const cats = try self.getAllCategories(io, a);
        var tree: std.AutoHashMapUnmanaged(i64, std.ArrayList(Category)) = .empty;
        for (cats) |c| {
            const parent = @mod(c.id, 5);
            const gop = try tree.getOrPut(a, parent);
            if (!gop.found_existing) gop.value_ptr.* = .empty;
            try gop.value_ptr.append(a, c);
        }
        return tree.count();
    }
    fn validateCategory(_: CategoryService, category: Category) bool {
        return category.name.len > 0 and category.description.len > 0;
    }
};

const InventoryService = struct {
    fn addInventory(_: InventoryService, io: Io, productId: i64, quantity: i64, location: []const u8) Err!Inventory {
        try delayMs(io, 40);
        return .{ .productId = productId, .quantity = quantity, .location = location };
    }
    fn updateInventory(_: InventoryService, io: Io, inv: Inventory, quantity: i64) Err!Inventory {
        try delayMs(io, 30);
        return inv.copyQuantity(quantity);
    }
    fn removeInventory(_: InventoryService, io: Io, productId: i64) Err!bool {
        try delayMs(io, 20);
        _ = productId;
        return true;
    }
    fn getInventory(_: InventoryService, io: Io, productId: i64) Err!?Inventory {
        try delayMs(io, 12);
        return .{ .productId = productId, .quantity = randomInRange(0, 1000), .location = "Warehouse A" };
    }
    fn getAllInventory(_: InventoryService, io: Io, a: Allocator) Err![]Inventory {
        try delayMs(io, 70);
        const locs = [_][]const u8{ "Warehouse A", "Warehouse B", "Warehouse C" };
        var list: std.ArrayList(Inventory) = .empty;
        var i: i64 = 1;
        while (i <= 100) : (i += 1) try list.append(a, .{ .productId = i, .quantity = @mod(i, 500), .location = locs[@intCast(@mod(i, 3))] });
        return list.toOwnedSlice(a);
    }
    fn getInventoryByLocation(self: InventoryService, io: Io, a: Allocator, location: []const u8) Err![]Inventory {
        try delayMs(io, 55);
        const inv = try self.getAllInventory(io, a);
        var out: std.ArrayList(Inventory) = .empty;
        for (inv) |it| if (std.mem.eql(u8, it.location, location)) try out.append(a, it);
        return out.toOwnedSlice(a);
    }
    fn getLowStockItems(self: InventoryService, io: Io, a: Allocator, threshold: i64) Err![]Inventory {
        try delayMs(io, 50);
        const inv = try self.getAllInventory(io, a);
        var out: std.ArrayList(Inventory) = .empty;
        for (inv) |it| if (it.quantity < threshold) try out.append(a, it);
        return out.toOwnedSlice(a);
    }
    fn getTotalQuantity(self: InventoryService, io: Io, a: Allocator) Err!i64 {
        try delayMs(io, 45);
        const inv = try self.getAllInventory(io, a);
        var sum: i64 = 0;
        for (inv) |it| sum += it.quantity;
        return sum;
    }
    fn reserveInventory(_: InventoryService, io: Io, productId: i64, quantity: i64) Err!bool {
        try delayMs(io, 25);
        _ = productId;
        return quantity > 0;
    }
    fn releaseInventory(_: InventoryService, io: Io, productId: i64, quantity: i64) Err!bool {
        try delayMs(io, 25);
        _ = productId;
        return quantity > 0;
    }
    fn getInventoryValue(self: InventoryService, io: Io, a: Allocator) Err!f64 {
        try delayMs(io, 40);
        const inv = try self.getAllInventory(io, a);
        var value: f64 = 0;
        for (inv) |it| value += @as(f64, @floatFromInt(it.quantity)) * 9.99;
        return value;
    }
    fn transferInventory(_: InventoryService, io: Io, productId: i64, from: []const u8, to: []const u8) Err!bool {
        try delayMs(io, 35);
        _ = productId;
        return !std.mem.eql(u8, from, to);
    }
};

const PaymentService = struct {
    fn processPayment(_: PaymentService, io: Io, orderId: i64, amount: f64, method: []const u8) Err!Payment {
        try delayMs(io, 80);
        return .{ .id = randomId(), .orderId = orderId, .amount = amount, .method = method };
    }
    fn refundPayment(_: PaymentService, io: Io, paymentId: i64) Err!bool {
        try delayMs(io, 60);
        _ = paymentId;
        return true;
    }
    fn getPaymentById(_: PaymentService, io: Io, paymentId: i64) Err!?Payment {
        try delayMs(io, 15);
        return .{ .id = paymentId, .orderId = 1, .amount = 199.99, .method = "card" };
    }
    fn getPaymentsByOrder(_: PaymentService, io: Io, a: Allocator, orderId: i64) Err![]Payment {
        try delayMs(io, 50);
        var list: std.ArrayList(Payment) = .empty;
        var i: i64 = 1;
        while (i <= 5) : (i += 1) try list.append(a, .{ .id = i, .orderId = orderId, .amount = 99.99, .method = "card" });
        return list.toOwnedSlice(a);
    }
    fn getAllPayments(_: PaymentService, io: Io, a: Allocator) Err![]Payment {
        try delayMs(io, 85);
        const methods = [_][]const u8{ "card", "paypal", "cash", "transfer" };
        var list: std.ArrayList(Payment) = .empty;
        var i: i64 = 1;
        while (i <= 100) : (i += 1) try list.append(a, .{ .id = i, .orderId = @mod(i, 50) + 1, .amount = @as(f64, @floatFromInt(@mod(i, 1000))) + 0.99, .method = methods[@intCast(@mod(i, 4))] });
        return list.toOwnedSlice(a);
    }
    fn getPaymentsByMethod(self: PaymentService, io: Io, a: Allocator, method: []const u8) Err![]Payment {
        try delayMs(io, 55);
        const payments = try self.getAllPayments(io, a);
        var out: std.ArrayList(Payment) = .empty;
        for (payments) |p| if (std.mem.eql(u8, p.method, method)) try out.append(a, p);
        return out.toOwnedSlice(a);
    }
    fn getPaymentsByDateRange(self: PaymentService, io: Io, a: Allocator, start: i64, end: i64) Err![]Payment {
        try delayMs(io, 50);
        _ = start;
        _ = end;
        return self.getAllPayments(io, a);
    }
    fn getTotalRevenue(self: PaymentService, io: Io, a: Allocator) Err!f64 {
        try delayMs(io, 45);
        const payments = try self.getAllPayments(io, a);
        var total: f64 = 0;
        for (payments) |p| total += p.amount;
        return total;
    }
    fn validatePayment(_: PaymentService, payment: Payment) bool {
        return payment.amount > 0 and payment.method.len > 0;
    }
    fn getPaymentMethods(_: PaymentService, io: Io, a: Allocator) Err![][]const u8 {
        try delayMs(io, 20);
        var list: std.ArrayList([]const u8) = .empty;
        for ([_][]const u8{ "card", "paypal", "cash", "transfer" }) |m| try list.append(a, m);
        return list.toOwnedSlice(a);
    }
    fn calculateFees(_: PaymentService, io: Io, amount: f64) Err!f64 {
        try delayMs(io, 18);
        return amount * 0.029 + 0.30;
    }
    fn isPaymentAuthorized(_: PaymentService, io: Io, paymentId: i64) Err!bool {
        try delayMs(io, 25);
        return @mod(paymentId, 10) != 0;
    }
};

const ShippingService = struct {
    fn createShipment(_: ShippingService, io: Io, orderId: i64, address: []const u8) Err!Shipping {
        try delayMs(io, 70);
        return .{ .id = randomId(), .orderId = orderId, .address = address, .status = "pending" };
    }
    fn updateShippingStatus(_: ShippingService, io: Io, shipping: Shipping, status: []const u8) Err!Shipping {
        try delayMs(io, 35);
        return .{ .id = shipping.id, .orderId = shipping.orderId, .address = shipping.address, .status = status };
    }
    fn cancelShipment(_: ShippingService, io: Io, shippingId: i64) Err!bool {
        try delayMs(io, 30);
        _ = shippingId;
        return true;
    }
    fn getShippingById(_: ShippingService, io: Io, shippingId: i64) Err!?Shipping {
        try delayMs(io, 15);
        return .{ .id = shippingId, .orderId = 1, .address = "123 Main St", .status = "shipped" };
    }
    fn getShippingByOrder(_: ShippingService, io: Io, orderId: i64) Err!?Shipping {
        try delayMs(io, 18);
        return .{ .id = 1, .orderId = orderId, .address = "123 Main St", .status = "shipped" };
    }
    fn getAllShipments(_: ShippingService, io: Io, a: Allocator) Err![]Shipping {
        try delayMs(io, 80);
        const statuses = [_][]const u8{ "pending", "shipped", "delivered", "returned" };
        var list: std.ArrayList(Shipping) = .empty;
        var i: i64 = 1;
        while (i <= 100) : (i += 1) try list.append(a, .{ .id = i, .orderId = @mod(i, 50) + 1, .address = "123 Main St", .status = statuses[@intCast(@mod(i, 4))] });
        return list.toOwnedSlice(a);
    }
    fn getShipmentsByStatus(self: ShippingService, io: Io, a: Allocator, status: []const u8) Err![]Shipping {
        try delayMs(io, 55);
        const shipments = try self.getAllShipments(io, a);
        var out: std.ArrayList(Shipping) = .empty;
        for (shipments) |s| if (std.mem.eql(u8, s.status, status)) try out.append(a, s);
        return out.toOwnedSlice(a);
    }
    fn trackShipment(_: ShippingService, io: Io, a: Allocator, shippingId: i64) Err![][]const u8 {
        try delayMs(io, 40);
        _ = shippingId;
        var list: std.ArrayList([]const u8) = .empty;
        const steps = randomInRange(1, 4);
        var i: i64 = 0;
        while (i < steps) : (i += 1) try list.append(a, "checkpoint");
        return list.toOwnedSlice(a);
    }
    fn estimateDelivery(_: ShippingService, io: Io, shippingId: i64) Err!i64 {
        try delayMs(io, 25);
        _ = shippingId;
        return randomInRange(1, 7);
    }
    fn calculateShippingCost(_: ShippingService, io: Io, weight: f64, distance: f64) Err!f64 {
        try delayMs(io, 20);
        return weight * 0.5 + distance * 0.1;
    }
    fn getAvailableCarriers(_: ShippingService, io: Io, a: Allocator) Err![][]const u8 {
        try delayMs(io, 18);
        var list: std.ArrayList([]const u8) = .empty;
        for ([_][]const u8{ "UPS", "FedEx", "DHL", "USPS" }) |c| try list.append(a, c);
        return list.toOwnedSlice(a);
    }
    fn schedulePickup(_: ShippingService, io: Io, shippingId: i64) Err!bool {
        try delayMs(io, 30);
        return @mod(shippingId, 2) == 0;
    }
};

const NotificationService = struct {
    fn sendNotification(_: NotificationService, io: Io, userId: i64, message: []const u8, kind: []const u8) Err!Notification {
        try delayMs(io, 50);
        return .{ .id = randomId(), .userId = userId, .message = message, .kind = kind };
    }
    fn deleteNotification(_: NotificationService, io: Io, notificationId: i64) Err!bool {
        try delayMs(io, 20);
        _ = notificationId;
        return true;
    }
    fn getNotificationById(_: NotificationService, io: Io, notificationId: i64) Err!?Notification {
        try delayMs(io, 12);
        return .{ .id = notificationId, .userId = 1, .message = "Hello", .kind = "info" };
    }
    fn getNotificationsByUser(_: NotificationService, io: Io, a: Allocator, userId: i64) Err![]Notification {
        try delayMs(io, 60);
        const kinds = [_][]const u8{ "info", "warning", "error", "success" };
        var list: std.ArrayList(Notification) = .empty;
        var i: i64 = 1;
        while (i <= 20) : (i += 1) try list.append(a, .{ .id = i, .userId = userId, .message = "Message", .kind = kinds[@intCast(@mod(i, 4))] });
        return list.toOwnedSlice(a);
    }
    fn getNotificationsByType(self: NotificationService, io: Io, a: Allocator, kind: []const u8) Err![]Notification {
        try delayMs(io, 50);
        const notifs = try self.getNotificationsByUser(io, a, 1);
        var out: std.ArrayList(Notification) = .empty;
        for (notifs) |n| if (std.mem.eql(u8, n.kind, kind)) try out.append(a, n);
        return out.toOwnedSlice(a);
    }
    fn markAsRead(_: NotificationService, io: Io, notificationId: i64) Err!bool {
        try delayMs(io, 18);
        _ = notificationId;
        return true;
    }
    fn markAllAsRead(_: NotificationService, io: Io, userId: i64) Err!i64 {
        try delayMs(io, 35);
        _ = userId;
        return randomInRange(0, 20);
    }
    fn getUnreadCount(_: NotificationService, io: Io, userId: i64) Err!i64 {
        try delayMs(io, 25);
        _ = userId;
        return randomInRange(0, 50);
    }
    fn sendBulkNotification(_: NotificationService, io: Io, a: Allocator, userIds: []const i64, message: []const u8) Err![]Notification {
        try delayMs(io, 90);
        var list: std.ArrayList(Notification) = .empty;
        for (userIds) |uid| try list.append(a, .{ .id = randomId(), .userId = uid, .message = message, .kind = "info" });
        return list.toOwnedSlice(a);
    }
    fn scheduleNotification(_: NotificationService, io: Io, userId: i64, message: []const u8, delayMsArg: i64) Err!bool {
        try delayMs(io, 30);
        _ = userId;
        _ = message;
        return delayMsArg > 0;
    }
    fn getNotificationTypes(_: NotificationService, io: Io, a: Allocator) Err![][]const u8 {
        try delayMs(io, 15);
        var list: std.ArrayList([]const u8) = .empty;
        for ([_][]const u8{ "info", "warning", "error", "success" }) |t| try list.append(a, t);
        return list.toOwnedSlice(a);
    }
    fn updateNotificationPreferences(_: NotificationService, io: Io, userId: i64, prefs: BoolMap) Err!bool {
        try delayMs(io, 40);
        _ = userId;
        return prefs.count() > 0;
    }
};

const AnalyticsService = struct {
    fn trackEvent(_: AnalyticsService, io: Io, a: Allocator, event: []const u8, data: StrMap) Err!Analytics {
        try delayMs(io, 30);
        _ = a;
        return .{ .id = randomId(), .event = event, .data = data };
    }
    fn getEventById(_: AnalyticsService, io: Io, eventId: i64) Err!?Analytics {
        try delayMs(io, 12);
        _ = eventId;
        return .{ .id = 1, .event = "page_view", .data = .empty };
    }
    fn getEventsByType(_: AnalyticsService, io: Io, a: Allocator, event: []const u8) Err![]Analytics {
        try delayMs(io, 65);
        var list: std.ArrayList(Analytics) = .empty;
        var i: i64 = 1;
        while (i <= 50) : (i += 1) try list.append(a, .{ .id = i, .event = event, .data = .empty });
        return list.toOwnedSlice(a);
    }
    fn getEventsByDateRange(self: AnalyticsService, io: Io, a: Allocator, start: i64, end: i64) Err![]Analytics {
        try delayMs(io, 55);
        _ = start;
        _ = end;
        return self.getEventsByType(io, a, "page_view");
    }
    fn getUserEvents(_: AnalyticsService, io: Io, a: Allocator, userId: i64) Err![]Analytics {
        try delayMs(io, 50);
        _ = userId;
        var list: std.ArrayList(Analytics) = .empty;
        var i: i64 = 1;
        while (i <= 25) : (i += 1) try list.append(a, .{ .id = i, .event = "click", .data = .empty });
        return list.toOwnedSlice(a);
    }
    fn getPopularEvents(self: AnalyticsService, io: Io, a: Allocator, limit: i64) Err![]Analytics {
        try delayMs(io, 45);
        const events = try self.getEventsByType(io, a, "page_view");
        const n: usize = @min(events.len, @as(usize, @intCast(limit)));
        return events[0..n];
    }
    fn getEventCount(_: AnalyticsService, io: Io) Err!i64 {
        try delayMs(io, 15);
        return randomInRange(1000, 10000);
    }
    fn getUniqueUsers(_: AnalyticsService, io: Io) Err!i64 {
        try delayMs(io, 20);
        return randomInRange(100, 1000);
    }
    fn generateReport(_: AnalyticsService, io: Io, a: Allocator) Err!StrMap {
        try delayMs(io, 70);
        var report: StrMap = .empty;
        try report.put(a, "totalEvents", .{ .num = @floatFromInt(randomInRange(1000, 10000)) });
        try report.put(a, "uniqueUsers", .{ .num = @floatFromInt(randomInRange(100, 1000)) });
        try report.put(a, "topEvent", .{ .str = "page_view" });
        return report;
    }
    fn getTopPages(_: AnalyticsService, io: Io, a: Allocator, limit: i64) Err![][]const u8 {
        try delayMs(io, 40);
        var list: std.ArrayList([]const u8) = .empty;
        var i: i64 = 0;
        while (i < limit) : (i += 1) try list.append(a, try std.fmt.allocPrint(a, "/page/{d}", .{i}));
        return list.toOwnedSlice(a);
    }
    fn getConversionRate(_: AnalyticsService, io: Io) Err!f64 {
        try delayMs(io, 25);
        return @as(f64, @floatFromInt(randomInRange(1, 100))) / 100.0;
    }
    fn exportAnalytics(_: AnalyticsService, io: Io, a: Allocator, format: []const u8) Err![]const u8 {
        try delayMs(io, 60);
        return std.fmt.allocPrint(a, "analytics_export.{s}", .{format});
    }
};

// ----- Driver ---------------------------------------------------------------

const IosSizeBenchmark = struct {
    userService: UserService = .{},
    productService: ProductService = .{},
    orderService: OrderService = .{},
    reviewService: ReviewService = .{},
    categoryService: CategoryService = .{},
    inventoryService: InventoryService = .{},
    paymentService: PaymentService = .{},
    shippingService: ShippingService = .{},
    notificationService: NotificationService = .{},
    analyticsService: AnalyticsService = .{},

    fn processUserWorkflow(self: *IosSizeBenchmark, io: Io, a: Allocator, index: i64) Err!void {
        const s = self.userService;
        const user = try s.createUser(io, try std.fmt.allocPrint(a, "User{d}", .{index}), try std.fmt.allocPrint(a, "user{d}@email.com", .{index}), 20 + @mod(index, 50));
        const updated = try s.updateUser(io, a, user);
        _ = try s.getUserById(io, a, user.id);
        _ = try s.getAllUsers(io, a);
        _ = try s.searchUsers(io, a, "User");
        _ = s.validateUser(updated);
        _ = try s.getUsersByAge(io, a, 20, 40);
        _ = try s.getUserCount(io);
        _ = try s.isEmailTaken(io, user.email);
        _ = try s.deleteUser(io, user.id);
        std.mem.doNotOptimizeAway(updated.id);
    }

    fn processProductWorkflow(self: *IosSizeBenchmark, io: Io, a: Allocator, index: i64) Err!void {
        const s = self.productService;
        const product = try s.createProduct(io, try std.fmt.allocPrint(a, "Product{d}", .{index}), 99.99, "Electronics");
        const updated = try s.updateProduct(io, product);
        _ = try s.getProductById(io, a, product.id);
        _ = try s.getAllProducts(io, a);
        _ = try s.searchProducts(io, a, "Product");
        _ = try s.getProductsByCategory(io, a, "Electronics");
        _ = try s.getProductsByPriceRange(io, a, 0, 500);
        _ = try s.getFeaturedProducts(io, a);
        _ = try s.getProductCount(io);
        _ = try s.calculateDiscount(io, product, 10);
        _ = try s.isProductAvailable(io, product.id);
        _ = try s.deleteProduct(io, product.id);
        std.mem.doNotOptimizeAway(updated.price);
    }

    fn processOrderWorkflow(self: *IosSizeBenchmark, io: Io, a: Allocator, index: i64) Err!void {
        const s = self.orderService;
        const order = try s.createOrder(io, index, &.{});
        const updated = try s.updateOrder(io, order);
        _ = try s.getOrderById(io, a, order.id);
        _ = try s.getOrdersByUser(io, a, index);
        _ = try s.getAllOrders(io, a);
        _ = try s.getOrdersByStatus(io, a, "pending");
        _ = try s.getOrdersByDateRange(io, a, 0, 100);
        _ = try s.calculateOrderTotal(io, order);
        _ = try s.applyDiscount(io, order, 15);
        _ = try s.getOrderCount(io);
        _ = try s.getOrdersByPriceRange(io, a, 0, 500);
        _ = try s.cancelOrder(io, order.id);
        std.mem.doNotOptimizeAway(updated.total);
    }

    fn processReviewWorkflow(self: *IosSizeBenchmark, io: Io, a: Allocator, index: i64) Err!void {
        const s = self.reviewService;
        const review = try s.createReview(io, index, index, randomInRange(1, 5), "Good product");
        const updated = try s.updateReview(io, a, review);
        _ = try s.getReviewById(io, review.productId);
        _ = try s.getReviewsByProduct(io, a, index);
        _ = try s.getReviewsByUser(io, a, index);
        _ = try s.getReviewsByRating(io, a, 5);
        _ = try s.getAverageRating(io, a, index);
        _ = try s.getReviewCount(io);
        _ = try s.searchReviews(io, a, "good");
        _ = try s.getTopReviews(io, a, 10);
        _ = try s.flagReview(io, review.id);
        _ = try s.deleteReview(io, review.id);
        std.mem.doNotOptimizeAway(updated.id);
    }

    fn processCategoryWorkflow(self: *IosSizeBenchmark, io: Io, a: Allocator, index: i64) Err!void {
        const s = self.categoryService;
        const category = try s.createCategory(io, try std.fmt.allocPrint(a, "Category{d}", .{index}), "Description");
        const updated = try s.updateCategory(io, a, category);
        _ = try s.getCategoryById(io, a, category.id);
        _ = try s.getAllCategories(io, a);
        _ = try s.searchCategories(io, a, "Category");
        _ = try s.getCategoryCount(io);
        _ = try s.getPopularCategories(io, a, 10);
        _ = try s.getCategoryTree(io, a);
        _ = s.validateCategory(updated);
        _ = try s.deleteCategory(io, category.id);
        std.mem.doNotOptimizeAway(updated.id);
    }

    fn processInventoryWorkflow(self: *IosSizeBenchmark, io: Io, a: Allocator, index: i64) Err!void {
        const s = self.inventoryService;
        const inv = try s.addInventory(io, index, randomInRange(0, 1000), "Warehouse A");
        const updated = try s.updateInventory(io, inv, 500);
        _ = try s.getInventory(io, index);
        _ = try s.getAllInventory(io, a);
        _ = try s.getInventoryByLocation(io, a, "Warehouse A");
        _ = try s.getLowStockItems(io, a, 100);
        _ = try s.getTotalQuantity(io, a);
        _ = try s.reserveInventory(io, index, 10);
        _ = try s.releaseInventory(io, index, 5);
        _ = try s.getInventoryValue(io, a);
        _ = try s.transferInventory(io, index, "Warehouse A", "Warehouse B");
        _ = try s.removeInventory(io, index);
        std.mem.doNotOptimizeAway(updated.quantity);
    }

    fn processPaymentWorkflow(self: *IosSizeBenchmark, io: Io, a: Allocator, index: i64) Err!void {
        const s = self.paymentService;
        const payment = try s.processPayment(io, index, 199.99, "card");
        _ = try s.getPaymentById(io, payment.id);
        _ = try s.getPaymentsByOrder(io, a, index);
        _ = try s.getAllPayments(io, a);
        _ = try s.getPaymentsByMethod(io, a, "card");
        _ = try s.getPaymentsByDateRange(io, a, 0, 100);
        _ = try s.getTotalRevenue(io, a);
        _ = s.validatePayment(payment);
        _ = try s.getPaymentMethods(io, a);
        _ = try s.calculateFees(io, payment.amount);
        _ = try s.isPaymentAuthorized(io, payment.id);
        _ = try s.refundPayment(io, payment.id);
        std.mem.doNotOptimizeAway(payment.amount);
    }

    fn processShippingWorkflow(self: *IosSizeBenchmark, io: Io, a: Allocator, index: i64) Err!void {
        const s = self.shippingService;
        const shipment = try s.createShipment(io, index, "123 Main St");
        const updated = try s.updateShippingStatus(io, shipment, "shipped");
        _ = try s.getShippingById(io, shipment.id);
        _ = try s.getShippingByOrder(io, index);
        _ = try s.getAllShipments(io, a);
        _ = try s.getShipmentsByStatus(io, a, "shipped");
        _ = try s.trackShipment(io, a, shipment.id);
        _ = try s.estimateDelivery(io, shipment.id);
        _ = try s.calculateShippingCost(io, 2.5, 100);
        _ = try s.getAvailableCarriers(io, a);
        _ = try s.schedulePickup(io, shipment.id);
        _ = try s.cancelShipment(io, shipment.id);
        std.mem.doNotOptimizeAway(updated.id);
    }

    fn processNotificationWorkflow(self: *IosSizeBenchmark, io: Io, a: Allocator, index: i64) Err!void {
        const s = self.notificationService;
        const notification = try s.sendNotification(io, index, "Hello", "info");
        _ = try s.getNotificationById(io, notification.id);
        _ = try s.getNotificationsByUser(io, a, index);
        _ = try s.getNotificationsByType(io, a, "info");
        _ = try s.markAsRead(io, notification.id);
        _ = try s.markAllAsRead(io, index);
        _ = try s.getUnreadCount(io, index);
        _ = try s.sendBulkNotification(io, a, &.{ 1, 2, 3 }, "Bulk");
        _ = try s.scheduleNotification(io, index, "Later", 1000);
        _ = try s.getNotificationTypes(io, a);
        var prefs: BoolMap = .empty;
        try prefs.put(a, "email", true);
        _ = try s.updateNotificationPreferences(io, index, prefs);
        _ = try s.deleteNotification(io, notification.id);
        std.mem.doNotOptimizeAway(notification.id);
    }

    fn processAnalyticsWorkflow(self: *IosSizeBenchmark, io: Io, a: Allocator, index: i64) Err!void {
        const s = self.analyticsService;
        var data: StrMap = .empty;
        try data.put(a, "page", .{ .str = "home" });
        const event = try s.trackEvent(io, a, "page_view", data);
        _ = try s.getEventById(io, event.id);
        _ = try s.getEventsByType(io, a, "page_view");
        _ = try s.getEventsByDateRange(io, a, 0, 100);
        _ = try s.getUserEvents(io, a, index);
        _ = try s.getPopularEvents(io, a, 10);
        _ = try s.getEventCount(io);
        _ = try s.getUniqueUsers(io);
        _ = try s.generateReport(io, a);
        _ = try s.getTopPages(io, a, 10);
        _ = try s.getConversionRate(io);
        _ = try s.exportAnalytics(io, a, "json");
        std.mem.doNotOptimizeAway(event.id);
    }

    // Io.Group tasks must return `Cancelable!void`; our workflows return the
    // wider `Err` (delay + allocation). These adapters swallow OutOfMemory so
    // the group sees the plain cooperative-cancellation signature it expects.
    fn wUser(self: *IosSizeBenchmark, io: Io, a: Allocator, i: i64) void {
        self.processUserWorkflow(io, a, i) catch {};
    }
    fn wProduct(self: *IosSizeBenchmark, io: Io, a: Allocator, i: i64) void {
        self.processProductWorkflow(io, a, i) catch {};
    }
    fn wOrder(self: *IosSizeBenchmark, io: Io, a: Allocator, i: i64) void {
        self.processOrderWorkflow(io, a, i) catch {};
    }
    fn wReview(self: *IosSizeBenchmark, io: Io, a: Allocator, i: i64) void {
        self.processReviewWorkflow(io, a, i) catch {};
    }
    fn wCategory(self: *IosSizeBenchmark, io: Io, a: Allocator, i: i64) void {
        self.processCategoryWorkflow(io, a, i) catch {};
    }
    fn wInventory(self: *IosSizeBenchmark, io: Io, a: Allocator, i: i64) void {
        self.processInventoryWorkflow(io, a, i) catch {};
    }
    fn wPayment(self: *IosSizeBenchmark, io: Io, a: Allocator, i: i64) void {
        self.processPaymentWorkflow(io, a, i) catch {};
    }
    fn wShipping(self: *IosSizeBenchmark, io: Io, a: Allocator, i: i64) void {
        self.processShippingWorkflow(io, a, i) catch {};
    }
    fn wNotification(self: *IosSizeBenchmark, io: Io, a: Allocator, i: i64) void {
        self.processNotificationWorkflow(io, a, i) catch {};
    }
    fn wAnalytics(self: *IosSizeBenchmark, io: Io, a: Allocator, i: i64) void {
        self.processAnalyticsWorkflow(io, a, i) catch {};
    }

    fn runWorkflows(self: *IosSizeBenchmark, io: Io, a: Allocator) void {
        var g: Io.Group = .init;
        var index: i64 = 0;
        while (index < 100) : (index += 1) {
            g.async(io, wUser, .{ self, io, a, index });
            g.async(io, wProduct, .{ self, io, a, index });
            g.async(io, wOrder, .{ self, io, a, index });
            g.async(io, wReview, .{ self, io, a, index });
            g.async(io, wCategory, .{ self, io, a, index });
            g.async(io, wInventory, .{ self, io, a, index });
            g.async(io, wPayment, .{ self, io, a, index });
            g.async(io, wShipping, .{ self, io, a, index });
            g.async(io, wNotification, .{ self, io, a, index });
            g.async(io, wAnalytics, .{ self, io, a, index });
        }
        g.await(io) catch {};
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