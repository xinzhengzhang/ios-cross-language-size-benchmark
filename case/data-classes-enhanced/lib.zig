// iOS Size Benchmark - Test Case Implementation
// Generated with Claude AI (https://claude.ai)
//
// Zig port of the "data-classes-enhanced" case (lib.kt/lib.ts are the source
// of truth). Idiomatic Zig models the three main shape families differently
// from the class-based originals, and these differences are intentional (not a
// 1:1 mirror):
//
//   * Kotlin `data class` -> plain structs. Zig has no auto-generated
//     equals/hashCode/toString/copy, so where lib.kt uses `.copy(...)` we add
//     explicit `copy` methods taking an options struct of optional fields
//     (the honest analogue of Kotlin's named-arg copy), and "destructuring" is
//     just field access.
//   * Kotlin `sealed class PaymentMethod` + nested data subclasses -> a
//     `union(enum)` dispatched by `switch`. This is THE idiomatic Zig mapping
//     for a closed hierarchy: the tag enumerates the variants, each payload is
//     a nested struct, and exhaustive `switch` replaces subtype polymorphism.
//   * The generic `OrderItem<T : Product>` -> a comptime
//     `fn(comptime T: type) type` factory. Zig has no type bounds, so the
//     `: Product` constraint becomes comptime duck-typing (any T exposing
//     `finalPrice` works); we instantiate it at `OrderItem(Product)`.
//   * Kotlin `Map<String, Any>` metadata -> a `MetaValue` union
//     (string | number | boolean), matching lib.ts; values are only carried,
//     never type-reflected, so this is behavior-preserving.
//
// A single exported entry (bench_run -> runBenchmark) constructs and uses every
// type under a per-run arena, so nothing is dead-code eliminated (the Zig
// analogue of lib.ts's exported entry / Swift's `public`).

const std = @import("std");

// Kotlin `Map<String, Any>` / lib.ts `MetaValue`: a closed set of carried
// scalar types modeled as a tagged union.
const MetaValue = union(enum) {
    string: []const u8,
    number: f64,
    boolean: bool,
};

// String-keyed maps: AutoHashMap can't hash []const u8, so string keys use
// StringHashMapUnmanaged (same .put(a,k,v)/.get(k)/.count() API).
const MetaMap = std.StringHashMapUnmanaged(MetaValue);
const StringMap = std.StringHashMapUnmanaged([]const u8);
const BoolMap = std.StringHashMapUnmanaged(bool);
const F64Map = std.StringHashMapUnmanaged(f64);

// Deterministic RNG mirroring Kotlin `(a..b).random()` / lib.ts randInt.
var rng_seed: i64 = 987654321;
fn randInt(min: i64, max: i64) i64 {
    rng_seed = (rng_seed *% 1103515245 +% 12345) & 0x7fffffff;
    return min + @mod(rng_seed, (max - min + 1));
}

fn padStart4(a: std.mem.Allocator, n: i64) ![]const u8 {
    return std.fmt.allocPrint(a, "{d:0>4}", .{n});
}

fn sumF64(nums: []const f64) f64 {
    var s: f64 = 0;
    for (nums) |n| s += n;
    return s;
}

// 复杂嵌套数据结构
const Address = struct {
    street: []const u8,
    city: []const u8,
    coordinates: [2]f64,
    metadata: MetaMap = .empty,
};

const ContactInfo = struct {
    emails: [][]const u8,
    phones: [][]const u8, // Kotlin Set<String> -> deduped slice
    socialMedia: StringMap,
    preferences: BoolMap = .empty,
};

// 带计算属性的数据类
const Product = struct {
    id: i64,
    name: []const u8,
    category: []const u8,
    basePrice: f64,
    taxes: []const f64,
    discounts: F64Map = .empty,
    tags: [][]const u8 = &.{},

    fn finalPrice(self: Product) f64 {
        var discountSum: f64 = 0;
        var it = self.discounts.valueIterator();
        while (it.next()) |v| discountSum += v.*;
        return self.basePrice + sumF64(self.taxes) - discountSum;
    }

    fn hasTag(self: Product, tag: []const u8) bool {
        for (self.tags) |t| if (std.mem.eql(u8, t, tag)) return true;
        return false;
    }

    fn displayName(self: Product, a: std.mem.Allocator) ![]const u8 {
        return if (self.hasTag("featured"))
            std.fmt.allocPrint(a, "\u{2b50} {s}", .{self.name})
        else
            self.name;
    }
};

// 复杂泛型数据类: generic over T (comptime duck-typing stands in for `T: Product`).
fn OrderItem(comptime T: type) type {
    return struct {
        const Self = @This();
        product: T,
        quantity: i64,
        customizations: MetaMap,
        bundledItems: []const Self = &.{},

        fn totalPrice(self: Self) f64 {
            var bundled: f64 = 0;
            for (self.bundledItems) |b| bundled += b.totalPrice();
            return self.product.finalPrice() * @as(f64, @floatFromInt(self.quantity)) + bundled;
        }
    };
}

// 密封类和数据类结合: sealed PaymentMethod -> union(enum) + switch.
const CreditCard = struct {
    number: []const u8,
    expiryMonth: i64,
    expiryYear: i64,
    securityCode: []const u8,
    billingAddress: Address,
};
const BankTransfer = struct {
    accountNumber: []const u8,
    routingNumber: []const u8,
    bankName: []const u8,
};
const DigitalWallet = struct {
    provider: []const u8,
    accountId: []const u8,
    linkedCards: []const CreditCard,
};
const PaymentMethod = union(enum) {
    credit_card: CreditCard,
    bank_transfer: BankTransfer,
    digital_wallet: DigitalWallet,
    cash: void,
};

const PersonalInfo = struct {
    firstName: []const u8,
    lastName: []const u8,
    dateOfBirth: []const u8,
    nationality: []const u8,
    governmentIds: StringMap,

    const Opts = struct {
        firstName: ?[]const u8 = null,
        lastName: ?[]const u8 = null,
        dateOfBirth: ?[]const u8 = null,
        nationality: ?[]const u8 = null,
        governmentIds: ?StringMap = null,
    };
    fn copy(self: PersonalInfo, opts: Opts) PersonalInfo {
        return .{
            .firstName = opts.firstName orelse self.firstName,
            .lastName = opts.lastName orelse self.lastName,
            .dateOfBirth = opts.dateOfBirth orelse self.dateOfBirth,
            .nationality = opts.nationality orelse self.nationality,
            .governmentIds = opts.governmentIds orelse self.governmentIds,
        };
    }
};

const LoyaltyProgram = struct {
    tier: []const u8,
    points: i64,
    benefits: [][]const u8,
    expiryDate: ?[]const u8,
};

const CustomerPreferences = struct {
    language: []const u8,
    currency: []const u8,
    timezone: []const u8,
    notifications: BoolMap,
    privacy: StringMap,

    const Opts = struct {
        language: ?[]const u8 = null,
        currency: ?[]const u8 = null,
        timezone: ?[]const u8 = null,
        notifications: ?BoolMap = null,
        privacy: ?StringMap = null,
    };
    fn copy(self: CustomerPreferences, opts: Opts) CustomerPreferences {
        return .{
            .language = opts.language orelse self.language,
            .currency = opts.currency orelse self.currency,
            .timezone = opts.timezone orelse self.timezone,
            .notifications = opts.notifications orelse self.notifications,
            .privacy = opts.privacy orelse self.privacy,
        };
    }
};

const StatusChange = struct {
    status: []const u8,
    timestamp: []const u8,
    reason: ?[]const u8,
    updatedBy: []const u8,
};
const OrderStatus = struct {
    current: []const u8,
    history: []const StatusChange,
    estimatedDelivery: ?[]const u8,
};
const OrderTimestamps = struct {
    created: []const u8,
    confirmed: ?[]const u8,
    shipped: ?[]const u8,
    delivered: ?[]const u8,
    cancelled: ?[]const u8,
};
const OrderTotals = struct {
    subtotal: f64,
    taxes: f64,
    shipping: f64,
    discounts: f64,
    total: f64,
};
const Order = struct {
    id: i64,
    customerId: i64,
    items: []const OrderItem(Product),
    shippingAddress: Address,
    billingAddress: Address,
    paymentMethod: PaymentMethod,
    status: OrderStatus,
    timestamps: OrderTimestamps,
    totals: OrderTotals,
    metadata: MetaMap = .empty,
};

// 深度嵌套数据结构
const Customer = struct {
    id: i64,
    personalInfo: PersonalInfo,
    contactInfo: ContactInfo,
    addresses: []const Address,
    paymentMethods: []const PaymentMethod,
    orderHistory: []const Order,
    loyaltyProgram: ?LoyaltyProgram,
    preferences: CustomerPreferences,

    const Opts = struct {
        personalInfo: ?PersonalInfo = null,
        preferences: ?CustomerPreferences = null,
    };
    fn copy(self: Customer, opts: Opts) Customer {
        return .{
            .id = self.id,
            .personalInfo = opts.personalInfo orelse self.personalInfo,
            .contactInfo = self.contactInfo,
            .addresses = self.addresses,
            .paymentMethods = self.paymentMethods,
            .orderHistory = self.orderHistory,
            .loyaltyProgram = self.loyaltyProgram,
            .preferences = opts.preferences orelse self.preferences,
        };
    }
};

const CustomerSummary = struct {
    id: i64,
    name: []const u8,
    totalOrders: usize,
    totalSpent: f64,
    loyaltyTier: ?[]const u8,
    primaryEmail: ?[]const u8,
    addressCount: usize,
};

const DataClassesService = struct {
    fn generateComplexCustomer(a: std.mem.Allocator, customerId: i64) !Customer {
        var govIds: StringMap = .empty;
        try govIds.put(a, "ssn", try std.fmt.allocPrint(a, "123-45-{s}", .{try padStart4(a, customerId)}));
        try govIds.put(a, "passport", try std.fmt.allocPrint(a, "P{d}234567", .{customerId}));
        const personalInfo = PersonalInfo{
            .firstName = try std.fmt.allocPrint(a, "John{d}", .{customerId}),
            .lastName = try std.fmt.allocPrint(a, "Doe{d}", .{customerId}),
            .dateOfBirth = "1990-01-01",
            .nationality = "US",
            .governmentIds = govIds,
        };

        var social: StringMap = .empty;
        try social.put(a, "twitter", try std.fmt.allocPrint(a, "@john{d}", .{customerId}));
        try social.put(a, "linkedin", try std.fmt.allocPrint(a, "john-doe-{d}", .{customerId}));
        try social.put(a, "instagram", try std.fmt.allocPrint(a, "john_{d}", .{customerId}));
        const emails = try a.dupe([]const u8, &.{
            try std.fmt.allocPrint(a, "john.doe{d}@email.com", .{customerId}),
            try std.fmt.allocPrint(a, "john{d}@work.com", .{customerId}),
        });
        const phones = try a.dupe([]const u8, &.{
            try std.fmt.allocPrint(a, "+1-555-{s}", .{try padStart4(a, customerId)}),
            try std.fmt.allocPrint(a, "+1-555-{s}", .{try padStart4(a, customerId + 1000)}),
        });
        const contactInfo = ContactInfo{
            .emails = emails,
            .phones = phones,
            .socialMedia = social,
        };

        var homeMeta: MetaMap = .empty;
        try homeMeta.put(a, "type", .{ .string = "home" });
        try homeMeta.put(a, "primary", .{ .boolean = true });
        var workMeta: MetaMap = .empty;
        try workMeta.put(a, "type", .{ .string = "work" });
        try workMeta.put(a, "primary", .{ .boolean = false });
        const addresses = try a.dupe(Address, &.{
            .{ .street = try std.fmt.allocPrint(a, "{d}00 Main St", .{customerId}), .city = "New York", .coordinates = .{ 40.7128, -74.0060 }, .metadata = homeMeta },
            .{ .street = try std.fmt.allocPrint(a, "{d}01 Business Ave", .{customerId}), .city = "Boston", .coordinates = .{ 42.3601, -71.0589 }, .metadata = workMeta },
        });

        const paymentMethods = try a.dupe(PaymentMethod, &.{
            .{ .credit_card = .{
                .number = try std.fmt.allocPrint(a, "4532-1234-5678-{s}", .{try padStart4(a, customerId)}),
                .expiryMonth = 12,
                .expiryYear = 2027,
                .securityCode = "123",
                .billingAddress = addresses[0],
            } },
            .{ .digital_wallet = .{
                .provider = "ApplePay",
                .accountId = try std.fmt.allocPrint(a, "apple_{d}", .{customerId}),
                .linkedCards = &.{},
            } },
        });

        var products: std.ArrayList(Product) = .empty;
        var i: i64 = 1;
        while (i <= 5) : (i += 1) {
            var discounts: F64Map = .empty;
            if (@mod(i, 2) == 0) try discounts.put(a, "member", 5.0);
            const tagPool = [_][]const u8{ "featured", "bestseller" };
            const tagCount: usize = @intCast(@mod(i, 2) + 1);
            const tags = try a.dupe([]const u8, tagPool[0..tagCount]);
            try products.append(a, .{
                .id = customerId * 100 + i,
                .name = try std.fmt.allocPrint(a, "Product {d} for Customer {d}", .{ i, customerId }),
                .category = try std.fmt.allocPrint(a, "Category{d}", .{@mod(i, 3)}),
                .basePrice = 99.99 + @as(f64, @floatFromInt(i)) * 10,
                .taxes = &.{ 8.25, 2.5 },
                .discounts = discounts,
                .tags = tags,
            });
        }

        const Item = OrderItem(Product);
        var allOrderItems: std.ArrayList(Item) = .empty;
        for (products.items) |product| {
            var customizations: MetaMap = .empty;
            try customizations.put(a, "color", .{ .string = "blue" });
            try customizations.put(a, "size", .{ .string = "large" });
            try customizations.put(a, "engraving", .{ .string = try std.fmt.allocPrint(a, "Custom text {d}", .{customerId}) });
            try allOrderItems.append(a, .{ .product = product, .quantity = randInt(1, 3), .customizations = customizations });
        }

        var orders: std.ArrayList(Order) = .empty;
        var orderIndex: i64 = 1;
        while (orderIndex <= 3) : (orderIndex += 1) {
            const take: usize = @intCast(orderIndex + 1);
            const items = allOrderItems.items[0..take];
            var subtotal: f64 = 0;
            for (items) |it| subtotal += it.totalPrice();
            const taxes = subtotal * 0.0825;
            const shipping: f64 = 9.99;
            const discounts: f64 = if (@mod(orderIndex, 2) == 0) 15.0 else 0.0;
            const total = subtotal + taxes + shipping - discounts;

            const history = try a.dupe(StatusChange, &.{
                .{ .status = "pending", .timestamp = "2024-01-01T10:00:00Z", .reason = null, .updatedBy = "system" },
                .{ .status = "confirmed", .timestamp = "2024-01-01T10:05:00Z", .reason = "payment_verified", .updatedBy = "system" },
                .{ .status = "shipped", .timestamp = "2024-01-02T14:30:00Z", .reason = null, .updatedBy = "warehouse" },
                .{ .status = "delivered", .timestamp = "2024-01-05T16:45:00Z", .reason = null, .updatedBy = "courier" },
            });
            try orders.append(a, .{
                .id = customerId * 1000 + orderIndex,
                .customerId = customerId,
                .items = try a.dupe(Item, items),
                .shippingAddress = addresses[0],
                .billingAddress = addresses[addresses.len - 1],
                .paymentMethod = paymentMethods[0],
                .status = .{ .current = "delivered", .history = history, .estimatedDelivery = "2024-01-05" },
                .timestamps = .{ .created = "2024-01-01T10:00:00Z", .confirmed = "2024-01-01T10:05:00Z", .shipped = "2024-01-02T14:30:00Z", .delivered = "2024-01-05T16:45:00Z", .cancelled = null },
                .totals = .{ .subtotal = subtotal, .taxes = taxes, .shipping = shipping, .discounts = discounts, .total = total },
            });
        }

        const loyaltyProgram = LoyaltyProgram{
            .tier = "Gold",
            .points = customerId * 100,
            .benefits = try a.dupe([]const u8, &.{ "free_shipping", "priority_support", "exclusive_discounts" }),
            .expiryDate = "2025-12-31",
        };

        var notifications: BoolMap = .empty;
        try notifications.put(a, "email", true);
        try notifications.put(a, "sms", false);
        try notifications.put(a, "push", true);
        try notifications.put(a, "marketing", false);
        var privacy: StringMap = .empty;
        try privacy.put(a, "share_data", "no");
        try privacy.put(a, "cookies", "essential_only");
        try privacy.put(a, "analytics", "anonymized");
        const preferences = CustomerPreferences{
            .language = "en-US",
            .currency = "USD",
            .timezone = "America/New_York",
            .notifications = notifications,
            .privacy = privacy,
        };

        return .{
            .id = customerId,
            .personalInfo = personalInfo,
            .contactInfo = contactInfo,
            .addresses = addresses,
            .paymentMethods = paymentMethods,
            .orderHistory = try orders.toOwnedSlice(a),
            .loyaltyProgram = loyaltyProgram,
            .preferences = preferences,
        };
    }

    fn massDataProcessing(a: std.mem.Allocator, customerCount: i64) !void {
        var customers: std.ArrayList(Customer) = .empty;
        var i: i64 = 1;
        while (i <= customerCount) : (i += 1)
            try customers.append(a, try generateComplexCustomer(a, i));

        // 测试数据类的复制操作 (copy with modified nested data)
        var updatedCustomers: std.ArrayList(Customer) = .empty;
        for (customers.items) |customer| {
            var newNotifications = try customer.preferences.notifications.clone(a);
            try newNotifications.put(a, "marketing", true);
            const updatedPersonal = customer.personalInfo.copy(.{
                .firstName = try std.fmt.allocPrint(a, "{s}_Updated", .{customer.personalInfo.firstName}),
            });
            try updatedCustomers.append(a, customer.copy(.{
                .personalInfo = updatedPersonal,
                .preferences = customer.preferences.copy(.{ .notifications = newNotifications }),
            }));
        }

        // 测试解构操作 (field access stands in for destructuring)
        var destructAcc: usize = 0;
        for (customers.items) |customer| {
            const id = customer.id;
            const firstName = customer.personalInfo.firstName;
            const lastName = customer.personalInfo.lastName;
            const emails = customer.contactInfo.emails;
            const phones = customer.contactInfo.phones;
            destructAcc += @as(usize, @intCast(id)) + firstName.len + lastName.len + emails.len + phones.len;
        }

        // 测试数据类的相等性和哈希码 (ids are unique -> map size == count)
        var customerMap: std.AutoHashMapUnmanaged(i64, Customer) = .empty;
        for (customers.items) |c| try customerMap.put(a, c.id, c);
        const customerSetSize = customers.items.len;

        // 测试复杂的数据转换
        var customerSummaries: std.ArrayList(CustomerSummary) = .empty;
        for (customers.items) |customer| {
            var totalSpent: f64 = 0;
            for (customer.orderHistory) |o| totalSpent += o.totals.total;
            try customerSummaries.append(a, .{
                .id = customer.id,
                .name = try std.fmt.allocPrint(a, "{s} {s}", .{ customer.personalInfo.firstName, customer.personalInfo.lastName }),
                .totalOrders = customer.orderHistory.len,
                .totalSpent = totalSpent,
                .loyaltyTier = if (customer.loyaltyProgram) |lp| lp.tier else null,
                .primaryEmail = if (customer.contactInfo.emails.len > 0) customer.contactInfo.emails[0] else null,
                .addressCount = customer.addresses.len,
            });
        }

        var summarySpent: f64 = 0;
        for (customerSummaries.items) |s| summarySpent += s.totalSpent;

        std.mem.doNotOptimizeAway(customers.items.len);
        std.mem.doNotOptimizeAway(updatedCustomers.items.len);
        std.mem.doNotOptimizeAway(customerSummaries.items.len);
        std.mem.doNotOptimizeAway(customerSetSize);
        std.mem.doNotOptimizeAway(customerMap.count());
        std.mem.doNotOptimizeAway(destructAcc);
        std.mem.doNotOptimizeAway(summarySpent);
        std.mem.doNotOptimizeAway(updatedCustomers.items[0].personalInfo.firstName.len);
    }
};

fn doTheWork(a: std.mem.Allocator) !void {
    try DataClassesService.massDataProcessing(a, 50);
}

pub fn runBenchmark() void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    doTheWork(arena.allocator()) catch {};
}

export fn bench_run() void {
    runBenchmark();
}
