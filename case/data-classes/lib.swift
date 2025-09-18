/*
 * iOS Size Benchmark - Test Case Implementation
 * Generated with Claude AI (https://claude.ai)
 * 
 * This Swift implementation demonstrates language-specific
 * features and patterns for binary size comparison.
 */

import Foundation

// Test case: Data Classes - Swift equivalent requiring manual implementation of all functionality

// Simple data structures - Swift can auto-generate Equatable and Hashable for simple structs
public struct Person: Equatable, Hashable {
    public let id: String
    public let firstName: String
    public let lastName: String
    public let age: Int
    public let email: String
    
    // Manual computed properties
    public var fullName: String {
        return "\(firstName) \(lastName)"
    }
    
    public var isAdult: Bool {
        return age >= 18
    }
    
    // Swift auto-generates == and hash(into:) for structs with Equatable/Hashable stored properties
    
    // Manual description/toString implementation
    public var stringDescription: String {
        return "Person(id: \(id), firstName: \(firstName), lastName: \(lastName), age: \(age), email: \(email))"
    }
    
    // Manual copy function implementation
    public func copy(id: String? = nil, firstName: String? = nil, lastName: String? = nil, age: Int? = nil, email: String? = nil) -> Person {
        return Person(
            id: id ?? self.id,
            firstName: firstName ?? self.firstName,
            lastName: lastName ?? self.lastName,
            age: age ?? self.age,
            email: email ?? self.email
        )
    }
}

public struct Address: Equatable, Hashable {
    public let street: String
    public let city: String
    public let state: String
    public let zipCode: String
    public let country: String
    
    public var shortAddress: String {
        return "\(city), \(state)"
    }
    
    public var isUSA: Bool {
        return country.lowercased() == "usa"
    }
    
    // Swift auto-generates Equatable and Hashable implementations
    
    // Manual description implementation
    public var stringDescription: String {
        return "Address(street: \(street), city: \(city), state: \(state), zipCode: \(zipCode), country: \(country))"
    }
    
    // Manual copy function
    public func copy(street: String? = nil, city: String? = nil, state: String? = nil, zipCode: String? = nil, country: String? = nil) -> Address {
        return Address(
            street: street ?? self.street,
            city: city ?? self.city,
            state: state ?? self.state,
            zipCode: zipCode ?? self.zipCode,
            country: country ?? self.country
        )
    }
}

public struct ContactInfo: Equatable, Hashable {
    public let primaryEmail: String
    public let secondaryEmail: String?
    public let phoneNumber: String?
    public let address: Address?
    
    public var hasMultipleEmails: Bool {
        return secondaryEmail != nil
    }
    
    public var hasCompleteInfo: Bool {
        return phoneNumber != nil && address != nil
    }
    
    // Swift auto-generates Equatable and Hashable implementations
    
    // Manual description implementation
    public var stringDescription: String {
        return "ContactInfo(primaryEmail: \(primaryEmail), secondaryEmail: \(String(describing: secondaryEmail)), phoneNumber: \(String(describing: phoneNumber)), address: \(String(describing: address)))"
    }
    
    // Manual copy function
    public func copy(primaryEmail: String? = nil, secondaryEmail: String?? = nil, phoneNumber: String?? = nil, address: Address?? = nil) -> ContactInfo {
        return ContactInfo(
            primaryEmail: primaryEmail ?? self.primaryEmail,
            secondaryEmail: secondaryEmail ?? self.secondaryEmail,
            phoneNumber: phoneNumber ?? self.phoneNumber,
            address: address ?? self.address
        )
    }
}

// Complex nested data structures - Swift can auto-generate these too
public struct Employee: Equatable, Hashable {
    public let id: String
    public let person: Person
    public let contactInfo: ContactInfo
    public let department: String
    public let position: String
    public let salary: Double
    public let startDate: String
    public let manager: String?
    public let isActive: Bool
    
    public var displayName: String {
        return "\(person.fullName) (\(department))"
    }
    
    public var isManager: Bool {
        return manager == nil
    }
    
    public var yearsOfService: Int {
        let currentYear = 2024
        if let year = Int(String(startDate.prefix(4))) {
            return currentYear - year
        }
        return 0
    }
    
    // Swift auto-generates Equatable and Hashable implementations
    
    // Manual description implementation
    public var stringDescription: String {
        return "Employee(id: \(id), person: \(person.stringDescription), contactInfo: \(contactInfo.stringDescription), department: \(department), position: \(position), salary: \(salary), startDate: \(startDate), manager: \(String(describing: manager)), isActive: \(isActive))"
    }
    
    // Manual copy function
    public func copy(id: String? = nil, person: Person? = nil, contactInfo: ContactInfo? = nil, department: String? = nil, position: String? = nil, salary: Double? = nil, startDate: String? = nil, manager: String?? = nil, isActive: Bool? = nil) -> Employee {
        return Employee(
            id: id ?? self.id,
            person: person ?? self.person,
            contactInfo: contactInfo ?? self.contactInfo,
            department: department ?? self.department,
            position: position ?? self.position,
            salary: salary ?? self.salary,
            startDate: startDate ?? self.startDate,
            manager: manager ?? self.manager,
            isActive: isActive ?? self.isActive
        )
    }
}

public struct Department: Equatable, Hashable {
    public let id: String
    public let name: String
    public let departmentDescription: String
    public let budget: Double
    public let manager: Employee
    public let employees: [Employee]
    
    public var totalSalaryBudget: Double {
        return employees.reduce(0) { $0 + $1.salary }
    }
    
    public var employeeCount: Int {
        return employees.count
    }
    
    public var averageSalary: Double {
        return employees.isEmpty ? 0.0 : totalSalaryBudget / Double(employees.count)
    }
    
    // Swift auto-generates Equatable and Hashable implementations for arrays too
    
    // Manual description implementation
    public var stringDescription: String {
        let employeesDesc = employees.map { $0.stringDescription }.joined(separator: ", ")
        return "Department(id: \(id), name: \(name), description: \(departmentDescription), budget: \(budget), manager: \(manager.stringDescription), employees: [\(employeesDesc)])"
    }
    
    // Manual copy function
    public func copy(id: String? = nil, name: String? = nil, departmentDescription: String? = nil, budget: Double? = nil, manager: Employee? = nil, employees: [Employee]? = nil) -> Department {
        return Department(
            id: id ?? self.id,
            name: name ?? self.name,
            departmentDescription: departmentDescription ?? self.departmentDescription,
            budget: budget ?? self.budget,
            manager: manager ?? self.manager,
            employees: employees ?? self.employees
        )
    }
}

// Financial data structures - auto-generated implementations
public struct Transaction: Equatable, Hashable {
    public let id: String
    public let amount: Double
    public let currency: String
    public let timestamp: Int64
    public let description: String
    public let category: String
    public let tags: [String]
    
    public var isExpense: Bool {
        return amount < 0
    }
    
    public var isIncome: Bool {
        return amount > 0
    }
    
    public var formattedAmount: String {
        let prefix = amount >= 0 ? "+" : ""
        return "\(prefix)\(String(format: "%.2f", amount)) \(currency)"
    }
    
    // Swift auto-generates Equatable and Hashable implementations
    
    // Manual description implementation
    public var stringDescription: String {
        return "Transaction(id: \(id), amount: \(amount), currency: \(currency), timestamp: \(timestamp), description: \(description), category: \(category), tags: \(tags))"
    }
    
    // Manual copy function
    public func copy(id: String? = nil, amount: Double? = nil, currency: String? = nil, timestamp: Int64? = nil, description: String? = nil, category: String? = nil, tags: [String]? = nil) -> Transaction {
        return Transaction(
            id: id ?? self.id,
            amount: amount ?? self.amount,
            currency: currency ?? self.currency,
            timestamp: timestamp ?? self.timestamp,
            description: description ?? self.description,
            category: category ?? self.category,
            tags: tags ?? self.tags
        )
    }
}

// E-commerce data structures - auto-generated implementations
public struct Product: Equatable, Hashable {
    public let id: String
    public let name: String
    public let description: String
    public let price: Double
    public let currency: String
    public let category: String
    public let tags: [String]
    public let inStock: Bool
    public let stockQuantity: Int
    
    public var isAvailable: Bool {
        return inStock && stockQuantity > 0
    }
    
    public var formattedPrice: String {
        return String(format: "%.2f %@", price, currency)
    }
    
    public var isOnSale: Bool {
        return tags.contains("sale")
    }
    
    // Swift auto-generates Equatable and Hashable implementations
    
    // Manual description implementation
    public var stringDescription: String {
        return "Product(id: \(id), name: \(name), description: \(description), price: \(price), currency: \(currency), category: \(category), tags: \(tags), inStock: \(inStock), stockQuantity: \(stockQuantity))"
    }
    
    // Manual copy function
    public func copy(id: String? = nil, name: String? = nil, description: String? = nil, price: Double? = nil, currency: String? = nil, category: String? = nil, tags: [String]? = nil, inStock: Bool? = nil, stockQuantity: Int? = nil) -> Product {
        return Product(
            id: id ?? self.id,
            name: name ?? self.name,
            description: description ?? self.description,
            price: price ?? self.price,
            currency: currency ?? self.currency,
            category: category ?? self.category,
            tags: tags ?? self.tags,
            inStock: inStock ?? self.inStock,
            stockQuantity: stockQuantity ?? self.stockQuantity
        )
    }
}

// Financial data structures - auto-generated implementations
public struct Account: Equatable, Hashable {
    public let id: String
    public let accountNumber: String
    public let accountType: String
    public let balance: Double
    public let currency: String
    public let owner: Person
    public let transactions: [Transaction]
    
    public var totalIncome: Double {
        return transactions.filter { $0.isIncome }.reduce(0) { $0 + $1.amount }
    }
    
    public var totalExpenses: Double {
        return transactions.filter { $0.isExpense }.reduce(0) { $0 + $1.amount }
    }
    
    public var transactionCount: Int {
        return transactions.count
    }
    
    // Swift auto-generates Equatable and Hashable implementations
    
    // Manual description implementation
    public var stringDescription: String {
        return "Account(id: \(id), accountNumber: \(accountNumber), accountType: \(accountType), balance: \(balance), currency: \(currency), owner: \(owner.stringDescription), transactionCount: \(transactionCount))"
    }
    
    // Manual copy function
    public func copy(id: String? = nil, accountNumber: String? = nil, accountType: String? = nil, balance: Double? = nil, currency: String? = nil, owner: Person? = nil, transactions: [Transaction]? = nil) -> Account {
        return Account(
            id: id ?? self.id,
            accountNumber: accountNumber ?? self.accountNumber,
            accountType: accountType ?? self.accountType,
            balance: balance ?? self.balance,
            currency: currency ?? self.currency,
            owner: owner ?? self.owner,
            transactions: transactions ?? self.transactions
        )
    }
}

public struct Budget: Equatable, Hashable {
    public let id: String
    public let name: String
    public let totalAmount: Double
    public let currency: String
    public let categories: [String: Double]
    public let period: String
    public let owner: Person
    
    public var allocatedAmount: Double {
        return categories.values.reduce(0, +)
    }
    
    public var remainingAmount: Double {
        return totalAmount - allocatedAmount
    }
    
    public var isOverBudget: Bool {
        return allocatedAmount > totalAmount
    }
    
    // Swift auto-generates Equatable and Hashable implementations
    
    // Manual description implementation
    public var stringDescription: String {
        return "Budget(id: \(id), name: \(name), totalAmount: \(totalAmount), currency: \(currency), period: \(period), allocatedAmount: \(allocatedAmount), isOverBudget: \(isOverBudget))"
    }
    
    // Manual copy function
    public func copy(id: String? = nil, name: String? = nil, totalAmount: Double? = nil, currency: String? = nil, categories: [String: Double]? = nil, period: String? = nil, owner: Person? = nil) -> Budget {
        return Budget(
            id: id ?? self.id,
            name: name ?? self.name,
            totalAmount: totalAmount ?? self.totalAmount,
            currency: currency ?? self.currency,
            categories: categories ?? self.categories,
            period: period ?? self.period,
            owner: owner ?? self.owner
        )
    }
}

// E-commerce data structures - auto-generated implementations
public struct CartItem: Equatable, Hashable {
    public let product: Product
    public let quantity: Int
    public let selectedVariant: String?
    
    public var totalPrice: Double {
        return product.price * Double(quantity)
    }
    
    public var isValidQuantity: Bool {
        return quantity > 0 && quantity <= product.stockQuantity
    }
    
    // Swift auto-generates Equatable and Hashable implementations
    
    // Manual description implementation
    public var stringDescription: String {
        return "CartItem(product: \(product.stringDescription), quantity: \(quantity), selectedVariant: \(String(describing: selectedVariant)), totalPrice: \(totalPrice))"
    }
    
    // Manual copy function
    public func copy(product: Product? = nil, quantity: Int? = nil, selectedVariant: String?? = nil) -> CartItem {
        return CartItem(
            product: product ?? self.product,
            quantity: quantity ?? self.quantity,
            selectedVariant: selectedVariant ?? self.selectedVariant
        )
    }
}

public struct ShoppingCart: Equatable, Hashable {
    public let id: String
    public let userId: String
    public let items: [CartItem]
    public let discountCode: String?
    public let discountAmount: Double
    
    public var subtotal: Double {
        return items.reduce(0) { $0 + $1.totalPrice }
    }
    
    public var total: Double {
        return subtotal - discountAmount
    }
    
    public var itemCount: Int {
        return items.reduce(0) { $0 + $1.quantity }
    }
    
    public var hasDiscount: Bool {
        return discountCode != nil && discountAmount > 0
    }
    
    // Swift auto-generates Equatable and Hashable implementations
    
    // Manual description implementation
    public var stringDescription: String {
        return "ShoppingCart(id: \(id), userId: \(userId), itemCount: \(itemCount), subtotal: \(subtotal), total: \(total), hasDiscount: \(hasDiscount))"
    }
    
    // Manual copy function
    public func copy(id: String? = nil, userId: String? = nil, items: [CartItem]? = nil, discountCode: String?? = nil, discountAmount: Double? = nil) -> ShoppingCart {
        return ShoppingCart(
            id: id ?? self.id,
            userId: userId ?? self.userId,
            items: items ?? self.items,
            discountCode: discountCode ?? self.discountCode,
            discountAmount: discountAmount ?? self.discountAmount
        )
    }
}

public struct Order: Equatable, Hashable {
    public let id: String
    public let userId: String
    public let cart: ShoppingCart
    public let shippingAddress: Address
    public let billingAddress: Address
    public let paymentMethod: String
    public let orderDate: String
    public let status: String
    
    public var orderTotal: Double {
        return cart.total
    }
    
    public var isShipped: Bool {
        return ["shipped", "delivered"].contains(status)
    }
    
    public var isCompleted: Bool {
        return status == "delivered"
    }
    
    public var itemSummary: String {
        return "\(cart.itemCount) items totaling \(cart.total)"
    }
    
    // Swift auto-generates Equatable and Hashable implementations
    
    // Manual description implementation
    public var stringDescription: String {
        return "Order(id: \(id), userId: \(userId), orderTotal: \(orderTotal), status: \(status), itemSummary: \(itemSummary))"
    }
    
    // Manual copy function
    public func copy(id: String? = nil, userId: String? = nil, cart: ShoppingCart? = nil, shippingAddress: Address? = nil, billingAddress: Address? = nil, paymentMethod: String? = nil, orderDate: String? = nil, status: String? = nil) -> Order {
        return Order(
            id: id ?? self.id,
            userId: userId ?? self.userId,
            cart: cart ?? self.cart,
            shippingAddress: shippingAddress ?? self.shippingAddress,
            billingAddress: billingAddress ?? self.billingAddress,
            paymentMethod: paymentMethod ?? self.paymentMethod,
            orderDate: orderDate ?? self.orderDate,
            status: status ?? self.status
        )
    }
}

// Company data structures - auto-generated implementations
public struct Company: Equatable, Hashable {
    public let id: String
    public let name: String
    public let headquarters: Address
    public let departments: [Department]
    public let foundedYear: Int
    public let website: String?
    
    public var totalEmployees: Int {
        return departments.reduce(0) { $0 + $1.employeeCount }
    }
    
    public var totalBudget: Double {
        return departments.reduce(0) { $0 + $1.budget }
    }
    
    public var companyAge: Int {
        return 2024 - foundedYear
    }
    
    // Swift auto-generates Equatable and Hashable implementations
    
    // Manual description implementation
    public var stringDescription: String {
        return "Company(id: \(id), name: \(name), totalEmployees: \(totalEmployees), totalBudget: \(totalBudget), companyAge: \(companyAge))"
    }
    
    // Manual copy function
    public func copy(id: String? = nil, name: String? = nil, headquarters: Address? = nil, departments: [Department]? = nil, foundedYear: Int? = nil, website: String?? = nil) -> Company {
        return Company(
            id: id ?? self.id,
            name: name ?? self.name,
            headquarters: headquarters ?? self.headquarters,
            departments: departments ?? self.departments,
            foundedYear: foundedYear ?? self.foundedYear,
            website: website ?? self.website
        )
    }
}

// Gaming/Entertainment data structures - auto-generated implementations
public struct Player: Equatable, Hashable {
    public let id: String
    public let username: String
    public let email: String
    public let level: Int
    public let experience: Int
    public let achievements: [String]
    public let joinDate: String
    
    public var experienceToNextLevel: Int {
        return ((level + 1) * 1000) - experience
    }
    
    public var achievementCount: Int {
        return achievements.count
    }
    
    public var isVeteran: Bool {
        return achievements.contains("veteran")
    }
    
    // Swift auto-generates Equatable and Hashable implementations
    
    // Manual description implementation
    public var stringDescription: String {
        return "Player(id: \(id), username: \(username), level: \(level), experience: \(experience), achievementCount: \(achievementCount))"
    }
    
    // Manual copy function
    public func copy(id: String? = nil, username: String? = nil, email: String? = nil, level: Int? = nil, experience: Int? = nil, achievements: [String]? = nil, joinDate: String? = nil) -> Player {
        return Player(
            id: id ?? self.id,
            username: username ?? self.username,
            email: email ?? self.email,
            level: level ?? self.level,
            experience: experience ?? self.experience,
            achievements: achievements ?? self.achievements,
            joinDate: joinDate ?? self.joinDate
        )
    }
}

public struct GameSession: Equatable, Hashable {
    public let id: String
    public let player: Player
    public let gameMode: String
    public let score: Int
    public let duration: Int64
    public let timestamp: Int64
    public let achievements: [String]
    
    public var scorePerMinute: Double {
        return duration > 0 ? Double(score) / (Double(duration) / 60000.0) : 0.0
    }
    
    public var hasNewAchievements: Bool {
        return !achievements.isEmpty
    }
    
    public var durationInMinutes: Int64 {
        return duration / 60000
    }
    
    // Swift auto-generates Equatable and Hashable implementations
    
    // Manual description implementation
    public var stringDescription: String {
        return "GameSession(id: \(id), gameMode: \(gameMode), score: \(score), durationInMinutes: \(durationInMinutes), hasNewAchievements: \(hasNewAchievements))"
    }
    
    // Manual copy function
    public func copy(id: String? = nil, player: Player? = nil, gameMode: String? = nil, score: Int? = nil, duration: Int64? = nil, timestamp: Int64? = nil, achievements: [String]? = nil) -> GameSession {
        return GameSession(
            id: id ?? self.id,
            player: player ?? self.player,
            gameMode: gameMode ?? self.gameMode,
            score: score ?? self.score,
            duration: duration ?? self.duration,
            timestamp: timestamp ?? self.timestamp,
            achievements: achievements ?? self.achievements
        )
    }
}

public struct LeaderboardEntry: Equatable, Hashable {
    public let rank: Int
    public let player: Player
    public let score: Int
    public let gamesPlayed: Int
    
    public var averageScorePerGame: Double {
        return gamesPlayed > 0 ? Double(score) / Double(gamesPlayed) : 0.0
    }
    
    public var isTopTen: Bool {
        return rank <= 10
    }
    
    // Swift auto-generates Equatable and Hashable implementations
    
    // Manual description implementation
    public var stringDescription: String {
        return "LeaderboardEntry(rank: \(rank), score: \(score), gamesPlayed: \(gamesPlayed), averageScorePerGame: \(averageScorePerGame))"
    }
    
    // Manual copy function
    public func copy(rank: Int? = nil, player: Player? = nil, score: Int? = nil, gamesPlayed: Int? = nil) -> LeaderboardEntry {
        return LeaderboardEntry(
            rank: rank ?? self.rank,
            player: player ?? self.player,
            score: score ?? self.score,
            gamesPlayed: gamesPlayed ?? self.gamesPlayed
        )
    }
}

public struct Leaderboard: Equatable, Hashable {
    public let gameMode: String
    public let period: String
    public let entries: [LeaderboardEntry]
    public let lastUpdated: Int64
    
    public var topPlayer: LeaderboardEntry? {
        return entries.first
    }
    
    public var entryCount: Int {
        return entries.count
    }
    
    public var averageScore: Double {
        return entries.isEmpty ? 0.0 : Double(entries.reduce(0) { $0 + $1.score }) / Double(entries.count)
    }
    
    // Swift auto-generates Equatable and Hashable implementations
    
    // Manual description implementation
    public var stringDescription: String {
        return "Leaderboard(gameMode: \(gameMode), period: \(period), entryCount: \(entryCount), averageScore: \(averageScore))"
    }
    
    // Manual copy function
    public func copy(gameMode: String? = nil, period: String? = nil, entries: [LeaderboardEntry]? = nil, lastUpdated: Int64? = nil) -> Leaderboard {
        return Leaderboard(
            gameMode: gameMode ?? self.gameMode,
            period: period ?? self.period,
            entries: entries ?? self.entries,
            lastUpdated: lastUpdated ?? self.lastUpdated
        )
    }
}

// Social media data structures - auto-generated implementations
public struct Comment: Equatable, Hashable {
    public let id: String
    public let author: Person
    public let content: String
    public let timestamp: Int64
    public let likes: Int
    public let replies: [Comment]
    
    public var hasReplies: Bool {
        return !replies.isEmpty
    }
    
    public var totalReplies: Int {
        return replies.count + replies.reduce(0) { $0 + $1.totalReplies }
    }
    
    // Swift auto-generates Equatable and Hashable implementations
    
    // Manual description implementation
    public var stringDescription: String {
        return "Comment(id: \(id), content: \(content), likes: \(likes), hasReplies: \(hasReplies), totalReplies: \(totalReplies))"
    }
    
    // Manual copy function
    public func copy(id: String? = nil, author: Person? = nil, content: String? = nil, timestamp: Int64? = nil, likes: Int? = nil, replies: [Comment]? = nil) -> Comment {
        return Comment(
            id: id ?? self.id,
            author: author ?? self.author,
            content: content ?? self.content,
            timestamp: timestamp ?? self.timestamp,
            likes: likes ?? self.likes,
            replies: replies ?? self.replies
        )
    }
}

public struct Post: Equatable, Hashable {
    public let id: String
    public let author: Person
    public let content: String
    public let timestamp: Int64
    public let likes: Int
    public let comments: [Comment]
    public let tags: [String]
    public let isPublic: Bool
    
    public var commentCount: Int {
        return comments.count
    }
    
    public var hasHashtags: Bool {
        return !tags.isEmpty
    }
    
    public var isPopular: Bool {
        return likes > 100 || comments.count > 50
    }
    
    // Swift auto-generates Equatable and Hashable implementations
    
    // Manual description implementation
    public var stringDescription: String {
        return "Post(id: \(id), content: \(content), likes: \(likes), commentCount: \(commentCount), isPopular: \(isPopular))"
    }
    
    // Manual copy function
    public func copy(id: String? = nil, author: Person? = nil, content: String? = nil, timestamp: Int64? = nil, likes: Int? = nil, comments: [Comment]? = nil, tags: [String]? = nil, isPublic: Bool? = nil) -> Post {
        return Post(
            id: id ?? self.id,
            author: author ?? self.author,
            content: content ?? self.content,
            timestamp: timestamp ?? self.timestamp,
            likes: likes ?? self.likes,
            comments: comments ?? self.comments,
            tags: tags ?? self.tags,
            isPublic: isPublic ?? self.isPublic
        )
    }
}

public struct UserProfile: Equatable, Hashable {
    public let person: Person
    public let bio: String
    public let profilePicture: String?
    public let followers: [String]
    public let following: [String]
    public let posts: [Post]
    
    public var followerCount: Int {
        return followers.count
    }
    
    public var followingCount: Int {
        return following.count
    }
    
    public var postCount: Int {
        return posts.count
    }
    
    public var totalLikes: Int {
        return posts.reduce(0) { $0 + $1.likes }
    }
    
    public var isVerified: Bool {
        return followerCount > 10000
    }
    
    // Swift auto-generates Equatable and Hashable implementations
    
    // Manual description implementation
    public var stringDescription: String {
        return "UserProfile(person: \(person.fullName), followerCount: \(followerCount), followingCount: \(followingCount), postCount: \(postCount), totalLikes: \(totalLikes), isVerified: \(isVerified))"
    }
    
    // Manual copy function
    public func copy(person: Person? = nil, bio: String? = nil, profilePicture: String?? = nil, followers: [String]? = nil, following: [String]? = nil, posts: [Post]? = nil) -> UserProfile {
        return UserProfile(
            person: person ?? self.person,
            bio: bio ?? self.bio,
            profilePicture: profilePicture ?? self.profilePicture,
            followers: followers ?? self.followers,
            following: following ?? self.following,
            posts: posts ?? self.posts
        )
    }
}

// Configuration and settings data structures - auto-generated implementations
public struct NotificationSettings: Equatable, Hashable {
    public let emailNotifications: Bool
    public let pushNotifications: Bool
    public let smsNotifications: Bool
    public let marketingEmails: Bool
    public let securityAlerts: Bool
    
    public var hasAnyNotificationsEnabled: Bool {
        return emailNotifications || pushNotifications || smsNotifications || marketingEmails || securityAlerts
    }
    
    public var notificationCount: Int {
        return [emailNotifications, pushNotifications, smsNotifications, marketingEmails, securityAlerts].filter { $0 }.count
    }
    
    // Swift auto-generates Equatable and Hashable implementations
    
    // Manual description implementation
    public var stringDescription: String {
        return "NotificationSettings(hasAnyEnabled: \(hasAnyNotificationsEnabled), notificationCount: \(notificationCount))"
    }
    
    // Manual copy function
    public func copy(emailNotifications: Bool? = nil, pushNotifications: Bool? = nil, smsNotifications: Bool? = nil, marketingEmails: Bool? = nil, securityAlerts: Bool? = nil) -> NotificationSettings {
        return NotificationSettings(
            emailNotifications: emailNotifications ?? self.emailNotifications,
            pushNotifications: pushNotifications ?? self.pushNotifications,
            smsNotifications: smsNotifications ?? self.smsNotifications,
            marketingEmails: marketingEmails ?? self.marketingEmails,
            securityAlerts: securityAlerts ?? self.securityAlerts
        )
    }
}

public struct PrivacySettings: Equatable, Hashable {
    public let profileVisibility: String
    public let dataSharing: Bool
    public let analytics: Bool
    public let advertising: Bool
    public let locationTracking: Bool
    
    public var isPrivacyFocused: Bool {
        return !dataSharing && !analytics && !advertising && !locationTracking
    }
    
    public var privacyScore: Int {
        return [dataSharing, analytics, advertising, locationTracking].filter { !$0 }.count
    }
    
    // Swift auto-generates Equatable and Hashable implementations
    
    // Manual description implementation
    public var stringDescription: String {
        return "PrivacySettings(profileVisibility: \(profileVisibility), isPrivacyFocused: \(isPrivacyFocused), privacyScore: \(privacyScore))"
    }
    
    // Manual copy function
    public func copy(profileVisibility: String? = nil, dataSharing: Bool? = nil, analytics: Bool? = nil, advertising: Bool? = nil, locationTracking: Bool? = nil) -> PrivacySettings {
        return PrivacySettings(
            profileVisibility: profileVisibility ?? self.profileVisibility,
            dataSharing: dataSharing ?? self.dataSharing,
            analytics: analytics ?? self.analytics,
            advertising: advertising ?? self.advertising,
            locationTracking: locationTracking ?? self.locationTracking
        )
    }
}

public struct DisplaySettings: Equatable, Hashable {
    public let fontSize: String
    public let colorScheme: String
    public let animation: Bool
    public let autoPlay: Bool
    public let highContrast: Bool
    
    public var isAccessibilityFriendly: Bool {
        return ["large", "extra-large"].contains(fontSize) || highContrast
    }
    
    public var isPerformanceOptimized: Bool {
        return !animation && !autoPlay
    }
    
    // Swift auto-generates Equatable and Hashable implementations
    
    // Manual description implementation
    public var stringDescription: String {
        return "DisplaySettings(fontSize: \(fontSize), colorScheme: \(colorScheme), isAccessibilityFriendly: \(isAccessibilityFriendly), isPerformanceOptimized: \(isPerformanceOptimized))"
    }
    
    // Manual copy function
    public func copy(fontSize: String? = nil, colorScheme: String? = nil, animation: Bool? = nil, autoPlay: Bool? = nil, highContrast: Bool? = nil) -> DisplaySettings {
        return DisplaySettings(
            fontSize: fontSize ?? self.fontSize,
            colorScheme: colorScheme ?? self.colorScheme,
            animation: animation ?? self.animation,
            autoPlay: autoPlay ?? self.autoPlay,
            highContrast: highContrast ?? self.highContrast
        )
    }
}

public struct AppSettings: Equatable, Hashable {
    public let theme: String
    public let language: String
    public let notifications: NotificationSettings
    public let privacy: PrivacySettings
    public let display: DisplaySettings
    
    // Swift auto-generates Equatable and Hashable implementations
    
    // Manual description implementation
    public var stringDescription: String {
        return "AppSettings(theme: \(theme), language: \(language))"
    }
    
    // Manual copy function
    public func copy(theme: String? = nil, language: String? = nil, notifications: NotificationSettings? = nil, privacy: PrivacySettings? = nil, display: DisplaySettings? = nil) -> AppSettings {
        return AppSettings(
            theme: theme ?? self.theme,
            language: language ?? self.language,
            notifications: notifications ?? self.notifications,
            privacy: privacy ?? self.privacy,
            display: display ?? self.display
        )
    }
}

// Data processing and analysis classes - manual implementations
public class DataClassProcessor {
    
    public func processPersonData(persons: [Person]) -> [String: Any] {
        let totalPersons = persons.count
        let adults = persons.filter { $0.isAdult }.count
        let averageAge = persons.isEmpty ? 0.0 : Double(persons.reduce(0) { $0 + $1.age }) / Double(persons.count)
        
        let firstNameCounts = Dictionary(grouping: persons) { $0.firstName }
            .mapValues { $0.count }
            .sorted { $0.value > $1.value }
            .prefix(5)
        let commonFirstNames = Dictionary(uniqueKeysWithValues: Array(firstNameCounts))
        
        let emailDomains = persons.map { $0.email.components(separatedBy: "@").last ?? "" }
            .filter { !$0.isEmpty }
            .removingDuplicates()
        
        return [
            "totalPersons": totalPersons,
            "adults": adults,
            "averageAge": averageAge,
            "commonFirstNames": commonFirstNames,
            "emailDomains": emailDomains
        ]
    }
    
    public func analyzeEmployeeData(employees: [Employee]) -> [String: Any] {
        let totalEmployees = employees.count
        let activeEmployees = employees.filter { $0.isActive }.count
        
        let departmentCounts = Dictionary(grouping: employees) { $0.department }
            .mapValues { $0.count }
        
        let averageSalary = employees.isEmpty ? 0.0 : employees.reduce(0) { $0 + $1.salary } / Double(employees.count)
        
        let salaryRanges = Dictionary(grouping: employees) { employee in
            switch employee.salary {
            case ..<50000:
                return "Under 50K"
            case 50000..<100000:
                return "50K-100K"
            case 100000..<150000:
                return "100K-150K"
            default:
                return "150K+"
            }
        }.mapValues { $0.count }
        
        let managers = employees.filter { $0.isManager }.count
        
        return [
            "totalEmployees": totalEmployees,
            "activeEmployees": activeEmployees,
            "departments": departmentCounts,
            "averageSalary": averageSalary,
            "salaryRanges": salaryRanges,
            "managers": managers
        ]
    }
    
    public func processTransactionData(transactions: [Transaction]) -> [String: Any] {
        let totalTransactions = transactions.count
        let totalIncome = transactions.filter { $0.isIncome }.reduce(0) { $0 + $1.amount }
        let totalExpenses = transactions.filter { $0.isExpense }.reduce(0) { $0 + $1.amount }
        
        let categories = Dictionary(grouping: transactions) { $0.category }
            .mapValues { group in
                [
                    "count": group.count,
                    "total": group.reduce(0) { $0 + $1.amount }
                ]
            }
        
        let averageTransaction = transactions.isEmpty ? 0.0 : transactions.reduce(0) { $0 + $1.amount } / Double(transactions.count)
        let currencies = Array(Set(transactions.map { $0.currency }))
        
        return [
            "totalTransactions": totalTransactions,
            "totalIncome": totalIncome,
            "totalExpenses": totalExpenses,
            "categories": categories,
            "averageTransaction": averageTransaction,
            "currencies": currencies
        ]
    }
    
    public func analyzeShoppingData(carts: [ShoppingCart]) -> [String: Any] {
        let allItems = carts.flatMap { $0.items }
        let averageCartValue = carts.isEmpty ? 0.0 : carts.reduce(0) { $0 + $1.total } / Double(carts.count)
        let averageItemsPerCart = carts.isEmpty ? 0.0 : Double(carts.reduce(0) { $0 + $1.itemCount }) / Double(carts.count)
        let cartsWithDiscount = carts.filter { $0.hasDiscount }.count
        let totalDiscountAmount = carts.reduce(0) { $0 + $1.discountAmount }
        
        let productCounts = Dictionary(grouping: allItems) { $0.product.id }
            .mapValues { $0.reduce(0) { $0 + $1.quantity } }
        let topProducts = Dictionary(uniqueKeysWithValues: Array(productCounts.sorted { $0.value > $1.value }.prefix(5)))
        
        return [
            "totalCarts": carts.count,
            "averageCartValue": averageCartValue,
            "averageItemsPerCart": averageItemsPerCart,
            "cartsWithDiscount": cartsWithDiscount,
            "totalDiscountAmount": totalDiscountAmount,
            "topProducts": topProducts
        ]
    }
    
    public func processGameData(sessions: [GameSession]) -> [String: Any] {
        let totalSessions = sessions.count
        let totalScore = sessions.reduce(0) { $0 + $1.score }
        let averageScore = sessions.isEmpty ? 0.0 : Double(totalScore) / Double(sessions.count)
        let topScore = sessions.map { $0.score }.max() ?? 0
        let totalDuration = sessions.reduce(0) { $0 + $1.duration }
        let averageDuration = sessions.isEmpty ? 0.0 : Double(totalDuration) / Double(sessions.count)
        
        let gameModeCounts = Dictionary(grouping: sessions) { $0.gameMode }
            .mapValues { $0.count }
        
        let achievementCounts = sessions.flatMap { $0.achievements }
            .reduce(into: [String: Int]()) { result, achievement in
                result[achievement, default: 0] += 1
            }
        
        return [
            "totalSessions": totalSessions,
            "averageScore": averageScore,
            "topScore": topScore,
            "averageDuration": averageDuration,
            "gameModeCounts": gameModeCounts,
            "achievementCounts": achievementCounts
        ]
    }
    
    public func analyzeSocialData(profiles: [UserProfile]) -> [String: Any] {
        let allPosts = profiles.flatMap { $0.posts }
        let totalProfiles = profiles.count
        let totalFollowers = profiles.reduce(0) { $0 + $1.followerCount }
        let averageFollowers = profiles.isEmpty ? 0.0 : Double(totalFollowers) / Double(profiles.count)
        let verifiedCount = profiles.filter { $0.isVerified }.count
        let totalPosts = allPosts.count
        let totalLikes = allPosts.reduce(0) { $0 + $1.likes }
        let popularPosts = allPosts.filter { $0.isPopular }.count
        
        let tagCounts = allPosts.flatMap { $0.tags }
            .reduce(into: [String: Int]()) { result, tag in
                result[tag, default: 0] += 1
            }
        let topTags = Dictionary(uniqueKeysWithValues: Array(tagCounts.sorted { $0.value > $1.value }.prefix(10)))
        
        return [
            "totalProfiles": totalProfiles,
            "averageFollowers": averageFollowers,
            "verifiedCount": verifiedCount,
            "totalPosts": totalPosts,
            "totalLikes": totalLikes,
            "popularPosts": popularPosts,
            "topTags": topTags
        ]
    }
}

// Data transformation and manipulation - missing in original Swift version
public class DataTransformer {
    
    public func transformPersonToEmployee(person: Person, department: String, position: String, salary: Double) -> Employee {
        let contactInfo = ContactInfo(
            primaryEmail: person.email,
            secondaryEmail: nil,
            phoneNumber: nil,
            address: nil
        )
        
        return Employee(
            id: "emp_\(person.id)",
            person: person,
            contactInfo: contactInfo,
            department: department,
            position: position,
            salary: salary,
            startDate: "2024-01-01",
            manager: nil,
            isActive: true
        )
    }
    
    public func mergeContactInfo(info1: ContactInfo, info2: ContactInfo) -> ContactInfo {
        return ContactInfo(
            primaryEmail: info1.primaryEmail,
            secondaryEmail: info2.primaryEmail,
            phoneNumber: info1.phoneNumber ?? info2.phoneNumber,
            address: info1.address ?? info2.address
        )
    }
    
    public func aggregateTransactions(transactions: [Transaction], groupBy: String) -> [Transaction] {
        switch groupBy {
        case "daily":
            let grouped = Dictionary(grouping: transactions) { transaction in
                // Simplified daily grouping - in real implementation would parse timestamp
                transaction.timestamp / 86400000 // milliseconds to days
            }
            return grouped.map { (day, dayTransactions) in
                let totalAmount = dayTransactions.reduce(0) { $0 + $1.amount }
                let firstTransaction = dayTransactions.first!
                return Transaction(
                    id: "daily_\(day)",
                    amount: totalAmount,
                    currency: firstTransaction.currency,
                    timestamp: day * 86400000,
                    description: "Daily aggregation for \(dayTransactions.count) transactions",
                    category: "aggregated",
                    tags: Array(Set(dayTransactions.flatMap { $0.tags }))
                )
            }
        case "category":
            let grouped = Dictionary(grouping: transactions) { $0.category }
            return grouped.map { (category, categoryTransactions) in
                let totalAmount = categoryTransactions.reduce(0) { $0 + $1.amount }
                let firstTransaction = categoryTransactions.first!
                return Transaction(
                    id: "cat_\(category)",
                    amount: totalAmount,
                    currency: firstTransaction.currency,
                    timestamp: firstTransaction.timestamp,
                    description: "Category aggregation for \(category)",
                    category: category,
                    tags: Array(Set(categoryTransactions.flatMap { $0.tags }))
                )
            }
        default:
            return transactions
        }
    }
    
    public func createOrderFromCart(cart: ShoppingCart, user: Person, shippingAddress: Address) -> Order {
        return Order(
            id: "order_\(cart.id)",
            userId: cart.userId,
            cart: cart,
            shippingAddress: shippingAddress,
            billingAddress: shippingAddress, // Same as shipping for simplicity
            paymentMethod: "credit_card",
            orderDate: "2024-01-01",
            status: "pending"
        )
    }
    
    public func updatePlayerProgress(player: Player, session: GameSession) -> Player {
        let newExperience = player.experience + (session.score / 10)
        let newLevel = newExperience / 1000
        let newAchievements = Array(Set(player.achievements + session.achievements))
        
        return player.copy(
            level: newLevel,
            experience: newExperience,
            achievements: newAchievements
        )
    }
}

// Main benchmark class demonstrating the verbosity difference
public class IosSizeBenchmark {
    private let processor = DataClassProcessor()
    private let transformer = DataTransformer()
    
    public func runBenchmark() {
        // Create sample data using structs - more verbose than Kotlin data classes
        let persons = [
            Person(id: "1", firstName: "John", lastName: "Doe", age: 30, email: "john.doe@example.com"),
            Person(id: "2", firstName: "Jane", lastName: "Smith", age: 25, email: "jane.smith@test.com"),
            Person(id: "3", firstName: "Bob", lastName: "Johnson", age: 35, email: "bob.johnson@company.org"),
            Person(id: "4", firstName: "Alice", lastName: "Brown", age: 28, email: "alice.brown@email.net"),
            Person(id: "5", firstName: "Charlie", lastName: "Wilson", age: 42, email: "charlie.wilson@work.com")
        ]
        
        let addresses = [
            Address(street: "123 Main St", city: "New York", state: "NY", zipCode: "10001", country: "USA"),
            Address(street: "456 Oak Ave", city: "Los Angeles", state: "CA", zipCode: "90210", country: "USA"),
            Address(street: "789 Pine Rd", city: "Chicago", state: "IL", zipCode: "60601", country: "USA"),
            Address(street: "321 Elm St", city: "Houston", state: "TX", zipCode: "77001", country: "USA"),
            Address(street: "654 Maple Dr", city: "Phoenix", state: "AZ", zipCode: "85001", country: "USA")
        ]
        
        let contactInfos = zip(persons, addresses).map { person, address in
            ContactInfo(primaryEmail: person.email, secondaryEmail: nil, phoneNumber: "+1234567890", address: address)
        }
        
        let employees = zip(persons, contactInfos).enumerated().map { index, personAndContact in
            let (person, contact) = personAndContact
            return Employee(
                id: "EMP_\(person.id)",
                person: person,
                contactInfo: contact,
                department: ["Engineering", "Marketing", "Sales", "HR", "Finance"][index % 5],
                position: ["Developer", "Manager", "Analyst", "Specialist", "Director"][index % 5],
                salary: 50000.0 + Double(index * 15000),
                startDate: "202\(index + 1)-01-01",
                manager: nil,
                isActive: true
            )
        }
        
        // Test manual equals functionality - Kotlin data classes do this automatically
        let person1 = persons[0]
        let person2 = Person(id: "1", firstName: "John", lastName: "Doe", age: 30, email: "john.doe@example.com")
        let areEqual = person1 == person2 // Manual implementation required
        
        // Test manual hashCode functionality - Kotlin data classes do this automatically
        let hashCode1 = person1.hashValue
        let hashCode2 = person2.hashValue
        let hashCodesEqual = hashCode1 == hashCode2
        
        // Test manual toString functionality - Kotlin data classes do this automatically
        let personString = person1.stringDescription
        
        // Test manual copy functionality - Kotlin data classes do this automatically with named parameters
        let modifiedPerson = person1.copy(age: 31)
        
        // Test that copy creates a new instance
        let isNotSameInstance = person1.age != modifiedPerson.age
        
        // Complex object operations - much more verbose than Kotlin
        let departmentEmployees = employees.prefix(3)
        let firstDepartment = Department(
            id: "DEPT_ENGINEERING",
            name: "Engineering",
            departmentDescription: "Engineering department",
            budget: Double(departmentEmployees.count) * 100000.0,
            manager: Array(departmentEmployees)[0],
            employees: Array(departmentEmployees)
        )
        
        // Manual copy with modifications - very verbose compared to Kotlin's named parameters
        let updatedDepartment = firstDepartment.copy(
            employees: firstDepartment.employees.map { employee in
                employee.copy(salary: employee.salary * 1.1)
            }
        )
        
        // Test transactions - split into smaller parts to help compiler
        let transactions: [Transaction] = (1...100).compactMap { i in
            let amount = i % 3 == 0 ? -(50.0 + Double(i * 10)) : (100.0 + Double(i * 5))
            let currency = i % 10 == 0 ? "EUR" : "USD"
            let timestamp = Int64(Date().timeIntervalSince1970 * 1000) - Int64(i * 86400000)
            let description = "Transaction \(i)"
            let category = ["food", "transportation", "entertainment", "utilities", "salary"][i % 5]
            let tags = i % 5 == 0 ? ["recurring", "essential"] : []
            
            return Transaction(
                id: "TXN_\(i)",
                amount: amount,
                currency: currency,
                timestamp: timestamp,
                description: description,
                category: category,
                tags: tags
            )
        }
        
        // Test products
        let products = (1...50).map { i in
            Product(
                id: "PROD_\(i)",
                name: "Product \(i)",
                description: "Description for product \(i)",
                price: 10.0 + Double(i * 5),
                currency: "USD",
                category: ["electronics", "clothing", "books", "home", "sports"][i % 5],
                tags: i % 10 == 0 ? ["sale", "featured"] : (i % 7 == 0 ? ["new"] : []),
                inStock: i % 15 != 0,
                stockQuantity: i % 15 == 0 ? 0 : i * 2
            )
        }
        
        // Process all data using manual processing methods
        let personStats = processor.processPersonData(persons: persons)
        let employeeStats = processor.analyzeEmployeeData(employees: employees)
        let transactionStats = processor.processTransactionData(transactions: transactions)
        
        // Complex transformations - much more verbose than Kotlin data class destructuring
        let employeePromotions = employees.map { employee in
            if employee.yearsOfService > 2 {
                return employee.copy(
                    position: "Senior \(employee.position)",
                    salary: employee.salary * 1.2
                )
            } else {
                return employee
            }
        }
        
        let discountedProducts = products.map { product in
            if product.isOnSale {
                return product.copy(price: product.price * 0.9)
            } else {
                return product
            }
        }
        
        // Manual object comparison and manipulation - Kotlin data classes make this trivial
        let originalTransaction = transactions.first!
        let modifiedTransaction = originalTransaction.copy(amount: originalTransaction.amount * 2)
        let transactionsAreEqual = originalTransaction == modifiedTransaction
        let transactionHashes = (originalTransaction.hashValue, modifiedTransaction.hashValue)
        
        // Complex nested operations - much more verbose without data class conveniences
        let processedEmployees = employees.map { employee in
            let updatedPerson = employee.person.copy(
                email: employee.person.email.lowercased()
            )
            let updatedContact = employee.contactInfo.copy(
                primaryEmail: updatedPerson.email
            )
            return employee.copy(
                person: updatedPerson,
                contactInfo: updatedContact,
                salary: employee.salary * (employee.isManager ? 1.5 : 1.1)
            )
        }
        
        // Grouping and aggregation - more verbose without data class conveniences
        let employeesByDepartment = Dictionary(grouping: employees) { $0.department }
        let departmentSummaries = employeesByDepartment.mapValues { deptEmployees in
            [
                "count": deptEmployees.count,
                "totalSalary": deptEmployees.reduce(0) { $0 + $1.salary },
                "averageAge": deptEmployees.isEmpty ? 0.0 : Double(deptEmployees.reduce(0) { $0 + $1.person.age }) / Double(deptEmployees.count)
            ]
        }
        
        // Product analysis - manual field access compared to Kotlin's component functions
        let productAnalysis = products.map { product in
            [
                "id": product.id,
                "name": product.name,
                "priceCategory": product.price < 50 ? "budget" : (product.price < 200 ? "mid-range" : "premium"),
                "availability": product.isAvailable ? "available" : "out_of_stock",
                "salesStatus": product.isOnSale ? "on_sale" : "regular_price"
            ]
        }
        
        // Transaction categorization - manual property access
        let transactionsByCategory = Dictionary(grouping: transactions) { $0.category }
        let categoryTotals = transactionsByCategory.mapValues { categoryTransactions in
            categoryTransactions.reduce(0) { $0 + $1.amount }
        }
        
        // Complex data transformations requiring manual object reconstruction
        let enrichedTransactions = transactions.map { transaction in
            let monthlyAmount = transaction.amount * 12
            let enrichedDescription = "\(transaction.description) (Monthly: \(monthlyAmount))"
            return transaction.copy(
                description: enrichedDescription,
                tags: transaction.tags + ["enriched"]
            )
        }
        
        // Demonstrate the verbosity of manual equals/hashCode/toString vs Kotlin's automatic generation
        print("Person equality check: \(areEqual)")
        print("Hash codes equal: \(hashCodesEqual)")
        print("Person description: \(personString)")
        print("Modified person age: \(modifiedPerson.age)")
        print("Department total salary: \(updatedDepartment.totalSalaryBudget)")
    }
}

// Extension to remove duplicates from arrays - helper functionality that would be built-in with better data classes
extension Array where Element: Hashable {
    func removingDuplicates() -> [Element] {
        var seen = Set<Element>()
        return filter { seen.insert($0).inserted }
    }
}