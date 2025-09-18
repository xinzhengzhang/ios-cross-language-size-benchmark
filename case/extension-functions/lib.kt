/*
 * iOS Size Benchmark - Test Case Implementation
 * Generated with Claude AI (https://claude.ai)
 * 
 * This Kotlin Native implementation demonstrates language-specific
 * features and patterns for binary size comparison.
 */

package kntr.examples.ios.size.benchmark

import kotlin.math.pow
import kotlin.math.round

// Platform-specific current time function
fun getCurrentTimeMillis(): Long = 1640995200000L // Mock timestamp for compilation

// Test case: Extension Functions - Tests Kotlin's extension functions vs utility classes/categories

// String extensions - elegant additions to String class
fun String.isValidEmail(): Boolean {
    return this.contains("@") && this.contains(".") && this.length > 5
}

fun String.isValidPhone(): Boolean {
    val cleaned = this.replace("[^0-9]".toRegex(), "")
    return cleaned.length in 10..15
}

fun String.toTitleCase(): String {
    return this.split(" ")
        .joinToString(" ") { word ->
            word.lowercase().replaceFirstChar { it.uppercase() }
        }
}

fun String.toCamelCase(): String {
    return this.split(" ", "_", "-")
        .filter { it.isNotEmpty() }
        .mapIndexed { index, word ->
            if (index == 0) word.lowercase()
            else word.lowercase().replaceFirstChar { it.uppercase() }
        }
        .joinToString("")
}

fun String.toSnakeCase(): String {
    return this.replace("([a-z])([A-Z])".toRegex(), "$1_$2")
        .replace(" ", "_")
        .replace("-", "_")
        .lowercase()
}

fun String.truncate(maxLength: Int, suffix: String = "..."): String {
    return if (this.length <= maxLength) this
    else this.take(maxLength - suffix.length) + suffix
}

fun String.removeWhitespace(): String = this.replace("\\s".toRegex(), "")

fun String.countWords(): Int = this.trim().split("\\s+".toRegex()).size

fun String.reverse(): String = this.reversed()

fun String.isPalindrome(): Boolean {
    val cleaned = this.removeWhitespace().lowercase()
    return cleaned == cleaned.reversed()
}

fun String.extractNumbers(): List<Int> {
    return "\\d+".toRegex().findAll(this)
        .map { it.value.toInt() }
        .toList()
}

fun String.extractEmails(): List<String> {
    return "[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}".toRegex()
        .findAll(this)
        .map { it.value }
        .toList()
}

fun String.maskEmail(): String {
    return if (this.isValidEmail()) {
        val parts = this.split("@")
        val username = parts[0]
        val domain = parts[1]
        val maskedUsername = if (username.length <= 2) "**"
        else username.take(2) + "*".repeat(username.length - 2)
        "$maskedUsername@$domain"
    } else this
}

fun String.wordFrequency(): Map<String, Int> {
    return this.lowercase()
        .split("\\W+".toRegex())
        .filter { it.isNotEmpty() }
        .groupBy { it }
        .mapValues { it.value.size }
}

// Number extensions
fun Int.isEven(): Boolean = this % 2 == 0
fun Int.isOdd(): Boolean = this % 2 != 0
fun Int.isPrime(): Boolean {
    if (this < 2) return false
    for (i in 2..kotlin.math.sqrt(this.toDouble()).toInt()) {
        if (this % i == 0) return false
    }
    return true
}

fun Int.factorial(): Long {
    return if (this <= 1) 1L else this * (this - 1).factorial()
}

fun Int.toRoman(): String {
    val values = arrayOf(1000, 900, 500, 400, 100, 90, 50, 40, 10, 9, 5, 4, 1)
    val symbols = arrayOf("M", "CM", "D", "CD", "C", "XC", "L", "XL", "X", "IX", "V", "IV", "I")
    
    var num = this
    val result = StringBuilder()
    
    for (i in values.indices) {
        while (num >= values[i]) {
            result.append(symbols[i])
            num -= values[i]
        }
    }
    return result.toString()
}

fun Double.formatCurrency(currency: String = "USD"): String {
    return "${'$'}${(this * 100).toInt() / 100.0} $currency"
}

fun Double.toPercentage(): String = "${'$'}{((this * 100 * 10).toInt() / 10.0)}%"

fun Double.round(decimals: Int): Double {
    val factor = 10.0.pow(decimals)
    return round(this * factor) / factor
}

// Collection extensions
fun <T> List<T>.second(): T? = if (this.size >= 2) this[1] else null
fun <T> List<T>.third(): T? = if (this.size >= 3) this[2] else null
fun <T> List<T>.secondToLast(): T? = if (this.size >= 2) this[this.size - 2] else null

fun <T> List<T>.takeRandom(count: Int): List<T> = this.shuffled().take(count)

fun <T> List<T>.split(predicate: (T) -> Boolean): Pair<List<T>, List<T>> {
    val first = mutableListOf<T>()
    val second = mutableListOf<T>()
    this.forEach { if (predicate(it)) first.add(it) else second.add(it) }
    return Pair(first, second)
}

fun <T> List<T>.chunks(size: Int): List<List<T>> {
    return this.chunked(size)
}

fun <T> List<T>.frequencyMap(): Map<T, Int> {
    return this.groupBy { it }.mapValues { it.value.size }
}

fun <T> List<T>.duplicates(): List<T> {
    return this.groupBy { it }.filter { it.value.size > 1 }.keys.toList()
}

fun <T> List<T>.unique(): List<T> = this.distinct()

fun <T> List<T>.withoutNulls(): List<T> = this.filterNotNull()

fun <T> List<T>.rotateLeft(positions: Int): List<T> {
    if (this.isEmpty()) return this
    val pos = positions % this.size
    return this.drop(pos) + this.take(pos)
}

fun <T> List<T>.rotateRight(positions: Int): List<T> {
    if (this.isEmpty()) return this
    val pos = positions % this.size
    return this.takeLast(pos) + this.dropLast(pos)
}

// Map extensions
fun <K, V> Map<K, V>.filterByKeys(predicate: (K) -> Boolean): Map<K, V> {
    return this.filterKeys(predicate)
}

fun <K, V> Map<K, V>.filterByValues(predicate: (V) -> Boolean): Map<K, V> {
    return this.filterValues(predicate)
}

fun <K, V> Map<K, V>.swap(): Map<V, K> {
    return this.map { (k, v) -> v to k }.toMap()
}

fun <K, V> Map<K, V>.getOrDefault(key: K, defaultValue: V): V {
    return this[key] ?: defaultValue
}

// Date/Time extensions (simplified)
fun Long.toDateString(): String {
    val seconds = this / 1000
    val minutes = seconds / 60
    val hours = minutes / 60
    val days = hours / 24
    
    return when {
        days > 0 -> "$days days ago"
        hours > 0 -> "$hours hours ago"
        minutes > 0 -> "$minutes minutes ago"
        else -> "$seconds seconds ago"
    }
}

fun Long.formatDuration(): String {
    val hours = this / 3600000
    val minutes = (this % 3600000) / 60000
    val seconds = (this % 60000) / 1000
    
    return when {
        hours > 0 -> "$hours:${minutes.toString().padStart(2, '0')}:${seconds.toString().padStart(2, '0')}"
        minutes > 0 -> "$minutes:${seconds.toString().padStart(2, '0')}"
        else -> "$seconds seconds"
    }
}

// Custom data class extensions
data class Person(val id: String, val name: String, val email: String, val age: Int)

fun Person.isAdult(): Boolean = this.age >= 18
fun Person.isMinor(): Boolean = this.age < 18
fun Person.ageGroup(): String = when {
    this.age < 13 -> "Child"
    this.age < 20 -> "Teenager"
    this.age < 30 -> "Young Adult"
    this.age < 60 -> "Adult"
    else -> "Senior"
}

fun Person.emailDomain(): String = this.email.substringAfter("@")
fun Person.initials(): String = this.name.split(" ").mapNotNull { it.firstOrNull() }.joinToString("")
fun Person.displayName(): String = "${this.name} (${this.age})"

data class Product(val id: String, val name: String, val price: Double, val category: String, val inStock: Boolean)

fun Product.isExpensive(): Boolean = this.price > 100.0
fun Product.isCheap(): Boolean = this.price < 20.0
fun Product.isAvailable(): Boolean = this.inStock
fun Product.priceRange(): String = when {
    this.price < 20 -> "Budget"
    this.price < 50 -> "Mid-range"
    this.price < 100 -> "Premium"
    else -> "Luxury"
}

fun Product.discountedPrice(discount: Double): Double = this.price * (1 - discount)
fun Product.withDiscount(discount: Double): Product = this.copy(price = this.discountedPrice(discount))
fun Product.categoryPrefix(): String = this.category.take(3).uppercase()

data class Order(val id: String, val items: List<Product>, val customerEmail: String, val timestamp: Long)

fun Order.totalAmount(): Double = this.items.sumOf { it.price }
fun Order.itemCount(): Int = this.items.size
fun Order.hasExpensiveItems(): Boolean = this.items.any { it.isExpensive() }
fun Order.categorySummary(): Map<String, Int> = this.items.groupBy { it.category }.mapValues { it.value.size }
fun Order.averageItemPrice(): Double = if (this.items.isNotEmpty()) this.items.map { it.price }.average() else 0.0
fun Order.customerDomain(): String = this.customerEmail.substringAfter("@")
fun Order.isRecent(): Boolean = (getCurrentTimeMillis() - this.timestamp) < 86400000 // 24 hours
fun Order.ageInHours(): Long = (getCurrentTimeMillis() - this.timestamp) / 3600000

// Complex domain-specific extensions
data class BankAccount(val accountNumber: String, val balance: Double, val currency: String, val type: String)

fun BankAccount.isOverdrawn(): Boolean = this.balance < 0
fun BankAccount.hasPositiveBalance(): Boolean = this.balance > 0
fun BankAccount.balanceFormatted(): String = this.balance.formatCurrency(this.currency)
fun BankAccount.accountType(): String = this.type.replaceFirstChar { it.uppercase() }
fun BankAccount.canWithdraw(amount: Double): Boolean = this.balance >= amount
fun BankAccount.withdraw(amount: Double): BankAccount = this.copy(balance = this.balance - amount)
fun BankAccount.deposit(amount: Double): BankAccount = this.copy(balance = this.balance + amount)
fun BankAccount.transfer(amount: Double, targetAccount: BankAccount): Pair<BankAccount, BankAccount> {
    return if (this.canWithdraw(amount)) {
        Pair(this.withdraw(amount), targetAccount.deposit(amount))
    } else {
        Pair(this, targetAccount)
    }
}

data class Transaction(val id: String, val amount: Double, val type: String, val timestamp: Long, val description: String)

fun Transaction.isDebit(): Boolean = this.amount < 0
fun Transaction.isCredit(): Boolean = this.amount > 0
fun Transaction.amountFormatted(): String = this.amount.formatCurrency()
fun Transaction.typeCapitalized(): String = this.type.replaceFirstChar { it.uppercase() }
fun Transaction.isToday(): Boolean = (getCurrentTimeMillis() - this.timestamp) < 86400000
fun Transaction.daysAgo(): Long = (getCurrentTimeMillis() - this.timestamp) / 86400000
fun Transaction.category(): String = when {
    this.description.contains("grocery", ignoreCase = true) -> "Groceries"
    this.description.contains("gas", ignoreCase = true) -> "Transportation"
    this.description.contains("restaurant", ignoreCase = true) -> "Dining"
    this.description.contains("salary", ignoreCase = true) -> "Income"
    else -> "Other"
}

// File/Path extensions
fun String.fileExtension(): String = this.substringAfterLast(".", "")
fun String.fileName(): String = this.substringAfterLast("/")
fun String.filePath(): String = this.substringBeforeLast("/")
fun String.isImageFile(): Boolean = this.fileExtension().lowercase() in listOf("jpg", "jpeg", "png", "gif", "bmp")
fun String.isTextFile(): Boolean = this.fileExtension().lowercase() in listOf("txt", "md", "doc", "docx")
fun String.isExecutable(): Boolean = this.fileExtension().lowercase() in listOf("exe", "app", "deb", "dmg")

// URL extensions
fun String.isValidUrl(): Boolean = this.startsWith("http://") || this.startsWith("https://")
fun String.domain(): String = if (this.isValidUrl()) {
    this.removePrefix("https://").removePrefix("http://").substringBefore("/")
} else ""
fun String.protocol(): String = when {
    this.startsWith("https://") -> "HTTPS"
    this.startsWith("http://") -> "HTTP"
    else -> "Unknown"
}
fun String.isSecureUrl(): Boolean = this.startsWith("https://")

// Validation extensions
fun String.isNumeric(): Boolean = this.toDoubleOrNull() != null
fun String.isAlphabetic(): Boolean = this.all { it.isLetter() }
fun String.isAlphanumeric(): Boolean = this.all { it.isLetterOrDigit() }
fun String.hasUppercase(): Boolean = this.any { it.isUpperCase() }
fun String.hasLowercase(): Boolean = this.any { it.isLowerCase() }
fun String.hasDigits(): Boolean = this.any { it.isDigit() }
fun String.hasSpecialChars(): Boolean = this.any { !it.isLetterOrDigit() }
fun String.isStrongPassword(): Boolean = this.length >= 8 && this.hasUppercase() && this.hasLowercase() && this.hasDigits() && this.hasSpecialChars()

// Functional extensions
fun <T, R> T.applyIf(condition: Boolean, transform: (T) -> R): T = if (condition) transform(this) as T else this
fun <T> T.takeIf(predicate: (T) -> Boolean): T? = if (predicate(this)) this else null
fun <T> T.takeUnless(predicate: (T) -> Boolean): T? = if (!predicate(this)) this else null

// Network/API extensions
data class ApiResponse<T>(val data: T?, val status: Int, val message: String)

fun <T> ApiResponse<T>.isSuccess(): Boolean = this.status in 200..299
fun <T> ApiResponse<T>.isError(): Boolean = this.status >= 400
fun <T> ApiResponse<T>.isClientError(): Boolean = this.status in 400..499
fun <T> ApiResponse<T>.isServerError(): Boolean = this.status in 500..599
fun <T> ApiResponse<T>.hasData(): Boolean = this.data != null

// Configuration extensions
data class AppConfig(val apiUrl: String, val timeout: Long, val retries: Int, val debug: Boolean)

fun AppConfig.isProduction(): Boolean = !this.debug
fun AppConfig.isDevelopment(): Boolean = this.debug
fun AppConfig.timeoutInSeconds(): Long = this.timeout / 1000
fun AppConfig.hasRetries(): Boolean = this.retries > 0
fun AppConfig.maxRetries(): Int = maxOf(this.retries, 1)

// Gaming extensions
data class Player(val id: String, val name: String, val level: Int, val experience: Int, val achievements: List<String>)

fun Player.isMaxLevel(): Boolean = this.level >= 100
fun Player.experienceToNextLevel(): Int = (this.level + 1) * 1000 - this.experience
fun Player.progressToNextLevel(): Double = this.experience.toDouble() / ((this.level + 1) * 1000)
fun Player.hasAchievement(achievement: String): Boolean = achievement in this.achievements
fun Player.achievementCount(): Int = this.achievements.size
fun Player.isVeteran(): Boolean = this.hasAchievement("veteran")
fun Player.displayLevel(): String = "Level ${this.level}"
fun Player.rankTitle(): String = when {
    this.level < 10 -> "Novice"
    this.level < 25 -> "Apprentice"
    this.level < 50 -> "Expert"
    this.level < 75 -> "Master"
    else -> "Grandmaster"
}

// Main benchmark class demonstrating extension function usage
class IosSizeBenchmark {
    
    fun runBenchmark() {
        // String extension demonstrations
        val emails = listOf(
            "john.doe@example.com",
            "invalid-email",
            "jane.smith@test.org",
            "not-an-email-at-all",
            "admin@company.co.uk"
        )
        
        val validEmails = emails.filter { it.isValidEmail() }
        val maskedEmails = validEmails.map { it.maskEmail() }
        
        val phones = listOf(
            "+1-555-123-4567",
            "555.123.4567",
            "(555) 123-4567",
            "5551234567",
            "invalid-phone"
        )
        
        val validPhones = phones.filter { it.isValidPhone() }
        
        val texts = listOf(
            "hello world programming",
            "the quick brown fox jumps over the lazy dog",
            "a man a plan a canal panama",
            "racecar level madam",
            "this is a sample text with numbers 123 and 456"
        )
        
        texts.forEach { text ->
            val titleCase = text.toTitleCase()
            val camelCase = text.toCamelCase()
            val snakeCase = text.toSnakeCase()
            val truncated = text.truncate(20)
            val wordCount = text.countWords()
            val isPalindrome = text.isPalindrome()
            val numbers = text.extractNumbers()
            val frequency = text.wordFrequency()
        }
        
        // Number extension demonstrations
        val numbers = listOf(2, 3, 4, 5, 7, 8, 10, 11, 13, 17, 25, 30)
        
        numbers.forEach { num ->
            val isEven = num.isEven()
            val isOdd = num.isOdd()
            val isPrime = num.isPrime()
            val factorial = if (num <= 10) num.factorial() else 0L
            val roman = if (num <= 50) num.toRoman() else ""
        }
        
        val prices = listOf(19.99, 45.50, 123.75, 999.99, 0.50)
        prices.forEach { price ->
            val currency = price.formatCurrency()
            val percentage = (price / 1000).toPercentage()
            val rounded = price.round(1)
        }
        
        // Collection extension demonstrations
        val wordList = listOf("apple", "banana", "cherry", "date", "elderberry", "fig", "grape")
        
        val secondItem = wordList.second()
        val thirdItem = wordList.third()
        val secondToLastItem = wordList.secondToLast()
        val randomItems = wordList.takeRandom(3)
        val (shortWords, longWords) = wordList.split { it.length <= 5 }
        val chunks = wordList.chunks(3)
        val frequency = wordList.frequencyMap()
        val rotatedLeft = wordList.rotateLeft(2)
        val rotatedRight = wordList.rotateRight(2)
        
        val duplicateList = listOf("a", "b", "c", "a", "b", "d", "e", "a")
        val duplicates = duplicateList.duplicates()
        val unique = duplicateList.unique()
        
        // Map extension demonstrations
        val scoreMap = mapOf("Alice" to 95, "Bob" to 87, "Charlie" to 92, "David" to 78, "Eve" to 89)
        
        val highScores = scoreMap.filterByValues { it > 85 }
        val swappedMap = scoreMap.swap()
        val defaultScore = scoreMap.getOrDefault("Unknown", 0)
        
        // Time extension demonstrations
        val timestamps = listOf<Long>(
            getCurrentTimeMillis() - 3600000,  // 1 hour ago
            getCurrentTimeMillis() - 86400000, // 1 day ago
            getCurrentTimeMillis() - 604800000 // 1 week ago
        )
        
        timestamps.forEach { timestamp: Long ->
            val dateString = timestamp.toDateString()
            val duration = (getCurrentTimeMillis() - timestamp).formatDuration()
        }
        
        // Custom data class extension demonstrations
        val persons = listOf(
            Person("1", "John Doe", "john@example.com", 25),
            Person("2", "Jane Smith", "jane@test.com", 17),
            Person("3", "Bob Johnson", "bob@company.org", 45),
            Person("4", "Alice Brown", "alice@email.net", 35)
        )
        
        persons.forEach { person ->
            val isAdult = person.isAdult()
            val ageGroup = person.ageGroup()
            val domain = person.emailDomain()
            val initials = person.initials()
            val displayName = person.displayName()
        }
        
        val adults = persons.filter { it.isAdult() }
        val minors = persons.filter { it.isMinor() }
        val ageGroups = persons.groupBy { it.ageGroup() }
        
        // Product extension demonstrations
        val products = listOf(
            Product("1", "Laptop", 899.99, "Electronics", true),
            Product("2", "Coffee Mug", 12.50, "Kitchen", true),
            Product("3", "Designer Watch", 1299.99, "Accessories", false),
            Product("4", "Book", 15.99, "Books", true),
            Product("5", "Smartphone", 699.99, "Electronics", true)
        )
        
        products.forEach { product ->
            val isExpensive = product.isExpensive()
            val priceRange = product.priceRange()
            val discounted = product.withDiscount(0.10)
            val prefix = product.categoryPrefix()
        }
        
        val availableProducts = products.filter { it.isAvailable() }
        val expensiveProducts = products.filter { it.isExpensive() }
        val electronicsProducts = products.filter { it.category == "Electronics" }
        
        // Order extension demonstrations
        val orders = listOf(
            Order("1", products.take(2), "customer1@email.com", getCurrentTimeMillis() - 3600000),
            Order("2", products.drop(2).take(2), "customer2@test.com", getCurrentTimeMillis() - 86400000),
            Order("3", products.takeLast(1), "customer3@company.org", getCurrentTimeMillis() - 7200000)
        )
        
        orders.forEach { order ->
            val total = order.totalAmount()
            val itemCount = order.itemCount()
            val hasExpensive = order.hasExpensiveItems()
            val categories = order.categorySummary()
            val averagePrice = order.averageItemPrice()
            val domain = order.customerDomain()
            val isRecent = order.isRecent()
            val age = order.ageInHours()
        }
        
        // Banking extension demonstrations
        val accounts = listOf(
            BankAccount("12345", 1500.50, "USD", "checking"),
            BankAccount("67890", -200.00, "USD", "checking"),
            BankAccount("11111", 5000.00, "EUR", "savings"),
            BankAccount("22222", 0.00, "USD", "savings")
        )
        
        accounts.forEach { account ->
            val isOverdrawn = account.isOverdrawn()
            val formatted = account.balanceFormatted()
            val canWithdraw = account.canWithdraw(100.0)
            val type = account.accountType()
        }
        
        val overdrawnAccounts = accounts.filter { it.isOverdrawn() }
        val positiveBalances = accounts.filter { it.hasPositiveBalance() }
        
        // Transaction processing
        val transactions = listOf(
            Transaction("1", -50.00, "debit", getCurrentTimeMillis(), "Grocery Store"),
            Transaction("2", 2500.00, "credit", getCurrentTimeMillis() - 86400000, "Salary Payment"),
            Transaction("3", -75.50, "debit", getCurrentTimeMillis() - 3600000, "Gas Station"),
            Transaction("4", -120.00, "debit", getCurrentTimeMillis() - 7200000, "Restaurant Dinner")
        )
        
        transactions.forEach { transaction ->
            val isDebit = transaction.isDebit()
            val formatted = transaction.amountFormatted()
            val category = transaction.category()
            val daysAgo = transaction.daysAgo()
        }
        
        val recentTransactions = transactions.filter { it.isToday() }
        val debits = transactions.filter { it.isDebit() }
        val credits = transactions.filter { it.isCredit() }
        
        // File path demonstrations
        val filePaths = listOf(
            "/home/user/documents/report.pdf",
            "/var/log/system.log",
            "/usr/bin/application.exe",
            "/home/photos/vacation.jpg",
            "/downloads/music.mp3"
        )
        
        filePaths.forEach { path ->
            val extension = path.fileExtension()
            val fileName = path.fileName()
            val directory = path.filePath()
            val isImage = path.isImageFile()
            val isText = path.isTextFile()
            val isExecutable = path.isExecutable()
        }
        
        // URL demonstrations
        val urls = listOf(
            "https://www.example.com/page",
            "http://api.service.org/data",
            "https://secure.bank.com/login",
            "ftp://files.domain.net/download",
            "invalid-url"
        )
        
        urls.forEach { url ->
            val isValid = url.isValidUrl()
            val domain = url.domain()
            val protocol = url.protocol()
            val isSecure = url.isSecureUrl()
        }
        
        // Password validation
        val passwords = listOf(
            "Password123!",
            "weakpass",
            "ONLYUPPER",
            "onlylower",
            "12345678",
            "Strong1Pass!"
        )
        
        passwords.forEach { password ->
            val isStrong = password.isStrongPassword()
            val hasUpper = password.hasUppercase()
            val hasLower = password.hasLowercase()
            val hasDigits = password.hasDigits()
            val hasSpecial = password.hasSpecialChars()
        }
        
        val strongPasswords = passwords.filter { it.isStrongPassword() }
        
        // API response demonstrations
        val apiResponses = listOf(
            ApiResponse("Success data", 200, "OK"),
            ApiResponse(null, 404, "Not Found"),
            ApiResponse("Server data", 500, "Internal Server Error"),
            ApiResponse("Created", 201, "Created")
        )
        
        apiResponses.forEach { response ->
            val isSuccess = response.isSuccess()
            val isError = response.isError()
            val isClientError = response.isClientError()
            val hasData = response.hasData()
        }
        
        // Gaming demonstrations
        val players = listOf(
            Player("1", "ProGamer", 95, 94500, listOf("veteran", "champion", "speedrun")),
            Player("2", "Newbie", 5, 4200, listOf("first_login")),
            Player("3", "Expert", 45, 44800, listOf("veteran", "collector", "explorer")),
            Player("4", "Master", 78, 77100, listOf("veteran", "champion", "mentor"))
        )
        
        players.forEach { player ->
            val isMaxLevel = player.isMaxLevel()
            val expToNext = player.experienceToNextLevel()
            val progress = player.progressToNextLevel()
            val isVeteran = player.isVeteran()
            val achievementCount = player.achievementCount()
            val title = player.rankTitle()
        }
        
        val veterans = players.filter { it.isVeteran() }
        val highLevelPlayers = players.filter { it.level > 50 }
        
        // Complex chaining demonstrations
        val processedData = texts
            .filter { it.length > 10 }
            .map { it.toTitleCase() }
            .map { it.truncate(30) }
            .filter { it.countWords() > 3 }
            .map { text -> 
                mapOf(
                    "text" to text,
                    "wordCount" to text.countWords(),
                    "hasNumbers" to text.extractNumbers().isNotEmpty(),
                    "frequency" to text.wordFrequency()
                )
            }
        
        val userAnalysis = persons
            .filter { it.isAdult() }
            .groupBy { it.ageGroup() }
            .mapValues { (_, people) ->
                mapOf(
                    "count" to people.size,
                    "averageAge" to people.map { it.age }.average(),
                    "domains" to people.map { it.emailDomain() }.distinct()
                )
            }
        
        val productAnalysis = products
            .filter { it.isAvailable() }
            .groupBy { it.priceRange() }
            .mapValues { (_, prods) ->
                mapOf(
                    "count" to prods.size,
                    "averagePrice" to prods.map { it.price }.average(),
                    "categories" to prods.map { it.category }.distinct()
                )
            }
    }
}