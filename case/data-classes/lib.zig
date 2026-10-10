// iOS Size Benchmark - Test Case Implementation
// Generated with Claude AI (https://claude.ai)
//
// Zig port of the "data-classes" case (lib.ts is the source of truth). Kotlin
// data classes auto-generate equals/hashCode/toString/copy/componentN; Zig has
// none of that, so each data class becomes a plain struct and every such member
// is written out by hand — that manual explicitness IS the idiomatic Zig point,
// and a genuine structural difference from the Kotlin/Swift/TS versions
// (documented, not a 1:1 mirror). Computed properties become methods; Kotlin's
// `copy(...)` becomes `copyWith(opts)` taking a struct of optional (?T)
// overrides merged over `self`; equals->`eql`, hashCode->`hashCode`,
// toString->allocPrint. Zig has no closures, so groupBy/distinct take a comptime
// key function. A per-run arena owns every allocation; one exported entry
// exercises every type and method so nothing is dead-code eliminated (the Swift
// `public` analogue).

const std = @import("std");
const Allocator = std.mem.Allocator;

// Deterministic LCG RNG (captured state -> struct + method). Mirrors Kotlin's
// inclusive `(a..b).random()`; only the shape of the data matters for size.
const Rng = struct {
    seed: i64 = 123456789,
    fn int(self: *Rng, min: i64, max: i64) i64 {
        self.seed = (self.seed *% 1103515245 +% 12345) & 0x7fffffff;
        return min + @mod(self.seed, (max - min + 1));
    }
};

fn average(nums: []const f64) f64 {
    if (nums.len == 0) return 0.0;
    var s: f64 = 0;
    for (nums) |n| s += n;
    return s / @as(f64, @floatFromInt(nums.len));
}

// 32-bit rolling string hash (matches lib.ts hashString's `| 0` wraparound).
fn hashString(s: []const u8) i32 {
    var h: i32 = 0;
    for (s) |c| h = h *% 31 +% @as(i32, c);
    return h;
}

fn streq(a: []const u8, b: []const u8) bool {
    return std.mem.eql(u8, a, b);
}

fn distinctStr(a: Allocator, items: []const []const u8) ![][]const u8 {
    var seen: std.StringHashMapUnmanaged(void) = .empty;
    var out: std.ArrayList([]const u8) = .empty;
    for (items) |it| {
        if (seen.get(it) == null) {
            try seen.put(a, it, {});
            try out.append(a, it);
        }
    }
    return out.toOwnedSlice(a);
}

// groupBy with a comptime key function (Zig has no closures). Returns a string
// map of buckets; each bucket is an ArrayList(T). Monomorphized per T.
fn GroupByStr(comptime T: type) type {
    return struct {
        const Map = std.StringHashMapUnmanaged(std.ArrayList(T));
        fn run(a: Allocator, items: []const T, comptime key: fn (T) []const u8) !Map {
            var m: Map = .empty;
            for (items) |it| {
                const gop = try m.getOrPut(a, key(it));
                if (!gop.found_existing) gop.value_ptr.* = .empty;
                try gop.value_ptr.append(a, it);
            }
            return m;
        }
    };
}

// ----- Simple data classes --------------------------------------------------

const Person = struct {
    id: []const u8,
    firstName: []const u8,
    lastName: []const u8,
    age: i64,
    email: []const u8,

    fn fullName(self: Person, a: Allocator) ![]u8 {
        return std.fmt.allocPrint(a, "{s} {s}", .{ self.firstName, self.lastName });
    }
    fn isAdult(self: Person) bool {
        return self.age >= 18;
    }

    const CopyOpts = struct {
        id: ?[]const u8 = null,
        firstName: ?[]const u8 = null,
        lastName: ?[]const u8 = null,
        age: ?i64 = null,
        email: ?[]const u8 = null,
    };
    fn copyWith(self: Person, o: CopyOpts) Person {
        return .{
            .id = o.id orelse self.id,
            .firstName = o.firstName orelse self.firstName,
            .lastName = o.lastName orelse self.lastName,
            .age = o.age orelse self.age,
            .email = o.email orelse self.email,
        };
    }
    fn eql(self: Person, other: Person) bool {
        return streq(self.id, other.id) and streq(self.firstName, other.firstName) and
            streq(self.lastName, other.lastName) and self.age == other.age and
            streq(self.email, other.email);
    }
    fn hashCode(self: Person) i32 {
        var h = hashString(self.id);
        h = h *% 31 +% hashString(self.firstName);
        h = h *% 31 +% hashString(self.lastName);
        h = h *% 31 +% @as(i32, @intCast(self.age));
        h = h *% 31 +% hashString(self.email);
        return h;
    }
    fn toString(self: Person, a: Allocator) ![]u8 {
        return std.fmt.allocPrint(a, "Person(id={s}, firstName={s}, lastName={s}, age={d}, email={s})", .{ self.id, self.firstName, self.lastName, self.age, self.email });
    }
};

const Address = struct {
    street: []const u8,
    city: []const u8,
    state: []const u8,
    zipCode: []const u8,
    country: []const u8,

    fn shortAddress(self: Address, a: Allocator) ![]u8 {
        return std.fmt.allocPrint(a, "{s}, {s}", .{ self.city, self.state });
    }
    fn isUSA(self: Address) bool {
        return streq(self.country, "USA") or streq(self.country, "usa");
    }
};

const ContactInfo = struct {
    primaryEmail: []const u8,
    secondaryEmail: ?[]const u8 = null,
    phoneNumber: ?[]const u8 = null,
    address: ?Address = null,

    fn hasMultipleEmails(self: ContactInfo) bool {
        return self.secondaryEmail != null;
    }
    fn hasCompleteInfo(self: ContactInfo) bool {
        return self.phoneNumber != null and self.address != null;
    }
};

// ----- Complex nested data structures ---------------------------------------

const Employee = struct {
    id: []const u8,
    person: Person,
    contactInfo: ContactInfo,
    department: []const u8,
    position: []const u8,
    salary: f64,
    startDate: []const u8,
    manager: ?[]const u8 = null,
    isActive: bool = true,

    fn displayName(self: Employee, a: Allocator) ![]u8 {
        const fn_ = try self.person.fullName(a);
        return std.fmt.allocPrint(a, "{s} ({s})", .{ fn_, self.department });
    }
    fn isManager(self: Employee) bool {
        return self.manager == null;
    }
    fn yearsOfService(self: Employee) i64 {
        const yr = if (self.startDate.len >= 4)
            std.fmt.parseInt(i64, self.startDate[0..4], 10) catch 2024
        else
            2024;
        return 2024 - yr;
    }

    // copyWith can't distinguish "set manager to null" from "leave unchanged"
    // (null means unchanged); the driver never needs that, matching lib.ts use.
    const CopyOpts = struct {
        id: ?[]const u8 = null,
        person: ?Person = null,
        contactInfo: ?ContactInfo = null,
        department: ?[]const u8 = null,
        position: ?[]const u8 = null,
        salary: ?f64 = null,
        startDate: ?[]const u8 = null,
        manager: ?[]const u8 = null,
        isActive: ?bool = null,
    };
    fn copyWith(self: Employee, o: CopyOpts) Employee {
        return .{
            .id = o.id orelse self.id,
            .person = o.person orelse self.person,
            .contactInfo = o.contactInfo orelse self.contactInfo,
            .department = o.department orelse self.department,
            .position = o.position orelse self.position,
            .salary = o.salary orelse self.salary,
            .startDate = o.startDate orelse self.startDate,
            .manager = o.manager orelse self.manager,
            .isActive = o.isActive orelse self.isActive,
        };
    }
};

const Department = struct {
    id: []const u8,
    name: []const u8,
    description: []const u8,
    budget: f64,
    manager: Employee,
    employees: []const Employee,

    fn totalSalaryBudget(self: Department) f64 {
        var s: f64 = 0;
        for (self.employees) |e| s += e.salary;
        return s;
    }
    fn employeeCount(self: Department) usize {
        return self.employees.len;
    }
    fn averageSalary(self: Department) f64 {
        return if (self.employees.len > 0)
            self.totalSalaryBudget() / @as(f64, @floatFromInt(self.employees.len))
        else
            0.0;
    }

    const CopyOpts = struct {
        id: ?[]const u8 = null,
        name: ?[]const u8 = null,
        description: ?[]const u8 = null,
        budget: ?f64 = null,
        manager: ?Employee = null,
        employees: ?[]const Employee = null,
    };
    fn copyWith(self: Department, o: CopyOpts) Department {
        return .{
            .id = o.id orelse self.id,
            .name = o.name orelse self.name,
            .description = o.description orelse self.description,
            .budget = o.budget orelse self.budget,
            .manager = o.manager orelse self.manager,
            .employees = o.employees orelse self.employees,
        };
    }
};

const Company = struct {
    id: []const u8,
    name: []const u8,
    headquarters: Address,
    departments: []const Department,
    foundedYear: i64,
    website: ?[]const u8 = null,

    fn totalEmployees(self: Company) usize {
        var s: usize = 0;
        for (self.departments) |d| s += d.employeeCount();
        return s;
    }
    fn totalBudget(self: Company) f64 {
        var s: f64 = 0;
        for (self.departments) |d| s += d.budget;
        return s;
    }
    fn companyAge(self: Company) i64 {
        return 2024 - self.foundedYear;
    }
};

// ----- Financial data structures --------------------------------------------

const Transaction = struct {
    id: []const u8,
    amount: f64,
    currency: []const u8,
    timestamp: i64,
    description: []const u8,
    category: []const u8,
    tags: []const []const u8 = &.{},

    fn isExpense(self: Transaction) bool {
        return self.amount < 0;
    }
    fn isIncome(self: Transaction) bool {
        return self.amount > 0;
    }
    fn formattedAmount(self: Transaction, a: Allocator) ![]u8 {
        const sign = if (self.amount >= 0) "+" else "";
        return std.fmt.allocPrint(a, "{s}{d} {s}", .{ sign, @trunc(self.amount * 100) / 100.0, self.currency });
    }
};

const Account = struct {
    id: []const u8,
    accountNumber: []const u8,
    accountType: []const u8,
    balance: f64,
    currency: []const u8,
    owner: Person,
    transactions: []const Transaction,

    fn totalIncome(self: Account) f64 {
        var s: f64 = 0;
        for (self.transactions) |t| if (t.isIncome()) {
            s += t.amount;
        };
        return s;
    }
    fn totalExpenses(self: Account) f64 {
        var s: f64 = 0;
        for (self.transactions) |t| if (t.isExpense()) {
            s += t.amount;
        };
        return s;
    }
    fn transactionCount(self: Account) usize {
        return self.transactions.len;
    }
};

const Budget = struct {
    id: []const u8,
    name: []const u8,
    totalAmount: f64,
    currency: []const u8,
    categories: std.StringHashMapUnmanaged(f64),
    period: []const u8,
    owner: Person,

    fn allocatedAmount(self: Budget) f64 {
        var s: f64 = 0;
        var it = self.categories.valueIterator();
        while (it.next()) |v| s += v.*;
        return s;
    }
    fn remainingAmount(self: Budget) f64 {
        return self.totalAmount - self.allocatedAmount();
    }
    fn isOverBudget(self: Budget) bool {
        return self.allocatedAmount() > self.totalAmount;
    }
};

// ----- E-commerce data structures -------------------------------------------

const Product = struct {
    id: []const u8,
    name: []const u8,
    description: []const u8,
    price: f64,
    currency: []const u8,
    category: []const u8,
    tags: []const []const u8,
    inStock: bool,
    stockQuantity: i64,

    fn isAvailable(self: Product) bool {
        return self.inStock and self.stockQuantity > 0;
    }
    fn formattedPrice(self: Product, a: Allocator) ![]u8 {
        return std.fmt.allocPrint(a, "{d} {s}", .{ @trunc(self.price * 100) / 100.0, self.currency });
    }
    fn isOnSale(self: Product) bool {
        for (self.tags) |t| if (streq(t, "sale")) return true;
        return false;
    }

    const CopyOpts = struct {
        id: ?[]const u8 = null,
        name: ?[]const u8 = null,
        description: ?[]const u8 = null,
        price: ?f64 = null,
        currency: ?[]const u8 = null,
        category: ?[]const u8 = null,
        tags: ?[]const []const u8 = null,
        inStock: ?bool = null,
        stockQuantity: ?i64 = null,
    };
    fn copyWith(self: Product, o: CopyOpts) Product {
        return .{
            .id = o.id orelse self.id,
            .name = o.name orelse self.name,
            .description = o.description orelse self.description,
            .price = o.price orelse self.price,
            .currency = o.currency orelse self.currency,
            .category = o.category orelse self.category,
            .tags = o.tags orelse self.tags,
            .inStock = o.inStock orelse self.inStock,
            .stockQuantity = o.stockQuantity orelse self.stockQuantity,
        };
    }
};

const CartItem = struct {
    product: Product,
    quantity: i64,
    selectedVariant: ?[]const u8 = null,

    fn totalPrice(self: CartItem) f64 {
        return self.product.price * @as(f64, @floatFromInt(self.quantity));
    }
    fn isValidQuantity(self: CartItem) bool {
        return self.quantity > 0 and self.quantity <= self.product.stockQuantity;
    }
};

const ShoppingCart = struct {
    id: []const u8,
    userId: []const u8,
    items: []const CartItem,
    discountCode: ?[]const u8 = null,
    discountAmount: f64 = 0.0,

    fn subtotal(self: ShoppingCart) f64 {
        var s: f64 = 0;
        for (self.items) |i| s += i.totalPrice();
        return s;
    }
    fn total(self: ShoppingCart) f64 {
        return self.subtotal() - self.discountAmount;
    }
    fn itemCount(self: ShoppingCart) i64 {
        var s: i64 = 0;
        for (self.items) |i| s += i.quantity;
        return s;
    }
    fn hasDiscount(self: ShoppingCart) bool {
        return self.discountCode != null and self.discountAmount > 0;
    }
};

const Order = struct {
    id: []const u8,
    userId: []const u8,
    cart: ShoppingCart,
    shippingAddress: Address,
    billingAddress: Address,
    paymentMethod: []const u8,
    orderDate: []const u8,
    status: []const u8,

    fn orderTotal(self: Order) f64 {
        return self.cart.total();
    }
    fn isShipped(self: Order) bool {
        return streq(self.status, "shipped") or streq(self.status, "delivered");
    }
    fn isCompleted(self: Order) bool {
        return streq(self.status, "delivered");
    }
    fn itemSummary(self: Order, a: Allocator) ![]u8 {
        return std.fmt.allocPrint(a, "{d} items totaling {d}", .{ self.cart.itemCount(), self.cart.total() });
    }

    const CopyOpts = struct {
        id: ?[]const u8 = null,
        userId: ?[]const u8 = null,
        cart: ?ShoppingCart = null,
        shippingAddress: ?Address = null,
        billingAddress: ?Address = null,
        paymentMethod: ?[]const u8 = null,
        orderDate: ?[]const u8 = null,
        status: ?[]const u8 = null,
    };
    fn copyWith(self: Order, o: CopyOpts) Order {
        return .{
            .id = o.id orelse self.id,
            .userId = o.userId orelse self.userId,
            .cart = o.cart orelse self.cart,
            .shippingAddress = o.shippingAddress orelse self.shippingAddress,
            .billingAddress = o.billingAddress orelse self.billingAddress,
            .paymentMethod = o.paymentMethod orelse self.paymentMethod,
            .orderDate = o.orderDate orelse self.orderDate,
            .status = o.status orelse self.status,
        };
    }
};

// ----- Gaming / entertainment data structures -------------------------------

const Player = struct {
    id: []const u8,
    username: []const u8,
    email: []const u8,
    level: i64,
    experience: i64,
    achievements: []const []const u8,
    joinDate: []const u8,

    fn experienceToNextLevel(self: Player) i64 {
        return ((self.level + 1) * 1000) - self.experience;
    }
    fn achievementCount(self: Player) usize {
        return self.achievements.len;
    }
    fn isVeteran(self: Player) bool {
        for (self.achievements) |ac| if (streq(ac, "veteran")) return true;
        return false;
    }

    const CopyOpts = struct {
        id: ?[]const u8 = null,
        username: ?[]const u8 = null,
        email: ?[]const u8 = null,
        level: ?i64 = null,
        experience: ?i64 = null,
        achievements: ?[]const []const u8 = null,
        joinDate: ?[]const u8 = null,
    };
    fn copyWith(self: Player, o: CopyOpts) Player {
        return .{
            .id = o.id orelse self.id,
            .username = o.username orelse self.username,
            .email = o.email orelse self.email,
            .level = o.level orelse self.level,
            .experience = o.experience orelse self.experience,
            .achievements = o.achievements orelse self.achievements,
            .joinDate = o.joinDate orelse self.joinDate,
        };
    }
};

const GameSession = struct {
    id: []const u8,
    player: Player,
    gameMode: []const u8,
    score: i64,
    duration: i64,
    timestamp: i64,
    achievements: []const []const u8 = &.{},

    fn scorePerMinute(self: GameSession) f64 {
        return if (self.duration > 0)
            @as(f64, @floatFromInt(self.score)) / (@as(f64, @floatFromInt(self.duration)) / 60000.0)
        else
            0.0;
    }
    fn hasNewAchievements(self: GameSession) bool {
        return self.achievements.len > 0;
    }
    fn durationInMinutes(self: GameSession) i64 {
        return @divTrunc(self.duration, 60000);
    }
};

const LeaderboardEntry = struct {
    rank: i64,
    player: Player,
    score: i64,
    gamesPlayed: i64,

    fn averageScorePerGame(self: LeaderboardEntry) f64 {
        return if (self.gamesPlayed > 0)
            @as(f64, @floatFromInt(self.score)) / @as(f64, @floatFromInt(self.gamesPlayed))
        else
            0.0;
    }
    fn isTopTen(self: LeaderboardEntry) bool {
        return self.rank <= 10;
    }
};

const Leaderboard = struct {
    gameMode: []const u8,
    period: []const u8,
    entries: []const LeaderboardEntry,
    lastUpdated: i64,

    fn topPlayer(self: Leaderboard) ?LeaderboardEntry {
        return if (self.entries.len > 0) self.entries[0] else null;
    }
    fn entryCount(self: Leaderboard) usize {
        return self.entries.len;
    }
    fn averageScore(self: Leaderboard) f64 {
        if (self.entries.len == 0) return 0.0;
        var s: f64 = 0;
        for (self.entries) |e| s += @floatFromInt(e.score);
        return s / @as(f64, @floatFromInt(self.entries.len));
    }
};

// ----- Social media data structures -----------------------------------------

const Comment = struct {
    id: []const u8,
    author: Person,
    content: []const u8,
    timestamp: i64,
    likes: i64,
    replies: []const Comment = &.{},

    fn hasReplies(self: Comment) bool {
        return self.replies.len > 0;
    }
    fn totalReplies(self: Comment) usize {
        var s = self.replies.len;
        for (self.replies) |r| s += r.totalReplies();
        return s;
    }

    const CopyOpts = struct {
        id: ?[]const u8 = null,
        author: ?Person = null,
        content: ?[]const u8 = null,
        timestamp: ?i64 = null,
        likes: ?i64 = null,
        replies: ?[]const Comment = null,
    };
    fn copyWith(self: Comment, o: CopyOpts) Comment {
        return .{
            .id = o.id orelse self.id,
            .author = o.author orelse self.author,
            .content = o.content orelse self.content,
            .timestamp = o.timestamp orelse self.timestamp,
            .likes = o.likes orelse self.likes,
            .replies = o.replies orelse self.replies,
        };
    }
};

const Post = struct {
    id: []const u8,
    author: Person,
    content: []const u8,
    timestamp: i64,
    likes: i64,
    comments: []const Comment,
    tags: []const []const u8,
    isPublic: bool = true,

    fn commentCount(self: Post) usize {
        return self.comments.len;
    }
    fn hasHashtags(self: Post) bool {
        return self.tags.len > 0;
    }
    fn isPopular(self: Post) bool {
        return self.likes > 100 or self.comments.len > 50;
    }

    const CopyOpts = struct {
        id: ?[]const u8 = null,
        author: ?Person = null,
        content: ?[]const u8 = null,
        timestamp: ?i64 = null,
        likes: ?i64 = null,
        comments: ?[]const Comment = null,
        tags: ?[]const []const u8 = null,
        isPublic: ?bool = null,
    };
    fn copyWith(self: Post, o: CopyOpts) Post {
        return .{
            .id = o.id orelse self.id,
            .author = o.author orelse self.author,
            .content = o.content orelse self.content,
            .timestamp = o.timestamp orelse self.timestamp,
            .likes = o.likes orelse self.likes,
            .comments = o.comments orelse self.comments,
            .tags = o.tags orelse self.tags,
            .isPublic = o.isPublic orelse self.isPublic,
        };
    }
};

const UserProfile = struct {
    person: Person,
    bio: []const u8,
    profilePicture: ?[]const u8,
    followers: []const []const u8,
    following: []const []const u8,
    posts: []const Post,

    fn followerCount(self: UserProfile) usize {
        return self.followers.len;
    }
    fn followingCount(self: UserProfile) usize {
        return self.following.len;
    }
    fn postCount(self: UserProfile) usize {
        return self.posts.len;
    }
    fn totalLikes(self: UserProfile) i64 {
        var s: i64 = 0;
        for (self.posts) |p| s += p.likes;
        return s;
    }
    fn isVerified(self: UserProfile) bool {
        return self.followerCount() > 10000;
    }

    const CopyOpts = struct {
        person: ?Person = null,
        bio: ?[]const u8 = null,
        profilePicture: ?[]const u8 = null,
        followers: ?[]const []const u8 = null,
        following: ?[]const []const u8 = null,
        posts: ?[]const Post = null,
    };
    fn copyWith(self: UserProfile, o: CopyOpts) UserProfile {
        return .{
            .person = o.person orelse self.person,
            .bio = o.bio orelse self.bio,
            .profilePicture = o.profilePicture orelse self.profilePicture,
            .followers = o.followers orelse self.followers,
            .following = o.following orelse self.following,
            .posts = o.posts orelse self.posts,
        };
    }
};

// ----- Configuration / settings data structures -----------------------------

const NotificationSettings = struct {
    emailNotifications: bool,
    pushNotifications: bool,
    smsNotifications: bool,
    marketingEmails: bool,
    securityAlerts: bool,

    fn hasAnyNotificationsEnabled(self: NotificationSettings) bool {
        return self.emailNotifications or self.pushNotifications or self.smsNotifications or
            self.marketingEmails or self.securityAlerts;
    }
    fn notificationCount(self: NotificationSettings) i64 {
        var c: i64 = 0;
        const flags = [_]bool{ self.emailNotifications, self.pushNotifications, self.smsNotifications, self.marketingEmails, self.securityAlerts };
        for (flags) |b| c += @intFromBool(b);
        return c;
    }
};

const PrivacySettings = struct {
    profileVisibility: []const u8,
    dataSharing: bool,
    analytics: bool,
    advertising: bool,
    locationTracking: bool,

    fn isPrivacyFocused(self: PrivacySettings) bool {
        return !self.dataSharing and !self.analytics and !self.advertising and !self.locationTracking;
    }
    fn privacyScore(self: PrivacySettings) i64 {
        var c: i64 = 0;
        const flags = [_]bool{ self.dataSharing, self.analytics, self.advertising, self.locationTracking };
        for (flags) |b| c += @intFromBool(!b);
        return c;
    }
};

const DisplaySettings = struct {
    fontSize: []const u8,
    colorScheme: []const u8,
    animation: bool,
    autoPlay: bool,
    highContrast: bool,

    fn isAccessibilityFriendly(self: DisplaySettings) bool {
        return streq(self.fontSize, "large") or streq(self.fontSize, "extra-large") or self.highContrast;
    }
    fn isPerformanceOptimized(self: DisplaySettings) bool {
        return !self.animation and !self.autoPlay;
    }
};

const AppSettings = struct {
    theme: []const u8,
    language: []const u8,
    notifications: NotificationSettings,
    privacy: PrivacySettings,
    display: DisplaySettings,
};

// ----- Key functions standing in for lib.ts's groupBy lambdas ---------------

fn keyPersonFirst(p: Person) []const u8 {
    return p.firstName;
}
fn keyEmpDept(e: Employee) []const u8 {
    return e.department;
}
fn keyEmpSalaryRange(e: Employee) []const u8 {
    if (e.salary < 50000) return "Under 50K";
    if (e.salary < 100000) return "50K-100K";
    if (e.salary < 150000) return "100K-150K";
    return "150K+";
}
fn keyTxnCategory(t: Transaction) []const u8 {
    return t.category;
}
fn keyTxnCurrency(t: Transaction) []const u8 {
    return t.currency;
}
fn keyGameMode(s: GameSession) []const u8 {
    return s.gameMode;
}
fn keyCartItemProduct(i: CartItem) []const u8 {
    return i.product.name;
}
fn keyIdentity(s: []const u8) []const u8 {
    return s;
}

fn emailDomain(email: []const u8) []const u8 {
    if (std.mem.indexOfScalar(u8, email, '@')) |idx| return email[idx + 1 ..];
    return email;
}

// ----- Data processing / analysis (Kotlin returns Map<String, Any>; we return
// a summary string so every computed value stays observably used) -------------

const DataClassProcessor = struct {
    fn processPersonData(_: DataClassProcessor, a: Allocator, persons: []const Person) ![]u8 {
        var adults: usize = 0;
        var ages: std.ArrayList(f64) = .empty;
        var domains: std.ArrayList([]const u8) = .empty;
        for (persons) |p| {
            if (p.isAdult()) adults += 1;
            try ages.append(a, @floatFromInt(p.age));
            try domains.append(a, emailDomain(p.email));
        }
        const avgAge = average(ages.items);
        var byFirst = try GroupByStr(Person).run(a, persons, keyPersonFirst);
        const uniqueDomains = try distinctStr(a, domains.items);
        return std.fmt.allocPrint(a, "persons={d},adults={d},avgAge={d},names={d},domains={d}", .{ persons.len, adults, avgAge, byFirst.count(), uniqueDomains.len });
    }

    fn analyzeEmployeeData(_: DataClassProcessor, a: Allocator, employees: []const Employee) ![]u8 {
        var active: usize = 0;
        var managers: usize = 0;
        var salaries: std.ArrayList(f64) = .empty;
        for (employees) |e| {
            if (e.isActive) active += 1;
            if (e.isManager()) managers += 1;
            try salaries.append(a, e.salary);
        }
        var depts = try GroupByStr(Employee).run(a, employees, keyEmpDept);
        var ranges = try GroupByStr(Employee).run(a, employees, keyEmpSalaryRange);
        return std.fmt.allocPrint(a, "emps={d},active={d},depts={d},avgSalary={d},ranges={d},mgrs={d}", .{ employees.len, active, depts.count(), average(salaries.items), ranges.count(), managers });
    }

    fn processTransactionData(_: DataClassProcessor, a: Allocator, transactions: []const Transaction) ![]u8 {
        var totalIncome: f64 = 0;
        var totalExpenses: f64 = 0;
        var amounts: std.ArrayList(f64) = .empty;
        var currencies: std.ArrayList([]const u8) = .empty;
        for (transactions) |t| {
            if (t.isIncome()) totalIncome += t.amount;
            if (t.isExpense()) totalExpenses += t.amount;
            try amounts.append(a, t.amount);
            try currencies.append(a, t.currency);
        }
        var byCategory = try GroupByStr(Transaction).run(a, transactions, keyTxnCategory);
        var categoryAgg: f64 = 0;
        var it = byCategory.valueIterator();
        while (it.next()) |group| {
            var tot: f64 = 0;
            for (group.items) |t| tot += t.amount;
            categoryAgg += @as(f64, @floatFromInt(group.items.len)) + tot;
        }
        const uniqueCur = try distinctStr(a, currencies.items);
        return std.fmt.allocPrint(a, "txns={d},income={d},expenses={d},cats={d},catAgg={d},avg={d},currencies={d}", .{ transactions.len, totalIncome, totalExpenses, byCategory.count(), categoryAgg, average(amounts.items), uniqueCur.len });
    }

    fn analyzeShoppingData(_: DataClassProcessor, a: Allocator, carts: []const ShoppingCart) ![]u8 {
        var allItems: std.ArrayList(CartItem) = .empty;
        var values: std.ArrayList(f64) = .empty;
        var itemsPer: std.ArrayList(f64) = .empty;
        var withDiscount: usize = 0;
        var totalDiscount: f64 = 0;
        var revenue: f64 = 0;
        for (carts) |c| {
            for (c.items) |i| try allItems.append(a, i);
            try values.append(a, c.total());
            try itemsPer.append(a, @floatFromInt(c.itemCount()));
            if (c.hasDiscount()) withDiscount += 1;
            totalDiscount += c.discountAmount;
            revenue += c.total();
        }
        var byProduct = try GroupByStr(CartItem).run(a, allItems.items, keyCartItemProduct);
        return std.fmt.allocPrint(a, "carts={d},avgValue={d},avgItems={d},disc={d},discAmt={d},popular={d},revenue={d}", .{ carts.len, average(values.items), average(itemsPer.items), withDiscount, totalDiscount, byProduct.count(), revenue });
    }

    fn processGameData(_: DataClassProcessor, a: Allocator, sessions: []const GameSession) ![]u8 {
        var playerIds: std.ArrayList([]const u8) = .empty;
        var scores: std.ArrayList(f64) = .empty;
        var durations: std.ArrayList(f64) = .empty;
        var withAchievements: usize = 0;
        for (sessions) |s| {
            try playerIds.append(a, s.player.id);
            try scores.append(a, @floatFromInt(s.score));
            try durations.append(a, @floatFromInt(s.durationInMinutes()));
            if (s.hasNewAchievements()) withAchievements += 1;
        }
        const uniquePlayers = try distinctStr(a, playerIds.items);
        var modes = try GroupByStr(GameSession).run(a, sessions, keyGameMode);
        return std.fmt.allocPrint(a, "sessions={d},players={d},avgScore={d},avgDur={d},modes={d},achieve={d}", .{ sessions.len, uniquePlayers.len, average(scores.items), average(durations.items), modes.count(), withAchievements });
    }

    fn analyzeSocialData(_: DataClassProcessor, a: Allocator, profiles: []const UserProfile) ![]u8 {
        var allPosts: std.ArrayList(Post) = .empty;
        var verified: usize = 0;
        var followerCounts: std.ArrayList(f64) = .empty;
        var postCounts: std.ArrayList(f64) = .empty;
        for (profiles) |p| {
            for (p.posts) |post| try allPosts.append(a, post);
            if (p.isVerified()) verified += 1;
            try followerCounts.append(a, @floatFromInt(p.followerCount()));
            try postCounts.append(a, @floatFromInt(p.postCount()));
        }
        var totalLikes: i64 = 0;
        var totalComments: usize = 0;
        var allTags: std.ArrayList([]const u8) = .empty;
        var publicPosts: usize = 0;
        var popularPosts: usize = 0;
        for (allPosts.items) |post| {
            totalLikes += post.likes;
            totalComments += post.commentCount();
            for (post.tags) |t| try allTags.append(a, t);
            if (post.isPublic) publicPosts += 1;
            if (post.isPopular()) popularPosts += 1;
        }
        var tagGroups = try GroupByStr([]const u8).run(a, allTags.items, keyIdentity);
        return std.fmt.allocPrint(a, "users={d},verified={d},posts={d},likes={d},comments={d},avgFollowers={d},avgPosts={d},tags={d},public={d},popular={d}", .{ profiles.len, verified, allPosts.items.len, totalLikes, totalComments, average(followerCounts.items), average(postCounts.items), tagGroups.count(), publicPosts, popularPosts });
    }
};

// ----- Data transformation / manipulation -----------------------------------

const DataTransformer = struct {
    fn transformPersonToEmployee(_: DataTransformer, a: Allocator, person: Person, department: []const u8, position: []const u8, salary: f64) !Employee {
        return .{
            .id = try std.fmt.allocPrint(a, "EMP_{s}", .{person.id}),
            .person = person,
            .contactInfo = .{ .primaryEmail = person.email },
            .department = department,
            .position = position,
            .salary = salary,
            .startDate = "2024-01-01",
        };
    }

    fn mergeContactInfo(_: DataTransformer, info1: ContactInfo, info2: ContactInfo) ContactInfo {
        return .{
            .primaryEmail = info1.primaryEmail,
            .secondaryEmail = info1.secondaryEmail orelse info2.secondaryEmail,
            .phoneNumber = info1.phoneNumber orelse info2.phoneNumber,
            .address = info1.address orelse info2.address,
        };
    }

    fn aggregateTransactions(_: DataTransformer, a: Allocator, transactions: []const Transaction, groupByKey: []const u8) ![]Transaction {
        const byCategory = streq(groupByKey, "category");
        if (!byCategory and !streq(groupByKey, "currency")) return a.dupe(Transaction, transactions);

        var grouped = if (byCategory)
            try GroupByStr(Transaction).run(a, transactions, keyTxnCategory)
        else
            try GroupByStr(Transaction).run(a, transactions, keyTxnCurrency);

        var out: std.ArrayList(Transaction) = .empty;
        var it = grouped.iterator();
        while (it.next()) |entry| {
            const key = entry.key_ptr.*;
            const txns = entry.value_ptr.items;
            var amount: f64 = 0;
            var maxTs: i64 = txns[0].timestamp;
            var tags: std.ArrayList([]const u8) = .empty;
            for (txns) |t| {
                amount += t.amount;
                if (t.timestamp > maxTs) maxTs = t.timestamp;
                for (t.tags) |g| try tags.append(a, g);
            }
            try out.append(a, .{
                .id = try std.fmt.allocPrint(a, "AGG_{s}_{d}", .{ key, txns.len }),
                .amount = amount,
                .currency = if (byCategory) txns[0].currency else key,
                .timestamp = maxTs,
                .description = try std.fmt.allocPrint(a, "Aggregated {s} transactions", .{key}),
                .category = if (byCategory) key else "aggregated",
                .tags = try distinctStr(a, tags.items),
            });
        }
        return out.toOwnedSlice(a);
    }

    fn createOrderFromCart(_: DataTransformer, a: Allocator, cart: ShoppingCart, shippingAddress: Address) !Order {
        return .{
            .id = try std.fmt.allocPrint(a, "ORDER_{s}", .{cart.id}),
            .userId = cart.userId,
            .cart = cart,
            .shippingAddress = shippingAddress,
            .billingAddress = shippingAddress,
            .paymentMethod = "credit_card",
            .orderDate = "2024-01-01",
            .status = "pending",
        };
    }

    fn updatePlayerProgress(_: DataTransformer, a: Allocator, player: Player, session: GameSession) !Player {
        const newExperience = player.experience + @divTrunc(session.score, 10);
        const newLevel = @divTrunc(newExperience, 1000);
        var combined: std.ArrayList([]const u8) = .empty;
        for (player.achievements) |ac| try combined.append(a, ac);
        for (session.achievements) |ac| try combined.append(a, ac);
        return player.copyWith(.{
            .level = @max(player.level, newLevel),
            .experience = newExperience,
            .achievements = try distinctStr(a, combined.items),
        });
    }
};

// ----- Small string helpers used by the driver ------------------------------

fn endsWith(s: []const u8, suffix: []const u8) bool {
    return std.mem.endsWith(u8, s, suffix);
}

fn upperAlloc(a: Allocator, s: []const u8) ![]u8 {
    const out = try a.alloc(u8, s.len);
    for (s, 0..) |c, i| out[i] = std.ascii.toUpper(c);
    return out;
}

fn scoreDesc(comptime T: type) fn (void, T, T) bool {
    return struct {
        fn less(_: void, x: T, y: T) bool {
            return x.score > y.score;
        }
    }.less;
}

// ----- Main benchmark: constructs and uses every type -----------------------

fn doTheWork(a: Allocator) !void {
    var rng = Rng{};
    const processor = DataClassProcessor{};
    const transformer = DataTransformer{};

    const persons = [_]Person{
        .{ .id = "1", .firstName = "John", .lastName = "Doe", .age = 30, .email = "john.doe@example.com" },
        .{ .id = "2", .firstName = "Jane", .lastName = "Smith", .age = 25, .email = "jane.smith@test.com" },
        .{ .id = "3", .firstName = "Bob", .lastName = "Johnson", .age = 35, .email = "bob.johnson@company.org" },
        .{ .id = "4", .firstName = "Alice", .lastName = "Brown", .age = 28, .email = "alice.brown@email.net" },
        .{ .id = "5", .firstName = "Charlie", .lastName = "Wilson", .age = 42, .email = "charlie.wilson@work.com" },
    };
    const addresses = [_]Address{
        .{ .street = "123 Main St", .city = "New York", .state = "NY", .zipCode = "10001", .country = "USA" },
        .{ .street = "456 Oak Ave", .city = "Los Angeles", .state = "CA", .zipCode = "90210", .country = "USA" },
        .{ .street = "789 Pine Rd", .city = "Chicago", .state = "IL", .zipCode = "60601", .country = "USA" },
    };

    const deptNames = [_][]const u8{ "Engineering", "Marketing", "Sales", "HR", "Finance" };
    const positions = [_][]const u8{ "Developer", "Manager", "Analyst", "Specialist", "Director" };

    // zip(persons, addresses) -> contactInfos (min length wins)
    var contactInfos: std.ArrayList(ContactInfo) = .empty;
    for (addresses, 0..) |addr, i|
        try contactInfos.append(a, .{ .primaryEmail = persons[i].email, .phoneNumber = "+1234567890", .address = addr });

    // zip(persons, contactInfos) -> employees
    var employees: std.ArrayList(Employee) = .empty;
    for (contactInfos.items, 0..) |ci, i| {
        try employees.append(a, .{
            .id = try std.fmt.allocPrint(a, "EMP_{s}", .{persons[i].id}),
            .person = persons[i],
            .contactInfo = ci,
            .department = deptNames[i % 5],
            .position = positions[i % 5],
            .salary = 50000.0 + @as(f64, @floatFromInt(i)) * 15000.0,
            .startDate = try std.fmt.allocPrint(a, "202{d}-01-01", .{i + 1}),
        });
    }

    var deptGroups = try GroupByStr(Employee).run(a, employees.items, keyEmpDept);
    var departments: std.ArrayList(Department) = .empty;
    var dgi = deptGroups.iterator();
    while (dgi.next()) |entry| {
        const deptName = entry.key_ptr.*;
        const emps = try a.dupe(Employee, entry.value_ptr.items);
        try departments.append(a, .{
            .id = try std.fmt.allocPrint(a, "DEPT_{s}", .{try upperAlloc(a, deptName)}),
            .name = deptName,
            .description = try std.fmt.allocPrint(a, "{s} department", .{deptName}),
            .budget = @as(f64, @floatFromInt(emps.len)) * 100000.0,
            .manager = emps[0],
            .employees = emps,
        });
    }

    const company = Company{
        .id = "COMPANY_001",
        .name = "Tech Solutions Inc",
        .headquarters = addresses[0],
        .departments = departments.items,
        .foundedYear = 2010,
        .website = "https://techsolutions.com",
    };

    // Financial data
    const categoryNames = [_][]const u8{ "food", "transportation", "entertainment", "utilities", "salary" };
    var transactions: std.ArrayList(Transaction) = .empty;
    {
        var i: i64 = 1;
        while (i <= 100) : (i += 1) {
            try transactions.append(a, .{
                .id = try std.fmt.allocPrint(a, "TXN_{d}", .{i}),
                .amount = if (@mod(i, 3) == 0) -(50.0 + @as(f64, @floatFromInt(i)) * 10.0) else (100.0 + @as(f64, @floatFromInt(i)) * 5.0),
                .currency = if (@mod(i, 10) == 0) "EUR" else "USD",
                .timestamp = 1640995200000 - i * 86400000,
                .description = try std.fmt.allocPrint(a, "Transaction {d}", .{i}),
                .category = categoryNames[@intCast(@mod(i, 5))],
                .tags = if (@mod(i, 5) == 0) &[_][]const u8{ "recurring", "essential" } else &.{},
            });
        }
    }

    var accounts: std.ArrayList(Account) = .empty;
    for (persons, 0..) |person, index| {
        const suffix = try std.fmt.allocPrint(a, "{d}", .{index});
        var acctTxns: std.ArrayList(Transaction) = .empty;
        for (transactions.items) |t| if (endsWith(t.id, suffix)) try acctTxns.append(a, t);
        try accounts.append(a, .{
            .id = try std.fmt.allocPrint(a, "ACC_{s}", .{person.id}),
            .accountNumber = try std.fmt.allocPrint(a, "12345{d}890", .{index}),
            .accountType = if (index % 2 == 0) "checking" else "savings",
            .balance = 1000.0 + @as(f64, @floatFromInt(index)) * 500.0,
            .currency = "USD",
            .owner = person,
            .transactions = try acctTxns.toOwnedSlice(a),
        });
    }

    var budgets: std.ArrayList(Budget) = .empty;
    for (persons, 0..) |person, index| {
        var categories: std.StringHashMapUnmanaged(f64) = .empty;
        try categories.put(a, "housing", 1200.0);
        try categories.put(a, "food", 400.0);
        try categories.put(a, "transportation", 300.0);
        try categories.put(a, "entertainment", 200.0);
        try categories.put(a, "savings", 500.0);
        try budgets.append(a, .{
            .id = try std.fmt.allocPrint(a, "BUDGET_{s}", .{person.id}),
            .name = try std.fmt.allocPrint(a, "{s}'s Monthly Budget", .{person.firstName}),
            .totalAmount = 3000.0 + @as(f64, @floatFromInt(index)) * 500.0,
            .currency = "USD",
            .categories = categories,
            .period = "monthly",
            .owner = person,
        });
    }

    // E-commerce data
    const prodCategories = [_][]const u8{ "electronics", "clothing", "books", "home", "sports" };
    var products: std.ArrayList(Product) = .empty;
    {
        var i: i64 = 1;
        while (i <= 50) : (i += 1) {
            const tags: []const []const u8 = if (@mod(i, 10) == 0)
                &[_][]const u8{ "sale", "featured" }
            else if (@mod(i, 7) == 0)
                &[_][]const u8{"new"}
            else
                &.{};
            try products.append(a, .{
                .id = try std.fmt.allocPrint(a, "PROD_{d}", .{i}),
                .name = try std.fmt.allocPrint(a, "Product {d}", .{i}),
                .description = try std.fmt.allocPrint(a, "Description for product {d}", .{i}),
                .price = 10.0 + @as(f64, @floatFromInt(i)) * 5.0,
                .currency = "USD",
                .category = prodCategories[@intCast(@mod(i, 5))],
                .tags = tags,
                .inStock = @mod(i, 15) != 0,
                .stockQuantity = if (@mod(i, 15) == 0) 0 else i * 2,
            });
        }
    }

    var cartItems: std.ArrayList(CartItem) = .empty;
    for (products.items[0..10], 0..) |product, index|
        try cartItems.append(a, .{ .product = product, .quantity = @as(i64, @intCast(index)) + 1 });

    var shoppingCarts: std.ArrayList(ShoppingCart) = .empty;
    for (persons, 0..) |person, index| {
        const n = @min(index + 2, cartItems.items.len);
        try shoppingCarts.append(a, .{
            .id = try std.fmt.allocPrint(a, "CART_{s}", .{person.id}),
            .userId = person.id,
            .items = cartItems.items[0..n],
            .discountCode = if (index % 3 == 0) "SAVE10" else null,
            .discountAmount = if (index % 3 == 0) 10.0 else 0.0,
        });
    }

    // zip(zip(shoppingCarts, persons), addresses) -> orders
    var orders: std.ArrayList(Order) = .empty;
    for (addresses, 0..) |addr, i|
        try orders.append(a, try transformer.createOrderFromCart(a, shoppingCarts.items[i], addr));

    // Gaming data
    const achievementPool = [_][]const u8{ "first_login", "score_1000", "veteran", "champion" };
    var players: std.ArrayList(Player) = .empty;
    for (persons) |person| {
        const month: i64 = rng.int(1, 12);
        try players.append(a, .{
            .id = try std.fmt.allocPrint(a, "PLAYER_{s}", .{person.id}),
            .username = try std.fmt.allocPrint(a, "{s}_{s}", .{ try lowerAlloc(a, person.firstName), try lowerAlloc(a, person.lastName) }),
            .email = person.email,
            .level = rng.int(1, 50),
            .experience = rng.int(100, 49000),
            .achievements = achievementPool[0..@intCast(rng.int(0, 4))],
            .joinDate = try std.fmt.allocPrint(a, "202{d}-{s}-01", .{ rng.int(0, 3), try padStart2(a, month) }),
        });
    }

    const gameModes = [_][]const u8{ "classic", "arcade", "tournament", "practice" };
    var gameSessions: std.ArrayList(GameSession) = .empty;
    {
        var i: i64 = 1;
        while (i <= 200) : (i += 1) {
            try gameSessions.append(a, .{
                .id = try std.fmt.allocPrint(a, "SESSION_{d}", .{i}),
                .player = players.items[@intCast(@mod(i, @as(i64, @intCast(players.items.len))))],
                .gameMode = gameModes[@intCast(@mod(i, 4))],
                .score = rng.int(100, 10000),
                .duration = rng.int(60000, 3600000),
                .timestamp = 1640995200000 - i * 3600000,
                .achievements = if (@mod(i, 20) == 0) &[_][]const u8{"high_score"} else &.{},
            });
        }
    }

    var leaderboardEntries: std.ArrayList(LeaderboardEntry) = .empty;
    for (players.items, 0..) |player, index|
        try leaderboardEntries.append(a, .{ .rank = @as(i64, @intCast(index)) + 1, .player = player, .score = rng.int(1000, 9999), .gamesPlayed = rng.int(10, 100) });
    const sortedEntries = try a.dupe(LeaderboardEntry, leaderboardEntries.items);
    std.mem.sort(LeaderboardEntry, sortedEntries, {}, scoreDesc(LeaderboardEntry));
    const leaderboard = Leaderboard{ .gameMode = "classic", .period = "weekly", .entries = sortedEntries, .lastUpdated = 1640995200000 };

    // Social media data
    var comments: std.ArrayList(Comment) = .empty;
    {
        var i: i64 = 1;
        while (i <= 50) : (i += 1) {
            try comments.append(a, .{
                .id = try std.fmt.allocPrint(a, "COMMENT_{d}", .{i}),
                .author = persons[@intCast(@mod(i, 5))],
                .content = try std.fmt.allocPrint(a, "This is comment {d}", .{i}),
                .timestamp = 1640995200000 - i * 60000,
                .likes = rng.int(0, 100),
            });
        }
    }

    var posts: std.ArrayList(Post) = .empty;
    {
        var i: i64 = 1;
        while (i <= 30) : (i += 1) {
            const suffix = try std.fmt.allocPrint(a, "{d}", .{@mod(i, 10)});
            var postComments: std.ArrayList(Comment) = .empty;
            for (comments.items) |c| if (endsWith(c.id, suffix)) try postComments.append(a, c);
            const tags: []const []const u8 = if (@mod(i, 5) == 0)
                &[_][]const u8{ "tech", "programming" }
            else if (@mod(i, 3) == 0)
                &[_][]const u8{ "life", "thoughts" }
            else
                &.{};
            try posts.append(a, .{
                .id = try std.fmt.allocPrint(a, "POST_{d}", .{i}),
                .author = persons[@intCast(@mod(i, 5))],
                .content = try std.fmt.allocPrint(a, "This is post {d} with some interesting content", .{i}),
                .timestamp = 1640995200000 - i * 3600000,
                .likes = rng.int(0, 1000),
                .comments = try postComments.toOwnedSlice(a),
                .tags = tags,
            });
        }
    }

    var userProfiles: std.ArrayList(UserProfile) = .empty;
    for (persons) |person| {
        var followers: std.ArrayList([]const u8) = .empty;
        {
            var it: i64 = 1;
            while (it <= 1000) : (it += 1) try followers.append(a, try std.fmt.allocPrint(a, "follower_{d}", .{it}));
        }
        var following: std.ArrayList([]const u8) = .empty;
        {
            var it: i64 = 1;
            while (it <= 500) : (it += 1) try following.append(a, try std.fmt.allocPrint(a, "following_{d}", .{it}));
        }
        var myPosts: std.ArrayList(Post) = .empty;
        for (posts.items) |p| if (streq(p.author.id, person.id)) try myPosts.append(a, p);
        const fc: usize = @intCast(rng.int(10, 1000));
        const gc: usize = @intCast(rng.int(5, 500));
        try userProfiles.append(a, .{
            .person = person,
            .bio = try std.fmt.allocPrint(a, "Bio for {s}", .{try person.fullName(a)}),
            .profilePicture = try std.fmt.allocPrint(a, "profile_{s}.jpg", .{person.id}),
            .followers = followers.items[0..@min(fc, followers.items.len)],
            .following = following.items[0..@min(gc, following.items.len)],
            .posts = try myPosts.toOwnedSlice(a),
        });
    }

    const appSettings = AppSettings{
        .theme = "dark",
        .language = "en",
        .notifications = .{ .emailNotifications = true, .pushNotifications = true, .smsNotifications = false, .marketingEmails = false, .securityAlerts = true },
        .privacy = .{ .profileVisibility = "public", .dataSharing = false, .analytics = false, .advertising = false, .locationTracking = true },
        .display = .{ .fontSize = "medium", .colorScheme = "auto", .animation = true, .autoPlay = false, .highContrast = false },
    };

    // Process all data using data class methods
    const personStats = try processor.processPersonData(a, &persons);
    const employeeStats = try processor.analyzeEmployeeData(a, employees.items);
    const transactionStats = try processor.processTransactionData(a, transactions.items);
    const shoppingStats = try processor.analyzeShoppingData(a, shoppingCarts.items);
    const gameStats = try processor.processGameData(a, gameSessions.items);
    const socialStats = try processor.analyzeSocialData(a, userProfiles.items);

    // Data class features: copy / equals / hashCode / toString / destructuring
    const originalPerson = persons[0];
    const modifiedPerson = originalPerson.copyWith(.{ .age = originalPerson.age + 1 });
    const isEqual = originalPerson.eql(modifiedPerson);
    const hashCodesEqual = originalPerson.hashCode() == modifiedPerson.hashCode();
    const personString = try originalPerson.toString(a);
    const p0 = originalPerson; // "destructuring" -> plain field reads
    const fullNameFromDestructuring = try std.fmt.allocPrint(a, "{s} {s}", .{ p0.firstName, p0.lastName });

    // Complex nested copyWith chains
    var deptEmpsCopy: std.ArrayList(Employee) = .empty;
    for (departments.items[0].employees) |emp| try deptEmpsCopy.append(a, emp.copyWith(.{ .salary = emp.salary * 1.1 }));
    const departmentCopy = departments.items[0].copyWith(.{ .employees = try deptEmpsCopy.toOwnedSlice(a) });

    const orderWithUpdatedStatus = orders.items[0].copyWith(.{ .status = "shipped" });

    const baseProfile = userProfiles.items[0];
    var updatedPosts: std.ArrayList(Post) = .empty;
    for (baseProfile.posts) |post| {
        var updatedComments: std.ArrayList(Comment) = .empty;
        for (post.comments) |c| try updatedComments.append(a, c.copyWith(.{ .likes = c.likes + 1 }));
        try updatedPosts.append(a, post.copyWith(.{ .comments = try updatedComments.toOwnedSlice(a) }));
    }
    const updatedUserProfile = baseProfile.copyWith(.{ .posts = try updatedPosts.toOwnedSlice(a) });

    // Aggregate computations using computed properties
    const totalCompanyValue = company.totalBudget();
    var allSalaries: std.ArrayList(f64) = .empty;
    for (company.departments) |d| for (d.employees) |e| try allSalaries.append(a, e.salary);
    const averageEmployeeSalary = average(allSalaries.items);
    var totalOrders: f64 = 0;
    for (orders.items) |o| totalOrders += o.orderTotal();
    var topGameScore: i64 = 0;
    for (gameSessions.items) |s| if (s.score > topGameScore) {
        topGameScore = s.score;
    };
    var totalSocialEngagement: i64 = 0;
    for (userProfiles.items) |p| totalSocialEngagement += p.totalLikes();

    // Data validation using computed properties
    var validEmployees: usize = 0;
    for (employees.items) |e| if (e.person.isAdult() and e.salary > 0) {
        validEmployees += 1;
    };
    var availableProducts: usize = 0;
    for (products.items) |p| if (p.isAvailable()) {
        availableProducts += 1;
    };
    var completedOrders: usize = 0;
    for (orders.items) |o| if (o.isCompleted()) {
        completedOrders += 1;
    };
    var activeGameSessions: usize = 0;
    for (gameSessions.items) |s| if (s.duration > 60000) {
        activeGameSessions += 1;
    };
    var popularPosts: usize = 0;
    for (posts.items) |p| if (p.isPopular()) {
        popularPosts += 1;
    };

    // Complex transformations
    var employeePromotions: std.ArrayList(Employee) = .empty;
    for (employees.items) |emp| {
        if (emp.yearsOfService() > 2)
            try employeePromotions.append(a, emp.copyWith(.{ .position = try std.fmt.allocPrint(a, "Senior {s}", .{emp.position}), .salary = emp.salary * 1.2 }))
        else
            try employeePromotions.append(a, emp);
    }
    var discountedProducts: std.ArrayList(Product) = .empty;
    for (products.items) |product| {
        if (product.isOnSale())
            try discountedProducts.append(a, product.copyWith(.{ .price = product.price * 0.9 }))
        else
            try discountedProducts.append(a, product);
    }
    var updatedPlayers: std.ArrayList(Player) = .empty;
    for (players.items) |player| {
        var current = player;
        for (gameSessions.items) |s| if (streq(s.player.id, player.id)) {
            current = try transformer.updatePlayerProgress(a, current, s);
        };
        try updatedPlayers.append(a, current);
    }

    // Exercise transformer branches + remaining types
    const aggByCategory = try transformer.aggregateTransactions(a, transactions.items, "category");
    const aggByCurrency = try transformer.aggregateTransactions(a, transactions.items, "currency");
    const promoted = try transformer.transformPersonToEmployee(a, persons[0], "Engineering", "Lead", 123000.0);
    const merged = transformer.mergeContactInfo(contactInfos.items[0], contactInfos.items[1]);

    // Keep every computed value observably used (replaces lib.ts's console.log).
    std.mem.doNotOptimizeAway(personStats.len);
    std.mem.doNotOptimizeAway(employeeStats.len);
    std.mem.doNotOptimizeAway(transactionStats.len);
    std.mem.doNotOptimizeAway(shoppingStats.len);
    std.mem.doNotOptimizeAway(gameStats.len);
    std.mem.doNotOptimizeAway(socialStats.len);
    std.mem.doNotOptimizeAway(company.totalEmployees());
    std.mem.doNotOptimizeAway(company.companyAge());
    std.mem.doNotOptimizeAway(accounts.items[0].totalIncome());
    std.mem.doNotOptimizeAway(accounts.items[0].totalExpenses());
    std.mem.doNotOptimizeAway(budgets.items[0].allocatedAmount());
    std.mem.doNotOptimizeAway(@intFromBool(budgets.items[0].isOverBudget()));
    std.mem.doNotOptimizeAway(availableProducts);
    std.mem.doNotOptimizeAway(completedOrders);
    std.mem.doNotOptimizeAway(totalOrders);
    std.mem.doNotOptimizeAway(orderWithUpdatedStatus.status.len);
    std.mem.doNotOptimizeAway(activeGameSessions);
    std.mem.doNotOptimizeAway(topGameScore);
    std.mem.doNotOptimizeAway(leaderboard.entryCount());
    std.mem.doNotOptimizeAway(leaderboard.averageScore());
    std.mem.doNotOptimizeAway(@intFromBool(leaderboard.topPlayer() != null));
    std.mem.doNotOptimizeAway(popularPosts);
    std.mem.doNotOptimizeAway(totalSocialEngagement);
    std.mem.doNotOptimizeAway(appSettings.notifications.notificationCount());
    std.mem.doNotOptimizeAway(appSettings.privacy.privacyScore());
    std.mem.doNotOptimizeAway(@intFromBool(appSettings.display.isAccessibilityFriendly()));
    std.mem.doNotOptimizeAway(@intFromBool(isEqual));
    std.mem.doNotOptimizeAway(@intFromBool(hashCodesEqual));
    std.mem.doNotOptimizeAway(personString.len);
    std.mem.doNotOptimizeAway(fullNameFromDestructuring.len);
    std.mem.doNotOptimizeAway(departmentCopy.totalSalaryBudget());
    std.mem.doNotOptimizeAway(updatedUserProfile.postCount());
    std.mem.doNotOptimizeAway(totalCompanyValue);
    std.mem.doNotOptimizeAway(averageEmployeeSalary);
    std.mem.doNotOptimizeAway(employeePromotions.items.len);
    std.mem.doNotOptimizeAway(discountedProducts.items.len);
    std.mem.doNotOptimizeAway(updatedPlayers.items.len);
    std.mem.doNotOptimizeAway(aggByCategory.len);
    std.mem.doNotOptimizeAway(aggByCurrency.len);
    std.mem.doNotOptimizeAway(promoted.id.len);
    std.mem.doNotOptimizeAway(@intFromBool(merged.hasMultipleEmails()));
    std.mem.doNotOptimizeAway(comments.items.len);
    std.mem.doNotOptimizeAway(validEmployees);
}

fn lowerAlloc(a: Allocator, s: []const u8) ![]u8 {
    const out = try a.alloc(u8, s.len);
    for (s, 0..) |c, i| out[i] = std.ascii.toLower(c);
    return out;
}

fn padStart2(a: Allocator, n: i64) ![]u8 {
    return if (n >= 10)
        std.fmt.allocPrint(a, "{d}", .{n})
    else
        std.fmt.allocPrint(a, "0{d}", .{n});
}

pub fn runBenchmark() void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    doTheWork(arena.allocator()) catch {};
}

export fn bench_run() void {
    runBenchmark();
}













