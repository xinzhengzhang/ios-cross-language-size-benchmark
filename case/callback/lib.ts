/*
 * iOS Size Benchmark - Test Case Implementation
 * Generated with Claude AI (https://claude.ai)
 *
 * This scriptc (TypeScript-to-native) implementation mirrors the Kotlin/
 * Swift/Objective-C versions for binary size comparison. It models the
 * Kotlin callback (higher-order function) style with TypeScript
 * function-typed parameters, kept synchronous exactly as the Kotlin
 * callback logic is synchronous. A single exported entry (runBenchmark)
 * exercises every type so nothing is dead-code eliminated.
 */

// Kotlin's Map<String, Any> analytics payload only ever holds strings and
// numbers in this case; model it as a concrete union (the static tier
// forbids `any`).
type AnyValue = string | number;

function randomId(): number {
  return 1 + Math.floor(Math.random() * 10000);
}

function randomInRange(min: number, max: number): number {
  return min + Math.floor(Math.random() * (max - min + 1));
}

// Fisher-Yates shuffle, mirroring Kotlin's List.shuffled().
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

// Faithful reproduction of Kotlin's String.hashCode() (32-bit signed).
function stringHashCode(s: string): number {
  let h = 0;
  for (let i = 0; i < s.length; i++) {
    h = (h * 31 + s.charCodeAt(i)) | 0;
  }
  return h;
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
  createUser(name: string, email: string, age: number, callback: (user: UserProfile) => void): void {
    const user = new UserProfile(this.generateId(), name, email, age);
    callback(user);
  }

  updateUser(user: UserProfile, callback: (user: UserProfile) => void): void {
    const updatedUser = user.copy(`${user.name}_updated`);
    callback(updatedUser);
  }

  deleteUser(userId: number, callback: (ok: boolean) => void): void {
    callback(true);
  }

  getUserById(userId: number, callback: (user: UserProfile | null) => void): void {
    const user = new UserProfile(userId, `User${userId}`, `user${userId}@email.com`, 25);
    callback(user);
  }

  getAllUsers(callback: (users: UserProfile[]) => void): void {
    const users: UserProfile[] = [];
    for (let i = 1; i <= 100; i++) {
      users.push(new UserProfile(i, `User${i}`, `user${i}@email.com`, 20 + (i % 50)));
    }
    callback(users);
  }

  searchUsers(query: string, callback: (users: UserProfile[]) => void): void {
    this.getAllUsers((users) => {
      const q = query.toLowerCase();
      const filtered = users.filter((u) => u.name.toLowerCase().includes(q));
      callback(filtered);
    });
  }

  validateUser(user: UserProfile, callback: (ok: boolean) => void): void {
    const isValid = user.email.includes("@") && user.name.trim().length > 0 && user.age > 0;
    callback(isValid);
  }

  getUsersByAge(minAge: number, maxAge: number, callback: (users: UserProfile[]) => void): void {
    this.getAllUsers((users) => {
      const filtered = users.filter((u) => u.age >= minAge && u.age <= maxAge);
      callback(filtered);
    });
  }

  getUserCount(callback: (count: number) => void): void {
    callback(1000);
  }

  isEmailTaken(email: string, callback: (taken: boolean) => void): void {
    const taken = stringHashCode(email) % 10 === 0;
    callback(taken);
  }

  generateId(): number {
    return randomId();
  }
}

class ProductService {
  createProduct(name: string, price: number, category: string, callback: (product: Product) => void): void {
    const product = new Product(this.generateId(), name, price, category);
    callback(product);
  }

  updateProduct(product: Product, callback: (product: Product) => void): void {
    const updatedProduct = product.copyPrice(product.price * 1.1);
    callback(updatedProduct);
  }

  deleteProduct(productId: number, callback: (ok: boolean) => void): void {
    callback(true);
  }

  getProductById(productId: number, callback: (product: Product | null) => void): void {
    const product = new Product(productId, `Product${productId}`, 99.99, "Electronics");
    callback(product);
  }

  getAllProducts(callback: (products: Product[]) => void): void {
    const products: Product[] = [];
    for (let i = 1; i <= 500; i++) {
      products.push(new Product(i, `Product${i}`, 50.0 + (i % 200), `Category${i % 10}`));
    }
    callback(products);
  }

  searchProducts(query: string, callback: (products: Product[]) => void): void {
    this.getAllProducts((products) => {
      const q = query.toLowerCase();
      const filtered = products.filter((p) => p.name.toLowerCase().includes(q));
      callback(filtered);
    });
  }

  getProductsByCategory(category: string, callback: (products: Product[]) => void): void {
    this.getAllProducts((products) => {
      const filtered = products.filter((p) => p.category === category);
      callback(filtered);
    });
  }

  getProductsByPriceRange(minPrice: number, maxPrice: number, callback: (products: Product[]) => void): void {
    this.getAllProducts((products) => {
      const filtered = products.filter((p) => p.price >= minPrice && p.price <= maxPrice);
      callback(filtered);
    });
  }

  getFeaturedProducts(count: number, callback: (products: Product[]) => void): void {
    this.getAllProducts((products) => {
      const featured = shuffled(products).slice(0, count);
      callback(featured);
    });
  }

  getProductCount(callback: (count: number) => void): void {
    callback(500);
  }

  calculateDiscount(product: Product, percentage: number, callback: (price: number) => void): void {
    const discountedPrice = product.price * (1 - percentage / 100);
    callback(discountedPrice);
  }

  isProductAvailable(productId: number, callback: (ok: boolean) => void): void {
    const available = productId % 10 !== 0;
    callback(available);
  }

  generateId(): number {
    return randomId();
  }
}

class OrderService {
  createOrder(userId: number, products: Product[], callback: (order: Order) => void): void {
    const total = products.reduce((acc, p) => acc + p.price, 0);
    const order = new Order(this.generateId(), userId, products, total);
    callback(order);
  }

  updateOrder(order: Order, callback: (order: Order) => void): void {
    const updatedOrder = order.copyTotal(order.total * 1.05);
    callback(updatedOrder);
  }

  cancelOrder(orderId: number, callback: (ok: boolean) => void): void {
    callback(true);
  }

  getOrderById(orderId: number, callback: (order: Order | null) => void): void {
    const order = new Order(orderId, 1, [new Product(1, "Sample", 99.99, "Sample")], 99.99);
    callback(order);
  }

  getOrdersByUser(userId: number, callback: (orders: Order[]) => void): void {
    const orders: Order[] = [];
    for (let i = 1; i <= 20; i++) {
      orders.push(new Order(i, userId, [new Product(i, `Product${i}`, 50.0, "Category")], 50.0));
    }
    callback(orders);
  }

  getAllOrders(callback: (orders: Order[]) => void): void {
    const orders: Order[] = [];
    for (let i = 1; i <= 200; i++) {
      orders.push(new Order(i, i % 50, [new Product(i, `Product${i}`, 75.0, "Category")], 75.0));
    }
    callback(orders);
  }

  getOrdersByStatus(status: string, callback: (orders: Order[]) => void): void {
    this.getAllOrders((orders) => {
      const key = stringHashCode(status) % 5;
      const filtered = orders.filter((o) => o.id % 5 === key);
      callback(filtered);
    });
  }

  getOrdersByDateRange(startDate: string, endDate: string, callback: (orders: Order[]) => void): void {
    this.getAllOrders((orders) => {
      const filtered = orders.filter((o) => o.id % 7 === 0);
      callback(filtered);
    });
  }

  calculateOrderTotal(products: Product[], callback: (total: number) => void): void {
    const total = products.reduce((acc, p) => acc + p.price, 0);
    callback(total);
  }

  applyDiscount(order: Order, discountPercent: number, callback: (order: Order) => void): void {
    const discountedOrder = order.copyTotal(order.total * (1 - discountPercent / 100));
    callback(discountedOrder);
  }

  getOrderCount(callback: (count: number) => void): void {
    callback(200);
  }

  getOrdersByPriceRange(minPrice: number, maxPrice: number, callback: (orders: Order[]) => void): void {
    this.getAllOrders((orders) => {
      const filtered = orders.filter((o) => o.total >= minPrice && o.total <= maxPrice);
      callback(filtered);
    });
  }

  generateId(): number {
    return randomId();
  }
}

class ReviewService {
  createReview(userId: number, productId: number, rating: number, comment: string, callback: (review: Review) => void): void {
    const review = new Review(this.generateId(), userId, productId, rating, comment);
    callback(review);
  }

  updateReview(review: Review, callback: (review: Review) => void): void {
    const updatedReview = review.copyComment(`${review.comment} [Updated]`);
    callback(updatedReview);
  }

  deleteReview(reviewId: number, callback: (ok: boolean) => void): void {
    callback(true);
  }

  getReviewById(reviewId: number, callback: (review: Review | null) => void): void {
    const review = new Review(reviewId, 1, 1, 5, "Great product!");
    callback(review);
  }

  getReviewsByProduct(productId: number, callback: (reviews: Review[]) => void): void {
    const reviews: Review[] = [];
    for (let i = 1; i <= 30; i++) {
      reviews.push(new Review(i, i % 20, productId, randomInRange(1, 5), `Review ${i}`));
    }
    callback(reviews);
  }

  getReviewsByUser(userId: number, callback: (reviews: Review[]) => void): void {
    const reviews: Review[] = [];
    for (let i = 1; i <= 15; i++) {
      reviews.push(new Review(i, userId, i % 50, randomInRange(1, 5), `User review ${i}`));
    }
    callback(reviews);
  }

  getReviewsByRating(rating: number, callback: (reviews: Review[]) => void): void {
    const reviews: Review[] = [];
    for (let i = 1; i <= 100; i++) {
      if (i % 5 === rating - 1) {
        reviews.push(new Review(i, i % 20, i % 50, rating, `Rating ${rating} review`));
      }
    }
    callback(reviews);
  }

  getAverageRating(productId: number, callback: (rating: number) => void): void {
    const rating = randomInRange(30, 50) / 10.0;
    callback(rating);
  }

  getReviewCount(productId: number, callback: (count: number) => void): void {
    const count = randomInRange(10, 100);
    callback(count);
  }

  searchReviews(query: string, callback: (reviews: Review[]) => void): void {
    const reviews: Review[] = [];
    for (let i = 1; i <= 50; i++) {
      reviews.push(new Review(i, i % 20, i % 50, randomInRange(1, 5), `Review containing ${query}`));
    }
    callback(reviews);
  }

  getTopReviews(productId: number, count: number, callback: (reviews: Review[]) => void): void {
    this.getReviewsByProduct(productId, (reviews) => {
      const top = reviews.slice().sort((a, b) => b.rating - a.rating).slice(0, count);
      callback(top);
    });
  }

  flagReview(reviewId: number, reason: string, callback: (ok: boolean) => void): void {
    callback(true);
  }

  generateId(): number {
    return randomId();
  }
}

class CategoryService {
  createCategory(name: string, description: string, callback: (category: Category) => void): void {
    const category = new Category(this.generateId(), name, description);
    callback(category);
  }

  updateCategory(category: Category, callback: (category: Category) => void): void {
    const updatedCategory = category.copyDescription(`${category.description} [Updated]`);
    callback(updatedCategory);
  }

  deleteCategory(categoryId: number, callback: (ok: boolean) => void): void {
    callback(true);
  }

  getCategoryById(categoryId: number, callback: (category: Category | null) => void): void {
    const category = new Category(categoryId, `Category${categoryId}`, `Description for category ${categoryId}`);
    callback(category);
  }

  getAllCategories(callback: (categories: Category[]) => void): void {
    const categories: Category[] = [];
    for (let i = 1; i <= 50; i++) {
      categories.push(new Category(i, `Category${i}`, `Description for category ${i}`));
    }
    callback(categories);
  }

  searchCategories(query: string, callback: (categories: Category[]) => void): void {
    this.getAllCategories((categories) => {
      const q = query.toLowerCase();
      const filtered = categories.filter((c) => c.name.toLowerCase().includes(q));
      callback(filtered);
    });
  }

  getCategoryCount(callback: (count: number) => void): void {
    callback(50);
  }

  getPopularCategories(count: number, callback: (categories: Category[]) => void): void {
    this.getAllCategories((categories) => {
      const popular = shuffled(categories).slice(0, count);
      callback(popular);
    });
  }

  getCategoryTree(callback: (tree: Map<Category, Category[]>) => void): void {
    this.getAllCategories((categories) => {
      const tree = new Map<Category, Category[]>();
      for (const parent of categories) {
        const children = categories.filter((c) => c.id !== parent.id).slice(0, 3);
        tree.set(parent, children);
      }
      callback(tree);
    });
  }

  validateCategory(category: Category, callback: (ok: boolean) => void): void {
    const isValid = category.name.trim().length > 0 && category.description.trim().length > 0;
    callback(isValid);
  }

  generateId(): number {
    return randomId();
  }
}

class InventoryService {
  addInventory(productId: number, quantity: number, location: string, callback: (inventory: Inventory) => void): void {
    const inventory = new Inventory(productId, quantity, location);
    callback(inventory);
  }

  updateInventory(inventory: Inventory, callback: (inventory: Inventory) => void): void {
    const updatedInventory = inventory.copyQuantity(inventory.quantity - 1);
    callback(updatedInventory);
  }

  removeInventory(productId: number, location: string, callback: (ok: boolean) => void): void {
    callback(true);
  }

  getInventory(productId: number, callback: (inventory: Inventory[]) => void): void {
    const inventory: Inventory[] = [];
    for (let i = 1; i <= 5; i++) {
      inventory.push(new Inventory(productId, randomInRange(10, 100), `Location${i}`));
    }
    callback(inventory);
  }

  getAllInventory(callback: (inventory: Inventory[]) => void): void {
    const inventory: Inventory[] = [];
    for (let i = 1; i <= 200; i++) {
      inventory.push(new Inventory(i % 50, randomInRange(5, 150), `Location${i % 10}`));
    }
    callback(inventory);
  }

  getInventoryByLocation(location: string, callback: (inventory: Inventory[]) => void): void {
    this.getAllInventory((inventory) => {
      const filtered = inventory.filter((inv) => inv.location === location);
      callback(filtered);
    });
  }

  getLowStockItems(threshold: number, callback: (inventory: Inventory[]) => void): void {
    this.getAllInventory((inventory) => {
      const lowStock = inventory.filter((inv) => inv.quantity < threshold);
      callback(lowStock);
    });
  }

  getTotalQuantity(productId: number, callback: (total: number) => void): void {
    this.getInventory(productId, (inventory) => {
      const total = inventory.reduce((acc, inv) => acc + inv.quantity, 0);
      callback(total);
    });
  }

  reserveInventory(productId: number, quantity: number, callback: (ok: boolean) => void): void {
    this.getTotalQuantity(productId, (total) => {
      callback(total >= quantity);
    });
  }

  releaseInventory(productId: number, quantity: number, callback: (ok: boolean) => void): void {
    callback(true);
  }

  getInventoryValue(callback: (value: number) => void): void {
    this.getAllInventory((inventory) => {
      const value = inventory.reduce((acc, inv) => acc + inv.quantity * 50.0, 0);
      callback(value);
    });
  }

  transferInventory(productId: number, fromLocation: string, toLocation: string, quantity: number, callback: (ok: boolean) => void): void {
    callback(true);
  }

  generateId(): number {
    return randomId();
  }
}

class PaymentService {
  processPayment(orderId: number, amount: number, method: string, callback: (payment: Payment) => void): void {
    const payment = new Payment(this.generateId(), orderId, amount, method);
    callback(payment);
  }

  refundPayment(paymentId: number, callback: (ok: boolean) => void): void {
    callback(true);
  }

  getPaymentById(paymentId: number, callback: (payment: Payment | null) => void): void {
    const payment = new Payment(paymentId, 1, 99.99, "credit_card");
    callback(payment);
  }

  getPaymentsByOrder(orderId: number, callback: (payments: Payment[]) => void): void {
    const payments: Payment[] = [];
    for (let i = 1; i <= 3; i++) {
      payments.push(new Payment(i, orderId, randomInRange(50, 200), "credit_card"));
    }
    callback(payments);
  }

  getAllPayments(callback: (payments: Payment[]) => void): void {
    const payments: Payment[] = [];
    for (let i = 1; i <= 300; i++) {
      payments.push(new Payment(i, i % 100, randomInRange(25, 500), "credit_card"));
    }
    callback(payments);
  }

  getPaymentsByMethod(method: string, callback: (payments: Payment[]) => void): void {
    this.getAllPayments((payments) => {
      const filtered = payments.filter((p) => p.method === method);
      callback(filtered);
    });
  }

  getPaymentsByDateRange(startDate: string, endDate: string, callback: (payments: Payment[]) => void): void {
    this.getAllPayments((payments) => {
      const filtered = payments.filter((p) => p.id % 7 === 0);
      callback(filtered);
    });
  }

  getTotalRevenue(callback: (total: number) => void): void {
    this.getAllPayments((payments) => {
      const total = payments.reduce((acc, p) => acc + p.amount, 0);
      callback(total);
    });
  }

  validatePayment(payment: Payment, callback: (ok: boolean) => void): void {
    const isValid = payment.amount > 0 && payment.method.trim().length > 0;
    callback(isValid);
  }

  getPaymentMethods(callback: (methods: string[]) => void): void {
    const methods = ["credit_card", "debit_card", "paypal", "apple_pay", "google_pay"];
    callback(methods);
  }

  calculateFees(amount: number, method: string, callback: (fee: number) => void): void {
    let fee: number;
    switch (method) {
      case "credit_card":
        fee = amount * 0.029;
        break;
      case "debit_card":
        fee = amount * 0.015;
        break;
      case "paypal":
        fee = amount * 0.035;
        break;
      default:
        fee = amount * 0.025;
        break;
    }
    callback(fee);
  }

  isPaymentAuthorized(paymentId: number, callback: (ok: boolean) => void): void {
    const authorized = paymentId % 10 !== 0;
    callback(authorized);
  }

  generateId(): number {
    return randomId();
  }
}

class ShippingService {
  createShipment(orderId: number, address: string, callback: (shipping: Shipping) => void): void {
    const shipping = new Shipping(this.generateId(), orderId, address, "pending");
    callback(shipping);
  }

  updateShippingStatus(shippingId: number, status: string, callback: (shipping: Shipping | null) => void): void {
    const shipping = new Shipping(shippingId, 1, "123 Main St", status);
    callback(shipping);
  }

  getShippingById(shippingId: number, callback: (shipping: Shipping | null) => void): void {
    const shipping = new Shipping(shippingId, 1, "123 Main St", "shipped");
    callback(shipping);
  }

  getShippingByOrder(orderId: number, callback: (shipping: Shipping | null) => void): void {
    const shipping = new Shipping(1, orderId, "456 Oak Ave", "delivered");
    callback(shipping);
  }

  getAllShipments(callback: (shipments: Shipping[]) => void): void {
    const shipments: Shipping[] = [];
    for (let i = 1; i <= 250; i++) {
      shipments.push(new Shipping(i, i % 150, `Address ${i}`, "shipped"));
    }
    callback(shipments);
  }

  getShipmentsByStatus(status: string, callback: (shipments: Shipping[]) => void): void {
    this.getAllShipments((shipments) => {
      const filtered = shipments.filter((s) => s.status === status);
      callback(filtered);
    });
  }

  trackShipment(shippingId: number, callback: (tracking: string) => void): void {
    const trackingNumber = `Tracking: SHIP${shippingId}${randomInRange(1000, 9999)}`;
    callback(trackingNumber);
  }

  estimateDelivery(address: string, callback: (estimate: string) => void): void {
    const days = randomInRange(1, 7);
    const estimate = `Estimated delivery in ${days} days`;
    callback(estimate);
  }

  calculateShippingCost(address: string, weight: number, callback: (cost: number) => void): void {
    const baseRate = 5.99;
    const weightRate = weight * 0.5;
    const cost = baseRate + weightRate;
    callback(cost);
  }

  getAvailableCarriers(callback: (carriers: string[]) => void): void {
    const carriers = ["UPS", "FedEx", "USPS", "DHL", "Amazon"];
    callback(carriers);
  }

  schedulePickup(shippingId: number, date: string, callback: (ok: boolean) => void): void {
    callback(true);
  }

  cancelShipment(shippingId: number, callback: (ok: boolean) => void): void {
    callback(true);
  }

  generateId(): number {
    return randomId();
  }
}

class NotificationService {
  sendNotification(userId: number, message: string, type: string, callback: (notification: Notification) => void): void {
    const notification = new Notification(this.generateId(), userId, message, type);
    callback(notification);
  }

  getNotificationById(notificationId: number, callback: (notification: Notification | null) => void): void {
    const notification = new Notification(notificationId, 1, "Sample notification", "info");
    callback(notification);
  }

  getNotificationsByUser(userId: number, callback: (notifications: Notification[]) => void): void {
    const notifications: Notification[] = [];
    for (let i = 1; i <= 20; i++) {
      notifications.push(new Notification(i, userId, `Notification ${i}`, "info"));
    }
    callback(notifications);
  }

  getNotificationsByType(type: string, callback: (notifications: Notification[]) => void): void {
    const notifications: Notification[] = [];
    for (let i = 1; i <= 50; i++) {
      notifications.push(new Notification(i, i % 25, `Message ${i}`, type));
    }
    callback(notifications);
  }

  markAsRead(notificationId: number, callback: (ok: boolean) => void): void {
    callback(true);
  }

  markAllAsRead(userId: number, callback: (ok: boolean) => void): void {
    callback(true);
  }

  deleteNotification(notificationId: number, callback: (ok: boolean) => void): void {
    callback(true);
  }

  getUnreadCount(userId: number, callback: (count: number) => void): void {
    const count = randomInRange(0, 15);
    callback(count);
  }

  sendBulkNotification(userIds: number[], message: string, type: string, callback: (notifications: Notification[]) => void): void {
    const notifications = userIds.map((userId) => new Notification(this.generateId(), userId, message, type));
    callback(notifications);
  }

  scheduleNotification(userId: number, message: string, type: string, scheduleTime: string, callback: (notification: Notification) => void): void {
    const notification = new Notification(this.generateId(), userId, message, type);
    callback(notification);
  }

  getNotificationTypes(callback: (types: string[]) => void): void {
    const types = ["info", "warning", "error", "success", "promotion"];
    callback(types);
  }

  updateNotificationPreferences(userId: number, preferences: Map<string, boolean>, callback: (ok: boolean) => void): void {
    callback(true);
  }

  generateId(): number {
    return randomId();
  }
}

class AnalyticsService {
  trackEvent(event: string, data: Map<string, AnyValue>, callback: (analytics: Analytics) => void): void {
    const analytics = new Analytics(this.generateId(), event, data);
    callback(analytics);
  }

  getEventById(eventId: number, callback: (analytics: Analytics | null) => void): void {
    const data = new Map<string, AnyValue>();
    data.set("page", "/home");
    const analytics = new Analytics(eventId, "page_view", data);
    callback(analytics);
  }

  getEventsByType(event: string, callback: (events: Analytics[]) => void): void {
    const events: Analytics[] = [];
    for (let i = 1; i <= 100; i++) {
      const data = new Map<string, AnyValue>();
      data.set("timestamp", "125");
      events.push(new Analytics(i, event, data));
    }
    callback(events);
  }

  getEventsByDateRange(startDate: string, endDate: string, callback: (events: Analytics[]) => void): void {
    const events: Analytics[] = [];
    for (let i = 1; i <= 500; i++) {
      const data = new Map<string, AnyValue>();
      data.set("date", startDate);
      events.push(new Analytics(i, `event_${i}`, data));
    }
    callback(events);
  }

  getUserEvents(userId: number, callback: (events: Analytics[]) => void): void {
    const events: Analytics[] = [];
    for (let i = 1; i <= 30; i++) {
      const data = new Map<string, AnyValue>();
      data.set("userId", userId);
      data.set("action", "click");
      events.push(new Analytics(i, "user_action", data));
    }
    callback(events);
  }

  getPopularEvents(count: number, callback: (events: string[]) => void): void {
    const events = ["page_view", "click", "purchase", "signup", "logout"].slice(0, count);
    callback(events);
  }

  getEventCount(event: string, callback: (count: number) => void): void {
    const count = randomInRange(100, 1000);
    callback(count);
  }

  getUniqueUsers(event: string, callback: (users: number) => void): void {
    const users = randomInRange(50, 500);
    callback(users);
  }

  generateReport(startDate: string, endDate: string, callback: (report: Map<string, AnyValue>) => void): void {
    const report = new Map<string, AnyValue>();
    report.set("totalEvents", 10000);
    report.set("uniqueUsers", 1500);
    report.set("averageSessionTime", 300);
    report.set("bounceRate", 0.35);
    callback(report);
  }

  getTopPages(count: number, callback: (pages: string[]) => void): void {
    const pages: string[] = [];
    for (let i = 1; i <= count; i++) {
      pages.push(`/page${i}`);
    }
    callback(pages);
  }

  getConversionRate(fromEvent: string, toEvent: string, callback: (rate: number) => void): void {
    const rate = randomInRange(5, 25) / 100.0;
    callback(rate);
  }

  exportAnalytics(format: string, callback: (filename: string) => void): void {
    const filename = `analytics_export.${format}`;
    callback(filename);
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

  runBenchmark(): void {
    for (let index = 0; index < 100; index++) {
      this.processUserWorkflow(index);
      this.processProductWorkflow(index);
      this.processOrderWorkflow(index);
      this.processReviewWorkflow(index);
      this.processCategoryWorkflow(index);
      this.processInventoryWorkflow(index);
      this.processPaymentWorkflow(index);
      this.processShippingWorkflow(index);
      this.processNotificationWorkflow(index);
      this.processAnalyticsWorkflow(index);
    }
  }

  processUserWorkflow(index: number): void {
    this.userService.createUser(`User${index}`, `user${index}@email.com`, 25 + (index % 50), (user) => {
      this.userService.updateUser(user, () => {
        this.userService.getUserById(user.id, () => {
          this.userService.getAllUsers(() => {
            this.userService.searchUsers("User", () => {
              this.userService.validateUser(user, () => {
                this.userService.getUsersByAge(20, 40, () => {
                  this.userService.getUserCount(() => {
                    this.userService.isEmailTaken(user.email, () => {
                      this.userService.deleteUser(user.id, () => {});
                    });
                  });
                });
              });
            });
          });
        });
      });
    });
  }

  processProductWorkflow(index: number): void {
    this.productService.createProduct(`Product${index}`, 99.99 + index, `Category${index % 10}`, (product) => {
      this.productService.updateProduct(product, () => {
        this.productService.getProductById(product.id, () => {
          this.productService.getAllProducts(() => {
            this.productService.searchProducts("Product", () => {
              this.productService.getProductsByCategory(product.category, () => {
                this.productService.getProductsByPriceRange(50.0, 200.0, () => {
                  this.productService.getFeaturedProducts(10, () => {
                    this.productService.getProductCount(() => {
                      this.productService.calculateDiscount(product, 10.0, () => {
                        this.productService.isProductAvailable(product.id, () => {
                          this.productService.deleteProduct(product.id, () => {});
                        });
                      });
                    });
                  });
                });
              });
            });
          });
        });
      });
    });
  }

  processOrderWorkflow(index: number): void {
    const products = [new Product(index, `Product${index}`, 75.0, "Category")];
    this.orderService.createOrder(index, products, (order) => {
      this.orderService.updateOrder(order, () => {
        this.orderService.getOrderById(order.id, () => {
          this.orderService.getOrdersByUser(index, () => {
            this.orderService.getAllOrders(() => {
              this.orderService.getOrdersByStatus("pending", () => {
                this.orderService.getOrdersByDateRange("2024-01-01", "2024-12-31", () => {
                  this.orderService.calculateOrderTotal(products, () => {
                    this.orderService.applyDiscount(order, 5.0, () => {
                      this.orderService.getOrderCount(() => {
                        this.orderService.getOrdersByPriceRange(50.0, 150.0, () => {
                          this.orderService.cancelOrder(order.id, () => {});
                        });
                      });
                    });
                  });
                });
              });
            });
          });
        });
      });
    });
  }

  processReviewWorkflow(index: number): void {
    this.reviewService.createReview(index, index % 50, 5, `Great product ${index}`, (review) => {
      this.reviewService.updateReview(review, () => {
        this.reviewService.getReviewById(review.id, () => {
          this.reviewService.getReviewsByProduct(index % 50, () => {
            this.reviewService.getReviewsByUser(index, () => {
              this.reviewService.getReviewsByRating(5, () => {
                this.reviewService.getAverageRating(index % 50, () => {
                  this.reviewService.getReviewCount(index % 50, () => {
                    this.reviewService.searchReviews("great", () => {
                      this.reviewService.getTopReviews(index % 50, 5, () => {
                        this.reviewService.flagReview(review.id, "spam", () => {
                          this.reviewService.deleteReview(review.id, () => {});
                        });
                      });
                    });
                  });
                });
              });
            });
          });
        });
      });
    });
  }

  processCategoryWorkflow(index: number): void {
    this.categoryService.createCategory(`Category${index}`, `Description ${index}`, (category) => {
      this.categoryService.updateCategory(category, () => {
        this.categoryService.getCategoryById(category.id, () => {
          this.categoryService.getAllCategories(() => {
            this.categoryService.searchCategories("Category", () => {
              this.categoryService.getCategoryCount(() => {
                this.categoryService.getPopularCategories(5, () => {
                  this.categoryService.getCategoryTree(() => {
                    this.categoryService.validateCategory(category, () => {
                      this.categoryService.deleteCategory(category.id, () => {});
                    });
                  });
                });
              });
            });
          });
        });
      });
    });
  }

  processInventoryWorkflow(index: number): void {
    this.inventoryService.addInventory(index, 100, `Location${index}`, (inventory) => {
      this.inventoryService.updateInventory(inventory, () => {
        this.inventoryService.getInventory(index, () => {
          this.inventoryService.getAllInventory(() => {
            this.inventoryService.getInventoryByLocation(`Location${index}`, () => {
              this.inventoryService.getLowStockItems(10, () => {
                this.inventoryService.getTotalQuantity(index, () => {
                  this.inventoryService.reserveInventory(index, 5, () => {
                    this.inventoryService.releaseInventory(index, 5, () => {
                      this.inventoryService.getInventoryValue(() => {
                        this.inventoryService.transferInventory(index, "Location1", "Location2", 10, () => {
                          this.inventoryService.removeInventory(index, `Location${index}`, () => {});
                        });
                      });
                    });
                  });
                });
              });
            });
          });
        });
      });
    });
  }

  processPaymentWorkflow(index: number): void {
    this.paymentService.processPayment(index, 99.99, "credit_card", (payment) => {
      this.paymentService.getPaymentById(payment.id, () => {
        this.paymentService.getPaymentsByOrder(index, () => {
          this.paymentService.getAllPayments(() => {
            this.paymentService.getPaymentsByMethod("credit_card", () => {
              this.paymentService.getPaymentsByDateRange("2024-01-01", "2024-12-31", () => {
                this.paymentService.getTotalRevenue(() => {
                  this.paymentService.validatePayment(payment, () => {
                    this.paymentService.getPaymentMethods(() => {
                      this.paymentService.calculateFees(99.99, "credit_card", () => {
                        this.paymentService.isPaymentAuthorized(payment.id, () => {
                          this.paymentService.refundPayment(payment.id, () => {});
                        });
                      });
                    });
                  });
                });
              });
            });
          });
        });
      });
    });
  }

  processShippingWorkflow(index: number): void {
    this.shippingService.createShipment(index, `Address ${index}`, (shipping) => {
      this.shippingService.updateShippingStatus(shipping.id, "shipped", () => {
        this.shippingService.getShippingById(shipping.id, () => {
          this.shippingService.getShippingByOrder(index, () => {
            this.shippingService.getAllShipments(() => {
              this.shippingService.getShipmentsByStatus("shipped", () => {
                this.shippingService.trackShipment(shipping.id, () => {
                  this.shippingService.estimateDelivery(`Address ${index}`, () => {
                    this.shippingService.calculateShippingCost(`Address ${index}`, 5.0, () => {
                      this.shippingService.getAvailableCarriers(() => {
                        this.shippingService.schedulePickup(shipping.id, "2024-12-25", () => {
                          this.shippingService.cancelShipment(shipping.id, () => {});
                        });
                      });
                    });
                  });
                });
              });
            });
          });
        });
      });
    });
  }

  processNotificationWorkflow(index: number): void {
    this.notificationService.sendNotification(index, `Message ${index}`, "info", (notification) => {
      this.notificationService.getNotificationById(notification.id, () => {
        this.notificationService.getNotificationsByUser(index, () => {
          this.notificationService.getNotificationsByType("info", () => {
            this.notificationService.markAsRead(notification.id, () => {
              this.notificationService.markAllAsRead(index, () => {
                this.notificationService.getUnreadCount(index, () => {
                  this.notificationService.sendBulkNotification([index], "Bulk message", "info", () => {
                    this.notificationService.scheduleNotification(index, "Scheduled", "info", "2024-12-25", () => {
                      this.notificationService.getNotificationTypes(() => {
                        const prefs = new Map<string, boolean>();
                        prefs.set("email", true);
                        this.notificationService.updateNotificationPreferences(index, prefs, () => {
                          this.notificationService.deleteNotification(notification.id, () => {});
                        });
                      });
                    });
                  });
                });
              });
            });
          });
        });
      });
    });
  }

  processAnalyticsWorkflow(index: number): void {
    const eventData = new Map<string, AnyValue>();
    eventData.set("data", index);
    this.analyticsService.trackEvent(`event_${index}`, eventData, (analytics) => {
      this.analyticsService.getEventById(analytics.id, () => {
        this.analyticsService.getEventsByType(`event_${index}`, () => {
          this.analyticsService.getEventsByDateRange("2024-01-01", "2024-12-31", () => {
            this.analyticsService.getUserEvents(index, () => {
              this.analyticsService.getPopularEvents(5, () => {
                this.analyticsService.getEventCount(`event_${index}`, () => {
                  this.analyticsService.getUniqueUsers(`event_${index}`, () => {
                    this.analyticsService.generateReport("2024-01-01", "2024-12-31", () => {
                      this.analyticsService.getTopPages(10, () => {
                        this.analyticsService.getConversionRate("view", "purchase", () => {
                          this.analyticsService.exportAnalytics("csv", () => {});
                        });
                      });
                    });
                  });
                });
              });
            });
          });
        });
      });
    });
  }
}

export function runBenchmark(): void {
  const benchmark = new IosSizeBenchmark();
  benchmark.runBenchmark();
  console.log("Callback benchmark completed");
}
