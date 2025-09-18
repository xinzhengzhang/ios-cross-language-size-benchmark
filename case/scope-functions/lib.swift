/*
 * iOS Size Benchmark - Test Case Implementation
 * Generated with Claude AI (https://claude.ai)
 * 
 * This Swift implementation demonstrates language-specific
 * features and patterns for binary size comparison.
 */

import Foundation

// Test case: Scope Functions - Swift equivalent requiring manual patterns for Kotlin's scope functions
// This demonstrates how verbose Swift becomes without Kotlin's elegant scope functions

// Data models - much more verbose than Kotlin data classes
public class User {
    public var id: String
    public var name: String
    public var email: String
    public var age: Int
    public var address: Address?
    public var preferences: UserPreferences?
    
    public init(id: String, name: String, email: String, age: Int, address: Address? = nil, preferences: UserPreferences? = nil) {
        self.id = id
        self.name = name
        self.email = email
        self.age = age
        self.address = address
        self.preferences = preferences
    }
}

public class Address {
    public var street: String
    public var city: String
    public var state: String
    public var zipCode: String
    public var country: String
    
    public init(street: String, city: String, state: String, zipCode: String, country: String) {
        self.street = street
        self.city = city
        self.state = state
        self.zipCode = zipCode
        self.country = country
    }
}

public class UserPreferences {
    public var theme: String
    public var language: String
    public var notifications: Bool
    public var newsletter: Bool
    
    public init(theme: String, language: String, notifications: Bool, newsletter: Bool) {
        self.theme = theme
        self.language = language
        self.notifications = notifications
        self.newsletter = newsletter
    }
}

public class Product {
    public var id: String
    public var name: String
    public var price: Double
    public var category: String
    public var description: String
    public var inStock: Bool
    public var tags: [String]
    
    public init(id: String, name: String, price: Double, category: String, description: String, inStock: Bool, tags: [String] = []) {
        self.id = id
        self.name = name
        self.price = price
        self.category = category
        self.description = description
        self.inStock = inStock
        self.tags = tags
    }
}

public class ShoppingCart {
    public var id: String
    public var userId: String
    public var items: [CartItem]
    public var discountCode: String?
    public var discountAmount: Double
    
    public init(id: String, userId: String, items: [CartItem] = [], discountCode: String? = nil, discountAmount: Double = 0.0) {
        self.id = id
        self.userId = userId
        self.items = items
        self.discountCode = discountCode
        self.discountAmount = discountAmount
    }
}

public class CartItem {
    public var productId: String
    public var quantity: Int
    public var price: Double
    
    public init(productId: String, quantity: Int, price: Double) {
        self.productId = productId
        self.quantity = quantity
        self.price = price
    }
}

public class Order {
    public var id: String
    public var cart: ShoppingCart
    public var shippingAddress: Address
    public var paymentMethod: String
    public var status: String
    public var timestamp: Int64
    
    public init(id: String, cart: ShoppingCart, shippingAddress: Address, paymentMethod: String, status: String, timestamp: Int64) {
        self.id = id
        self.cart = cart
        self.shippingAddress = shippingAddress
        self.paymentMethod = paymentMethod
        self.status = status
        self.timestamp = timestamp
    }
}

public class BankAccount {
    public var accountNumber: String
    public var balance: Double
    public var accountType: String
    public var isActive: Bool
    
    public init(accountNumber: String, balance: Double, accountType: String, isActive: Bool) {
        self.accountNumber = accountNumber
        self.balance = balance
        self.accountType = accountType
        self.isActive = isActive
    }
}

public class ApiResponse<T> {
    public var data: T?
    public var errorMessage: String?
    public var statusCode: Int
    public var headers: [String: String]
    
    public init(data: T? = nil, errorMessage: String? = nil, statusCode: Int = 0, headers: [String: String] = [:]) {
        self.data = data
        self.errorMessage = errorMessage
        self.statusCode = statusCode
        self.headers = headers
    }
}

// Configuration classes
public class DatabaseConfig {
    public var host: String
    public var port: Int
    public var database: String
    public var username: String
    public var password: String
    public var connectionPool: ConnectionPoolConfig?
    
    public init(host: String, port: Int, database: String, username: String, password: String, connectionPool: ConnectionPoolConfig? = nil) {
        self.host = host
        self.port = port
        self.database = database
        self.username = username
        self.password = password
        self.connectionPool = connectionPool
    }
}

public class ConnectionPoolConfig {
    public var minConnections: Int
    public var maxConnections: Int
    public var timeout: Int64
    
    public init(minConnections: Int, maxConnections: Int, timeout: Int64) {
        self.minConnections = minConnections
        self.maxConnections = maxConnections
        self.timeout = timeout
    }
}

public class AppConfig {
    public var appName: String
    public var version: String
    public var environment: String
    public var database: DatabaseConfig
    public var features: [String: Bool]
    public var settings: [String: String]
    
    public init(appName: String, version: String, environment: String, database: DatabaseConfig, features: [String: Bool] = [:], settings: [String: String] = [:]) {
        self.appName = appName
        self.version = version
        self.environment = environment
        self.database = database
        self.features = features
        self.settings = settings
    }
}

// Service classes demonstrating manual patterns instead of Kotlin's scope functions
public class UserService {
    
    public func createUser(name: String, email: String, age: Int) -> User {
        // Manual equivalent of Kotlin's 'apply' - much more verbose
        let user = User(id: "", name: "", email: "", age: 0)
        
        // Manual configuration - no 'apply' equivalent in Swift
        user.id = generateUserId()
        user.name = name
        user.email = email
        user.age = age
        
        // Manual nested object creation - no nested 'apply'
        let address = Address(street: "", city: "", state: "", zipCode: "", country: "")
        address.street = ""
        address.city = ""
        address.state = ""
        address.zipCode = ""
        address.country = "USA"
        user.address = address
        
        // Manual preferences setup
        let preferences = UserPreferences(theme: "", language: "", notifications: false, newsletter: false)
        preferences.theme = "light"
        preferences.language = "en"
        preferences.notifications = true
        preferences.newsletter = false
        user.preferences = preferences
        
        return user
    }
    
    public func updateUserWithValidation(user: User, newEmail: String?, newAge: Int?) -> User? {
        // Manual equivalent of Kotlin's 'let' - much more verbose with nested optionals
        var updated = false
        
        if let email = newEmail {
            if email.contains("@") {
                user.email = email
                updated = true
            }
        }
        
        if let age = newAge {
            if age > 0 && age < 120 {
                user.age = age
                updated = true
            }
        }
        
        return updated ? user : nil
    }
    
    public func processUserData(user: User?) -> String {
        // Manual equivalent of Kotlin's 'let' with null safety
        if let validUser = user {
            return "Processing user: \(validUser.name) (\(validUser.email))"
        } else {
            return "No user to process"
        }
    }
    
    public func configureUserPreferences(user: User) -> User {
        // Manual equivalent of Kotlin's 'also' - no elegant side effects pattern
        if let preferences = user.preferences {
            preferences.theme = "dark"
            preferences.notifications = true
            logPreferenceChange(userId: user.id, key: "theme", value: "dark")
            logPreferenceChange(userId: user.id, key: "notifications", value: "enabled")
        }
        return user
    }
    
    public func validateAndFormatUser(user: User) -> String {
        // Manual equivalent of Kotlin's 'run' - no receiver context
        let isValidEmail = user.email.contains("@")
        let isValidAge = user.age >= 1 && user.age <= 120
        let hasAddress = user.address != nil
        
        if !isValidEmail {
            return "Invalid email: \(user.email)"
        } else if !isValidAge {
            return "Invalid age: \(user.age)"
        } else if !hasAddress {
            return "Missing address information"
        } else {
            return "Valid user: \(user.name) (\(user.email), age \(user.age))"
        }
    }
    
    public func getUserSummary(user: User?) -> [String: Any] {
        // Manual equivalent of Kotlin's 'let' with complex transformations
        guard let validUser = user else {
            return [:]
        }
        
        let addressSummary: String
        if let addr = validUser.address {
            addressSummary = "\(addr.city), \(addr.state), \(addr.country)"
        } else {
            addressSummary = "No address"
        }
        
        let preferencesSummary: String
        if let prefs = validUser.preferences {
            preferencesSummary = "Theme: \(prefs.theme), Language: \(prefs.language)"
        } else {
            preferencesSummary = "No preferences"
        }
        
        return [
            "id": validUser.id,
            "name": validUser.name,
            "email": validUser.email,
            "age": validUser.age,
            "hasAddress": validUser.address != nil,
            "hasPreferences": validUser.preferences != nil,
            "addressSummary": addressSummary,
            "preferencesSummary": preferencesSummary
        ]
    }
    
    private func generateUserId() -> String {
        return "USER_\(Int64(Date().timeIntervalSince1970 * 1000))"
    }
    
    private func logPreferenceChange(userId: String, key: String, value: String) {
        // Logging implementation
    }
}

public class ProductService {
    
    public func createProduct(name: String, price: Double, category: String) -> Product {
        // Manual equivalent of Kotlin's 'apply' - much more verbose
        let product = Product(id: "", name: "", price: 0.0, category: "", description: "", inStock: false)
        
        product.id = generateProductId()
        product.name = name
        product.price = price
        product.category = category
        product.description = "Default description for \(name)"
        product.inStock = true
        
        // Manual tag manipulation - no 'apply' for collections
        product.tags.append("new")
        product.tags.append(category.lowercased())
        if price > 100 {
            product.tags.append("premium")
        }
        
        return product
    }
    
    public func updateProductPrice(product: Product, newPrice: Double) -> Product? {
        // Manual equivalent of Kotlin's 'takeIf' with 'apply' - much more complex
        guard newPrice > 0 else {
            return nil
        }
        
        let oldPrice = product.price
        product.price = newPrice
        
        // Manual tag updates - no elegant collection 'apply'
        product.tags.removeAll { $0 == "budget" || $0 == "premium" || $0 == "luxury" }
        
        if newPrice < 50 {
            product.tags.append("budget")
        } else if newPrice > 500 {
            product.tags.append("luxury")
        } else if newPrice > 100 {
            product.tags.append("premium")
        }
        
        logPriceChange(productId: product.id, oldPrice: oldPrice, newPrice: newPrice)
        return product
    }
    
    public func processProductBatch(products: [Product]) -> [String] {
        // Manual equivalent of Kotlin's scope functions in collections
        var results: [String] = []
        
        for product in products {
            if product.inStock {
                results.append("Processing: \(product.name) - $\(product.price)")
            }
        }
        
        return results
    }
    
    public func configureProductForSale(product: Product, discountPercent: Double) -> Product {
        // Manual equivalent of Kotlin's 'also' with nested 'apply' - very verbose
        product.price *= (1 - discountPercent / 100)
        product.tags.append("sale")
        product.tags.append("discounted")
        
        // Manual side effects - no 'also' chaining
        logSaleConfiguration(productId: product.id, discountPercent: discountPercent)
        notifyPriceChange(productId: product.id, newPrice: product.price)
        
        return product
    }
    
    public func analyzeProduct(product: Product) -> [String: Any] {
        // Manual equivalent of Kotlin's 'run' - no receiver context
        let priceCategory: String
        if product.price < 20 {
            priceCategory = "budget"
        } else if product.price < 100 {
            priceCategory = "mid-range"
        } else if product.price < 500 {
            priceCategory = "premium"
        } else {
            priceCategory = "luxury"
        }
        
        // Manual tag analysis - no 'run' for collections
        let promoTags = ["sale", "new", "featured"]
        let categoryTags = ["electronics", "clothing", "books"]
        
        let tagAnalysis: [String: Any] = [
            "tagCount": product.tags.count,
            "hasPromoTags": product.tags.contains { promoTags.contains($0) },
            "categoryTags": product.tags.filter { categoryTags.contains($0) }
        ]
        
        return [
            "productId": product.id,
            "priceCategory": priceCategory,
            "availability": product.inStock ? "available" : "out_of_stock",
            "tagAnalysis": tagAnalysis,
            "summary": "\(product.name) (\(priceCategory)) - \(product.inStock ? "In Stock" : "Out of Stock")"
        ]
    }
    
    private func generateProductId() -> String {
        return "PROD_\(Int64(Date().timeIntervalSince1970 * 1000))"
    }
    
    private func logPriceChange(productId: String, oldPrice: Double, newPrice: Double) {}
    private func logSaleConfiguration(productId: String, discountPercent: Double) {}
    private func notifyPriceChange(productId: String, newPrice: Double) {}
}

public class ShoppingCartService {
    
    public func createCart(userId: String) -> ShoppingCart {
        // Manual equivalent of Kotlin's 'apply' - verbose initialization
        let cart = ShoppingCart(id: "", userId: "")
        cart.id = generateCartId()
        cart.userId = userId
        cart.items = []
        cart.discountAmount = 0.0
        return cart
    }
    
    public func addItemToCart(cart: ShoppingCart, productId: String, quantity: Int, price: Double) -> ShoppingCart {
        // Manual equivalent of Kotlin's 'also' - no elegant side effects
        let item = CartItem(productId: productId, quantity: quantity, price: price)
        cart.items.append(item)
        logCartItemAdded(cartId: cart.id, productId: productId, quantity: quantity)
        return cart
    }
    
    public func applyDiscount(cart: ShoppingCart, discountCode: String) -> ShoppingCart? {
        // Manual equivalent of Kotlin's 'takeIf' with 'apply' and 'also' - very complex
        guard validateDiscountCode(discountCode: discountCode) else {
            return nil
        }
        
        cart.discountCode = discountCode
        cart.discountAmount = calculateDiscount(cart: cart, discountCode: discountCode)
        
        logDiscountApplied(cartId: cart.id, discountCode: discountCode, amount: cart.discountAmount)
        return cart
    }
    
    public func processCartCheckout(cart: ShoppingCart, shippingAddress: Address, paymentMethod: String) -> Order? {
        // Manual equivalent of Kotlin's 'takeIf' with 'let' and 'also' - extremely verbose
        guard !cart.items.isEmpty else {
            return nil
        }
        
        let order = Order(id: "", cart: cart, shippingAddress: shippingAddress, paymentMethod: paymentMethod, status: "", timestamp: 0)
        order.id = generateOrderId()
        order.status = "pending"
        order.timestamp = Int64(Date().timeIntervalSince1970 * 1000)
        
        logOrderCreated(orderId: order.id, cartId: cart.id)
        clearCart(cart: cart)
        
        return order
    }
    
    public func calculateCartSummary(cart: ShoppingCart) -> [String: Any] {
        // Manual equivalent of Kotlin's 'run' - no receiver context
        let subtotal = cart.items.reduce(0) { $0 + ($1.price * Double($1.quantity)) }
        let total = subtotal - cart.discountAmount
        let itemCount = cart.items.reduce(0) { $0 + $1.quantity }
        
        let itemsData = cart.items.map { item in
            return [
                "productId": item.productId,
                "quantity": item.quantity,
                "price": item.price,
                "total": item.price * Double(item.quantity)
            ]
        }
        
        return [
            "cartId": cart.id,
            "itemCount": itemCount,
            "subtotal": subtotal,
            "discountAmount": cart.discountAmount,
            "total": total,
            "hasDiscount": cart.discountCode != nil,
            "discountCode": cart.discountCode ?? "none",
            "items": itemsData
        ]
    }
    
    private func generateCartId() -> String {
        return "CART_\(Int64(Date().timeIntervalSince1970 * 1000))"
    }
    
    private func generateOrderId() -> String {
        return "ORDER_\(Int64(Date().timeIntervalSince1970 * 1000))"
    }
    
    private func validateDiscountCode(discountCode: String) -> Bool {
        return !discountCode.isEmpty
    }
    
    private func calculateDiscount(cart: ShoppingCart, discountCode: String) -> Double {
        return 10.0
    }
    
    private func logCartItemAdded(cartId: String, productId: String, quantity: Int) {}
    private func logDiscountApplied(cartId: String, discountCode: String, amount: Double) {}
    private func logOrderCreated(orderId: String, cartId: String) {}
    private func clearCart(cart: ShoppingCart) {
        cart.items.removeAll()
    }
}

public class BankingService {
    
    public func createAccount(accountNumber: String, accountType: String) -> BankAccount {
        // Manual equivalent of Kotlin's 'apply' with 'also' - verbose setup
        let account = BankAccount(accountNumber: "", balance: 0.0, accountType: "", isActive: false)
        account.accountNumber = accountNumber
        account.balance = 0.0
        account.accountType = accountType
        account.isActive = true
        
        logAccountCreated(accountNumber: account.accountNumber, type: account.accountType)
        return account
    }
    
    public func processTransaction(account: BankAccount, amount: Double, type: String) -> BankAccount? {
        // Manual equivalent of Kotlin's 'takeIf' with 'let' - complex nested logic
        guard account.isActive else {
            return nil
        }
        
        switch type {
        case "deposit":
            account.balance += amount
            logTransaction(accountNumber: account.accountNumber, amount: amount, type: type)
            return account
            
        case "withdrawal":
            guard account.balance >= amount else {
                return nil
            }
            account.balance -= amount
            logTransaction(accountNumber: account.accountNumber, amount: amount, type: type)
            return account
            
        default:
            return nil
        }
    }
    
    public func generateAccountStatement(account: BankAccount) -> [String: Any] {
        // Manual equivalent of Kotlin's 'run' - no receiver context
        let accountStatus: String
        if !account.isActive {
            accountStatus = "inactive"
        } else if account.balance < 0 {
            accountStatus = "overdrawn"
        } else if account.balance < 100 {
            accountStatus = "low_balance"
        } else {
            accountStatus = "normal"
        }
        
        return [
            "accountNumber": account.accountNumber,
            "accountType": account.accountType,
            "balance": account.balance,
            "status": accountStatus,
            "isActive": account.isActive,
            "formattedBalance": String(format: "$%.2f", account.balance),
            "canWithdraw": account.isActive && account.balance > 0,
            "summary": "\(account.accountType) account #\(account.accountNumber): \(String(format: "%.2f", account.balance)) (\(accountStatus))"
        ]
    }
    
    public func transferFunds(fromAccount: BankAccount, toAccount: BankAccount, amount: Double) -> (BankAccount?, BankAccount?) {
        // Manual equivalent of complex Kotlin scope function chaining - extremely verbose
        guard fromAccount.isActive && fromAccount.balance >= amount else {
            return (nil, nil)
        }
        
        guard toAccount.isActive else {
            return (nil, nil)
        }
        
        fromAccount.balance -= amount
        toAccount.balance += amount
        
        logTransfer(fromAccount: fromAccount.accountNumber, toAccount: toAccount.accountNumber, amount: amount)
        
        return (fromAccount, toAccount)
    }
    
    private func logAccountCreated(accountNumber: String, type: String) {}
    private func logTransaction(accountNumber: String, amount: Double, type: String) {}
    private func logTransfer(fromAccount: String, toAccount: String, amount: Double) {}
}

public class ApiService {
    
    public func processApiResponse<T>(response: ApiResponse<T>) -> T? {
        // Manual equivalent of Kotlin's 'takeIf' and 'let' - verbose validation
        if response.statusCode >= 200 && response.statusCode < 300 {
            if let data = response.data {
                logSuccessfulResponse(statusCode: response.statusCode)
                return data
            }
        }
        
        logErrorResponse(statusCode: response.statusCode, error: response.errorMessage ?? "Unknown error")
        return nil
    }
    
    public func createApiResponse<T>(data: T?, statusCode: Int, errorMessage: String?) -> ApiResponse<T> {
        // Manual equivalent of Kotlin's 'apply' - verbose initialization
        let response = ApiResponse<T>()
        response.data = data
        response.statusCode = statusCode
        response.errorMessage = errorMessage
        
        response.headers["Content-Type"] = "application/json"
        response.headers["Timestamp"] = String(Int64(Date().timeIntervalSince1970 * 1000))
        response.headers["Server"] = "Swift-Service"
        
        return response
    }
    
    public func handleApiError<T>(response: ApiResponse<T>) -> String {
        // Manual equivalent of Kotlin's 'run' - no receiver context
        switch response.statusCode {
        case 404:
            return "Resource not found: \(response.errorMessage ?? "Unknown resource")"
        case 401:
            return "Unauthorized access"
        case 403:
            return "Forbidden operation"
        case 500:
            return "Internal server error: \(response.errorMessage ?? "Unknown error")"
        default:
            return "API error (\(response.statusCode)): \(response.errorMessage ?? "Unknown error")"
        }
    }
    
    public func retryApiCall<T>(maxRetries: Int, apiCall: () -> ApiResponse<T>) -> ApiResponse<T>? {
        // Manual equivalent of Kotlin's scope functions in retry logic
        for attempt in 0..<maxRetries {
            let response = apiCall()
            
            if response.statusCode >= 200 && response.statusCode < 300 {
                logRetrySuccess(attempt: attempt + 1, maxRetries: maxRetries)
                return response
            }
            
            if attempt < maxRetries - 1 {
                logRetryAttempt(attempt: attempt + 1, maxRetries: maxRetries, statusCode: response.statusCode)
            }
        }
        
        return nil
    }
    
    private func logSuccessfulResponse(statusCode: Int) {}
    private func logErrorResponse(statusCode: Int, error: String) {}
    private func logRetrySuccess(attempt: Int, maxRetries: Int) {}
    private func logRetryAttempt(attempt: Int, maxRetries: Int, statusCode: Int) {}
}

public class ConfigurationService {
    
    public func createDatabaseConfig(host: String, port: Int, database: String) -> DatabaseConfig {
        // Manual equivalent of Kotlin's 'apply' - extremely verbose nested configuration
        let config = DatabaseConfig(host: "", port: 0, database: "", username: "", password: "")
        config.host = host
        config.port = port
        config.database = database
        config.username = "defaultUser"
        config.password = "defaultPassword"
        
        let poolConfig = ConnectionPoolConfig(minConnections: 0, maxConnections: 0, timeout: 0)
        poolConfig.minConnections = 5
        poolConfig.maxConnections = 20
        poolConfig.timeout = 30000
        config.connectionPool = poolConfig
        
        return config
    }
    
    public func createAppConfig(appName: String, version: String, environment: String) -> AppConfig {
        // Manual equivalent of Kotlin's nested 'apply' - incredibly verbose
        let dbConfig = createDatabaseConfig(host: "localhost", port: 5432, database: "app_db")
        let config = AppConfig(appName: "", version: "", environment: "", database: dbConfig)
        
        config.appName = appName
        config.version = version
        config.environment = environment
        config.database = dbConfig
        
        // Manual feature configuration - no 'apply' for dictionaries
        config.features["feature_flags"] = true
        config.features["analytics"] = environment != "development"
        config.features["logging"] = true
        config.features["cache"] = environment == "production"
        
        // Manual settings configuration
        config.settings["log_level"] = environment == "production" ? "ERROR" : "DEBUG"
        config.settings["cache_ttl"] = "3600"
        config.settings["max_connections"] = "100"
        config.settings["timeout"] = "30000"
        
        logConfigurationCreated(appName: config.appName, environment: config.environment)
        return config
    }
    
    public func validateConfiguration(config: AppConfig) -> [String: Any] {
        // Manual equivalent of Kotlin's 'run' - no receiver context
        var issues: [String] = []
        
        if config.appName.isEmpty {
            issues.append("App name is required")
        }
        if config.version.isEmpty {
            issues.append("Version is required")
        }
        if !["development", "staging", "production"].contains(config.environment) {
            issues.append("Invalid environment: \(config.environment)")
        }
        
        // Manual database validation - no 'run' for nested objects
        if config.database.host.isEmpty {
            issues.append("Database host is required")
        }
        if config.database.port <= 0 {
            issues.append("Database port must be positive")
        }
        if config.database.database.isEmpty {
            issues.append("Database name is required")
        }
        
        return [
            "isValid": issues.isEmpty,
            "issues": issues,
            "summary": issues.isEmpty ? "Configuration is valid" : "Found \(issues.count) issues"
        ]
    }
    
    public func updateConfiguration(config: AppConfig, updates: [String: String]) -> AppConfig {
        // Manual equivalent of Kotlin's 'also' - no elegant side effects
        for (key, value) in updates {
            switch key {
            case "log_level", "cache_ttl", "max_connections":
                config.settings[key] = value
            default:
                config.settings[key] = value
            }
        }
        
        logConfigurationUpdated(appName: config.appName, updatedKeys: Array(updates.keys))
        return config
    }
    
    private func logConfigurationCreated(appName: String, environment: String) {}
    private func logConfigurationUpdated(appName: String, updatedKeys: [String]) {}
}

// Main benchmark class demonstrating verbose patterns instead of Kotlin's scope functions
public class IosSizeBenchmark {
    private let userService = UserService()
    private let productService = ProductService()
    private let cartService = ShoppingCartService()
    private let bankingService = BankingService()
    private let apiService = ApiService()
    private let configService = ConfigurationService()
    
    public func runBenchmark() {
        // User service demonstrations - much more verbose than Kotlin's scope functions
        let user = userService.createUser(name: "John Doe", email: "john@example.com", age: 30)
        
        let updatedUser = userService.updateUserWithValidation(user: user, newEmail: "newemail@test.com", newAge: 31)
        let processedData = userService.processUserData(user: updatedUser)
        let configuredUser = userService.configureUserPreferences(user: user)
        let validationResult = userService.validateAndFormatUser(user: user)
        let userSummary = userService.getUserSummary(user: user)
        
        // Product service demonstrations - manual object manipulation
        let product = productService.createProduct(name: "Laptop", price: 999.99, category: "Electronics")
        let updatedProduct = productService.updateProductPrice(product: product, newPrice: 899.99)
        let saleProduct = productService.configureProductForSale(product: product, discountPercent: 15.0)
        let productAnalysis = productService.analyzeProduct(product: product)
        
        let products = [
            productService.createProduct(name: "Mouse", price: 29.99, category: "Electronics"),
            productService.createProduct(name: "Keyboard", price: 79.99, category: "Electronics"),
            productService.createProduct(name: "Monitor", price: 299.99, category: "Electronics")
        ]
        let processedProducts = productService.processProductBatch(products: products)
        
        // Shopping cart demonstrations - manual chaining instead of elegant 'let' chains
        let cart = cartService.createCart(userId: "USER_123")
        let cartWithItem1 = cartService.addItemToCart(cart: cart, productId: "PROD_1", quantity: 2, price: 29.99)
        let cartWithItem2 = cartService.addItemToCart(cart: cartWithItem1, productId: "PROD_2", quantity: 1, price: 79.99)
        let cartWithItems = cartService.addItemToCart(cart: cartWithItem2, productId: "PROD_3", quantity: 1, price: 299.99)
        
        let discountedCart = cartService.applyDiscount(cart: cartWithItems, discountCode: "SAVE10")
        let cartSummary = cartService.calculateCartSummary(cart: cartWithItems)
        
        let address = Address(street: "123 Main St", city: "New York", state: "NY", zipCode: "10001", country: "USA")
        let order = cartService.processCartCheckout(cart: cartWithItems, shippingAddress: address, paymentMethod: "credit_card")
        
        // Banking demonstrations - manual null handling instead of elegant 'let' chains
        let checkingAccount = bankingService.createAccount(accountNumber: "CHK001", accountType: "checking")
        let savingsAccount = bankingService.createAccount(accountNumber: "SAV001", accountType: "savings")
        
        let accountAfterDeposit = bankingService.processTransaction(account: checkingAccount, amount: 1000.0, type: "deposit")
        let accountAfterWithdrawal: BankAccount?
        if let deposited = accountAfterDeposit {
            accountAfterWithdrawal = bankingService.processTransaction(account: deposited, amount: 250.0, type: "withdrawal")
        } else {
            accountAfterWithdrawal = nil
        }
        
        let accountStatement: [String: Any]?
        if let withdrawn = accountAfterWithdrawal {
            accountStatement = bankingService.generateAccountStatement(account: withdrawn)
        } else {
            accountStatement = nil
        }
        
        let (fromAccount, toAccount) = bankingService.transferFunds(fromAccount: checkingAccount, toAccount: savingsAccount, amount: 500.0)
        
        // API service demonstrations - manual response handling
        let successResponse = apiService.createApiResponse(data: "Success data", statusCode: 200, errorMessage: nil)
        let errorResponse: ApiResponse<String> = apiService.createApiResponse(data: nil, statusCode: 404, errorMessage: "Not found")
        
        let processedSuccess = apiService.processApiResponse(response: successResponse)
        let processedError = apiService.processApiResponse(response: errorResponse)
        let errorMessage = apiService.handleApiError(response: errorResponse)
        
        // Configuration demonstrations - manual nested object creation
        let dbConfig = configService.createDatabaseConfig(host: "localhost", port: 5432, database: "myapp_db")
        let appConfig = configService.createAppConfig(appName: "MyApp", version: "1.0.0", environment: "production")
        let validationResult2 = configService.validateConfiguration(config: appConfig)
        let updatedConfig = configService.updateConfiguration(config: appConfig, updates: [
            "log_level": "INFO",
            "cache_ttl": "7200"
        ])
        
        // Complex processing chains - manual instead of Kotlin's elegant scope function chaining
        let usersToProcess = [
            User(id: "1", name: "Alice", email: "alice@test.com", age: 25),
            User(id: "2", name: "Bob", email: "bob@example.com", age: 35),
            User(id: "3", name: "Charlie", email: "charlie@company.org", age: 45)
        ]
        
        // Manual processing instead of elegant map + apply + filter + map + also chain
        var processedUsers: [[String: Any]] = []
        for user in usersToProcess {
            // Manual equivalent of 'apply'
            user.preferences = UserPreferences(theme: "dark", language: "en", notifications: true, newsletter: false)
            user.address = Address(street: "", city: "", state: "", zipCode: "", country: "USA")
            
            // Manual equivalent of 'filter'
            if user.email.contains("@") {
                // Manual equivalent of 'map'
                let summary = userService.getUserSummary(user: user)
                processedUsers.append(summary)
            }
        }
        
        // Manual side effects instead of 'also'
        for summary in processedUsers {
            // Log processing results
        }
        
        // Complex product processing chain - manual instead of elegant Kotlin chaining
        var productProcessingResults: [[String: Any]] = []
        for i in 1...10 {
            let prod = productService.createProduct(name: "Product \(i)", price: Double(i * 10), category: "Category\(i % 3)")
            
            // Manual price update instead of 'map' + optional chaining
            if let updatedProd = productService.updateProductPrice(product: prod, newPrice: prod.price * 0.9) {
                // Manual filtering instead of 'takeIf'
                if updatedProd.price > 50 {
                    let saleProduct = productService.configureProductForSale(product: updatedProd, discountPercent: 20.0)
                    let analysis = productService.analyzeProduct(product: saleProduct)
                    productProcessingResults.append(analysis)
                }
            }
        }
        
        // Manual side effects processing
        for analysis in productProcessingResults {
            // Process analysis results
        }
        
        // Complex cart and order processing - manual instead of Kotlin's elegant chains
        let userIds = ["USER_1", "USER_2", "USER_3"]
        var orderSummaries: [[String: Any]] = []
        
        for userId in userIds {
            let userCart = cartService.createCart(userId: userId)
            
            // Manual item addition - no elegant 'apply'
            for (index, product) in products.enumerated() {
                if index < 3 {
                    let _ = cartService.addItemToCart(cart: userCart, productId: product.id, quantity: 1, price: product.price)
                }
            }
            
            // Manual discount application with null handling
            if let discountedUserCart = cartService.applyDiscount(cart: userCart, discountCode: "SAVE15") {
                let summary = cartService.calculateCartSummary(cart: discountedUserCart)
                orderSummaries.append(summary)
            }
        }
        
        // Manual processing of summaries
        for summary in orderSummaries {
            // Process cart summaries
        }
        
        // Banking operation chains - manual instead of elegant Kotlin chains
        let accountData = [
            ("ACC001", "checking"),
            ("ACC002", "savings"),
            ("ACC003", "business")
        ]
        
        var bankingStatements: [[String: Any]] = []
        
        for (accNum, type) in accountData {
            let account = bankingService.createAccount(accountNumber: accNum, accountType: type)
            
            // Manual transaction chaining
            if let deposited = bankingService.processTransaction(account: account, amount: 1000.0, type: "deposit") {
                if let withdrawn = bankingService.processTransaction(account: deposited, amount: 100.0, type: "withdrawal") {
                    let statement = bankingService.generateAccountStatement(account: withdrawn)
                    bankingStatements.append(statement)
                }
            }
        }
        
        // Manual statement processing
        for statement in bankingStatements {
            // Process account statements
        }
        
        // API response processing chains - manual instead of Kotlin's elegant patterns
        let responseData = [
            (200, "Success"),
            (404, "Not Found"),
            (500, "Server Error")
        ]
        
        var apiResults: [String] = []
        
        for (status, message) in responseData {
            let response: ApiResponse<String>
            if status == 200 {
                response = apiService.createApiResponse(data: "Data", statusCode: status, errorMessage: nil)
            } else {
                response = apiService.createApiResponse(data: nil, statusCode: status, errorMessage: message)
            }
            
            // Manual success/error handling instead of elegant 'takeIf' + 'let' + 'run'
            if response.statusCode >= 200 && response.statusCode < 300 {
                if let data = apiService.processApiResponse(response: response) {
                    apiResults.append("Success: \(data)")
                } else {
                    apiResults.append("Error: No data")
                }
            } else {
                let errorMsg = apiService.handleApiError(response: response)
                apiResults.append("Error: \(errorMsg)")
            }
        }
        
        // Manual result processing
        for result in apiResults {
            // Process API results
        }
        
        // Configuration processing chains - manual validation and updates
        let configData = [
            ("App1", "development"),
            ("App2", "staging"),
            ("App3", "production")
        ]
        
        var finalConfigs: [AppConfig] = []
        
        for (name, env) in configData {
            let config = configService.createAppConfig(appName: name, version: "1.0.0", environment: env)
            let validation = configService.validateConfiguration(config: config)
            
            // Manual validation handling instead of elegant 'let' + conditional 'apply'
            if let isValid = validation["isValid"] as? Bool, isValid {
                // Configuration is valid, use as is
                finalConfigs.append(config)
            } else {
                // Fix configuration issues manually
                if config.appName.isEmpty {
                    config.appName = "DefaultApp"
                }
                if config.version.isEmpty {
                    config.version = "1.0.0"
                }
                finalConfigs.append(config)
            }
        }
        
        // Manual configuration updates
        for config in finalConfigs {
            let _ = configService.updateConfiguration(config: config, updates: [
                "log_level": "INFO",
                "timeout": "60000"
            ])
        }
        
        // Manual final config processing
        for config in finalConfigs {
            // Process final configurations
        }
        
        // Nested scope function equivalent - extremely verbose in Swift
        let userToProcess = user
        userToProcess.name = "Updated \(userToProcess.name)"
        userToProcess.email = userToProcess.email.lowercased()
        
        let validationMessage = userService.validateAndFormatUser(user: userToProcess)
        // Manual side effect logging
        
        let isLongMessage = validationMessage.count > 10
        let finalMessage = isLongMessage ? "Long validation message" : "Short validation message"
        
        // Error handling with manual null checks - no elegant scope function chaining
        var safeOperationResult: String = "Invalid user data"
        
        if user.age > 0 {
            if let address = user.address, !address.zipCode.isEmpty {
                safeOperationResult = "User \(user.name) has valid address in \(address.city)"
            } else {
                safeOperationResult = "User has invalid address"
            }
        }
        
        // Resource management patterns - manual instead of elegant scope function chains
        var resourceManagementResults: [String] = []
        
        if !products.isEmpty {
            for product in products {
                if product.inStock {
                    resourceManagementResults.append("Processing available product: \(product.name) (\(product.price))")
                } else {
                    resourceManagementResults.append("Product \(product.name) is out of stock")
                }
            }
        }
        
        // Manual logging of all processing messages
        for message in resourceManagementResults {
            // Log processing messages
        }
        
        // This demonstrates how much more verbose Swift becomes without Kotlin's scope functions
        // Every operation requires explicit null checking, manual state management, and verbose chaining
        // Kotlin's scope functions like let, run, apply, also, and takeIf provide much more elegant patterns
    }
}