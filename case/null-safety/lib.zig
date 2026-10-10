// iOS Size Benchmark - Test Case Implementation
// Generated with Claude AI (https://claude.ai)
//
// Zig port of the "null-safety" case. Zig's optional type `?T` is the direct
// analogue of Kotlin's `T?` / Swift's `T?` / scriptc's `T | null`, so the port
// is close to 1:1 on the null-handling itself: `orelse` is the elvis operator
// (`?:` / `??`); `if (opt) |v| { ... }` is a safe-call / `let` unwrap; chained
// `if (a) |x| if (x.b) |y| ...` is optional chaining (`?.`). The classes become
// plain structs (with namespaced methods, no `self` where stateless, since Zig
// has no classes); the generic `ApiResponse<T>` becomes a comptime
// `fn(comptime T: type) type` factory; nullable maps/sets use the unmanaged
// std containers. A single exported entry (bench_run -> runBenchmark) exercises
// every type and service so nothing is dead-code eliminated.

const std = @import("std");

// --- Data model: nullable fields map directly to `?T` ----------------------

const Address = struct {
    street: ?[]const u8,
    city: ?[]const u8,
    state: ?[]const u8,
    zipCode: ?[]const u8,
    country: ?[]const u8,
};

const NotificationSettings = struct {
    email: ?bool,
    push: ?bool,
    sms: ?bool,
};

const PrivacySettings = struct {
    profileVisibility: ?[]const u8,
    dataSharing: ?bool,
    analytics: ?bool,
};

const UserPreferences = struct {
    theme: ?[]const u8,
    language: ?[]const u8,
    notifications: ?NotificationSettings,
    privacy: ?PrivacySettings,
};

const User = struct {
    id: []const u8,
    name: ?[]const u8,
    email: ?[]const u8,
    phone: ?[]const u8,
    address: ?Address,
    preferences: ?UserPreferences,
};

const ErrorInfo = struct {
    code: ?[]const u8,
    message: ?[]const u8,
    details: ?std.StringHashMapUnmanaged([]const u8),
};

const ResponseMetadata = struct {
    timestamp: ?i64,
    version: ?[]const u8,
    requestId: ?[]const u8,
};

// Generic network response: TS `ApiResponse<T>` -> comptime type factory.
// `error` is a Zig keyword, so the error field is named `err`.
fn ApiResponse(comptime T: type) type {
    return struct {
        data: ?T,
        err: ?ErrorInfo,
        metadata: ?ResponseMetadata,
    };
}

const FeatureFlags = struct {
    newUI: ?bool,
    betaFeatures: ?bool,
    experimentalMode: ?bool,
};

const CacheConfig = struct {
    enabled: ?bool,
    maxSize: ?i64,
    ttl: ?i64,
};

const AnalyticsConfig = struct {
    enabled: ?bool,
    trackingId: ?[]const u8,
    samplingRate: ?f64,
};

const AppConfig = struct {
    apiUrl: ?[]const u8,
    apiKey: ?[]const u8,
    features: ?FeatureFlags,
    cache: ?CacheConfig,
    analytics: ?AnalyticsConfig,
};

// Kotlin's `String.isNotBlank()`.
fn isNotBlank(s: []const u8) bool {
    return std.mem.trim(u8, s, " \t\n\r").len > 0;
}

// Kotlin String.toIntOrNull / toDoubleOrNull: null on blank/non-numeric input.
fn toIntOrNull(s: []const u8) ?i64 {
    const t = std.mem.trim(u8, s, " \t\n\r");
    if (t.len == 0) return null;
    return std.fmt.parseInt(i64, t, 10) catch null;
}

fn toDoubleOrNull(s: []const u8) ?f64 {
    const t = std.mem.trim(u8, s, " \t\n\r");
    if (t.len == 0) return null;
    return std.fmt.parseFloat(f64, t) catch null;
}

// --- UserService: safe calls / elvis chains -------------------------------

const UserService = struct {
    fn getUserDisplayName(user: ?User) []const u8 {
        if (user) |u| if (u.name) |name| if (isNotBlank(name)) return name;
        return "Anonymous User";
    }

    fn getUserContactInfo(a: std.mem.Allocator, user: ?User) ![]const u8 {
        const email: ?[]const u8 = if (user) |u| blk: {
            if (u.email) |e| if (std.mem.indexOfScalar(u8, e, '@') != null) break :blk e;
            break :blk null;
        } else null;
        const phone: ?[]const u8 = if (user) |u| blk: {
            if (u.phone) |p| if (isNotBlank(p)) break :blk p;
            break :blk null;
        } else null;

        if (email) |e| {
            if (phone) |p| return std.fmt.allocPrint(a, "Email: {s}, Phone: {s}", .{ e, p });
            return std.fmt.allocPrint(a, "Email: {s}", .{e});
        }
        if (phone) |p| return std.fmt.allocPrint(a, "Phone: {s}", .{p});
        return "No contact information available";
    }

    fn getUserFullAddress(a: std.mem.Allocator, user: ?User) !?[]const u8 {
        const u = user orelse return null;
        const address = u.address orelse return null;
        var parts: std.ArrayList([]const u8) = .empty;
        if (address.street) |v| try parts.append(a, v);
        if (address.city) |v| try parts.append(a, v);
        if (address.state) |v| try parts.append(a, v);
        if (address.zipCode) |v| try parts.append(a, v);
        if (address.country) |v| try parts.append(a, v);
        if (parts.items.len == 0) return null;
        return try std.mem.join(a, ", ", parts.items);
    }

    fn isUserPreferencesComplete(user: ?User) bool {
        const u = user orelse return false;
        const prefs = u.preferences orelse return false;
        const notifComplete = if (prefs.notifications) |n|
            n.email != null and n.push != null and n.sms != null
        else
            false;
        const privacyComplete = if (prefs.privacy) |p|
            p.profileVisibility != null and p.dataSharing != null and p.analytics != null
        else
            false;
        return prefs.theme != null and prefs.language != null and notifComplete and privacyComplete;
    }

    fn updateUserEmail(user: ?User, newEmail: ?[]const u8) ?User {
        const u = user orelse return null;
        if (newEmail) |e| if (std.mem.indexOfScalar(u8, e, '@') != null) {
            return .{ .id = u.id, .name = u.name, .email = e, .phone = u.phone, .address = u.address, .preferences = u.preferences };
        };
        return null;
    }

    fn mergeUserData(primary: ?User, secondary: ?User) ?User {
        const p = primary orelse return secondary;
        const s = secondary orelse return primary;
        return .{
            .id = p.id,
            .name = p.name orelse s.name,
            .email = p.email orelse s.email,
            .phone = p.phone orelse s.phone,
            .address = p.address orelse s.address,
            .preferences = mergePreferences(p.preferences, s.preferences),
        };
    }

    fn mergePreferences(primary: ?UserPreferences, secondary: ?UserPreferences) ?UserPreferences {
        const p = primary orelse return secondary;
        const s = secondary orelse return primary;
        return .{
            .theme = p.theme orelse s.theme,
            .language = p.language orelse s.language,
            .notifications = mergeNotificationSettings(p.notifications, s.notifications),
            .privacy = mergePrivacySettings(p.privacy, s.privacy),
        };
    }

    fn mergeNotificationSettings(primary: ?NotificationSettings, secondary: ?NotificationSettings) ?NotificationSettings {
        const p = primary orelse return secondary;
        const s = secondary orelse return primary;
        return .{ .email = p.email orelse s.email, .push = p.push orelse s.push, .sms = p.sms orelse s.sms };
    }

    fn mergePrivacySettings(primary: ?PrivacySettings, secondary: ?PrivacySettings) ?PrivacySettings {
        const p = primary orelse return secondary;
        const s = secondary orelse return primary;
        return .{
            .profileVisibility = p.profileVisibility orelse s.profileVisibility,
            .dataSharing = p.dataSharing orelse s.dataSharing,
            .analytics = p.analytics orelse s.analytics,
        };
    }
};

// --- ApiService -----------------------------------------------------------

const ApiService = struct {
    fn handleApiResponse(comptime T: type, response: ?ApiResponse(T)) ?T {
        if (response) |r| if (r.err == null) return r.data;
        return null;
    }

    fn getErrorMessage(a: std.mem.Allocator, comptime T: type, response: ?ApiResponse(T)) ![]const u8 {
        if (response) |r| if (r.err) |e| {
            if (e.message) |m| if (isNotBlank(m)) return m;
            if (e.code) |c| return std.fmt.allocPrint(a, "Error code: {s}", .{c});
        };
        return "Unknown error occurred";
    }

    fn getResponseMetadata(a: std.mem.Allocator, comptime T: type, response: ?ApiResponse(T)) !std.StringHashMapUnmanaged([]const u8) {
        var result: std.StringHashMapUnmanaged([]const u8) = .empty;
        if (response) |r| if (r.metadata) |m| {
            if (m.timestamp) |ts| try result.put(a, "timestamp", try std.fmt.allocPrint(a, "{d}", .{ts}));
            if (m.version) |v| try result.put(a, "version", v);
            if (m.requestId) |id| try result.put(a, "requestId", id);
        };
        return result;
    }

    fn validateApiResponse(comptime T: type, response: ?ApiResponse(T)) bool {
        const r = response orelse return false;
        const metaValid = if (r.metadata) |m|
            (if (m.timestamp) |ts| ts > 0 else false)
        else
            false;
        return r.data != null and r.err == null and metaValid;
    }

    fn processApiErrorDetails(a: std.mem.Allocator, comptime T: type, response: ?ApiResponse(T)) ![][]const u8 {
        var result: std.ArrayList([]const u8) = .empty;
        if (response) |r| if (r.err) |e| if (e.details) |details| {
            var it = details.iterator();
            while (it.next()) |entry| {
                const key = entry.key_ptr.*;
                const value = entry.value_ptr.*;
                if (isNotBlank(key) and isNotBlank(value))
                    try result.append(a, try std.fmt.allocPrint(a, "{s}: {s}", .{ key, value }));
            }
        };
        return result.toOwnedSlice(a);
    }
};

// A heterogeneous config value: TS `string | number | boolean` -> tagged union.
const ConfigValue = union(enum) {
    flag: bool,
    num: f64,
    str: []const u8,
};

const CacheSettings = struct { enabled: bool, maxSize: i64, ttl: i64 };

// --- ConfigService --------------------------------------------------------

const ConfigService = struct {
    fn isConfigValid(config: ?AppConfig) bool {
        const cfg = config orelse return false;
        const apiUrlValid = if (cfg.apiUrl) |u| isNotBlank(u) else false;
        const apiKeyValid = if (cfg.apiKey) |k| isNotBlank(k) else false;
        return apiUrlValid and apiKeyValid and cfg.features != null and cfg.cache != null and cfg.analytics != null;
    }

    fn getApiEndpoint(a: std.mem.Allocator, config: ?AppConfig, path: ?[]const u8) !?[]const u8 {
        const cfg = config orelse return null;
        const baseUrl = cfg.apiUrl orelse return null;
        if (!isNotBlank(baseUrl)) return null;
        if (path) |p| if (isNotBlank(p)) return try std.fmt.allocPrint(a, "{s}/{s}", .{ baseUrl, p });
        return baseUrl;
    }

    fn isFeatureEnabled(config: ?AppConfig, featureName: []const u8) bool {
        const flags = (if (config) |c| c.features else null) orelse return false;
        if (std.mem.eql(u8, featureName, "newUI")) return flags.newUI orelse false;
        if (std.mem.eql(u8, featureName, "betaFeatures")) return flags.betaFeatures orelse false;
        if (std.mem.eql(u8, featureName, "experimentalMode")) return flags.experimentalMode orelse false;
        return false;
    }

    fn getCacheSettings(config: ?AppConfig) CacheSettings {
        const cache = if (config) |c| c.cache else null;
        return .{
            .enabled = if (cache) |ch| ch.enabled orelse false else false,
            .maxSize = if (cache) |ch| ch.maxSize orelse 0 else 0,
            .ttl = if (cache) |ch| ch.ttl orelse 0 else 0,
        };
    }

    fn getAnalyticsConfig(a: std.mem.Allocator, config: ?AppConfig) !std.StringHashMapUnmanaged(ConfigValue) {
        var result: std.StringHashMapUnmanaged(ConfigValue) = .empty;
        const analytics = (if (config) |c| c.analytics else null) orelse return result;
        if (analytics.enabled) |e| try result.put(a, "enabled", .{ .flag = e });
        if (analytics.trackingId) |t| if (isNotBlank(t)) try result.put(a, "trackingId", .{ .str = t });
        if (analytics.samplingRate) |r| if (r > 0.0) try result.put(a, "samplingRate", .{ .num = r });
        return result;
    }
};

// --- DataProcessor --------------------------------------------------------

const DataProcessor = struct {
    fn processUserList(a: std.mem.Allocator, users: ?[]const ?User) ![][]const u8 {
        var result: std.ArrayList([]const u8) = .empty;
        const arr = users orelse return result.toOwnedSlice(a);
        for (arr) |user| if (user) |u| if (u.name) |name| if (isNotBlank(name)) try result.append(a, name);
        return result.toOwnedSlice(a);
    }

    fn getUsersByCity(a: std.mem.Allocator, users: ?[]const ?User, city: ?[]const u8) ![]User {
        var result: std.ArrayList(User) = .empty;
        const arr = users orelse return result.toOwnedSlice(a);
        const c = city orelse return result.toOwnedSlice(a);
        for (arr) |user| if (user) |u| if (u.address) |addr| if (addr.city) |uc| {
            if (std.ascii.eqlIgnoreCase(uc, c)) try result.append(a, u);
        };
        return result.toOwnedSlice(a);
    }

    fn calculateUserStats(a: std.mem.Allocator, users: ?[]const ?User) !std.StringHashMapUnmanaged(i64) {
        var stats: std.StringHashMapUnmanaged(i64) = .empty;
        var total: i64 = 0;
        var withEmail: i64 = 0;
        var withPhone: i64 = 0;
        var withAddress: i64 = 0;
        var withPreferences: i64 = 0;
        if (users) |arr| for (arr) |user| if (user) |u| {
            total += 1;
            if (u.email) |e| if (std.mem.indexOfScalar(u8, e, '@') != null) {
                withEmail += 1;
            };
            if (u.phone) |p| if (isNotBlank(p)) {
                withPhone += 1;
            };
            if (u.address != null) withAddress += 1;
            if (u.preferences != null) withPreferences += 1;
        };
        try stats.put(a, "total", total);
        try stats.put(a, "withEmail", withEmail);
        try stats.put(a, "withPhone", withPhone);
        try stats.put(a, "withAddress", withAddress);
        try stats.put(a, "withPreferences", withPreferences);
        return stats;
    }

    fn extractContactEmails(a: std.mem.Allocator, users: ?[]const ?User) !std.StringHashMapUnmanaged(void) {
        var emails: std.StringHashMapUnmanaged(void) = .empty;
        const arr = users orelse return emails;
        for (arr) |user| if (user) |u| if (u.email) |e| {
            if (std.mem.indexOfScalar(u8, e, '@') != null and isNotBlank(e)) try emails.put(a, e, {});
        };
        return emails;
    }

    fn groupUsersByCountry(a: std.mem.Allocator, users: ?[]const ?User) !std.StringHashMapUnmanaged(std.ArrayList(User)) {
        var result: std.StringHashMapUnmanaged(std.ArrayList(User)) = .empty;
        const arr = users orelse return result;
        for (arr) |user| if (user) |u| {
            const country = blk: {
                if (u.address) |addr| if (addr.country) |c| if (isNotBlank(c)) break :blk c;
                break :blk "Unknown";
            };
            const gop = try result.getOrPut(a, country);
            if (!gop.found_existing) gop.value_ptr.* = .empty;
            try gop.value_ptr.append(a, u);
        };
        return result;
    }
};

// --- StringUtils ----------------------------------------------------------

const StringUtils = struct {
    fn safeSubstring(text: ?[]const u8, start: usize, end: ?usize) ?[]const u8 {
        const t = text orelse return null;
        if (t.len <= start) return null;
        const endIndex = if (end) |e| @min(e, t.len) else t.len;
        if (start < endIndex) return t[start..endIndex];
        return null;
    }

    fn safeStringJoin(a: std.mem.Allocator, strings: ?[]const ?[]const u8, separator: ?[]const u8) !?[]const u8 {
        const arr = strings orelse return null;
        var valid: std.ArrayList([]const u8) = .empty;
        for (arr) |s| if (s) |str| if (isNotBlank(str)) try valid.append(a, str);
        if (valid.items.len == 0) return null;
        return try std.mem.join(a, separator orelse ",", valid.items);
    }

    fn safeStringFormat(template: ?[]const u8, args: []const ?[]const u8) ?[]const u8 {
        const tmpl = template orelse return null;
        if (!isNotBlank(tmpl)) return null;
        // Simplified formatting (matches Kotlin): the args are null-coalesced to
        // "null" and measured, then the template is returned verbatim.
        var total: usize = 0;
        const nullStr: []const u8 = "null";
        for (args) |arg| total += (arg orelse nullStr).len;
        std.mem.doNotOptimizeAway(total);
        return tmpl;
    }

    fn extractNumbers(a: std.mem.Allocator, text: ?[]const u8) ![]i64 {
        var result: std.ArrayList(i64) = .empty;
        const str = text orelse return result.toOwnedSlice(a);
        var i: usize = 0;
        while (i < str.len) {
            if (std.ascii.isDigit(str[i])) {
                const start = i;
                while (i < str.len and std.ascii.isDigit(str[i])) : (i += 1) {}
                if (toIntOrNull(str[start..i])) |n| try result.append(a, n);
            } else i += 1;
        }
        return result.toOwnedSlice(a);
    }

    fn parseKeyValuePairs(a: std.mem.Allocator, text: ?[]const u8, delimiter: ?[]const u8) !std.StringHashMapUnmanaged([]const u8) {
        var result: std.StringHashMapUnmanaged([]const u8) = .empty;
        const str = text orelse return result;
        if (!isNotBlank(str)) return result;
        const delim = delimiter orelse "=";
        var it = std.mem.splitAny(u8, str, "\n;,");
        while (it.next()) |line| {
            const idx = std.mem.indexOf(u8, line, delim) orelse continue;
            const key = std.mem.trim(u8, line[0..idx], " \t\r\n");
            const value = std.mem.trim(u8, line[idx + delim.len ..], " \t\r\n");
            if (isNotBlank(key) and isNotBlank(value)) try result.put(a, key, value);
        }
        return result;
    }
};

// --- Benchmark entry ------------------------------------------------------

const Resp = ApiResponse([]const u8);

fn doTheWork(a: std.mem.Allocator) !void {
    // Create test data with nullable fields.
    const users = [_]?User{
        .{
            .id = "1",
            .name = "John Doe",
            .email = "john@example.com",
            .phone = "+1234567890",
            .address = .{ .street = "123 Main St", .city = "New York", .state = "NY", .zipCode = "10001", .country = "USA" },
            .preferences = .{
                .theme = "dark",
                .language = "en",
                .notifications = .{ .email = true, .push = false, .sms = true },
                .privacy = .{ .profileVisibility = "public", .dataSharing = true, .analytics = false },
            },
        },
        .{ .id = "2", .name = null, .email = null, .phone = null, .address = null, .preferences = null },
        .{
            .id = "3",
            .name = "Jane Smith",
            .email = "jane@test.com",
            .phone = null,
            .address = .{ .street = null, .city = "Los Angeles", .state = null, .zipCode = null, .country = "USA" },
            .preferences = null,
        },
        null,
    };
    const userSlice: []const ?User = &users;

    var detailsMap: std.StringHashMapUnmanaged([]const u8) = .empty;
    try detailsMap.put(a, "reason", "User not found");
    const apiResponses = [_]?Resp{
        .{ .data = "success", .err = null, .metadata = .{ .timestamp = 1234567890, .version = "1.0", .requestId = "req-123" } },
        .{ .data = null, .err = .{ .code = "404", .message = "Not found", .details = detailsMap }, .metadata = null },
        null,
    };

    const configs = [_]?AppConfig{
        .{
            .apiUrl = "https://api.example.com",
            .apiKey = "key123",
            .features = .{ .newUI = true, .betaFeatures = false, .experimentalMode = null },
            .cache = .{ .enabled = true, .maxSize = 1024, .ttl = 3600 },
            .analytics = .{ .enabled = true, .trackingId = "GA-123", .samplingRate = 0.1 },
        },
        .{ .apiUrl = null, .apiKey = null, .features = null, .cache = null, .analytics = null },
        null,
    };

    // User service operations.
    var displayNameLen: usize = 0;
    var contactLen: usize = 0;
    var addressCount: usize = 0;
    var prefsCompleteCount: usize = 0;
    var updatedCount: usize = 0;
    for (userSlice) |user| {
        displayNameLen += UserService.getUserDisplayName(user).len;
        contactLen += (try UserService.getUserContactInfo(a, user)).len;
        if (try UserService.getUserFullAddress(a, user)) |_| addressCount += 1;
        if (UserService.isUserPreferencesComplete(user)) prefsCompleteCount += 1;
        if (UserService.updateUserEmail(user, "newemail@example.com")) |_| updatedCount += 1;
    }

    const mergedUser = UserService.mergeUserData(users[0], users[2]);

    // API service operations.
    var dataCount: usize = 0;
    var errorMsgLen: usize = 0;
    var metadataCount: usize = 0;
    var validCount: usize = 0;
    var errorDetailCount: usize = 0;
    for (apiResponses) |response| {
        if (ApiService.handleApiResponse([]const u8, response)) |_| dataCount += 1;
        errorMsgLen += (try ApiService.getErrorMessage(a, []const u8, response)).len;
        metadataCount += (try ApiService.getResponseMetadata(a, []const u8, response)).count();
        if (ApiService.validateApiResponse([]const u8, response)) validCount += 1;
        errorDetailCount += (try ApiService.processApiErrorDetails(a, []const u8, response)).len;
    }

    // Config service operations.
    var configValidCount: usize = 0;
    var endpointCount: usize = 0;
    var newUICount: usize = 0;
    var betaCount: usize = 0;
    var cacheMaxTotal: i64 = 0;
    var analyticsCount: usize = 0;
    for (configs) |config| {
        if (ConfigService.isConfigValid(config)) configValidCount += 1;
        if (try ConfigService.getApiEndpoint(a, config, "users")) |_| endpointCount += 1;
        if (ConfigService.isFeatureEnabled(config, "newUI")) newUICount += 1;
        if (ConfigService.isFeatureEnabled(config, "betaFeatures")) betaCount += 1;
        cacheMaxTotal += ConfigService.getCacheSettings(config).maxSize;
        analyticsCount += (try ConfigService.getAnalyticsConfig(a, config)).count();
    }

    // Data processing operations.
    const userNames = try DataProcessor.processUserList(a, userSlice);
    const nyUsers = try DataProcessor.getUsersByCity(a, userSlice, "New York");
    var userStats = try DataProcessor.calculateUserStats(a, userSlice);
    var emails = try DataProcessor.extractContactEmails(a, userSlice);
    var usersByCountry = try DataProcessor.groupUsersByCountry(a, userSlice);

    // String utility operations.
    const testStrings = [_]?[]const u8{ "Hello World", null, "", "   ", "Test123" };
    var substringCount: usize = 0;
    var numberCount: usize = 0;
    for (testStrings) |str| {
        if (StringUtils.safeSubstring(str, 2, 8)) |_| substringCount += 1;
        numberCount += (try StringUtils.extractNumbers(a, str)).len;
    }

    const stringList = [_]?[]const u8{ "apple", null, "banana", "", "cherry" };
    const joinedString = try StringUtils.safeStringJoin(a, &stringList, ", ");

    const formatArgs = [_]?[]const u8{ "John", "5" };
    const formatResult = StringUtils.safeStringFormat("Hello %s, you have %d messages", &formatArgs);

    const kvText = "name=John\nemail=john@example.com\nage=30";
    var kvPairs = try StringUtils.parseKeyValuePairs(a, kvText, "=");

    // Complex null-safe operation chains.
    var complexResult: []const u8 = "No email notifications configured";
    const firstUser = if (userSlice.len > 0) userSlice[0] else null;
    if (firstUser) |fu| if (fu.preferences) |prefs| if (prefs.notifications) |notif| {
        if (notif.email) |enabled| if (enabled) {
            if (fu.email) |email| if (std.mem.indexOfScalar(u8, email, '@') != null) {
                complexResult = try std.fmt.allocPrint(a, "Email notifications enabled for {s}", .{email});
            };
        };
    };

    // Safe collection operations.
    var validEmails: std.ArrayList([]const u8) = .empty;
    for (userSlice) |user| if (user) |u| if (u.email) |email| {
        if (std.mem.indexOfScalar(u8, email, '@') != null) try validEmails.append(a, email);
    };

    var addressSummary: std.ArrayList([]const u8) = .empty;
    for (userSlice) |user| if (user) |u| if (u.address) |address| {
        var parts: std.ArrayList([]const u8) = .empty;
        if (address.city) |v| try parts.append(a, v);
        if (address.state) |v| try parts.append(a, v);
        if (address.country) |v| try parts.append(a, v);
        if (parts.items.len > 0) try addressSummary.append(a, try std.mem.join(a, ", ", parts.items));
    };

    // Null-safe error handling patterns.
    var processedConfigs: std.ArrayList(std.StringHashMapUnmanaged([]const u8)) = .empty;
    for (configs) |config| if (config) |cfg| if (ConfigService.isConfigValid(cfg)) {
        var configMap: std.StringHashMapUnmanaged([]const u8) = .empty;
        try configMap.put(a, "apiUrl", cfg.apiUrl orelse "");
        try configMap.put(a, "hasFeatures", if (cfg.features != null) "true" else "false");
        const cacheEnabled = if (cfg.cache) |c| c.enabled orelse false else false;
        try configMap.put(a, "cacheEnabled", if (cacheEnabled) "true" else "false");
        try processedConfigs.append(a, configMap);
    };

    // Safe numeric operations.
    const numericData = [_]?[]const u8{ "123", null, "456.78", "invalid", "789" };
    var validNumbers: std.ArrayList(f64) = .empty;
    for (numericData) |str| if (str) |s| if (toDoubleOrNull(s)) |n| try validNumbers.append(a, n);
    var sum: f64 = 0.0;
    for (validNumbers.items) |n| sum += n;
    const average = if (validNumbers.items.len > 0) sum / @as(f64, @floatFromInt(validNumbers.items.len)) else 0.0;

    // Safe date/time operations simulation.
    const timestamps = [_]?i64{ 1234567890, null, 0, -1, 987654321 };
    var validTimestamps: std.ArrayList(i64) = .empty;
    for (timestamps) |timestamp| if (timestamp) |ts| if (ts > 0) try validTimestamps.append(a, ts);

    // Null-safe resource management patterns.
    const resourcePaths = [_]?[]const u8{ "/path/to/file.txt", null, "", "/another/path" };
    var validPaths: std.ArrayList([]const u8) = .empty;
    for (resourcePaths) |path| if (path) |p| if (isNotBlank(p) and std.mem.startsWith(u8, p, "/")) try validPaths.append(a, p);

    std.mem.doNotOptimizeAway(displayNameLen);
    std.mem.doNotOptimizeAway(contactLen);
    std.mem.doNotOptimizeAway(addressCount);
    std.mem.doNotOptimizeAway(prefsCompleteCount);
    std.mem.doNotOptimizeAway(updatedCount);
    std.mem.doNotOptimizeAway(if (mergedUser) |m| m.id.len else 0);
    std.mem.doNotOptimizeAway(dataCount);
    std.mem.doNotOptimizeAway(errorMsgLen);
    std.mem.doNotOptimizeAway(metadataCount);
    std.mem.doNotOptimizeAway(validCount);
    std.mem.doNotOptimizeAway(errorDetailCount);
    std.mem.doNotOptimizeAway(configValidCount);
    std.mem.doNotOptimizeAway(endpointCount);
    std.mem.doNotOptimizeAway(newUICount);
    std.mem.doNotOptimizeAway(betaCount);
    std.mem.doNotOptimizeAway(cacheMaxTotal);
    std.mem.doNotOptimizeAway(analyticsCount);
    std.mem.doNotOptimizeAway(userNames.len);
    std.mem.doNotOptimizeAway(nyUsers.len);
    std.mem.doNotOptimizeAway(userStats.count());
    std.mem.doNotOptimizeAway(emails.count());
    std.mem.doNotOptimizeAway(usersByCountry.count());
    std.mem.doNotOptimizeAway(substringCount);
    std.mem.doNotOptimizeAway(numberCount);
    std.mem.doNotOptimizeAway(if (joinedString) |j| j.len else 0);
    std.mem.doNotOptimizeAway(if (formatResult) |f| f.len else 0);
    std.mem.doNotOptimizeAway(kvPairs.count());
    std.mem.doNotOptimizeAway(complexResult.len);
    std.mem.doNotOptimizeAway(validEmails.items.len);
    std.mem.doNotOptimizeAway(addressSummary.items.len);
    std.mem.doNotOptimizeAway(processedConfigs.items.len);
    std.mem.doNotOptimizeAway(validNumbers.items.len);
    std.mem.doNotOptimizeAway(sum);
    std.mem.doNotOptimizeAway(average);
    std.mem.doNotOptimizeAway(validTimestamps.items.len);
    std.mem.doNotOptimizeAway(validPaths.items.len);
}

pub fn runBenchmark() void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    doTheWork(arena.allocator()) catch {};
}

export fn bench_run() void {
    runBenchmark();
}
