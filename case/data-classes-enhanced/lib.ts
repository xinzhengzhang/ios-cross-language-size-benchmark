/*
 * iOS Size Benchmark - Test Case Implementation
 * Generated with Claude AI (https://claude.ai)
 *
 * scriptc (TypeScript-to-native) port of the Kotlin `data-classes-enhanced`
 * case (lib.kt is authoritative): complex nested data classes, a generic
 * OrderItem<T : Product>, and a sealed PaymentMethod hierarchy. Kotlin's
 * `Map<String, Any>` metadata becomes a `MetaValue` union (string | number |
 * boolean) since the static tier forbids `any`; the stored values are never
 * type-reflected, only carried, so this is behavior-preserving.
 *
 * Auto-generated data-class members are replicated only where lib.kt uses
 * them: copy on Customer / PersonalInfo / CustomerPreferences, and
 * destructuring on Customer / PersonalInfo / ContactInfo. A single exported
 * entry (runBenchmark) constructs and uses every type and logs results,
 * preventing dead-code elimination (the scriptc analogue of Swift `public`).
 */

type MetaValue = string | number | boolean;

// Deterministic RNG mirroring Kotlin `(a..b).random()` (inclusive).
let rngSeed = 987654321;
function randInt(min: number, max: number): number {
  rngSeed = (rngSeed * 1103515245 + 12345) & 0x7fffffff;
  return min + (rngSeed % (max - min + 1));
}

function padStart4(s: string): string {
  return s.length >= 4 ? s : "0".repeat(4 - s.length) + s;
}

function sum(nums: number[]): number {
  let s = 0;
  for (const n of nums) s += n;
  return s;
}

// 复杂嵌套数据结构
class Address {
  constructor(
    readonly street: string,
    readonly city: string,
    readonly coordinates: readonly [number, number],
    readonly metadata: Map<string, MetaValue> = new Map<string, MetaValue>(),
  ) {}
}
class ContactInfo {
  constructor(
    readonly emails: string[],
    readonly phones: Set<string>,
    readonly socialMedia: Map<string, string>,
    readonly preferences: Map<string, boolean> = new Map<string, boolean>([
      ["notifications", true],
      ["marketing", false],
    ]),
  ) {}
}

// 带计算属性的数据类
class Product {
  constructor(
    readonly id: number,
    readonly name: string,
    readonly category: string,
    readonly basePrice: number,
    readonly taxes: number[],
    readonly discounts: Map<string, number> = new Map<string, number>(),
    readonly tags: Set<string> = new Set<string>(),
  ) {}

  get finalPrice(): number {
    let discountSum = 0;
    for (const v of this.discounts.values()) discountSum += v;
    return this.basePrice + sum(this.taxes) - discountSum;
  }

  get displayName(): string {
    return this.tags.has("featured") ? `⭐ ${this.name}` : this.name;
  }
}

// 复杂泛型数据类
class OrderItem<T extends Product> {
  constructor(
    readonly product: T,
    readonly quantity: number,
    readonly customizations: Map<string, MetaValue>,
    readonly bundledItems: OrderItem<Product>[] = [],
  ) {}

  get totalPrice(): number {
    let bundled = 0;
    for (const b of this.bundledItems) bundled += b.totalPrice;
    return this.product.finalPrice * this.quantity + bundled;
  }
}

// 密封类和数据类结合
abstract class PaymentMethod {}

class CreditCard extends PaymentMethod {
  constructor(
    readonly number: string,
    readonly expiryMonth: number,
    readonly expiryYear: number,
    readonly securityCode: string,
    readonly billingAddress: Address,
  ) { super(); }
}

class BankTransfer extends PaymentMethod {
  constructor(
    readonly accountNumber: string,
    readonly routingNumber: string,
    readonly bankName: string,
  ) { super(); }
}

class DigitalWallet extends PaymentMethod {
  constructor(
    readonly provider: string,
    readonly accountId: string,
    readonly linkedCards: CreditCard[],
  ) { super(); }
}

class Cash extends PaymentMethod {}
class PersonalInfo {
  constructor(
    readonly firstName: string,
    readonly lastName: string,
    readonly dateOfBirth: string,
    readonly nationality: string,
    readonly governmentIds: Map<string, string>,
  ) {}

  copy(opts: {
    firstName?: string; lastName?: string; dateOfBirth?: string;
    nationality?: string; governmentIds?: Map<string, string>;
  }): PersonalInfo {
    return new PersonalInfo(
      opts.firstName ?? this.firstName,
      opts.lastName ?? this.lastName,
      opts.dateOfBirth ?? this.dateOfBirth,
      opts.nationality ?? this.nationality,
      opts.governmentIds ?? this.governmentIds,
    );
  }
}

class LoyaltyProgram {
  constructor(
    readonly tier: string,
    readonly points: number,
    readonly benefits: Set<string>,
    readonly expiryDate: string | null,
  ) {}
}

class CustomerPreferences {
  constructor(
    readonly language: string,
    readonly currency: string,
    readonly timezone: string,
    readonly notifications: Map<string, boolean>,
    readonly privacy: Map<string, string>,
  ) {}

  copy(opts: {
    language?: string; currency?: string; timezone?: string;
    notifications?: Map<string, boolean>; privacy?: Map<string, string>;
  }): CustomerPreferences {
    return new CustomerPreferences(
      opts.language ?? this.language,
      opts.currency ?? this.currency,
      opts.timezone ?? this.timezone,
      opts.notifications ?? this.notifications,
      opts.privacy ?? this.privacy,
    );
  }
}

class StatusChange {
  constructor(
    readonly status: string,
    readonly timestamp: string,
    readonly reason: string | null,
    readonly updatedBy: string,
  ) {}
}

class OrderStatus {
  constructor(
    readonly current: string,
    readonly history: StatusChange[],
    readonly estimatedDelivery: string | null,
  ) {}
}

class OrderTimestamps {
  constructor(
    readonly created: string,
    readonly confirmed: string | null,
    readonly shipped: string | null,
    readonly delivered: string | null,
    readonly cancelled: string | null,
  ) {}
}

class OrderTotals {
  constructor(
    readonly subtotal: number,
    readonly taxes: number,
    readonly shipping: number,
    readonly discounts: number,
    readonly total: number,
  ) {}
}

class Order {
  constructor(
    readonly id: number,
    readonly customerId: number,
    readonly items: OrderItem<Product>[],
    readonly shippingAddress: Address,
    readonly billingAddress: Address,
    readonly paymentMethod: PaymentMethod,
    readonly status: OrderStatus,
    readonly timestamps: OrderTimestamps,
    readonly totals: OrderTotals,
    readonly metadata: Map<string, MetaValue> = new Map<string, MetaValue>(),
  ) {}
}
// 深度嵌套数据结构
class Customer {
  constructor(
    readonly id: number,
    readonly personalInfo: PersonalInfo,
    readonly contactInfo: ContactInfo,
    readonly addresses: Address[],
    readonly paymentMethods: PaymentMethod[],
    readonly orderHistory: Order[],
    readonly loyaltyProgram: LoyaltyProgram | null,
    readonly preferences: CustomerPreferences,
  ) {}

  copy(opts: {
    id?: number; personalInfo?: PersonalInfo; contactInfo?: ContactInfo;
    addresses?: Address[]; paymentMethods?: PaymentMethod[]; orderHistory?: Order[];
    loyaltyProgram?: LoyaltyProgram | null; preferences?: CustomerPreferences;
  }): Customer {
    return new Customer(
      opts.id ?? this.id,
      opts.personalInfo ?? this.personalInfo,
      opts.contactInfo ?? this.contactInfo,
      opts.addresses ?? this.addresses,
      opts.paymentMethods ?? this.paymentMethods,
      opts.orderHistory ?? this.orderHistory,
      opts.loyaltyProgram !== undefined ? opts.loyaltyProgram : this.loyaltyProgram,
      opts.preferences ?? this.preferences,
    );
  }
}
class DataClassesService {
  generateComplexCustomer(customerId: number): Customer {
    const govIds = new Map<string, string>();
    govIds.set("ssn", `123-45-${padStart4(`${customerId}`)}`);
    govIds.set("passport", `P${customerId}234567`);
    const personalInfo = new PersonalInfo(`John${customerId}`, `Doe${customerId}`, "1990-01-01", "US", govIds);

    const social = new Map<string, string>();
    social.set("twitter", `@john${customerId}`);
    social.set("linkedin", `john-doe-${customerId}`);
    social.set("instagram", `john_${customerId}`);
    const contactInfo = new ContactInfo(
      [`john.doe${customerId}@email.com`, `john${customerId}@work.com`],
      new Set<string>([`+1-555-${padStart4(`${customerId}`)}`, `+1-555-${padStart4(`${customerId + 1000}`)}`]),
      social,
    );

    const homeMeta = new Map<string, MetaValue>();
    homeMeta.set("type", "home");
    homeMeta.set("primary", true);
    const workMeta = new Map<string, MetaValue>();
    workMeta.set("type", "work");
    workMeta.set("primary", false);
    const addresses = [
      new Address(`${customerId}00 Main St`, "New York", [40.7128, -74.0060], homeMeta),
      new Address(`${customerId}01 Business Ave`, "Boston", [42.3601, -71.0589], workMeta),
    ];

    const paymentMethods: PaymentMethod[] = [
      new CreditCard(`4532-1234-5678-${padStart4(`${customerId}`)}`, 12, 2027, "123", addresses[0]),
      new DigitalWallet("ApplePay", `apple_${customerId}`, []),
    ];

    const products: Product[] = [];
    for (let i = 1; i <= 5; i++) {
      const discounts = new Map<string, number>();
      if (i % 2 === 0) discounts.set("member", 5.0);
      const tags = new Set<string>(["featured", "bestseller"].slice(0, (i % 2) + 1));
      products.push(new Product(
        customerId * 100 + i,
        `Product ${i} for Customer ${customerId}`,
        `Category${i % 3}`,
        99.99 + i * 10,
        [8.25, 2.5],
        discounts,
        tags,
      ));
    }

    const allOrderItems = products.map((product) => {
      const customizations = new Map<string, MetaValue>();
      customizations.set("color", "blue");
      customizations.set("size", "large");
      customizations.set("engraving", `Custom text ${customerId}`);
      return new OrderItem<Product>(product, randInt(1, 3), customizations);
    });
    const orders: Order[] = [];
    for (let orderIndex = 1; orderIndex <= 3; orderIndex++) {
      const items = allOrderItems.slice(0, orderIndex + 1);
      const subtotal = sum(items.map((it) => it.totalPrice));
      const taxes = subtotal * 0.0825;
      const shipping = 9.99;
      const discounts = orderIndex % 2 === 0 ? 15.0 : 0.0;
      const total = subtotal + taxes + shipping - discounts;

      orders.push(new Order(
        customerId * 1000 + orderIndex,
        customerId,
        items,
        addresses[0],
        addresses[addresses.length - 1],
        paymentMethods[0],
        new OrderStatus("delivered", [
          new StatusChange("pending", "2024-01-01T10:00:00Z", null, "system"),
          new StatusChange("confirmed", "2024-01-01T10:05:00Z", "payment_verified", "system"),
          new StatusChange("shipped", "2024-01-02T14:30:00Z", null, "warehouse"),
          new StatusChange("delivered", "2024-01-05T16:45:00Z", null, "courier"),
        ], "2024-01-05"),
        new OrderTimestamps("2024-01-01T10:00:00Z", "2024-01-01T10:05:00Z", "2024-01-02T14:30:00Z", "2024-01-05T16:45:00Z", null),
        new OrderTotals(subtotal, taxes, shipping, discounts, total),
      ));
    }

    const loyaltyProgram = new LoyaltyProgram(
      "Gold",
      Math.trunc(customerId * 100),
      new Set<string>(["free_shipping", "priority_support", "exclusive_discounts"]),
      "2025-12-31",
    );

    const notifications = new Map<string, boolean>();
    notifications.set("email", true);
    notifications.set("sms", false);
    notifications.set("push", true);
    notifications.set("marketing", false);
    const privacy = new Map<string, string>();
    privacy.set("share_data", "no");
    privacy.set("cookies", "essential_only");
    privacy.set("analytics", "anonymized");
    const preferences = new CustomerPreferences("en-US", "USD", "America/New_York", notifications, privacy);

    return new Customer(customerId, personalInfo, contactInfo, addresses, paymentMethods, orders, loyaltyProgram, preferences);
  }
  massDataProcessing(customerCount: number): void {
    console.log(`Generating ${customerCount} complex customers with nested data structures...`);

    const customers: Customer[] = [];
    for (let i = 1; i <= customerCount; i++) customers.push(this.generateComplexCustomer(i));

    console.log("Processing data class operations...");

    // 测试数据类的复制操作
    const updatedCustomers = customers.map((customer) => {
      const newNotifications = new Map<string, boolean>(customer.preferences.notifications);
      newNotifications.set("marketing", true);
      return customer.copy({
        personalInfo: customer.personalInfo.copy({ firstName: `${customer.personalInfo.firstName}_Updated` }),
        preferences: customer.preferences.copy({ notifications: newNotifications }),
      });
    });

    // 测试解构操作
    let destructAcc = 0;
    for (const customer of customers) {
      const { id, personalInfo, contactInfo } = customer;
      const { firstName, lastName } = personalInfo;
      const { emails, phones } = contactInfo;
      destructAcc += id + firstName.length + lastName.length + emails.length + phones.size;
    }

    // 测试数据类的相等性和哈希码 (ids are unique -> set/map size == count)
    const customerSet = new Set<Customer>(customers);
    const customerMap = new Map<number, Customer>();
    for (const c of customers) customerMap.set(c.id, c);

    // 测试复杂的数据转换
    const customerSummaries = customers.map((customer) => {
      const name = `${customer.personalInfo.firstName} ${customer.personalInfo.lastName}`;
      const totalOrders = customer.orderHistory.length;
      const totalSpent = sum(customer.orderHistory.map((o) => o.totals.total));
      const loyaltyTier = customer.loyaltyProgram !== null ? customer.loyaltyProgram.tier : null;
      const primaryEmail = customer.contactInfo.emails.length > 0 ? customer.contactInfo.emails[0] : null;
      const addressCount = customer.addresses.length;
      return { id: customer.id, name, totalOrders, totalSpent, loyaltyTier, primaryEmail, addressCount };
    });

    let summarySpent = 0;
    for (const s of customerSummaries) summarySpent += s.totalSpent;

    console.log(`Completed data class processing: ${customers.length} customers, ${updatedCustomers.length} updates, ${customerSummaries.length} summaries`);
    console.log(`- set=${customerSet.size}, map=${customerMap.size}, destructAcc=${destructAcc}, summarySpent=${summarySpent}, firstUpdatedName=${updatedCustomers[0].personalInfo.firstName}`);
  }
}

class IosSizeBenchmark {
  private readonly service = new DataClassesService();

  runBenchmark(): void {
    this.service.massDataProcessing(50);
  }
}

export function runBenchmark(): void {
  const benchmark = new IosSizeBenchmark();
  benchmark.runBenchmark();
}
