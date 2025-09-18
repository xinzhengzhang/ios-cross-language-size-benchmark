/*
 * iOS Size Benchmark - Test Case Implementation
 * Generated with Claude AI (https://claude.ai)
 * 
 * This Swift implementation demonstrates language-specific
 * features and patterns for binary size comparison.
 */

import Foundation

// Test case: Null Safety - Swift equivalent with optionals and manual nil handling

// User data model with optional fields
public class User {
    public let id: String
    public let name: String?
    public let email: String?
    public let phone: String?
    public let address: Address?
    public let preferences: UserPreferences?
    
    public init(id: String, name: String?, email: String?, phone: String?, address: Address?, preferences: UserPreferences?) {
        self.id = id
        self.name = name
        self.email = email
        self.phone = phone
        self.address = address
        self.preferences = preferences
    }
}

public class Address {
    public let street: String?
    public let city: String?
    public let state: String?
    public let zipCode: String?
    public let country: String?
    
    public init(street: String?, city: String?, state: String?, zipCode: String?, country: String?) {
        self.street = street
        self.city = city
        self.state = state
        self.zipCode = zipCode
        self.country = country
    }
}

public class UserPreferences {
    public let theme: String?
    public let language: String?
    public let notifications: NotificationSettings?
    public let privacy: PrivacySettings?
    
    public init(theme: String?, language: String?, notifications: NotificationSettings?, privacy: PrivacySettings?) {
        self.theme = theme
        self.language = language
        self.notifications = notifications
        self.privacy = privacy
    }
}

public class NotificationSettings {
    public let email: Bool?
    public let push: Bool?
    public let sms: Bool?
    
    public init(email: Bool?, push: Bool?, sms: Bool?) {
        self.email = email
        self.push = push
        self.sms = sms
    }
}

public class PrivacySettings {
    let profileVisibility: String?
    let dataSharing: Bool?
    let analytics: Bool?
    
    public init(profileVisibility: String?, dataSharing: Bool?, analytics: Bool?) {
        self.profileVisibility = profileVisibility
        self.dataSharing = dataSharing
        self.analytics = analytics
    }
}

// Network response models with optional data
public class ApiResponse<T> {
    let data: T?
    let error: ErrorInfo?
    let metadata: ResponseMetadata?
    
    public init(data: T?, error: ErrorInfo?, metadata: ResponseMetadata?) {
        self.data = data
        self.error = error
        self.metadata = metadata
    }
}

public class ErrorInfo {
    let code: String?
    let message: String?
    let details: [String: String]?
    
    public init(code: String?, message: String?, details: [String: String]?) {
        self.code = code
        self.message = message
        self.details = details
    }
}

public class ResponseMetadata {
    let timestamp: Int64?
    let version: String?
    let requestId: String?
    
    init(timestamp: Int64?, version: String?, requestId: String?) {
        self.timestamp = timestamp
        self.version = version
        self.requestId = requestId
    }
}

// Configuration classes with optional settings
public class AppConfig {
    let apiUrl: String?
    let apiKey: String?
    let features: FeatureFlags?
    let cache: CacheConfig?
    let analytics: AnalyticsConfig?
    
    init(apiUrl: String?, apiKey: String?, features: FeatureFlags?, cache: CacheConfig?, analytics: AnalyticsConfig?) {
        self.apiUrl = apiUrl
        self.apiKey = apiKey
        self.features = features
        self.cache = cache
        self.analytics = analytics
    }
}

public class FeatureFlags {
    let newUI: Bool?
    let betaFeatures: Bool?
    let experimentalMode: Bool?
    
    init(newUI: Bool?, betaFeatures: Bool?, experimentalMode: Bool?) {
        self.newUI = newUI
        self.betaFeatures = betaFeatures
        self.experimentalMode = experimentalMode
    }
}

public class CacheConfig {
    let enabled: Bool?
    let maxSize: Int64?
    let ttl: Int64?
    
    init(enabled: Bool?, maxSize: Int64?, ttl: Int64?) {
        self.enabled = enabled
        self.maxSize = maxSize
        self.ttl = ttl
    }
}

public class AnalyticsConfig {
    let enabled: Bool?
    let trackingId: String?
    let samplingRate: Double?
    
    init(enabled: Bool?, trackingId: String?, samplingRate: Double?) {
        self.enabled = enabled
        self.trackingId = trackingId
        self.samplingRate = samplingRate
    }
}

// Service classes demonstrating manual nil handling
public class UserService {
    
    public func getUserDisplayName(user: User?) -> String {
        // Swift's manual nil checking approach
        if let user = user {
            if let name = user.name {
                if !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    return name
                }
            }
        }
        return "Anonymous User"
    }
    
    public func getUserContactInfo(user: User?) -> String {
        // Manual nil checking with multiple optionals
        if let user = user {
            var email: String? = nil
            var phone: String? = nil
            
            if let userEmail = user.email {
                if userEmail.contains("@") {
                    email = userEmail
                }
            }
            
            if let userPhone = user.phone {
                if !userPhone.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    phone = userPhone
                }
            }
            
            if let email = email, let phone = phone {
                return "Email: \(email), Phone: \(phone)"
            } else if let email = email {
                return "Email: \(email)"
            } else if let phone = phone {
                return "Phone: \(phone)"
            }
        }
        return "No contact information available"
    }
    
    public func getUserFullAddress(user: User?) -> String? {
        // Manual nil checking through nested optionals
        if let user = user {
            if let address = user.address {
                var addressParts: [String] = []
                
                if let street = address.street {
                    addressParts.append(street)
                }
                if let city = address.city {
                    addressParts.append(city)
                }
                if let state = address.state {
                    addressParts.append(state)
                }
                if let zipCode = address.zipCode {
                    addressParts.append(zipCode)
                }
                if let country = address.country {
                    addressParts.append(country)
                }
                
                if !addressParts.isEmpty {
                    return addressParts.joined(separator: ", ")
                }
            }
        }
        return nil
    }
    
    public func isUserPreferencesComplete(user: User?) -> Bool {
        // Complex manual nil checking
        if let user = user {
            if let preferences = user.preferences {
                if let theme = preferences.theme, let language = preferences.language {
                    if let notifications = preferences.notifications {
                        if let email = notifications.email, let push = notifications.push, let sms = notifications.sms {
                            if let privacy = preferences.privacy {
                                if let profileVisibility = privacy.profileVisibility,
                                   let dataSharing = privacy.dataSharing,
                                   let analytics = privacy.analytics {
                                    return true
                                }
                            }
                        }
                    }
                }
            }
        }
        return false
    }
    
    public func updateUserEmail(user: User?, newEmail: String?) -> User? {
        // Manual nil checking for update operations
        if let user = user {
            if let newEmail = newEmail {
                if newEmail.contains("@") {
                    return User(id: user.id, name: user.name, email: newEmail, 
                               phone: user.phone, address: user.address, preferences: user.preferences)
                }
            }
        }
        return nil
    }
    
    public func mergeUserData(primary: User?, secondary: User?) -> User? {
        // Manual merging with nil checks
        if primary == nil {
            return secondary
        }
        if secondary == nil {
            return primary
        }
        
        if let primaryUser = primary, let secondaryUser = secondary {
            let mergedName = primaryUser.name ?? secondaryUser.name
            let mergedEmail = primaryUser.email ?? secondaryUser.email
            let mergedPhone = primaryUser.phone ?? secondaryUser.phone
            let mergedAddress = primaryUser.address ?? secondaryUser.address
            let mergedPreferences = mergePreferences(primary: primaryUser.preferences, secondary: secondaryUser.preferences)
            
            return User(id: primaryUser.id, name: mergedName, email: mergedEmail,
                       phone: mergedPhone, address: mergedAddress, preferences: mergedPreferences)
        }
        
        return nil
    }
    
    private func mergePreferences(primary: UserPreferences?, secondary: UserPreferences?) -> UserPreferences? {
        if primary == nil {
            return secondary
        }
        if secondary == nil {
            return primary
        }
        
        if let primaryPrefs = primary, let secondaryPrefs = secondary {
            let mergedTheme = primaryPrefs.theme ?? secondaryPrefs.theme
            let mergedLanguage = primaryPrefs.language ?? secondaryPrefs.language
            let mergedNotifications = mergeNotificationSettings(primary: primaryPrefs.notifications, secondary: secondaryPrefs.notifications)
            let mergedPrivacy = mergePrivacySettings(primary: primaryPrefs.privacy, secondary: secondaryPrefs.privacy)
            
            return UserPreferences(theme: mergedTheme, language: mergedLanguage,
                                 notifications: mergedNotifications, privacy: mergedPrivacy)
        }
        
        return nil
    }
    
    private func mergeNotificationSettings(primary: NotificationSettings?, secondary: NotificationSettings?) -> NotificationSettings? {
        if primary == nil {
            return secondary
        }
        if secondary == nil {
            return primary
        }
        
        if let primaryNotif = primary, let secondaryNotif = secondary {
            let mergedEmail = primaryNotif.email ?? secondaryNotif.email
            let mergedPush = primaryNotif.push ?? secondaryNotif.push
            let mergedSms = primaryNotif.sms ?? secondaryNotif.sms
            
            return NotificationSettings(email: mergedEmail, push: mergedPush, sms: mergedSms)
        }
        
        return nil
    }
    
    private func mergePrivacySettings(primary: PrivacySettings?, secondary: PrivacySettings?) -> PrivacySettings? {
        if primary == nil {
            return secondary
        }
        if secondary == nil {
            return primary
        }
        
        if let primaryPrivacy = primary, let secondaryPrivacy = secondary {
            let mergedProfileVisibility = primaryPrivacy.profileVisibility ?? secondaryPrivacy.profileVisibility
            let mergedDataSharing = primaryPrivacy.dataSharing ?? secondaryPrivacy.dataSharing
            let mergedAnalytics = primaryPrivacy.analytics ?? secondaryPrivacy.analytics
            
            return PrivacySettings(profileVisibility: mergedProfileVisibility, 
                                 dataSharing: mergedDataSharing, analytics: mergedAnalytics)
        }
        
        return nil
    }
}

public class ApiService {
    
    func handleApiResponse<T>(response: ApiResponse<T>?) -> T? {
        // Manual nil checking for API responses
        if let response = response {
            if response.error == nil {
                return response.data
            }
        }
        return nil
    }
    
    func getErrorMessage<T>(response: ApiResponse<T>?) -> String {
        // Manual error message extraction
        if let response = response {
            if let error = response.error {
                if let message = error.message {
                    if !message.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                        return message
                    }
                }
                if let code = error.code {
                    return "Error code: \(code)"
                }
            }
        }
        return "Unknown error occurred"
    }
    
    func getResponseMetadata<T>(response: ApiResponse<T>?) -> [String: String] {
        // Manual metadata extraction
        var result: [String: String] = [:]
        
        if let response = response {
            if let metadata = response.metadata {
                if let timestamp = metadata.timestamp {
                    result["timestamp"] = String(timestamp)
                }
                if let version = metadata.version {
                    result["version"] = version
                }
                if let requestId = metadata.requestId {
                    result["requestId"] = requestId
                }
            }
        }
        
        return result
    }
    
    func validateApiResponse<T>(response: ApiResponse<T>?) -> Bool {
        // Complex manual validation
        if let response = response {
            if response.data != nil && response.error == nil {
                if let metadata = response.metadata {
                    if let timestamp = metadata.timestamp {
                        if timestamp > 0 {
                            return true
                        }
                    }
                }
            }
        }
        return false
    }
    
    func processApiErrorDetails<T>(response: ApiResponse<T>?) -> [String] {
        // Manual error details processing
        var result: [String] = []
        
        if let response = response {
            if let error = response.error {
                if let details = error.details {
                    for (key, value) in details {
                        if !key.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
                           !value.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                            result.append("\(key): \(value)")
                        }
                    }
                }
            }
        }
        
        return result
    }
}

public class ConfigService {
    
    func isConfigValid(config: AppConfig?) -> Bool {
        // Manual configuration validation
        if let config = config {
            if let apiUrl = config.apiUrl {
                if !apiUrl.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    if let apiKey = config.apiKey {
                        if !apiKey.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                            if config.features != nil && config.cache != nil && config.analytics != nil {
                                return true
                            }
                        }
                    }
                }
            }
        }
        return false
    }
    
    func getApiEndpoint(config: AppConfig?, path: String?) -> String? {
        // Manual URL construction
        if let config = config {
            if let apiUrl = config.apiUrl {
                if !apiUrl.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    if let path = path {
                        if !path.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                            return "\(apiUrl)/\(path)"
                        }
                    }
                    return apiUrl
                }
            }
        }
        return nil
    }
    
    func isFeatureEnabled(config: AppConfig?, featureName: String) -> Bool {
        // Manual feature flag checking
        if let config = config {
            if let features = config.features {
                switch featureName {
                case "newUI":
                    return features.newUI ?? false
                case "betaFeatures":
                    return features.betaFeatures ?? false
                case "experimentalMode":
                    return features.experimentalMode ?? false
                default:
                    return false
                }
            }
        }
        return false
    }
    
    func getCacheSettings(config: AppConfig?) -> (Bool, Int64, Int64) {
        // Manual cache configuration extraction
        var enabled = false
        var maxSize: Int64 = 0
        var ttl: Int64 = 0
        
        if let config = config {
            if let cache = config.cache {
                enabled = cache.enabled ?? false
                maxSize = cache.maxSize ?? 0
                ttl = cache.ttl ?? 0
            }
        }
        
        return (enabled, maxSize, ttl)
    }
    
    func getAnalyticsConfig(config: AppConfig?) -> [String: Any] {
        // Manual analytics configuration extraction
        var result: [String: Any] = [:]
        
        if let config = config {
            if let analytics = config.analytics {
                if let enabled = analytics.enabled {
                    result["enabled"] = enabled
                }
                if let trackingId = analytics.trackingId {
                    if !trackingId.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                        result["trackingId"] = trackingId
                    }
                }
                if let samplingRate = analytics.samplingRate {
                    if samplingRate > 0.0 {
                        result["samplingRate"] = samplingRate
                    }
                }
            }
        }
        
        return result
    }
}

public class DataProcessor {
    
    func processUserList(users: [User?]?) -> [String] {
        // Manual processing of optional list with optional elements
        var result: [String] = []
        
        if let users = users {
            for user in users {
                if let user = user {
                    if let name = user.name {
                        if !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                            result.append(name)
                        }
                    }
                }
            }
        }
        
        return result
    }
    
    func getUsersByCity(users: [User?]?, city: String?) -> [User] {
        // Manual filtering with nested nil checks
        var result: [User] = []
        
        if let users = users, let targetCity = city {
            for user in users {
                if let user = user {
                    if let address = user.address {
                        if let userCity = address.city {
                            if userCity.caseInsensitiveCompare(targetCity) == .orderedSame {
                                result.append(user)
                            }
                        }
                    }
                }
            }
        }
        
        return result
    }
    
    func calculateUserStats(users: [User?]?) -> [String: Int] {
        // Manual statistics calculation
        var validUsers: [User] = []
        
        if let users = users {
            for user in users {
                if let user = user {
                    validUsers.append(user)
                }
            }
        }
        
        var withEmail = 0
        var withPhone = 0
        var withAddress = 0
        var withPreferences = 0
        
        for user in validUsers {
            if let email = user.email {
                if email.contains("@") {
                    withEmail += 1
                }
            }
            
            if let phone = user.phone {
                if !phone.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    withPhone += 1
                }
            }
            
            if user.address != nil {
                withAddress += 1
            }
            
            if user.preferences != nil {
                withPreferences += 1
            }
        }
        
        return [
            "total": validUsers.count,
            "withEmail": withEmail,
            "withPhone": withPhone,
            "withAddress": withAddress,
            "withPreferences": withPreferences
        ]
    }
    
    func extractContactEmails(users: [User?]?) -> Set<String> {
        // Manual email extraction and deduplication
        var emails: Set<String> = []
        
        if let users = users {
            for user in users {
                if let user = user {
                    if let email = user.email {
                        if email.contains("@") && !email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                            emails.insert(email)
                        }
                    }
                }
            }
        }
        
        return emails
    }
    
    func groupUsersByCountry(users: [User?]?) -> [String: [User]] {
        // Manual grouping with nested navigation
        var result: [String: [User]] = [:]
        
        if let users = users {
            for user in users {
                if let user = user {
                    var country = "Unknown"
                    if let address = user.address {
                        if let userCountry = address.country {
                            if !userCountry.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                                country = userCountry
                            }
                        }
                    }
                    
                    if result[country] == nil {
                        result[country] = []
                    }
                    result[country]?.append(user)
                }
            }
        }
        
        return result
    }
}

public class StringUtils {
    
    func safeSubstring(text: String?, start: Int, end: Int?) -> String? {
        // Manual string operations with nil checks
        if let text = text {
            if text.count > start {
                let startIndex = text.index(text.startIndex, offsetBy: start)
                var endIndex: String.Index
                
                if let end = end {
                    let maxEnd = min(end, text.count)
                    endIndex = text.index(text.startIndex, offsetBy: maxEnd)
                } else {
                    endIndex = text.endIndex
                }
                
                if startIndex < endIndex {
                    return String(text[startIndex..<endIndex])
                }
            }
        }
        return nil
    }
    
    func safeStringJoin(strings: [String?]?, separator: String?) -> String? {
        // Manual string joining with nil filtering
        var validStrings: [String] = []
        
        if let strings = strings {
            for string in strings {
                if let string = string {
                    if !string.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                        validStrings.append(string)
                    }
                }
            }
        }
        
        if !validStrings.isEmpty {
            let sep = separator ?? ","
            return validStrings.joined(separator: sep)
        }
        
        return nil
    }
    
    func safeStringFormat(template: String?, args: [Any?]) -> String? {
        // Manual string formatting with nil handling
        if let template = template {
            if !template.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                var safeArgs: [Any] = []
                for arg in args {
                    if let arg = arg {
                        safeArgs.append(arg)
                    } else {
                        safeArgs.append("null")
                    }
                }
                
                // Simplified string formatting (would need more complex implementation in real code)
                return template
            }
        }
        return nil
    }
    
    func extractNumbers(text: String?) -> [Int] {
        // Manual number extraction from optional string
        var numbers: [Int] = []
        
        if let text = text {
            let regex = try? NSRegularExpression(pattern: "\\d+", options: [])
            let matches = regex?.matches(in: text, options: [], range: NSRange(location: 0, length: text.count))
            
            if let matches = matches {
                for match in matches {
                    let range = Range(match.range, in: text)
                    if let range = range {
                        let numberString = String(text[range])
                        if let number = Int(numberString) {
                            numbers.append(number)
                        }
                    }
                }
            }
        }
        
        return numbers
    }
    
    func parseKeyValuePairs(text: String?, delimiter: String?) -> [String: String] {
        // Manual parsing of key-value pairs
        var result: [String: String] = [:]
        
        if let text = text {
            if !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                let delim = delimiter ?? "="
                let lines = text.components(separatedBy: CharacterSet(charactersIn: "\n;,"))
                
                for line in lines {
                    let parts = line.components(separatedBy: delim)
                    if parts.count == 2 {
                        let key = parts[0].trimmingCharacters(in: .whitespacesAndNewlines)
                        let value = parts[1].trimmingCharacters(in: .whitespacesAndNewlines)
                        
                        if !key.isEmpty && !value.isEmpty {
                            result[key] = value
                        }
                    }
                }
            }
        }
        
        return result
    }
}

public class IosSizeBenchmark {
    private let userService = UserService()
    private let apiService = ApiService()
    private let configService = ConfigService()
    private let dataProcessor = DataProcessor()
    private let stringUtils = StringUtils()
    
    public func runBenchmark() {
        // Create test data with optional fields - much more verbose than Kotlin
        let users: [User?] = [
            User(id: "1", name: "John Doe", email: "john@example.com", phone: "+1234567890",
                 address: Address(street: "123 Main St", city: "New York", state: "NY", zipCode: "10001", country: "USA"),
                 preferences: UserPreferences(theme: "dark", language: "en",
                                            notifications: NotificationSettings(email: true, push: false, sms: true),
                                            privacy: PrivacySettings(profileVisibility: "public", dataSharing: true, analytics: false))),
            User(id: "2", name: nil, email: nil, phone: nil, address: nil, preferences: nil),
            User(id: "3", name: "Jane Smith", email: "jane@test.com", phone: nil,
                 address: Address(street: nil, city: "Los Angeles", state: nil, zipCode: nil, country: "USA"), preferences: nil),
            nil
        ]
        
        let apiResponses: [ApiResponse<String>?] = [
            ApiResponse(data: "success", error: nil, metadata: ResponseMetadata(timestamp: Int64(Date().timeIntervalSince1970 * 1000), version: "1.0", requestId: "req-123")),
            ApiResponse(data: nil, error: ErrorInfo(code: "404", message: "Not found", details: ["reason": "User not found"]), metadata: nil),
            nil
        ]
        
        let configs: [AppConfig?] = [
            AppConfig(apiUrl: "https://api.example.com", apiKey: "key123",
                     features: FeatureFlags(newUI: true, betaFeatures: false, experimentalMode: nil),
                     cache: CacheConfig(enabled: true, maxSize: 1024, ttl: 3600),
                     analytics: AnalyticsConfig(enabled: true, trackingId: "GA-123", samplingRate: 0.1)),
            AppConfig(apiUrl: nil, apiKey: nil, features: nil, cache: nil, analytics: nil),
            nil
        ]
        
        // Test user service operations - much more verbose nil checking
        for user in users {
            let displayName = userService.getUserDisplayName(user: user)
            let contactInfo = userService.getUserContactInfo(user: user)
            let fullAddress = userService.getUserFullAddress(user: user)
            let preferencesComplete = userService.isUserPreferencesComplete(user: user)
            let updatedUser = userService.updateUserEmail(user: user, newEmail: "newemail@example.com")
        }
        
        // Test user merging
        let mergedUser = userService.mergeUserData(primary: users[0], secondary: users[2])
        
        // Test API service operations
        for response in apiResponses {
            let data = apiService.handleApiResponse(response: response)
            let errorMessage = apiService.getErrorMessage(response: response)
            let metadata = apiService.getResponseMetadata(response: response)
            let isValid = apiService.validateApiResponse(response: response)
            let errorDetails = apiService.processApiErrorDetails(response: response)
        }
        
        // Test config service operations
        for config in configs {
            let isValid = configService.isConfigValid(config: config)
            let endpoint = configService.getApiEndpoint(config: config, path: "users")
            let newUIEnabled = configService.isFeatureEnabled(config: config, featureName: "newUI")
            let betaEnabled = configService.isFeatureEnabled(config: config, featureName: "betaFeatures")
            let cacheSettings = configService.getCacheSettings(config: config)
            let analyticsConfig = configService.getAnalyticsConfig(config: config)
        }
        
        // Test data processing operations
        let userNames = dataProcessor.processUserList(users: users)
        let nyUsers = dataProcessor.getUsersByCity(users: users, city: "New York")
        let userStats = dataProcessor.calculateUserStats(users: users)
        let emails = dataProcessor.extractContactEmails(users: users)
        let usersByCountry = dataProcessor.groupUsersByCountry(users: users)
        
        // Test string utility operations - more verbose than Kotlin extensions
        let testStrings: [String?] = ["Hello World", nil, "", "   ", "Test123"]
        for str in testStrings {
            let substring = stringUtils.safeSubstring(text: str, start: 2, end: 8)
            let numbers = stringUtils.extractNumbers(text: str)
        }
        
        let stringList: [String?] = ["apple", nil, "banana", "", "cherry"]
        let joinedString = stringUtils.safeStringJoin(strings: stringList, separator: ", ")
        
        let formatResult = stringUtils.safeStringFormat(template: "Hello %@, you have %d messages", args: ["John", 5])
        
        let kvText = "name=John\nemail=john@example.com\nage=30"
        let kvPairs = stringUtils.parseKeyValuePairs(text: kvText, delimiter: "=")
        
        // Complex nil-safe operations chains - much more verbose
        var complexResult = "No email notifications configured"
        if let firstUser = users.first {
            if let user = firstUser {
                if let preferences = user.preferences {
                    if let notifications = preferences.notifications {
                        if let emailNotifications = notifications.email {
                            if emailNotifications {
                                if let email = user.email {
                                    if email.contains("@") {
                                        complexResult = "Email notifications enabled for \(email)"
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        
        // Manual nil-safe collection operations - much more verbose than Kotlin
        var validEmails: [String] = []
        for user in users {
            if let user = user {
                if let email = user.email {
                    if email.contains("@") {
                        validEmails.append(email)
                    }
                }
            }
        }
        
        var addressSummary: [String] = []
        for user in users {
            if let user = user {
                if let address = user.address {
                    var parts: [String] = []
                    if let city = address.city {
                        parts.append(city)
                    }
                    if let state = address.state {
                        parts.append(state)
                    }
                    if let country = address.country {
                        parts.append(country)
                    }
                    if !parts.isEmpty {
                        addressSummary.append(parts.joined(separator: ", "))
                    }
                }
            }
        }
        
        // Manual error handling patterns - much more verbose
        var processedConfigs: [[String: String]] = []
        for config in configs {
            if let config = config {
                if configService.isConfigValid(config: config) {
                    var configMap: [String: String] = [:]
                    configMap["apiUrl"] = config.apiUrl ?? ""
                    configMap["hasFeatures"] = (config.features != nil) ? "true" : "false"
                    
                    var cacheEnabled = "false"
                    if let cache = config.cache {
                        if let enabled = cache.enabled {
                            cacheEnabled = enabled ? "true" : "false"
                        }
                    }
                    configMap["cacheEnabled"] = cacheEnabled
                    
                    processedConfigs.append(configMap)
                }
            }
        }
        
        // Manual numeric operations - more verbose
        let numericData: [String?] = ["123", nil, "456.78", "invalid", "789"]
        var validNumbers: [Double] = []
        for str in numericData {
            if let str = str {
                if let number = Double(str) {
                    validNumbers.append(number)
                }
            }
        }
        let sum = validNumbers.reduce(0, +)
        let average = validNumbers.isEmpty ? 0.0 : validNumbers.reduce(0, +) / Double(validNumbers.count)
        
        // Manual date/time operations
        let timestamps: [Int64?] = [1234567890, nil, 0, -1, Int64(Date().timeIntervalSince1970 * 1000)]
        var validTimestamps: [Int64] = []
        for timestamp in timestamps {
            if let timestamp = timestamp {
                if timestamp > 0 {
                    validTimestamps.append(timestamp)
                }
            }
        }
        
        // Manual resource management patterns - much more verbose
        let resourcePaths: [String?] = ["/path/to/file.txt", nil, "", "/another/path"]
        var validPaths: [String] = []
        for path in resourcePaths {
            if let path = path {
                if !path.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    if path.hasPrefix("/") {
                        validPaths.append(path)
                    }
                }
            }
        }
    }
}