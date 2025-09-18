/*
 * iOS Size Benchmark - Test Case Implementation
 * Generated with Claude AI (https://claude.ai)
 * 
 * This Kotlin Native implementation demonstrates language-specific
 * features and patterns for binary size comparison.
 */

package kntr.examples.ios.size.benchmark

// Test case: Scope Functions - Tests Kotlin's scope functions vs traditional patterns

// Data models for testing scope functions
data class User(
    var id: String,
    var name: String,
    var email: String,
    var age: Int,
    var address: Address? = null,
    var preferences: UserPreferences? = null
)

data class Address(
    var street: String,
    var city: String,
    var state: String,
    var zipCode: String,
    var country: String
)

data class UserPreferences(
    var theme: String,
    var language: String,
    var notifications: Boolean,
    var newsletter: Boolean
)

data class Product(
    var id: String,
    var name: String,
    var price: Double,
    var category: String,
    var description: String,
    var inStock: Boolean,
    var tags: MutableList<String> = mutableListOf()
)

data class ShoppingCart(
    var id: String,
    var userId: String,
    var items: MutableList<CartItem> = mutableListOf(),
    var discountCode: String? = null,
    var discountAmount: Double = 0.0
)

data class CartItem(
    var productId: String,
    var quantity: Int,
    var price: Double
)

data class Order(
    var id: String,
    var cart: ShoppingCart,
    var shippingAddress: Address,
    var paymentMethod: String,
    var status: String,
    var timestamp: Long
)

data class BankAccount(
    var accountNumber: String,
    var balance: Double,
    var accountType: String,
    var isActive: Boolean
)

data class ApiResponse<T>(
    var data: T? = null,
    var errorMessage: String? = null,
    var statusCode: Int = 0,
    var headers: MutableMap<String, String> = mutableMapOf()
)

// Configuration classes
data class DatabaseConfig(
    var host: String,
    var port: Int,
    var database: String,
    var username: String,
    var password: String,
    var connectionPool: ConnectionPoolConfig? = null
)

data class ConnectionPoolConfig(
    var minConnections: Int,
    var maxConnections: Int,
    var timeout: Long
)

data class AppConfig(
    var appName: String,
    var version: String,
    var environment: String,
    var database: DatabaseConfig,
    var features: MutableMap<String, Boolean> = mutableMapOf(),
    var settings: MutableMap<String, String> = mutableMapOf()
)

// Service classes demonstrating scope function usage
class UserService {
    
    fun createUser(name: String, email: String, age: Int): User {
        // Using 'apply' for object initialization and configuration
        return User("", "", "", 0).apply {
            this.id = generateUserId()
            this.name = name
            this.email = email
            this.age = age
            this.address = Address("", "", "", "", "").apply {
                // Nested apply for address initialization
                this.street = ""
                this.city = ""
                this.state = ""
                this.zipCode = ""
                this.country = "USA"
            }
            this.preferences = UserPreferences("", "", false, false).apply {
                this.theme = "light"
                this.language = "en"
                this.notifications = true
                this.newsletter = false
            }
        }
    }
    
    fun updateUserWithValidation(user: User, newEmail: String?, newAge: Int?): User? {
        // Using 'let' for null-safe operations and transformations
        return user.let { validUser ->
            var updated = false
            
            newEmail?.let { email ->
                if (email.contains("@")) {
                    validUser.email = email
                    updated = true
                }
            }
            
            newAge?.let { age ->
                if (age > 0 && age < 120) {
                    validUser.age = age
                    updated = true
                }
            }
            
            if (updated) validUser else null
        }
    }
    
    fun processUserData(user: User?): String {
        // Using 'let' with null safety
        return user?.let { validUser ->
            "Processing user: ${validUser.name} (${validUser.email})"
        } ?: "No user to process"
    }
    
    fun configureUserPreferences(user: User): User {
        // Using 'also' for side effects while returning the original object
        return user.also { userData ->
            userData.preferences?.also { prefs ->
                prefs.theme = "dark"
                prefs.notifications = true
                logPreferenceChange(userData.id, "theme", "dark")
                logPreferenceChange(userData.id, "notifications", "enabled")
            }
        }
    }
    
    fun validateAndFormatUser(user: User): String {
        // Using 'run' for complex operations on the object
        return user.run {
            val isValidEmail = email.contains("@")
            val isValidAge = age in 1..120
            val hasAddress = address != null
            
            when {
                !isValidEmail -> "Invalid email: $email"
                !isValidAge -> "Invalid age: $age"
                !hasAddress -> "Missing address information"
                else -> "Valid user: $name ($email, age $age)"
            }
        }
    }
    
    fun getUserSummary(user: User?): Map<String, Any> {
        // Using 'let' with complex transformations
        return user?.let { validUser ->
            mapOf(
                "id" to validUser.id,
                "name" to validUser.name,
                "email" to validUser.email,
                "age" to validUser.age,
                "hasAddress" to (validUser.address != null),
                "hasPreferences" to (validUser.preferences != null),
                "addressSummary" to (validUser.address?.let { addr ->
                    "${addr.city}, ${addr.state}, ${addr.country}"
                } ?: "No address"),
                "preferencesSummary" to (validUser.preferences?.let { prefs ->
                    "Theme: ${prefs.theme}, Language: ${prefs.language}"
                } ?: "No preferences")
            )
        } ?: emptyMap()
    }
    
    fun generateUserId(): String = "USER_12345"
    fun logPreferenceChange(userId: String, key: String, value: String) {
        // Logging implementation
    }
}

class ProductService {
    
    fun createProduct(name: String, price: Double, category: String): Product {
        // Using 'apply' for fluent object initialization
        return Product("", "", 0.0, "", "", false).apply {
            id = generateProductId()
            this.name = name
            this.price = price
            this.category = category
            description = "Default description for $name"
            inStock = true
            tags.apply {
                add("new")
                add(category.lowercase())
                if (price > 100) add("premium")
            }
        }
    }
    
    fun updateProductPrice(product: Product, newPrice: Double): Product? {
        // Using 'takeIf' with 'apply' for conditional updates
        return product.takeIf { newPrice > 0 }?.apply {
            val oldPrice = price
            price = newPrice
            
            // Update tags based on new price
            tags.apply {
                remove("budget")
                remove("premium")
                remove("luxury")
                
                when {
                    newPrice < 50 -> add("budget")
                    newPrice > 500 -> add("luxury")
                    newPrice > 100 -> add("premium")
                }
            }
            
            logPriceChange(id, oldPrice, newPrice)
        }
    }
    
    fun processProductBatch(products: List<Product>): List<String> {
        // Using scope functions in collection operations
        return products.mapNotNull { product ->
            product.takeIf { it.inStock }?.let { availableProduct ->
                "Processing: ${availableProduct.name} - $${availableProduct.price}"
            }
        }
    }
    
    fun configureProductForSale(product: Product, discountPercent: Double): Product {
        // Using 'also' for side effects during configuration
        return product.also { prod ->
            prod.apply {
                price *= (1 - discountPercent / 100)
                tags.add("sale")
                tags.add("discounted")
            }.also {
                logSaleConfiguration(prod.id, discountPercent)
                notifyPriceChange(prod.id, prod.price)
            }
        }
    }
    
    fun analyzeProduct(product: Product): Map<String, Any> {
        // Using 'run' for complex analysis
        return product.run {
            val priceCategory = when {
                price < 20 -> "budget"
                price < 100 -> "mid-range"
                price < 500 -> "premium"
                else -> "luxury"
            }
            
            val tagAnalysis = tags.run {
                mapOf(
                    "tagCount" to size,
                    "hasPromoTags" to any { it in listOf("sale", "new", "featured") },
                    "categoryTags" to filter { it in listOf("electronics", "clothing", "books") }
                )
            }
            
            mapOf(
                "productId" to id,
                "priceCategory" to priceCategory,
                "availability" to if (inStock) "available" else "out_of_stock",
                "tagAnalysis" to tagAnalysis,
                "summary" to "$name ($priceCategory) - ${if (inStock) "In Stock" else "Out of Stock"}"
            )
        }
    }
    
    fun generateProductId(): String = "PROD_12345"
    fun logPriceChange(productId: String, oldPrice: Double, newPrice: Double) {}
    fun logSaleConfiguration(productId: String, discount: Double) {}
    fun notifyPriceChange(productId: String, newPrice: Double) {}
}

class ShoppingCartService {
    
    fun createCart(userId: String): ShoppingCart {
        // Using 'apply' for cart initialization
        return ShoppingCart("", "").apply {
            id = generateCartId()
            this.userId = userId
            items = mutableListOf()
            discountAmount = 0.0
        }
    }
    
    fun addItemToCart(cart: ShoppingCart, productId: String, quantity: Int, price: Double): ShoppingCart {
        // Using 'also' to perform side effects while returning the original object
        return cart.also { cartData ->
            cartData.items.add(
                CartItem(productId, quantity, price).apply {
                    // Additional item configuration could go here
                }
            )
            logCartItemAdded(cartData.id, productId, quantity)
        }
    }
    
    fun applyDiscount(cart: ShoppingCart, discountCode: String): ShoppingCart? {
        // Using 'takeIf' with complex validation and 'apply'
        return cart.takeIf { validateDiscountCode(discountCode) }?.apply {
            this.discountCode = discountCode
            discountAmount = calculateDiscount(this, discountCode)
        }?.also { updatedCart ->
            logDiscountApplied(updatedCart.id, discountCode, updatedCart.discountAmount)
        }
    }
    
    fun processCartCheckout(cart: ShoppingCart, shippingAddress: Address, paymentMethod: String): Order? {
        // Using 'let' for complex transformation with validation
        return cart.takeIf { it.items.isNotEmpty() }?.let { validCart ->
            Order("", validCart, shippingAddress, paymentMethod, "", 0L).apply {
                id = generateOrderId()
                status = "pending"
                timestamp = 1640995200000L
            }.also { newOrder ->
                logOrderCreated(newOrder.id, validCart.id)
                clearCart(validCart)
            }
        }
    }
    
    fun calculateCartSummary(cart: ShoppingCart): Map<String, Any> {
        // Using 'run' for complex calculations
        return cart.run {
            val subtotal = items.sumOf { it.price * it.quantity }
            val total = subtotal - discountAmount
            val itemCount = items.sumOf { it.quantity }
            
            mapOf(
                "cartId" to id,
                "itemCount" to itemCount,
                "subtotal" to subtotal,
                "discountAmount" to discountAmount,
                "total" to total,
                "hasDiscount" to (discountCode != null),
                "discountCode" to (discountCode ?: "none"),
                "items" to items.map { item ->
                    mapOf(
                        "productId" to item.productId,
                        "quantity" to item.quantity,
                        "price" to item.price,
                        "total" to (item.price * item.quantity)
                    )
                }
            )
        }
    }
    
    fun generateCartId(): String = "CART_12345"
    fun generateOrderId(): String = "ORDER_12345"
    fun validateDiscountCode(code: String): Boolean = code.isNotEmpty()
    fun calculateDiscount(cart: ShoppingCart, code: String): Double = 10.0
    fun logCartItemAdded(cartId: String, productId: String, quantity: Int) {}
    fun logDiscountApplied(cartId: String, code: String, amount: Double) {}
    fun logOrderCreated(orderId: String, cartId: String) {}
    fun clearCart(cart: ShoppingCart) { cart.items.clear() }
}

class BankingService {
    
    fun createAccount(accountNumber: String, accountType: String): BankAccount {
        // Using 'apply' for account setup
        return BankAccount("", 0.0, "", false).apply {
            this.accountNumber = accountNumber
            balance = 0.0
            this.accountType = accountType
            isActive = true
        }.also { newAccount ->
            logAccountCreated(newAccount.accountNumber, newAccount.accountType)
        }
    }
    
    fun processTransaction(account: BankAccount, amount: Double, type: String): BankAccount? {
        // Using 'takeIf' with complex validation
        return account.takeIf { it.isActive }?.let { activeAccount ->
            when (type) {
                "deposit" -> activeAccount.apply {
                    balance += amount
                }.also { logTransaction(it.accountNumber, amount, type) }
                
                "withdrawal" -> activeAccount.takeIf { it.balance >= amount }?.apply {
                    balance -= amount
                }?.also { logTransaction(it.accountNumber, amount, type) }
                
                else -> null
            }
        }
    }
    
    fun generateAccountStatement(account: BankAccount): Map<String, Any> {
        // Using 'run' for complex statement generation
        return account.run {
            val accountStatus = when {
                !isActive -> "inactive"
                balance < 0 -> "overdrawn"
                balance < 100 -> "low_balance"
                else -> "normal"
            }
            
            mapOf(
                "accountNumber" to accountNumber,
                "accountType" to accountType,
                "balance" to balance,
                "status" to accountStatus,
                "isActive" to isActive,
                "formattedBalance" to "$$balance",
                "canWithdraw" to (isActive && balance > 0),
                "summary" to "$accountType account #$accountNumber: $balance ($accountStatus)"
            )
        }
    }
    
    fun transferFunds(fromAccount: BankAccount, toAccount: BankAccount, amount: Double): Pair<BankAccount?, BankAccount?> {
        // Using scope functions for complex transfer logic
        return fromAccount.takeIf { it.isActive && it.balance >= amount }?.let { validFromAccount ->
            toAccount.takeIf { it.isActive }?.let { validToAccount ->
                val updatedFromAccount = validFromAccount.apply { balance -= amount }
                val updatedToAccount = validToAccount.apply { balance += amount }
                
                // Log the transfer
                logTransfer(validFromAccount.accountNumber, validToAccount.accountNumber, amount)
                
                Pair(updatedFromAccount, updatedToAccount)
            }
        } ?: Pair(null, null)
    }
    
    fun logAccountCreated(accountNumber: String, type: String) {}
    fun logTransaction(accountNumber: String, amount: Double, type: String) {}
    fun logTransfer(fromAccount: String, toAccount: String, amount: Double) {}
}

class ApiService {
    
    fun <T> processApiResponse(response: ApiResponse<T>): T? {
        // Using 'takeIf' and 'let' for response validation
        return response.takeIf { it.statusCode in 200..299 }?.let { validResponse ->
            validResponse.data?.also { data ->
                logSuccessfulResponse(validResponse.statusCode)
            }
        } ?: run {
            logErrorResponse(response.statusCode, response.errorMessage ?: "Unknown error")
            null
        }
    }
    
    fun <T> createApiResponse(data: T?, statusCode: Int, errorMessage: String?): ApiResponse<T> {
        // Using 'apply' for response building
        return ApiResponse<T>().apply {
            this.data = data
            this.statusCode = statusCode
            this.errorMessage = errorMessage
            headers.apply {
                put("Content-Type", "application/json")
                put("Timestamp", "1640995200000")
                put("Server", "Kotlin-Service")
            }
        }
    }
    
    fun handleApiError(response: ApiResponse<*>): String {
        // Using 'run' for error handling
        return response.run {
            when (statusCode) {
                404 -> "Resource not found: ${errorMessage ?: "Unknown resource"}"
                401 -> "Unauthorized access"
                403 -> "Forbidden operation"
                500 -> "Internal server error: ${errorMessage ?: "Unknown error"}"
                else -> "API error ($statusCode): ${errorMessage ?: "Unknown error"}"
            }
        }
    }
    
    fun <T> retryApiCall(maxRetries: Int, apiCall: () -> ApiResponse<T>): ApiResponse<T>? {
        // Using scope functions in retry logic
        repeat(maxRetries) { attempt ->
            apiCall().let { response ->
                response.takeIf { it.statusCode in 200..299 }?.let { successResponse ->
                    return successResponse.also {
                        logRetrySuccess(attempt + 1, maxRetries)
                    }
                }
                
                if (attempt < maxRetries - 1) {
                    logRetryAttempt(attempt + 1, maxRetries, response.statusCode)
                }
            }
        }
        return null
    }
    
    fun logSuccessfulResponse(statusCode: Int) {}
    fun logErrorResponse(statusCode: Int, error: String) {}
    fun logRetrySuccess(attempt: Int, maxRetries: Int) {}
    fun logRetryAttempt(attempt: Int, maxRetries: Int, statusCode: Int) {}
}

class ConfigurationService {
    
    fun createDatabaseConfig(host: String, port: Int, database: String): DatabaseConfig {
        // Using 'apply' for complex configuration
        return DatabaseConfig("", 0, "", "", "").apply {
            this.host = host
            this.port = port
            this.database = database
            username = "defaultUser"
            password = "defaultPassword"
            connectionPool = ConnectionPoolConfig(0, 0, 0L).apply {
                minConnections = 5
                maxConnections = 20
                timeout = 30000L
            }
        }
    }
    
    fun createAppConfig(appName: String, version: String, environment: String): AppConfig {
        // Using 'apply' with nested configuration
        return AppConfig("", "", "", DatabaseConfig("", 0, "", "", "")).apply {
            this.appName = appName
            this.version = version
            this.environment = environment
            database = createDatabaseConfig("localhost", 5432, "app_db")
            
            features.apply {
                put("feature_flags", true)
                put("analytics", environment != "development")
                put("logging", true)
                put("cache", environment == "production")
            }
            
            settings.apply {
                put("log_level", if (environment == "production") "ERROR" else "DEBUG")
                put("cache_ttl", "3600")
                put("max_connections", "100")
                put("timeout", "30000")
            }
        }.also { config ->
            logConfigurationCreated(config.appName, config.environment)
        }
    }
    
    fun validateConfiguration(config: AppConfig): Map<String, Any> {
        // Using 'run' for validation logic
        return config.run {
            val issues = mutableListOf<String>()
            
            if (appName.isBlank()) issues.add("App name is required")
            if (version.isBlank()) issues.add("Version is required")
            if (environment !in listOf("development", "staging", "production")) {
                issues.add("Invalid environment: $environment")
            }
            
            database.run {
                if (host.isBlank()) issues.add("Database host is required")
                if (port <= 0) issues.add("Database port must be positive")
                if (database.isBlank()) issues.add("Database name is required")
            }
            
            mapOf(
                "isValid" to issues.isEmpty(),
                "issues" to issues,
                "summary" to if (issues.isEmpty()) "Configuration is valid" else "Found ${issues.size} issues"
            )
        }
    }
    
    fun updateConfiguration(config: AppConfig, updates: Map<String, String>): AppConfig {
        // Using 'also' for configuration updates
        return config.also { cfg ->
            updates.forEach { (key, value) ->
                when (key) {
                    "log_level" -> cfg.settings[key] = value
                    "cache_ttl" -> cfg.settings[key] = value
                    "max_connections" -> cfg.settings[key] = value
                    else -> cfg.settings[key] = value
                }
            }
        }.also { updatedConfig ->
            logConfigurationUpdated(updatedConfig.appName, updates.keys.toList())
        }
    }
    
    fun logConfigurationCreated(appName: String, environment: String) {}
    fun logConfigurationUpdated(appName: String, updatedKeys: List<String>) {}
}

// Main benchmark class demonstrating scope function usage
class IosSizeBenchmark {
    val userService = UserService()
    val productService = ProductService()
    val cartService = ShoppingCartService()
    val bankingService = BankingService()
    val apiService = ApiService()
    val configService = ConfigurationService()
    
    fun runBenchmark() {
        // User service demonstrations
        val user = userService.createUser("John Doe", "john@example.com", 30)
        
        val updatedUser = userService.updateUserWithValidation(user, "newemail@test.com", 31)
        val processedData = userService.processUserData(updatedUser)
        val configuredUser = userService.configureUserPreferences(user)
        val validationResult = userService.validateAndFormatUser(user)
        val userSummary = userService.getUserSummary(user)
        
        // Product service demonstrations
        val product = productService.createProduct("Laptop", 999.99, "Electronics")
        val updatedProduct = productService.updateProductPrice(product, 899.99)
        val saleProduct = productService.configureProductForSale(product, 15.0)
        val productAnalysis = productService.analyzeProduct(product)
        
        val products = listOf(
            productService.createProduct("Mouse", 29.99, "Electronics"),
            productService.createProduct("Keyboard", 79.99, "Electronics"),
            productService.createProduct("Monitor", 299.99, "Electronics")
        )
        val processedProducts = productService.processProductBatch(products)
        
        // Shopping cart demonstrations
        val cart = cartService.createCart("USER_123")
        val cartWithItems = cartService.addItemToCart(cart, "PROD_1", 2, 29.99)
            .let { cartService.addItemToCart(it, "PROD_2", 1, 79.99) }
            .let { cartService.addItemToCart(it, "PROD_3", 1, 299.99) }
        
        val discountedCart = cartService.applyDiscount(cartWithItems, "SAVE10")
        val cartSummary = cartService.calculateCartSummary(cartWithItems)
        
        val address = Address("123 Main St", "New York", "NY", "10001", "USA")
        val order = cartService.processCartCheckout(cartWithItems, address, "credit_card")
        
        // Banking demonstrations
        val checkingAccount = bankingService.createAccount("CHK001", "checking")
        val savingsAccount = bankingService.createAccount("SAV001", "savings")
        
        val accountAfterDeposit = bankingService.processTransaction(checkingAccount, 1000.0, "deposit")
        val accountAfterWithdrawal = accountAfterDeposit?.let { 
            bankingService.processTransaction(it, 250.0, "withdrawal") 
        }
        
        val accountStatement = accountAfterWithdrawal?.let { 
            bankingService.generateAccountStatement(it) 
        }
        
        val (fromAccount, toAccount) = bankingService.transferFunds(
            checkingAccount, savingsAccount, 500.0
        )
        
        // API service demonstrations
        val successResponse = apiService.createApiResponse("Success data", 200, null)
        val errorResponse = apiService.createApiResponse(null, 404, "Not found")
        
        val processedSuccess = apiService.processApiResponse(successResponse)
        val processedError = apiService.processApiResponse(errorResponse)
        val errorMessage = apiService.handleApiError(errorResponse)
        
        // Configuration demonstrations
        val dbConfig = configService.createDatabaseConfig("localhost", 5432, "myapp_db")
        val appConfig = configService.createAppConfig("MyApp", "1.0.0", "production")
        val validationResult2 = configService.validateConfiguration(appConfig)
        val updatedConfig = configService.updateConfiguration(appConfig, mapOf(
            "log_level" to "INFO",
            "cache_ttl" to "7200"
        ))
        
        // Complex scope function chaining demonstrations
        val complexUserProcessing = listOf(
            User("1", "Alice", "alice@test.com", 25),
            User("2", "Bob", "bob@example.com", 35),
            User("3", "Charlie", "charlie@company.org", 45)
        ).map { user ->
            user.apply {
                preferences = UserPreferences("dark", "en", true, false)
                // address = Address("", "", "", "", "USA")
            }
        }.filter { user ->
            user.email.contains("@")
        }.map { user ->
            userService.getUserSummary(user)
        }.also { summaries ->
            summaries.forEach { summary ->
                // Log processing results
            }
        }
        
        // Complex product processing chain
        val productProcessingChain = (1..10).map { i ->
            productService.createProduct("Product $i", i * 10.0, "Category${i % 3}")
        }.map { prod ->
            productService.updateProductPrice(prod, prod.price * 0.9)
        }.mapNotNull { prod ->
            prod?.takeIf { it.price > 50 }
        }.map { prod ->
            productService.configureProductForSale(prod, 20.0)
        }.map { prod ->
            productService.analyzeProduct(prod)
        }.also { analyses ->
            // Process analysis results
        }
        
        // Complex cart and order processing
        val orderProcessingChain = listOf("USER_1", "USER_2", "USER_3").map { userId ->
            cartService.createCart(userId).apply {
                products.take(3).forEach { product ->
                    cartService.addItemToCart(this, product.id, 1, product.price)
                }
            }
        }.mapNotNull { cart ->
            cartService.applyDiscount(cart, "SAVE15")
        }.map { cart ->
            cartService.calculateCartSummary(cart)
        }.also { summaries ->
            summaries.forEach { summary ->
                // Process cart summaries
            }
        }
        
        // Banking operation chains
        val bankingOperations = listOf(
            "ACC001" to "checking",
            "ACC002" to "savings",
            "ACC003" to "business"
        ).map { (accNum, type) ->
            bankingService.createAccount(accNum, type)
        }.map { account ->
            bankingService.processTransaction(account, 1000.0, "deposit")
        }.mapNotNull { account ->
            account?.let { bankingService.processTransaction(it, 100.0, "withdrawal") }
        }.map { account ->
            bankingService.generateAccountStatement(account)
        }.also { statements ->
            statements.forEach { statement ->
                // Process account statements
            }
        }
        
        // API response processing chains
        val apiResponseChain = listOf(
            200 to "Success",
            404 to "Not Found",
            500 to "Server Error"
        ).map { (status, message) ->
            if (status == 200) {
                apiService.createApiResponse("Data", status, null)
            } else {
                apiService.createApiResponse(null, status, message)
            }
        }.map { response ->
            response.takeIf { it.statusCode in 200..299 }?.let { successResponse ->
                "Success: ${apiService.processApiResponse(successResponse)}"
            } ?: run {
                "Error: ${apiService.handleApiError(response)}"
            }
        }.also { results ->
            results.forEach { result ->
                // Process API results
            }
        }
        
        // Configuration processing chains
        val configChain = listOf(
            "App1" to "development",
            "App2" to "staging", 
            "App3" to "production"
        ).map { (name, env) ->
            configService.createAppConfig(name, "1.0.0", env)
        }.map { config ->
            configService.validateConfiguration(config).let { validation ->
                if (validation["isValid"] as Boolean) {
                    config
                } else {
                    config.apply {
                        // Fix configuration issues
                        if (appName.isBlank()) appName = "DefaultApp"
                        if (version.isBlank()) version = "1.0.0"
                    }
                }
            }
        }.map { config ->
            configService.updateConfiguration(config, mapOf(
                "log_level" to "INFO",
                "timeout" to "60000"
            ))
        }.also { configs ->
            configs.forEach { config ->
                // Process final configurations
            }
        }
        
        // Nested scope function usage
        user.apply {
            name = "Updated $name"
            email = email.lowercase()
        }.let { updatedUser ->
            userService.validateAndFormatUser(updatedUser)
        }.also { validationMessage ->
            // Log validation result
        }.run {
            this.length > 10
        }.let { isLongMessage ->
            if (isLongMessage) "Long validation message" else "Short validation message"
        }
        
        // Error handling with scope functions
        val safeOperation = user.takeIf { it.age > 0 }?.let { validUser ->
            validUser.address?.takeIf { it.zipCode.isNotEmpty() }?.let { validAddress ->
                "User ${validUser.name} has valid address in ${validAddress.city}"
            } ?: "User has invalid address"
        } ?: "Invalid user data"
        
        // Resource management patterns with scope functions
        val resourceManagement = products.takeIf { it.isNotEmpty() }?.let { validProducts ->
            validProducts.map { product ->
                product.takeIf { it.inStock }?.run {
                    "Processing available product: $name ($price)"
                } ?: "Product ${product.name} is out of stock"
            }
        }?.also { messages ->
            // Log all processing messages
        } ?: emptyList()
    }
}