// iOS Size Benchmark - Test Case Implementation
// Generated with Claude AI (https://claude.ai)
//
// Zig port of the "extension-functions" case. Zig has no extension functions,
// so the idiomatic mapping splits by *who owns the receiver*:
//   - Extensions on foreign/builtin types (String, Int, Double, Long, List, Map)
//     become plain namespaced free functions whose first arg is the receiver
//     (`self`): `String.isValidEmail()` -> `Str.isValidEmail(self)`,
//     `Int.isPrime()` -> `Num.isPrime(self)`, `List<T>.second()` ->
//     `Lst.second(T, self)`. Generic list/functional extensions use comptime
//     `fn(comptime T: type)` monomorphization; the TS lambdas become named /
//     comptime fn-pointer args (Zig has no closures).
//   - Extensions on our *own* data classes (Person, Product, ...) become plain
//     methods on the struct, the honest Zig home for that behavior.
// Strings are []const u8 over an arena allocator; ASCII helpers come from
// std.ascii. A single exported entry (bench_run -> runBenchmark) calls every
// function so nothing is dead-code eliminated.

const std = @import("std");

fn getCurrentTimeMillis() i64 {
    return 1640995200000;
}

// Deterministic xorshift PRNG stand-in for Math.random (no closures / no OS RNG).
var g_seed: u64 = 88172645463325252;
fn randBelow(n: usize) usize {
    if (n == 0) return 0;
    g_seed ^= g_seed << 13;
    g_seed ^= g_seed >> 7;
    g_seed ^= g_seed << 17;
    return @intCast(g_seed % n);
}

// --- Shared string helpers (allocator-first, idiomatic unmanaged style) ---
fn lowerDup(a: std.mem.Allocator, s: []const u8) ![]u8 {
    const out = try a.dupe(u8, s);
    for (out) |*c| c.* = std.ascii.toLower(c.*);
    return out;
}

fn capitalizeFirst(a: std.mem.Allocator, s: []const u8) ![]u8 {
    const out = try a.dupe(u8, s);
    if (out.len > 0) out[0] = std.ascii.toUpper(out[0]);
    return out;
}

fn reverseStr(a: std.mem.Allocator, s: []const u8) ![]u8 {
    const out = try a.alloc(u8, s.len);
    for (s, 0..) |c, i| out[s.len - 1 - i] = c;
    return out;
}

// Kotlin substringAfter: everything after first delimiter, else whole string.
fn substringAfter(s: []const u8, delim: []const u8) []const u8 {
    return if (std.mem.indexOf(u8, s, delim)) |i| s[i + delim.len ..] else s;
}
fn substringAfterLast(s: []const u8, delim: []const u8, missing: []const u8) []const u8 {
    return if (std.mem.lastIndexOf(u8, s, delim)) |i| s[i + delim.len ..] else missing;
}
fn substringBefore(s: []const u8, delim: []const u8) []const u8 {
    return if (std.mem.indexOf(u8, s, delim)) |i| s[0..i] else s;
}
fn substringBeforeLast(s: []const u8, delim: []const u8) []const u8 {
    return if (std.mem.lastIndexOf(u8, s, delim)) |i| s[0..i] else s;
}
fn removePrefix(s: []const u8, prefix: []const u8) []const u8 {
    return if (std.mem.startsWith(u8, s, prefix)) s[prefix.len..] else s;
}

fn averageOf(values: []const f64) f64 {
    if (values.len == 0) return 0.0;
    var total: f64 = 0.0;
    for (values) |v| total += v;
    return total / @as(f64, @floatFromInt(values.len));
}

// Kotlin String.toDoubleOrNull(): null on blank / non-numeric input.
fn toDoubleOrNull(text: []const u8) ?f64 {
    const trimmed = std.mem.trim(u8, text, " \t\n\r");
    if (trimmed.len == 0) return null;
    var start: usize = 0;
    if (trimmed[0] == '-' or trimmed[0] == '+') start = 1;
    if (start >= trimmed.len) return null;
    var seen_dot = false;
    for (trimmed[start..]) |c| {
        if (c == '.') {
            if (seen_dot) return null;
            seen_dot = true;
        } else if (!std.ascii.isDigit(c)) return null;
    }
    return std.fmt.parseFloat(f64, trimmed) catch null;
}

// --- String extensions -> namespaced free functions (`self` first) ---
const Str = struct {
    fn isValidEmail(self: []const u8) bool {
        return std.mem.indexOfScalar(u8, self, '@') != null and
            std.mem.indexOfScalar(u8, self, '.') != null and self.len > 5;
    }

    fn isValidPhone(self: []const u8) bool {
        var count: usize = 0;
        for (self) |c| if (std.ascii.isDigit(c)) {
            count += 1;
        };
        return count >= 10 and count <= 15;
    }

    fn toTitleCase(a: std.mem.Allocator, self: []const u8) ![]u8 {
        var buf: std.ArrayList(u8) = .empty;
        var it = std.mem.splitScalar(u8, self, ' ');
        var first = true;
        while (it.next()) |word| {
            if (!first) try buf.append(a, ' ');
            first = false;
            const lowered = try lowerDup(a, word);
            try buf.appendSlice(a, try capitalizeFirst(a, lowered));
        }
        return buf.toOwnedSlice(a);
    }

    fn toCamelCase(a: std.mem.Allocator, self: []const u8) ![]u8 {
        var buf: std.ArrayList(u8) = .empty;
        var it = std.mem.splitAny(u8, self, " _-");
        var index: usize = 0;
        while (it.next()) |word| {
            if (word.len == 0) continue;
            const lowered = try lowerDup(a, word);
            if (index == 0) {
                try buf.appendSlice(a, lowered);
            } else {
                try buf.appendSlice(a, try capitalizeFirst(a, lowered));
            }
            index += 1;
        }
        return buf.toOwnedSlice(a);
    }

    fn toSnakeCase(a: std.mem.Allocator, self: []const u8) ![]u8 {
        var buf: std.ArrayList(u8) = .empty;
        for (self, 0..) |c, i| {
            if (c == ' ' or c == '-') {
                try buf.append(a, '_');
            } else if (std.ascii.isUpper(c)) {
                // insert '_' between a lower and an upper (camelCase boundary)
                if (i > 0 and std.ascii.isLower(self[i - 1])) try buf.append(a, '_');
                try buf.append(a, std.ascii.toLower(c));
            } else {
                try buf.append(a, std.ascii.toLower(c));
            }
        }
        return buf.toOwnedSlice(a);
    }

    fn truncate(a: std.mem.Allocator, self: []const u8, max_length: usize, suffix: []const u8) ![]const u8 {
        if (self.len <= max_length) return self;
        return std.fmt.allocPrint(a, "{s}{s}", .{ self[0 .. max_length - suffix.len], suffix });
    }

    fn removeWhitespace(a: std.mem.Allocator, self: []const u8) ![]u8 {
        var buf: std.ArrayList(u8) = .empty;
        for (self) |c| if (!std.ascii.isWhitespace(c)) try buf.append(a, c);
        return buf.toOwnedSlice(a);
    }

    fn countWords(self: []const u8) i64 {
        var it = std.mem.tokenizeAny(u8, self, " \t\n\r");
        var n: i64 = 0;
        while (it.next()) |_| n += 1;
        return n;
    }

    fn reverse(a: std.mem.Allocator, self: []const u8) ![]u8 {
        return reverseStr(a, self);
    }

    fn isPalindrome(a: std.mem.Allocator, self: []const u8) !bool {
        const cleaned = try lowerDup(a, try removeWhitespace(a, self));
        const rev = try reverseStr(a, cleaned);
        return std.mem.eql(u8, cleaned, rev);
    }

    fn extractNumbers(a: std.mem.Allocator, self: []const u8) ![]i64 {
        var out: std.ArrayList(i64) = .empty;
        var i: usize = 0;
        while (i < self.len) {
            if (std.ascii.isDigit(self[i])) {
                const start = i;
                while (i < self.len and std.ascii.isDigit(self[i])) i += 1;
                try out.append(a, std.fmt.parseInt(i64, self[start..i], 10) catch 0);
            } else i += 1;
        }
        return out.toOwnedSlice(a);
    }

    // Simplified email scan (token contains '@' and a '.' after it).
    fn extractEmails(a: std.mem.Allocator, self: []const u8) ![][]const u8 {
        var out: std.ArrayList([]const u8) = .empty;
        var it = std.mem.tokenizeAny(u8, self, " \t\n\r");
        while (it.next()) |tok| {
            if (std.mem.indexOfScalar(u8, tok, '@')) |at| {
                if (std.mem.indexOfScalarPos(u8, tok, at, '.') != null) try out.append(a, tok);
            }
        }
        return out.toOwnedSlice(a);
    }

    fn maskEmail(a: std.mem.Allocator, self: []const u8) ![]const u8 {
        if (!isValidEmail(self)) return self;
        const at = std.mem.indexOfScalar(u8, self, '@').?;
        const username = self[0..at];
        const dom = self[at + 1 ..];
        if (username.len <= 2) return std.fmt.allocPrint(a, "**@{s}", .{dom});
        var buf: std.ArrayList(u8) = .empty;
        try buf.appendSlice(a, username[0..2]);
        var k: usize = 2;
        while (k < username.len) : (k += 1) try buf.append(a, '*');
        try buf.print(a, "@{s}", .{dom});
        return buf.toOwnedSlice(a);
    }

    fn wordFrequency(a: std.mem.Allocator, self: []const u8) !std.StringHashMapUnmanaged(i64) {
        var result: std.StringHashMapUnmanaged(i64) = .empty;
        var it = std.mem.splitAny(u8, self, " \t\n\r.,;:!?()[]{}\"'/\\-_");
        while (it.next()) |word| {
            if (word.len == 0) continue;
            const key = try lowerDup(a, word);
            const gop = try result.getOrPut(a, key);
            if (!gop.found_existing) gop.value_ptr.* = 0;
            gop.value_ptr.* += 1;
        }
        return result;
    }

    // --- File/Path string extensions ---
    fn fileExtension(self: []const u8) []const u8 {
        return substringAfterLast(self, ".", "");
    }
    fn fileName(self: []const u8) []const u8 {
        return substringAfterLast(self, "/", self);
    }
    fn filePath(self: []const u8) []const u8 {
        return substringBeforeLast(self, "/");
    }
    fn hasExtIn(a: std.mem.Allocator, self: []const u8, exts: []const []const u8) bool {
        const ext = lowerDup(a, fileExtension(self)) catch return false;
        for (exts) |e| if (std.mem.eql(u8, ext, e)) return true;
        return false;
    }
    fn isImageFile(a: std.mem.Allocator, self: []const u8) bool {
        return hasExtIn(a, self, &.{ "jpg", "jpeg", "png", "gif", "bmp" });
    }
    fn isTextFile(a: std.mem.Allocator, self: []const u8) bool {
        return hasExtIn(a, self, &.{ "txt", "md", "doc", "docx" });
    }
    fn isExecutable(a: std.mem.Allocator, self: []const u8) bool {
        return hasExtIn(a, self, &.{ "exe", "app", "deb", "dmg" });
    }

    // --- URL string extensions ---
    fn isValidUrl(self: []const u8) bool {
        return std.mem.startsWith(u8, self, "http://") or std.mem.startsWith(u8, self, "https://");
    }
    fn domain(self: []const u8) []const u8 {
        if (!isValidUrl(self)) return "";
        return substringBefore(removePrefix(removePrefix(self, "https://"), "http://"), "/");
    }
    fn protocol(self: []const u8) []const u8 {
        if (std.mem.startsWith(u8, self, "https://")) return "HTTPS";
        if (std.mem.startsWith(u8, self, "http://")) return "HTTP";
        return "Unknown";
    }
    fn isSecureUrl(self: []const u8) bool {
        return std.mem.startsWith(u8, self, "https://");
    }

    // --- Validation string extensions ---
    fn isNumeric(self: []const u8) bool {
        return toDoubleOrNull(self) != null;
    }
    fn isAlphabetic(self: []const u8) bool {
        for (self) |c| if (!std.ascii.isAlphabetic(c)) return false;
        return true;
    }
    fn isAlphanumeric(self: []const u8) bool {
        for (self) |c| if (!std.ascii.isAlphanumeric(c)) return false;
        return true;
    }
    fn hasUppercase(self: []const u8) bool {
        for (self) |c| if (std.ascii.isUpper(c)) return true;
        return false;
    }
    fn hasLowercase(self: []const u8) bool {
        for (self) |c| if (std.ascii.isLower(c)) return true;
        return false;
    }
    fn hasDigits(self: []const u8) bool {
        for (self) |c| if (std.ascii.isDigit(c)) return true;
        return false;
    }
    fn hasSpecialChars(self: []const u8) bool {
        for (self) |c| if (!std.ascii.isAlphanumeric(c)) return true;
        return false;
    }
    fn isStrongPassword(self: []const u8) bool {
        return self.len >= 8 and hasUppercase(self) and hasLowercase(self) and
            hasDigits(self) and hasSpecialChars(self);
    }
};

// --- Number (Int/Double/Long) extensions -> namespaced free functions ---
const Num = struct {
    fn isEven(self: i64) bool {
        return @mod(self, 2) == 0;
    }
    fn isOdd(self: i64) bool {
        return @mod(self, 2) != 0;
    }
    fn isPrime(self: i64) bool {
        if (self < 2) return false;
        var i: i64 = 2;
        while (i * i <= self) : (i += 1) if (@mod(self, i) == 0) return false;
        return true;
    }
    fn factorial(self: i64) i64 {
        return if (self <= 1) 1 else self * factorial(self - 1);
    }
    fn toRoman(a: std.mem.Allocator, self: i64) ![]u8 {
        const values = [_]i64{ 1000, 900, 500, 400, 100, 90, 50, 40, 10, 9, 5, 4, 1 };
        const symbols = [_][]const u8{ "M", "CM", "D", "CD", "C", "XC", "L", "XL", "X", "IX", "V", "IV", "I" };
        var num = self;
        var buf: std.ArrayList(u8) = .empty;
        for (values, 0..) |v, i| {
            while (num >= v) : (num -= v) try buf.appendSlice(a, symbols[i]);
        }
        return buf.toOwnedSlice(a);
    }

    // Double extensions
    fn formatCurrency(a: std.mem.Allocator, self: f64, currency: []const u8) ![]u8 {
        const truncated = @trunc(self * 100) / 100.0;
        return std.fmt.allocPrint(a, "${d} {s}", .{ truncated, currency });
    }
    // Faithful to Kotlin: the body is a literal (value never interpolated).
    fn toPercentage(a: std.mem.Allocator, _: f64) ![]u8 {
        return a.dupe(u8, "${((this * 100 * 10).toInt() / 10.0)}%");
    }
    fn round(self: f64, decimals: u6) f64 {
        const factor = std.math.pow(f64, 10.0, @floatFromInt(decimals));
        return @round(self * factor) / factor;
    }

    // Long (timestamp) extensions
    fn toDateString(a: std.mem.Allocator, self: i64) ![]u8 {
        const seconds = @divTrunc(self, 1000);
        const minutes = @divTrunc(seconds, 60);
        const hours = @divTrunc(minutes, 60);
        const days = @divTrunc(hours, 24);
        if (days > 0) return std.fmt.allocPrint(a, "{d} days ago", .{days});
        if (hours > 0) return std.fmt.allocPrint(a, "{d} hours ago", .{hours});
        if (minutes > 0) return std.fmt.allocPrint(a, "{d} minutes ago", .{minutes});
        return std.fmt.allocPrint(a, "{d} seconds ago", .{seconds});
    }
    fn formatDuration(a: std.mem.Allocator, self: i64) ![]u8 {
        const hours = @divTrunc(self, 3600000);
        const minutes = @divTrunc(@mod(self, 3600000), 60000);
        const seconds = @divTrunc(@mod(self, 60000), 1000);
        if (hours > 0) return std.fmt.allocPrint(a, "{d}:{d:0>2}:{d:0>2}", .{ hours, minutes, seconds });
        if (minutes > 0) return std.fmt.allocPrint(a, "{d}:{d:0>2}", .{ minutes, seconds });
        return std.fmt.allocPrint(a, "{d} seconds", .{seconds});
    }
};

// --- Collection (List) extensions -> comptime-generic free functions ---
const Lst = struct {
    fn second(comptime T: type, self: []const T) ?T {
        return if (self.len >= 2) self[1] else null;
    }
    fn third(comptime T: type, self: []const T) ?T {
        return if (self.len >= 3) self[2] else null;
    }
    fn secondToLast(comptime T: type, self: []const T) ?T {
        return if (self.len >= 2) self[self.len - 2] else null;
    }
    fn shuffled(a: std.mem.Allocator, comptime T: type, source: []const T) ![]T {
        const result = try a.dupe(T, source);
        var i = result.len;
        while (i > 1) {
            i -= 1;
            const j = randBelow(i + 1);
            const tmp = result[i];
            result[i] = result[j];
            result[j] = tmp;
        }
        return result;
    }
    fn takeRandom(a: std.mem.Allocator, comptime T: type, self: []const T, count: usize) ![]T {
        const s = try shuffled(a, T, self);
        return s[0..@min(count, s.len)];
    }
    fn split(a: std.mem.Allocator, comptime T: type, self: []const T, predicate: fn (T) bool) !struct { first: []T, second: []T } {
        var first: std.ArrayList(T) = .empty;
        var rest: std.ArrayList(T) = .empty;
        for (self) |it| {
            if (predicate(it)) try first.append(a, it) else try rest.append(a, it);
        }
        return .{ .first = try first.toOwnedSlice(a), .second = try rest.toOwnedSlice(a) };
    }
    fn chunks(a: std.mem.Allocator, comptime T: type, self: []const T, size: usize) ![][]const T {
        var out: std.ArrayList([]const T) = .empty;
        var i: usize = 0;
        while (i < self.len) : (i += size) try out.append(a, self[i..@min(i + size, self.len)]);
        return out.toOwnedSlice(a);
    }
    fn frequencyMap(a: std.mem.Allocator, self: []const []const u8) !std.StringHashMapUnmanaged(i64) {
        var result: std.StringHashMapUnmanaged(i64) = .empty;
        for (self) |it| {
            const gop = try result.getOrPut(a, it);
            if (!gop.found_existing) gop.value_ptr.* = 0;
            gop.value_ptr.* += 1;
        }
        return result;
    }
    fn duplicates(a: std.mem.Allocator, self: []const []const u8) ![][]const u8 {
        var counts = try frequencyMap(a, self);
        var out: std.ArrayList([]const u8) = .empty;
        var it = counts.iterator();
        while (it.next()) |e| if (e.value_ptr.* > 1) try out.append(a, e.key_ptr.*);
        return out.toOwnedSlice(a);
    }
    fn unique(a: std.mem.Allocator, self: []const []const u8) ![][]const u8 {
        var seen: std.StringHashMapUnmanaged(void) = .empty;
        var out: std.ArrayList([]const u8) = .empty;
        for (self) |it| {
            const gop = try seen.getOrPut(a, it);
            if (!gop.found_existing) try out.append(a, it);
        }
        return out.toOwnedSlice(a);
    }
    fn withoutNulls(a: std.mem.Allocator, comptime T: type, self: []const ?T) ![]T {
        var out: std.ArrayList(T) = .empty;
        for (self) |it| if (it) |v| try out.append(a, v);
        return out.toOwnedSlice(a);
    }
    fn rotateLeft(a: std.mem.Allocator, comptime T: type, self: []const T, positions: usize) ![]T {
        if (self.len == 0) return a.dupe(T, self);
        const pos = positions % self.len;
        var out: std.ArrayList(T) = .empty;
        try out.appendSlice(a, self[pos..]);
        try out.appendSlice(a, self[0..pos]);
        return out.toOwnedSlice(a);
    }
    fn rotateRight(a: std.mem.Allocator, comptime T: type, self: []const T, positions: usize) ![]T {
        if (self.len == 0) return a.dupe(T, self);
        const pos = positions % self.len;
        var out: std.ArrayList(T) = .empty;
        try out.appendSlice(a, self[self.len - pos ..]);
        try out.appendSlice(a, self[0 .. self.len - pos]);
        return out.toOwnedSlice(a);
    }
};

// --- Map extensions -> namespaced free functions over StringHashMap(i64) ---
const MapExt = struct {
    const SMap = std.StringHashMapUnmanaged(i64);
    fn filterByKeys(a: std.mem.Allocator, self: SMap, predicate: fn ([]const u8) bool) !SMap {
        var result: SMap = .empty;
        var it = self.iterator();
        while (it.next()) |e| if (predicate(e.key_ptr.*)) try result.put(a, e.key_ptr.*, e.value_ptr.*);
        return result;
    }
    fn filterByValues(a: std.mem.Allocator, self: SMap, predicate: fn (i64) bool) !SMap {
        var result: SMap = .empty;
        var it = self.iterator();
        while (it.next()) |e| if (predicate(e.value_ptr.*)) try result.put(a, e.key_ptr.*, e.value_ptr.*);
        return result;
    }
    fn swap(a: std.mem.Allocator, self: SMap) !std.AutoHashMapUnmanaged(i64, []const u8) {
        var result: std.AutoHashMapUnmanaged(i64, []const u8) = .empty;
        var it = self.iterator();
        while (it.next()) |e| try result.put(a, e.value_ptr.*, e.key_ptr.*);
        return result;
    }
    fn getOrDefault(self: SMap, key: []const u8, default_value: i64) i64 {
        return self.get(key) orelse default_value;
    }
};

// --- Functional generic extensions (comptime T, fn-pointer "lambdas") ---
fn applyIf(comptime T: type, self: T, condition: bool, transform: fn (T) T) T {
    return if (condition) transform(self) else self;
}
fn takeIfFn(comptime T: type, self: T, predicate: fn (T) bool) ?T {
    return if (predicate(self)) self else null;
}
fn takeUnlessFn(comptime T: type, self: T, predicate: fn (T) bool) ?T {
    return if (!predicate(self)) self else null;
}

// --- Our own data classes: extensions become plain methods ---
const Person = struct {
    id: []const u8,
    name: []const u8,
    email: []const u8,
    age: i64,

    fn isAdult(self: Person) bool {
        return self.age >= 18;
    }
    fn isMinor(self: Person) bool {
        return self.age < 18;
    }
    fn ageGroup(self: Person) []const u8 {
        if (self.age < 13) return "Child";
        if (self.age < 20) return "Teenager";
        if (self.age < 30) return "Young Adult";
        if (self.age < 60) return "Adult";
        return "Senior";
    }
    fn emailDomain(self: Person) []const u8 {
        return substringAfter(self.email, "@");
    }
    fn initials(self: Person, a: std.mem.Allocator) ![]u8 {
        var buf: std.ArrayList(u8) = .empty;
        var it = std.mem.splitScalar(u8, self.name, ' ');
        while (it.next()) |word| if (word.len > 0) try buf.append(a, word[0]);
        return buf.toOwnedSlice(a);
    }
    fn displayName(self: Person, a: std.mem.Allocator) ![]u8 {
        return std.fmt.allocPrint(a, "{s} ({d})", .{ self.name, self.age });
    }
};

const Product = struct {
    id: []const u8,
    name: []const u8,
    price: f64,
    category: []const u8,
    inStock: bool,

    fn copyPrice(self: Product, price: f64) Product {
        return .{ .id = self.id, .name = self.name, .price = price, .category = self.category, .inStock = self.inStock };
    }
    fn isExpensive(self: Product) bool {
        return self.price > 100.0;
    }
    fn isCheap(self: Product) bool {
        return self.price < 20.0;
    }
    fn isAvailable(self: Product) bool {
        return self.inStock;
    }
    fn priceRange(self: Product) []const u8 {
        if (self.price < 20) return "Budget";
        if (self.price < 50) return "Mid-range";
        if (self.price < 100) return "Premium";
        return "Luxury";
    }
    fn discountedPrice(self: Product, discount: f64) f64 {
        return self.price * (1 - discount);
    }
    fn withDiscount(self: Product, discount: f64) Product {
        return self.copyPrice(self.discountedPrice(discount));
    }
    fn categoryPrefix(self: Product, a: std.mem.Allocator) ![]u8 {
        const n = @min(3, self.category.len);
        const out = try a.dupe(u8, self.category[0..n]);
        for (out) |*c| c.* = std.ascii.toUpper(c.*);
        return out;
    }
};

const Order = struct {
    id: []const u8,
    items: []const Product,
    customerEmail: []const u8,
    timestamp: i64,

    fn totalAmount(self: Order) f64 {
        var total: f64 = 0.0;
        for (self.items) |it| total += it.price;
        return total;
    }
    fn itemCount(self: Order) i64 {
        return @intCast(self.items.len);
    }
    fn hasExpensiveItems(self: Order) bool {
        for (self.items) |it| if (it.isExpensive()) return true;
        return false;
    }
    fn categorySummary(self: Order, a: std.mem.Allocator) !std.StringHashMapUnmanaged(i64) {
        var result: std.StringHashMapUnmanaged(i64) = .empty;
        for (self.items) |it| {
            const gop = try result.getOrPut(a, it.category);
            if (!gop.found_existing) gop.value_ptr.* = 0;
            gop.value_ptr.* += 1;
        }
        return result;
    }
    fn averageItemPrice(self: Order, a: std.mem.Allocator) !f64 {
        if (self.items.len == 0) return 0.0;
        var prices: std.ArrayList(f64) = .empty;
        for (self.items) |it| try prices.append(a, it.price);
        return averageOf(prices.items);
    }
    fn customerDomain(self: Order) []const u8 {
        return substringAfter(self.customerEmail, "@");
    }
    fn isRecent(self: Order) bool {
        return getCurrentTimeMillis() - self.timestamp < 86400000;
    }
    fn ageInHours(self: Order) i64 {
        return @divTrunc(getCurrentTimeMillis() - self.timestamp, 3600000);
    }
};

const BankAccount = struct {
    accountNumber: []const u8,
    balance: f64,
    currency: []const u8,
    type: []const u8,

    fn copyBalance(self: BankAccount, balance: f64) BankAccount {
        return .{ .accountNumber = self.accountNumber, .balance = balance, .currency = self.currency, .type = self.type };
    }
    fn isOverdrawn(self: BankAccount) bool {
        return self.balance < 0;
    }
    fn hasPositiveBalance(self: BankAccount) bool {
        return self.balance > 0;
    }
    fn balanceFormatted(self: BankAccount, a: std.mem.Allocator) ![]u8 {
        return Num.formatCurrency(a, self.balance, self.currency);
    }
    fn accountType(self: BankAccount, a: std.mem.Allocator) ![]u8 {
        return capitalizeFirst(a, self.type);
    }
    fn canWithdraw(self: BankAccount, amount: f64) bool {
        return self.balance >= amount;
    }
    fn withdraw(self: BankAccount, amount: f64) BankAccount {
        return self.copyBalance(self.balance - amount);
    }
    fn deposit(self: BankAccount, amount: f64) BankAccount {
        return self.copyBalance(self.balance + amount);
    }
    fn transfer(self: BankAccount, amount: f64, target: BankAccount) struct { from: BankAccount, to: BankAccount } {
        if (self.canWithdraw(amount))
            return .{ .from = self.withdraw(amount), .to = target.deposit(amount) };
        return .{ .from = self, .to = target };
    }
};

const Transaction = struct {
    id: []const u8,
    amount: f64,
    type: []const u8,
    timestamp: i64,
    description: []const u8,

    fn isDebit(self: Transaction) bool {
        return self.amount < 0;
    }
    fn isCredit(self: Transaction) bool {
        return self.amount > 0;
    }
    fn amountFormatted(self: Transaction, a: std.mem.Allocator) ![]u8 {
        return Num.formatCurrency(a, self.amount, "USD");
    }
    fn typeCapitalized(self: Transaction, a: std.mem.Allocator) ![]u8 {
        return capitalizeFirst(a, self.type);
    }
    fn isToday(self: Transaction) bool {
        return getCurrentTimeMillis() - self.timestamp < 86400000;
    }
    fn daysAgo(self: Transaction) i64 {
        return @divTrunc(getCurrentTimeMillis() - self.timestamp, 86400000);
    }
    fn category(self: Transaction, a: std.mem.Allocator) ![]const u8 {
        const desc = try lowerDup(a, self.description);
        if (std.mem.indexOf(u8, desc, "grocery") != null) return "Groceries";
        if (std.mem.indexOf(u8, desc, "gas") != null) return "Transportation";
        if (std.mem.indexOf(u8, desc, "restaurant") != null) return "Dining";
        if (std.mem.indexOf(u8, desc, "salary") != null) return "Income";
        return "Other";
    }
};

const AppConfig = struct {
    apiUrl: []const u8,
    timeout: i64,
    retries: i64,
    debug: bool,

    fn isProduction(self: AppConfig) bool {
        return !self.debug;
    }
    fn isDevelopment(self: AppConfig) bool {
        return self.debug;
    }
    fn timeoutInSeconds(self: AppConfig) i64 {
        return @divTrunc(self.timeout, 1000);
    }
    fn hasRetries(self: AppConfig) bool {
        return self.retries > 0;
    }
    fn maxRetries(self: AppConfig) i64 {
        return @max(self.retries, 1);
    }
};

const Player = struct {
    id: []const u8,
    name: []const u8,
    level: i64,
    experience: i64,
    achievements: []const []const u8,

    fn isMaxLevel(self: Player) bool {
        return self.level >= 100;
    }
    fn experienceToNextLevel(self: Player) i64 {
        return (self.level + 1) * 1000 - self.experience;
    }
    fn progressToNextLevel(self: Player) f64 {
        return @as(f64, @floatFromInt(self.experience)) / @as(f64, @floatFromInt((self.level + 1) * 1000));
    }
    fn hasAchievement(self: Player, achievement: []const u8) bool {
        for (self.achievements) |ac| if (std.mem.eql(u8, ac, achievement)) return true;
        return false;
    }
    fn achievementCount(self: Player) i64 {
        return @intCast(self.achievements.len);
    }
    fn isVeteran(self: Player) bool {
        return self.hasAchievement("veteran");
    }
    fn displayLevel(self: Player, a: std.mem.Allocator) ![]u8 {
        return std.fmt.allocPrint(a, "Level {d}", .{self.level});
    }
    fn rankTitle(self: Player) []const u8 {
        if (self.level < 10) return "Novice";
        if (self.level < 25) return "Apprentice";
        if (self.level < 50) return "Expert";
        if (self.level < 75) return "Master";
        return "Grandmaster";
    }
};

// Generic network/API response -> comptime factory.
fn ApiResponse(comptime T: type) type {
    return struct {
        data: ?T,
        status: i64,
        message: []const u8,
        const Self = @This();
        fn isSuccess(self: Self) bool {
            return self.status >= 200 and self.status <= 299;
        }
        fn isError(self: Self) bool {
            return self.status >= 400;
        }
        fn isClientError(self: Self) bool {
            return self.status >= 400 and self.status <= 499;
        }
        fn isServerError(self: Self) bool {
            return self.status >= 500 and self.status <= 599;
        }
        fn hasData(self: Self) bool {
            return self.data != null;
        }
    };
}

// Named functions standing in for the TS lambdas (Zig has no closures).
fn wordLenLe5(s: []const u8) bool {
    return s.len <= 5;
}
fn valueGt85(v: i64) bool {
    return v > 85;
}
fn keyLenGt3(s: []const u8) bool {
    return s.len > 3;
}
fn personIsAdultP(p: Person) bool {
    return p.isAdult();
}
fn identityPerson(p: Person) Person {
    return p;
}

fn doTheWork(a: std.mem.Allocator) !void {
    var sink: i64 = 0;

    // --- String extensions ---
    const emails = [_][]const u8{
        "john.doe@example.com", "invalid-email", "jane.smith@test.org",
        "not-an-email-at-all",  "admin@company.co.uk",
    };
    for (emails) |e| if (Str.isValidEmail(e)) {
        sink += @intCast((try Str.maskEmail(a, e)).len);
    };

    const phones = [_][]const u8{ "+1-555-123-4567", "555.123.4567", "(555) 123-4567", "5551234567", "invalid-phone" };
    for (phones) |p| sink += @intFromBool(Str.isValidPhone(p));

    const texts = [_][]const u8{
        "hello world programming",
        "the quick brown fox jumps over the lazy dog",
        "a man a plan a canal panama",
        "racecar level madam",
        "this is a sample text with numbers 123 and 456",
    };
    for (texts) |text| {
        sink += @intCast((try Str.toTitleCase(a, text)).len);
        sink += @intCast((try Str.toCamelCase(a, text)).len);
        sink += @intCast((try Str.toSnakeCase(a, text)).len);
        sink += @intCast((try Str.truncate(a, text, 20, "...")).len);
        sink += Str.countWords(text);
        sink += @intFromBool(try Str.isPalindrome(a, text));
        sink += @intCast((try Str.extractNumbers(a, text)).len);
        var freq = try Str.wordFrequency(a, text);
        sink += @intCast(freq.count());
    }

    // --- Number extensions ---
    const numbers = [_]i64{ 2, 3, 4, 5, 7, 8, 10, 11, 13, 17, 25, 30 };
    for (numbers) |num| {
        sink += @intFromBool(Num.isEven(num));
        sink += @intFromBool(Num.isOdd(num));
        sink += @intFromBool(Num.isPrime(num));
        if (num <= 10) sink += @intCast(@mod(Num.factorial(num), 7));
        if (num <= 50) sink += @intCast((try Num.toRoman(a, num)).len);
    }

    const prices = [_]f64{ 19.99, 45.5, 123.75, 999.99, 0.5 };
    for (prices) |price| {
        sink += @intCast((try Num.formatCurrency(a, price, "USD")).len);
        sink += @intCast((try Num.toPercentage(a, price / 1000)).len);
        sink += @intFromFloat(Num.round(price, 1));
    }

    // --- Collection extensions ---
    const wordList = [_][]const u8{ "apple", "banana", "cherry", "date", "elderberry", "fig", "grape" };
    sink += @intCast((Lst.second([]const u8, &wordList) orelse @as([]const u8, "")).len);
    sink += @intCast((Lst.third([]const u8, &wordList) orelse @as([]const u8, "")).len);
    sink += @intCast((Lst.secondToLast([]const u8, &wordList) orelse @as([]const u8, "")).len);
    sink += @intCast((try Lst.takeRandom(a, []const u8, &wordList, 3)).len);
    const parts = try Lst.split(a, []const u8, &wordList, wordLenLe5);
    sink += @intCast(parts.first.len + parts.second.len);
    sink += @intCast((try Lst.chunks(a, []const u8, &wordList, 3)).len);
    var wlFreq = try Lst.frequencyMap(a, &wordList);
    sink += @intCast(wlFreq.count());
    sink += @intCast((try Lst.rotateLeft(a, []const u8, &wordList, 2)).len);
    sink += @intCast((try Lst.rotateRight(a, []const u8, &wordList, 2)).len);

    const duplicateList = [_][]const u8{ "a", "b", "c", "a", "b", "d", "e", "a" };
    sink += @intCast((try Lst.duplicates(a, &duplicateList)).len);
    sink += @intCast((try Lst.unique(a, &duplicateList)).len);

    // --- Map extensions ---
    var scoreMap: std.StringHashMapUnmanaged(i64) = .empty;
    try scoreMap.put(a, "Alice", 95);
    try scoreMap.put(a, "Bob", 87);
    try scoreMap.put(a, "Charlie", 92);
    try scoreMap.put(a, "David", 78);
    try scoreMap.put(a, "Eve", 89);
    var highScores = try MapExt.filterByValues(a, scoreMap, valueGt85);
    sink += @intCast(highScores.count());
    var highKeys = try MapExt.filterByKeys(a, scoreMap, keyLenGt3);
    sink += @intCast(highKeys.count());
    var swapped = try MapExt.swap(a, scoreMap);
    sink += @intCast(swapped.count());
    sink += MapExt.getOrDefault(scoreMap, "Unknown", 0);

    // --- Time extensions ---
    const timestamps = [_]i64{
        getCurrentTimeMillis() - 3600000,
        getCurrentTimeMillis() - 86400000,
        getCurrentTimeMillis() - 604800000,
    };
    for (timestamps) |ts| {
        sink += @intCast((try Num.toDateString(a, ts)).len);
        sink += @intCast((try Num.formatDuration(a, getCurrentTimeMillis() - ts)).len);
    }

    // --- Person ---
    const persons = [_]Person{
        .{ .id = "1", .name = "John Doe", .email = "john@example.com", .age = 25 },
        .{ .id = "2", .name = "Jane Smith", .email = "jane@test.com", .age = 17 },
        .{ .id = "3", .name = "Bob Johnson", .email = "bob@company.org", .age = 45 },
        .{ .id = "4", .name = "Alice Brown", .email = "alice@email.net", .age = 35 },
    };
    for (persons) |person| {
        sink += @intFromBool(person.isAdult());
        sink += @intFromBool(person.isMinor());
        sink += @intCast(person.ageGroup().len);
        sink += @intCast(person.emailDomain().len);
        sink += @intCast((try person.initials(a)).len);
        sink += @intCast((try person.displayName(a)).len);
    }

    // --- Product ---
    const products = [_]Product{
        .{ .id = "1", .name = "Laptop", .price = 899.99, .category = "Electronics", .inStock = true },
        .{ .id = "2", .name = "Coffee Mug", .price = 12.5, .category = "Kitchen", .inStock = true },
        .{ .id = "3", .name = "Designer Watch", .price = 1299.99, .category = "Accessories", .inStock = false },
        .{ .id = "4", .name = "Book", .price = 15.99, .category = "Books", .inStock = true },
        .{ .id = "5", .name = "Smartphone", .price = 699.99, .category = "Electronics", .inStock = true },
    };
    for (products) |product| {
        sink += @intFromBool(product.isExpensive());
        sink += @intFromBool(product.isCheap());
        sink += @intFromBool(product.isAvailable());
        sink += @intCast(product.priceRange().len);
        const disc = product.withDiscount(0.1);
        sink += @intFromFloat(disc.discountedPrice(0.0));
        sink += @intCast((try product.categoryPrefix(a)).len);
    }

    // --- Order ---
    const orders = [_]Order{
        .{ .id = "1", .items = products[0..2], .customerEmail = "customer1@email.com", .timestamp = getCurrentTimeMillis() - 3600000 },
        .{ .id = "2", .items = products[2..4], .customerEmail = "customer2@test.com", .timestamp = getCurrentTimeMillis() - 86400000 },
        .{ .id = "3", .items = products[4..5], .customerEmail = "customer3@company.org", .timestamp = getCurrentTimeMillis() - 7200000 },
    };
    for (orders) |order| {
        sink += @intFromFloat(order.totalAmount());
        sink += order.itemCount();
        sink += @intFromBool(order.hasExpensiveItems());
        var cats = try order.categorySummary(a);
        sink += @intCast(cats.count());
        sink += @intFromFloat(try order.averageItemPrice(a));
        sink += @intCast(order.customerDomain().len);
        sink += @intFromBool(order.isRecent());
        sink += @divTrunc(order.ageInHours(), 1000000);
    }

    // --- BankAccount ---
    const accounts = [_]BankAccount{
        .{ .accountNumber = "12345", .balance = 1500.5, .currency = "USD", .type = "checking" },
        .{ .accountNumber = "67890", .balance = -200.0, .currency = "USD", .type = "checking" },
        .{ .accountNumber = "11111", .balance = 5000.0, .currency = "EUR", .type = "savings" },
        .{ .accountNumber = "22222", .balance = 0.0, .currency = "USD", .type = "savings" },
    };
    for (accounts) |account| {
        sink += @intFromBool(account.isOverdrawn());
        sink += @intFromBool(account.hasPositiveBalance());
        sink += @intCast((try account.balanceFormatted(a)).len);
        sink += @intCast((try account.accountType(a)).len);
        sink += @intFromBool(account.canWithdraw(100.0));
    }
    const xfer = accounts[0].transfer(100.0, accounts[2]);
    sink += @intFromFloat(xfer.from.balance + xfer.to.balance);

    // --- Transaction ---
    const transactions = [_]Transaction{
        .{ .id = "1", .amount = -50.0, .type = "debit", .timestamp = getCurrentTimeMillis(), .description = "Grocery Store" },
        .{ .id = "2", .amount = 2500.0, .type = "credit", .timestamp = getCurrentTimeMillis() - 86400000, .description = "Salary Payment" },
        .{ .id = "3", .amount = -75.5, .type = "debit", .timestamp = getCurrentTimeMillis() - 3600000, .description = "Gas Station" },
        .{ .id = "4", .amount = -120.0, .type = "debit", .timestamp = getCurrentTimeMillis() - 7200000, .description = "Restaurant Dinner" },
    };
    for (transactions) |txn| {
        sink += @intFromBool(txn.isDebit());
        sink += @intFromBool(txn.isCredit());
        sink += @intCast((try txn.amountFormatted(a)).len);
        sink += @intCast((try txn.typeCapitalized(a)).len);
        sink += @intFromBool(txn.isToday());
        sink += @divTrunc(txn.daysAgo(), 1000000);
        sink += @intCast((try txn.category(a)).len);
    }

    // --- File/Path + URL + validation string extensions ---
    const filePaths = [_][]const u8{
        "/home/user/documents/report.pdf", "/var/log/system.log",
        "/usr/bin/application.exe",         "/home/photos/vacation.jpg",
        "/downloads/music.mp3",
    };
    for (filePaths) |path| {
        sink += @intCast(Str.fileExtension(path).len);
        sink += @intCast(Str.fileName(path).len);
        sink += @intCast(Str.filePath(path).len);
        sink += @intFromBool(Str.isImageFile(a, path));
        sink += @intFromBool(Str.isTextFile(a, path));
        sink += @intFromBool(Str.isExecutable(a, path));
    }

    const urls = [_][]const u8{
        "https://www.example.com/page", "http://api.service.org/data",
        "https://secure.bank.com/login", "ftp://files.domain.net/download", "invalid-url",
    };
    for (urls) |url| {
        sink += @intFromBool(Str.isValidUrl(url));
        sink += @intCast(Str.domain(url).len);
        sink += @intCast(Str.protocol(url).len);
        sink += @intFromBool(Str.isSecureUrl(url));
    }

    const passwords = [_][]const u8{ "Password123!", "weakpass", "ONLYUPPER", "onlylower", "12345678", "Strong1Pass!" };
    for (passwords) |pw| {
        sink += @intFromBool(Str.isStrongPassword(pw));
        sink += @intFromBool(Str.hasUppercase(pw));
        sink += @intFromBool(Str.hasLowercase(pw));
        sink += @intFromBool(Str.hasDigits(pw));
        sink += @intFromBool(Str.hasSpecialChars(pw));
    }

    // --- ApiResponse (generic) ---
    const Resp = ApiResponse([]const u8);
    const apiResponses = [_]Resp{
        .{ .data = "Success data", .status = 200, .message = "OK" },
        .{ .data = null, .status = 404, .message = "Not Found" },
        .{ .data = "Server data", .status = 500, .message = "Internal Server Error" },
        .{ .data = "Created", .status = 201, .message = "Created" },
    };
    for (apiResponses) |resp| {
        sink += @intFromBool(resp.isSuccess());
        sink += @intFromBool(resp.isError());
        sink += @intFromBool(resp.isClientError());
        sink += @intFromBool(resp.isServerError());
        sink += @intFromBool(resp.hasData());
    }

    // --- Player ---
    const players = [_]Player{
        .{ .id = "1", .name = "ProGamer", .level = 95, .experience = 94500, .achievements = &.{ "veteran", "champion", "speedrun" } },
        .{ .id = "2", .name = "Newbie", .level = 5, .experience = 4200, .achievements = &.{"first_login"} },
        .{ .id = "3", .name = "Expert", .level = 45, .experience = 44800, .achievements = &.{ "veteran", "collector", "explorer" } },
        .{ .id = "4", .name = "Master", .level = 78, .experience = 77100, .achievements = &.{ "veteran", "champion", "mentor" } },
    };
    for (players) |player| {
        sink += @intFromBool(player.isMaxLevel());
        sink += player.experienceToNextLevel();
        sink += @intFromFloat(player.progressToNextLevel() * 100);
        sink += @intFromBool(player.isVeteran());
        sink += player.achievementCount();
        sink += @intCast(player.rankTitle().len);
        sink += @intCast((try player.displayLevel(a)).len);
    }

    // --- Remaining declared extensions (functional, config, extractors) ---
    sink += @intCast((try Str.extractEmails(a, "contact john@a.com or jane@b.org now")).len);
    sink += @intCast((try Str.reverse(a, "extension")).len);
    sink += @intFromBool(Str.isNumeric("123.45"));
    sink += @intFromBool(Str.isAlphabetic("Hello"));
    sink += @intFromBool(Str.isAlphanumeric("Hello123"));

    const nullableWords = [_]?[]const u8{ "a", null, "b", null, "c" };
    sink += @intCast((try Lst.withoutNulls(a, []const u8, &nullableWords)).len);

    const applied = applyIf(Person, persons[0], true, identityPerson);
    sink += @intCast(applied.name.len);
    const taken = takeIfFn(Person, persons[0], personIsAdultP);
    sink += @intCast((if (taken) |t| t.name else @as([]const u8, "null")).len);
    const unless = takeUnlessFn(Person, persons[1], personIsAdultP);
    sink += @intCast((if (unless) |u| u.name else @as([]const u8, "null")).len);

    const appConfig = AppConfig{ .apiUrl = "https://api.example.com", .timeout = 30000, .retries = 3, .debug = false };
    sink += appConfig.timeoutInSeconds();
    sink += appConfig.maxRetries();
    sink += @intFromBool(appConfig.isProduction());
    sink += @intFromBool(appConfig.isDevelopment());
    sink += @intFromBool(appConfig.hasRetries());

    std.mem.doNotOptimizeAway(sink);
}

pub fn runBenchmark() void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    doTheWork(arena.allocator()) catch {};
}

export fn bench_run() void {
    runBenchmark();
}
