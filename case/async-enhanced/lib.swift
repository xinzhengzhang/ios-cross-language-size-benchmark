/*
 * iOS Size Benchmark - Test Case Implementation
 * Generated with Claude AI (https://claude.ai)
 * 
 * This Swift implementation demonstrates language-specific
 * features and patterns for binary size comparison.
 */

import Foundation

// Swift async/await 真正异步实现

public actor UserDataStore {
    private var users: [Int: User] = [:]
    private var nextId = 1
    
    public func addUser(_ user: User) -> User {
        let userWithId = User(id: nextId, name: user.name, email: user.email, age: user.age)
        users[nextId] = userWithId
        nextId += 1
        return userWithId
    }
    
    public func getUser(id: Int) -> User? {
        return users[id]
    }
    
    public func getAllUsers() -> [User] {
        return Array(users.values)
    }
    
    public func updateUser(_ user: User) -> User? {
        guard users[user.id] != nil else { return nil }
        let updatedUser = User(id: user.id, name: "\(user.name)_updated", email: user.email, age: user.age)
        users[user.id] = updatedUser
        return updatedUser
    }
    
    public func deleteUser(id: Int) -> Bool {
        return users.removeValue(forKey: id) != nil
    }
}

public actor ProductInventory {
    private var products: [Int: Product] = [:]
    private var inventory: [Int: Int] = [:]
    private var nextId = 1
    
    public func addProduct(_ product: Product, quantity: Int = 100) -> Product {
        let productWithId = Product(id: nextId, name: product.name, price: product.price, category: product.category)
        products[nextId] = productWithId
        inventory[nextId] = quantity
        nextId += 1
        return productWithId
    }
    
    public func getProduct(id: Int) -> Product? {
        return products[id]
    }
    
    public func getAllProducts() -> [Product] {
        return Array(products.values)
    }
    
    public func checkInventory(productId: Int) -> Int {
        return inventory[productId] ?? 0
    }
    
    public func reserveInventory(productId: Int, quantity: Int) -> Bool {
        guard let currentStock = inventory[productId], currentStock >= quantity else {
            return false
        }
        inventory[productId] = currentStock - quantity
        return true
    }
    
    public func updateProduct(_ product: Product) -> Product? {
        guard products[product.id] != nil else { return nil }
        let updatedProduct = Product(id: product.id, name: product.name, price: product.price * 1.1, category: product.category)
        products[product.id] = updatedProduct
        return updatedProduct
    }
}

public struct User: Sendable, Identifiable, Hashable {
    public let id: Int
    public let name: String
    public let email: String
    public let age: Int
}

public struct Product: Sendable, Identifiable, Hashable {
    public let id: Int
    public let name: String
    public let price: Double
    public let category: String
}

public struct Order: Sendable, Identifiable {
    public let id: Int
    public let userId: Int
    public let products: [Product]
    public let total: Double
    public let timestamp: Date
}

public struct OrderRequest: Sendable {
    public let userId: Int
    public let productIds: [Int]
}

public struct ProductMetrics: Sendable {
    public let totalCount: Int
    public let averagePrice: Double
    public let categoryCount: Int
    public let priceRangeDistribution: [String: Int]
}

public enum WorkflowResult: Sendable {
    case success(WorkflowSuccess)
    case error(String)
    
    public struct WorkflowSuccess: Sendable {
        public let createdUser: User
        public let updatedUser: User
        public let retrievedUser: User?
        public let allUsersCount: Int
        public let searchResultsCount: Int
        public let deleteSuccess: Bool
    }
}

public enum OrderPipelineResult: Sendable {
    case success(Order)
    case error(String)
}

public enum OrderResult: Sendable {
    case success(Order)
    case failed(userId: Int, message: String)
}

public class AsyncUserService {
    private let dataStore = UserDataStore()
    
    public func createUser(name: String, email: String, age: Int) async throws -> User {
        // 模拟网络延迟
        try await Task.sleep(nanoseconds: 10_000_000) // 10ms
        let user = User(id: 0, name: name, email: email, age: age)
        return await dataStore.addUser(user)
    }
    
    public func updateUser(_ user: User) async throws -> User? {
        try await Task.sleep(nanoseconds: 5_000_000) // 5ms
        return await dataStore.updateUser(user)
    }
    
    public func deleteUser(userId: Int) async throws -> Bool {
        try await Task.sleep(nanoseconds: 5_000_000) // 5ms
        return await dataStore.deleteUser(id: userId)
    }
    
    public func getUserById(_ userId: Int) async throws -> User? {
        try await Task.sleep(nanoseconds: 10_000_000) // 10ms
        return await dataStore.getUser(id: userId)
    }
    
    public func getAllUsers() async throws -> [User] {
        try await Task.sleep(nanoseconds: 50_000_000) // 50ms
        return await dataStore.getAllUsers()
    }
    
    public func searchUsers(query: String) async throws -> [User] {
        let users = try await getAllUsers()
        try await Task.sleep(nanoseconds: 20_000_000) // 20ms
        return users.filter { $0.name.localizedCaseInsensitiveContains(query) }
    }
    
    public func batchCreateUsers(userRequests: [(name: String, email: String, age: Int)]) async throws -> [User] {
        // 并行创建多个用户
        return try await withThrowingTaskGroup(of: User.self) { group in
            for (name, email, age) in userRequests {
                group.addTask {
                    try await self.createUser(name: name, email: email, age: age)
                }
            }
            
            var users: [User] = []
            for try await user in group {
                users.append(user)
            }
            return users
        }
    }
    
    public func processUserWorkflow(userIndex: Int) async -> WorkflowResult {
        do {
            // 并行执行多个异步操作
            async let createTask = createUser(name: "User\(userIndex)", email: "user\(userIndex)@email.com", age: 25 + userIndex % 50)
            async let allUsersTask = getAllUsers()
            async let searchTask = searchUsers(query: "User")
            
            let (createdUser, allUsers, searchResults) = try await (createTask, allUsersTask, searchTask)
            
            // 串行执行依赖操作
            guard let updatedUser = try await updateUser(createdUser) else {
                return .error("Failed to update user")
            }
            
            let retrievedUser = try await getUserById(updatedUser.id)
            let deleteSuccess = try await deleteUser(userId: updatedUser.id)
            
            return .success(WorkflowResult.WorkflowSuccess(
                createdUser: createdUser,
                updatedUser: updatedUser,
                retrievedUser: retrievedUser,
                allUsersCount: allUsers.count,
                searchResultsCount: searchResults.count,
                deleteSuccess: deleteSuccess
            ))
        } catch {
            return .error(error.localizedDescription)
        }
    }
}

public class AsyncProductService {
    private let inventory = ProductInventory()
    
    public func createProduct(name: String, price: Double, category: String) async throws -> Product {
        try await Task.sleep(nanoseconds: 15_000_000) // 15ms
        let product = Product(id: 0, name: name, price: price, category: category)
        return await inventory.addProduct(product)
    }
    
    public func updateProduct(_ product: Product) async throws -> Product? {
        try await Task.sleep(nanoseconds: 8_000_000) // 8ms
        return await inventory.updateProduct(product)
    }
    
    public func getAllProducts() async throws -> [Product] {
        try await Task.sleep(nanoseconds: 60_000_000) // 60ms
        return await inventory.getAllProducts()
    }
    
    public func getProductsByCategory(_ category: String) async throws -> [Product] {
        let products = try await getAllProducts()
        try await Task.sleep(nanoseconds: 30_000_000) // 30ms
        return products.filter { $0.category == category }
    }
    
    public func getProductById(_ productId: Int) async throws -> Product? {
        try await Task.sleep(nanoseconds: 12_000_000) // 12ms
        return await inventory.getProduct(id: productId)
    }
    
    public func batchProcessProducts(productIds: [Int]) async throws -> [Int: Product?] {
        // 并发处理多个产品
        return try await withThrowingTaskGroup(of: (Int, Product?).self) { group in
            for id in productIds {
                group.addTask {
                    let product = try await self.getProductById(id)
                    return (id, product)
                }
            }
            
            var results: [Int: Product?] = [:]
            for try await (id, product) in group {
                results[id] = product
            }
            return results
        }
    }
    
    public func calculateProductMetrics(products: [Product]) async -> ProductMetrics {
        // CPU密集型计算使用Task.detached
        return await Task.detached {
            let averagePrice = products.map { $0.price }.reduce(0, +) / Double(products.count)
            let categoryGroups = Dictionary(grouping: products) { $0.category }
            let priceRanges = Dictionary(grouping: products) { product in
                switch product.price {
                case ..<50: return "Low"
                case 50..<100: return "Medium"
                default: return "High"
                }
            }
            
            return ProductMetrics(
                totalCount: products.count,
                averagePrice: averagePrice,
                categoryCount: categoryGroups.count,
                priceRangeDistribution: priceRanges.mapValues { $0.count }
            )
        }.value
    }
}

public class AsyncOrderService {
    private let productService = AsyncProductService()
    private var nextOrderId = 1
    
    public func createOrder(userId: Int, products: [Product]) async throws -> Order {
        try await Task.sleep(nanoseconds: 25_000_000) // 25ms
        let total = products.reduce(0) { $0 + $1.price }
        let order = Order(id: nextOrderId, userId: userId, products: products, total: total, timestamp: Date())
        nextOrderId += 1
        return order
    }
    
    public func processOrderPipeline(userId: Int, productIds: [Int]) async -> OrderPipelineResult {
        do {
            // 第一阶段：并行获取产品信息
            let products = try await withThrowingTaskGroup(of: Product?.self) { group in
                for id in productIds {
                    group.addTask {
                        try await self.productService.getProductById(id)
                    }
                }
                
                var validProducts: [Product] = []
                for try await product in group {
                    if let product = product {
                        validProducts.append(product)
                    }
                }
                return validProducts
            }
            
            if products.count != productIds.count {
                return .error("Some products not found")
            }
            
            // 第二阶段：验证库存（并行）
            let inventoryResults = try await withThrowingTaskGroup(of: Bool.self) { group in
                for product in products {
                    group.addTask {
                        try await self.checkInventory(productId: product.id)
                    }
                }
                
                var results: [Bool] = []
                for try await result in group {
                    results.append(result)
                }
                return results
            }
            
            if inventoryResults.contains(false) {
                return .error("Insufficient inventory")
            }
            
            // 第三阶段：创建订单和处理支付（串行）
            let order = try await createOrder(userId: userId, products: products)
            let paymentResult = try await processPayment(amount: order.total)
            
            if !paymentResult {
                return .error("Payment failed")
            }
            
            // 第四阶段：并行执行后续操作
            async let inventoryUpdate = updateInventory(products: products)
            async let notification = sendNotification(userId: userId, orderId: order.id)
            async let analytics = recordAnalytics(order: order)
            
            let (_, _, _) = try await (inventoryUpdate, notification, analytics)
            
            return .success(order)
        } catch {
            return .error(error.localizedDescription)
        }
    }
    
    public func batchProcessOrders(orderRequests: [OrderRequest]) async -> [OrderResult] {
        // 使用TaskGroup并限制并发数
        return await withTaskGroup(of: OrderResult.self) { group in
            let maxConcurrency = min(10, orderRequests.count)
            var requestIndex = 0
            var results: [OrderResult] = []
            
            // 启动初始任务
            for _ in 0..<maxConcurrency {
                if requestIndex < orderRequests.count {
                    let request = orderRequests[requestIndex]
                    requestIndex += 1
                    
                    group.addTask {
                        let result = await self.processOrderPipeline(userId: request.userId, productIds: request.productIds)
                        switch result {
                        case .success(let order):
                            return .success(order)
                        case .error(let message):
                            return .failed(userId: request.userId, message: message)
                        }
                    }
                }
            }
            
            // 处理完成的任务并启动新任务
            for await result in group {
                results.append(result)
                
                if requestIndex < orderRequests.count {
                    let request = orderRequests[requestIndex]
                    requestIndex += 1
                    
                    group.addTask {
                        let result = await self.processOrderPipeline(userId: request.userId, productIds: request.productIds)
                        switch result {
                        case .success(let order):
                            return .success(order)
                        case .error(let message):
                            return .failed(userId: request.userId, message: message)
                        }
                    }
                }
            }
            
            return results
        }
    }
    
    private func checkInventory(productId: Int) async throws -> Bool {
        try await Task.sleep(nanoseconds: 10_000_000) // 10ms
        return productId % 10 != 0 // 模拟库存检查
    }
    
    private func processPayment(amount: Double) async throws -> Bool {
        try await Task.sleep(nanoseconds: 100_000_000) // 100ms 支付处理较慢
        return amount > 0
    }
    
    private func updateInventory(products: [Product]) async throws -> Bool {
        try await Task.sleep(nanoseconds: 20_000_000) // 20ms
        return true
    }
    
    private func sendNotification(userId: Int, orderId: Int) async throws -> Bool {
        try await Task.sleep(nanoseconds: 15_000_000) // 15ms
        return true
    }
    
    private func recordAnalytics(order: Order) async throws -> Bool {
        try await Task.sleep(nanoseconds: 5_000_000) // 5ms
        return true
    }
}

public class AsyncBenchmarkService {
    private let userService = AsyncUserService()
    private let productService = AsyncProductService()
    private let orderService = AsyncOrderService()
    
    public func runComplexAsyncWorkflow(iterations: Int) async {
        print("Starting complex async workflow with \(iterations) iterations...")
        
        do {
            // 第一阶段：并行用户工作流
            let userResults = try await withThrowingTaskGroup(of: WorkflowResult.self) { group in
                for index in 1...iterations {
                    group.addTask {
                        await self.userService.processUserWorkflow(userIndex: index)
                    }
                }
                
                var results: [WorkflowResult] = []
                for try await result in group {
                    results.append(result)
                }
                return results
            }
            
            let successfulUsers = userResults.compactMap { result in
                if case .success(let success) = result { return success }
                return nil
            }
            
            print("User workflows completed: \(successfulUsers.count)/\(userResults.count) successful")
            
            // 第二阶段：产品批处理和指标计算
            let productIds = Array(1...100)
            async let productBatch = productService.batchProcessProducts(productIds: productIds)
            
            let products = try await productBatch.values.compactMap { $0 }
            let metrics = await productService.calculateProductMetrics(products: products)
            
            // 第三阶段：批量订单处理
            let orderRequests = successfulUsers.prefix(20).enumerated().map { index, userResult in
                OrderRequest(
                    userId: userResult.createdUser.id,
                    productIds: Array(productIds.prefix(3 + index % 5))
                )
            }
            
            let orderResults = await orderService.batchProcessOrders(orderRequests: Array(orderRequests))
            let successfulOrders = orderResults.compactMap { result in
                if case .success(let order) = result { return order }
                return nil
            }
            
            print("Async workflow completed:")
            print("- User workflows: \(successfulUsers.count)")
            print("- Products processed: \(products.count)")
            print("- Average product price: \(metrics.averagePrice)")
            print("- Orders processed: \(successfulOrders.count)/\(orderResults.count)")
            print("- Total revenue: \(successfulOrders.reduce(0) { $0 + $1.total })")
            
        } catch {
            print("Workflow failed with error: \(error)")
        }
    }
    
    public func runConcurrentStressTest(concurrencyLevel: Int, operations: Int) async {
        print("Starting concurrent stress test: \(concurrencyLevel) concurrent workers, \(operations) operations each")
        
        let results = await withTaskGroup(of: String.self) { group in
            for workerId in 1...concurrencyLevel {
                group.addTask {
                    var successCount = 0
                    var errorCount = 0
                    
                    for opIndex in 0..<operations {
                        do {
                            switch opIndex % 4 {
                            case 0:
                                let user = try await self.userService.createUser(name: "Worker\(workerId)_User\(opIndex)", email: "email\(opIndex)@test.com", age: 25)
                                _ = try await self.userService.updateUser(user)
                                successCount += 1
                            case 1:
                                let product = try await self.productService.createProduct(name: "Product\(opIndex)", price: 99.99, category: "Category\(opIndex % 5)")
                                _ = try await self.productService.updateProduct(product)
                                successCount += 1
                            case 2:
                                _ = try await self.productService.getProductsByCategory("Category\(opIndex % 5)")
                                successCount += 1
                            case 3:
                                _ = try await self.userService.searchUsers(query: "User")
                                successCount += 1
                            default:
                                break
                            }
                        } catch {
                            errorCount += 1
                        }
                    }
                    
                    return "Worker \(workerId): \(successCount) successes, \(errorCount) errors"
                }
            }
            
            var allResults: [String] = []
            for await result in group {
                allResults.append(result)
            }
            return allResults
        }
        
        results.forEach { print($0) }
        
        let totalSuccess = results.compactMap { result in
            let components = result.components(separatedBy: ": ")[1].components(separatedBy: " ")
            return Int(components[0])
        }.reduce(0, +)
        
        let totalErrors = results.compactMap { result in
            let components = result.components(separatedBy: "successes, ")[1].components(separatedBy: " ")
            return Int(components[0])
        }.reduce(0, +)
        
        print("Stress test completed: \(totalSuccess) successes, \(totalErrors) errors")
    }
}

public class IosSizeBenchmark {
    private let benchmarkService = AsyncBenchmarkService()
    
    public func runBenchmark() {
        Task {
            await benchmarkService.runComplexAsyncWorkflow(iterations: 50)
            await benchmarkService.runConcurrentStressTest(concurrencyLevel: 10, operations: 20)
        }
    }
}