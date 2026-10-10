// iOS Size Benchmark - Test Case Implementation
// Generated with Claude AI (https://claude.ai)
//
// Zig port of the "scope-functions" case. Kotlin's let/run/apply/also/with/
// takeIf scope functions have no Zig equivalent, and Zig has no closures to
// model their trailing lambdas — so the idiomatic port simply writes the
// straight-line code they sugar over: plain blocks and explicit locals,
// mutating arena-allocated structs through pointers. The one spot that reads
// cleanly as a helper is `takeIf`, kept as a tiny generic guard taking a
// precomputed bool (no capture needed). Mapping:
//   x.apply { ... }   -> allocate, then set fields on the *T in place
//   x.also  { ... }   -> run the side effect inline, keep using the same *T
//   x.let   { f(it) } -> bind an explicit local, compute the expression
//   x.run   { ... }   -> a plain block / helper returning the result
//   x.takeIf { p }    -> takeIf(T, x, p)  (returns ?T)
//   x?.let            -> an explicit `if (opt) |v|` null check
// Kotlin's heterogeneous `Map<String, Any>` summaries become a StringHashMap
// of formatted strings. A single exported entry (bench_run -> runBenchmark)
// drives every service method so nothing is dead-code eliminated.

const std = @import("std");

// takeIf: the one scope function that survives as a helper — no closure
// capture, just a value plus a precomputed predicate result.
fn takeIf(comptime T: type, value: T, keep: bool) ?T {
    return if (keep) value else null;
}

fn hasAt(s: []const u8) bool {
    return std.mem.indexOfScalar(u8, s, '@') != null;
}

fn boolStr(b: bool) []const u8 {
    return if (b) "true" else "false";
}

// Kotlin's heterogeneous Map<String, Any> summary payloads -> a string map.
const Summary = std.StringHashMapUnmanaged([]const u8);

// --- Data models (Kotlin `data class` with mutable `var` fields) ---
const Address = struct { street: []const u8, city: []const u8, state: []const u8, zipCode: []const u8, country: []const u8 };
const UserPreferences = struct { theme: []const u8, language: []const u8, notifications: bool, newsletter: bool };
const User = struct { id: []const u8, name: []const u8, email: []const u8, age: i64, address: ?*Address = null, preferences: ?*UserPreferences = null };
const Product = struct {
    id: []const u8,
    name: []const u8,
    price: f64,
    category: []const u8,
    description: []const u8,
    inStock: bool,
    tags: std.ArrayList([]const u8) = .empty,
};
const CartItem = struct { productId: []const u8, quantity: i64, price: f64 };
const ShoppingCart = struct {
    id: []const u8,
    userId: []const u8,
    items: std.ArrayList(*CartItem) = .empty,
    discountCode: ?[]const u8 = null,
    discountAmount: f64 = 0.0,
};
const Order = struct {
    id: []const u8,
    cart: *ShoppingCart,
    shippingAddress: *Address,
    paymentMethod: []const u8,
    status: []const u8,
    timestamp: i64,
};
const BankAccount = struct { accountNumber: []const u8, balance: f64, accountType: []const u8, isActive: bool };

// ApiResponse<T> -> comptime factory (monomorphized per instantiation).
fn ApiResponse(comptime T: type) type {
    return struct {
        data: ?T = null,
        errorMessage: ?[]const u8 = null,
        statusCode: i64 = 0,
        headers: std.StringHashMapUnmanaged([]const u8) = .empty,
    };
}
const ApiResponseStr = ApiResponse([]const u8);

const ConnectionPoolConfig = struct { minConnections: i64, maxConnections: i64, timeout: i64 };
const DatabaseConfig = struct {
    host: []const u8,
    port: i64,
    database: []const u8,
    username: []const u8,
    password: []const u8,
    connectionPool: ?*ConnectionPoolConfig = null,
};
const AppConfig = struct {
    appName: []const u8,
    version: []const u8,
    environment: []const u8,
    database: *DatabaseConfig,
    features: std.StringHashMapUnmanaged(bool) = .empty,
    settings: std.StringHashMapUnmanaged([]const u8) = .empty,
};

// Kotlin Pair<A, B> (used by transferFunds).
fn Pair(comptime A: type, comptime B: type) type {
    return struct { first: A, second: B };
}

// Kotlin MutableList.remove(element): drop first occurrence if present.
fn removeFromList(list: *std.ArrayList([]const u8), element: []const u8) void {
    for (list.items, 0..) |it, i| {
        if (std.mem.eql(u8, it, element)) {
            _ = list.orderedRemove(i);
            return;
        }
    }
}

// --- Service structs. Kotlin's scope functions collapse into straight-line
// code here: allocate a struct, set its fields in place, run side effects
// inline. Services are stateless namespaces; methods take the arena. ---
const UserService = struct {
    fn generateUserId() []const u8 {
        return "USER_12345";
    }
    fn logPreferenceChange(_: []const u8, _: []const u8, _: []const u8) void {}

    // Kotlin `apply` for object init -> allocate, then set fields on *User.
    fn createUser(a: std.mem.Allocator, name: []const u8, email: []const u8, age: i64) !*User {
        const addr = try a.create(Address);
        addr.* = .{ .street = "", .city = "", .state = "", .zipCode = "", .country = "USA" };
        const prefs = try a.create(UserPreferences);
        prefs.* = .{ .theme = "light", .language = "en", .notifications = true, .newsletter = false };
        const u = try a.create(User);
        u.* = .{ .id = generateUserId(), .name = name, .email = email, .age = age, .address = addr, .preferences = prefs };
        return u;
    }

    // Kotlin `let` with null-safe `?.let` on the optionals -> explicit checks.
    fn updateUserWithValidation(user: *User, newEmail: ?[]const u8, newAge: ?i64) ?*User {
        var updated = false;
        if (newEmail) |email| {
            if (hasAt(email)) {
                user.email = email;
                updated = true;
            }
        }
        if (newAge) |age| {
            if (age > 0 and age < 120) {
                user.age = age;
                updated = true;
            }
        }
        return if (updated) user else null;
    }

    // Kotlin `user?.let { ... } ?: ...` -> explicit optional unwrap.
    fn processUserData(a: std.mem.Allocator, user: ?*User) ![]const u8 {
        if (user) |valid| {
            return std.fmt.allocPrint(a, "Processing user: {s} ({s})", .{ valid.name, valid.email });
        }
        return "No user to process";
    }

    // Kotlin `also` (side effect, return original) -> run it inline, return user.
    fn configureUserPreferences(user: *User) *User {
        if (user.preferences) |prefs| {
            prefs.theme = "dark";
            prefs.notifications = true;
            logPreferenceChange(user.id, "theme", "dark");
            logPreferenceChange(user.id, "notifications", "enabled");
        }
        return user;
    }

    // Kotlin `run` (receiver block returning a value) -> a plain function body.
    fn validateAndFormatUser(a: std.mem.Allocator, user: *User) ![]const u8 {
        const isValidEmail = hasAt(user.email);
        const isValidAge = user.age >= 1 and user.age <= 120;
        const hasAddress = user.address != null;
        if (!isValidEmail) return std.fmt.allocPrint(a, "Invalid email: {s}", .{user.email});
        if (!isValidAge) return std.fmt.allocPrint(a, "Invalid age: {d}", .{user.age});
        if (!hasAddress) return "Missing address information";
        return std.fmt.allocPrint(a, "Valid user: {s} ({s}, age {d})", .{ user.name, user.email, user.age });
    }

    fn getUserSummary(a: std.mem.Allocator, user: ?*User) !Summary {
        var summary: Summary = .empty;
        const valid = user orelse return summary;
        try summary.put(a, "id", valid.id);
        try summary.put(a, "name", valid.name);
        try summary.put(a, "email", valid.email);
        try summary.put(a, "age", try std.fmt.allocPrint(a, "{d}", .{valid.age}));
        try summary.put(a, "hasAddress", boolStr(valid.address != null));
        try summary.put(a, "hasPreferences", boolStr(valid.preferences != null));
        const addrSummary = if (valid.address) |addr|
            try std.fmt.allocPrint(a, "{s}, {s}, {s}", .{ addr.city, addr.state, addr.country })
        else
            "No address";
        try summary.put(a, "addressSummary", addrSummary);
        const prefSummary = if (valid.preferences) |p|
            try std.fmt.allocPrint(a, "Theme: {s}, Language: {s}", .{ p.theme, p.language })
        else
            "No preferences";
        try summary.put(a, "preferencesSummary", prefSummary);
        return summary;
    }
};
const ProductService = struct {
    fn generateProductId() []const u8 {
        return "PROD_12345";
    }
    fn logPriceChange(_: []const u8, _: f64, _: f64) void {}
    fn logSaleConfiguration(_: []const u8, _: f64) void {}
    fn notifyPriceChange(_: []const u8, _: f64) void {}

    fn createProduct(a: std.mem.Allocator, name: []const u8, price: f64, category: []const u8) !*Product {
        const p = try a.create(Product);
        p.* = .{
            .id = generateProductId(),
            .name = name,
            .price = price,
            .category = category,
            .description = try std.fmt.allocPrint(a, "Default description for {s}", .{name}),
            .inStock = true,
        };
        try p.tags.append(a, "new");
        try p.tags.append(a, category); // category.lowercase() stand-in
        if (price > 100) try p.tags.append(a, "premium");
        return p;
    }

    // Kotlin `takeIf { newPrice > 0 }?.apply { ... }` -> guard, then mutate.
    fn updateProductPrice(a: std.mem.Allocator, product: *Product, newPrice: f64) !?*Product {
        const candidate = takeIf(*Product, product, newPrice > 0) orelse return null;
        const oldPrice = candidate.price;
        candidate.price = newPrice;
        removeFromList(&candidate.tags, "budget");
        removeFromList(&candidate.tags, "premium");
        removeFromList(&candidate.tags, "luxury");
        if (newPrice < 50) {
            try candidate.tags.append(a, "budget");
        } else if (newPrice > 500) {
            try candidate.tags.append(a, "luxury");
        } else if (newPrice > 100) {
            try candidate.tags.append(a, "premium");
        }
        logPriceChange(candidate.id, oldPrice, newPrice);
        return candidate;
    }

    // Kotlin `mapNotNull { takeIf?.let }` -> plain loop with explicit guard.
    fn processProductBatch(a: std.mem.Allocator, products: []const *Product) ![][]const u8 {
        var result: std.ArrayList([]const u8) = .empty;
        for (products) |product| {
            if (takeIf(*Product, product, product.inStock)) |p| {
                try result.append(a, try std.fmt.allocPrint(a, "Processing: {s} - ${d}", .{ p.name, p.price }));
            }
        }
        return result.toOwnedSlice(a);
    }

    fn configureProductForSale(a: std.mem.Allocator, product: *Product, discountPercent: f64) !*Product {
        product.price *= 1 - discountPercent / 100;
        try product.tags.append(a, "sale");
        try product.tags.append(a, "discounted");
        logSaleConfiguration(product.id, discountPercent);
        notifyPriceChange(product.id, product.price);
        return product;
    }

    fn analyzeProduct(a: std.mem.Allocator, product: *Product) !Summary {
        const priceCategory = if (product.price < 20)
            "budget"
        else if (product.price < 100)
            "mid-range"
        else if (product.price < 500)
            "premium"
        else
            "luxury";

        const promo = [_][]const u8{ "sale", "new", "featured" };
        const cats = [_][]const u8{ "electronics", "clothing", "books" };
        var hasPromo = false;
        var categoryTagCount: i64 = 0;
        for (product.tags.items) |t| {
            for (promo) |pr| if (std.mem.eql(u8, t, pr)) {
                hasPromo = true;
            };
            for (cats) |c| if (std.mem.eql(u8, t, c)) {
                categoryTagCount += 1;
            };
        }

        var result: Summary = .empty;
        try result.put(a, "productId", product.id);
        try result.put(a, "priceCategory", priceCategory);
        try result.put(a, "availability", if (product.inStock) "available" else "out_of_stock");
        try result.put(a, "tagCount", try std.fmt.allocPrint(a, "{d}", .{product.tags.items.len}));
        try result.put(a, "hasPromoTags", boolStr(hasPromo));
        try result.put(a, "categoryTagCount", try std.fmt.allocPrint(a, "{d}", .{categoryTagCount}));
        try result.put(a, "summary", try std.fmt.allocPrint(a, "{s} ({s}) - {s}", .{
            product.name,
            priceCategory,
            if (product.inStock) "In Stock" else "Out of Stock",
        }));
        return result;
    }
};

const ShoppingCartService = struct {
    fn generateCartId() []const u8 {
        return "CART_12345";
    }
    fn generateOrderId() []const u8 {
        return "ORDER_12345";
    }
    fn validateDiscountCode(code: []const u8) bool {
        return code.len > 0;
    }
    fn calculateDiscount(_: *ShoppingCart, _: []const u8) f64 {
        return 10.0;
    }
    fn logCartItemAdded(_: []const u8, _: []const u8, _: i64) void {}
    fn logDiscountApplied(_: []const u8, _: []const u8, _: f64) void {}
    fn logOrderCreated(_: []const u8, _: []const u8) void {}
    fn clearCart(cart: *ShoppingCart) void {
        cart.items.clearRetainingCapacity();
    }

    fn createCart(a: std.mem.Allocator, userId: []const u8) !*ShoppingCart {
        const c = try a.create(ShoppingCart);
        c.* = .{ .id = generateCartId(), .userId = userId };
        return c;
    }

    // Kotlin `also` -> mutate the shared cart in place, return it.
    fn addItemToCart(a: std.mem.Allocator, cart: *ShoppingCart, productId: []const u8, quantity: i64, price: f64) !*ShoppingCart {
        const item = try a.create(CartItem);
        item.* = .{ .productId = productId, .quantity = quantity, .price = price };
        try cart.items.append(a, item);
        logCartItemAdded(cart.id, productId, quantity);
        return cart;
    }

    fn applyDiscount(cart: *ShoppingCart, discountCode: []const u8) ?*ShoppingCart {
        const valid = takeIf(*ShoppingCart, cart, validateDiscountCode(discountCode)) orelse return null;
        valid.discountCode = discountCode;
        valid.discountAmount = calculateDiscount(valid, discountCode);
        logDiscountApplied(valid.id, discountCode, valid.discountAmount);
        return valid;
    }

    fn processCartCheckout(a: std.mem.Allocator, cart: *ShoppingCart, shippingAddress: *Address, paymentMethod: []const u8) !?*Order {
        const valid = takeIf(*ShoppingCart, cart, cart.items.items.len > 0) orelse return null;
        const order = try a.create(Order);
        order.* = .{
            .id = generateOrderId(),
            .cart = valid,
            .shippingAddress = shippingAddress,
            .paymentMethod = paymentMethod,
            .status = "pending",
            .timestamp = 1640995200000,
        };
        logOrderCreated(order.id, valid.id);
        clearCart(valid);
        return order;
    }

    fn calculateCartSummary(a: std.mem.Allocator, cart: *ShoppingCart) !Summary {
        var subtotal: f64 = 0;
        var itemCount: i64 = 0;
        for (cart.items.items) |it| {
            subtotal += it.price * @as(f64, @floatFromInt(it.quantity));
            itemCount += it.quantity;
        }
        const total = subtotal - cart.discountAmount;
        var result: Summary = .empty;
        try result.put(a, "cartId", cart.id);
        try result.put(a, "itemCount", try std.fmt.allocPrint(a, "{d}", .{itemCount}));
        try result.put(a, "subtotal", try std.fmt.allocPrint(a, "{d}", .{subtotal}));
        try result.put(a, "discountAmount", try std.fmt.allocPrint(a, "{d}", .{cart.discountAmount}));
        try result.put(a, "total", try std.fmt.allocPrint(a, "{d}", .{total}));
        try result.put(a, "hasDiscount", boolStr(cart.discountCode != null));
        try result.put(a, "discountCode", cart.discountCode orelse "none");
        try result.put(a, "items", try std.fmt.allocPrint(a, "{d}", .{cart.items.items.len}));
        return result;
    }
};
const BankingService = struct {
    fn logAccountCreated(_: []const u8, _: []const u8) void {}
    fn logTransaction(_: []const u8, _: f64, _: []const u8) void {}
    fn logTransfer(_: []const u8, _: []const u8, _: f64) void {}

    fn createAccount(a: std.mem.Allocator, accountNumber: []const u8, accountType: []const u8) !*BankAccount {
        const acc = try a.create(BankAccount);
        acc.* = .{ .accountNumber = accountNumber, .balance = 0.0, .accountType = accountType, .isActive = true };
        logAccountCreated(acc.accountNumber, acc.accountType);
        return acc;
    }

    fn processTransaction(account: *BankAccount, amount: f64, txType: []const u8) ?*BankAccount {
        const active = takeIf(*BankAccount, account, account.isActive) orelse return null;
        if (std.mem.eql(u8, txType, "deposit")) {
            active.balance += amount;
            logTransaction(active.accountNumber, amount, txType);
            return active;
        } else if (std.mem.eql(u8, txType, "withdrawal")) {
            const sufficient = takeIf(*BankAccount, active, active.balance >= amount) orelse return null;
            sufficient.balance -= amount;
            logTransaction(sufficient.accountNumber, amount, txType);
            return sufficient;
        }
        return null;
    }

    fn generateAccountStatement(a: std.mem.Allocator, account: *BankAccount) !Summary {
        const status = if (!account.isActive)
            "inactive"
        else if (account.balance < 0)
            "overdrawn"
        else if (account.balance < 100)
            "low_balance"
        else
            "normal";
        var result: Summary = .empty;
        try result.put(a, "accountNumber", account.accountNumber);
        try result.put(a, "accountType", account.accountType);
        try result.put(a, "balance", try std.fmt.allocPrint(a, "{d}", .{account.balance}));
        try result.put(a, "status", status);
        try result.put(a, "isActive", boolStr(account.isActive));
        try result.put(a, "formattedBalance", try std.fmt.allocPrint(a, "${d}", .{account.balance}));
        try result.put(a, "canWithdraw", boolStr(account.isActive and account.balance > 0));
        try result.put(a, "summary", try std.fmt.allocPrint(a, "{s} account #{s}: {d} ({s})", .{
            account.accountType, account.accountNumber, account.balance, status,
        }));
        return result;
    }

    fn transferFunds(fromAccount: *BankAccount, toAccount: *BankAccount, amount: f64) Pair(?*BankAccount, ?*BankAccount) {
        if (takeIf(*BankAccount, fromAccount, fromAccount.isActive and fromAccount.balance >= amount)) |validFrom| {
            if (takeIf(*BankAccount, toAccount, toAccount.isActive)) |validTo| {
                validFrom.balance -= amount;
                validTo.balance += amount;
                logTransfer(validFrom.accountNumber, validTo.accountNumber, amount);
                return .{ .first = validFrom, .second = validTo };
            }
        }
        return .{ .first = null, .second = null };
    }
};

const ApiService = struct {
    fn logSuccessfulResponse(_: i64) void {}
    fn logErrorResponse(_: i64, _: []const u8) void {}
    fn logRetrySuccess(_: i64, _: i64) void {}
    fn logRetryAttempt(_: i64, _: i64, _: i64) void {}

    fn processApiResponse(response: *ApiResponseStr) ?[]const u8 {
        if (takeIf(*ApiResponseStr, response, response.statusCode >= 200 and response.statusCode <= 299)) |valid| {
            if (valid.data) |data| {
                logSuccessfulResponse(valid.statusCode);
                return data;
            }
            return null;
        }
        logErrorResponse(response.statusCode, response.errorMessage orelse "Unknown error");
        return null;
    }

    fn createApiResponse(a: std.mem.Allocator, data: ?[]const u8, statusCode: i64, errorMessage: ?[]const u8) !ApiResponseStr {
        var r: ApiResponseStr = .{ .data = data, .statusCode = statusCode, .errorMessage = errorMessage };
        try r.headers.put(a, "Content-Type", "application/json");
        try r.headers.put(a, "Timestamp", "1640995200000");
        try r.headers.put(a, "Server", "Zig-Service");
        return r;
    }

    fn handleApiError(a: std.mem.Allocator, response: *ApiResponseStr) ![]const u8 {
        const err = response.errorMessage orelse "Unknown error";
        return switch (response.statusCode) {
            404 => std.fmt.allocPrint(a, "Resource not found: {s}", .{response.errorMessage orelse "Unknown resource"}),
            401 => "Unauthorized access",
            403 => "Forbidden operation",
            500 => std.fmt.allocPrint(a, "Internal server error: {s}", .{err}),
            else => std.fmt.allocPrint(a, "API error ({d}): {s}", .{ response.statusCode, err }),
        };
    }

    // Kotlin passes a `() -> ApiResponse<T>` lambda; Zig has no closures, so
    // the retried call is a plain function pointer (allocator threaded in).
    fn retryApiCall(a: std.mem.Allocator, maxRetries: i64, apiCall: *const fn (std.mem.Allocator) anyerror!ApiResponseStr) !?ApiResponseStr {
        var attempt: i64 = 0;
        while (attempt < maxRetries) : (attempt += 1) {
            var response = try apiCall(a);
            if (takeIf(*ApiResponseStr, &response, response.statusCode >= 200 and response.statusCode <= 299)) |ok| {
                logRetrySuccess(attempt + 1, maxRetries);
                return ok.*;
            }
            if (attempt < maxRetries - 1) logRetryAttempt(attempt + 1, maxRetries, response.statusCode);
        }
        return null;
    }
};

fn okApiCall(a: std.mem.Allocator) anyerror!ApiResponseStr {
    return ApiService.createApiResponse(a, "ok", 200, null);
}

const ConfigurationService = struct {
    fn logConfigurationCreated(_: []const u8, _: []const u8) void {}
    fn logConfigurationUpdated(_: []const u8, _: usize) void {}

    fn createDatabaseConfig(a: std.mem.Allocator, host: []const u8, port: i64, database: []const u8) !*DatabaseConfig {
        const pool = try a.create(ConnectionPoolConfig);
        pool.* = .{ .minConnections = 5, .maxConnections = 20, .timeout = 30000 };
        const c = try a.create(DatabaseConfig);
        c.* = .{ .host = host, .port = port, .database = database, .username = "defaultUser", .password = "defaultPassword", .connectionPool = pool };
        return c;
    }

    fn createAppConfig(a: std.mem.Allocator, appName: []const u8, version: []const u8, environment: []const u8) !*AppConfig {
        const c = try a.create(AppConfig);
        c.* = .{
            .appName = appName,
            .version = version,
            .environment = environment,
            .database = try createDatabaseConfig(a, "localhost", 5432, "app_db"),
        };
        const isDev = std.mem.eql(u8, environment, "development");
        const isProd = std.mem.eql(u8, environment, "production");
        try c.features.put(a, "feature_flags", true);
        try c.features.put(a, "analytics", !isDev);
        try c.features.put(a, "logging", true);
        try c.features.put(a, "cache", isProd);
        try c.settings.put(a, "log_level", if (isProd) "ERROR" else "DEBUG");
        try c.settings.put(a, "cache_ttl", "3600");
        try c.settings.put(a, "max_connections", "100");
        try c.settings.put(a, "timeout", "30000");
        logConfigurationCreated(c.appName, c.environment);
        return c;
    }

    fn validateConfiguration(a: std.mem.Allocator, config: *AppConfig) !Summary {
        var issues: i64 = 0;
        if (config.appName.len == 0) issues += 1;
        if (config.version.len == 0) issues += 1;
        const envs = [_][]const u8{ "development", "staging", "production" };
        var validEnv = false;
        for (envs) |e| if (std.mem.eql(u8, config.environment, e)) {
            validEnv = true;
        };
        if (!validEnv) issues += 1;
        if (config.database.host.len == 0) issues += 1;
        if (config.database.port <= 0) issues += 1;
        if (config.database.database.len == 0) issues += 1;

        var result: Summary = .empty;
        try result.put(a, "isValid", boolStr(issues == 0));
        try result.put(a, "issues", try std.fmt.allocPrint(a, "{d}", .{issues}));
        try result.put(a, "summary", if (issues == 0)
            "Configuration is valid"
        else
            try std.fmt.allocPrint(a, "Found {d} issues", .{issues}));
        return result;
    }

    fn updateConfiguration(a: std.mem.Allocator, config: *AppConfig, updates: []const [2][]const u8) !*AppConfig {
        for (updates) |kv| try config.settings.put(a, kv[0], kv[1]);
        logConfigurationUpdated(config.appName, updates.len);
        return config;
    }
};

// Sink: consumes every produced value so ReleaseSmall can't DCE the graph.
const Bench = struct {
    sink: i64 = 0,
    fn note(self: *Bench, s: []const u8) void {
        self.sink +%= @intCast(s.len);
    }
    fn flag(self: *Bench, b: bool) void {
        self.sink +%= @intFromBool(b);
    }
    fn num(self: *Bench, n: i64) void {
        self.sink +%= n;
    }
    fn fnum(self: *Bench, x: f64) void {
        self.sink +%= @intFromFloat(x);
    }
    fn map(self: *Bench, m: Summary) void {
        self.sink +%= @intCast(m.count());
    }
};
fn doTheWork(a: std.mem.Allocator) !void {
    var b = Bench{};

    // User service.
    const user = try UserService.createUser(a, "John Doe", "john@example.com", 30);
    const updatedUser = UserService.updateUserWithValidation(user, "newemail@test.com", 31);
    b.note(try UserService.processUserData(a, updatedUser));
    b.note(UserService.configureUserPreferences(user).name);
    b.note(try UserService.validateAndFormatUser(a, user));
    b.map(try UserService.getUserSummary(a, user));

    // Product service.
    const product = try ProductService.createProduct(a, "Laptop", 999.99, "Electronics");
    const updatedProduct = try ProductService.updateProductPrice(a, product, 899.99);
    b.flag(updatedProduct != null);
    const saleProduct = try ProductService.configureProductForSale(a, product, 15.0);
    b.num(@intCast(saleProduct.tags.items.len));
    b.map(try ProductService.analyzeProduct(a, product));

    var products: std.ArrayList(*Product) = .empty;
    try products.append(a, try ProductService.createProduct(a, "Mouse", 29.99, "Electronics"));
    try products.append(a, try ProductService.createProduct(a, "Keyboard", 79.99, "Electronics"));
    try products.append(a, try ProductService.createProduct(a, "Monitor", 299.99, "Electronics"));
    const processedProducts = try ProductService.processProductBatch(a, products.items);
    b.num(@intCast(processedProducts.len));

    // Shopping cart (Kotlin `.let { }` chain -> explicit re-binding).
    const cart = try ShoppingCartService.createCart(a, "USER_123");
    _ = try ShoppingCartService.addItemToCart(a, cart, "PROD_1", 2, 29.99);
    _ = try ShoppingCartService.addItemToCart(a, cart, "PROD_2", 1, 79.99);
    _ = try ShoppingCartService.addItemToCart(a, cart, "PROD_3", 1, 299.99);
    b.flag(ShoppingCartService.applyDiscount(cart, "SAVE10") != null);
    b.map(try ShoppingCartService.calculateCartSummary(a, cart));
    const address = try a.create(Address);
    address.* = .{ .street = "123 Main St", .city = "New York", .state = "NY", .zipCode = "10001", .country = "USA" };
    b.flag((try ShoppingCartService.processCartCheckout(a, cart, address, "credit_card")) != null);

    // Banking (Kotlin `?.let` chaining -> explicit optional unwraps).
    const checking = try BankingService.createAccount(a, "CHK001", "checking");
    const savings = try BankingService.createAccount(a, "SAV001", "savings");
    const afterDeposit = BankingService.processTransaction(checking, 1000.0, "deposit");
    const afterWithdrawal = if (afterDeposit) |acc| BankingService.processTransaction(acc, 250.0, "withdrawal") else null;
    if (afterWithdrawal) |acc| b.map(try BankingService.generateAccountStatement(a, acc));
    const transfer = BankingService.transferFunds(checking, savings, 500.0);
    b.flag(transfer.first != null);

    // API service.
    var successResponse = try ApiService.createApiResponse(a, "Success data", 200, null);
    var errorResponse = try ApiService.createApiResponse(a, null, 404, "Not found");
    b.flag(ApiService.processApiResponse(&successResponse) != null);
    b.flag(ApiService.processApiResponse(&errorResponse) != null);
    b.note(try ApiService.handleApiError(a, &errorResponse));
    b.flag((try ApiService.retryApiCall(a, 3, &okApiCall)) != null);

    // Configuration service.
    const dbConfig = try ConfigurationService.createDatabaseConfig(a, "localhost", 5432, "myapp_db");
    b.note(dbConfig.host);
    const appConfig = try ConfigurationService.createAppConfig(a, "MyApp", "1.0.0", "production");
    b.map(try ConfigurationService.validateConfiguration(a, appConfig));
    const updates = [_][2][]const u8{ .{ "log_level", "INFO" }, .{ "cache_ttl", "7200" } };
    const updatedConfig = try ConfigurationService.updateConfiguration(a, appConfig, &updates);
    b.num(@intCast(updatedConfig.settings.count()));

    // Complex chains (Kotlin map/filter/also pipelines -> plain loops).
    var userChain: i64 = 0;
    const chainUsers = [_]struct { id: []const u8, name: []const u8, email: []const u8, age: i64 }{
        .{ .id = "1", .name = "Alice", .email = "alice@test.com", .age = 25 },
        .{ .id = "2", .name = "Bob", .email = "bob@example.com", .age = 35 },
        .{ .id = "3", .name = "Charlie", .email = "charlie@company.org", .age = 45 },
    };
    for (chainUsers) |cu| {
        const u = try a.create(User);
        const prefs = try a.create(UserPreferences);
        prefs.* = .{ .theme = "dark", .language = "en", .notifications = true, .newsletter = false };
        u.* = .{ .id = cu.id, .name = cu.name, .email = cu.email, .age = cu.age, .preferences = prefs };
        if (hasAt(u.email)) {
            b.map(try UserService.getUserSummary(a, u));
            userChain += 1;
        }
    }
    b.num(userChain);

    var productChain: i64 = 0;
    var i: i64 = 1;
    while (i <= 10) : (i += 1) {
        const prod = try ProductService.createProduct(a, try std.fmt.allocPrint(a, "Product {d}", .{i}), @as(f64, @floatFromInt(i)) * 10.0, try std.fmt.allocPrint(a, "Category{d}", .{@mod(i, 3)}));
        const repriced = try ProductService.updateProductPrice(a, prod, prod.price * 0.9);
        const kept = if (repriced) |p| takeIf(*Product, p, p.price > 50) else null;
        if (kept) |p| {
            const onSale = try ProductService.configureProductForSale(a, p, 20.0);
            b.map(try ProductService.analyzeProduct(a, onSale));
            productChain += 1;
        }
    }
    b.num(productChain);

    var orderChain: i64 = 0;
    const userIds = [_][]const u8{ "USER_1", "USER_2", "USER_3" };
    for (userIds) |uid| {
        const c = try ShoppingCartService.createCart(a, uid);
        var k: usize = 0;
        while (k < 3 and k < products.items.len) : (k += 1) {
            const p = products.items[k];
            _ = try ShoppingCartService.addItemToCart(a, c, p.id, 1, p.price);
        }
        if (ShoppingCartService.applyDiscount(c, "SAVE15")) |disc| {
            b.map(try ShoppingCartService.calculateCartSummary(a, disc));
            orderChain += 1;
        }
    }
    b.num(orderChain);

    var bankingChain: i64 = 0;
    const specs = [_][2][]const u8{ .{ "ACC001", "checking" }, .{ "ACC002", "savings" }, .{ "ACC003", "business" } };
    for (specs) |spec| {
        const account = try BankingService.createAccount(a, spec[0], spec[1]);
        const deposited = BankingService.processTransaction(account, 1000.0, "deposit");
        const withdrawn = if (deposited) |acc| BankingService.processTransaction(acc, 100.0, "withdrawal") else null;
        if (withdrawn) |acc| {
            b.map(try BankingService.generateAccountStatement(a, acc));
            bankingChain += 1;
        }
    }
    b.num(bankingChain);

    const apiSpecs = [_]struct { status: i64, msg: []const u8 }{
        .{ .status = 200, .msg = "Success" },
        .{ .status = 404, .msg = "Not Found" },
        .{ .status = 500, .msg = "Server Error" },
    };
    for (apiSpecs) |spec| {
        var response = if (spec.status == 200)
            try ApiService.createApiResponse(a, "Data", spec.status, null)
        else
            try ApiService.createApiResponse(a, null, spec.status, spec.msg);
        if (takeIf(*ApiResponseStr, &response, response.statusCode >= 200 and response.statusCode <= 299)) |ok| {
            b.flag(ApiService.processApiResponse(ok) != null);
        } else {
            b.note(try ApiService.handleApiError(a, &response));
        }
    }

    const configSpecs = [_][2][]const u8{ .{ "App1", "development" }, .{ "App2", "staging" }, .{ "App3", "production" } };
    for (configSpecs) |spec| {
        const cfg = try ConfigurationService.createAppConfig(a, spec[0], "1.0.0", spec[1]);
        const validation = try ConfigurationService.validateConfiguration(a, cfg);
        b.flag(std.mem.eql(u8, validation.get("isValid") orelse "false", "true"));
        const upd = [_][2][]const u8{ .{ "log_level", "INFO" }, .{ "timeout", "60000" } };
        _ = try ConfigurationService.updateConfiguration(a, cfg, &upd);
    }

    // Nested scope-function usage -> straight-line locals.
    user.name = try std.fmt.allocPrint(a, "Updated {s}", .{user.name});
    const msg = try UserService.validateAndFormatUser(a, user);
    const isLong = msg.len > 10;
    b.note(if (isLong) "Long validation message" else "Short validation message");

    // Error handling with explicit guards.
    if (takeIf(*User, user, user.age > 0)) |safeUser| {
        const validAddr = if (safeUser.address) |addr| takeIf(*Address, addr, addr.zipCode.len > 0) else null;
        b.note(if (validAddr) |va|
            try std.fmt.allocPrint(a, "User {s} has valid address in {s}", .{ safeUser.name, va.city })
        else
            "User has invalid address");
    } else {
        b.note("Invalid user data");
    }

    // Resource management.
    if (takeIf([]const *Product, products.items, products.items.len > 0)) |valid| {
        for (valid) |p| {
            b.note(if (takeIf(*Product, p, p.inStock)) |av|
                try std.fmt.allocPrint(a, "Processing available product: {s} ({d})", .{ av.name, av.price })
            else
                try std.fmt.allocPrint(a, "Product {s} is out of stock", .{p.name}));
        }
    }

    std.mem.doNotOptimizeAway(b.sink);
}

pub fn runBenchmark() void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    doTheWork(arena.allocator()) catch {};
}

export fn bench_run() void {
    runBenchmark();
}




