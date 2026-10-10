// iOS Size Benchmark - Test Case Implementation
// Generated with Claude AI (https://claude.ai)
//
// Zig port of the "callback" (higher-order function) case. Idiomatic Zig has no
// closures, so the TS `(value) => void` callbacks are modeled as function
// pointers `*const fn (*Sink, T) void` paired with an explicit `*Sink` context
// — the honest Zig analogue of a JS closure that captures its surrounding
// state (here the accumulator + PRNG). A comptime `recorder(T)` factory
// monomorphizes one typed callback per payload type, and a comptime-recursive
// `record` walks any value (scalars, strings, structs, slices, optionals,
// unions) into the sink so nothing is dead-code eliminated. The deep callback
// *nesting* of the TS is flattened to straight-line data flow (each service
// method returns its produced value and also invokes the callback) — a genuine
// structural difference from the OO/CPS versions, documented here, not a 1:1
// mirror. A single exported entry exercises every service method.

const std = @import("std");
const Allocator = std.mem.Allocator;

// Kotlin's Map<String, Any> payload only ever holds strings and numbers here;
// model it as a concrete tagged union (idiomatic Zig for a closed "any").
const AnyValue = union(enum) { str: []const u8, num: f64 };
const Kv = struct { key: []const u8, value: AnyValue };

// "Closure object": the captured state every TS callback closed over.
const Sink = struct {
    acc: i64 = 0,
    seed: u64 = 0x9E3779B97F4A7C15,

    fn next(self: *Sink) u64 {
        var x = self.seed;
        x ^= x << 13;
        x ^= x >> 7;
        x ^= x << 17;
        self.seed = x;
        return x;
    }
    fn rand(self: *Sink, min: i64, max: i64) i64 {
        const span: u64 = @intCast(max - min + 1);
        return min + @as(i64, @intCast(self.next() % span));
    }
    fn num(self: *Sink, n: i64) void {
        self.acc +%= n;
    }
    fn note(self: *Sink, s: []const u8) void {
        self.acc +%= @intCast(s.len);
    }
    fn flag(self: *Sink, b: bool) void {
        self.acc +%= @intFromBool(b);
    }
};

// Callback type: function pointer + the Sink context (no closures in Zig).
fn Cb(comptime T: type) type {
    return *const fn (*Sink, T) void;
}

// Comptime-recursive walk of any payload into the sink.
fn record(s: *Sink, comptime T: type, v: T) void {
    switch (@typeInfo(T)) {
        .bool => s.flag(v),
        .int, .comptime_int => s.num(@intCast(v)),
        .float, .comptime_float => s.num(@intFromFloat(v)),
        .optional => if (v) |x| record(s, @TypeOf(x), x),
        .pointer => |p| {
            if (p.size == .slice) {
                if (p.child == u8) s.note(v) else for (v) |x| record(s, p.child, x);
            }
        },
        .@"struct" => inline for (std.meta.fields(T)) |fld| record(s, fld.type, @field(v, fld.name)),
        .@"union" => switch (v) {
            inline else => |payload| record(s, @TypeOf(payload), payload),
        },
        else => {},
    }
}

// recorder(T) is the typed "lambda" handed to each service method.
fn recorder(comptime T: type) Cb(T) {
    return struct {
        fn f(s: *Sink, v: T) void {
            record(s, T, v);
        }
    }.f;
}

fn randomId(sink: *Sink) i64 {
    return 1 + sink.rand(0, 9999);
}

fn stringHashCode(s: []const u8) i32 {
    var h: i32 = 0;
    for (s) |c| h = h *% 31 +% @as(i32, @intCast(c));
    return h;
}

fn shuffled(comptime T: type, a: Allocator, sink: *Sink, src: []const T) ![]T {
    const r = try a.dupe(T, src);
    var i: usize = r.len;
    while (i > 1) {
        i -= 1;
        const j: usize = @intCast(sink.rand(0, @intCast(i)));
        const t = r[i];
        r[i] = r[j];
        r[j] = t;
    }
    return r;
}

// ---- Data model (classes -> structs with copy helpers) --------------------

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
const Notification = struct { id: i64, userId: i64, message: []const u8, type_: []const u8 };
const Analytics = struct { id: i64, event: []const u8, data: []const Kv };
const TreeNode = struct { parent: Category, children: []const Category };

// ---- Services (stateless namespaces; each method takes a callback) --------

const UserService = struct {
    fn createUser(a: Allocator, sink: *Sink, name: []const u8, email: []const u8, age: i64, cb: Cb(UserProfile)) !UserProfile {
        const u = UserProfile{ .id = randomId(sink), .name = name, .email = email, .age = age };
        _ = a;
        cb(sink, u);
        return u;
    }
    fn updateUser(a: Allocator, sink: *Sink, user: UserProfile, cb: Cb(UserProfile)) !UserProfile {
        const u = user.copy(try std.fmt.allocPrint(a, "{s}_updated", .{user.name}));
        cb(sink, u);
        return u;
    }
    fn deleteUser(sink: *Sink, _: i64, cb: Cb(bool)) void {
        cb(sink, true);
    }
    fn getUserById(a: Allocator, sink: *Sink, userId: i64, cb: Cb(?UserProfile)) !?UserProfile {
        const u = UserProfile{
            .id = userId,
            .name = try std.fmt.allocPrint(a, "User{d}", .{userId}),
            .email = try std.fmt.allocPrint(a, "user{d}@email.com", .{userId}),
            .age = 25,
        };
        cb(sink, u);
        return u;
    }
    fn getAllUsers(a: Allocator, sink: *Sink, cb: Cb([]const UserProfile)) ![]const UserProfile {
        var list: std.ArrayList(UserProfile) = .empty;
        var i: i64 = 1;
        while (i <= 100) : (i += 1) try list.append(a, .{
            .id = i,
            .name = try std.fmt.allocPrint(a, "User{d}", .{i}),
            .email = try std.fmt.allocPrint(a, "user{d}@email.com", .{i}),
            .age = 20 + @mod(i, 50),
        });
        const users = try list.toOwnedSlice(a);
        cb(sink, users);
        return users;
    }
    fn searchUsers(a: Allocator, sink: *Sink, _: []const u8, cb: Cb([]const UserProfile)) !void {
        const users = try getAllUsers(a, sink, recorder([]const UserProfile));
        cb(sink, users); // all names contain "user"
    }
    fn validateUser(sink: *Sink, user: UserProfile, cb: Cb(bool)) void {
        const ok = std.mem.indexOfScalar(u8, user.email, '@') != null and user.name.len > 0 and user.age > 0;
        cb(sink, ok);
    }
    fn getUsersByAge(a: Allocator, sink: *Sink, minAge: i64, maxAge: i64, cb: Cb([]const UserProfile)) !void {
        const all = try getAllUsers(a, sink, recorder([]const UserProfile));
        var list: std.ArrayList(UserProfile) = .empty;
        for (all) |u| if (u.age >= minAge and u.age <= maxAge) try list.append(a, u);
        cb(sink, try list.toOwnedSlice(a));
    }
    fn getUserCount(sink: *Sink, cb: Cb(i64)) void {
        cb(sink, 1000);
    }
    fn isEmailTaken(sink: *Sink, email: []const u8, cb: Cb(bool)) void {
        cb(sink, @mod(stringHashCode(email), 10) == 0);
    }
};

const ProductService = struct {
    fn createProduct(sink: *Sink, name: []const u8, price: f64, category: []const u8, cb: Cb(Product)) Product {
        const p = Product{ .id = randomId(sink), .name = name, .price = price, .category = category };
        cb(sink, p);
        return p;
    }
    fn updateProduct(sink: *Sink, product: Product, cb: Cb(Product)) Product {
        const p = product.copyPrice(product.price * 1.1);
        cb(sink, p);
        return p;
    }
    fn deleteProduct(sink: *Sink, _: i64, cb: Cb(bool)) void {
        cb(sink, true);
    }
    fn getProductById(a: Allocator, sink: *Sink, productId: i64, cb: Cb(?Product)) !?Product {
        const p = Product{ .id = productId, .name = try std.fmt.allocPrint(a, "Product{d}", .{productId}), .price = 99.99, .category = "Electronics" };
        cb(sink, p);
        return p;
    }
    fn getAllProducts(a: Allocator, sink: *Sink, cb: Cb([]const Product)) ![]const Product {
        var list: std.ArrayList(Product) = .empty;
        var i: i64 = 1;
        while (i <= 500) : (i += 1) try list.append(a, .{
            .id = i,
            .name = try std.fmt.allocPrint(a, "Product{d}", .{i}),
            .price = 50.0 + @as(f64, @floatFromInt(@mod(i, 200))),
            .category = try std.fmt.allocPrint(a, "Category{d}", .{@mod(i, 10)}),
        });
        const products = try list.toOwnedSlice(a);
        cb(sink, products);
        return products;
    }
    fn searchProducts(a: Allocator, sink: *Sink, _: []const u8, cb: Cb([]const Product)) !void {
        cb(sink, try getAllProducts(a, sink, recorder([]const Product)));
    }
    fn getProductsByCategory(a: Allocator, sink: *Sink, category: []const u8, cb: Cb([]const Product)) !void {
        const all = try getAllProducts(a, sink, recorder([]const Product));
        var list: std.ArrayList(Product) = .empty;
        for (all) |p| if (std.mem.eql(u8, p.category, category)) try list.append(a, p);
        cb(sink, try list.toOwnedSlice(a));
    }
    fn getProductsByPriceRange(a: Allocator, sink: *Sink, minPrice: f64, maxPrice: f64, cb: Cb([]const Product)) !void {
        const all = try getAllProducts(a, sink, recorder([]const Product));
        var list: std.ArrayList(Product) = .empty;
        for (all) |p| if (p.price >= minPrice and p.price <= maxPrice) try list.append(a, p);
        cb(sink, try list.toOwnedSlice(a));
    }
    fn getFeaturedProducts(a: Allocator, sink: *Sink, count: usize, cb: Cb([]const Product)) !void {
        const all = try getAllProducts(a, sink, recorder([]const Product));
        const sh = try shuffled(Product, a, sink, all);
        cb(sink, sh[0..@min(count, sh.len)]);
    }
    fn getProductCount(sink: *Sink, cb: Cb(i64)) void {
        cb(sink, 500);
    }
    fn calculateDiscount(sink: *Sink, product: Product, percentage: f64, cb: Cb(f64)) void {
        cb(sink, product.price * (1 - percentage / 100));
    }
    fn isProductAvailable(sink: *Sink, productId: i64, cb: Cb(bool)) void {
        cb(sink, @mod(productId, 10) != 0);
    }
};

const OrderService = struct {
    fn totalOf(products: []const Product) f64 {
        var t: f64 = 0;
        for (products) |p| t += p.price;
        return t;
    }
    fn createOrder(sink: *Sink, userId: i64, products: []const Product, cb: Cb(Order)) Order {
        const o = Order{ .id = randomId(sink), .userId = userId, .products = products, .total = totalOf(products) };
        cb(sink, o);
        return o;
    }
    fn updateOrder(sink: *Sink, order: Order, cb: Cb(Order)) Order {
        const o = order.copyTotal(order.total * 1.05);
        cb(sink, o);
        return o;
    }
    fn cancelOrder(sink: *Sink, _: i64, cb: Cb(bool)) void {
        cb(sink, true);
    }
    fn getOrderById(a: Allocator, sink: *Sink, orderId: i64, cb: Cb(?Order)) !?Order {
        const products = try a.dupe(Product, &[_]Product{.{ .id = 1, .name = "Sample", .price = 99.99, .category = "Sample" }});
        const o = Order{ .id = orderId, .userId = 1, .products = products, .total = 99.99 };
        cb(sink, o);
        return o;
    }
    fn getOrdersByUser(a: Allocator, sink: *Sink, userId: i64, cb: Cb([]const Order)) !void {
        var list: std.ArrayList(Order) = .empty;
        var i: i64 = 1;
        while (i <= 20) : (i += 1) {
            const products = try a.dupe(Product, &[_]Product{.{ .id = i, .name = try std.fmt.allocPrint(a, "Product{d}", .{i}), .price = 50.0, .category = "Category" }});
            try list.append(a, .{ .id = i, .userId = userId, .products = products, .total = 50.0 });
        }
        cb(sink, try list.toOwnedSlice(a));
    }
    fn getAllOrders(a: Allocator, sink: *Sink, cb: Cb([]const Order)) ![]const Order {
        var list: std.ArrayList(Order) = .empty;
        var i: i64 = 1;
        while (i <= 200) : (i += 1) {
            const products = try a.dupe(Product, &[_]Product{.{ .id = i, .name = try std.fmt.allocPrint(a, "Product{d}", .{i}), .price = 75.0, .category = "Category" }});
            try list.append(a, .{ .id = i, .userId = @mod(i, 50), .products = products, .total = 75.0 });
        }
        const orders = try list.toOwnedSlice(a);
        cb(sink, orders);
        return orders;
    }
    fn getOrdersByStatus(a: Allocator, sink: *Sink, status: []const u8, cb: Cb([]const Order)) !void {
        const all = try getAllOrders(a, sink, recorder([]const Order));
        const key = @mod(stringHashCode(status), 5);
        var list: std.ArrayList(Order) = .empty;
        for (all) |o| if (@mod(o.id, 5) == key) try list.append(a, o);
        cb(sink, try list.toOwnedSlice(a));
    }
    fn getOrdersByDateRange(a: Allocator, sink: *Sink, _: []const u8, _: []const u8, cb: Cb([]const Order)) !void {
        const all = try getAllOrders(a, sink, recorder([]const Order));
        var list: std.ArrayList(Order) = .empty;
        for (all) |o| if (@mod(o.id, 7) == 0) try list.append(a, o);
        cb(sink, try list.toOwnedSlice(a));
    }
    fn calculateOrderTotal(sink: *Sink, products: []const Product, cb: Cb(f64)) void {
        cb(sink, totalOf(products));
    }
    fn applyDiscount(sink: *Sink, order: Order, discountPercent: f64, cb: Cb(Order)) void {
        cb(sink, order.copyTotal(order.total * (1 - discountPercent / 100)));
    }
    fn getOrderCount(sink: *Sink, cb: Cb(i64)) void {
        cb(sink, 200);
    }
    fn getOrdersByPriceRange(a: Allocator, sink: *Sink, minPrice: f64, maxPrice: f64, cb: Cb([]const Order)) !void {
        const all = try getAllOrders(a, sink, recorder([]const Order));
        var list: std.ArrayList(Order) = .empty;
        for (all) |o| if (o.total >= minPrice and o.total <= maxPrice) try list.append(a, o);
        cb(sink, try list.toOwnedSlice(a));
    }
};

const ReviewService = struct {
    fn createReview(sink: *Sink, userId: i64, productId: i64, rating: i64, comment: []const u8, cb: Cb(Review)) Review {
        const r = Review{ .id = randomId(sink), .userId = userId, .productId = productId, .rating = rating, .comment = comment };
        cb(sink, r);
        return r;
    }
    fn updateReview(a: Allocator, sink: *Sink, review: Review, cb: Cb(Review)) !Review {
        const r = review.copyComment(try std.fmt.allocPrint(a, "{s} [Updated]", .{review.comment}));
        cb(sink, r);
        return r;
    }
    fn deleteReview(sink: *Sink, _: i64, cb: Cb(bool)) void {
        cb(sink, true);
    }
    fn getReviewById(sink: *Sink, reviewId: i64, cb: Cb(?Review)) ?Review {
        const r = Review{ .id = reviewId, .userId = 1, .productId = 1, .rating = 5, .comment = "Great product!" };
        cb(sink, r);
        return r;
    }
    fn getReviewsByProduct(a: Allocator, sink: *Sink, productId: i64, cb: Cb([]const Review)) ![]const Review {
        var list: std.ArrayList(Review) = .empty;
        var i: i64 = 1;
        while (i <= 30) : (i += 1) try list.append(a, .{ .id = i, .userId = @mod(i, 20), .productId = productId, .rating = sink.rand(1, 5), .comment = try std.fmt.allocPrint(a, "Review {d}", .{i}) });
        const reviews = try list.toOwnedSlice(a);
        cb(sink, reviews);
        return reviews;
    }
    fn getReviewsByUser(a: Allocator, sink: *Sink, userId: i64, cb: Cb([]const Review)) !void {
        var list: std.ArrayList(Review) = .empty;
        var i: i64 = 1;
        while (i <= 15) : (i += 1) try list.append(a, .{ .id = i, .userId = userId, .productId = @mod(i, 50), .rating = sink.rand(1, 5), .comment = try std.fmt.allocPrint(a, "User review {d}", .{i}) });
        cb(sink, try list.toOwnedSlice(a));
    }
    fn getReviewsByRating(a: Allocator, sink: *Sink, rating: i64, cb: Cb([]const Review)) !void {
        var list: std.ArrayList(Review) = .empty;
        var i: i64 = 1;
        while (i <= 100) : (i += 1) if (@mod(i, 5) == rating - 1)
            try list.append(a, .{ .id = i, .userId = @mod(i, 20), .productId = @mod(i, 50), .rating = rating, .comment = "Rating review" });
        cb(sink, try list.toOwnedSlice(a));
    }
    fn getAverageRating(sink: *Sink, _: i64, cb: Cb(f64)) void {
        cb(sink, @as(f64, @floatFromInt(sink.rand(30, 50))) / 10.0);
    }
    fn getReviewCount(sink: *Sink, _: i64, cb: Cb(i64)) void {
        cb(sink, sink.rand(10, 100));
    }
    fn searchReviews(a: Allocator, sink: *Sink, query: []const u8, cb: Cb([]const Review)) !void {
        var list: std.ArrayList(Review) = .empty;
        var i: i64 = 1;
        while (i <= 50) : (i += 1) try list.append(a, .{ .id = i, .userId = @mod(i, 20), .productId = @mod(i, 50), .rating = sink.rand(1, 5), .comment = try std.fmt.allocPrint(a, "Review containing {s}", .{query}) });
        cb(sink, try list.toOwnedSlice(a));
    }
    fn getTopReviews(a: Allocator, sink: *Sink, productId: i64, count: usize, cb: Cb([]const Review)) !void {
        const reviews = try getReviewsByProduct(a, sink, productId, recorder([]const Review));
        const sorted = try a.dupe(Review, reviews);
        std.mem.sort(Review, sorted, {}, struct {
            fn lt(_: void, x: Review, y: Review) bool {
                return x.rating > y.rating;
            }
        }.lt);
        cb(sink, sorted[0..@min(count, sorted.len)]);
    }
    fn flagReview(sink: *Sink, _: i64, _: []const u8, cb: Cb(bool)) void {
        cb(sink, true);
    }
};

const CategoryService = struct {
    fn createCategory(sink: *Sink, name: []const u8, description: []const u8, cb: Cb(Category)) Category {
        const c = Category{ .id = randomId(sink), .name = name, .description = description };
        cb(sink, c);
        return c;
    }
    fn updateCategory(a: Allocator, sink: *Sink, category: Category, cb: Cb(Category)) !Category {
        const c = category.copyDescription(try std.fmt.allocPrint(a, "{s} [Updated]", .{category.description}));
        cb(sink, c);
        return c;
    }
    fn deleteCategory(sink: *Sink, _: i64, cb: Cb(bool)) void {
        cb(sink, true);
    }
    fn getCategoryById(a: Allocator, sink: *Sink, categoryId: i64, cb: Cb(?Category)) !?Category {
        const c = Category{ .id = categoryId, .name = try std.fmt.allocPrint(a, "Category{d}", .{categoryId}), .description = try std.fmt.allocPrint(a, "Description for category {d}", .{categoryId}) };
        cb(sink, c);
        return c;
    }
    fn getAllCategories(a: Allocator, sink: *Sink, cb: Cb([]const Category)) ![]const Category {
        var list: std.ArrayList(Category) = .empty;
        var i: i64 = 1;
        while (i <= 50) : (i += 1) try list.append(a, .{ .id = i, .name = try std.fmt.allocPrint(a, "Category{d}", .{i}), .description = try std.fmt.allocPrint(a, "Description for category {d}", .{i}) });
        const cats = try list.toOwnedSlice(a);
        cb(sink, cats);
        return cats;
    }
    fn searchCategories(a: Allocator, sink: *Sink, _: []const u8, cb: Cb([]const Category)) !void {
        cb(sink, try getAllCategories(a, sink, recorder([]const Category)));
    }
    fn getCategoryCount(sink: *Sink, cb: Cb(i64)) void {
        cb(sink, 50);
    }
    fn getPopularCategories(a: Allocator, sink: *Sink, count: usize, cb: Cb([]const Category)) !void {
        const all = try getAllCategories(a, sink, recorder([]const Category));
        const sh = try shuffled(Category, a, sink, all);
        cb(sink, sh[0..@min(count, sh.len)]);
    }
    fn getCategoryTree(a: Allocator, sink: *Sink, cb: Cb([]const TreeNode)) !void {
        const all = try getAllCategories(a, sink, recorder([]const Category));
        var nodes: std.ArrayList(TreeNode) = .empty;
        for (all) |parent| {
            var children: std.ArrayList(Category) = .empty;
            for (all) |c| {
                if (c.id != parent.id) try children.append(a, c);
                if (children.items.len >= 3) break;
            }
            try nodes.append(a, .{ .parent = parent, .children = try children.toOwnedSlice(a) });
        }
        cb(sink, try nodes.toOwnedSlice(a));
    }
    fn validateCategory(sink: *Sink, category: Category, cb: Cb(bool)) void {
        cb(sink, category.name.len > 0 and category.description.len > 0);
    }
};

const InventoryService = struct {
    fn addInventory(sink: *Sink, productId: i64, quantity: i64, location: []const u8, cb: Cb(Inventory)) Inventory {
        const inv = Inventory{ .productId = productId, .quantity = quantity, .location = location };
        cb(sink, inv);
        return inv;
    }
    fn updateInventory(sink: *Sink, inventory: Inventory, cb: Cb(Inventory)) Inventory {
        const inv = inventory.copyQuantity(inventory.quantity - 1);
        cb(sink, inv);
        return inv;
    }
    fn removeInventory(sink: *Sink, _: i64, _: []const u8, cb: Cb(bool)) void {
        cb(sink, true);
    }
    fn getInventory(a: Allocator, sink: *Sink, productId: i64, cb: Cb([]const Inventory)) ![]const Inventory {
        var list: std.ArrayList(Inventory) = .empty;
        var i: i64 = 1;
        while (i <= 5) : (i += 1) try list.append(a, .{ .productId = productId, .quantity = sink.rand(10, 100), .location = try std.fmt.allocPrint(a, "Location{d}", .{i}) });
        const inv = try list.toOwnedSlice(a);
        cb(sink, inv);
        return inv;
    }
    fn getAllInventory(a: Allocator, sink: *Sink, cb: Cb([]const Inventory)) ![]const Inventory {
        var list: std.ArrayList(Inventory) = .empty;
        var i: i64 = 1;
        while (i <= 200) : (i += 1) try list.append(a, .{ .productId = @mod(i, 50), .quantity = sink.rand(5, 150), .location = try std.fmt.allocPrint(a, "Location{d}", .{@mod(i, 10)}) });
        const inv = try list.toOwnedSlice(a);
        cb(sink, inv);
        return inv;
    }
    fn getInventoryByLocation(a: Allocator, sink: *Sink, location: []const u8, cb: Cb([]const Inventory)) !void {
        const all = try getAllInventory(a, sink, recorder([]const Inventory));
        var list: std.ArrayList(Inventory) = .empty;
        for (all) |inv| if (std.mem.eql(u8, inv.location, location)) try list.append(a, inv);
        cb(sink, try list.toOwnedSlice(a));
    }
    fn getLowStockItems(a: Allocator, sink: *Sink, threshold: i64, cb: Cb([]const Inventory)) !void {
        const all = try getAllInventory(a, sink, recorder([]const Inventory));
        var list: std.ArrayList(Inventory) = .empty;
        for (all) |inv| if (inv.quantity < threshold) try list.append(a, inv);
        cb(sink, try list.toOwnedSlice(a));
    }
    fn getTotalQuantity(a: Allocator, sink: *Sink, productId: i64, cb: Cb(i64)) !i64 {
        const inv = try getInventory(a, sink, productId, recorder([]const Inventory));
        var total: i64 = 0;
        for (inv) |x| total += x.quantity;
        cb(sink, total);
        return total;
    }
    fn reserveInventory(a: Allocator, sink: *Sink, productId: i64, quantity: i64, cb: Cb(bool)) !void {
        const total = try getTotalQuantity(a, sink, productId, recorder(i64));
        cb(sink, total >= quantity);
    }
    fn releaseInventory(sink: *Sink, _: i64, _: i64, cb: Cb(bool)) void {
        cb(sink, true);
    }
    fn getInventoryValue(a: Allocator, sink: *Sink, cb: Cb(f64)) !void {
        const all = try getAllInventory(a, sink, recorder([]const Inventory));
        var value: f64 = 0;
        for (all) |inv| value += @as(f64, @floatFromInt(inv.quantity)) * 50.0;
        cb(sink, value);
    }
    fn transferInventory(sink: *Sink, _: i64, _: []const u8, _: []const u8, _: i64, cb: Cb(bool)) void {
        cb(sink, true);
    }
};

const PaymentService = struct {
    fn processPayment(sink: *Sink, orderId: i64, amount: f64, method: []const u8, cb: Cb(Payment)) Payment {
        const p = Payment{ .id = randomId(sink), .orderId = orderId, .amount = amount, .method = method };
        cb(sink, p);
        return p;
    }
    fn refundPayment(sink: *Sink, _: i64, cb: Cb(bool)) void {
        cb(sink, true);
    }
    fn getPaymentById(sink: *Sink, paymentId: i64, cb: Cb(?Payment)) ?Payment {
        const p = Payment{ .id = paymentId, .orderId = 1, .amount = 99.99, .method = "credit_card" };
        cb(sink, p);
        return p;
    }
    fn getPaymentsByOrder(a: Allocator, sink: *Sink, orderId: i64, cb: Cb([]const Payment)) !void {
        var list: std.ArrayList(Payment) = .empty;
        var i: i64 = 1;
        while (i <= 3) : (i += 1) try list.append(a, .{ .id = i, .orderId = orderId, .amount = @floatFromInt(sink.rand(50, 200)), .method = "credit_card" });
        cb(sink, try list.toOwnedSlice(a));
    }
    fn getAllPayments(a: Allocator, sink: *Sink, cb: Cb([]const Payment)) ![]const Payment {
        var list: std.ArrayList(Payment) = .empty;
        var i: i64 = 1;
        while (i <= 300) : (i += 1) try list.append(a, .{ .id = i, .orderId = @mod(i, 100), .amount = @floatFromInt(sink.rand(25, 500)), .method = "credit_card" });
        const p = try list.toOwnedSlice(a);
        cb(sink, p);
        return p;
    }
    fn getPaymentsByMethod(a: Allocator, sink: *Sink, method: []const u8, cb: Cb([]const Payment)) !void {
        const all = try getAllPayments(a, sink, recorder([]const Payment));
        var list: std.ArrayList(Payment) = .empty;
        for (all) |p| if (std.mem.eql(u8, p.method, method)) try list.append(a, p);
        cb(sink, try list.toOwnedSlice(a));
    }
    fn getPaymentsByDateRange(a: Allocator, sink: *Sink, _: []const u8, _: []const u8, cb: Cb([]const Payment)) !void {
        const all = try getAllPayments(a, sink, recorder([]const Payment));
        var list: std.ArrayList(Payment) = .empty;
        for (all) |p| if (@mod(p.id, 7) == 0) try list.append(a, p);
        cb(sink, try list.toOwnedSlice(a));
    }
    fn getTotalRevenue(a: Allocator, sink: *Sink, cb: Cb(f64)) !void {
        const all = try getAllPayments(a, sink, recorder([]const Payment));
        var total: f64 = 0;
        for (all) |p| total += p.amount;
        cb(sink, total);
    }
    fn validatePayment(sink: *Sink, payment: Payment, cb: Cb(bool)) void {
        cb(sink, payment.amount > 0 and payment.method.len > 0);
    }
    fn getPaymentMethods(a: Allocator, sink: *Sink, cb: Cb([]const []const u8)) !void {
        const methods = try a.dupe([]const u8, &[_][]const u8{ "credit_card", "debit_card", "paypal", "apple_pay", "google_pay" });
        cb(sink, methods);
    }
    fn calculateFees(sink: *Sink, amount: f64, method: []const u8, cb: Cb(f64)) void {
        const fee = if (std.mem.eql(u8, method, "credit_card")) amount * 0.029 else if (std.mem.eql(u8, method, "debit_card")) amount * 0.015 else if (std.mem.eql(u8, method, "paypal")) amount * 0.035 else amount * 0.025;
        cb(sink, fee);
    }
    fn isPaymentAuthorized(sink: *Sink, paymentId: i64, cb: Cb(bool)) void {
        cb(sink, @mod(paymentId, 10) != 0);
    }
};

const ShippingService = struct {
    fn createShipment(sink: *Sink, orderId: i64, address: []const u8, cb: Cb(Shipping)) Shipping {
        const s = Shipping{ .id = randomId(sink), .orderId = orderId, .address = address, .status = "pending" };
        cb(sink, s);
        return s;
    }
    fn updateShippingStatus(sink: *Sink, shippingId: i64, status: []const u8, cb: Cb(?Shipping)) ?Shipping {
        const s = Shipping{ .id = shippingId, .orderId = 1, .address = "123 Main St", .status = status };
        cb(sink, s);
        return s;
    }
    fn getShippingById(sink: *Sink, shippingId: i64, cb: Cb(?Shipping)) ?Shipping {
        const s = Shipping{ .id = shippingId, .orderId = 1, .address = "123 Main St", .status = "shipped" };
        cb(sink, s);
        return s;
    }
    fn getShippingByOrder(sink: *Sink, orderId: i64, cb: Cb(?Shipping)) ?Shipping {
        const s = Shipping{ .id = 1, .orderId = orderId, .address = "456 Oak Ave", .status = "delivered" };
        cb(sink, s);
        return s;
    }
    fn getAllShipments(a: Allocator, sink: *Sink, cb: Cb([]const Shipping)) ![]const Shipping {
        var list: std.ArrayList(Shipping) = .empty;
        var i: i64 = 1;
        while (i <= 250) : (i += 1) try list.append(a, .{ .id = i, .orderId = @mod(i, 150), .address = try std.fmt.allocPrint(a, "Address {d}", .{i}), .status = "shipped" });
        const s = try list.toOwnedSlice(a);
        cb(sink, s);
        return s;
    }
    fn getShipmentsByStatus(a: Allocator, sink: *Sink, status: []const u8, cb: Cb([]const Shipping)) !void {
        const all = try getAllShipments(a, sink, recorder([]const Shipping));
        var list: std.ArrayList(Shipping) = .empty;
        for (all) |s| if (std.mem.eql(u8, s.status, status)) try list.append(a, s);
        cb(sink, try list.toOwnedSlice(a));
    }
    fn trackShipment(a: Allocator, sink: *Sink, shippingId: i64, cb: Cb([]const u8)) !void {
        cb(sink, try std.fmt.allocPrint(a, "Tracking: SHIP{d}{d}", .{ shippingId, sink.rand(1000, 9999) }));
    }
    fn estimateDelivery(a: Allocator, sink: *Sink, _: []const u8, cb: Cb([]const u8)) !void {
        cb(sink, try std.fmt.allocPrint(a, "Estimated delivery in {d} days", .{sink.rand(1, 7)}));
    }
    fn calculateShippingCost(sink: *Sink, _: []const u8, weight: f64, cb: Cb(f64)) void {
        cb(sink, 5.99 + weight * 0.5);
    }
    fn getAvailableCarriers(a: Allocator, sink: *Sink, cb: Cb([]const []const u8)) !void {
        cb(sink, try a.dupe([]const u8, &[_][]const u8{ "UPS", "FedEx", "USPS", "DHL", "Amazon" }));
    }
    fn schedulePickup(sink: *Sink, _: i64, _: []const u8, cb: Cb(bool)) void {
        cb(sink, true);
    }
    fn cancelShipment(sink: *Sink, _: i64, cb: Cb(bool)) void {
        cb(sink, true);
    }
};

const NotificationService = struct {
    fn sendNotification(sink: *Sink, userId: i64, message: []const u8, type_: []const u8, cb: Cb(Notification)) Notification {
        const n = Notification{ .id = randomId(sink), .userId = userId, .message = message, .type_ = type_ };
        cb(sink, n);
        return n;
    }
    fn getNotificationById(sink: *Sink, notificationId: i64, cb: Cb(?Notification)) ?Notification {
        const n = Notification{ .id = notificationId, .userId = 1, .message = "Sample notification", .type_ = "info" };
        cb(sink, n);
        return n;
    }
    fn getNotificationsByUser(a: Allocator, sink: *Sink, userId: i64, cb: Cb([]const Notification)) !void {
        var list: std.ArrayList(Notification) = .empty;
        var i: i64 = 1;
        while (i <= 20) : (i += 1) try list.append(a, .{ .id = i, .userId = userId, .message = try std.fmt.allocPrint(a, "Notification {d}", .{i}), .type_ = "info" });
        cb(sink, try list.toOwnedSlice(a));
    }
    fn getNotificationsByType(a: Allocator, sink: *Sink, type_: []const u8, cb: Cb([]const Notification)) !void {
        var list: std.ArrayList(Notification) = .empty;
        var i: i64 = 1;
        while (i <= 50) : (i += 1) try list.append(a, .{ .id = i, .userId = @mod(i, 25), .message = try std.fmt.allocPrint(a, "Message {d}", .{i}), .type_ = type_ });
        cb(sink, try list.toOwnedSlice(a));
    }
    fn markAsRead(sink: *Sink, _: i64, cb: Cb(bool)) void {
        cb(sink, true);
    }
    fn markAllAsRead(sink: *Sink, _: i64, cb: Cb(bool)) void {
        cb(sink, true);
    }
    fn deleteNotification(sink: *Sink, _: i64, cb: Cb(bool)) void {
        cb(sink, true);
    }
    fn getUnreadCount(sink: *Sink, _: i64, cb: Cb(i64)) void {
        cb(sink, sink.rand(0, 15));
    }
    fn sendBulkNotification(a: Allocator, sink: *Sink, userIds: []const i64, message: []const u8, type_: []const u8, cb: Cb([]const Notification)) !void {
        var list: std.ArrayList(Notification) = .empty;
        for (userIds) |uid| try list.append(a, .{ .id = randomId(sink), .userId = uid, .message = message, .type_ = type_ });
        cb(sink, try list.toOwnedSlice(a));
    }
    fn scheduleNotification(sink: *Sink, userId: i64, message: []const u8, type_: []const u8, _: []const u8, cb: Cb(Notification)) Notification {
        const n = Notification{ .id = randomId(sink), .userId = userId, .message = message, .type_ = type_ };
        cb(sink, n);
        return n;
    }
    fn getNotificationTypes(a: Allocator, sink: *Sink, cb: Cb([]const []const u8)) !void {
        cb(sink, try a.dupe([]const u8, &[_][]const u8{ "info", "warning", "error", "success", "promotion" }));
    }
    fn updateNotificationPreferences(sink: *Sink, _: i64, _: []const Kv, cb: Cb(bool)) void {
        cb(sink, true);
    }
};

const AnalyticsService = struct {
    fn trackEvent(sink: *Sink, event: []const u8, data: []const Kv, cb: Cb(Analytics)) Analytics {
        const an = Analytics{ .id = randomId(sink), .event = event, .data = data };
        cb(sink, an);
        return an;
    }
    fn getEventById(a: Allocator, sink: *Sink, eventId: i64, cb: Cb(?Analytics)) !?Analytics {
        const data = try a.dupe(Kv, &[_]Kv{.{ .key = "page", .value = .{ .str = "/home" } }});
        const an = Analytics{ .id = eventId, .event = "page_view", .data = data };
        cb(sink, an);
        return an;
    }
    fn getEventsByType(a: Allocator, sink: *Sink, event: []const u8, cb: Cb([]const Analytics)) !void {
        var list: std.ArrayList(Analytics) = .empty;
        var i: i64 = 1;
        while (i <= 100) : (i += 1) {
            const data = try a.dupe(Kv, &[_]Kv{.{ .key = "timestamp", .value = .{ .str = "125" } }});
            try list.append(a, .{ .id = i, .event = event, .data = data });
        }
        cb(sink, try list.toOwnedSlice(a));
    }
    fn getEventsByDateRange(a: Allocator, sink: *Sink, startDate: []const u8, _: []const u8, cb: Cb([]const Analytics)) !void {
        var list: std.ArrayList(Analytics) = .empty;
        var i: i64 = 1;
        while (i <= 500) : (i += 1) {
            const data = try a.dupe(Kv, &[_]Kv{.{ .key = "date", .value = .{ .str = startDate } }});
            try list.append(a, .{ .id = i, .event = try std.fmt.allocPrint(a, "event_{d}", .{i}), .data = data });
        }
        cb(sink, try list.toOwnedSlice(a));
    }
    fn getUserEvents(a: Allocator, sink: *Sink, userId: i64, cb: Cb([]const Analytics)) !void {
        var list: std.ArrayList(Analytics) = .empty;
        var i: i64 = 1;
        while (i <= 30) : (i += 1) {
            const data = try a.dupe(Kv, &[_]Kv{ .{ .key = "userId", .value = .{ .num = @floatFromInt(userId) } }, .{ .key = "action", .value = .{ .str = "click" } } });
            try list.append(a, .{ .id = i, .event = "user_action", .data = data });
        }
        cb(sink, try list.toOwnedSlice(a));
    }
    fn getPopularEvents(a: Allocator, sink: *Sink, count: usize, cb: Cb([]const []const u8)) !void {
        const all = try a.dupe([]const u8, &[_][]const u8{ "page_view", "click", "purchase", "signup", "logout" });
        cb(sink, all[0..@min(count, all.len)]);
    }
    fn getEventCount(sink: *Sink, _: []const u8, cb: Cb(i64)) void {
        cb(sink, sink.rand(100, 1000));
    }
    fn getUniqueUsers(sink: *Sink, _: []const u8, cb: Cb(i64)) void {
        cb(sink, sink.rand(50, 500));
    }
    fn generateReport(a: Allocator, sink: *Sink, _: []const u8, _: []const u8, cb: Cb([]const Kv)) !void {
        const report = try a.dupe(Kv, &[_]Kv{
            .{ .key = "totalEvents", .value = .{ .num = 10000 } },
            .{ .key = "uniqueUsers", .value = .{ .num = 1500 } },
            .{ .key = "averageSessionTime", .value = .{ .num = 300 } },
            .{ .key = "bounceRate", .value = .{ .num = 0.35 } },
        });
        cb(sink, report);
    }
    fn getTopPages(a: Allocator, sink: *Sink, count: usize, cb: Cb([]const []const u8)) !void {
        var list: std.ArrayList([]const u8) = .empty;
        var i: usize = 1;
        while (i <= count) : (i += 1) try list.append(a, try std.fmt.allocPrint(a, "/page{d}", .{i}));
        cb(sink, try list.toOwnedSlice(a));
    }
    fn getConversionRate(sink: *Sink, _: []const u8, _: []const u8, cb: Cb(f64)) void {
        cb(sink, @as(f64, @floatFromInt(sink.rand(5, 25))) / 100.0);
    }
    fn exportAnalytics(a: Allocator, sink: *Sink, format: []const u8, cb: Cb([]const u8)) !void {
        cb(sink, try std.fmt.allocPrint(a, "analytics_export.{s}", .{format}));
    }
};

// ---- Workflows: straight-line data flow passing recorder() callbacks ------

fn processUserWorkflow(a: Allocator, sink: *Sink, index: i64) !void {
    const name = try std.fmt.allocPrint(a, "User{d}", .{index});
    const email = try std.fmt.allocPrint(a, "user{d}@email.com", .{index});
    const user = try UserService.createUser(a, sink, name, email, 25 + @mod(index, 50), recorder(UserProfile));
    _ = try UserService.updateUser(a, sink, user, recorder(UserProfile));
    _ = try UserService.getUserById(a, sink, user.id, recorder(?UserProfile));
    _ = try UserService.getAllUsers(a, sink, recorder([]const UserProfile));
    try UserService.searchUsers(a, sink, "User", recorder([]const UserProfile));
    UserService.validateUser(sink, user, recorder(bool));
    try UserService.getUsersByAge(a, sink, 20, 40, recorder([]const UserProfile));
    UserService.getUserCount(sink, recorder(i64));
    UserService.isEmailTaken(sink, user.email, recorder(bool));
    UserService.deleteUser(sink, user.id, recorder(bool));
}

fn processProductWorkflow(a: Allocator, sink: *Sink, index: i64) !void {
    const name = try std.fmt.allocPrint(a, "Product{d}", .{index});
    const category = try std.fmt.allocPrint(a, "Category{d}", .{@mod(index, 10)});
    const product = ProductService.createProduct(sink, name, 99.99 + @as(f64, @floatFromInt(index)), category, recorder(Product));
    _ = ProductService.updateProduct(sink, product, recorder(Product));
    _ = try ProductService.getProductById(a, sink, product.id, recorder(?Product));
    _ = try ProductService.getAllProducts(a, sink, recorder([]const Product));
    try ProductService.searchProducts(a, sink, "Product", recorder([]const Product));
    try ProductService.getProductsByCategory(a, sink, product.category, recorder([]const Product));
    try ProductService.getProductsByPriceRange(a, sink, 50.0, 200.0, recorder([]const Product));
    try ProductService.getFeaturedProducts(a, sink, 10, recorder([]const Product));
    ProductService.getProductCount(sink, recorder(i64));
    ProductService.calculateDiscount(sink, product, 10.0, recorder(f64));
    ProductService.isProductAvailable(sink, product.id, recorder(bool));
    ProductService.deleteProduct(sink, product.id, recorder(bool));
}

fn processOrderWorkflow(a: Allocator, sink: *Sink, index: i64) !void {
    const products = try a.dupe(Product, &[_]Product{.{ .id = index, .name = try std.fmt.allocPrint(a, "Product{d}", .{index}), .price = 75.0, .category = "Category" }});
    const order = OrderService.createOrder(sink, index, products, recorder(Order));
    _ = OrderService.updateOrder(sink, order, recorder(Order));
    _ = try OrderService.getOrderById(a, sink, order.id, recorder(?Order));
    try OrderService.getOrdersByUser(a, sink, index, recorder([]const Order));
    _ = try OrderService.getAllOrders(a, sink, recorder([]const Order));
    try OrderService.getOrdersByStatus(a, sink, "pending", recorder([]const Order));
    try OrderService.getOrdersByDateRange(a, sink, "2024-01-01", "2024-12-31", recorder([]const Order));
    OrderService.calculateOrderTotal(sink, products, recorder(f64));
    OrderService.applyDiscount(sink, order, 5.0, recorder(Order));
    OrderService.getOrderCount(sink, recorder(i64));
    try OrderService.getOrdersByPriceRange(a, sink, 50.0, 150.0, recorder([]const Order));
    OrderService.cancelOrder(sink, order.id, recorder(bool));
}

fn processReviewWorkflow(a: Allocator, sink: *Sink, index: i64) !void {
    const comment = try std.fmt.allocPrint(a, "Great product {d}", .{index});
    const review = ReviewService.createReview(sink, index, @mod(index, 50), 5, comment, recorder(Review));
    _ = try ReviewService.updateReview(a, sink, review, recorder(Review));
    _ = ReviewService.getReviewById(sink, review.id, recorder(?Review));
    _ = try ReviewService.getReviewsByProduct(a, sink, @mod(index, 50), recorder([]const Review));
    try ReviewService.getReviewsByUser(a, sink, index, recorder([]const Review));
    try ReviewService.getReviewsByRating(a, sink, 5, recorder([]const Review));
    ReviewService.getAverageRating(sink, @mod(index, 50), recorder(f64));
    ReviewService.getReviewCount(sink, @mod(index, 50), recorder(i64));
    try ReviewService.searchReviews(a, sink, "great", recorder([]const Review));
    try ReviewService.getTopReviews(a, sink, @mod(index, 50), 5, recorder([]const Review));
    ReviewService.flagReview(sink, review.id, "spam", recorder(bool));
    ReviewService.deleteReview(sink, review.id, recorder(bool));
}

fn processCategoryWorkflow(a: Allocator, sink: *Sink, index: i64) !void {
    const name = try std.fmt.allocPrint(a, "Category{d}", .{index});
    const desc = try std.fmt.allocPrint(a, "Description {d}", .{index});
    const category = CategoryService.createCategory(sink, name, desc, recorder(Category));
    _ = try CategoryService.updateCategory(a, sink, category, recorder(Category));
    _ = try CategoryService.getCategoryById(a, sink, category.id, recorder(?Category));
    _ = try CategoryService.getAllCategories(a, sink, recorder([]const Category));
    try CategoryService.searchCategories(a, sink, "Category", recorder([]const Category));
    CategoryService.getCategoryCount(sink, recorder(i64));
    try CategoryService.getPopularCategories(a, sink, 5, recorder([]const Category));
    try CategoryService.getCategoryTree(a, sink, recorder([]const TreeNode));
    CategoryService.validateCategory(sink, category, recorder(bool));
    CategoryService.deleteCategory(sink, category.id, recorder(bool));
}

fn processInventoryWorkflow(a: Allocator, sink: *Sink, index: i64) !void {
    const loc = try std.fmt.allocPrint(a, "Location{d}", .{index});
    const inventory = InventoryService.addInventory(sink, index, 100, loc, recorder(Inventory));
    _ = InventoryService.updateInventory(sink, inventory, recorder(Inventory));
    _ = try InventoryService.getInventory(a, sink, index, recorder([]const Inventory));
    _ = try InventoryService.getAllInventory(a, sink, recorder([]const Inventory));
    try InventoryService.getInventoryByLocation(a, sink, loc, recorder([]const Inventory));
    try InventoryService.getLowStockItems(a, sink, 10, recorder([]const Inventory));
    _ = try InventoryService.getTotalQuantity(a, sink, index, recorder(i64));
    try InventoryService.reserveInventory(a, sink, index, 5, recorder(bool));
    InventoryService.releaseInventory(sink, index, 5, recorder(bool));
    try InventoryService.getInventoryValue(a, sink, recorder(f64));
    InventoryService.transferInventory(sink, index, "Location1", "Location2", 10, recorder(bool));
    InventoryService.removeInventory(sink, index, loc, recorder(bool));
}

fn processPaymentWorkflow(a: Allocator, sink: *Sink, index: i64) !void {
    const payment = PaymentService.processPayment(sink, index, 99.99, "credit_card", recorder(Payment));
    _ = PaymentService.getPaymentById(sink, payment.id, recorder(?Payment));
    try PaymentService.getPaymentsByOrder(a, sink, index, recorder([]const Payment));
    _ = try PaymentService.getAllPayments(a, sink, recorder([]const Payment));
    try PaymentService.getPaymentsByMethod(a, sink, "credit_card", recorder([]const Payment));
    try PaymentService.getPaymentsByDateRange(a, sink, "2024-01-01", "2024-12-31", recorder([]const Payment));
    try PaymentService.getTotalRevenue(a, sink, recorder(f64));
    PaymentService.validatePayment(sink, payment, recorder(bool));
    try PaymentService.getPaymentMethods(a, sink, recorder([]const []const u8));
    PaymentService.calculateFees(sink, 99.99, "credit_card", recorder(f64));
    PaymentService.isPaymentAuthorized(sink, payment.id, recorder(bool));
    PaymentService.refundPayment(sink, payment.id, recorder(bool));
}

fn processShippingWorkflow(a: Allocator, sink: *Sink, index: i64) !void {
    const address = try std.fmt.allocPrint(a, "Address {d}", .{index});
    const shipping = ShippingService.createShipment(sink, index, address, recorder(Shipping));
    _ = ShippingService.updateShippingStatus(sink, shipping.id, "shipped", recorder(?Shipping));
    _ = ShippingService.getShippingById(sink, shipping.id, recorder(?Shipping));
    _ = ShippingService.getShippingByOrder(sink, index, recorder(?Shipping));
    _ = try ShippingService.getAllShipments(a, sink, recorder([]const Shipping));
    try ShippingService.getShipmentsByStatus(a, sink, "shipped", recorder([]const Shipping));
    try ShippingService.trackShipment(a, sink, shipping.id, recorder([]const u8));
    try ShippingService.estimateDelivery(a, sink, address, recorder([]const u8));
    ShippingService.calculateShippingCost(sink, address, 5.0, recorder(f64));
    try ShippingService.getAvailableCarriers(a, sink, recorder([]const []const u8));
    ShippingService.schedulePickup(sink, shipping.id, "2024-12-25", recorder(bool));
    ShippingService.cancelShipment(sink, shipping.id, recorder(bool));
}

fn processNotificationWorkflow(a: Allocator, sink: *Sink, index: i64) !void {
    const message = try std.fmt.allocPrint(a, "Message {d}", .{index});
    const notification = NotificationService.sendNotification(sink, index, message, "info", recorder(Notification));
    _ = NotificationService.getNotificationById(sink, notification.id, recorder(?Notification));
    try NotificationService.getNotificationsByUser(a, sink, index, recorder([]const Notification));
    try NotificationService.getNotificationsByType(a, sink, "info", recorder([]const Notification));
    NotificationService.markAsRead(sink, notification.id, recorder(bool));
    NotificationService.markAllAsRead(sink, index, recorder(bool));
    NotificationService.getUnreadCount(sink, index, recorder(i64));
    const ids = try a.dupe(i64, &[_]i64{index});
    try NotificationService.sendBulkNotification(a, sink, ids, "Bulk message", "info", recorder([]const Notification));
    _ = NotificationService.scheduleNotification(sink, index, "Scheduled", "info", "2024-12-25", recorder(Notification));
    try NotificationService.getNotificationTypes(a, sink, recorder([]const []const u8));
    const prefs = try a.dupe(Kv, &[_]Kv{.{ .key = "email", .value = .{ .num = 1 } }});
    NotificationService.updateNotificationPreferences(sink, index, prefs, recorder(bool));
    NotificationService.deleteNotification(sink, notification.id, recorder(bool));
}

fn processAnalyticsWorkflow(a: Allocator, sink: *Sink, index: i64) !void {
    const event = try std.fmt.allocPrint(a, "event_{d}", .{index});
    const eventData = try a.dupe(Kv, &[_]Kv{.{ .key = "data", .value = .{ .num = @floatFromInt(index) } }});
    const analytics = AnalyticsService.trackEvent(sink, event, eventData, recorder(Analytics));
    _ = try AnalyticsService.getEventById(a, sink, analytics.id, recorder(?Analytics));
    try AnalyticsService.getEventsByType(a, sink, event, recorder([]const Analytics));
    try AnalyticsService.getEventsByDateRange(a, sink, "2024-01-01", "2024-12-31", recorder([]const Analytics));
    try AnalyticsService.getUserEvents(a, sink, index, recorder([]const Analytics));
    try AnalyticsService.getPopularEvents(a, sink, 5, recorder([]const []const u8));
    AnalyticsService.getEventCount(sink, event, recorder(i64));
    AnalyticsService.getUniqueUsers(sink, event, recorder(i64));
    try AnalyticsService.generateReport(a, sink, "2024-01-01", "2024-12-31", recorder([]const Kv));
    try AnalyticsService.getTopPages(a, sink, 10, recorder([]const []const u8));
    AnalyticsService.getConversionRate(sink, "view", "purchase", recorder(f64));
    try AnalyticsService.exportAnalytics(a, sink, "csv", recorder([]const u8));
}

fn runCallbacks(a: Allocator) !void {
    var sink = Sink{};
    var index: i64 = 0;
    while (index < 100) : (index += 1) {
        try processUserWorkflow(a, &sink, index);
        try processProductWorkflow(a, &sink, index);
        try processOrderWorkflow(a, &sink, index);
        try processReviewWorkflow(a, &sink, index);
        try processCategoryWorkflow(a, &sink, index);
        try processInventoryWorkflow(a, &sink, index);
        try processPaymentWorkflow(a, &sink, index);
        try processShippingWorkflow(a, &sink, index);
        try processNotificationWorkflow(a, &sink, index);
        try processAnalyticsWorkflow(a, &sink, index);
    }
    std.mem.doNotOptimizeAway(sink.acc);
}

pub fn runBenchmark() void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    runCallbacks(arena.allocator()) catch {};
}

export fn bench_run() void {
    runBenchmark();
}







