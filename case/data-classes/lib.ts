/*
 * iOS Size Benchmark - Test Case Implementation
 * Generated with Claude AI (https://claude.ai)
 *
 * scriptc (TypeScript-to-native) port of the Kotlin `data-classes` case
 * (lib.kt is authoritative). Kotlin data classes become TS classes; the
 * auto-generated members (equals/hashCode/toString/copy/componentN) are
 * replicated ONLY where lib.kt actually exercises them, to keep parity:
 *   - copy: Person, Employee, Department, Order, UserProfile, Post,
 *           Comment, Product, Player
 *   - equals/hashCode/toString + destructuring: Person
 * A single exported entry (runBenchmark) constructs and uses every type and
 * logs results, preventing dead-code elimination (the scriptc analogue of
 * the Swift `public` requirement).
 */

// Deterministic RNG so the port is reproducible; mirrors Kotlin `(a..b).random()`
// which is inclusive on both ends. Values are irrelevant to size, only shape.
let rngSeed = 123456789;
function randInt(min: number, max: number): number {
  rngSeed = (rngSeed * 1103515245 + 12345) & 0x7fffffff;
  return min + (rngSeed % (max - min + 1));
}

// Collection helpers mirroring the Kotlin stdlib operators used below.
function groupBy<T, K>(items: T[], key: (t: T) => K): Map<K, T[]> {
  const m = new Map<K, T[]>();
  for (const it of items) {
    const k = key(it);
    const bucket = m.get(k);
    if (bucket === undefined) m.set(k, [it]);
    else bucket.push(it);
  }
  return m;
}

function distinct<T>(items: T[]): T[] {
  const seen = new Set<T>();
  const out: T[] = [];
  for (const it of items) {
    if (!seen.has(it)) { seen.add(it); out.push(it); }
  }
  return out;
}

function average(nums: number[]): number {
  if (nums.length === 0) return 0.0;
  let s = 0;
  for (const n of nums) s += n;
  return s / nums.length;
}
function hashString(s: string): number {
  let h = 0;
  for (let i = 0; i < s.length; i++) {
    h = (h * 31 + s.charCodeAt(i)) | 0;
  }
  return h;
}

// Simple data classes - minimal code for maximum functionality
class Person {
  constructor(
    readonly id: string,
    readonly firstName: string,
    readonly lastName: string,
    readonly age: number,
    readonly email: string,
  ) {}

  get fullName(): string { return `${this.firstName} ${this.lastName}`; }
  get isAdult(): boolean { return this.age >= 18; }

  copy(opts: { id?: string; firstName?: string; lastName?: string; age?: number; email?: string }): Person {
    return new Person(
      opts.id ?? this.id,
      opts.firstName ?? this.firstName,
      opts.lastName ?? this.lastName,
      opts.age ?? this.age,
      opts.email ?? this.email,
    );
  }

  equals(other: Person): boolean {
    return this.id === other.id && this.firstName === other.firstName &&
      this.lastName === other.lastName && this.age === other.age && this.email === other.email;
  }

  hashCode(): number {
    let h = hashString(this.id);
    h = (h * 31 + hashString(this.firstName)) | 0;
    h = (h * 31 + hashString(this.lastName)) | 0;
    h = (h * 31 + this.age) | 0;
    h = (h * 31 + hashString(this.email)) | 0;
    return h;
  }

  toString(): string {
    return `Person(id=${this.id}, firstName=${this.firstName}, lastName=${this.lastName}, age=${this.age}, email=${this.email})`;
  }
}

class Address {
  constructor(
    readonly street: string,
    readonly city: string,
    readonly state: string,
    readonly zipCode: string,
    readonly country: string,
  ) {}

  get shortAddress(): string { return `${this.city}, ${this.state}`; }
  get isUSA(): boolean { return this.country.toLowerCase() === "usa"; }
}

class ContactInfo {
  constructor(
    readonly primaryEmail: string,
    readonly secondaryEmail: string | null = null,
    readonly phoneNumber: string | null = null,
    readonly address: Address | null = null,
  ) {}

  get hasMultipleEmails(): boolean { return this.secondaryEmail !== null; }
  get hasCompleteInfo(): boolean { return this.phoneNumber !== null && this.address !== null; }
}
// Complex nested data structures
class Employee {
  constructor(
    readonly id: string,
    readonly person: Person,
    readonly contactInfo: ContactInfo,
    readonly department: string,
    readonly position: string,
    readonly salary: number,
    readonly startDate: string,
    readonly manager: string | null = null,
    readonly isActive: boolean = true,
  ) {}

  get displayName(): string { return `${this.person.fullName} (${this.department})`; }
  get isManager(): boolean { return this.manager === null; }
  get yearsOfService(): number {
    const parsed = parseInt(this.startDate.substring(0, 4), 10);
    return 2024 - (isNaN(parsed) ? 2024 : parsed);
  }

  copy(opts: {
    id?: string; person?: Person; contactInfo?: ContactInfo; department?: string;
    position?: string; salary?: number; startDate?: string; manager?: string | null; isActive?: boolean;
  }): Employee {
    return new Employee(
      opts.id ?? this.id,
      opts.person ?? this.person,
      opts.contactInfo ?? this.contactInfo,
      opts.department ?? this.department,
      opts.position ?? this.position,
      opts.salary ?? this.salary,
      opts.startDate ?? this.startDate,
      opts.manager !== undefined ? opts.manager : this.manager,
      opts.isActive ?? this.isActive,
    );
  }
}

class Department {
  constructor(
    readonly id: string,
    readonly name: string,
    readonly description: string,
    readonly budget: number,
    readonly manager: Employee,
    readonly employees: Employee[],
  ) {}

  get totalSalaryBudget(): number { let s = 0; for (const e of this.employees) s += e.salary; return s; }
  get employeeCount(): number { return this.employees.length; }
  get averageSalary(): number { return this.employees.length > 0 ? this.totalSalaryBudget / this.employees.length : 0.0; }

  copy(opts: {
    id?: string; name?: string; description?: string; budget?: number;
    manager?: Employee; employees?: Employee[];
  }): Department {
    return new Department(
      opts.id ?? this.id,
      opts.name ?? this.name,
      opts.description ?? this.description,
      opts.budget ?? this.budget,
      opts.manager ?? this.manager,
      opts.employees ?? this.employees,
    );
  }
}

class Company {
  constructor(
    readonly id: string,
    readonly name: string,
    readonly headquarters: Address,
    readonly departments: Department[],
    readonly foundedYear: number,
    readonly website: string | null = null,
  ) {}

  get totalEmployees(): number { let s = 0; for (const d of this.departments) s += d.employeeCount; return s; }
  get totalBudget(): number { let s = 0; for (const d of this.departments) s += d.budget; return s; }
  get companyAge(): number { return 2024 - this.foundedYear; }
}
// Financial data structures
class Transaction {
  constructor(
    readonly id: string,
    readonly amount: number,
    readonly currency: string,
    readonly timestamp: number,
    readonly description: string,
    readonly category: string,
    readonly tags: string[] = [],
  ) {}

  get isExpense(): boolean { return this.amount < 0; }
  get isIncome(): boolean { return this.amount > 0; }
  get formattedAmount(): string {
    return `${this.amount >= 0 ? "+" : ""}${Math.trunc(this.amount * 100) / 100.0} ${this.currency}`;
  }
}

class Account {
  constructor(
    readonly id: string,
    readonly accountNumber: string,
    readonly accountType: string,
    readonly balance: number,
    readonly currency: string,
    readonly owner: Person,
    readonly transactions: Transaction[],
  ) {}

  get totalIncome(): number { let s = 0; for (const t of this.transactions) if (t.isIncome) s += t.amount; return s; }
  get totalExpenses(): number { let s = 0; for (const t of this.transactions) if (t.isExpense) s += t.amount; return s; }
  get transactionCount(): number { return this.transactions.length; }
}

class Budget {
  constructor(
    readonly id: string,
    readonly name: string,
    readonly totalAmount: number,
    readonly currency: string,
    readonly categories: Map<string, number>,
    readonly period: string,
    readonly owner: Person,
  ) {}

  get allocatedAmount(): number { let s = 0; for (const v of this.categories.values()) s += v; return s; }
  get remainingAmount(): number { return this.totalAmount - this.allocatedAmount; }
  get isOverBudget(): boolean { return this.allocatedAmount > this.totalAmount; }
}

// E-commerce data structures
class Product {
  constructor(
    readonly id: string,
    readonly name: string,
    readonly description: string,
    readonly price: number,
    readonly currency: string,
    readonly category: string,
    readonly tags: string[],
    readonly inStock: boolean,
    readonly stockQuantity: number,
  ) {}

  get isAvailable(): boolean { return this.inStock && this.stockQuantity > 0; }
  get formattedPrice(): string { return `${Math.trunc(this.price * 100) / 100.0} ${this.currency}`; }
  get isOnSale(): boolean { return this.tags.indexOf("sale") >= 0; }

  copy(opts: {
    id?: string; name?: string; description?: string; price?: number; currency?: string;
    category?: string; tags?: string[]; inStock?: boolean; stockQuantity?: number;
  }): Product {
    return new Product(
      opts.id ?? this.id,
      opts.name ?? this.name,
      opts.description ?? this.description,
      opts.price ?? this.price,
      opts.currency ?? this.currency,
      opts.category ?? this.category,
      opts.tags ?? this.tags,
      opts.inStock ?? this.inStock,
      opts.stockQuantity ?? this.stockQuantity,
    );
  }
}
class CartItem {
  constructor(
    readonly product: Product,
    readonly quantity: number,
    readonly selectedVariant: string | null = null,
  ) {}

  get totalPrice(): number { return this.product.price * this.quantity; }
  get isValidQuantity(): boolean { return this.quantity > 0 && this.quantity <= this.product.stockQuantity; }
}

class ShoppingCart {
  constructor(
    readonly id: string,
    readonly userId: string,
    readonly items: CartItem[],
    readonly discountCode: string | null = null,
    readonly discountAmount: number = 0.0,
  ) {}

  get subtotal(): number { let s = 0; for (const i of this.items) s += i.totalPrice; return s; }
  get total(): number { return this.subtotal - this.discountAmount; }
  get itemCount(): number { let s = 0; for (const i of this.items) s += i.quantity; return s; }
  get hasDiscount(): boolean { return this.discountCode !== null && this.discountAmount > 0; }
}

class Order {
  constructor(
    readonly id: string,
    readonly userId: string,
    readonly cart: ShoppingCart,
    readonly shippingAddress: Address,
    readonly billingAddress: Address,
    readonly paymentMethod: string,
    readonly orderDate: string,
    readonly status: string,
  ) {}

  get orderTotal(): number { return this.cart.total; }
  get isShipped(): boolean { return this.status === "shipped" || this.status === "delivered"; }
  get isCompleted(): boolean { return this.status === "delivered"; }
  get itemSummary(): string { return `${this.cart.itemCount} items totaling ${this.cart.total}`; }

  copy(opts: {
    id?: string; userId?: string; cart?: ShoppingCart; shippingAddress?: Address;
    billingAddress?: Address; paymentMethod?: string; orderDate?: string; status?: string;
  }): Order {
    return new Order(
      opts.id ?? this.id,
      opts.userId ?? this.userId,
      opts.cart ?? this.cart,
      opts.shippingAddress ?? this.shippingAddress,
      opts.billingAddress ?? this.billingAddress,
      opts.paymentMethod ?? this.paymentMethod,
      opts.orderDate ?? this.orderDate,
      opts.status ?? this.status,
    );
  }
}
// Gaming/Entertainment data structures
class Player {
  constructor(
    readonly id: string,
    readonly username: string,
    readonly email: string,
    readonly level: number,
    readonly experience: number,
    readonly achievements: string[],
    readonly joinDate: string,
  ) {}

  get experienceToNextLevel(): number { return ((this.level + 1) * 1000) - this.experience; }
  get achievementCount(): number { return this.achievements.length; }
  get isVeteran(): boolean { return this.achievements.indexOf("veteran") >= 0; }

  copy(opts: {
    id?: string; username?: string; email?: string; level?: number;
    experience?: number; achievements?: string[]; joinDate?: string;
  }): Player {
    return new Player(
      opts.id ?? this.id,
      opts.username ?? this.username,
      opts.email ?? this.email,
      opts.level ?? this.level,
      opts.experience ?? this.experience,
      opts.achievements ?? this.achievements,
      opts.joinDate ?? this.joinDate,
    );
  }
}

class GameSession {
  constructor(
    readonly id: string,
    readonly player: Player,
    readonly gameMode: string,
    readonly score: number,
    readonly duration: number,
    readonly timestamp: number,
    readonly achievements: string[] = [],
  ) {}

  get scorePerMinute(): number { return this.duration > 0 ? this.score / (this.duration / 60000.0) : 0.0; }
  get hasNewAchievements(): boolean { return this.achievements.length > 0; }
  get durationInMinutes(): number { return Math.trunc(this.duration / 60000); }
}

class LeaderboardEntry {
  constructor(
    readonly rank: number,
    readonly player: Player,
    readonly score: number,
    readonly gamesPlayed: number,
  ) {}

  get averageScorePerGame(): number { return this.gamesPlayed > 0 ? this.score / this.gamesPlayed : 0.0; }
  get isTopTen(): boolean { return this.rank <= 10; }
}

class Leaderboard {
  constructor(
    readonly gameMode: string,
    readonly period: string,
    readonly entries: LeaderboardEntry[],
    readonly lastUpdated: number,
  ) {}

  get topPlayer(): LeaderboardEntry | null { return this.entries.length > 0 ? this.entries[0] : null; }
  get entryCount(): number { return this.entries.length; }
  get averageScore(): number {
    if (this.entries.length === 0) return 0.0;
    let s = 0; for (const e of this.entries) s += e.score;
    return s / this.entries.length;
  }
}
// Social media data structures
class Comment {
  constructor(
    readonly id: string,
    readonly author: Person,
    readonly content: string,
    readonly timestamp: number,
    readonly likes: number,
    readonly replies: Comment[] = [],
  ) {}

  get hasReplies(): boolean { return this.replies.length > 0; }
  get totalReplies(): number { let s = this.replies.length; for (const r of this.replies) s += r.totalReplies; return s; }

  copy(opts: {
    id?: string; author?: Person; content?: string; timestamp?: number; likes?: number; replies?: Comment[];
  }): Comment {
    return new Comment(
      opts.id ?? this.id,
      opts.author ?? this.author,
      opts.content ?? this.content,
      opts.timestamp ?? this.timestamp,
      opts.likes ?? this.likes,
      opts.replies ?? this.replies,
    );
  }
}

class Post {
  constructor(
    readonly id: string,
    readonly author: Person,
    readonly content: string,
    readonly timestamp: number,
    readonly likes: number,
    readonly comments: Comment[],
    readonly tags: string[],
    readonly isPublic: boolean = true,
  ) {}

  get commentCount(): number { return this.comments.length; }
  get hasHashtags(): boolean { return this.tags.length > 0; }
  get isPopular(): boolean { return this.likes > 100 || this.comments.length > 50; }

  copy(opts: {
    id?: string; author?: Person; content?: string; timestamp?: number; likes?: number;
    comments?: Comment[]; tags?: string[]; isPublic?: boolean;
  }): Post {
    return new Post(
      opts.id ?? this.id,
      opts.author ?? this.author,
      opts.content ?? this.content,
      opts.timestamp ?? this.timestamp,
      opts.likes ?? this.likes,
      opts.comments ?? this.comments,
      opts.tags ?? this.tags,
      opts.isPublic ?? this.isPublic,
    );
  }
}

class UserProfile {
  constructor(
    readonly person: Person,
    readonly bio: string,
    readonly profilePicture: string | null,
    readonly followers: string[],
    readonly following: string[],
    readonly posts: Post[],
  ) {}

  get followerCount(): number { return this.followers.length; }
  get followingCount(): number { return this.following.length; }
  get postCount(): number { return this.posts.length; }
  get totalLikes(): number { let s = 0; for (const p of this.posts) s += p.likes; return s; }
  get isVerified(): boolean { return this.followerCount > 10000; }

  copy(opts: {
    person?: Person; bio?: string; profilePicture?: string | null;
    followers?: string[]; following?: string[]; posts?: Post[];
  }): UserProfile {
    return new UserProfile(
      opts.person ?? this.person,
      opts.bio ?? this.bio,
      opts.profilePicture !== undefined ? opts.profilePicture : this.profilePicture,
      opts.followers ?? this.followers,
      opts.following ?? this.following,
      opts.posts ?? this.posts,
    );
  }
}
// Configuration and settings data structures
class NotificationSettings {
  constructor(
    readonly emailNotifications: boolean,
    readonly pushNotifications: boolean,
    readonly smsNotifications: boolean,
    readonly marketingEmails: boolean,
    readonly securityAlerts: boolean,
  ) {}

  get hasAnyNotificationsEnabled(): boolean {
    return this.emailNotifications || this.pushNotifications || this.smsNotifications ||
      this.marketingEmails || this.securityAlerts;
  }
  get notificationCount(): number {
    let c = 0;
    for (const b of [this.emailNotifications, this.pushNotifications, this.smsNotifications, this.marketingEmails, this.securityAlerts]) if (b) c++;
    return c;
  }
}

class PrivacySettings {
  constructor(
    readonly profileVisibility: string,
    readonly dataSharing: boolean,
    readonly analytics: boolean,
    readonly advertising: boolean,
    readonly locationTracking: boolean,
  ) {}

  get isPrivacyFocused(): boolean { return !this.dataSharing && !this.analytics && !this.advertising && !this.locationTracking; }
  get privacyScore(): number {
    let c = 0;
    for (const b of [this.dataSharing, this.analytics, this.advertising, this.locationTracking]) if (!b) c++;
    return c;
  }
}

class DisplaySettings {
  constructor(
    readonly fontSize: string,
    readonly colorScheme: string,
    readonly animation: boolean,
    readonly autoPlay: boolean,
    readonly highContrast: boolean,
  ) {}

  get isAccessibilityFriendly(): boolean { return this.fontSize === "large" || this.fontSize === "extra-large" || this.highContrast; }
  get isPerformanceOptimized(): boolean { return !this.animation && !this.autoPlay; }
}

class AppSettings {
  constructor(
    readonly theme: string,
    readonly language: string,
    readonly notifications: NotificationSettings,
    readonly privacy: PrivacySettings,
    readonly display: DisplaySettings,
  ) {}
}
// Data processing and analysis classes.
// Kotlin returns Map<String, Any>; the static tier forbids `any`, so each
// method performs the identical aggregation and returns a summary string so
// the computed values stay observably used (printed by runBenchmark).
class DataClassProcessor {
  processPersonData(persons: Person[]): string {
    const totalPersons = persons.length;
    let adults = 0;
    for (const p of persons) if (p.isAdult) adults++;
    const averageAge = average(persons.map((p) => p.age));
    const byFirst = groupBy(persons, (p) => p.firstName);
    const firstNameCounts: Array<[string, number]> = [];
    for (const [k, v] of byFirst) firstNameCounts.push([k, v.length]);
    firstNameCounts.sort((a, b) => b[1] - a[1]);
    const commonFirstNames = firstNameCounts.slice(0, 5);
    const emailDomains = distinct(persons.map((p) => {
      const idx = p.email.indexOf("@");
      return idx >= 0 ? p.email.substring(idx + 1) : p.email;
    }));
    return `persons=${totalPersons},adults=${adults},avgAge=${averageAge},names=${commonFirstNames.length},domains=${emailDomains.length}`;
  }

  analyzeEmployeeData(employees: Employee[]): string {
    const totalEmployees = employees.length;
    let activeEmployees = 0;
    for (const e of employees) if (e.isActive) activeEmployees++;
    const departments = groupBy(employees, (e) => e.department);
    const averageSalary = average(employees.map((e) => e.salary));
    const salaryRanges = groupBy(employees, (e) => {
      if (e.salary < 50000) return "Under 50K";
      if (e.salary < 100000) return "50K-100K";
      if (e.salary < 150000) return "100K-150K";
      return "150K+";
    });
    let managers = 0;
    for (const e of employees) if (e.isManager) managers++;
    return `emps=${totalEmployees},active=${activeEmployees},depts=${departments.size},avgSalary=${averageSalary},ranges=${salaryRanges.size},mgrs=${managers}`;
  }

  processTransactionData(transactions: Transaction[]): string {
    const totalTransactions = transactions.length;
    let totalIncome = 0;
    let totalExpenses = 0;
    for (const t of transactions) {
      if (t.isIncome) totalIncome += t.amount;
      if (t.isExpense) totalExpenses += t.amount;
    }
    const byCategory = groupBy(transactions, (t) => t.category);
    let categoryAgg = 0;
    for (const [, group] of byCategory) {
      let total = 0;
      for (const t of group) total += t.amount;
      categoryAgg += group.length + total;
    }
    const averageTransaction = average(transactions.map((t) => t.amount));
    const currencies = distinct(transactions.map((t) => t.currency));
    return `txns=${totalTransactions},income=${totalIncome},expenses=${totalExpenses},cats=${byCategory.size},catAgg=${categoryAgg},avg=${averageTransaction},currencies=${currencies.length}`;
  }
  analyzeShoppingData(carts: ShoppingCart[]): string {
    const allItems: CartItem[] = [];
    for (const c of carts) for (const i of c.items) allItems.push(i);
    const averageCartValue = average(carts.map((c) => c.total));
    const averageItemsPerCart = average(carts.map((c) => c.itemCount));
    let cartsWithDiscount = 0;
    for (const c of carts) if (c.hasDiscount) cartsWithDiscount++;
    let totalDiscountAmount = 0;
    for (const c of carts) totalDiscountAmount += c.discountAmount;
    const byProduct = groupBy(allItems, (i) => i.product.name);
    const popularProducts: Array<[string, number]> = [];
    for (const [k, v] of byProduct) {
      let q = 0;
      for (const i of v) q += i.quantity;
      popularProducts.push([k, q]);
    }
    popularProducts.sort((a, b) => b[1] - a[1]);
    let totalRevenue = 0;
    for (const c of carts) totalRevenue += c.total;
    return `carts=${carts.length},avgValue=${averageCartValue},avgItems=${averageItemsPerCart},disc=${cartsWithDiscount},discAmt=${totalDiscountAmount},popular=${popularProducts.slice(0, 10).length},revenue=${totalRevenue}`;
  }

  processGameData(sessions: GameSession[]): string {
    const totalSessions = sessions.length;
    const uniquePlayers = distinct(sessions.map((s) => s.player.id)).length;
    const averageScore = average(sessions.map((s) => s.score));
    const averageDuration = average(sessions.map((s) => s.durationInMinutes));
    const gameModes = groupBy(sessions, (s) => s.gameMode);
    const topScores = sessions.slice().sort((a, b) => b.score - a.score).slice(0, 10);
    let sessionsWithAchievements = 0;
    for (const s of sessions) if (s.hasNewAchievements) sessionsWithAchievements++;
    return `sessions=${totalSessions},players=${uniquePlayers},avgScore=${averageScore},avgDur=${averageDuration},modes=${gameModes.size},top=${topScores.length},achieve=${sessionsWithAchievements}`;
  }

  analyzeSocialData(profiles: UserProfile[]): string {
    const allPosts: Post[] = [];
    for (const p of profiles) for (const post of p.posts) allPosts.push(post);
    const totalUsers = profiles.length;
    let verifiedUsers = 0;
    for (const p of profiles) if (p.isVerified) verifiedUsers++;
    const totalPosts = allPosts.length;
    let totalLikes = 0;
    let totalComments = 0;
    for (const post of allPosts) { totalLikes += post.likes; totalComments += post.commentCount; }
    const averageFollowers = average(profiles.map((p) => p.followerCount));
    const averagePostsPerUser = average(profiles.map((p) => p.postCount));
    const allTags: string[] = [];
    for (const post of allPosts) for (const t of post.tags) allTags.push(t);
    const tagGroups = groupBy(allTags, (t) => t);
    const popularTags: Array<[string, number]> = [];
    for (const [k, v] of tagGroups) popularTags.push([k, v.length]);
    popularTags.sort((a, b) => b[1] - a[1]);
    let publicPosts = 0;
    let popularPosts = 0;
    for (const post of allPosts) { if (post.isPublic) publicPosts++; if (post.isPopular) popularPosts++; }
    return `users=${totalUsers},verified=${verifiedUsers},posts=${totalPosts},likes=${totalLikes},comments=${totalComments},avgFollowers=${averageFollowers},avgPosts=${averagePostsPerUser},tags=${popularTags.slice(0, 20).length},public=${publicPosts},popular=${popularPosts}`;
  }
}
// Data transformation and manipulation
class DataTransformer {
  transformPersonToEmployee(person: Person, department: string, position: string, salary: number): Employee {
    return new Employee(
      `EMP_${person.id}`,
      person,
      new ContactInfo(person.email),
      department,
      position,
      salary,
      "2024-01-01",
    );
  }

  mergeContactInfo(info1: ContactInfo, info2: ContactInfo): ContactInfo {
    return new ContactInfo(
      info1.primaryEmail,
      info1.secondaryEmail ?? info2.secondaryEmail,
      info1.phoneNumber ?? info2.phoneNumber,
      info1.address ?? info2.address,
    );
  }

  aggregateTransactions(transactions: Transaction[], groupByKey: string): Transaction[] {
    if (groupByKey === "category") {
      const grouped = groupBy(transactions, (t) => t.category);
      const out: Transaction[] = [];
      for (const [category, txns] of grouped) {
        let amount = 0;
        let maxTs = txns[0].timestamp;
        const tags: string[] = [];
        for (const t of txns) { amount += t.amount; if (t.timestamp > maxTs) maxTs = t.timestamp; for (const g of t.tags) tags.push(g); }
        out.push(new Transaction(`AGG_${category}_${txns.length}`, amount, txns[0].currency, maxTs, `Aggregated ${category} transactions`, category, distinct(tags)));
      }
      return out;
    } else if (groupByKey === "currency") {
      const grouped = groupBy(transactions, (t) => t.currency);
      const out: Transaction[] = [];
      for (const [currency, txns] of grouped) {
        let amount = 0;
        let maxTs = txns[0].timestamp;
        const tags: string[] = [];
        for (const t of txns) { amount += t.amount; if (t.timestamp > maxTs) maxTs = t.timestamp; for (const g of t.tags) tags.push(g); }
        out.push(new Transaction(`AGG_${currency}_${txns.length}`, amount, currency, maxTs, `Aggregated ${currency} transactions`, "aggregated", distinct(tags)));
      }
      return out;
    }
    return transactions;
  }

  createOrderFromCart(cart: ShoppingCart, user: Person, shippingAddress: Address): Order {
    return new Order(
      `ORDER_${cart.id}`,
      cart.userId,
      cart,
      shippingAddress,
      shippingAddress,
      "credit_card",
      "2024-01-01",
      "pending",
    );
  }

  updatePlayerProgress(player: Player, session: GameSession): Player {
    const newExperience = player.experience + Math.trunc(session.score / 10);
    const newLevel = Math.trunc(newExperience / 1000);
    const newAchievements = distinct(player.achievements.concat(session.achievements));
    return player.copy({
      level: Math.max(player.level, newLevel),
      experience: newExperience,
      achievements: newAchievements,
    });
  }
}
function padStart2(s: string): string {
  return s.length >= 2 ? s : "0".repeat(2 - s.length) + s;
}

function endsWith(s: string, suffix: string): boolean {
  if (suffix.length > s.length) return false;
  return s.substring(s.length - suffix.length) === suffix;
}

function zip<A, B>(a: A[], b: B[]): Array<[A, B]> {
  const n = Math.min(a.length, b.length);
  const out: Array<[A, B]> = [];
  for (let i = 0; i < n; i++) out.push([a[i], b[i]]);
  return out;
}

// Main benchmark class
class IosSizeBenchmark {
  private readonly processor = new DataClassProcessor();
  private readonly transformer = new DataTransformer();

  runBenchmark(): void {
    const persons = [
      new Person("1", "John", "Doe", 30, "john.doe@example.com"),
      new Person("2", "Jane", "Smith", 25, "jane.smith@test.com"),
      new Person("3", "Bob", "Johnson", 35, "bob.johnson@company.org"),
      new Person("4", "Alice", "Brown", 28, "alice.brown@email.net"),
      new Person("5", "Charlie", "Wilson", 42, "charlie.wilson@work.com"),
    ];

    const addresses = [
      new Address("123 Main St", "New York", "NY", "10001", "USA"),
      new Address("456 Oak Ave", "Los Angeles", "CA", "90210", "USA"),
      new Address("789 Pine Rd", "Chicago", "IL", "60601", "USA"),
    ];

    const contactInfos = zip(persons, addresses).map(
      ([person, address]) => new ContactInfo(person.email, null, "+1234567890", address),
    );

    const employees = zip(persons, contactInfos).map(([person, contact], index) =>
      new Employee(
        `EMP_${person.id}`,
        person,
        contact,
        ["Engineering", "Marketing", "Sales", "HR", "Finance"][index % 5],
        ["Developer", "Manager", "Analyst", "Specialist", "Director"][index % 5],
        50000.0 + index * 15000,
        `202${index + 1}-01-01`,
      ),
    );

    const deptGroups = groupBy(employees, (e) => e.department);
    const departments: Department[] = [];
    for (const [deptName, deptEmployees] of deptGroups) {
      departments.push(new Department(
        `DEPT_${deptName.split(" ").join("_").toUpperCase()}`,
        deptName,
        `${deptName} department`,
        deptEmployees.length * 100000.0,
        deptEmployees[0],
        deptEmployees,
      ));
    }

    const company = new Company(
      "COMPANY_001",
      "Tech Solutions Inc",
      addresses[0],
      departments,
      2010,
      "https://techsolutions.com",
    );
    // Financial data
    const transactions: Transaction[] = [];
    for (let i = 1; i <= 100; i++) {
      transactions.push(new Transaction(
        `TXN_${i}`,
        i % 3 === 0 ? -(50.0 + i * 10) : (100.0 + i * 5),
        i % 10 === 0 ? "EUR" : "USD",
        1640995200000 - i * 86400000,
        `Transaction ${i}`,
        ["food", "transportation", "entertainment", "utilities", "salary"][i % 5],
        i % 5 === 0 ? ["recurring", "essential"] : [],
      ));
    }

    const accounts = persons.map((person, index) =>
      new Account(
        `ACC_${person.id}`,
        `12345${index}890`,
        index % 2 === 0 ? "checking" : "savings",
        1000.0 + index * 500,
        "USD",
        person,
        transactions.filter((t) => endsWith(t.id, `${index}`)),
      ),
    );

    const budgets = persons.map((person, index) => {
      const categories = new Map<string, number>();
      categories.set("housing", 1200.0);
      categories.set("food", 400.0);
      categories.set("transportation", 300.0);
      categories.set("entertainment", 200.0);
      categories.set("savings", 500.0);
      return new Budget(
        `BUDGET_${person.id}`,
        `${person.firstName}'s Monthly Budget`,
        3000.0 + index * 500,
        "USD",
        categories,
        "monthly",
        person,
      );
    });

    // E-commerce data
    const products: Product[] = [];
    for (let i = 1; i <= 50; i++) {
      products.push(new Product(
        `PROD_${i}`,
        `Product ${i}`,
        `Description for product ${i}`,
        10.0 + i * 5,
        "USD",
        ["electronics", "clothing", "books", "home", "sports"][i % 5],
        i % 10 === 0 ? ["sale", "featured"] : (i % 7 === 0 ? ["new"] : []),
        i % 15 !== 0,
        i % 15 === 0 ? 0 : i * 2,
      ));
    }

    const cartItems = products.slice(0, 10).map((product, index) => new CartItem(product, index + 1));

    const shoppingCarts = persons.map((person, index) =>
      new ShoppingCart(
        `CART_${person.id}`,
        person.id,
        cartItems.slice(0, index + 2),
        index % 3 === 0 ? "SAVE10" : null,
        index % 3 === 0 ? 10.0 : 0.0,
      ),
    );

    const orders = zip(zip(shoppingCarts, persons), addresses).map(([[cart, person], address]) =>
      this.transformer.createOrderFromCart(cart, person, address),
    );
    // Gaming data
    const players = persons.map((person) =>
      new Player(
        `PLAYER_${person.id}`,
        `${person.firstName.toLowerCase()}_${person.lastName.toLowerCase()}`,
        person.email,
        randInt(1, 50),
        randInt(100, 49000),
        ["first_login", "score_1000", "veteran", "champion"].slice(0, randInt(0, 4)),
        `202${randInt(0, 3)}-${padStart2(`${randInt(1, 12)}`)}-01`,
      ),
    );

    const gameSessions: GameSession[] = [];
    for (let i = 1; i <= 200; i++) {
      gameSessions.push(new GameSession(
        `SESSION_${i}`,
        players[i % players.length],
        ["classic", "arcade", "tournament", "practice"][i % 4],
        randInt(100, 10000),
        randInt(60000, 3600000),
        1640995200000 - i * 3600000,
        i % 20 === 0 ? ["high_score"] : [],
      ));
    }

    const leaderboardEntries = players.map((player, index) =>
      new LeaderboardEntry(index + 1, player, randInt(1000, 9999), randInt(10, 100)),
    );

    const leaderboard = new Leaderboard(
      "classic",
      "weekly",
      leaderboardEntries.slice().sort((a, b) => b.score - a.score),
      1640995200000,
    );

    // Social media data
    const comments: Comment[] = [];
    for (let i = 1; i <= 50; i++) {
      comments.push(new Comment(
        `COMMENT_${i}`,
        persons[i % persons.length],
        `This is comment ${i}`,
        1640995200000 - i * 60000,
        randInt(0, 100),
      ));
    }

    const posts: Post[] = [];
    for (let i = 1; i <= 30; i++) {
      posts.push(new Post(
        `POST_${i}`,
        persons[i % persons.length],
        `This is post ${i} with some interesting content`,
        1640995200000 - i * 3600000,
        randInt(0, 1000),
        comments.filter((c) => endsWith(c.id, `${i % 10}`)),
        i % 5 === 0 ? ["tech", "programming"] : (i % 3 === 0 ? ["life", "thoughts"] : []),
      ));
    }

    const userProfiles = persons.map((person) => {
      const followers: string[] = [];
      for (let it = 1; it <= 1000; it++) followers.push(`follower_${it}`);
      const following: string[] = [];
      for (let it = 1; it <= 500; it++) following.push(`following_${it}`);
      return new UserProfile(
        person,
        `Bio for ${person.fullName}`,
        `profile_${person.id}.jpg`,
        followers.slice(0, randInt(10, 1000)),
        following.slice(0, randInt(5, 500)),
        posts.filter((p) => p.author.id === person.id),
      );
    });

    // Settings data
    const appSettings = new AppSettings(
      "dark",
      "en",
      new NotificationSettings(true, true, false, false, true),
      new PrivacySettings("public", false, false, false, true),
      new DisplaySettings("medium", "auto", true, false, false),
    );
    // Process all data using data class methods
    const personStats = this.processor.processPersonData(persons);
    const employeeStats = this.processor.analyzeEmployeeData(employees);
    const transactionStats = this.processor.processTransactionData(transactions);
    const shoppingStats = this.processor.analyzeShoppingData(shoppingCarts);
    const gameStats = this.processor.processGameData(gameSessions);
    const socialStats = this.processor.analyzeSocialData(userProfiles);

    // Test data class features - copy, equals, hashCode, toString
    const originalPerson = persons[0];
    const modifiedPerson = originalPerson.copy({ age: originalPerson.age + 1 });
    const isEqual = originalPerson.equals(modifiedPerson);
    const hashCodesEqual = originalPerson.hashCode() === modifiedPerson.hashCode();
    const personString = originalPerson.toString();

    // Test destructuring
    const { id, firstName, lastName, age, email } = originalPerson;
    const fullNameFromDestructuring = `${firstName} ${lastName}`;

    // Complex object operations
    const departmentCopy = departments[0].copy({
      employees: departments[0].employees.map((emp) => emp.copy({ salary: emp.salary * 1.1 })),
    });

    const orderWithUpdatedStatus = orders[0].copy({ status: "shipped" });

    // Nested data manipulation
    const baseProfile = userProfiles[0];
    const updatedUserProfile = baseProfile.copy({
      posts: baseProfile.posts.map((post) =>
        post.copy({ comments: post.comments.map((comment) => comment.copy({ likes: comment.likes + 1 })) }),
      ),
    });

    // Aggregate computations using data class properties
    const totalCompanyValue = company.totalBudget;
    const allSalaries: number[] = [];
    for (const d of company.departments) for (const e of d.employees) allSalaries.push(e.salary);
    const averageEmployeeSalary = average(allSalaries);
    let totalOrders = 0;
    for (const o of orders) totalOrders += o.orderTotal;
    let topGameScore = 0;
    for (const s of gameSessions) if (s.score > topGameScore) topGameScore = s.score;
    let totalSocialEngagement = 0;
    for (const p of userProfiles) totalSocialEngagement += p.totalLikes;

    // Data validation using computed properties
    const validEmployees = employees.filter((e) => e.person.isAdult && e.salary > 0);
    const availableProducts = products.filter((p) => p.isAvailable);
    const completedOrders = orders.filter((o) => o.isCompleted);
    const activeGameSessions = gameSessions.filter((s) => s.duration > 60000);
    const popularPosts = posts.filter((p) => p.isPopular);

    // Complex transformations
    const employeePromotions = employees.map((emp) =>
      emp.yearsOfService > 2
        ? emp.copy({ position: `Senior ${emp.position}`, salary: emp.salary * 1.2 })
        : emp,
    );

    const discountedProducts = products.map((product) =>
      product.isOnSale ? product.copy({ price: product.price * 0.9 }) : product,
    );

    const updatedPlayers = players.map((player) => {
      const playerSessions = gameSessions.filter((s) => s.player.id === player.id);
      let currentPlayer = player;
      for (const session of playerSessions) {
        currentPlayer = this.transformer.updatePlayerProgress(currentPlayer, session);
      }
      return currentPlayer;
    });

    // Exercise transformer branches + remaining types so nothing is stripped.
    const aggByCategory = this.transformer.aggregateTransactions(transactions, "category");
    const aggByCurrency = this.transformer.aggregateTransactions(transactions, "currency");
    const promoted = this.transformer.transformPersonToEmployee(persons[0], "Engineering", "Lead", 123000.0);
    const merged = this.transformer.mergeContactInfo(contactInfos[0], contactInfos[1]);

    console.log("Data classes benchmark completed:");
    console.log(`- Persons: ${persons.length}, personStats: ${personStats}`);
    console.log(`- Employees: ${employees.length}, employeeStats: ${employeeStats}`);
    console.log(`- Company: ${company.name}, totalEmployees=${company.totalEmployees}, age=${company.companyAge}`);
    console.log(`- Transactions: ${transactions.length}, transactionStats: ${transactionStats}`);
    console.log(`- Accounts: ${accounts.length}, firstIncome=${accounts[0].totalIncome}, firstExpenses=${accounts[0].totalExpenses}`);
    console.log(`- Budgets: ${budgets.length}, firstAllocated=${budgets[0].allocatedAmount}, over=${budgets[0].isOverBudget}`);
    console.log(`- Products: ${products.length}, available=${availableProducts.length}, shoppingStats: ${shoppingStats}`);
    console.log(`- Orders: ${orders.length}, completed=${completedOrders.length}, totalOrders=${totalOrders}, updatedStatus=${orderWithUpdatedStatus.status}`);
    console.log(`- Game: sessions=${gameSessions.length}, active=${activeGameSessions.length}, top=${topGameScore}, gameStats: ${gameStats}`);
    console.log(`- Leaderboard: entries=${leaderboard.entryCount}, avg=${leaderboard.averageScore}, top=${leaderboard.topPlayer !== null}`);
    console.log(`- Social: profiles=${userProfiles.length}, popularPosts=${popularPosts.length}, engagement=${totalSocialEngagement}, socialStats: ${socialStats}`);
    console.log(`- Settings: theme=${appSettings.theme}, notif=${appSettings.notifications.notificationCount}, privacy=${appSettings.privacy.privacyScore}, display=${appSettings.display.isAccessibilityFriendly}`);
    console.log(`- Features: equal=${isEqual}, hashEq=${hashCodesEqual}, str=${personString.length}, destruct=${fullNameFromDestructuring}, id=${id}, lastName=${lastName}, age=${age}, email=${email.length}`);
    console.log(`- Transforms: deptCopySalary=${departmentCopy.totalSalaryBudget}, profilePosts=${updatedUserProfile.postCount}, companyValue=${totalCompanyValue}, avgSalary=${averageEmployeeSalary}`);
    console.log(`- More: promotions=${employeePromotions.length}, discounted=${discountedProducts.length}, updatedPlayers=${updatedPlayers.length}, aggCat=${aggByCategory.length}, aggCur=${aggByCurrency.length}, promoted=${promoted.id}, merged=${merged.hasMultipleEmails}`);
    console.log(`- Comments: ${comments.length}, carts=${shoppingCarts.length}, contactInfos=${contactInfos.length}, posts=${posts.length}`);
  }
}

export function runBenchmark(): void {
  const benchmark = new IosSizeBenchmark();
  benchmark.runBenchmark();
}
