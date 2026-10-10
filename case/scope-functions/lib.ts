/*
 * iOS Size Benchmark - Test Case Implementation
 * Generated with Claude AI (https://claude.ai)
 *
 * scriptc (TypeScript-to-native) port of the Kotlin/Swift "scope-functions"
 * case. Kotlin's scope functions have no TypeScript equivalent, so each is
 * modeled as a small generic helper preserving the exact return/sequencing
 * semantics:
 *   x.let { f(it) }   -> letFn(x, f)      (returns lambda result)
 *   x.run { f(this) } -> runFn(x, f)      (returns lambda result)
 *   with(x) { f(this)}-> withFn(x, f)     (returns lambda result)
 *   x.apply { ... }   -> applyFn(x, f)    (runs f(x) for mutation, returns x)
 *   x.also { ... }    -> alsoFn(x, f)     (runs f(x) side effect, returns x)
 *   x.takeIf { p(it) }-> takeIfFn(x, p)   (returns x or null)
 * Kotlin safe-call `x?.let { }` is modeled as an explicit null check around
 * the helper. A single exported entry (runBenchmark) exercises every type and
 * method so nothing is dead-code eliminated.
 */

// Test case: Scope Functions - let/run/apply/also/with/takeIf as helpers

// --- Scope-function helpers ---
function letFn<T, R>(value: T, block: (it: T) => R): R {
  return block(value);
}

function runFn<T, R>(value: T, block: (self: T) => R): R {
  return block(value);
}

function withFn<T, R>(value: T, block: (self: T) => R): R {
  return block(value);
}

function applyFn<T>(value: T, block: (self: T) => void): T {
  block(value);
  return value;
}

function alsoFn<T>(value: T, block: (it: T) => void): T {
  block(value);
  return value;
}

function takeIfFn<T>(value: T, predicate: (it: T) => boolean): T | null {
  return predicate(value) ? value : null;
}

// Narrow union for Kotlin's heterogeneous Map<String, Any> summary payloads
// (the static tier forbids `any`).
type SummaryValue =
  | string
  | number
  | boolean
  | string[]
  | Map<string, string | number | boolean | string[]>
  | Array<Map<string, string | number | boolean>>;

// --- Data models (Kotlin `data class` with mutable `var` fields) ---
class Address {
  constructor(
    public street: string,
    public city: string,
    public state: string,
    public zipCode: string,
    public country: string,
  ) {}
}

class UserPreferences {
  constructor(
    public theme: string,
    public language: string,
    public notifications: boolean,
    public newsletter: boolean,
  ) {}
}

class User {
  address: Address | null = null;
  preferences: UserPreferences | null = null;
  constructor(
    public id: string,
    public name: string,
    public email: string,
    public age: number,
  ) {}
}

class Product {
  tags: string[] = [];
  constructor(
    public id: string,
    public name: string,
    public price: number,
    public category: string,
    public description: string,
    public inStock: boolean,
  ) {}
}

class CartItem {
  constructor(
    public productId: string,
    public quantity: number,
    public price: number,
  ) {}
}

class ShoppingCart {
  items: CartItem[] = [];
  discountCode: string | null = null;
  discountAmount = 0.0;
  constructor(
    public id: string,
    public userId: string,
  ) {}
}

class Order {
  constructor(
    public id: string,
    public cart: ShoppingCart,
    public shippingAddress: Address,
    public paymentMethod: string,
    public status: string,
    public timestamp: number,
  ) {}
}

class BankAccount {
  constructor(
    public accountNumber: string,
    public balance: number,
    public accountType: string,
    public isActive: boolean,
  ) {}
}

class ApiResponse<T> {
  data: T | null = null;
  errorMessage: string | null = null;
  statusCode = 0;
  headers = new Map<string, string>();
}

class ConnectionPoolConfig {
  constructor(
    public minConnections: number,
    public maxConnections: number,
    public timeout: number,
  ) {}
}

class DatabaseConfig {
  connectionPool: ConnectionPoolConfig | null = null;
  constructor(
    public host: string,
    public port: number,
    public database: string,
    public username: string,
    public password: string,
  ) {}
}

class AppConfig {
  features = new Map<string, boolean>();
  settings = new Map<string, string>();
  constructor(
    public appName: string,
    public version: string,
    public environment: string,
    public database: DatabaseConfig,
  ) {}
}

// --- Service classes demonstrating scope-function usage ---
class UserService {
  createUser(name: string, email: string, age: number): User {
    // 'apply' for object initialization and configuration
    return applyFn(new User("", "", "", 0), (u) => {
      u.id = this.generateUserId();
      u.name = name;
      u.email = email;
      u.age = age;
      u.address = applyFn(new Address("", "", "", "", ""), (a) => {
        a.street = "";
        a.city = "";
        a.state = "";
        a.zipCode = "";
        a.country = "USA";
      });
      u.preferences = applyFn(new UserPreferences("", "", false, false), (p) => {
        p.theme = "light";
        p.language = "en";
        p.notifications = true;
        p.newsletter = false;
      });
    });
  }

  updateUserWithValidation(user: User, newEmail: string | null, newAge: number | null): User | null {
    // 'let' for null-safe operations and transformations
    return letFn(user, (validUser) => {
      let updated = false;
      if (newEmail !== null) {
        letFn(newEmail, (email) => {
          if (email.includes("@")) {
            validUser.email = email;
            updated = true;
          }
        });
      }
      if (newAge !== null) {
        letFn(newAge, (age) => {
          if (age > 0 && age < 120) {
            validUser.age = age;
            updated = true;
          }
        });
      }
      return updated ? validUser : null;
    });
  }

  processUserData(user: User | null): string {
    // 'let' with null safety
    return user !== null
      ? letFn(user, (validUser) => `Processing user: ${validUser.name} (${validUser.email})`)
      : "No user to process";
  }

  configureUserPreferences(user: User): User {
    // 'also' for side effects while returning the original object
    return alsoFn(user, (userData) => {
      const prefs = userData.preferences;
      if (prefs !== null) {
        alsoFn(prefs, (p) => {
          p.theme = "dark";
          p.notifications = true;
          this.logPreferenceChange(userData.id, "theme", "dark");
          this.logPreferenceChange(userData.id, "notifications", "enabled");
        });
      }
    });
  }

  validateAndFormatUser(user: User): string {
    // 'run' for complex operations on the object
    return runFn(user, (self) => {
      const isValidEmail = self.email.includes("@");
      const isValidAge = self.age >= 1 && self.age <= 120;
      const hasAddress = self.address !== null;
      if (!isValidEmail) {
        return `Invalid email: ${self.email}`;
      } else if (!isValidAge) {
        return `Invalid age: ${self.age}`;
      } else if (!hasAddress) {
        return "Missing address information";
      } else {
        return `Valid user: ${self.name} (${self.email}, age ${self.age})`;
      }
    });
  }

  getUserSummary(user: User | null): Map<string, SummaryValue> {
    // 'let' with complex transformations
    if (user === null) {
      return new Map<string, SummaryValue>();
    }
    return letFn(user, (validUser) => {
      const summary = new Map<string, SummaryValue>();
      summary.set("id", validUser.id);
      summary.set("name", validUser.name);
      summary.set("email", validUser.email);
      summary.set("age", validUser.age);
      summary.set("hasAddress", validUser.address !== null);
      summary.set("hasPreferences", validUser.preferences !== null);
      const addr = validUser.address;
      summary.set(
        "addressSummary",
        addr !== null ? letFn(addr, (a) => `${a.city}, ${a.state}, ${a.country}`) : "No address",
      );
      const prefs = validUser.preferences;
      summary.set(
        "preferencesSummary",
        prefs !== null
          ? letFn(prefs, (p) => `Theme: ${p.theme}, Language: ${p.language}`)
          : "No preferences",
      );
      return summary;
    });
  }

  generateUserId(): string {
    return "USER_12345";
  }

  logPreferenceChange(userId: string, key: string, value: string): void {
    // Logging implementation
  }
}

class ProductService {
  createProduct(name: string, price: number, category: string): Product {
    // 'apply' for fluent object initialization
    return applyFn(new Product("", "", 0.0, "", "", false), (p) => {
      p.id = this.generateProductId();
      p.name = name;
      p.price = price;
      p.category = category;
      p.description = `Default description for ${name}`;
      p.inStock = true;
      applyFn(p.tags, (tags) => {
        tags.push("new");
        tags.push(category.toLowerCase());
        if (price > 100) {
          tags.push("premium");
        }
      });
    });
  }

  updateProductPrice(product: Product, newPrice: number): Product | null {
    // 'takeIf' with 'apply' for conditional updates
    const candidate = takeIfFn(product, () => newPrice > 0);
    if (candidate === null) {
      return null;
    }
    return applyFn(candidate, (p) => {
      const oldPrice = p.price;
      p.price = newPrice;
      applyFn(p.tags, (tags) => {
        removeFromList(tags, "budget");
        removeFromList(tags, "premium");
        removeFromList(tags, "luxury");
        if (newPrice < 50) {
          tags.push("budget");
        } else if (newPrice > 500) {
          tags.push("luxury");
        } else if (newPrice > 100) {
          tags.push("premium");
        }
      });
      this.logPriceChange(p.id, oldPrice, newPrice);
    });
  }

  processProductBatch(products: Product[]): string[] {
    // scope functions in collection operations
    const result: string[] = [];
    for (const product of products) {
      const available = takeIfFn(product, (it) => it.inStock);
      if (available !== null) {
        result.push(
          letFn(available, (p) => `Processing: ${p.name} - $${p.price}`),
        );
      }
    }
    return result;
  }

  configureProductForSale(product: Product, discountPercent: number): Product {
    // 'also' for side effects during configuration
    return alsoFn(product, (prod) => {
      alsoFn(
        applyFn(prod, (p) => {
          p.price *= 1 - discountPercent / 100;
          p.tags.push("sale");
          p.tags.push("discounted");
        }),
        () => {
          this.logSaleConfiguration(prod.id, discountPercent);
          this.notifyPriceChange(prod.id, prod.price);
        },
      );
    });
  }

  analyzeProduct(product: Product): Map<string, SummaryValue> {
    // 'run' for complex analysis
    return runFn(product, (self) => {
      let priceCategory: string;
      if (self.price < 20) {
        priceCategory = "budget";
      } else if (self.price < 100) {
        priceCategory = "mid-range";
      } else if (self.price < 500) {
        priceCategory = "premium";
      } else {
        priceCategory = "luxury";
      }
      const tagAnalysis = runFn(self.tags, (tags) => {
        const promo = ["sale", "new", "featured"];
        const cats = ["electronics", "clothing", "books"];
        const m = new Map<string, string | number | boolean | string[]>();
        m.set("tagCount", tags.length);
        m.set("hasPromoTags", tags.some((it) => promo.includes(it)));
        m.set("categoryTags", tags.filter((it) => cats.includes(it)));
        return m;
      });
      const result = new Map<string, SummaryValue>();
      result.set("productId", self.id);
      result.set("priceCategory", priceCategory);
      result.set("availability", self.inStock ? "available" : "out_of_stock");
      result.set("tagAnalysis", tagAnalysis);
      result.set(
        "summary",
        `${self.name} (${priceCategory}) - ${self.inStock ? "In Stock" : "Out of Stock"}`,
      );
      return result;
    });
  }

  generateProductId(): string {
    return "PROD_12345";
  }

  logPriceChange(productId: string, oldPrice: number, newPrice: number): void {}
  logSaleConfiguration(productId: string, discount: number): void {}
  notifyPriceChange(productId: string, newPrice: number): void {}
}

// Kotlin MutableList.remove(element): remove first occurrence if present.
function removeFromList<T>(list: T[], element: T): void {
  const idx = list.indexOf(element);
  if (idx !== -1) {
    list.splice(idx, 1);
  }
}

class ShoppingCartService {
  createCart(userId: string): ShoppingCart {
    // 'apply' for cart initialization
    return applyFn(new ShoppingCart("", ""), (c) => {
      c.id = this.generateCartId();
      c.userId = userId;
      c.items = [];
      c.discountAmount = 0.0;
    });
  }

  addItemToCart(cart: ShoppingCart, productId: string, quantity: number, price: number): ShoppingCart {
    // 'also' to perform side effects while returning the original object
    return alsoFn(cart, (cartData) => {
      cartData.items.push(
        applyFn(new CartItem(productId, quantity, price), () => {
          // Additional item configuration could go here
        }),
      );
      this.logCartItemAdded(cartData.id, productId, quantity);
    });
  }

  applyDiscount(cart: ShoppingCart, discountCode: string): ShoppingCart | null {
    // 'takeIf' with validation and 'apply'/'also'
    const valid = takeIfFn(cart, () => this.validateDiscountCode(discountCode));
    if (valid === null) {
      return null;
    }
    const updated = applyFn(valid, (c) => {
      c.discountCode = discountCode;
      c.discountAmount = this.calculateDiscount(c, discountCode);
    });
    return alsoFn(updated, (updatedCart) => {
      this.logDiscountApplied(updatedCart.id, discountCode, updatedCart.discountAmount);
    });
  }

  processCartCheckout(
    cart: ShoppingCart,
    shippingAddress: Address,
    paymentMethod: string,
  ): Order | null {
    // 'let' for complex transformation with validation
    const valid = takeIfFn(cart, (it) => it.items.length > 0);
    if (valid === null) {
      return null;
    }
    return letFn(valid, (validCart) => {
      const order = applyFn(
        new Order("", validCart, shippingAddress, paymentMethod, "", 0),
        (o) => {
          o.id = this.generateOrderId();
          o.status = "pending";
          o.timestamp = 1640995200000;
        },
      );
      return alsoFn(order, (newOrder) => {
        this.logOrderCreated(newOrder.id, validCart.id);
        this.clearCart(validCart);
      });
    });
  }

  calculateCartSummary(cart: ShoppingCart): Map<string, SummaryValue> {
    // 'run' for complex calculations
    return runFn(cart, (self) => {
      const subtotal = self.items.reduce((acc, it) => acc + it.price * it.quantity, 0);
      const total = subtotal - self.discountAmount;
      const itemCount = self.items.reduce((acc, it) => acc + it.quantity, 0);
      const result = new Map<string, SummaryValue>();
      result.set("cartId", self.id);
      result.set("itemCount", itemCount);
      result.set("subtotal", subtotal);
      result.set("discountAmount", self.discountAmount);
      result.set("total", total);
      result.set("hasDiscount", self.discountCode !== null);
      result.set("discountCode", self.discountCode !== null ? self.discountCode : "none");
      const items: Array<Map<string, string | number | boolean>> = self.items.map((item) => {
        const m = new Map<string, string | number | boolean>();
        m.set("productId", item.productId);
        m.set("quantity", item.quantity);
        m.set("price", item.price);
        m.set("total", item.price * item.quantity);
        return m;
      });
      result.set("items", items);
      return result;
    });
  }

  generateCartId(): string {
    return "CART_12345";
  }
  generateOrderId(): string {
    return "ORDER_12345";
  }
  validateDiscountCode(code: string): boolean {
    return code.length > 0;
  }
  calculateDiscount(cart: ShoppingCart, code: string): number {
    return 10.0;
  }
  logCartItemAdded(cartId: string, productId: string, quantity: number): void {}
  logDiscountApplied(cartId: string, code: string, amount: number): void {}
  logOrderCreated(orderId: string, cartId: string): void {}
  clearCart(cart: ShoppingCart): void {
    cart.items = [];
  }
}

class BankingService {
  createAccount(accountNumber: string, accountType: string): BankAccount {
    // 'apply' for account setup, 'also' for the side-effecting log
    return alsoFn(
      applyFn(new BankAccount("", 0.0, "", false), (a) => {
        a.accountNumber = accountNumber;
        a.balance = 0.0;
        a.accountType = accountType;
        a.isActive = true;
      }),
      (newAccount) => {
        this.logAccountCreated(newAccount.accountNumber, newAccount.accountType);
      },
    );
  }

  processTransaction(account: BankAccount, amount: number, type: string): BankAccount | null {
    // 'takeIf' with validation
    const active = takeIfFn(account, (it) => it.isActive);
    if (active === null) {
      return null;
    }
    return letFn(active, (activeAccount) => {
      if (type === "deposit") {
        return alsoFn(
          applyFn(activeAccount, (a) => {
            a.balance += amount;
          }),
          (it) => this.logTransaction(it.accountNumber, amount, type),
        );
      } else if (type === "withdrawal") {
        const sufficient = takeIfFn(activeAccount, (it) => it.balance >= amount);
        if (sufficient === null) {
          return null;
        }
        return alsoFn(
          applyFn(sufficient, (a) => {
            a.balance -= amount;
          }),
          (it) => this.logTransaction(it.accountNumber, amount, type),
        );
      } else {
        return null;
      }
    });
  }

  generateAccountStatement(account: BankAccount): Map<string, SummaryValue> {
    // 'run' for complex statement generation
    return runFn(account, (self) => {
      let accountStatus: string;
      if (!self.isActive) {
        accountStatus = "inactive";
      } else if (self.balance < 0) {
        accountStatus = "overdrawn";
      } else if (self.balance < 100) {
        accountStatus = "low_balance";
      } else {
        accountStatus = "normal";
      }
      const result = new Map<string, SummaryValue>();
      result.set("accountNumber", self.accountNumber);
      result.set("accountType", self.accountType);
      result.set("balance", self.balance);
      result.set("status", accountStatus);
      result.set("isActive", self.isActive);
      result.set("formattedBalance", `$${self.balance}`);
      result.set("canWithdraw", self.isActive && self.balance > 0);
      result.set(
        "summary",
        `${self.accountType} account #${self.accountNumber}: ${self.balance} (${accountStatus})`,
      );
      return result;
    });
  }

  transferFunds(
    fromAccount: BankAccount,
    toAccount: BankAccount,
    amount: number,
  ): Pair<BankAccount | null, BankAccount | null> {
    // scope functions for complex transfer logic
    const validFrom = takeIfFn(fromAccount, (it) => it.isActive && it.balance >= amount);
    if (validFrom !== null) {
      const validTo = takeIfFn(toAccount, (it) => it.isActive);
      if (validTo !== null) {
        const updatedFrom = applyFn(validFrom, (a) => {
          a.balance -= amount;
        });
        const updatedTo = applyFn(validTo, (a) => {
          a.balance += amount;
        });
        this.logTransfer(validFrom.accountNumber, validTo.accountNumber, amount);
        return new Pair<BankAccount | null, BankAccount | null>(updatedFrom, updatedTo);
      }
    }
    return new Pair<BankAccount | null, BankAccount | null>(null, null);
  }

  logAccountCreated(accountNumber: string, type: string): void {}
  logTransaction(accountNumber: string, amount: number, type: string): void {}
  logTransfer(fromAccount: string, toAccount: string, amount: number): void {}
}

// Kotlin Pair<A, B>.
class Pair<A, B> {
  constructor(
    public readonly first: A,
    public readonly second: B,
  ) {}
}

// --- API service demonstrating scope-function usage ---
class ApiService {
  processApiResponse<T>(response: ApiResponse<T>): T | null {
    // 'takeIf' + 'let' for response validation
    const valid = takeIfFn(response, (it) => it.statusCode >= 200 && it.statusCode <= 299);
    if (valid !== null) {
      const data = valid.data;
      if (data !== null) {
        alsoFn(data, () => {
          this.logSuccessfulResponse(valid.statusCode);
        });
        return data;
      }
      return null;
    }
    this.logErrorResponse(
      response.statusCode,
      response.errorMessage !== null ? response.errorMessage : "Unknown error",
    );
    return null;
  }

  createApiResponse<T>(data: T | null, statusCode: number, errorMessage: string | null): ApiResponse<T> {
    // 'apply' for response building
    return applyFn(new ApiResponse<T>(), (r) => {
      r.data = data;
      r.statusCode = statusCode;
      r.errorMessage = errorMessage;
      applyFn(r.headers, (h) => {
        h.set("Content-Type", "application/json");
        h.set("Timestamp", "1640995200000");
        h.set("Server", "Kotlin-Service");
      });
    });
  }
  handleApiError<T>(response: ApiResponse<T>): string {
    // 'run' for error handling
    return runFn(response, (self) => {
      const err = self.errorMessage !== null ? self.errorMessage : "Unknown error";
      switch (self.statusCode) {
        case 404:
          return `Resource not found: ${self.errorMessage !== null ? self.errorMessage : "Unknown resource"}`;
        case 401:
          return "Unauthorized access";
        case 403:
          return "Forbidden operation";
        case 500:
          return `Internal server error: ${err}`;
        default:
          return `API error (${self.statusCode}): ${err}`;
      }
    });
  }

  retryApiCall<T>(maxRetries: number, apiCall: () => ApiResponse<T>): ApiResponse<T> | null {
    // scope functions in retry logic
    for (let attempt = 0; attempt < maxRetries; attempt++) {
      const response = apiCall();
      const success = takeIfFn(response, (it) => it.statusCode >= 200 && it.statusCode <= 299);
      if (success !== null) {
        return alsoFn(success, () => {
          this.logRetrySuccess(attempt + 1, maxRetries);
        });
      }
      if (attempt < maxRetries - 1) {
        this.logRetryAttempt(attempt + 1, maxRetries, response.statusCode);
      }
    }
    return null;
  }

  logSuccessfulResponse(statusCode: number): void {}
  logErrorResponse(statusCode: number, error: string): void {}
  logRetrySuccess(attempt: number, maxRetries: number): void {}
  logRetryAttempt(attempt: number, maxRetries: number, statusCode: number): void {}
}

// --- Configuration service demonstrating scope-function usage ---
class ConfigurationService {
  createDatabaseConfig(host: string, port: number, database: string): DatabaseConfig {
    // 'apply' for complex configuration
    return applyFn(new DatabaseConfig("", 0, "", "", ""), (c) => {
      c.host = host;
      c.port = port;
      c.database = database;
      c.username = "defaultUser";
      c.password = "defaultPassword";
      c.connectionPool = applyFn(new ConnectionPoolConfig(0, 0, 0), (pool) => {
        pool.minConnections = 5;
        pool.maxConnections = 20;
        pool.timeout = 30000;
      });
    });
  }

  createAppConfig(appName: string, version: string, environment: string): AppConfig {
    // 'apply' with nested configuration, 'also' for the log
    return alsoFn(
      applyFn(new AppConfig("", "", "", new DatabaseConfig("", 0, "", "", "")), (c) => {
        c.appName = appName;
        c.version = version;
        c.environment = environment;
        c.database = this.createDatabaseConfig("localhost", 5432, "app_db");
        applyFn(c.features, (f) => {
          f.set("feature_flags", true);
          f.set("analytics", environment !== "development");
          f.set("logging", true);
          f.set("cache", environment === "production");
        });
        applyFn(c.settings, (s) => {
          s.set("log_level", environment === "production" ? "ERROR" : "DEBUG");
          s.set("cache_ttl", "3600");
          s.set("max_connections", "100");
          s.set("timeout", "30000");
        });
      }),
      (config) => {
        this.logConfigurationCreated(config.appName, config.environment);
      },
    );
  }
  validateConfiguration(config: AppConfig): Map<string, SummaryValue> {
    // 'run' for validation logic
    return runFn(config, (self) => {
      const issues: string[] = [];
      if (self.appName.length === 0) issues.push("App name is required");
      if (self.version.length === 0) issues.push("Version is required");
      const envs = ["development", "staging", "production"];
      if (!envs.includes(self.environment)) {
        issues.push(`Invalid environment: ${self.environment}`);
      }
      runFn(self.database, (db) => {
        if (db.host.length === 0) issues.push("Database host is required");
        if (db.port <= 0) issues.push("Database port must be positive");
        if (db.database.length === 0) issues.push("Database name is required");
      });
      const result = new Map<string, SummaryValue>();
      result.set("isValid", issues.length === 0);
      result.set("issues", issues);
      result.set(
        "summary",
        issues.length === 0 ? "Configuration is valid" : `Found ${issues.length} issues`,
      );
      return result;
    });
  }

  updateConfiguration(config: AppConfig, updates: Map<string, string>): AppConfig {
    // 'also' for configuration updates
    const updated = alsoFn(config, (cfg) => {
      updates.forEach((value, key) => {
        cfg.settings.set(key, value);
      });
    });
    return alsoFn(updated, (updatedConfig) => {
      const keys: string[] = [];
      updates.forEach((_value, key) => keys.push(key));
      this.logConfigurationUpdated(updatedConfig.appName, keys);
    });
  }

  logConfigurationCreated(appName: string, environment: string): void {}
  logConfigurationUpdated(appName: string, updatedKeys: string[]): void {}
}

// A single exported entry drives every service so nothing is dead-code
// eliminated — the scriptc analogue of the Swift `public` requirement.
export function runBenchmark(): void {
  const userService = new UserService();
  const productService = new ProductService();
  const cartService = new ShoppingCartService();
  const bankingService = new BankingService();
  const apiService = new ApiService();
  const configService = new ConfigurationService();

  // User service demonstrations
  const user = userService.createUser("John Doe", "john@example.com", 30);
  const updatedUser = userService.updateUserWithValidation(user, "newemail@test.com", 31);
  const processedData = userService.processUserData(updatedUser);
  const configuredUser = userService.configureUserPreferences(user);
  const validationResult = userService.validateAndFormatUser(user);
  const userSummary = userService.getUserSummary(user);

  // Product service demonstrations
  const product = productService.createProduct("Laptop", 999.99, "Electronics");
  const updatedProduct = productService.updateProductPrice(product, 899.99);
  const saleProduct = productService.configureProductForSale(product, 15.0);
  const productAnalysis = productService.analyzeProduct(product);
  const products = [
    productService.createProduct("Mouse", 29.99, "Electronics"),
    productService.createProduct("Keyboard", 79.99, "Electronics"),
    productService.createProduct("Monitor", 299.99, "Electronics"),
  ];
  const processedProducts = productService.processProductBatch(products);

  // Shopping cart demonstrations
  const cart = cartService.createCart("USER_123");
  const cartWithItems = letFn(
    letFn(cartService.addItemToCart(cart, "PROD_1", 2, 29.99), (c) =>
      cartService.addItemToCart(c, "PROD_2", 1, 79.99),
    ),
    (c) => cartService.addItemToCart(c, "PROD_3", 1, 299.99),
  );
  const discountedCart = cartService.applyDiscount(cartWithItems, "SAVE10");
  const cartSummary = cartService.calculateCartSummary(cartWithItems);
  const address = new Address("123 Main St", "New York", "NY", "10001", "USA");
  const order = cartService.processCartCheckout(cartWithItems, address, "credit_card");

  // Banking demonstrations
  const checkingAccount = bankingService.createAccount("CHK001", "checking");
  const savingsAccount = bankingService.createAccount("SAV001", "savings");
  const accountAfterDeposit = bankingService.processTransaction(checkingAccount, 1000.0, "deposit");
  const accountAfterWithdrawal =
    accountAfterDeposit !== null
      ? bankingService.processTransaction(accountAfterDeposit, 250.0, "withdrawal")
      : null;
  const accountStatement =
    accountAfterWithdrawal !== null
      ? bankingService.generateAccountStatement(accountAfterWithdrawal)
      : null;
  const transfer = bankingService.transferFunds(checkingAccount, savingsAccount, 500.0);

  // API service demonstrations
  const successResponse = apiService.createApiResponse("Success data", 200, null);
  const errorResponse = apiService.createApiResponse<string>(null, 404, "Not found");
  const processedSuccess = apiService.processApiResponse(successResponse);
  const processedError = apiService.processApiResponse(errorResponse);
  const errorMessage = apiService.handleApiError(errorResponse);
  const retried = apiService.retryApiCall(3, () => apiService.createApiResponse("ok", 200, null));

  // Configuration demonstrations
  const dbConfig = configService.createDatabaseConfig("localhost", 5432, "myapp_db");
  const appConfig = configService.createAppConfig("MyApp", "1.0.0", "production");
  const configValidation = configService.validateConfiguration(appConfig);
  const updates = new Map<string, string>([
    ["log_level", "INFO"],
    ["cache_ttl", "7200"],
  ]);
  const updatedConfig = configService.updateConfiguration(appConfig, updates);
  // Complex scope-function chaining demonstrations
  const complexUserProcessing = [
    new User("1", "Alice", "alice@test.com", 25),
    new User("2", "Bob", "bob@example.com", 35),
    new User("3", "Charlie", "charlie@company.org", 45),
  ]
    .map((u) =>
      applyFn(u, (it) => {
        it.preferences = new UserPreferences("dark", "en", true, false);
      }),
    )
    .filter((u) => u.email.includes("@"))
    .map((u) => userService.getUserSummary(u));

  // Complex product processing chain
  const productProcessingChain: Array<Map<string, SummaryValue>> = [];
  for (let i = 1; i <= 10; i++) {
    const prod = productService.createProduct(`Product ${i}`, i * 10.0, `Category${i % 3}`);
    const repriced = productService.updateProductPrice(prod, prod.price * 0.9);
    const kept = repriced !== null ? takeIfFn(repriced, (it) => it.price > 50) : null;
    if (kept !== null) {
      const onSale = productService.configureProductForSale(kept, 20.0);
      productProcessingChain.push(productService.analyzeProduct(onSale));
    }
  }

  // Complex cart and order processing
  const orderProcessingChain: Array<Map<string, SummaryValue>> = [];
  for (const userId of ["USER_1", "USER_2", "USER_3"]) {
    const c = applyFn(cartService.createCart(userId), (self) => {
      for (const p of products.slice(0, 3)) {
        cartService.addItemToCart(self, p.id, 1, p.price);
      }
    });
    const discounted = cartService.applyDiscount(c, "SAVE15");
    if (discounted !== null) {
      orderProcessingChain.push(cartService.calculateCartSummary(discounted));
    }
  }

  // Banking operation chains
  const bankingOperations: Array<Map<string, SummaryValue>> = [];
  const accountSpecs: Array<Pair<string, string>> = [
    new Pair("ACC001", "checking"),
    new Pair("ACC002", "savings"),
    new Pair("ACC003", "business"),
  ];
  for (const spec of accountSpecs) {
    const account = bankingService.createAccount(spec.first, spec.second);
    const deposited = bankingService.processTransaction(account, 1000.0, "deposit");
    const withdrawn =
      deposited !== null ? bankingService.processTransaction(deposited, 100.0, "withdrawal") : null;
    if (withdrawn !== null) {
      bankingOperations.push(bankingService.generateAccountStatement(withdrawn));
    }
  }

  // API response processing chains
  const apiResponseChain = [
    new Pair(200, "Success"),
    new Pair(404, "Not Found"),
    new Pair(500, "Server Error"),
  ]
    .map((p) =>
      p.first === 200
        ? apiService.createApiResponse("Data", p.first, null)
        : apiService.createApiResponse<string>(null, p.first, p.second),
    )
    .map((response) => {
      const ok = takeIfFn(response, (it) => it.statusCode >= 200 && it.statusCode <= 299);
      return ok !== null
        ? `Success: ${apiService.processApiResponse(ok)}`
        : `Error: ${apiService.handleApiError(response)}`;
    });

  // Configuration processing chains
  const configChain = [
    new Pair("App1", "development"),
    new Pair("App2", "staging"),
    new Pair("App3", "production"),
  ]
    .map((p) => configService.createAppConfig(p.first, "1.0.0", p.second))
    .map((config) => {
      const validation = configService.validateConfiguration(config);
      return validation.get("isValid") === true
        ? config
        : applyFn(config, (c) => {
            if (c.appName.length === 0) c.appName = "DefaultApp";
            if (c.version.length === 0) c.version = "1.0.0";
          });
    })
    .map((config) =>
      configService.updateConfiguration(
        config,
        new Map<string, string>([
          ["log_level", "INFO"],
          ["timeout", "60000"],
        ]),
      ),
    );

  // Nested scope-function usage
  const nestedResult = letFn(
    runFn(
      alsoFn(
        letFn(
          applyFn(user, (self) => {
            self.name = `Updated ${self.name}`;
            self.email = self.email.toLowerCase();
          }),
          (uu) => userService.validateAndFormatUser(uu),
        ),
        () => {},
      ),
      (msg) => msg.length > 10,
    ),
    (isLong) => (isLong ? "Long validation message" : "Short validation message"),
  );

  // Error handling with scope functions
  const safeUser = takeIfFn(user, (it) => it.age > 0);
  let safeOperation = "Invalid user data";
  if (safeUser !== null) {
    const addr = safeUser.address;
    const validAddr = addr !== null ? takeIfFn(addr, (it) => it.zipCode.length > 0) : null;
    safeOperation =
      validAddr !== null
        ? `User ${safeUser.name} has valid address in ${validAddr.city}`
        : "User has invalid address";
  }

  // Resource management patterns with scope functions
  const validProducts = takeIfFn(products, (it) => it.length > 0);
  const resourceManagement =
    validProducts !== null
      ? validProducts.map((p) => {
          const available = takeIfFn(p, (it) => it.inStock);
          return available !== null
            ? `Processing available product: ${available.name} (${available.price})`
            : `Product ${p.name} is out of stock`;
        })
      : [];

  // Consume every result so the static tier cannot dead-code eliminate it.
  console.log("scope-functions benchmark completed:");
  console.log(`- user: ${processedData}, valid: ${validationResult}, summary keys: ${userSummary.size}`);
  console.log(`- configuredUser: ${configuredUser.name}, updatedUser: ${updatedUser !== null}`);
  console.log(
    `- product analysis keys: ${productAnalysis.size}, updated: ${updatedProduct !== null}, sale tags: ${saleProduct.tags.length}, batch: ${processedProducts.length}`,
  );
  console.log(
    `- cart summary keys: ${cartSummary.size}, discounted: ${discountedCart !== null}, order: ${order !== null}`,
  );
  console.log(
    `- statement: ${accountStatement !== null ? accountStatement.size : 0}, transfer ok: ${transfer.first !== null}`,
  );
  console.log(
    `- api success: ${processedSuccess}, error data: ${processedError}, errorMessage: ${errorMessage}, retried: ${retried !== null}`,
  );
  console.log(
    `- db: ${dbConfig.host}, config valid: ${configValidation.get("isValid") === true}, updated settings: ${updatedConfig.settings.size}`,
  );
  console.log(
    `- chains: users ${complexUserProcessing.length}, products ${productProcessingChain.length}, orders ${orderProcessingChain.length}, banking ${bankingOperations.length}, api ${apiResponseChain.length}, config ${configChain.length}`,
  );
  console.log(`- nested: ${nestedResult}, safe: ${safeOperation}, resources: ${resourceManagement.length}`);
}
