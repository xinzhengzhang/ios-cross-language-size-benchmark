// iOS Size Benchmark - Test Case Implementation
// Generated with Claude AI (https://claude.ai)
//
// Zig port of the "json-serialization" case. This is the genuine JSON path:
// serialization uses `std.json.Stringify` (pretty-printed, indent_2 — the
// analogue of kotlinx `Json { prettyPrint = true }` / Swift `.prettyPrinted`)
// and the round-trip deserialize uses `std.json.parseFromSlice(T, a, s, .{})`
// straight back into the typed structs. No manual string building: the stdlib
// JSON library drives both directions, mirroring kotlinx-serialization's
// generated serializers over @Serializable data classes and Swift's Codable.
//
// Idiomatic difference (documented): Kotlin/TS model `specifications` and
// `metadata` as Map<String,String>. Zig's idiom for a fixed, known key set is
// a struct, not a hash map — and std.json serializes/parses structs natively,
// so Specifications/Metadata are structs here. The round-trip is identical
// (serialize -> string -> parse -> read fields back), the keys are the same;
// only the in-memory shape is a struct instead of a map.
//
// A per-run arena owns every allocation (generated customers, the pretty JSON
// strings, and each parse's result tree) and frees them all at once — ideal
// for a throwaway serialization workload. A single exported entry
// (bench_run -> runBenchmark) exercises the whole graph so nothing is DCE'd.

const std = @import("std");

const Address = struct {
    street: []const u8,
    city: []const u8,
    state: []const u8,
    zipCode: []const u8,
    country: []const u8,
    latitude: f64,
    longitude: f64,
};

const ContactInfo = struct {
    email: []const u8,
    phone: []const u8,
    website: []const u8,
    socialMedia: []const []const u8,
};

const Review = struct {
    reviewId: i64,
    rating: i64,
    comment: []const u8,
    reviewer: []const u8,
};

// Fixed-key Map<String,String> -> struct (see header).
const Specifications = struct {
    weight: []const u8,
    dimensions: []const u8,
    material: []const u8,
};

const Product = struct {
    productId: i64,
    name: []const u8,
    category: []const u8,
    price: f64,
    inventory: i64,
    tags: []const []const u8,
    specifications: Specifications,
    reviews: []const Review,
};

// Fixed-key Map<String,String> -> struct (see header).
const Metadata = struct {
    source: []const u8,
    campaign: []const u8,
    discount: []const u8,
};

const Order = struct {
    orderId: i64,
    customerId: i64,
    orderDate: i64,
    products: []const Product,
    totalAmount: f64,
    status: []const u8,
    shippingAddress: Address,
    billingAddress: Address,
    metadata: Metadata,
};

const NotificationPreferences = struct {
    email: bool,
    sms: bool,
    push: bool,
};

const Preferences = struct {
    notifications: NotificationPreferences,
    language: []const u8,
    currency: []const u8,
    timezone: []const u8,
};

const Customer = struct {
    customerId: i64,
    firstName: []const u8,
    lastName: []const u8,
    birthDate: i64,
    contactInfo: ContactInfo,
    addresses: []const Address,
    orderHistory: []const Order,
    preferences: Preferences,
    isActive: bool,
    loyaltyPrograms: []const []const u8,
};

const JSONSerializationService = struct {
    fn generateComplexCustomer(a: std.mem.Allocator, customerId: i64) !Customer {
        const contactInfo = ContactInfo{
            .email = try std.fmt.allocPrint(a, "customer{d}@email.com", .{customerId}),
            .phone = try std.fmt.allocPrint(a, "+1-555-{d:0>4}", .{customerId}),
            .website = try std.fmt.allocPrint(a, "https://customer{d}.com", .{customerId}),
            .socialMedia = &.{ "twitter", "linkedin", "facebook" },
        };

        var addresses: std.ArrayList(Address) = .empty;
        var i: i64 = 0;
        while (i < 3) : (i += 1) {
            try addresses.append(a, .{
                .street = try std.fmt.allocPrint(a, "{d}{d} Main Street", .{ customerId, i }),
                .city = try std.fmt.allocPrint(a, "City{d}", .{customerId + i}),
                .state = try std.fmt.allocPrint(a, "State{d}", .{i}),
                .zipCode = try std.fmt.allocPrint(a, "{d:0>5}", .{customerId * 100 + i}),
                .country = "USA",
                .latitude = 40.0 + @as(f64, @floatFromInt(@mod(customerId, 10))),
                .longitude = -74.0 + @as(f64, @floatFromInt(@mod(customerId, 10))),
            });
        }
        const addressSlice = try addresses.toOwnedSlice(a);

        var orders: std.ArrayList(Order) = .empty;
        i = 0;
        while (i < 5) : (i += 1) {
            var products: std.ArrayList(Product) = .empty;
            var j: i64 = 0;
            while (j < 3) : (j += 1) {
                var reviews: std.ArrayList(Review) = .empty;
                var k: i64 = 0;
                while (k < 2) : (k += 1) {
                    try reviews.append(a, .{
                        .reviewId = k,
                        .rating = 4 + k,
                        .comment = try std.fmt.allocPrint(a, "Great product review {d}", .{k}),
                        .reviewer = try std.fmt.allocPrint(a, "Reviewer{d}", .{k}),
                    });
                }

                try products.append(a, .{
                    .productId = i * 10 + j,
                    .name = try std.fmt.allocPrint(a, "Product{d}-{d}", .{ i, j }),
                    .category = try std.fmt.allocPrint(a, "Category{d}", .{j}),
                    .price = 99.99 + @as(f64, @floatFromInt(j * 50)),
                    .inventory = 100 + j,
                    .tags = &.{ "featured", "bestseller", "new" },
                    .specifications = .{
                        .weight = try std.fmt.allocPrint(a, "{d}.0 kg", .{1 + j}),
                        .dimensions = try std.fmt.allocPrint(a, "{d}x{d}x{d} cm", .{ 10 + j, 20 + j, 5 + j }),
                        .material = "premium",
                    },
                    .reviews = try reviews.toOwnedSlice(a),
                });
            }
            const productSlice = try products.toOwnedSlice(a);

            var totalAmount: f64 = 0;
            for (productSlice) |p| totalAmount += p.price;

            try orders.append(a, .{
                .orderId = customerId * 100 + i,
                .customerId = customerId,
                .orderDate = 1609459200 + i * 86400,
                .products = productSlice,
                .totalAmount = totalAmount,
                .status = "completed",
                .shippingAddress = addressSlice[0],
                .billingAddress = addressSlice[addressSlice.len - 1],
                .metadata = .{
                    .source = "mobile",
                    .campaign = try std.fmt.allocPrint(a, "campaign{d}", .{i}),
                    .discount = try std.fmt.allocPrint(a, "{d}.0", .{i * 5}),
                },
            });
        }

        const preferences = Preferences{
            .notifications = .{ .email = true, .sms = false, .push = true },
            .language = "en-US",
            .currency = "USD",
            .timezone = "America/New_York",
        };

        return .{
            .customerId = customerId,
            .firstName = try std.fmt.allocPrint(a, "FirstName{d}", .{customerId}),
            .lastName = try std.fmt.allocPrint(a, "LastName{d}", .{customerId}),
            .birthDate = 631152000 + customerId * 86400,
            .contactInfo = contactInfo,
            .addresses = addressSlice,
            .orderHistory = try orders.toOwnedSlice(a),
            .preferences = preferences,
            .isActive = @mod(customerId, 2) == 0,
            .loyaltyPrograms = &.{ "Gold", "Premium", "VIP" },
        };
    }

    // Pretty-printed stringify straight off the struct graph (Codable /
    // kotlinx analogue). Returns an arena-owned slice.
    fn serializeCustomerToJSON(a: std.mem.Allocator, customer: Customer) ![]u8 {
        var aw: std.Io.Writer.Allocating = .init(a);
        var js: std.json.Stringify = .{ .writer = &aw.writer, .options = .{ .whitespace = .indent_2 } };
        try js.write(customer);
        return aw.writer.buffered();
    }

    // Round-trip back into the typed Customer; errors -> null, matching the
    // try/catch of decodeFromString / JSONDecoder.
    fn deserializeCustomerFromJSON(a: std.mem.Allocator, jsonString: []const u8) ?Customer {
        const parsed = std.json.parseFromSlice(Customer, a, jsonString, .{}) catch return null;
        return parsed.value;
    }

    fn massSerializationTest(a: std.mem.Allocator, customerCount: usize) !void {
        var customers: std.ArrayList(Customer) = .empty;
        var i: usize = 0;
        while (i < customerCount) : (i += 1)
            try customers.append(a, try generateComplexCustomer(a, @as(i64, @intCast(i)) + 1));

        var jsonStrings: std.ArrayList([]const u8) = .empty;
        for (customers.items) |customer|
            try jsonStrings.append(a, try serializeCustomerToJSON(a, customer));

        var deserialized: usize = 0;
        var firstId: i64 = 0;
        var firstOrders: usize = 0;
        var firstProducts: usize = 0;
        var firstWeightLen: usize = 0;
        var firstLat: f64 = 0;
        for (jsonStrings.items, 0..) |jsonString, idx| {
            const customer = deserializeCustomerFromJSON(a, jsonString) orelse continue;
            deserialized += 1;
            if (idx == 0) {
                firstId = customer.customerId;
                firstOrders = customer.orderHistory.len;
                firstProducts = customer.orderHistory[0].products.len;
                firstWeightLen = customer.orderHistory[0].products[0].specifications.weight.len;
                firstLat = customer.addresses[0].latitude;
            }
        }

        var sampleLen: usize = 0;
        const sampleCount = @min(@as(usize, 3), jsonStrings.items.len);
        for (jsonStrings.items[0..sampleCount]) |s| sampleLen += s.len;

        std.mem.doNotOptimizeAway(customers.items.len);
        std.mem.doNotOptimizeAway(jsonStrings.items.len);
        std.mem.doNotOptimizeAway(deserialized);
        std.mem.doNotOptimizeAway(firstId);
        std.mem.doNotOptimizeAway(firstOrders);
        std.mem.doNotOptimizeAway(firstProducts);
        std.mem.doNotOptimizeAway(firstWeightLen);
        std.mem.doNotOptimizeAway(firstLat);
        std.mem.doNotOptimizeAway(sampleLen);
    }
};

fn doTheWork(a: std.mem.Allocator) !void {
    try JSONSerializationService.massSerializationTest(a, 100);
}

pub fn runBenchmark() void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    doTheWork(arena.allocator()) catch {};
}

export fn bench_run() void {
    runBenchmark();
}
