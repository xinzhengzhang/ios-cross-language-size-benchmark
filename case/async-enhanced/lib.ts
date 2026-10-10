/*
 * iOS Size Benchmark - Test Case Implementation
 * Generated with Claude AI (https://claude.ai)
 *
 * This scriptc (TypeScript-to-native) implementation mirrors the Kotlin/
 * Swift/Objective-C versions for binary size comparison. It is a faithful
 * async/await port of the Kotlin coroutine implementation: suspend funcs
 * become `async`, `withContext(Dispatchers.X) { delay(n); ... }` becomes
 * `await delay(n); ...`, `coroutineScope { ...async{}... }.awaitAll()`
 * becomes `Promise.all([...])`, and the coroutine `Semaphore` is modelled
 * as an async permit gate. Sealed classes become abstract-base hierarchies.
 * A single exported entry (runBenchmark) exercises every type.
 */

function delay(ms: number): Promise<void> {
  return new Promise<void>((resolve) => {
    setTimeout(resolve, ms);
  });
}

function randomId(): number {
  return 1 + Math.floor(Math.random() * 10000);
}

// Coroutine-style counting semaphore (suspending acquire).
class Semaphore {
  private permits: number;
  private waiters: Array<() => void> = [];

  constructor(permits: number) {
    this.permits = permits;
  }

  acquire(): Promise<void> {
    if (this.permits > 0) {
      this.permits -= 1;
      return Promise.resolve();
    }
    return new Promise<void>((resolve) => {
      this.waiters.push(resolve);
    });
  }

  release(): void {
    const next = this.waiters.shift();
    if (next !== undefined) {
      next();
    } else {
      this.permits += 1;
    }
  }
}

// Data classes
class User {
  constructor(
    public readonly id: number,
    public readonly name: string,
    public readonly email: string,
    public readonly age: number,
  ) {}

  copy(name: string): User {
    return new User(this.id, name, this.email, this.age);
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
}

class OrderRequest {
  constructor(
    public readonly userId: number,
    public readonly productIds: number[],
  ) {}
}

class ProductMetrics {
  constructor(
    public readonly totalCount: number,
    public readonly averagePrice: number,
    public readonly categoryCount: number,
    public readonly priceRangeDistribution: Map<string, number>,
  ) {}
}

// sealed class WorkflowResult
abstract class WorkflowResult {}

class WorkflowResultSuccess extends WorkflowResult {
  constructor(
    public readonly createdUser: User,
    public readonly updatedUser: User,
    public readonly retrievedUser: User | null,
    public readonly allUsersCount: number,
    public readonly searchResultsCount: number,
    public readonly deleteSuccess: boolean,
  ) {
    super();
  }
}

class WorkflowResultError extends WorkflowResult {
  constructor(public readonly message: string) {
    super();
  }
}

// sealed class OrderPipelineResult
abstract class OrderPipelineResult {}

class OrderPipelineResultSuccess extends OrderPipelineResult {
  constructor(public readonly order: Order) {
    super();
  }
}

class OrderPipelineResultError extends OrderPipelineResult {
  constructor(public readonly message: string) {
    super();
  }
}

// sealed class OrderResult
abstract class OrderResult {}

class OrderResultSuccess extends OrderResult {
  constructor(public readonly order: Order) {
    super();
  }
}

class OrderResultFailed extends OrderResult {
  constructor(
    public readonly userId: number,
    public readonly message: string,
  ) {
    super();
  }
}

// Triple<String, String, Int> for batch user creation.
type UserTriple = [string, string, number];

class AsyncUserService {
  async createUser(name: string, email: string, age: number): Promise<User> {
    await delay(10);
    return new User(this.generateId(), name, email, age);
  }

  async updateUser(user: User): Promise<User> {
    await delay(5);
    return user.copy(`${user.name}_updated`);
  }

  async deleteUser(userId: number): Promise<boolean> {
    await delay(5);
    return true;
  }

  async getUserById(userId: number): Promise<User | null> {
    await delay(10);
    return new User(userId, `User${userId}`, `user${userId}@email.com`, 25);
  }

  async getAllUsers(): Promise<User[]> {
    await delay(50);
    const users: User[] = [];
    for (let i = 1; i <= 100; i++) {
      users.push(new User(i, `User${i}`, `user${i}@email.com`, 20 + (i % 50)));
    }
    return users;
  }

  async searchUsers(query: string): Promise<User[]> {
    const users = await this.getAllUsers();
    await delay(20);
    const q = query.toLowerCase();
    return users.filter((u) => u.name.toLowerCase().includes(q));
  }

  async batchCreateUsers(users: UserTriple[]): Promise<User[]> {
    return Promise.all(users.map((t) => this.createUser(t[0], t[1], t[2])));
  }

  async processUserWorkflow(userIndex: number): Promise<WorkflowResult> {
    try {
      // Parallel async operations
      const createDeferred = this.createUser(`User${userIndex}`, `user${userIndex}@email.com`, 25 + (userIndex % 50));
      const allUsersDeferred = this.getAllUsers();
      const searchDeferred = this.searchUsers("User");

      const createdUser = await createDeferred;
      const allUsers = await allUsersDeferred;
      const searchResults = await searchDeferred;

      // Serial dependent operations
      const updatedUser = await this.updateUser(createdUser);
      const retrievedUser = await this.getUserById(updatedUser.id);
      const deleteResult = await this.deleteUser(updatedUser.id);

      return new WorkflowResultSuccess(
        createdUser,
        updatedUser,
        retrievedUser,
        allUsers.length,
        searchResults.length,
        deleteResult,
      );
    } catch (e) {
      return new WorkflowResultError(e instanceof Error ? e.message : "Unknown error");
    }
  }

  generateId(): number {
    return randomId();
  }
}

class AsyncProductService {
  async createProduct(name: string, price: number, category: string): Promise<Product> {
    await delay(15);
    return new Product(this.generateId(), name, price, category);
  }

  async updateProduct(product: Product): Promise<Product> {
    await delay(8);
    return product.copyPrice(product.price * 1.1);
  }

  async getAllProducts(): Promise<Product[]> {
    await delay(60);
    const products: Product[] = [];
    for (let i = 1; i <= 500; i++) {
      products.push(new Product(i, `Product${i}`, 50.0 + (i % 200), `Category${i % 10}`));
    }
    return products;
  }

  async getProductsByCategory(category: string): Promise<Product[]> {
    const products = await this.getAllProducts();
    await delay(30);
    return products.filter((p) => p.category === category);
  }

  async batchProcessProducts(productIds: number[]): Promise<Map<number, Product | null>> {
    const result = new Map<number, Product | null>();
    const resolved = await Promise.all(productIds.map((id) => this.getProductById(id)));
    for (let i = 0; i < productIds.length; i++) {
      result.set(productIds[i], resolved[i]);
    }
    return result;
  }

  async getProductById(productId: number): Promise<Product | null> {
    await delay(12);
    return new Product(productId, `Product${productId}`, 99.99, "Electronics");
  }

  async calculateProductMetrics(products: Product[]): Promise<ProductMetrics> {
    // CPU-intensive computation
    const sum = products.reduce((acc, p) => acc + p.price, 0);
    const averagePrice = products.length > 0 ? sum / products.length : 0;

    const categoryGroups = new Map<string, Product[]>();
    for (const p of products) {
      const bucket = categoryGroups.get(p.category);
      if (bucket !== undefined) {
        bucket.push(p);
      } else {
        categoryGroups.set(p.category, [p]);
      }
    }

    const priceRanges = new Map<string, Product[]>();
    for (const p of products) {
      let key: string;
      if (p.price < 50) {
        key = "Low";
      } else if (p.price < 100) {
        key = "Medium";
      } else {
        key = "High";
      }
      const bucket = priceRanges.get(key);
      if (bucket !== undefined) {
        bucket.push(p);
      } else {
        priceRanges.set(key, [p]);
      }
    }

    const priceRangeDistribution = new Map<string, number>();
    for (const [key, value] of priceRanges) {
      priceRangeDistribution.set(key, value.length);
    }

    return new ProductMetrics(products.length, averagePrice, categoryGroups.size, priceRangeDistribution);
  }

  generateId(): number {
    return randomId();
  }
}

class AsyncOrderService {
  async createOrder(userId: number, products: Product[]): Promise<Order> {
    await delay(25);
    const total = products.reduce((acc, p) => acc + p.price, 0);
    return new Order(this.generateId(), userId, products, total);
  }

  async processOrderPipeline(userId: number, productIds: number[]): Promise<OrderPipelineResult> {
    try {
      // Stage 1: fetch product info in parallel
      const productService = new AsyncProductService();
      const fetched = await Promise.all(productIds.map((id) => productService.getProductById(id)));
      const products: Product[] = [];
      for (const p of fetched) {
        if (p !== null) {
          products.push(p);
        }
      }

      if (products.length !== productIds.length) {
        return new OrderPipelineResultError("Some products not found");
      }

      // Stage 2: validate inventory (parallel)
      const inventoryResults = await Promise.all(products.map((product) => this.checkInventory(product.id)));

      if (inventoryResults.some((ok) => !ok)) {
        return new OrderPipelineResultError("Insufficient inventory");
      }

      // Stage 3: create order and process payment (serial)
      const order = await this.createOrder(userId, products);
      const paymentResult = await this.processPayment(order.total);

      if (!paymentResult) {
        return new OrderPipelineResultError("Payment failed");
      }

      // Stage 4: follow-up operations in parallel
      const inventoryUpdateDeferred = this.updateInventory(products);
      const notificationDeferred = this.sendNotification(userId, order.id);
      const analyticsDeferred = this.recordAnalytics(order);

      await inventoryUpdateDeferred;
      await notificationDeferred;
      await analyticsDeferred;

      return new OrderPipelineResultSuccess(order);
    } catch (e) {
      return new OrderPipelineResultError(e instanceof Error ? e.message : "Pipeline failed");
    }
  }

  async batchProcessOrders(orderRequests: OrderRequest[]): Promise<OrderResult[]> {
    // Concurrency limit to avoid resource exhaustion
    const semaphore = new Semaphore(10);

    return Promise.all(
      orderRequests.map(async (request): Promise<OrderResult> => {
        await semaphore.acquire();
        try {
          const result = await this.processOrderPipeline(request.userId, request.productIds);
          if (result instanceof OrderPipelineResultSuccess) {
            return new OrderResultSuccess(result.order);
          }
          if (result instanceof OrderPipelineResultError) {
            return new OrderResultFailed(request.userId, result.message);
          }
          return new OrderResultFailed(request.userId, "Unknown error");
        } catch (e) {
          return new OrderResultFailed(request.userId, e instanceof Error ? e.message : "Unknown error");
        } finally {
          semaphore.release();
        }
      }),
    );
  }

  async checkInventory(productId: number): Promise<boolean> {
    await delay(10);
    return productId % 10 !== 0; // simulated inventory check
  }

  async processPayment(amount: number): Promise<boolean> {
    await delay(100); // payment processing is slow
    return amount > 0;
  }

  async updateInventory(products: Product[]): Promise<boolean> {
    await delay(20);
    return true;
  }

  async sendNotification(userId: number, orderId: number): Promise<boolean> {
    await delay(15);
    return true;
  }

  async recordAnalytics(order: Order): Promise<boolean> {
    await delay(5);
    return true;
  }

  generateId(): number {
    return randomId();
  }
}

class AsyncBenchmarkService {
  userService = new AsyncUserService();
  productService = new AsyncProductService();
  orderService = new AsyncOrderService();

  async runComplexAsyncWorkflow(iterations: number): Promise<void> {
    console.log(`Starting complex async workflow with ${iterations} iterations...`);

    // Stage 1: parallel user workflows
    const userWorkflows: Promise<WorkflowResult>[] = [];
    for (let index = 1; index <= iterations; index++) {
      userWorkflows.push(this.userService.processUserWorkflow(index));
    }

    // Stage 2: product batch processing
    const productIds: number[] = [];
    for (let i = 1; i <= 100; i++) {
      productIds.push(i);
    }
    const productBatchDeferred = this.productService.batchProcessProducts(productIds);

    // Stage 3: wait for user workflows
    const userResults = await Promise.all(userWorkflows);
    const successfulUsers: WorkflowResultSuccess[] = [];
    for (const r of userResults) {
      if (r instanceof WorkflowResultSuccess) {
        successfulUsers.push(r);
      }
    }

    console.log(`User workflows completed: ${successfulUsers.length}/${userResults.length} successful`);

    // Stage 4: product metrics computation
    const batchResult = await productBatchDeferred;
    const products: Product[] = [];
    for (const value of batchResult.values()) {
      if (value !== null) {
        products.push(value);
      }
    }
    const metricsDeferred = this.productService.calculateProductMetrics(products);

    // Stage 5: batch order processing
    const orderRequests: OrderRequest[] = [];
    const takenUsers = successfulUsers.slice(0, 20);
    for (let index = 0; index < takenUsers.length; index++) {
      orderRequests.push(new OrderRequest(takenUsers[index].createdUser.id, productIds.slice(0, 3 + (index % 5))));
    }

    const orderResultsDeferred = this.orderService.batchProcessOrders(orderRequests);

    // Wait for all operations
    const metrics = await metricsDeferred;
    const orderResults = await orderResultsDeferred;

    const successfulOrders: OrderResultSuccess[] = [];
    for (const r of orderResults) {
      if (r instanceof OrderResultSuccess) {
        successfulOrders.push(r);
      }
    }

    const totalRevenue = successfulOrders.reduce((acc, r) => acc + r.order.total, 0);

    console.log("Async workflow completed:");
    console.log(`- User workflows: ${successfulUsers.length}`);
    console.log(`- Products processed: ${products.length}`);
    console.log(`- Average product price: ${metrics.averagePrice}`);
    console.log(`- Orders processed: ${successfulOrders.length}/${orderResults.length}`);
    console.log(`- Total revenue: ${totalRevenue}`);
  }

  async runConcurrentStressTest(concurrencyLevel: number, operations: number): Promise<void> {
    console.log(`Starting concurrent stress test: ${concurrencyLevel} concurrent workers, ${operations} operations each`);

    const workerPromises: Promise<string>[] = [];
    for (let workerId = 1; workerId <= concurrencyLevel; workerId++) {
      workerPromises.push(this.runStressWorker(workerId, operations));
    }

    const results = await Promise.all(workerPromises);
    for (const r of results) {
      console.log(r);
    }

    let totalSuccess = 0;
    let totalErrors = 0;
    for (const result of results) {
      const successPart = result.substring(result.indexOf(": ") + 2);
      totalSuccess += parseInt(successPart.substring(0, successPart.indexOf(" successes")), 10);
      const afterSuccesses = result.substring(result.indexOf("successes, ") + "successes, ".length);
      totalErrors += parseInt(afterSuccesses.substring(0, afterSuccesses.indexOf(" errors")), 10);
    }

    console.log(`Stress test completed: ${totalSuccess} successes, ${totalErrors} errors`);
  }

  async runStressWorker(workerId: number, operations: number): Promise<string> {
    let successCount = 0;
    let errorCount = 0;

    for (let opIndex = 0; opIndex < operations; opIndex++) {
      try {
        switch (opIndex % 4) {
          case 0: {
            const user = await this.userService.createUser(`Worker${workerId}_User${opIndex}`, `email${opIndex}@test.com`, 25);
            await this.userService.updateUser(user);
            successCount++;
            break;
          }
          case 1: {
            const product = await this.productService.createProduct(`Product${opIndex}`, 99.99, `Category${opIndex % 5}`);
            await this.productService.updateProduct(product);
            successCount++;
            break;
          }
          case 2: {
            await this.productService.getProductsByCategory(`Category${opIndex % 5}`);
            successCount++;
            break;
          }
          case 3: {
            await this.userService.searchUsers("User");
            successCount++;
            break;
          }
          default:
            break;
        }
      } catch (e) {
        errorCount++;
      }
    }

    return `Worker ${workerId}: ${successCount} successes, ${errorCount} errors`;
  }
}

class IosSizeBenchmark {
  benchmarkService = new AsyncBenchmarkService();

  async runWorkflows(): Promise<void> {
    // Run complex async workflow
    await this.benchmarkService.runComplexAsyncWorkflow(50);

    // Run concurrent stress test
    await this.benchmarkService.runConcurrentStressTest(10, 20);
  }
}

export function runBenchmark(): void {
  const benchmark = new IosSizeBenchmark();
  benchmark.runWorkflows().then(() => {
    console.log("Async-enhanced benchmark completed");
  });
}
