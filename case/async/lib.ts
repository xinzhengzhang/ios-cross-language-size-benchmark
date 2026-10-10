/*
 * iOS Size Benchmark - Test Case Implementation
 * Generated with Claude AI (https://claude.ai)
 *
 * This scriptc (TypeScript-to-native) implementation mirrors the Kotlin/
 * Swift/Objective-C versions for binary size comparison. It is a faithful
 * async/await port of the Kotlin coroutine implementation: every suspend
 * function becomes an `async` method, `withContext(Dispatchers.IO) { delay(n); ... }`
 * becomes `await delay(n); ...`, and the structured-concurrency fan-out
 * (scope.async { ... } + awaitAll) becomes Promise.all over async calls.
 * A single exported entry (runBenchmark) exercises every type.
 */

type AnyValue = string | number;

function delay(ms: number): Promise<void> {
  return new Promise<void>((resolve) => {
    setTimeout(resolve, ms);
  });
}

function randomId(): number {
  return 1 + Math.floor(Math.random() * 10000);
}

function randomInRange(min: number, max: number): number {
  return min + Math.floor(Math.random() * (max - min + 1));
}

function stringHashCode(s: string): number {
  let h = 0;
  for (let i = 0; i < s.length; i++) {
    h = (h * 31 + s.charCodeAt(i)) | 0;
  }
  return h;
}

function shuffled<T>(source: T[]): T[] {
  const result = source.slice();
  for (let i = result.length - 1; i > 0; i--) {
    const j = Math.floor(Math.random() * (i + 1));
    const tmp = result[i];
    result[i] = result[j];
    result[j] = tmp;
  }
  return result;
}

class UserProfile {
  constructor(
    public readonly id: number,
    public readonly name: string,
    public readonly email: string,
    public readonly age: number,
  ) {}

  copy(name: string): UserProfile {
    return new UserProfile(this.id, name, this.email, this.age);
  }
}

class Product {
  constructor(
    public readonly id: number,
    public readonly name: string,
    public readonly price: number,
    public readonly category: string,
  ) {}

  copyPrice(price: number): Product {
    return new Product(this.id, this.name, price, this.category);
  }
}

class Order {
  constructor(
    public readonly id: number,
    public readonly userId: number,
    public readonly products: Product[],
    public readonly total: number,
  ) {}

  copyTotal(total: number): Order {
    return new Order(this.id, this.userId, this.products, total);
  }
}

class Review {
  constructor(
    public readonly id: number,
    public readonly userId: number,
    public readonly productId: number,
    public readonly rating: number,
    public readonly comment: string,
  ) {}

  copyComment(comment: string): Review {
    return new Review(this.id, this.userId, this.productId, this.rating, comment);
  }
}

class Category {
  constructor(
    public readonly id: number,
    public readonly name: string,
    public readonly description: string,
  ) {}

  copyDescription(description: string): Category {
    return new Category(this.id, this.name, description);
  }
}

class Inventory {
  constructor(
    public readonly productId: number,
    public readonly quantity: number,
    public readonly location: string,
  ) {}

  copyQuantity(quantity: number): Inventory {
    return new Inventory(this.productId, quantity, this.location);
  }
}

class Payment {
  constructor(
    public readonly id: number,
    public readonly orderId: number,
    public readonly amount: number,
    public readonly method: string,
  ) {}
}

class Shipping {
  constructor(
    public readonly id: number,
    public readonly orderId: number,
    public readonly address: string,
    public readonly status: string,
  ) {}
}

class Notification {
  constructor(
    public readonly id: number,
    public readonly userId: number,
    public readonly message: string,
    public readonly type: string,
  ) {}
}

class Analytics {
  constructor(
    public readonly id: number,
    public readonly event: string,
    public readonly data: Map<string, AnyValue>,
  ) {}
}

class UserService {
  async createUser(name: string, email: string, age: number): Promise<UserProfile> {
    await delay(50);
    return new UserProfile(this.generateId(), name, email, age);
  }

  async updateUser(user: UserProfile): Promise<UserProfile> {
    await delay(30);
    return user.copy(`${user.name}_updated`);
  }

  async deleteUser(userId: number): Promise<boolean> {
    await delay(20);
    return true;
  }

  async getUserById(userId: number): Promise<UserProfile | null> {
    await delay(10);
    return new UserProfile(userId, `User${userId}`, `user${userId}@email.com`, 25);
  }

  async getAllUsers(): Promise<UserProfile[]> {
    await delay(100);
    const users: UserProfile[] = [];
    for (let i = 1; i <= 100; i++) {
      users.push(new UserProfile(i, `User${i}`, `user${i}@email.com`, 20 + (i % 50)));
    }
    return users;
  }

  async searchUsers(query: string): Promise<UserProfile[]> {
    await delay(80);
    const users = await this.getAllUsers();
    const q = query.toLowerCase();
    return users.filter((u) => u.name.toLowerCase().includes(q));
  }

  async validateUser(user: UserProfile): Promise<boolean> {
    return user.email.includes("@") && user.name.trim().length > 0 && user.age > 0;
  }

  async getUsersByAge(minAge: number, maxAge: number): Promise<UserProfile[]> {
    await delay(60);
    const users = await this.getAllUsers();
    return users.filter((u) => u.age >= minAge && u.age <= maxAge);
  }

  async getUserCount(): Promise<number> {
    await delay(15);
    return 1000;
  }

  async isEmailTaken(email: string): Promise<boolean> {
    await delay(25);
    return stringHashCode(email) % 10 === 0;
  }

  generateId(): number {
    return randomId();
  }
}

class ProductService {
  async createProduct(name: string, price: number, category: string): Promise<Product> {
    await delay(40);
    return new Product(this.generateId(), name, price, category);
  }

  async updateProduct(product: Product): Promise<Product> {
    await delay(35);
    return product.copyPrice(product.price * 1.1);
  }

  async deleteProduct(productId: number): Promise<boolean> {
    await delay(25);
    return true;
  }

  async getProductById(productId: number): Promise<Product | null> {
    await delay(15);
    return new Product(productId, `Product${productId}`, 99.99, "Electronics");
  }

  async getAllProducts(): Promise<Product[]> {
    await delay(120);
    const products: Product[] = [];
    for (let i = 1; i <= 500; i++) {
      products.push(new Product(i, `Product${i}`, 50.0 + (i % 200), `Category${i % 10}`));
    }
    return products;
  }

  async searchProducts(query: string): Promise<Product[]> {
    await delay(90);
    const products = await this.getAllProducts();
    const q = query.toLowerCase();
    return products.filter((p) => p.name.toLowerCase().includes(q));
  }

  async getProductsByCategory(category: string): Promise<Product[]> {
    await delay(70);
    const products = await this.getAllProducts();
    return products.filter((p) => p.category === category);
  }

  async getProductsByPriceRange(minPrice: number, maxPrice: number): Promise<Product[]> {
    await delay(80);
    const products = await this.getAllProducts();
    return products.filter((p) => p.price >= minPrice && p.price <= maxPrice);
  }

  async getFeaturedProducts(count: number): Promise<Product[]> {
    await delay(50);
    const products = await this.getAllProducts();
    return shuffled(products).slice(0, count);
  }

  async getProductCount(): Promise<number> {
    await delay(20);
    return 500;
  }

  async calculateDiscount(product: Product, percentage: number): Promise<number> {
    return product.price * (1 - percentage / 100);
  }

  async isProductAvailable(productId: number): Promise<boolean> {
    await delay(10);
    return productId % 10 !== 0;
  }

  generateId(): number {
    return randomId();
  }
}

class OrderService {
  async createOrder(userId: number, products: Product[]): Promise<Order> {
    await delay(60);
    const total = products.reduce((acc, p) => acc + p.price, 0);
    return new Order(this.generateId(), userId, products, total);
  }

  async updateOrder(order: Order): Promise<Order> {
    await delay(45);
    return order.copyTotal(order.total * 1.05);
  }

  async cancelOrder(orderId: number): Promise<boolean> {
    await delay(30);
    return true;
  }

  async getOrderById(orderId: number): Promise<Order | null> {
    await delay(20);
    return new Order(orderId, 1, [new Product(1, "Sample", 99.99, "Sample")], 99.99);
  }

  async getOrdersByUser(userId: number): Promise<Order[]> {
    await delay(80);
    const orders: Order[] = [];
    for (let i = 1; i <= 20; i++) {
      orders.push(new Order(i, userId, [new Product(i, `Product${i}`, 50.0, "Category")], 50.0));
    }
    return orders;
  }

  async getAllOrders(): Promise<Order[]> {
    await delay(150);
    const orders: Order[] = [];
    for (let i = 1; i <= 200; i++) {
      orders.push(new Order(i, i % 50, [new Product(i, `Product${i}`, 75.0, "Category")], 75.0));
    }
    return orders;
  }

  async getOrdersByStatus(status: string): Promise<Order[]> {
    await delay(90);
    const orders = await this.getAllOrders();
    const key = stringHashCode(status) % 5;
    return orders.filter((o) => o.id % 5 === key);
  }

  async getOrdersByDateRange(startDate: string, endDate: string): Promise<Order[]> {
    await delay(100);
    const orders = await this.getAllOrders();
    return orders.filter((o) => o.id % 7 === 0);
  }

  async calculateOrderTotal(products: Product[]): Promise<number> {
    return products.reduce((acc, p) => acc + p.price, 0);
  }

  async applyDiscount(order: Order, discountPercent: number): Promise<Order> {
    return order.copyTotal(order.total * (1 - discountPercent / 100));
  }

  async getOrderCount(): Promise<number> {
    await delay(25);
    return 200;
  }

  async getOrdersByPriceRange(minPrice: number, maxPrice: number): Promise<Order[]> {
    await delay(85);
    const orders = await this.getAllOrders();
    return orders.filter((o) => o.total >= minPrice && o.total <= maxPrice);
  }

  generateId(): number {
    return randomId();
  }
}

class ReviewService {
  async createReview(userId: number, productId: number, rating: number, comment: string): Promise<Review> {
    await delay(35);
    return new Review(this.generateId(), userId, productId, rating, comment);
  }

  async updateReview(review: Review): Promise<Review> {
    await delay(30);
    return review.copyComment(`${review.comment} [Updated]`);
  }

  async deleteReview(reviewId: number): Promise<boolean> {
    await delay(20);
    return true;
  }

  async getReviewById(reviewId: number): Promise<Review | null> {
    await delay(15);
    return new Review(reviewId, 1, 1, 5, "Great product!");
  }

  async getReviewsByProduct(productId: number): Promise<Review[]> {
    await delay(60);
    const reviews: Review[] = [];
    for (let i = 1; i <= 30; i++) {
      reviews.push(new Review(i, i % 20, productId, randomInRange(1, 5), `Review ${i}`));
    }
    return reviews;
  }

  async getReviewsByUser(userId: number): Promise<Review[]> {
    await delay(55);
    const reviews: Review[] = [];
    for (let i = 1; i <= 15; i++) {
      reviews.push(new Review(i, userId, i % 50, randomInRange(1, 5), `User review ${i}`));
    }
    return reviews;
  }

  async getReviewsByRating(rating: number): Promise<Review[]> {
    await delay(70);
    const reviews: Review[] = [];
    for (let i = 1; i <= 100; i++) {
      if (i % 5 === rating - 1) {
        reviews.push(new Review(i, i % 20, i % 50, rating, `Rating ${rating} review`));
      }
    }
    return reviews;
  }

  async getAverageRating(productId: number): Promise<number> {
    await delay(40);
    return randomInRange(30, 50) / 10.0;
  }

  async getReviewCount(productId: number): Promise<number> {
    await delay(25);
    return randomInRange(10, 100);
  }

  async searchReviews(query: string): Promise<Review[]> {
    await delay(80);
    const reviews: Review[] = [];
    for (let i = 1; i <= 50; i++) {
      reviews.push(new Review(i, i % 20, i % 50, randomInRange(1, 5), `Review containing ${query}`));
    }
    return reviews;
  }

  async getTopReviews(productId: number, count: number): Promise<Review[]> {
    await delay(50);
    const reviews = await this.getReviewsByProduct(productId);
    return reviews.slice().sort((a, b) => b.rating - a.rating).slice(0, count);
  }

  async flagReview(reviewId: number, reason: string): Promise<boolean> {
    await delay(30);
    return true;
  }

  generateId(): number {
    return randomId();
  }
}

class CategoryService {
  async createCategory(name: string, description: string): Promise<Category> {
    await delay(25);
    return new Category(this.generateId(), name, description);
  }

  async updateCategory(category: Category): Promise<Category> {
    await delay(20);
    return category.copyDescription(`${category.description} [Updated]`);
  }

  async deleteCategory(categoryId: number): Promise<boolean> {
    await delay(15);
    return true;
  }

  async getCategoryById(categoryId: number): Promise<Category | null> {
    await delay(10);
    return new Category(categoryId, `Category${categoryId}`, `Description for category ${categoryId}`);
  }

  async getAllCategories(): Promise<Category[]> {
    await delay(40);
    const categories: Category[] = [];
    for (let i = 1; i <= 50; i++) {
      categories.push(new Category(i, `Category${i}`, `Description for category ${i}`));
    }
    return categories;
  }

  async searchCategories(query: string): Promise<Category[]> {
    await delay(35);
    const categories = await this.getAllCategories();
    const q = query.toLowerCase();
    return categories.filter((c) => c.name.toLowerCase().includes(q));
  }

  async getCategoryCount(): Promise<number> {
    await delay(10);
    return 50;
  }

  async getPopularCategories(count: number): Promise<Category[]> {
    await delay(30);
    const categories = await this.getAllCategories();
    return shuffled(categories).slice(0, count);
  }

  async getCategoryTree(): Promise<Map<Category, Category[]>> {
    await delay(60);
    const categories = await this.getAllCategories();
    const tree = new Map<Category, Category[]>();
    for (const parent of categories) {
      const children = categories.filter((c) => c.id !== parent.id).slice(0, 3);
      tree.set(parent, children);
    }
    return tree;
  }

  async validateCategory(category: Category): Promise<boolean> {
    return category.name.trim().length > 0 && category.description.trim().length > 0;
  }

  generateId(): number {
    return randomId();
  }
}

class InventoryService {
  async addInventory(productId: number, quantity: number, location: string): Promise<Inventory> {
    await delay(30);
    return new Inventory(productId, quantity, location);
  }

  async updateInventory(inventory: Inventory): Promise<Inventory> {
    await delay(25);
    return inventory.copyQuantity(inventory.quantity - 1);
  }

  async removeInventory(productId: number, location: string): Promise<boolean> {
    await delay(20);
    return true;
  }

  async getInventory(productId: number): Promise<Inventory[]> {
    await delay(35);
    const inventory: Inventory[] = [];
    for (let i = 1; i <= 5; i++) {
      inventory.push(new Inventory(productId, randomInRange(10, 100), `Location${i}`));
    }
    return inventory;
  }

  async getAllInventory(): Promise<Inventory[]> {
    await delay(80);
    const inventory: Inventory[] = [];
    for (let i = 1; i <= 200; i++) {
      inventory.push(new Inventory(i % 50, randomInRange(5, 150), `Location${i % 10}`));
    }
    return inventory;
  }

  async getInventoryByLocation(location: string): Promise<Inventory[]> {
    await delay(45);
    const inventory = await this.getAllInventory();
    return inventory.filter((inv) => inv.location === location);
  }

  async getLowStockItems(threshold: number): Promise<Inventory[]> {
    await delay(55);
    const inventory = await this.getAllInventory();
    return inventory.filter((inv) => inv.quantity < threshold);
  }

  async getTotalQuantity(productId: number): Promise<number> {
    await delay(25);
    const inventory = await this.getInventory(productId);
    return inventory.reduce((acc, inv) => acc + inv.quantity, 0);
  }

  async reserveInventory(productId: number, quantity: number): Promise<boolean> {
    await delay(35);
    const total = await this.getTotalQuantity(productId);
    return total >= quantity;
  }

  async releaseInventory(productId: number, quantity: number): Promise<boolean> {
    await delay(30);
    return true;
  }

  async getInventoryValue(): Promise<number> {
    await delay(50);
    const inventory = await this.getAllInventory();
    return inventory.reduce((acc, inv) => acc + inv.quantity * 50.0, 0);
  }

  async transferInventory(productId: number, fromLocation: string, toLocation: string, quantity: number): Promise<boolean> {
    await delay(40);
    return true;
  }

  generateId(): number {
    return randomId();
  }
}

class PaymentService {
  async processPayment(orderId: number, amount: number, method: string): Promise<Payment> {
    await delay(100);
    return new Payment(this.generateId(), orderId, amount, method);
  }

  async refundPayment(paymentId: number): Promise<boolean> {
    await delay(80);
    return true;
  }

  async getPaymentById(paymentId: number): Promise<Payment | null> {
    await delay(20);
    return new Payment(paymentId, 1, 99.99, "credit_card");
  }

  async getPaymentsByOrder(orderId: number): Promise<Payment[]> {
    await delay(40);
    const payments: Payment[] = [];
    for (let i = 1; i <= 3; i++) {
      payments.push(new Payment(i, orderId, randomInRange(50, 200), "credit_card"));
    }
    return payments;
  }

  async getAllPayments(): Promise<Payment[]> {
    await delay(120);
    const payments: Payment[] = [];
    for (let i = 1; i <= 300; i++) {
      payments.push(new Payment(i, i % 100, randomInRange(25, 500), "credit_card"));
    }
    return payments;
  }

  async getPaymentsByMethod(method: string): Promise<Payment[]> {
    await delay(60);
    const payments = await this.getAllPayments();
    return payments.filter((p) => p.method === method);
  }

  async getPaymentsByDateRange(startDate: string, endDate: string): Promise<Payment[]> {
    await delay(90);
    const payments = await this.getAllPayments();
    return payments.filter((p) => p.id % 7 === 0);
  }

  async getTotalRevenue(): Promise<number> {
    await delay(70);
    const payments = await this.getAllPayments();
    return payments.reduce((acc, p) => acc + p.amount, 0);
  }

  async validatePayment(payment: Payment): Promise<boolean> {
    return payment.amount > 0 && payment.method.trim().length > 0;
  }

  async getPaymentMethods(): Promise<string[]> {
    return ["credit_card", "debit_card", "paypal", "apple_pay", "google_pay"];
  }

  async calculateFees(amount: number, method: string): Promise<number> {
    switch (method) {
      case "credit_card":
        return amount * 0.029;
      case "debit_card":
        return amount * 0.015;
      case "paypal":
        return amount * 0.035;
      default:
        return amount * 0.025;
    }
  }

  async isPaymentAuthorized(paymentId: number): Promise<boolean> {
    await delay(30);
    return paymentId % 10 !== 0;
  }

  generateId(): number {
    return randomId();
  }
}

class ShippingService {
  async createShipment(orderId: number, address: string): Promise<Shipping> {
    await delay(60);
    return new Shipping(this.generateId(), orderId, address, "pending");
  }

  async updateShippingStatus(shippingId: number, status: string): Promise<Shipping | null> {
    await delay(30);
    return new Shipping(shippingId, 1, "123 Main St", status);
  }

  async getShippingById(shippingId: number): Promise<Shipping | null> {
    await delay(20);
    return new Shipping(shippingId, 1, "123 Main St", "shipped");
  }

  async getShippingByOrder(orderId: number): Promise<Shipping | null> {
    await delay(25);
    return new Shipping(1, orderId, "456 Oak Ave", "delivered");
  }

  async getAllShipments(): Promise<Shipping[]> {
    await delay(100);
    const shipments: Shipping[] = [];
    for (let i = 1; i <= 250; i++) {
      shipments.push(new Shipping(i, i % 150, `Address ${i}`, "shipped"));
    }
    return shipments;
  }

  async getShipmentsByStatus(status: string): Promise<Shipping[]> {
    await delay(70);
    const shipments = await this.getAllShipments();
    return shipments.filter((s) => s.status === status);
  }

  async trackShipment(shippingId: number): Promise<string> {
    await delay(40);
    return `Tracking: SHIP${shippingId}${randomInRange(1000, 9999)}`;
  }

  async estimateDelivery(address: string): Promise<string> {
    await delay(50);
    const days = randomInRange(1, 7);
    return `Estimated delivery in ${days} days`;
  }

  async calculateShippingCost(address: string, weight: number): Promise<number> {
    await delay(30);
    const baseRate = 5.99;
    const weightRate = weight * 0.5;
    return baseRate + weightRate;
  }

  async getAvailableCarriers(): Promise<string[]> {
    return ["UPS", "FedEx", "USPS", "DHL", "Amazon"];
  }

  async schedulePickup(shippingId: number, date: string): Promise<boolean> {
    await delay(35);
    return true;
  }

  async cancelShipment(shippingId: number): Promise<boolean> {
    await delay(25);
    return true;
  }

  generateId(): number {
    return randomId();
  }
}

class NotificationService {
  async sendNotification(userId: number, message: string, type: string): Promise<Notification> {
    await delay(40);
    return new Notification(this.generateId(), userId, message, type);
  }

  async getNotificationById(notificationId: number): Promise<Notification | null> {
    await delay(15);
    return new Notification(notificationId, 1, "Sample notification", "info");
  }

  async getNotificationsByUser(userId: number): Promise<Notification[]> {
    await delay(50);
    const notifications: Notification[] = [];
    for (let i = 1; i <= 20; i++) {
      notifications.push(new Notification(i, userId, `Notification ${i}`, "info"));
    }
    return notifications;
  }

  async getNotificationsByType(type: string): Promise<Notification[]> {
    await delay(60);
    const notifications: Notification[] = [];
    for (let i = 1; i <= 50; i++) {
      notifications.push(new Notification(i, i % 25, `Message ${i}`, type));
    }
    return notifications;
  }

  async markAsRead(notificationId: number): Promise<boolean> {
    await delay(20);
    return true;
  }

  async markAllAsRead(userId: number): Promise<boolean> {
    await delay(35);
    return true;
  }

  async deleteNotification(notificationId: number): Promise<boolean> {
    await delay(25);
    return true;
  }

  async getUnreadCount(userId: number): Promise<number> {
    await delay(30);
    return randomInRange(0, 15);
  }

  async sendBulkNotification(userIds: number[], message: string, type: string): Promise<Notification[]> {
    await delay(100);
    return userIds.map((userId) => new Notification(this.generateId(), userId, message, type));
  }

  async scheduleNotification(userId: number, message: string, type: string, scheduleTime: string): Promise<Notification> {
    await delay(45);
    return new Notification(this.generateId(), userId, message, type);
  }

  async getNotificationTypes(): Promise<string[]> {
    return ["info", "warning", "error", "success", "promotion"];
  }

  async updateNotificationPreferences(userId: number, preferences: Map<string, boolean>): Promise<boolean> {
    await delay(31);
    return true;
  }

  generateId(): number {
    return randomId();
  }
}

class AnalyticsService {
  async trackEvent(event: string, data: Map<string, AnyValue>): Promise<Analytics> {
    await delay(25);
    return new Analytics(this.generateId(), event, data);
  }

  async getEventById(eventId: number): Promise<Analytics | null> {
    await delay(15);
    const data = new Map<string, AnyValue>();
    data.set("page", "/home");
    return new Analytics(eventId, "page_view", data);
  }

  async getEventsByType(event: string): Promise<Analytics[]> {
    await delay(80);
    const events: Analytics[] = [];
    for (let i = 1; i <= 100; i++) {
      const data = new Map<string, AnyValue>();
      data.set("timestamp", "125");
      events.push(new Analytics(i, event, data));
    }
    return events;
  }

  async getEventsByDateRange(startDate: string, endDate: string): Promise<Analytics[]> {
    await delay(120);
    const events: Analytics[] = [];
    for (let i = 1; i <= 500; i++) {
      const data = new Map<string, AnyValue>();
      data.set("date", startDate);
      events.push(new Analytics(i, `event_${i}`, data));
    }
    return events;
  }

  async getUserEvents(userId: number): Promise<Analytics[]> {
    await delay(70);
    const events: Analytics[] = [];
    for (let i = 1; i <= 30; i++) {
      const data = new Map<string, AnyValue>();
      data.set("userId", userId);
      data.set("action", "click");
      events.push(new Analytics(i, "user_action", data));
    }
    return events;
  }

  async getPopularEvents(count: number): Promise<string[]> {
    await delay(60);
    return ["page_view", "click", "purchase", "signup", "logout"].slice(0, count);
  }

  async getEventCount(event: string): Promise<number> {
    await delay(40);
    return randomInRange(100, 1000);
  }

  async getUniqueUsers(event: string): Promise<number> {
    await delay(50);
    return randomInRange(50, 500);
  }

  async generateReport(startDate: string, endDate: string): Promise<Map<string, AnyValue>> {
    await delay(150);
    const report = new Map<string, AnyValue>();
    report.set("totalEvents", 10000);
    report.set("uniqueUsers", 1500);
    report.set("averageSessionTime", 300);
    report.set("bounceRate", 0.35);
    return report;
  }

  async getTopPages(count: number): Promise<string[]> {
    await delay(45);
    const pages: string[] = [];
    for (let i = 1; i <= count; i++) {
      pages.push(`/page${i}`);
    }
    return pages;
  }

  async getConversionRate(fromEvent: string, toEvent: string): Promise<number> {
    await delay(60);
    return randomInRange(5, 25) / 100.0;
  }

  async exportAnalytics(format: string): Promise<string> {
    await delay(200);
    return `analytics_export.${format}`;
  }

  generateId(): number {
    return randomId();
  }
}

class IosSizeBenchmark {
  private userService = new UserService();
  private productService = new ProductService();
  private orderService = new OrderService();
  private reviewService = new ReviewService();
  private categoryService = new CategoryService();
  private inventoryService = new InventoryService();
  private paymentService = new PaymentService();
  private shippingService = new ShippingService();
  private notificationService = new NotificationService();
  private analyticsService = new AnalyticsService();

  async runWorkflows(): Promise<void> {
    const jobs: Promise<void>[] = [];
    for (let index = 0; index < 100; index++) {
      jobs.push(this.processUserWorkflow(index));
      jobs.push(this.processProductWorkflow(index));
      jobs.push(this.processOrderWorkflow(index));
      jobs.push(this.processReviewWorkflow(index));
      jobs.push(this.processCategoryWorkflow(index));
      jobs.push(this.processInventoryWorkflow(index));
      jobs.push(this.processPaymentWorkflow(index));
      jobs.push(this.processShippingWorkflow(index));
      jobs.push(this.processNotificationWorkflow(index));
      jobs.push(this.processAnalyticsWorkflow(index));
    }
    await Promise.all(jobs);
  }

  async processUserWorkflow(index: number): Promise<void> {
    const user = await this.userService.createUser(`User${index}`, `user${index}@email.com`, 25 + (index % 50));
    await this.userService.updateUser(user);
    await this.userService.getUserById(user.id);
    await this.userService.getAllUsers();
    await this.userService.searchUsers("User");
    await this.userService.validateUser(user);
    await this.userService.getUsersByAge(20, 40);
    await this.userService.getUserCount();
    await this.userService.isEmailTaken(user.email);
    await this.userService.deleteUser(user.id);
  }

  async processProductWorkflow(index: number): Promise<void> {
    const product = await this.productService.createProduct(`Product${index}`, 99.99 + index, `Category${index % 10}`);
    await this.productService.updateProduct(product);
    await this.productService.getProductById(product.id);
    await this.productService.getAllProducts();
    await this.productService.searchProducts("Product");
    await this.productService.getProductsByCategory(product.category);
    await this.productService.getProductsByPriceRange(50.0, 200.0);
    await this.productService.getFeaturedProducts(10);
    await this.productService.getProductCount();
    await this.productService.calculateDiscount(product, 10.0);
    await this.productService.isProductAvailable(product.id);
    await this.productService.deleteProduct(product.id);
  }

  async processOrderWorkflow(index: number): Promise<void> {
    const products = [new Product(index, `Product${index}`, 75.0, "Category")];
    const order = await this.orderService.createOrder(index, products);
    await this.orderService.updateOrder(order);
    await this.orderService.getOrderById(order.id);
    await this.orderService.getOrdersByUser(index);
    await this.orderService.getAllOrders();
    await this.orderService.getOrdersByStatus("pending");
    await this.orderService.getOrdersByDateRange("2024-01-01", "2024-12-31");
    await this.orderService.calculateOrderTotal(products);
    await this.orderService.applyDiscount(order, 5.0);
    await this.orderService.getOrderCount();
    await this.orderService.getOrdersByPriceRange(50.0, 150.0);
    await this.orderService.cancelOrder(order.id);
  }

  async processReviewWorkflow(index: number): Promise<void> {
    const review = await this.reviewService.createReview(index, index % 50, 5, `Great product ${index}`);
    await this.reviewService.updateReview(review);
    await this.reviewService.getReviewById(review.id);
    await this.reviewService.getReviewsByProduct(index % 50);
    await this.reviewService.getReviewsByUser(index);
    await this.reviewService.getReviewsByRating(5);
    await this.reviewService.getAverageRating(index % 50);
    await this.reviewService.getReviewCount(index % 50);
    await this.reviewService.searchReviews("great");
    await this.reviewService.getTopReviews(index % 50, 5);
    await this.reviewService.flagReview(review.id, "spam");
    await this.reviewService.deleteReview(review.id);
  }

  async processCategoryWorkflow(index: number): Promise<void> {
    const category = await this.categoryService.createCategory(`Category${index}`, `Description ${index}`);
    await this.categoryService.updateCategory(category);
    await this.categoryService.getCategoryById(category.id);
    await this.categoryService.getAllCategories();
    await this.categoryService.searchCategories("Category");
    await this.categoryService.getCategoryCount();
    await this.categoryService.getPopularCategories(5);
    await this.categoryService.getCategoryTree();
    await this.categoryService.validateCategory(category);
    await this.categoryService.deleteCategory(category.id);
  }

  async processInventoryWorkflow(index: number): Promise<void> {
    const inventory = await this.inventoryService.addInventory(index, 100, `Location${index}`);
    await this.inventoryService.updateInventory(inventory);
    await this.inventoryService.getInventory(index);
    await this.inventoryService.getAllInventory();
    await this.inventoryService.getInventoryByLocation(`Location${index}`);
    await this.inventoryService.getLowStockItems(10);
    await this.inventoryService.getTotalQuantity(index);
    await this.inventoryService.reserveInventory(index, 5);
    await this.inventoryService.releaseInventory(index, 5);
    await this.inventoryService.getInventoryValue();
    await this.inventoryService.transferInventory(index, "Location1", "Location2", 10);
    await this.inventoryService.removeInventory(index, `Location${index}`);
  }

  async processPaymentWorkflow(index: number): Promise<void> {
    const payment = await this.paymentService.processPayment(index, 99.99, "credit_card");
    await this.paymentService.getPaymentById(payment.id);
    await this.paymentService.getPaymentsByOrder(index);
    await this.paymentService.getAllPayments();
    await this.paymentService.getPaymentsByMethod("credit_card");
    await this.paymentService.getPaymentsByDateRange("2024-01-01", "2024-12-31");
    await this.paymentService.getTotalRevenue();
    await this.paymentService.validatePayment(payment);
    await this.paymentService.getPaymentMethods();
    await this.paymentService.calculateFees(99.99, "credit_card");
    await this.paymentService.isPaymentAuthorized(payment.id);
    await this.paymentService.refundPayment(payment.id);
  }

  async processShippingWorkflow(index: number): Promise<void> {
    const shipping = await this.shippingService.createShipment(index, `Address ${index}`);
    await this.shippingService.updateShippingStatus(shipping.id, "shipped");
    await this.shippingService.getShippingById(shipping.id);
    await this.shippingService.getShippingByOrder(index);
    await this.shippingService.getAllShipments();
    await this.shippingService.getShipmentsByStatus("shipped");
    await this.shippingService.trackShipment(shipping.id);
    await this.shippingService.estimateDelivery(`Address ${index}`);
    await this.shippingService.calculateShippingCost(`Address ${index}`, 5.0);
    await this.shippingService.getAvailableCarriers();
    await this.shippingService.schedulePickup(shipping.id, "2024-12-25");
    await this.shippingService.cancelShipment(shipping.id);
  }

  async processNotificationWorkflow(index: number): Promise<void> {
    const notification = await this.notificationService.sendNotification(index, `Message ${index}`, "info");
    await this.notificationService.getNotificationById(notification.id);
    await this.notificationService.getNotificationsByUser(index);
    await this.notificationService.getNotificationsByType("info");
    await this.notificationService.markAsRead(notification.id);
    await this.notificationService.markAllAsRead(index);
    await this.notificationService.getUnreadCount(index);
    await this.notificationService.sendBulkNotification([index], "Bulk message", "info");
    await this.notificationService.scheduleNotification(index, "Scheduled", "info", "2024-12-25");
    await this.notificationService.getNotificationTypes();
    const prefs = new Map<string, boolean>();
    prefs.set("email", true);
    await this.notificationService.updateNotificationPreferences(index, prefs);
    await this.notificationService.deleteNotification(notification.id);
  }

  async processAnalyticsWorkflow(index: number): Promise<void> {
    const eventData = new Map<string, AnyValue>();
    eventData.set("data", index);
    const analytics = await this.analyticsService.trackEvent(`event_${index}`, eventData);
    await this.analyticsService.getEventById(analytics.id);
    await this.analyticsService.getEventsByType(`event_${index}`);
    await this.analyticsService.getEventsByDateRange("2024-01-01", "2024-12-31");
    await this.analyticsService.getUserEvents(index);
    await this.analyticsService.getPopularEvents(5);
    await this.analyticsService.getEventCount(`event_${index}`);
    await this.analyticsService.getUniqueUsers(`event_${index}`);
    await this.analyticsService.generateReport("2024-01-01", "2024-12-31");
    await this.analyticsService.getTopPages(10);
    await this.analyticsService.getConversionRate("view", "purchase");
    await this.analyticsService.exportAnalytics("csv");
  }
}

export function runBenchmark(): void {
  const benchmark = new IosSizeBenchmark();
  benchmark.runWorkflows().then(() => {
    console.log("Async benchmark completed");
  });
}
