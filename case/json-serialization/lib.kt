/*
 * iOS Size Benchmark - Test Case Implementation
 * Generated with Claude AI (https://claude.ai)
 * 
 * This Kotlin Native implementation demonstrates language-specific
 * features and patterns for binary size comparison.
 */

package kntr.examples.ios.size.benchmark

import kotlinx.serialization.*
import kotlinx.serialization.json.*

@Serializable
data class Address(
    val street: String,
    val city: String,
    val state: String,
    val zipCode: String,
    val country: String,
    val latitude: Double,
    val longitude: Double
)

@Serializable
data class ContactInfo(
    val email: String,
    val phone: String,
    val website: String,
    val socialMedia: List<String>
)

@Serializable
data class Review(
    val reviewId: Int,
    val rating: Int,
    val comment: String,
    val reviewer: String
)

@Serializable
data class Product(
    val productId: Int,
    val name: String,
    val category: String,
    val price: Double,
    val inventory: Int,
    val tags: List<String>,
    val specifications: Map<String, String>,
    val reviews: List<Review>
)

@Serializable
data class Order(
    val orderId: Int,
    val customerId: Int,
    val orderDate: Long,
    val products: List<Product>,
    val totalAmount: Double,
    val status: String,
    val shippingAddress: Address,
    val billingAddress: Address,
    val metadata: Map<String, String>
)

@Serializable
data class NotificationPreferences(
    val email: Boolean,
    val sms: Boolean,
    val push: Boolean
)

@Serializable
data class Preferences(
    val notifications: NotificationPreferences,
    val language: String,
    val currency: String,
    val timezone: String
)

@Serializable
data class Customer(
    val customerId: Int,
    val firstName: String,
    val lastName: String,
    val birthDate: Long,
    val contactInfo: ContactInfo,
    val addresses: List<Address>,
    val orderHistory: List<Order>,
    val preferences: Preferences,
    val isActive: Boolean,
    val loyaltyPrograms: List<String>
)

class JSONSerializationService {
    
    val json = Json {
        prettyPrint = true
        ignoreUnknownKeys = true
    }
    
    fun performComplexJSONSerializationTest() {
        massSerializationTest(100)
    }
    
    fun generateComplexCustomer(customerId: Int): Customer {
        val contactInfo = ContactInfo(
            email = "customer$customerId@email.com",
            phone = "+1-555-${customerId.toString().padStart(4, '0')}",
            website = "https://customer$customerId.com",
            socialMedia = listOf("twitter", "linkedin", "facebook")
        )
        
        val addresses = (0 until 3).map { i ->
            Address(
                street = "$customerId$i Main Street",
                city = "City${customerId + i}",
                state = "State$i",
                zipCode = (customerId * 100 + i).toString().padStart(5, '0'),
                country = "USA",
                latitude = 40.0 + (customerId % 10),
                longitude = -74.0 + (customerId % 10)
            )
        }
        
        val orders = (0 until 5).map { i ->
            val products = (0 until 3).map { j ->
                val reviews = (0 until 2).map { k ->
                    Review(
                        reviewId = k,
                        rating = 4 + k,
                        comment = "Great product review $k",
                        reviewer = "Reviewer$k"
                    )
                }
                
                Product(
                    productId = i * 10 + j,
                    name = "Product$i-$j",
                    category = "Category$j",
                    price = 99.99 + (j * 50.0),
                    inventory = 100 + j,
                    tags = listOf("featured", "bestseller", "new"),
                    specifications = mapOf(
                        "weight" to "${1.0 + j} kg",
                        "dimensions" to "${10 + j}x${20 + j}x${5 + j} cm",
                        "material" to "premium"
                    ),
                    reviews = reviews
                )
            }
            
            val totalAmount = products.sumOf { it.price }
            
            Order(
                orderId = customerId * 100 + i,
                customerId = customerId,
                orderDate = 1609459200L + (i * 86400L),
                products = products,
                totalAmount = totalAmount,
                status = "completed",
                shippingAddress = addresses.first(),
                billingAddress = addresses.last(),
                metadata = mapOf(
                    "source" to "mobile",
                    "campaign" to "campaign$i",
                    "discount" to "${i * 5.0}"
                )
            )
        }
        
        val preferences = Preferences(
            notifications = NotificationPreferences(email = true, sms = false, push = true),
            language = "en-US",
            currency = "USD",
            timezone = "America/New_York"
        )
        
        return Customer(
            customerId = customerId,
            firstName = "FirstName$customerId",
            lastName = "LastName$customerId",
            birthDate = 631152000L + (customerId * 86400L),
            contactInfo = contactInfo,
            addresses = addresses,
            orderHistory = orders,
            preferences = preferences,
            isActive = customerId % 2 == 0,
            loyaltyPrograms = listOf("Gold", "Premium", "VIP")
        )
    }
    
    fun serializeCustomerToJSON(customer: Customer): String {
        return json.encodeToString(customer)
    }
    
    fun deserializeCustomerFromJSON(jsonString: String): Customer? {
        return try {
            json.decodeFromString<Customer>(jsonString)
        } catch (e: Exception) {
            println("JSON Deserialization Error: ${e.message}")
            null
        }
    }
    
    fun massSerializationTest(customerCount: Int) {
        val customers = mutableListOf<Customer>()
        val jsonStrings = mutableListOf<String>()
        
        println("Generating $customerCount complex customers...")
        repeat(customerCount) { i ->
            val customer = generateComplexCustomer(i + 1)
            customers.add(customer)
        }
        
        println("Serializing $customerCount customers to JSON...")
        customers.forEach { customer ->
            val jsonString = serializeCustomerToJSON(customer)
            jsonStrings.add(jsonString)
        }
        
        println("Deserializing ${jsonStrings.size} JSON strings back to objects...")
        val deserializedCustomers = mutableListOf<Customer>()
        jsonStrings.forEach { jsonString ->
            deserializeCustomerFromJSON(jsonString)?.let { customer ->
                deserializedCustomers.add(customer)
            }
        }
        
        println("Completed JSON serialization test: Generated ${customers.size}, Serialized ${jsonStrings.size}, Deserialized ${deserializedCustomers.size}")
        
        repeat(minOf(3, jsonStrings.size)) { i ->
            val jsonString = jsonStrings[i]
            println("Sample JSON length $i: ${jsonString.length} characters")
        }
    }
}

class IosSizeBenchmark {
    val jsonService = JSONSerializationService()
    
    fun runBenchmark() {
        jsonService.performComplexJSONSerializationTest()
    }
}