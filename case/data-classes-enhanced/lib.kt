/*
 * iOS Size Benchmark - Test Case Implementation
 * Generated with Claude AI (https://claude.ai)
 * 
 * This Kotlin Native implementation demonstrates language-specific
 * features and patterns for binary size comparison.
 */

package kntr.examples.ios.size.benchmark

// 复杂嵌套数据结构测试
data class Address(
    val street: String,
    val city: String,
    val coordinates: Pair<Double, Double>,
    val metadata: Map<String, Any> = emptyMap()
)

data class ContactInfo(
    val emails: List<String>,
    val phones: Set<String>,
    val socialMedia: Map<String, String>,
    val preferences: Map<String, Boolean> = mapOf(
        "notifications" to true,
        "marketing" to false
    )
)

// 带计算属性的数据类
data class Product(
    val id: Long,
    val name: String,
    val category: String,
    val basePrice: Double,
    val taxes: List<Double>,
    val discounts: Map<String, Double> = emptyMap(),
    val tags: Set<String> = emptySet()
) {
    val finalPrice: Double
        get() = basePrice + taxes.sum() - discounts.values.sum()
    
    val displayName: String
        get() = if (tags.contains("featured")) "⭐ $name" else name
}

// 复杂泛型数据类
data class OrderItem<T : Product>(
    val product: T,
    val quantity: Int,
    val customizations: Map<String, Any>,
    val bundledItems: List<OrderItem<out Product>> = emptyList()
) {
    val totalPrice: Double
        get() = product.finalPrice * quantity + bundledItems.sumOf { it.totalPrice }
}

// 密封类和数据类结合
sealed class PaymentMethod {
    data class CreditCard(
        val number: String,
        val expiryMonth: Int,
        val expiryYear: Int,
        val securityCode: String,
        val billingAddress: Address
    ) : PaymentMethod()
    
    data class BankTransfer(
        val accountNumber: String,
        val routingNumber: String,
        val bankName: String
    ) : PaymentMethod()
    
    data class DigitalWallet(
        val provider: String,
        val accountId: String,
        val linkedCards: List<CreditCard>
    ) : PaymentMethod()
    
    object Cash : PaymentMethod()
}

// 深度嵌套数据结构
data class Customer(
    val id: Long,
    val personalInfo: PersonalInfo,
    val contactInfo: ContactInfo,
    val addresses: List<Address>,
    val paymentMethods: List<PaymentMethod>,
    val orderHistory: List<Order>,
    val loyaltyProgram: LoyaltyProgram?,
    val preferences: CustomerPreferences
)

data class PersonalInfo(
    val firstName: String,
    val lastName: String,
    val dateOfBirth: String,
    val nationality: String,
    val governmentIds: Map<String, String>
)

data class LoyaltyProgram(
    val tier: String,
    val points: Int,
    val benefits: Set<String>,
    val expiryDate: String?
)

data class CustomerPreferences(
    val language: String,
    val currency: String,
    val timezone: String,
    val notifications: Map<String, Boolean>,
    val privacy: Map<String, String>
)

data class Order(
    val id: Long,
    val customerId: Long,
    val items: List<OrderItem<Product>>,
    val shippingAddress: Address,
    val billingAddress: Address,
    val paymentMethod: PaymentMethod,
    val status: OrderStatus,
    val timestamps: OrderTimestamps,
    val totals: OrderTotals,
    val metadata: Map<String, Any> = emptyMap()
)

data class OrderStatus(
    val current: String,
    val history: List<StatusChange>,
    val estimatedDelivery: String?
)

data class StatusChange(
    val status: String,
    val timestamp: String,
    val reason: String?,
    val updatedBy: String
)

data class OrderTimestamps(
    val created: String,
    val confirmed: String?,
    val shipped: String?,
    val delivered: String?,
    val cancelled: String?
)

data class OrderTotals(
    val subtotal: Double,
    val taxes: Double,
    val shipping: Double,
    val discounts: Double,
    val total: Double
)

class DataClassesService {
    
    fun generateComplexCustomer(customerId: Long): Customer {
        val personalInfo = PersonalInfo(
            firstName = "John$customerId",
            lastName = "Doe$customerId",
            dateOfBirth = "1990-01-01",
            nationality = "US",
            governmentIds = mapOf(
                "ssn" to "123-45-${customerId.toString().padStart(4, '0')}",
                "passport" to "P${customerId}234567"
            )
        )
        
        val contactInfo = ContactInfo(
            emails = listOf(
                "john.doe$customerId@email.com",
                "john$customerId@work.com"
            ),
            phones = setOf(
                "+1-555-${customerId.toString().padStart(4, '0')}",
                "+1-555-${(customerId + 1000).toString().padStart(4, '0')}"
            ),
            socialMedia = mapOf(
                "twitter" to "@john$customerId",
                "linkedin" to "john-doe-$customerId",
                "instagram" to "john_$customerId"
            )
        )
        
        val addresses = listOf(
            Address(
                street = "${customerId}00 Main St",
                city = "New York",
                coordinates = 40.7128 to -74.0060,
                metadata = mapOf("type" to "home", "primary" to true)
            ),
            Address(
                street = "${customerId}01 Business Ave",
                city = "Boston",
                coordinates = 42.3601 to -71.0589,
                metadata = mapOf("type" to "work", "primary" to false)
            )
        )
        
        val paymentMethods = listOf(
            PaymentMethod.CreditCard(
                number = "4532-1234-5678-${customerId.toString().padStart(4, '0')}",
                expiryMonth = 12,
                expiryYear = 2027,
                securityCode = "123",
                billingAddress = addresses.first()
            ),
            PaymentMethod.DigitalWallet(
                provider = "ApplePay",
                accountId = "apple_$customerId",
                linkedCards = emptyList()
            )
        )
        
        val products = (1..5).map { i ->
            Product(
                id = customerId * 100 + i,
                name = "Product $i for Customer $customerId",
                category = "Category${i % 3}",
                basePrice = 99.99 + i * 10,
                taxes = listOf(8.25, 2.5),
                discounts = if (i % 2 == 0) mapOf("member" to 5.0) else emptyMap(),
                tags = setOf("featured", "bestseller").take(i % 2 + 1).toSet()
            )
        }
        
        val orderItems = products.map { product ->
            OrderItem(
                product = product,
                quantity = (1..3).random(),
                customizations = mapOf(
                    "color" to "blue",
                    "size" to "large",
                    "engraving" to "Custom text $customerId"
                )
            )
        }
        
        val orders = (1..3).map { orderIndex ->
            val orderItems = orderItems.take(orderIndex + 1)
            val subtotal = orderItems.sumOf { it.totalPrice }
            val taxes = subtotal * 0.0825
            val shipping = 9.99
            val discounts = if (orderIndex % 2 == 0) 15.0 else 0.0
            val total = subtotal + taxes + shipping - discounts
            
            Order(
                id = customerId * 1000 + orderIndex,
                customerId = customerId,
                items = orderItems,
                shippingAddress = addresses.first(),
                billingAddress = addresses.last(),
                paymentMethod = paymentMethods.first(),
                status = OrderStatus(
                    current = "delivered",
                    history = listOf(
                        StatusChange("pending", "2024-01-01T10:00:00Z", null, "system"),
                        StatusChange("confirmed", "2024-01-01T10:05:00Z", "payment_verified", "system"),
                        StatusChange("shipped", "2024-01-02T14:30:00Z", null, "warehouse"),
                        StatusChange("delivered", "2024-01-05T16:45:00Z", null, "courier")
                    ),
                    estimatedDelivery = "2024-01-05"
                ),
                timestamps = OrderTimestamps(
                    created = "2024-01-01T10:00:00Z",
                    confirmed = "2024-01-01T10:05:00Z",
                    shipped = "2024-01-02T14:30:00Z",
                    delivered = "2024-01-05T16:45:00Z",
                    cancelled = null
                ),
                totals = OrderTotals(
                    subtotal = subtotal,
                    taxes = taxes,
                    shipping = shipping,
                    discounts = discounts,
                    total = total
                )
            )
        }
        
        val loyaltyProgram = LoyaltyProgram(
            tier = "Gold",
            points = (customerId * 100).toInt(),
            benefits = setOf("free_shipping", "priority_support", "exclusive_discounts"),
            expiryDate = "2025-12-31"
        )
        
        val preferences = CustomerPreferences(
            language = "en-US",
            currency = "USD",
            timezone = "America/New_York",
            notifications = mapOf(
                "email" to true,
                "sms" to false,
                "push" to true,
                "marketing" to false
            ),
            privacy = mapOf(
                "share_data" to "no",
                "cookies" to "essential_only",
                "analytics" to "anonymized"
            )
        )
        
        return Customer(
            id = customerId,
            personalInfo = personalInfo,
            contactInfo = contactInfo,
            addresses = addresses,
            paymentMethods = paymentMethods,
            orderHistory = orders,
            loyaltyProgram = loyaltyProgram,
            preferences = preferences
        )
    }
    
    fun massDataProcessing(customerCount: Int) {
        println("Generating $customerCount complex customers with nested data structures...")
        
        val customers = (1L..customerCount.toLong()).map { generateComplexCustomer(it) }
        
        println("Processing data class operations...")
        
        // 测试数据类的复制操作
        val updatedCustomers = customers.map { customer ->
            customer.copy(
                personalInfo = customer.personalInfo.copy(
                    firstName = "${customer.personalInfo.firstName}_Updated"
                ),
                preferences = customer.preferences.copy(
                    notifications = customer.preferences.notifications + ("marketing" to true)
                )
            )
        }
        
        // 测试解构操作
        customers.forEach { customer ->
            val (id, personalInfo, contactInfo) = customer
            val (firstName, lastName) = personalInfo
            val (emails, phones) = contactInfo
        }
        
        // 测试数据类的相等性和哈希码
        val customerSet = customers.toSet()
        val customerMap = customers.associateBy { it.id }
        
        // 测试复杂的数据转换
        val customerSummaries = customers.map { customer ->
            mapOf(
                "id" to customer.id,
                "name" to "${customer.personalInfo.firstName} ${customer.personalInfo.lastName}",
                "totalOrders" to customer.orderHistory.size,
                "totalSpent" to customer.orderHistory.sumOf { it.totals.total },
                "loyaltyTier" to customer.loyaltyProgram?.tier,
                "primaryEmail" to customer.contactInfo.emails.firstOrNull(),
                "addressCount" to customer.addresses.size
            )
        }
        
        println("Completed data class processing: ${customers.size} customers, ${updatedCustomers.size} updates, ${customerSummaries.size} summaries")
    }
}

class IosSizeBenchmark {
    val service = DataClassesService()
    
    fun runBenchmark() {
        service.massDataProcessing(50)
    }
}