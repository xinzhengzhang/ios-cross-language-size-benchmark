/*
 * iOS Size Benchmark - Test Case Implementation
 * Generated with Claude AI (https://claude.ai)
 * 
 * This Kotlin Native implementation demonstrates language-specific
 * features and patterns for binary size comparison.
 */

package kntr.examples.ios.size.benchmark

import kotlinx.coroutines.*
import kotlinx.coroutines.sync.Semaphore
import kotlin.coroutines.CoroutineContext

// 使用协程的真正异步实现
class AsyncUserService : CoroutineScope {
    override val coroutineContext: CoroutineContext = Dispatchers.Default + SupervisorJob()
    
    suspend fun createUser(name: String, email: String, age: Int): User = withContext(Dispatchers.IO) {
        delay(10) // 模拟网络延迟
        User(generateId(), name, email, age)
    }
    
    suspend fun updateUser(user: User): User = withContext(Dispatchers.IO) {
        delay(5)
        user.copy(name = "${user.name}_updated")
    }
    
    suspend fun deleteUser(userId: Int): Boolean = withContext(Dispatchers.IO) {
        delay(5)
        true
    }
    
    suspend fun getUserById(userId: Int): User? = withContext(Dispatchers.IO) {
        delay(10)
        User(userId, "User$userId", "user$userId@email.com", 25)
    }
    
    suspend fun getAllUsers(): List<User> = withContext(Dispatchers.IO) {
        delay(50)
        (1..100).map { User(it, "User$it", "user$it@email.com", 20 + it % 50) }
    }
    
    suspend fun searchUsers(query: String): List<User> = withContext(Dispatchers.IO) {
        val users = getAllUsers()
        delay(20)
        users.filter { it.name.contains(query, ignoreCase = true) }
    }
    
    suspend fun batchCreateUsers(users: List<Triple<String, String, Int>>): List<User> = coroutineScope {
        users.map { (name, email, age) ->
            async { createUser(name, email, age) }
        }.awaitAll()
    }
    
    suspend fun processUserWorkflow(userIndex: Int): WorkflowResult = coroutineScope {
        try {
            // 并行执行多个异步操作
            val createDeferred = async { createUser("User$userIndex", "user$userIndex@email.com", 25 + userIndex % 50) }
            val allUsersDeferred = async { getAllUsers() }
            val searchDeferred = async { searchUsers("User") }
            
            val createdUser = createDeferred.await()
            val allUsers = allUsersDeferred.await()
            val searchResults = searchDeferred.await()
            
            // 串行执行依赖操作
            val updatedUser = updateUser(createdUser)
            val retrievedUser = getUserById(updatedUser.id)
            val deleteResult = deleteUser(updatedUser.id)
            
            WorkflowResult.Success(
                createdUser = createdUser,
                updatedUser = updatedUser,
                retrievedUser = retrievedUser,
                allUsersCount = allUsers.size,
                searchResultsCount = searchResults.size,
                deleteSuccess = deleteResult
            )
        } catch (e: Exception) {
            WorkflowResult.Error(e.message ?: "Unknown error")
        }
    }
    
    fun generateId(): Int = (1..10000).random()
}

class AsyncProductService : CoroutineScope {
    override val coroutineContext: CoroutineContext = Dispatchers.Default + SupervisorJob()
    
    suspend fun createProduct(name: String, price: Double, category: String): Product = withContext(Dispatchers.IO) {
        delay(15)
        Product(generateId(), name, price, category)
    }
    
    suspend fun updateProduct(product: Product): Product = withContext(Dispatchers.IO) {
        delay(8)
        product.copy(price = product.price * 1.1)
    }
    
    suspend fun getAllProducts(): List<Product> = withContext(Dispatchers.IO) {
        delay(60)
        (1..500).map { Product(it, "Product$it", 50.0 + it % 200, "Category${it % 10}") }
    }
    
    suspend fun getProductsByCategory(category: String): List<Product> = withContext(Dispatchers.IO) {
        val products = getAllProducts()
        delay(30)
        products.filter { it.category == category }
    }
    
    suspend fun batchProcessProducts(productIds: List<Int>): Map<Int, Product?> = coroutineScope {
        productIds.associateWith { id ->
            async { getProductById(id) }
        }.mapValues { (_, deferred) -> deferred.await() }
    }
    
    suspend fun getProductById(productId: Int): Product? = withContext(Dispatchers.IO) {
        delay(12)
        Product(productId, "Product$productId", 99.99, "Electronics")
    }
    
    suspend fun calculateProductMetrics(products: List<Product>): ProductMetrics = withContext(Dispatchers.Default) {
        // CPU密集型计算
        val averagePrice = products.map { it.price }.average()
        val categoryGroups = products.groupBy { it.category }
        val priceRanges = products.groupBy { 
            when {
                it.price < 50 -> "Low"
                it.price < 100 -> "Medium"
                else -> "High"
            }
        }
        
        ProductMetrics(
            totalCount = products.size,
            averagePrice = averagePrice,
            categoryCount = categoryGroups.size,
            priceRangeDistribution = priceRanges.mapValues { it.value.size }
        )
    }
    
    fun generateId(): Int = (1..10000).random()
}

class AsyncOrderService : CoroutineScope {
    override val coroutineContext: CoroutineContext = Dispatchers.Default + SupervisorJob()
    
    suspend fun createOrder(userId: Int, products: List<Product>): Order = withContext(Dispatchers.IO) {
        delay(25)
        val total = products.sumOf { it.price }
        Order(generateId(), userId, products, total)
    }
    
    suspend fun processOrderPipeline(userId: Int, productIds: List<Int>): OrderPipelineResult = coroutineScope {
        try {
            // 第一阶段：并行获取产品信息
            val productService = AsyncProductService()
            val products = productIds.map { id ->
                async { productService.getProductById(id) }
            }.awaitAll().filterNotNull()
            
            if (products.size != productIds.size) {
                return@coroutineScope OrderPipelineResult.Error("Some products not found")
            }
            
            // 第二阶段：验证库存（并行）
            val inventoryChecks = products.map { product ->
                async { checkInventory(product.id) }
            }
            val inventoryResults = inventoryChecks.awaitAll()
            
            if (inventoryResults.any { !it }) {
                return@coroutineScope OrderPipelineResult.Error("Insufficient inventory")
            }
            
            // 第三阶段：创建订单和处理支付（串行）
            val order = createOrder(userId, products)
            val paymentResult = processPayment(order.total)
            
            if (!paymentResult) {
                return@coroutineScope OrderPipelineResult.Error("Payment failed")
            }
            
            // 第四阶段：并行执行后续操作
            val inventoryUpdateDeferred = async { updateInventory(products) }
            val notificationDeferred = async { sendNotification(userId, order.id) }
            val analyticsDeferred = async { recordAnalytics(order) }
            
            inventoryUpdateDeferred.await()
            notificationDeferred.await()
            analyticsDeferred.await()
            
            OrderPipelineResult.Success(order)
        } catch (e: Exception) {
            OrderPipelineResult.Error(e.message ?: "Pipeline failed")
        }
    }
    
    suspend fun batchProcessOrders(orderRequests: List<OrderRequest>): List<OrderResult> = coroutineScope {
        // 使用并发限制避免资源耗尽
        val semaphore = Semaphore(10)
        
        orderRequests.map { request ->
            async<OrderResult> {
                semaphore.acquire()
                try {
                    val result = processOrderPipeline(request.userId, request.productIds)
                    when (result) {
                        is OrderPipelineResult.Success -> OrderResult.Success(result.order)
                        is OrderPipelineResult.Error -> OrderResult.Failed(request.userId, result.message)
                    }
                } catch (e: Exception) {
                    OrderResult.Failed(request.userId, e.message ?: "Unknown error")
                } finally {
                    semaphore.release()
                }
            }
        }.awaitAll()
    }
    
    suspend fun checkInventory(productId: Int): Boolean = withContext(Dispatchers.IO) {
        delay(10)
        productId % 10 != 0 // 模拟库存检查
    }
    
    suspend fun processPayment(amount: Double): Boolean = withContext(Dispatchers.IO) {
        delay(100) // 支付处理较慢
        amount > 0
    }
    
    suspend fun updateInventory(products: List<Product>): Boolean = withContext(Dispatchers.IO) {
        delay(20)
        true
    }
    
    suspend fun sendNotification(userId: Int, orderId: Int): Boolean = withContext(Dispatchers.IO) {
        delay(15)
        true
    }
    
    suspend fun recordAnalytics(order: Order): Boolean = withContext(Dispatchers.IO) {
        delay(5)
        true
    }
    
    fun generateId(): Int = (1..10000).random()
}

// 数据类
data class User(val id: Int, val name: String, val email: String, val age: Int)
data class Product(val id: Int, val name: String, val price: Double, val category: String)
data class Order(val id: Int, val userId: Int, val products: List<Product>, val total: Double)

data class OrderRequest(val userId: Int, val productIds: List<Int>)

data class ProductMetrics(
    val totalCount: Int,
    val averagePrice: Double,
    val categoryCount: Int,
    val priceRangeDistribution: Map<String, Int>
)

sealed class WorkflowResult {
    data class Success(
        val createdUser: User,
        val updatedUser: User,
        val retrievedUser: User?,
        val allUsersCount: Int,
        val searchResultsCount: Int,
        val deleteSuccess: Boolean
    ) : WorkflowResult()
    
    data class Error(val message: String) : WorkflowResult()
}

sealed class OrderPipelineResult {
    data class Success(val order: Order) : OrderPipelineResult()
    data class Error(val message: String) : OrderPipelineResult()
}

sealed class OrderResult {
    data class Success(val order: Order) : OrderResult()
    data class Failed(val userId: Int, val message: String) : OrderResult()
}

class AsyncBenchmarkService : CoroutineScope {
    override val coroutineContext: CoroutineContext = Dispatchers.Default + SupervisorJob()
    
    val userService = AsyncUserService()
    val productService = AsyncProductService()
    val orderService = AsyncOrderService()
    
    suspend fun runComplexAsyncWorkflow(iterations: Int) = coroutineScope {
        println("Starting complex async workflow with $iterations iterations...")
        
        // 第一阶段：并行用户工作流
        val userWorkflows = (1..iterations).map { index ->
            async { userService.processUserWorkflow(index) }
        }
        
        // 第二阶段：产品批处理
        val productIds = (1..100).toList()
        val productBatchDeferred = async { 
            productService.batchProcessProducts(productIds) 
        }
        
        // 第三阶段：等待用户工作流完成
        val userResults = userWorkflows.awaitAll()
        val successfulUsers = userResults.filterIsInstance<WorkflowResult.Success>()
        
        println("User workflows completed: ${successfulUsers.size}/${userResults.size} successful")
        
        // 第四阶段：产品指标计算
        val products = productBatchDeferred.await().values.filterNotNull()
        val metricsDeferred = async { productService.calculateProductMetrics(products) }
        
        // 第五阶段：批量订单处理
        val orderRequests = successfulUsers.take(20).mapIndexed { index, userResult ->
            OrderRequest(
                userId = userResult.createdUser.id,
                productIds = productIds.take(3 + index % 5)
            )
        }
        
        val orderResultsDeferred = async { orderService.batchProcessOrders(orderRequests) }
        
        // 等待所有操作完成
        val metrics = metricsDeferred.await()
        val orderResults = orderResultsDeferred.await()
        
        val successfulOrders = orderResults.filterIsInstance<OrderResult.Success>()
        
        println("Async workflow completed:")
        println("- User workflows: ${successfulUsers.size}")
        println("- Products processed: ${products.size}")
        println("- Average product price: ${metrics.averagePrice}")
        println("- Orders processed: ${successfulOrders.size}/${orderResults.size}")
        println("- Total revenue: ${successfulOrders.sumOf { it.order.total }}")
    }
    
    suspend fun runConcurrentStressTest(concurrencyLevel: Int, operations: Int) = coroutineScope {
        println("Starting concurrent stress test: $concurrencyLevel concurrent workers, $operations operations each")
        
        val workers = (1..concurrencyLevel).map { workerId ->
            async {
                var successCount = 0
                var errorCount = 0
                
                repeat(operations) { opIndex ->
                    try {
                        when (opIndex % 4) {
                            0 -> {
                                val user = userService.createUser("Worker${workerId}_User$opIndex", "email$opIndex@test.com", 25)
                                userService.updateUser(user)
                                successCount++
                            }
                            1 -> {
                                val product = productService.createProduct("Product$opIndex", 99.99, "Category${opIndex % 5}")
                                productService.updateProduct(product)
                                successCount++
                            }
                            2 -> {
                                productService.getProductsByCategory("Category${opIndex % 5}")
                                successCount++
                            }
                            3 -> {
                                userService.searchUsers("User")
                                successCount++
                            }
                        }
                    } catch (e: Exception) {
                        errorCount++
                    }
                }
                
                "Worker $workerId: $successCount successes, $errorCount errors"
            }
        }
        
        val results = workers.awaitAll()
        results.forEach { println(it) }
        
        val totalSuccess = results.sumOf { result ->
            result.substringAfter(": ").substringBefore(" successes").toInt()
        }
        val totalErrors = results.sumOf { result ->
            result.substringAfter("successes, ").substringBefore(" errors").toInt()
        }
        
        println("Stress test completed: $totalSuccess successes, $totalErrors errors")
    }
}

class IosSizeBenchmark {
    val benchmarkService = AsyncBenchmarkService()
    
    fun runBenchmark() {
        runBlocking {
            // 运行复杂异步工作流
            benchmarkService.runComplexAsyncWorkflow(50)
            
            // 运行并发压力测试
            benchmarkService.runConcurrentStressTest(10, 20)
        }
    }
}