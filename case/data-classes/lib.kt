/*
 * iOS Size Benchmark - Test Case Implementation
 * Generated with Claude AI (https://claude.ai)
 * 
 * This Kotlin Native implementation demonstrates language-specific
 * features and patterns for binary size comparison.
 */

package kntr.examples.ios.size.benchmark

// Test case: Data Classes - Tests Kotlin's concise data classes vs manual implementation

// Simple data classes - minimal code for maximum functionality
data class Person(
    val id: String,
    val firstName: String,
    val lastName: String,
    val age: Int,
    val email: String
) {
    // Additional computed properties and methods can still be added
    val fullName: String get() = "$firstName $lastName"
    val isAdult: Boolean get() = age >= 18
}

data class Address(
    val street: String,
    val city: String,
    val state: String,
    val zipCode: String,
    val country: String
) {
    val shortAddress: String get() = "$city, $state"
    val isUSA: Boolean get() = country.equals("USA", ignoreCase = true)
}

data class ContactInfo(
    val primaryEmail: String,
    val secondaryEmail: String? = null,
    val phoneNumber: String? = null,
    val address: Address? = null
) {
    val hasMultipleEmails: Boolean get() = secondaryEmail != null
    val hasCompleteInfo: Boolean get() = phoneNumber != null && address != null
}

// Complex nested data structures
data class Employee(
    val id: String,
    val person: Person,
    val contactInfo: ContactInfo,
    val department: String,
    val position: String,
    val salary: Double,
    val startDate: String,
    val manager: String? = null,
    val isActive: Boolean = true
) {
    val displayName: String get() = "${person.fullName} ($department)"
    val isManager: Boolean get() = manager == null
    val yearsOfService: Int get() = 2024 - (startDate.take(4).toIntOrNull() ?: 2024)
}

data class Department(
    val id: String,
    val name: String,
    val description: String,
    val budget: Double,
    val manager: Employee,
    val employees: List<Employee>
) {
    val totalSalaryBudget: Double get() = employees.sumOf { it.salary }
    val employeeCount: Int get() = employees.size
    val averageSalary: Double get() = if (employees.isNotEmpty()) totalSalaryBudget / employees.size else 0.0
}

data class Company(
    val id: String,
    val name: String,
    val headquarters: Address,
    val departments: List<Department>,
    val foundedYear: Int,
    val website: String? = null
) {
    val totalEmployees: Int get() = departments.sumOf { it.employeeCount }
    val totalBudget: Double get() = departments.sumOf { it.budget }
    val companyAge: Int get() = 2024 - foundedYear
}

// Financial data structures
data class Transaction(
    val id: String,
    val amount: Double,
    val currency: String,
    val timestamp: Long,
    val description: String,
    val category: String,
    val tags: List<String> = emptyList()
) {
    val isExpense: Boolean get() = amount < 0
    val isIncome: Boolean get() = amount > 0
    val formattedAmount: String get() = "${if (amount >= 0) "+" else ""}${(amount * 100).toInt() / 100.0} $currency"
}

data class Account(
    val id: String,
    val accountNumber: String,
    val accountType: String,
    val balance: Double,
    val currency: String,
    val owner: Person,
    val transactions: List<Transaction>
) {
    val totalIncome: Double get() = transactions.filter { it.isIncome }.sumOf { it.amount }
    val totalExpenses: Double get() = transactions.filter { it.isExpense }.sumOf { it.amount }
    val transactionCount: Int get() = transactions.size
}

data class Budget(
    val id: String,
    val name: String,
    val totalAmount: Double,
    val currency: String,
    val categories: Map<String, Double>,
    val period: String,
    val owner: Person
) {
    val allocatedAmount: Double get() = categories.values.sum()
    val remainingAmount: Double get() = totalAmount - allocatedAmount
    val isOverBudget: Boolean get() = allocatedAmount > totalAmount
}

// E-commerce data structures
data class Product(
    val id: String,
    val name: String,
    val description: String,
    val price: Double,
    val currency: String,
    val category: String,
    val tags: List<String>,
    val inStock: Boolean,
    val stockQuantity: Int
) {
    val isAvailable: Boolean get() = inStock && stockQuantity > 0
    val formattedPrice: String get() = "${(price * 100).toInt() / 100.0} $currency"
    val isOnSale: Boolean get() = tags.contains("sale")
}

data class CartItem(
    val product: Product,
    val quantity: Int,
    val selectedVariant: String? = null
) {
    val totalPrice: Double get() = product.price * quantity
    val isValidQuantity: Boolean get() = quantity > 0 && quantity <= product.stockQuantity
}

data class ShoppingCart(
    val id: String,
    val userId: String,
    val items: List<CartItem>,
    val discountCode: String? = null,
    val discountAmount: Double = 0.0
) {
    val subtotal: Double get() = items.sumOf { it.totalPrice }
    val total: Double get() = subtotal - discountAmount
    val itemCount: Int get() = items.sumOf { it.quantity }
    val hasDiscount: Boolean get() = discountCode != null && discountAmount > 0
}

data class Order(
    val id: String,
    val userId: String,
    val cart: ShoppingCart,
    val shippingAddress: Address,
    val billingAddress: Address,
    val paymentMethod: String,
    val orderDate: String,
    val status: String
) {
    val orderTotal: Double get() = cart.total
    val isShipped: Boolean get() = status in listOf("shipped", "delivered")
    val isCompleted: Boolean get() = status == "delivered"
    val itemSummary: String get() = "${cart.itemCount} items totaling ${cart.total}"
}

// Gaming/Entertainment data structures
data class Player(
    val id: String,
    val username: String,
    val email: String,
    val level: Int,
    val experience: Int,
    val achievements: List<String>,
    val joinDate: String
) {
    val experienceToNextLevel: Int get() = ((level + 1) * 1000) - experience
    val achievementCount: Int get() = achievements.size
    val isVeteran: Boolean get() = achievements.contains("veteran")
}

data class GameSession(
    val id: String,
    val player: Player,
    val gameMode: String,
    val score: Int,
    val duration: Long,
    val timestamp: Long,
    val achievements: List<String> = emptyList()
) {
    val scorePerMinute: Double get() = if (duration > 0) score.toDouble() / (duration / 60000.0) else 0.0
    val hasNewAchievements: Boolean get() = achievements.isNotEmpty()
    val durationInMinutes: Long get() = duration / 60000
}

data class Leaderboard(
    val gameMode: String,
    val period: String,
    val entries: List<LeaderboardEntry>,
    val lastUpdated: Long
) {
    val topPlayer: LeaderboardEntry? get() = entries.firstOrNull()
    val entryCount: Int get() = entries.size
    val averageScore: Double get() = if (entries.isNotEmpty()) entries.map { it.score }.average() else 0.0
}

data class LeaderboardEntry(
    val rank: Int,
    val player: Player,
    val score: Int,
    val gamesPlayed: Int
) {
    val averageScorePerGame: Double get() = if (gamesPlayed > 0) score.toDouble() / gamesPlayed else 0.0
    val isTopTen: Boolean get() = rank <= 10
}

// Social media data structures
data class Post(
    val id: String,
    val author: Person,
    val content: String,
    val timestamp: Long,
    val likes: Int,
    val comments: List<Comment>,
    val tags: List<String>,
    val isPublic: Boolean = true
) {
    val commentCount: Int get() = comments.size
    val hasHashtags: Boolean get() = tags.isNotEmpty()
    val isPopular: Boolean get() = likes > 100 || comments.size > 50
}

data class Comment(
    val id: String,
    val author: Person,
    val content: String,
    val timestamp: Long,
    val likes: Int,
    val replies: List<Comment> = emptyList()
) {
    val hasReplies: Boolean get() = replies.isNotEmpty()
    val totalReplies: Int get() = replies.size + replies.sumOf { it.totalReplies }
}

data class UserProfile(
    val person: Person,
    val bio: String,
    val profilePicture: String? = null,
    val followers: List<String>,
    val following: List<String>,
    val posts: List<Post>
) {
    val followerCount: Int get() = followers.size
    val followingCount: Int get() = following.size
    val postCount: Int get() = posts.size
    val totalLikes: Int get() = posts.sumOf { it.likes }
    val isVerified: Boolean get() = followerCount > 10000
}

// Configuration and settings data structures
data class AppSettings(
    val theme: String,
    val language: String,
    val notifications: NotificationSettings,
    val privacy: PrivacySettings,
    val display: DisplaySettings
)

data class NotificationSettings(
    val emailNotifications: Boolean,
    val pushNotifications: Boolean,
    val smsNotifications: Boolean,
    val marketingEmails: Boolean,
    val securityAlerts: Boolean
) {
    val hasAnyNotificationsEnabled: Boolean get() = 
        emailNotifications || pushNotifications || smsNotifications || marketingEmails || securityAlerts
    val notificationCount: Int get() = 
        listOf(emailNotifications, pushNotifications, smsNotifications, marketingEmails, securityAlerts).count { it }
}

data class PrivacySettings(
    val profileVisibility: String,
    val dataSharing: Boolean,
    val analytics: Boolean,
    val advertising: Boolean,
    val locationTracking: Boolean
) {
    val isPrivacyFocused: Boolean get() = !dataSharing && !analytics && !advertising && !locationTracking
    val privacyScore: Int get() = 
        listOf(dataSharing, analytics, advertising, locationTracking).count { !it }
}

data class DisplaySettings(
    val fontSize: String,
    val colorScheme: String,
    val animation: Boolean,
    val autoPlay: Boolean,
    val highContrast: Boolean
) {
    val isAccessibilityFriendly: Boolean get() = fontSize in listOf("large", "extra-large") || highContrast
    val isPerformanceOptimized: Boolean get() = !animation && !autoPlay
}

// Data processing and analysis classes
class DataClassProcessor {
    
    fun processPersonData(persons: List<Person>): Map<String, Any> {
        return mapOf(
            "totalPersons" to persons.size,
            "adults" to persons.count { it.isAdult },
            "averageAge" to if (persons.isNotEmpty()) persons.map { it.age }.average() else 0.0,
            "commonFirstNames" to persons.groupBy { it.firstName }.mapValues { it.value.size }
                .toList().sortedByDescending { it.second }.take(5).toMap(),
            "emailDomains" to persons.map { it.email.substringAfter("@") }.distinct()
        )
    }
    
    fun analyzeEmployeeData(employees: List<Employee>): Map<String, Any> {
        return mapOf(
            "totalEmployees" to employees.size,
            "activeEmployees" to employees.count { it.isActive },
            "departments" to employees.groupBy { it.department }.mapValues { it.value.size },
            "averageSalary" to if (employees.isNotEmpty()) employees.map { it.salary }.average() else 0.0,
            "salaryRanges" to employees.groupBy { 
                when {
                    it.salary < 50000 -> "Under 50K"
                    it.salary < 100000 -> "50K-100K"
                    it.salary < 150000 -> "100K-150K"
                    else -> "150K+"
                }
            }.mapValues { it.value.size },
            "managers" to employees.count { it.isManager }
        )
    }
    
    fun processTransactionData(transactions: List<Transaction>): Map<String, Any> {
        return mapOf(
            "totalTransactions" to transactions.size,
            "totalIncome" to transactions.filter { it.isIncome }.sumOf { it.amount },
            "totalExpenses" to transactions.filter { it.isExpense }.sumOf { it.amount },
            "categories" to transactions.groupBy { it.category }.mapValues { group ->
                mapOf(
                    "count" to group.value.size,
                    "total" to group.value.sumOf { it.amount }
                )
            },
            "averageTransaction" to if (transactions.isNotEmpty()) transactions.map { it.amount }.average() else 0.0,
            "currencies" to transactions.map { it.currency }.distinct()
        )
    }
    
    fun analyzeShoppingData(carts: List<ShoppingCart>): Map<String, Any> {
        val allItems = carts.flatMap { it.items }
        return mapOf(
            "totalCarts" to carts.size,
            "averageCartValue" to if (carts.isNotEmpty()) carts.map { it.total }.average() else 0.0,
            "averageItemsPerCart" to if (carts.isNotEmpty()) carts.map { it.itemCount }.average() else 0.0,
            "cartsWithDiscount" to carts.count { it.hasDiscount },
            "totalDiscountAmount" to carts.sumOf { it.discountAmount },
            "popularProducts" to allItems.groupBy { it.product.name }.mapValues { it.value.sumOf { item -> item.quantity } }
                .toList().sortedByDescending { it.second }.take(10).toMap(),
            "totalRevenue" to carts.sumOf { it.total }
        )
    }
    
    fun processGameData(sessions: List<GameSession>): Map<String, Any> {
        return mapOf(
            "totalSessions" to sessions.size,
            "uniquePlayers" to sessions.map { it.player.id }.distinct().size,
            "averageScore" to if (sessions.isNotEmpty()) sessions.map { it.score }.average() else 0.0,
            "averageDuration" to if (sessions.isNotEmpty()) sessions.map { it.durationInMinutes }.average() else 0.0,
            "gameModes" to sessions.groupBy { it.gameMode }.mapValues { it.value.size },
            "topScores" to sessions.sortedByDescending { it.score }.take(10).map { 
                mapOf("player" to it.player.username, "score" to it.score, "mode" to it.gameMode)
            },
            "sessionsWithAchievements" to sessions.count { it.hasNewAchievements }
        )
    }
    
    fun analyzeSocialData(profiles: List<UserProfile>): Map<String, Any> {
        val allPosts = profiles.flatMap { it.posts }
        return mapOf(
            "totalUsers" to profiles.size,
            "verifiedUsers" to profiles.count { it.isVerified },
            "totalPosts" to allPosts.size,
            "totalLikes" to allPosts.sumOf { it.likes },
            "totalComments" to allPosts.sumOf { it.commentCount },
            "averageFollowers" to if (profiles.isNotEmpty()) profiles.map { it.followerCount }.average() else 0.0,
            "averagePostsPerUser" to if (profiles.isNotEmpty()) profiles.map { it.postCount }.average() else 0.0,
            "popularTags" to allPosts.flatMap { it.tags }.groupBy { it }.mapValues { it.value.size }
                .toList().sortedByDescending { it.second }.take(20).toMap(),
            "publicPosts" to allPosts.count { it.isPublic },
            "popularPosts" to allPosts.count { it.isPopular }
        )
    }
}

// Data transformation and manipulation
class DataTransformer {
    
    fun transformPersonToEmployee(person: Person, department: String, position: String, salary: Double): Employee {
        return Employee(
            id = "EMP_${person.id}",
            person = person,
            contactInfo = ContactInfo(person.email),
            department = department,
            position = position,
            salary = salary,
            startDate = "2024-01-01"
        )
    }
    
    fun mergeContactInfo(info1: ContactInfo, info2: ContactInfo): ContactInfo {
        return ContactInfo(
            primaryEmail = info1.primaryEmail,
            secondaryEmail = info1.secondaryEmail ?: info2.secondaryEmail,
            phoneNumber = info1.phoneNumber ?: info2.phoneNumber,
            address = info1.address ?: info2.address
        )
    }
    
    fun aggregateTransactions(transactions: List<Transaction>, groupBy: String): List<Transaction> {
        return when (groupBy) {
            "category" -> transactions.groupBy { it.category }.map { (category, txns) ->
                Transaction(
                    id = "AGG_${category}_${txns.size}",
                    amount = txns.sumOf { it.amount },
                    currency = txns.first().currency,
                    timestamp = txns.maxOf { it.timestamp },
                    description = "Aggregated $category transactions",
                    category = category,
                    tags = txns.flatMap { it.tags }.distinct()
                )
            }
            "currency" -> transactions.groupBy { it.currency }.map { (currency, txns) ->
                Transaction(
                    id = "AGG_${currency}_${txns.size}",
                    amount = txns.sumOf { it.amount },
                    currency = currency,
                    timestamp = txns.maxOf { it.timestamp },
                    description = "Aggregated $currency transactions",
                    category = "aggregated",
                    tags = txns.flatMap { it.tags }.distinct()
                )
            }
            else -> transactions
        }
    }
    
    fun createOrderFromCart(cart: ShoppingCart, user: Person, shippingAddress: Address): Order {
        return Order(
            id = "ORDER_${cart.id}",
            userId = cart.userId,
            cart = cart,
            shippingAddress = shippingAddress,
            billingAddress = shippingAddress,
            paymentMethod = "credit_card",
            orderDate = "2024-01-01",
            status = "pending"
        )
    }
    
    fun updatePlayerProgress(player: Player, session: GameSession): Player {
        val newExperience = player.experience + (session.score / 10)
        val newLevel = newExperience / 1000
        val newAchievements = (player.achievements + session.achievements).distinct()
        
        return player.copy(
            level = maxOf(player.level, newLevel),
            experience = newExperience,
            achievements = newAchievements
        )
    }
}

// Main benchmark class
class IosSizeBenchmark {
    val processor = DataClassProcessor()
    val transformer = DataTransformer()
    
    fun runBenchmark() {
        // Create sample data using data classes
        val persons = listOf(
            Person("1", "John", "Doe", 30, "john.doe@example.com"),
            Person("2", "Jane", "Smith", 25, "jane.smith@test.com"),
            Person("3", "Bob", "Johnson", 35, "bob.johnson@company.org"),
            Person("4", "Alice", "Brown", 28, "alice.brown@email.net"),
            Person("5", "Charlie", "Wilson", 42, "charlie.wilson@work.com")
        )
        
        val addresses = listOf(
            Address("123 Main St", "New York", "NY", "10001", "USA"),
            Address("456 Oak Ave", "Los Angeles", "CA", "90210", "USA"),
            Address("789 Pine Rd", "Chicago", "IL", "60601", "USA")
        )
        
        val contactInfos = persons.zip(addresses).map { (person, address) ->
            ContactInfo(person.email, null, "+1234567890", address)
        }
        
        val employees = persons.zip(contactInfos).mapIndexed { index, (person, contact) ->
            Employee(
                id = "EMP_${person.id}",
                person = person,
                contactInfo = contact,
                department = listOf("Engineering", "Marketing", "Sales", "HR", "Finance")[index % 5],
                position = listOf("Developer", "Manager", "Analyst", "Specialist", "Director")[index % 5],
                salary = 50000.0 + (index * 15000),
                startDate = "202${index + 1}-01-01"
            )
        }
        
        val departments = employees.groupBy { it.department }.map { (deptName, deptEmployees) ->
            Department(
                id = "DEPT_${deptName.replace(" ", "_").uppercase()}",
                name = deptName,
                description = "$deptName department",
                budget = deptEmployees.size * 100000.0,
                manager = deptEmployees.first(),
                employees = deptEmployees
            )
        }
        
        val company = Company(
            id = "COMPANY_001",
            name = "Tech Solutions Inc",
            headquarters = addresses.first(),
            departments = departments,
            foundedYear = 2010,
            website = "https://techsolutions.com"
        )
        
        // Financial data
        val transactions = (1..100).map { i ->
            Transaction(
                id = "TXN_$i",
                amount = if (i % 3 == 0) -(50.0 + i * 10) else (100.0 + i * 5),
                currency = if (i % 10 == 0) "EUR" else "USD",
                timestamp = 1640995200000L - (i * 86400000L), // Fixed timestamp
                description = "Transaction $i",
                category = listOf("food", "transportation", "entertainment", "utilities", "salary")[i % 5],
                tags = if (i % 5 == 0) listOf("recurring", "essential") else emptyList()
            )
        }
        
        val accounts = persons.mapIndexed { index, person ->
            Account(
                id = "ACC_${person.id}",
                accountNumber = "12345${index}890",
                accountType = if (index % 2 == 0) "checking" else "savings",
                balance = 1000.0 + index * 500,
                currency = "USD",
                owner = person,
                transactions = transactions.filter { it.id.endsWith(index.toString()) }
            )
        }
        
        val budgets = persons.mapIndexed { index, person ->
            Budget(
                id = "BUDGET_${person.id}",
                name = "${person.firstName}'s Monthly Budget",
                totalAmount = 3000.0 + index * 500,
                currency = "USD",
                categories = mapOf(
                    "housing" to 1200.0,
                    "food" to 400.0,
                    "transportation" to 300.0,
                    "entertainment" to 200.0,
                    "savings" to 500.0
                ),
                period = "monthly",
                owner = person
            )
        }
        
        // E-commerce data
        val products = (1..50).map { i ->
            Product(
                id = "PROD_$i",
                name = "Product $i",
                description = "Description for product $i",
                price = 10.0 + i * 5,
                currency = "USD",
                category = listOf("electronics", "clothing", "books", "home", "sports")[i % 5],
                tags = if (i % 10 == 0) listOf("sale", "featured") else if (i % 7 == 0) listOf("new") else emptyList(),
                inStock = i % 15 != 0,
                stockQuantity = if (i % 15 == 0) 0 else i * 2
            )
        }
        
        val cartItems = products.take(10).mapIndexed { index, product ->
            CartItem(product, index + 1)
        }
        
        val shoppingCarts = persons.mapIndexed { index, person ->
            ShoppingCart(
                id = "CART_${person.id}",
                userId = person.id,
                items = cartItems.take(index + 2),
                discountCode = if (index % 3 == 0) "SAVE10" else null,
                discountAmount = if (index % 3 == 0) 10.0 else 0.0
            )
        }
        
        val orders = shoppingCarts.zip(persons).zip(addresses).map { (cartAndPerson, address) ->
            val (cart, person) = cartAndPerson
            transformer.createOrderFromCart(cart, person, address)
        }
        
        // Gaming data
        val players = persons.map { person ->
            Player(
                id = "PLAYER_${person.id}",
                username = "${person.firstName.lowercase()}_${person.lastName.lowercase()}",
                email = person.email,
                level = (1..50).random(),
                experience = (100..49000).random(),
                achievements = listOf("first_login", "score_1000", "veteran", "champion").take((0..4).random()),
                joinDate = "202${(0..3).random()}-${(1..12).random().toString().padStart(2, '0')}-01"
            )
        }
        
        val gameSessions = (1..200).map { i ->
            GameSession(
                id = "SESSION_$i",
                player = players[i % players.size],
                gameMode = listOf("classic", "arcade", "tournament", "practice")[i % 4],
                score = (100..10000).random(),
                duration = (60000L..3600000L).random(),
                timestamp = 1640995200000L - (i * 3600000L), // Fixed timestamp
                achievements = if (i % 20 == 0) listOf("high_score") else emptyList()
            )
        }
        
        val leaderboardEntries = players.mapIndexed { index, player ->
            LeaderboardEntry(index + 1, player, (1000..9999).random(), (10..100).random())
        }
        
        val leaderboard = Leaderboard(
            gameMode = "classic",
            period = "weekly",
            entries = leaderboardEntries.sortedByDescending { it.score },
            lastUpdated = 1640995200000L // Fixed timestamp
        )
        
        // Social media data
        val comments = (1..50).map { i ->
            Comment(
                id = "COMMENT_$i",
                author = persons[i % persons.size],
                content = "This is comment $i",
                timestamp = 1640995200000L - (i * 60000L), // Fixed timestamp
                likes = (0..100).random()
            )
        }
        
        val posts = (1..30).map { i ->
            Post(
                id = "POST_$i",
                author = persons[i % persons.size],
                content = "This is post $i with some interesting content",
                timestamp = 1640995200000L - (i * 3600000L), // Fixed timestamp
                likes = (0..1000).random(),
                comments = comments.filter { it.id.endsWith((i % 10).toString()) },
                tags = if (i % 5 == 0) listOf("tech", "programming") else if (i % 3 == 0) listOf("life", "thoughts") else emptyList()
            )
        }
        
        val userProfiles = persons.map { person ->
            UserProfile(
                person = person,
                bio = "Bio for ${person.fullName}",
                profilePicture = "profile_${person.id}.jpg",
                followers = (1..1000).map { "follower_$it" }.take((10..1000).random()),
                following = (1..500).map { "following_$it" }.take((5..500).random()),
                posts = posts.filter { it.author.id == person.id }
            )
        }
        
        // Settings data
        val appSettings = AppSettings(
            theme = "dark",
            language = "en",
            notifications = NotificationSettings(true, true, false, false, true),
            privacy = PrivacySettings("public", false, false, false, true),
            display = DisplaySettings("medium", "auto", true, false, false)
        )
        
        // Process all data using data class methods
        val personStats = processor.processPersonData(persons)
        val employeeStats = processor.analyzeEmployeeData(employees)
        val transactionStats = processor.processTransactionData(transactions)
        val shoppingStats = processor.analyzeShoppingData(shoppingCarts)
        val gameStats = processor.processGameData(gameSessions)
        val socialStats = processor.analyzeSocialData(userProfiles)
        
        // Test data class features - copy, equals, hashCode, toString
        val originalPerson = persons.first()
        val modifiedPerson = originalPerson.copy(age = originalPerson.age + 1)
        val isEqual = originalPerson == modifiedPerson
        val hashCodesEqual = originalPerson.hashCode() == modifiedPerson.hashCode()
        val personString = originalPerson.toString()
        
        // Test destructuring
        val (id, firstName, lastName, age, email) = originalPerson
        val fullNameFromDestructuring = "$firstName $lastName"
        
        // Complex object operations
        val departmentCopy = departments.first().copy(
            employees = departments.first().employees.map { emp ->
                emp.copy(salary = emp.salary * 1.1)
            }
        )
        
        val orderWithUpdatedStatus = orders.first().copy(status = "shipped")
        
        // Nested data manipulation
        val updatedUserProfile = userProfiles.first().let { profile ->
            profile.copy(
                posts = profile.posts.map { post ->
                    post.copy(
                        comments = post.comments.map { comment ->
                            comment.copy(likes = comment.likes + 1)
                        }
                    )
                }
            )
        }
        
        // Aggregate computations using data class properties
        val totalCompanyValue = company.totalBudget
        val averageEmployeeSalary = company.departments.flatMap { it.employees }.map { it.salary }.average()
        val totalOrders = orders.sumOf { it.orderTotal }
        val topGameScore = gameSessions.maxOfOrNull { it.score } ?: 0
        val totalSocialEngagement = userProfiles.sumOf { it.totalLikes }
        
        // Data validation using computed properties
        val validEmployees = employees.filter { it.person.isAdult && it.salary > 0 }
        val availableProducts = products.filter { it.isAvailable }
        val completedOrders = orders.filter { it.isCompleted }
        val activeGameSessions = gameSessions.filter { it.duration > 60000 }
        val popularPosts = posts.filter { it.isPopular }
        
        // Complex transformations
        val employeePromotions = employees.map { emp ->
            if (emp.yearsOfService > 2) {
                emp.copy(
                    position = "Senior ${emp.position}",
                    salary = emp.salary * 1.2
                )
            } else emp
        }
        
        val discountedProducts = products.map { product ->
            if (product.isOnSale) {
                product.copy(price = product.price * 0.9)
            } else product
        }
        
        val updatedPlayers = players.map { player ->
            val playerSessions = gameSessions.filter { it.player.id == player.id }
            playerSessions.fold(player) { currentPlayer, session ->
                transformer.updatePlayerProgress(currentPlayer, session)
            }
        }
    }
}