/*
 * iOS Size Benchmark - Test Case Implementation
 * Generated with Claude AI (https://claude.ai)
 * 
 * This Kotlin Native implementation demonstrates language-specific
 * features and patterns for binary size comparison.
 */

package kntr.examples.ios.size.benchmark

// Test case: Null Safety - Tests Kotlin's compile-time null safety vs runtime null handling

// User data model with nullable fields
class User(
    val id: String,
    val name: String?,
    val email: String?,
    val phone: String?,
    val address: Address?,
    val preferences: UserPreferences?
)

class Address(
    val street: String?,
    val city: String?,
    val state: String?,
    val zipCode: String?,
    val country: String?
)

class UserPreferences(
    val theme: String?,
    val language: String?,
    val notifications: NotificationSettings?,
    val privacy: PrivacySettings?
)

class NotificationSettings(
    val email: Boolean?,
    val push: Boolean?,
    val sms: Boolean?
)

class PrivacySettings(
    val profileVisibility: String?,
    val dataSharing: Boolean?,
    val analytics: Boolean?
)

// Network response models with nullable data
class ApiResponse<T>(
    val data: T?,
    val error: ErrorInfo?,
    val metadata: ResponseMetadata?
)

class ErrorInfo(
    val code: String?,
    val message: String?,
    val details: Map<String, String>?
)

class ResponseMetadata(
    val timestamp: Long?,
    val version: String?,
    val requestId: String?
)

// Configuration classes with nullable settings
class AppConfig(
    val apiUrl: String?,
    val apiKey: String?,
    val features: FeatureFlags?,
    val cache: CacheConfig?,
    val analytics: AnalyticsConfig?
)

class FeatureFlags(
    val newUI: Boolean?,
    val betaFeatures: Boolean?,
    val experimentalMode: Boolean?
)

class CacheConfig(
    val enabled: Boolean?,
    val maxSize: Long?,
    val ttl: Long?
)

class AnalyticsConfig(
    val enabled: Boolean?,
    val trackingId: String?,
    val samplingRate: Double?
)

// Service classes demonstrating null-safe operations
class UserService {
    
    fun getUserDisplayName(user: User?): String {
        // Kotlin's null-safe approach with safe calls and elvis operator
        return user?.name?.takeIf { it.isNotBlank() } ?: "Anonymous User"
    }
    
    fun getUserContactInfo(user: User?): String {
        // Chain of safe calls with null coalescing
        val email = user?.email?.takeIf { it.contains("@") }
        val phone = user?.phone?.takeIf { it.isNotBlank() }
        
        return when {
            email != null && phone != null -> "Email: $email, Phone: $phone"
            email != null -> "Email: $email"
            phone != null -> "Phone: $phone"
            else -> "No contact information available"
        }
    }
    
    fun getUserFullAddress(user: User?): String? {
        // Safe navigation through nested nullable properties
        return user?.address?.let { address ->
            listOfNotNull(
                address.street,
                address.city,
                address.state,
                address.zipCode,
                address.country
            ).takeIf { it.isNotEmpty() }?.joinToString(", ")
        }
    }
    
    fun isUserPreferencesComplete(user: User?): Boolean {
        // Complex null checking with safe calls
        return user?.preferences?.let { prefs ->
            prefs.theme != null && 
            prefs.language != null && 
            prefs.notifications?.let { notif ->
                notif.email != null && notif.push != null && notif.sms != null
            } == true &&
            prefs.privacy?.let { privacy ->
                privacy.profileVisibility != null && 
                privacy.dataSharing != null && 
                privacy.analytics != null
            } == true
        } ?: false
    }
    
    fun updateUserEmail(user: User?, newEmail: String?): User? {
        // Safe updating with null checks
        return user?.takeIf { newEmail?.contains("@") == true }?.let {
            User(it.id, it.name, newEmail, it.phone, it.address, it.preferences)
        }
    }
    
    fun mergeUserData(primary: User?, secondary: User?): User? {
        // Safe merging of nullable data
        if (primary == null) return secondary
        if (secondary == null) return primary
        
        return User(
            id = primary.id,
            name = primary.name ?: secondary.name,
            email = primary.email ?: secondary.email,
            phone = primary.phone ?: secondary.phone,
            address = primary.address ?: secondary.address,
            preferences = mergePreferences(primary.preferences, secondary.preferences)
        )
    }
    
    fun mergePreferences(primary: UserPreferences?, secondary: UserPreferences?): UserPreferences? {
        if (primary == null) return secondary
        if (secondary == null) return primary
        
        return UserPreferences(
            theme = primary.theme ?: secondary.theme,
            language = primary.language ?: secondary.language,
            notifications = mergeNotificationSettings(primary.notifications, secondary.notifications),
            privacy = mergePrivacySettings(primary.privacy, secondary.privacy)
        )
    }
    
    fun mergeNotificationSettings(primary: NotificationSettings?, secondary: NotificationSettings?): NotificationSettings? {
        if (primary == null) return secondary
        if (secondary == null) return primary
        
        return NotificationSettings(
            email = primary.email ?: secondary.email,
            push = primary.push ?: secondary.push,
            sms = primary.sms ?: secondary.sms
        )
    }
    
    fun mergePrivacySettings(primary: PrivacySettings?, secondary: PrivacySettings?): PrivacySettings? {
        if (primary == null) return secondary
        if (secondary == null) return primary
        
        return PrivacySettings(
            profileVisibility = primary.profileVisibility ?: secondary.profileVisibility,
            dataSharing = primary.dataSharing ?: secondary.dataSharing,
            analytics = primary.analytics ?: secondary.analytics
        )
    }
}

class ApiService {
    
    fun <T> handleApiResponse(response: ApiResponse<T>?): T? {
        // Safe handling of API responses with null checks
        return response?.takeIf { it.error == null }?.data
    }
    
    fun getErrorMessage(response: ApiResponse<*>?): String {
        // Safe error message extraction
        return response?.error?.message?.takeIf { it.isNotBlank() } 
            ?: response?.error?.code?.let { "Error code: $it" }
            ?: "Unknown error occurred"
    }
    
    fun getResponseMetadata(response: ApiResponse<*>?): Map<String, String> {
        // Safe metadata extraction
        val metadata = response?.metadata
        return buildMap {
            metadata?.timestamp?.let { put("timestamp", it.toString()) }
            metadata?.version?.let { put("version", it) }
            metadata?.requestId?.let { put("requestId", it) }
        }
    }
    
    fun validateApiResponse(response: ApiResponse<*>?): Boolean {
        // Complex validation with safe calls
        return response?.let { resp ->
            resp.data != null && 
            resp.error == null &&
            resp.metadata?.let { meta ->
                meta.timestamp != null && meta.timestamp > 0
            } == true
        } ?: false
    }
    
    fun processApiErrorDetails(response: ApiResponse<*>?): List<String> {
        // Safe processing of error details
        return response?.error?.details?.mapNotNull { (key, value) ->
            if (key.isNotBlank() && value.isNotBlank()) "$key: $value" else null
        } ?: emptyList()
    }
}

class ConfigService {
    
    fun isConfigValid(config: AppConfig?): Boolean {
        // Safe configuration validation
        return config?.let { cfg ->
            cfg.apiUrl?.isNotBlank() == true &&
            cfg.apiKey?.isNotBlank() == true &&
            cfg.features != null &&
            cfg.cache != null &&
            cfg.analytics != null
        } ?: false
    }
    
    fun getApiEndpoint(config: AppConfig?, path: String?): String? {
        // Safe URL construction
        return config?.apiUrl?.takeIf { it.isNotBlank() }?.let { baseUrl ->
            path?.takeIf { it.isNotBlank() }?.let { "$baseUrl/$it" } ?: baseUrl
        }
    }
    
    fun isFeatureEnabled(config: AppConfig?, featureName: String): Boolean {
        // Safe feature flag checking
        return when (featureName) {
            "newUI" -> config?.features?.newUI ?: false
            "betaFeatures" -> config?.features?.betaFeatures ?: false
            "experimentalMode" -> config?.features?.experimentalMode ?: false
            else -> false
        }
    }
    
    fun getCacheSettings(config: AppConfig?): Triple<Boolean, Long, Long> {
        // Safe cache configuration extraction
        val cache = config?.cache
        return Triple(
            cache?.enabled ?: false,
            cache?.maxSize ?: 0L,
            cache?.ttl ?: 0L
        )
    }
    
    fun getAnalyticsConfig(config: AppConfig?): Map<String, Any> {
        // Safe analytics configuration extraction
        val analytics = config?.analytics
        return buildMap {
            analytics?.enabled?.let { put("enabled", it) }
            analytics?.trackingId?.takeIf { it.isNotBlank() }?.let { put("trackingId", it) }
            analytics?.samplingRate?.takeIf { it > 0.0 }?.let { put("samplingRate", it) }
        }
    }
}

class DataProcessor {
    
    fun processUserList(users: List<User?>?): List<String> {
        // Safe processing of nullable list with nullable elements
        return users?.mapNotNull { user ->
            user?.name?.takeIf { it.isNotBlank() }
        } ?: emptyList()
    }
    
    fun getUsersByCity(users: List<User?>?, city: String?): List<User> {
        // Safe filtering with nested null checks
        return users?.mapNotNull { user ->
            user?.takeIf { 
                it.address?.city?.equals(city, ignoreCase = true) == true 
            }
        } ?: emptyList()
    }
    
    fun calculateUserStats(users: List<User?>?): Map<String, Int> {
        // Safe statistics calculation
        val validUsers = users?.mapNotNull { it } ?: emptyList()
        
        return mapOf(
            "total" to validUsers.size,
            "withEmail" to validUsers.count { it.email?.contains("@") == true },
            "withPhone" to validUsers.count { it.phone?.isNotBlank() == true },
            "withAddress" to validUsers.count { it.address != null },
            "withPreferences" to validUsers.count { it.preferences != null }
        )
    }
    
    fun extractContactEmails(users: List<User?>?): Set<String> {
        // Safe email extraction and deduplication
        return users?.mapNotNull { user ->
            user?.email?.takeIf { it.contains("@") && it.isNotBlank() }
        }?.toSet() ?: emptySet()
    }
    
    fun groupUsersByCountry(users: List<User?>?): Map<String, List<User>> {
        // Safe grouping with nested navigation
        return users?.mapNotNull { it }
            ?.groupBy { user ->
                user.address?.country?.takeIf { it.isNotBlank() } ?: "Unknown"
            } ?: emptyMap()
    }
}

class StringUtils {
    
    fun safeSubstring(text: String?, start: Int, end: Int? = null): String? {
        // Safe string operations with null checks
        return text?.takeIf { it.length > start }?.let {
            val endIndex = end?.coerceAtMost(it.length) ?: it.length
            if (start < endIndex) it.substring(start, endIndex) else null
        }
    }
    
    fun safeStringJoin(strings: List<String?>?, separator: String? = ", "): String? {
        // Safe string joining with null filtering
        return strings?.mapNotNull { it?.takeIf { str -> str.isNotBlank() } }
            ?.takeIf { it.isNotEmpty() }
            ?.joinToString(separator ?: ",")
    }
    
    fun safeStringFormat(template: String?, vararg args: Any?): String? {
        // Safe string formatting with null handling
        return template?.takeIf { it.isNotBlank() }?.let { tmpl ->
            val safeArgs = args.map { it?.toString() ?: "null" }
            try {
                // Simplified formatting for cross-platform compatibility
                tmpl
            } catch (e: Exception) {
                null
            }
        }
    }
    
    fun extractNumbers(text: String?): List<Int> {
        // Safe number extraction from nullable string
        return text?.let { str ->
            "\\d+".toRegex().findAll(str).mapNotNull { 
                it.value.toIntOrNull() 
            }.toList()
        } ?: emptyList()
    }
    
    fun parseKeyValuePairs(text: String?, delimiter: String? = "="): Map<String, String> {
        // Safe parsing of key-value pairs
        return text?.takeIf { it.isNotBlank() }?.let { str ->
            val delim = delimiter ?: "="
            str.split("\n", ";", ",").mapNotNull { line ->
                line.split(delim, limit = 2).takeIf { it.size == 2 }?.let { parts ->
                    val key = parts[0].trim()
                    val value = parts[1].trim()
                    if (key.isNotBlank() && value.isNotBlank()) key to value else null
                }
            }.toMap()
        } ?: emptyMap()
    }
}

class IosSizeBenchmark {
    val userService = UserService()
    val apiService = ApiService()
    val configService = ConfigService()
    val dataProcessor = DataProcessor()
    val stringUtils = StringUtils()
    
    fun runBenchmark() {
        // Create test data with nullable fields
        val users = listOf(
            User("1", "John Doe", "john@example.com", "+1234567890", 
                Address("123 Main St", "New York", "NY", "10001", "USA"),
                UserPreferences("dark", "en", 
                    NotificationSettings(true, false, true),
                    PrivacySettings("public", true, false))),
            User("2", null, null, null, null, null),
            User("3", "Jane Smith", "jane@test.com", null,
                Address(null, "Los Angeles", null, null, "USA"), null),
            null
        )
        
        val apiResponses = listOf(
            ApiResponse("success", null, ResponseMetadata(1234567890L, "1.0", "req-123")),
            ApiResponse(null, ErrorInfo("404", "Not found", mapOf("reason" to "User not found")), null),
            null
        )
        
        val configs = listOf(
            AppConfig("https://api.example.com", "key123",
                FeatureFlags(true, false, null),
                CacheConfig(true, 1024L, 3600L),
                AnalyticsConfig(true, "GA-123", 0.1)),
            AppConfig(null, null, null, null, null),
            null
        )
        
        // Test user service operations
        users.forEach { user ->
            val displayName = userService.getUserDisplayName(user)
            val contactInfo = userService.getUserContactInfo(user)
            val fullAddress = userService.getUserFullAddress(user)
            val preferencesComplete = userService.isUserPreferencesComplete(user)
            val updatedUser = userService.updateUserEmail(user, "newemail@example.com")
        }
        
        // Test user merging
        val mergedUser = userService.mergeUserData(users[0], users[2])
        
        // Test API service operations
        apiResponses.forEach { response ->
            val data = apiService.handleApiResponse(response)
            val errorMessage = apiService.getErrorMessage(response)
            val metadata = apiService.getResponseMetadata(response)
            val isValid = apiService.validateApiResponse(response)
            val errorDetails = apiService.processApiErrorDetails(response)
        }
        
        // Test config service operations
        configs.forEach { config ->
            val isValid = configService.isConfigValid(config)
            val endpoint = configService.getApiEndpoint(config, "users")
            val newUIEnabled = configService.isFeatureEnabled(config, "newUI")
            val betaEnabled = configService.isFeatureEnabled(config, "betaFeatures")
            val cacheSettings = configService.getCacheSettings(config)
            val analyticsConfig = configService.getAnalyticsConfig(config)
        }
        
        // Test data processing operations
        val userNames = dataProcessor.processUserList(users)
        val nyUsers = dataProcessor.getUsersByCity(users, "New York")
        val userStats = dataProcessor.calculateUserStats(users)
        val emails = dataProcessor.extractContactEmails(users)
        val usersByCountry = dataProcessor.groupUsersByCountry(users)
        
        // Test string utility operations
        val testStrings = listOf("Hello World", null, "", "   ", "Test123")
        testStrings.forEach { str ->
            val substring = stringUtils.safeSubstring(str, 2, 8)
            val numbers = stringUtils.extractNumbers(str)
        }
        
        val stringList = listOf("apple", null, "banana", "", "cherry")
        val joinedString = stringUtils.safeStringJoin(stringList)
        
        val formatResult = stringUtils.safeStringFormat("Hello %s, you have %d messages", "John", 5)
        
        val kvText = "name=John\nemail=john@example.com\nage=30"
        val kvPairs = stringUtils.parseKeyValuePairs(kvText)
        
        // Complex null-safe operations chains
        val complexResult = users.firstOrNull()?.let { user ->
            user.preferences?.notifications?.let { notifications ->
                if (notifications.email == true) {
                    user.email?.let { email ->
                        if (email.contains("@")) {
                            "Email notifications enabled for $email"
                        } else null
                    }
                } else null
            }
        } ?: "No email notifications configured"
        
        // Safe collection operations
        val validEmails = users.mapNotNull { user ->
            user?.email?.takeIf { it.contains("@") }
        }
        
        val addressSummary = users.mapNotNull { user ->
            user?.address?.let { address ->
                listOfNotNull(address.city, address.state, address.country)
                    .takeIf { it.isNotEmpty() }
                    ?.joinToString(", ")
            }
        }
        
        // Null-safe error handling patterns
        val processedConfigs = configs.mapNotNull { config ->
            config?.takeIf { configService.isConfigValid(it) }?.let { validConfig ->
                mapOf(
                    "apiUrl" to (validConfig.apiUrl ?: ""),
                    "hasFeatures" to (validConfig.features != null).toString(),
                    "cacheEnabled" to (validConfig.cache?.enabled ?: false).toString()
                )
            }
        }
        
        // Safe numeric operations
        val numericData = listOf("123", null, "456.78", "invalid", "789")
        val validNumbers = numericData.mapNotNull { str ->
            str?.toDoubleOrNull()
        }
        val sum = validNumbers.sum()
        val average = if (validNumbers.isNotEmpty()) validNumbers.average() else 0.0
        
        // Safe date/time operations simulation
        val timestamps = listOf(1234567890L, null, 0L, -1L, 987654321L)
        val validTimestamps = timestamps.mapNotNull { timestamp ->
            timestamp?.takeIf { it > 0 }
        }
        
        // Null-safe resource management patterns
        val resourcePaths = listOf("/path/to/file.txt", null, "", "/another/path")
        val validPaths = resourcePaths.mapNotNull { path ->
            path?.takeIf { it.isNotBlank() && it.startsWith("/") }
        }
    }
}