/*
 * iOS Size Benchmark - Test Case Implementation
 * Generated with Claude AI (https://claude.ai)
 * 
 * This Swift implementation demonstrates language-specific
 * features and patterns for binary size comparison.
 */

import Foundation

// Test case: Extension Functions - Swift equivalent using extensions and utility classes

// String extensions - Swift equivalent to Kotlin's extension functions
public extension String {
    
    public func isValidEmail() -> Bool {
        return self.contains("@") && self.contains(".") && self.count > 5
    }
    
    public func isValidPhone() -> Bool {
        let cleaned = self.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        return cleaned.count >= 10 && cleaned.count <= 15
    }
    
    public func toTitleCase() -> String {
        return self.components(separatedBy: " ")
            .map { word in
                word.lowercased().prefix(1).capitalized + word.lowercased().dropFirst()
            }
            .joined(separator: " ")
    }
    
    public func toCamelCase() -> String {
        let components = self.components(separatedBy: CharacterSet(charactersIn: " _-"))
            .filter { !$0.isEmpty }
        
        guard !components.isEmpty else { return "" }
        
        let first = components[0].lowercased()
        let rest = components.dropFirst().map { $0.lowercased().prefix(1).capitalized + $0.lowercased().dropFirst() }
        
        return ([first] + rest).joined()
    }
    
    public func toSnakeCase() -> String {
        let result = self.replacingOccurrences(of: "([a-z])([A-Z])", with: "$1_$2", options: .regularExpression)
            .replacingOccurrences(of: " ", with: "_")
            .replacingOccurrences(of: "-", with: "_")
        return result.lowercased()
    }
    
    public func truncate(maxLength: Int, suffix: String = "...") -> String {
        if self.count <= maxLength {
            return self
        }
        let endIndex = self.index(self.startIndex, offsetBy: maxLength - suffix.count)
        return String(self[..<endIndex]) + suffix
    }
    
    public func removeWhitespace() -> String {
        return self.replacingOccurrences(of: "\\s", with: "", options: .regularExpression)
    }
    
    public func countWords() -> Int {
        let trimmed = self.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmed.isEmpty { return 0 }
        return trimmed.components(separatedBy: .whitespacesAndNewlines).filter { !$0.isEmpty }.count
    }
    
    public func reverse() -> String {
        return String(self.reversed())
    }
    
    public func isPalindrome() -> Bool {
        let cleaned = self.removeWhitespace().lowercased()
        return cleaned == cleaned.reverse()
    }
    
    public func extractNumbers() -> [Int] {
        let regex = try! NSRegularExpression(pattern: "\\d+", options: [])
        let matches = regex.matches(in: self, options: [], range: NSRange(location: 0, length: self.count))
        
        return matches.compactMap { match in
            let range = Range(match.range, in: self)
            return range.flatMap { Int(String(self[$0])) }
        }
    }
    
    public func extractEmails() -> [String] {
        let pattern = "[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let regex = try! NSRegularExpression(pattern: pattern, options: [])
        let matches = regex.matches(in: self, options: [], range: NSRange(location: 0, length: self.count))
        
        return matches.compactMap { match in
            let range = Range(match.range, in: self)
            return range.map { String(self[$0]) }
        }
    }
    
    public func maskEmail() -> String {
        if self.isValidEmail() {
            let parts = self.components(separatedBy: "@")
            guard parts.count == 2 else { return self }
            
            let username = parts[0]
            let domain = parts[1]
            
            let maskedUsername: String
            if username.count <= 2 {
                maskedUsername = "**"
            } else {
                maskedUsername = String(username.prefix(2)) + String(repeating: "*", count: username.count - 2)
            }
            
            return "\(maskedUsername)@\(domain)"
        }
        return self
    }
    
    public func emailDomain() -> String {
        if self.isValidEmail() {
            let parts = self.components(separatedBy: "@")
            return parts.count > 1 ? parts[1] : ""
        }
        return ""
    }
    
    public func wordFrequency() -> [String: Int] {
        let words = self.lowercased()
            .components(separatedBy: CharacterSet.alphanumerics.inverted)
            .filter { !$0.isEmpty }
        
        var frequency: [String: Int] = [:]
        for word in words {
            frequency[word, default: 0] += 1
        }
        return frequency
    }
}

// Number extensions
public extension Int {
    public func isEven() -> Bool { return self % 2 == 0 }
    public func isOdd() -> Bool { return self % 2 != 0 }
    
    public func isPrime() -> Bool {
        if self < 2 { return false }
        for i in 2...Int(sqrt(Double(self))) {
            if self % i == 0 { return false }
        }
        return true
    }
    
    public func factorial() -> Int64 {
        if self <= 1 { return 1 }
        return Int64(self) * Int64(self - 1).factorial()
    }
    
    public func toRoman() -> String {
        let values = [1000, 900, 500, 400, 100, 90, 50, 40, 10, 9, 5, 4, 1]
        let symbols = ["M", "CM", "D", "CD", "C", "XC", "L", "XL", "X", "IX", "V", "IV", "I"]
        
        var num = self
        var result = ""
        
        for (value, symbol) in zip(values, symbols) {
            while num >= value {
                result += symbol
                num -= value
            }
        }
        return result
    }
}

public extension Int64 {
    public func factorial() -> Int64 {
        if self <= 1 { return 1 }
        return self * (self - 1).factorial()
    }
}

public extension Double {
    public func formatCurrency(currency: String = "USD") -> String {
        return String(format: "%.2f %@", self, currency)
    }
    
    public func toPercentage() -> String {
        return String(format: "%.1f%%", self * 100)
    }
    
    public func round(decimals: Int) -> Double {
        let factor = pow(10.0, Double(decimals))
        return Darwin.round(self * factor) / factor
    }
}

// Collection extensions
public extension Array {
    public func second() -> Element? {
        return self.count >= 2 ? self[1] : nil
    }
    
    public func third() -> Element? {
        return self.count >= 3 ? self[2] : nil
    }
    
    public func secondToLast() -> Element? {
        return self.count >= 2 ? self[self.count - 2] : nil
    }
    
    public func takeRandom(count: Int) -> [Element] {
        return Array(self.shuffled().prefix(count))
    }
    
    public func split(predicate: (Element) -> Bool) -> ([Element], [Element]) {
        var first: [Element] = []
        var second: [Element] = []
        
        for element in self {
            if predicate(element) {
                first.append(element)
            } else {
                second.append(element)
            }
        }
        return (first, second)
    }
    
    public func chunks(size: Int) -> [[Element]] {
        var result: [[Element]] = []
        var currentChunk: [Element] = []
        
        for element in self {
            currentChunk.append(element)
            if currentChunk.count == size {
                result.append(currentChunk)
                currentChunk = []
            }
        }
        
        if !currentChunk.isEmpty {
            result.append(currentChunk)
        }
        
        return result
    }
    
    public func rotateLeft(positions: Int) -> [Element] {
        guard !self.isEmpty else { return self }
        let pos = positions % self.count
        return Array(self.dropFirst(pos) + self.prefix(pos))
    }
    
    public func rotateRight(positions: Int) -> [Element] {
        guard !self.isEmpty else { return self }
        let pos = positions % self.count
        return Array(self.suffix(pos) + self.dropLast(pos))
    }
}

public extension Array where Element: Hashable {
    public func frequencyMap() -> [Element: Int] {
        var frequency: [Element: Int] = [:]
        for element in self {
            frequency[element, default: 0] += 1
        }
        return frequency
    }
    
    public func duplicates() -> [Element] {
        let frequency = self.frequencyMap()
        return Array(frequency.filter { $0.value > 1 }.keys)
    }
    
    public func unique() -> [Element] {
        return Array(Set(self))
    }
}

// Dictionary extensions
public extension Dictionary {
    public func filterByKeys(predicate: (Key) -> Bool) -> [Key: Value] {
        return self.filter { predicate($0.key) }
    }
    
    public func filterByValues(predicate: (Value) -> Bool) -> [Key: Value] {
        return self.filter { predicate($0.value) }
    }
    
    public func getOrDefault(key: Key, defaultValue: Value) -> Value {
        return self[key] ?? defaultValue
    }
}

extension Dictionary where Value: Hashable {
    public func swap() -> [Value: Key] {
        var result: [Value: Key] = [:]
        for (key, value) in self {
            result[value] = key
        }
        return result
    }
}

// Date/Time extensions using Int64 for cross-platform compatibility
extension Int64 {
    public func toDateString() -> String {
        let seconds = self / 1000
        let minutes = seconds / 60
        let hours = minutes / 60
        let days = hours / 24
        
        switch (days, hours, minutes, seconds) {
        case (let d, _, _, _) where d > 0:
            return "\(d) days ago"
        case (_, let h, _, _) where h > 0:
            return "\(h) hours ago"
        case (_, _, let m, _) where m > 0:
            return "\(m) minutes ago"
        default:
            return "\(seconds) seconds ago"
        }
    }
    
    public func formatDuration() -> String {
        let hours = self / 3600000
        let minutes = (self % 3600000) / 60000
        let seconds = (self % 60000) / 1000
        
        switch (hours, minutes) {
        case (let h, let m) where h > 0:
            return String(format: "%d:%02d:%02d", h, m, seconds)
        case (_, let m) where m > 0:
            return String(format: "%d:%02d", m, seconds)
        default:
            return "\(seconds) seconds"
        }
    }
}

// Custom data class extensions
public struct Person {
    public let id: String
    public let name: String
    public let email: String
    public let age: Int
}

extension Person {
    public func isAdult() -> Bool { return age >= 18 }
    public func isMinor() -> Bool { return age < 18 }
    
    public func ageGroup() -> String {
        switch age {
        case 0..<13: return "Child"
        case 13..<20: return "Teenager"
        case 20..<30: return "Young Adult"
        case 30..<60: return "Adult"
        default: return "Senior"
        }
    }
    
    public func emailDomain() -> String {
        return String(email.split(separator: "@").last ?? "")
    }
    
    public func initials() -> String {
        return name.components(separatedBy: " ")
            .compactMap { $0.first }
            .map { String($0) }
            .joined()
    }
    
    public func displayName() -> String {
        return "\(name) (\(age))"
    }
}

public struct Product: Hashable {
    public let id: String
    public let name: String
    public let price: Double
    public let category: String
    public let inStock: Bool
}

extension Product {
    public func isExpensive() -> Bool { return price > 100.0 }
    public func isCheap() -> Bool { return price < 20.0 }
    public func isAvailable() -> Bool { return inStock }
    
    public func priceRange() -> String {
        switch price {
        case 0..<20: return "Budget"
        case 20..<50: return "Mid-range"
        case 50..<100: return "Premium"
        default: return "Luxury"
        }
    }
    
    public func discountedPrice(discount: Double) -> Double {
        return price * (1 - discount)
    }
    
    public func withDiscount(discount: Double) -> Product {
        return Product(id: id, name: name, price: discountedPrice(discount: discount), category: category, inStock: inStock)
    }
    
    public func categoryPrefix() -> String {
        return String(category.prefix(3).uppercased())
    }
}

public struct Order {
    let id: String
    let items: [Product]
    let customerEmail: String
    let timestamp: Int64
}

extension Order {
    public func totalAmount() -> Double { return items.reduce(0) { $0 + $1.price } }
    public func itemCount() -> Int { return items.count }
    public func hasExpensiveItems() -> Bool { return items.contains { $0.isExpensive() } }
    
    public func categorySummary() -> [String: Int] {
        return items.map { $0.category }.frequencyMap()
    }
    
    public func averageItemPrice() -> Double {
        return items.isEmpty ? 0.0 : totalAmount() / Double(items.count)
    }
    
    public func customerDomain() -> String {
        return customerEmail.emailDomain()
    }
    
    public func isRecent() -> Bool {
        return (Int64(Date().timeIntervalSince1970 * 1000) - timestamp) < 86400000 // 24 hours
    }
    
    public func ageInHours() -> Int64 {
        return (Int64(Date().timeIntervalSince1970 * 1000) - timestamp) / 3600000
    }
}

// Banking extensions
public struct BankAccount {
    let accountNumber: String
    let balance: Double
    let currency: String
    let type: String
}

extension BankAccount {
    public func isOverdrawn() -> Bool { return balance < 0 }
    public func hasPositiveBalance() -> Bool { return balance > 0 }
    public func balanceFormatted() -> String { return balance.formatCurrency(currency: currency) }
    public func accountType() -> String { return type.capitalized }
    public func canWithdraw(amount: Double) -> Bool { return balance >= amount }
    
    public func withdraw(amount: Double) -> BankAccount {
        return BankAccount(accountNumber: accountNumber, balance: balance - amount, currency: currency, type: type)
    }
    
    public func deposit(amount: Double) -> BankAccount {
        return BankAccount(accountNumber: accountNumber, balance: balance + amount, currency: currency, type: type)
    }
    
    public func transfer(amount: Double, targetAccount: BankAccount) -> (BankAccount?, BankAccount?) {
        if canWithdraw(amount: amount) {
            return (withdraw(amount: amount), targetAccount.deposit(amount: amount))
        } else {
            return (nil, nil)
        }
    }
}

public struct Transaction {
    let id: String
    let amount: Double
    let type: String
    let timestamp: Int64
    let description: String
}

extension Transaction {
    public func isDebit() -> Bool { return amount < 0 }
    public func isCredit() -> Bool { return amount > 0 }
    public func amountFormatted() -> String { return amount.formatCurrency() }
    public func typeCapitalized() -> String { return type.capitalized }
    public func isToday() -> Bool { return (Int64(Date().timeIntervalSince1970 * 1000) - timestamp) < 86400000 }
    public func daysAgo() -> Int64 { return (Int64(Date().timeIntervalSince1970 * 1000) - timestamp) / 86400000 }
    
    public func category() -> String {
        let desc = description.lowercased()
        if desc.contains("grocery") { return "Groceries" }
        if desc.contains("gas") { return "Transportation" }
        if desc.contains("restaurant") { return "Dining" }
        if desc.contains("salary") { return "Income" }
        return "Other"
    }
}

// File/Path extensions
extension String {
    public func fileExtension() -> String {
        return (self as NSString).pathExtension
    }
    
    public func fileName() -> String {
        return (self as NSString).lastPathComponent
    }
    
    public func filePath() -> String {
        return (self as NSString).deletingLastPathComponent
    }
    
    public func isImageFile() -> Bool {
        let imageExtensions = ["jpg", "jpeg", "png", "gif", "bmp"]
        return imageExtensions.contains(fileExtension().lowercased())
    }
    
    public func isTextFile() -> Bool {
        let textExtensions = ["txt", "md", "doc", "docx"]
        return textExtensions.contains(fileExtension().lowercased())
    }
    
    public func isExecutable() -> Bool {
        let executableExtensions = ["exe", "app", "deb", "dmg"]
        return executableExtensions.contains(fileExtension().lowercased())
    }
}

// URL extensions
extension String {
    public func isValidUrl() -> Bool {
        return hasPrefix("http://") || hasPrefix("https://")
    }
    
    public func domain() -> String {
        if isValidUrl() {
            let withoutProtocol = replacingOccurrences(of: "https://", with: "")
                .replacingOccurrences(of: "http://", with: "")
            return String(withoutProtocol.split(separator: "/").first ?? "")
        }
        return ""
    }
    
    public func `protocol`() -> String {
        if hasPrefix("https://") { return "HTTPS" }
        if hasPrefix("http://") { return "HTTP" }
        return "Unknown"
    }
    
    public func isSecureUrl() -> Bool {
        return hasPrefix("https://")
    }
}

// Validation extensions
extension String {
    public func isNumeric() -> Bool { return Double(self) != nil }
    public func isAlphabetic() -> Bool { return allSatisfy { $0.isLetter } }
    public func isAlphanumeric() -> Bool { return allSatisfy { $0.isLetter || $0.isNumber } }
    public func hasUppercase() -> Bool { return contains { $0.isUppercase } }
    public func hasLowercase() -> Bool { return contains { $0.isLowercase } }
    public func hasDigits() -> Bool { return contains { $0.isNumber } }
    public func hasSpecialChars() -> Bool { return contains { !$0.isLetter && !$0.isNumber } }
    
    public func isStrongPassword() -> Bool {
        return count >= 8 && hasUppercase() && hasLowercase() && hasDigits() && hasSpecialChars()
    }
}

// API response extensions
public struct ApiResponse<T> {
    let data: T?
    let status: Int
    let message: String
}

extension ApiResponse {
    public func isSuccess() -> Bool { return status >= 200 && status < 300 }
    public func isError() -> Bool { return status >= 400 }
    public func isClientError() -> Bool { return status >= 400 && status < 500 }
    public func isServerError() -> Bool { return status >= 500 }
    public func hasData() -> Bool { return data != nil }
}

// Configuration extensions
public struct AppConfig {
    let apiUrl: String
    let timeout: Int64
    let retries: Int
    let debug: Bool
}

extension AppConfig {
    public func isProduction() -> Bool { return !debug }
    public func isDevelopment() -> Bool { return debug }
    public func timeoutInSeconds() -> Int64 { return timeout / 1000 }
    public func hasRetries() -> Bool { return retries > 0 }
    public func maxRetries() -> Int { return max(retries, 1) }
}

// Gaming extensions
public struct Player {
    let id: String
    let name: String
    let level: Int
    let experience: Int
    let achievements: [String]
}

extension Player {
    public func isMaxLevel() -> Bool { return level >= 100 }
    public func experienceToNextLevel() -> Int { return (level + 1) * 1000 - experience }
    public func progressToNextLevel() -> Double { return Double(experience) / Double((level + 1) * 1000) }
    public func hasAchievement(achievement: String) -> Bool { return achievements.contains(achievement) }
    public func achievementCount() -> Int { return achievements.count }
    public func isVeteran() -> Bool { return hasAchievement(achievement: "veteran") }
    public func displayLevel() -> String { return "Level \(level)" }
    
    public func rankTitle() -> String {
        switch level {
        case 0..<10: return "Novice"
        case 10..<25: return "Apprentice"
        case 25..<50: return "Expert"
        case 50..<75: return "Master"
        default: return "Grandmaster"
        }
    }
}

// Main benchmark class demonstrating Swift extension usage vs Kotlin's concise syntax
public class IosSizeBenchmark {
    
    public func runBenchmark() {
        // String extension demonstrations
        let emails = [
            "john.doe@example.com",
            "invalid-email",
            "jane.smith@test.org",
            "not-an-email-at-all",
            "admin@company.co.uk"
        ]
        
        let validEmails = emails.filter { $0.isValidEmail() }
        let maskedEmails = validEmails.map { $0.maskEmail() }
        
        let phones = [
            "+1-555-123-4567",
            "555.123.4567",
            "(555) 123-4567",
            "5551234567",
            "invalid-phone"
        ]
        
        let validPhones = phones.filter { $0.isValidPhone() }
        
        let texts = [
            "hello world programming",
            "the quick brown fox jumps over the lazy dog",
            "a man a plan a canal panama",
            "racecar level madam",
            "this is a sample text with numbers 123 and 456"
        ]
        
        texts.forEach { text in
            let titleCase = text.toTitleCase()
            let camelCase = text.toCamelCase()
            let snakeCase = text.toSnakeCase()
            let truncated = text.truncate(maxLength: 20)
            let wordCount = text.countWords()
            let isPalindrome = text.isPalindrome()
            let numbers = text.extractNumbers()
            let frequency = text.wordFrequency()
        }
        
        // Number extension demonstrations
        let numbers = [2, 3, 4, 5, 7, 8, 10, 11, 13, 17, 25, 30]
        
        numbers.forEach { num in
            let isEven = num.isEven()
            let isOdd = num.isOdd()
            let isPrime = num.isPrime()
            let factorial = num <= 10 ? num.factorial() : 0
            let roman = num <= 50 ? num.toRoman() : ""
        }
        
        let prices = [19.99, 45.50, 123.75, 999.99, 0.50]
        prices.forEach { price in
            let currency = price.formatCurrency()
            let percentage = (price / 1000).toPercentage()
            let rounded = price.round(decimals: 1)
        }
        
        // Collection extension demonstrations
        let wordList = ["apple", "banana", "cherry", "date", "elderberry", "fig", "grape"]
        
        let secondItem = wordList.second()
        let thirdItem = wordList.third()
        let secondToLastItem = wordList.secondToLast()
        let randomItems = wordList.takeRandom(count: 3)
        let (shortWords, longWords) = wordList.split { $0.count <= 5 }
        let chunks = wordList.chunks(size: 3)
        let frequency = wordList.frequencyMap()
        let rotatedLeft = wordList.rotateLeft(positions: 2)
        let rotatedRight = wordList.rotateRight(positions: 2)
        
        let duplicateList = ["a", "b", "c", "a", "b", "d", "e", "a"]
        let duplicates = duplicateList.duplicates()
        let unique = duplicateList.unique()
        
        // Dictionary extension demonstrations
        let scoreMap = ["Alice": 95, "Bob": 87, "Charlie": 92, "David": 78, "Eve": 89]
        
        let highScores = scoreMap.filterByValues { $0 > 85 }
        let swappedMap = scoreMap.swap()
        let defaultScore = scoreMap.getOrDefault(key: "Unknown", defaultValue: 0)
        
        // Time extension demonstrations
        let timestamps: [Int64] = [
            Int64(Date().timeIntervalSince1970 * 1000) - 3600000,  // 1 hour ago
            Int64(Date().timeIntervalSince1970 * 1000) - 86400000, // 1 day ago
            Int64(Date().timeIntervalSince1970 * 1000) - 604800000 // 1 week ago
        ]
        
        timestamps.forEach { timestamp in
            let dateString = timestamp.toDateString()
            let duration = (Int64(Date().timeIntervalSince1970 * 1000) - timestamp).formatDuration()
        }
        
        // Custom data extension demonstrations
        let persons = [
            Person(id: "1", name: "John Doe", email: "john@example.com", age: 25),
            Person(id: "2", name: "Jane Smith", email: "jane@test.com", age: 17),
            Person(id: "3", name: "Bob Johnson", email: "bob@company.org", age: 45),
            Person(id: "4", name: "Alice Brown", email: "alice@email.net", age: 35)
        ]
        
        persons.forEach { person in
            let isAdult = person.isAdult()
            let ageGroup = person.ageGroup()
            let domain = person.emailDomain()
            let initials = person.initials()
            let displayName = person.displayName()
        }
        
        let adults = persons.filter { $0.isAdult() }
        let minors = persons.filter { $0.isMinor() }
        let ageGroups = Dictionary(grouping: persons) { $0.ageGroup() }
        
        // Product extension demonstrations
        let products = [
            Product(id: "1", name: "Laptop", price: 899.99, category: "Electronics", inStock: true),
            Product(id: "2", name: "Coffee Mug", price: 12.50, category: "Kitchen", inStock: true),
            Product(id: "3", name: "Designer Watch", price: 1299.99, category: "Accessories", inStock: false),
            Product(id: "4", name: "Book", price: 15.99, category: "Books", inStock: true),
            Product(id: "5", name: "Smartphone", price: 699.99, category: "Electronics", inStock: true)
        ]
        
        products.forEach { product in
            let isExpensive = product.isExpensive()
            let priceRange = product.priceRange()
            let discounted = product.withDiscount(discount: 0.10)
            let prefix = product.categoryPrefix()
        }
        
        let availableProducts = products.filter { $0.isAvailable() }
        let expensiveProducts = products.filter { $0.isExpensive() }
        let electronicsProducts = products.filter { $0.category == "Electronics" }
        
        // Complex chaining demonstrations - showing Swift's extension limitations
        let processedData = texts
            .filter { $0.count > 10 }
            .map { $0.toTitleCase() }
            .map { $0.truncate(maxLength: 30) }
            .filter { $0.countWords() > 3 }
            .map { text -> [String: Any] in
                return [
                    "text": text,
                    "wordCount": text.countWords(),
                    "hasNumbers": !text.extractNumbers().isEmpty,
                    "frequency": text.wordFrequency()
                ]
            }
        
        let userAnalysis = Dictionary(grouping: persons.filter { $0.isAdult() }) { $0.ageGroup() }
            .mapValues { people -> [String: Any] in
                return [
                    "count": people.count,
                    "averageAge": people.map { $0.age }.reduce(0, +) / people.count,
                    "domains": Array(Set(people.map { $0.emailDomain() }))
                ]
            }
        
        let productAnalysis = Dictionary(grouping: products.filter { $0.isAvailable() }) { $0.priceRange() }
            .mapValues { prods -> [String: Any] in
                return [
                    "count": prods.count,
                    "averagePrice": prods.map { $0.price }.reduce(0, +) / Double(prods.count),
                    "categories": Array(Set(prods.map { $0.category }))
                ]
            }
        
        // File path demonstrations
        let filePaths = [
            "/home/user/documents/report.pdf",
            "/var/log/system.log",
            "/usr/bin/application.exe",
            "/home/photos/vacation.jpg",
            "/downloads/music.mp3"
        ]
        
        filePaths.forEach { path in
            let `extension` = path.fileExtension()
            let fileName = path.fileName()
            let directory = path.filePath()
            let isImage = path.isImageFile()
            let isText = path.isTextFile()
            let isExecutable = path.isExecutable()
        }
        
        // URL demonstrations
        let urls = [
            "https://www.example.com/page",
            "http://api.service.org/data",
            "https://secure.bank.com/login",
            "ftp://files.domain.net/download",
            "invalid-url"
        ]
        
        urls.forEach { url in
            let isValid = url.isValidUrl()
            let domain = url.domain()
            let protocolType = url.`protocol`()
            let isSecure = url.isSecureUrl()
        }
        
        // Password validation
        let passwords = [
            "Password123!",
            "weakpass",
            "ONLYUPPER",
            "onlylower",
            "12345678",
            "Strong1Pass!"
        ]
        
        passwords.forEach { password in
            let isStrong = password.isStrongPassword()
            let hasUpper = password.hasUppercase()
            let hasLower = password.hasLowercase()
            let hasDigits = password.hasDigits()
            let hasSpecial = password.hasSpecialChars()
        }
        
        let strongPasswords = passwords.filter { $0.isStrongPassword() }
        
        // Gaming demonstrations
        let players = [
            Player(id: "1", name: "ProGamer", level: 95, experience: 94500, achievements: ["veteran", "champion", "speedrun"]),
            Player(id: "2", name: "Newbie", level: 5, experience: 4200, achievements: ["first_login"]),
            Player(id: "3", name: "Expert", level: 45, experience: 44800, achievements: ["veteran", "collector", "explorer"]),
            Player(id: "4", name: "Master", level: 78, experience: 77100, achievements: ["veteran", "champion", "mentor"])
        ]
        
        players.forEach { player in
            let isMaxLevel = player.isMaxLevel()
            let expToNext = player.experienceToNextLevel()
            let progress = player.progressToNextLevel()
            let isVeteran = player.isVeteran()
            let achievementCount = player.achievementCount()
            let title = player.rankTitle()
        }
        
        let veterans = players.filter { $0.isVeteran() }
        let highLevelPlayers = players.filter { $0.level > 50 }
    }
}