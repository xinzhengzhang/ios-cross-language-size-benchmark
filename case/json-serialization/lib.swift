/*
 * iOS Size Benchmark - Test Case Implementation
 * Generated with Claude AI (https://claude.ai)
 * 
 * This Swift implementation demonstrates language-specific
 * features and patterns for binary size comparison.
 */

import Foundation

public struct Address: Codable {
    public let street: String
    public let city: String
    public let state: String
    public let zipCode: String
    public let country: String
    public let latitude: Double
    public let longitude: Double
}

public struct ContactInfo: Codable {
    public let email: String
    public let phone: String
    public let website: String
    public let socialMedia: [String]
}

public struct Product: Codable {
    public let productId: Int
    public let name: String
    public let category: String
    public let price: Double
    public let inventory: Int
    public let tags: [String]
    public let specifications: [String: String]
    public let reviews: [Review]
}

public struct Review: Codable {
    public let reviewId: Int
    public let rating: Int
    public let comment: String
    public let reviewer: String
}

public struct Order: Codable {
    public let orderId: Int
    public let customerId: Int
    public let orderDate: Date
    public let products: [Product]
    public let totalAmount: Double
    public let status: String
    public let shippingAddress: Address
    public let billingAddress: Address
    public let metadata: [String: MetadataValue]
}

public enum MetadataValue: Codable {
    case string(String)
    case double(Double)
    case bool(Bool)
    case int(Int)
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let stringValue = try? container.decode(String.self) {
            self = .string(stringValue)
        } else if let doubleValue = try? container.decode(Double.self) {
            self = .double(doubleValue)
        } else if let boolValue = try? container.decode(Bool.self) {
            self = .bool(boolValue)
        } else if let intValue = try? container.decode(Int.self) {
            self = .int(intValue)
        } else {
            throw DecodingError.typeMismatch(MetadataValue.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Unknown metadata value type"))
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .string(let value):
            try container.encode(value)
        case .double(let value):
            try container.encode(value)
        case .bool(let value):
            try container.encode(value)
        case .int(let value):
            try container.encode(value)
        }
    }
}

public struct Preferences: Codable {
    public let notifications: NotificationPreferences
    public let language: String
    public let currency: String
    public let timezone: String
}

public struct NotificationPreferences: Codable {
    public let email: Bool
    public let sms: Bool
    public let push: Bool
}

public struct Customer: Codable {
    public let customerId: Int
    public let firstName: String
    public let lastName: String
    public let birthDate: Date
    public let contactInfo: ContactInfo
    public let addresses: [Address]
    public let orderHistory: [Order]
    public let preferences: Preferences
    public let isActive: Bool
    public let loyaltyPrograms: [String]
}

public class JSONSerializationService {
    private let encoder: JSONEncoder
    private let decoder: JSONDecoder
    
    public init() {
        encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        encoder.dateEncodingStrategy = .secondsSince1970
        
        decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
    }
    
    public func performComplexJSONSerializationTest() {
        massSerializationTest(customerCount: 100)
    }
    
    public func generateComplexCustomer(customerId: Int) -> Customer {
        let contactInfo = ContactInfo(
            email: "customer\(customerId)@email.com",
            phone: "+1-555-\(String(format: "%04d", customerId))",
            website: "https://customer\(customerId).com",
            socialMedia: ["twitter", "linkedin", "facebook"]
        )
        
        let addresses = (0..<3).map { i in
            Address(
                street: "\(customerId)\(i) Main Street",
                city: "City\(customerId + i)",
                state: "State\(i)",
                zipCode: String(format: "%05d", customerId * 100 + i),
                country: "USA",
                latitude: 40.0 + Double(customerId % 10),
                longitude: -74.0 + Double(customerId % 10)
            )
        }
        
        let orders = (0..<5).map { i in
            let products = (0..<3).map { j -> Product in
                let reviews = (0..<2).map { k in
                    Review(
                        reviewId: k,
                        rating: 4 + k,
                        comment: "Great product review \(k)",
                        reviewer: "Reviewer\(k)"
                    )
                }
                
                return Product(
                    productId: i * 10 + j,
                    name: "Product\(i)-\(j)",
                    category: "Category\(j)",
                    price: 99.99 + Double(j * 50),
                    inventory: 100 + j,
                    tags: ["featured", "bestseller", "new"],
                    specifications: [
                        "weight": "\(1.0 + Double(j)) kg",
                        "dimensions": "\(10 + j)x\(20 + j)x\(5 + j) cm",
                        "material": "premium"
                    ],
                    reviews: reviews
                )
            }
            
            let totalAmount = products.reduce(0) { $0 + $1.price }
            
            return Order(
                orderId: customerId * 100 + i,
                customerId: customerId,
                orderDate: Date(timeIntervalSince1970: 1609459200 + Double(i * 86400)),
                products: products,
                totalAmount: totalAmount,
                status: "completed",
                shippingAddress: addresses.first!,
                billingAddress: addresses.last!,
                metadata: [
                    "source": .string("mobile"),
                    "campaign": .string("campaign\(i)"),
                    "discount": .double(Double(i * 5))
                ]
            )
        }
        
        let preferences = Preferences(
            notifications: NotificationPreferences(email: true, sms: false, push: true),
            language: "en-US",
            currency: "USD",
            timezone: "America/New_York"
        )
        
        return Customer(
            customerId: customerId,
            firstName: "FirstName\(customerId)",
            lastName: "LastName\(customerId)",
            birthDate: Date(timeIntervalSince1970: 631152000 + Double(customerId * 86400)),
            contactInfo: contactInfo,
            addresses: addresses,
            orderHistory: orders,
            preferences: preferences,
            isActive: customerId % 2 == 0,
            loyaltyPrograms: ["Gold", "Premium", "VIP"]
        )
    }
    
    public func serializeCustomerToJSON(_ customer: Customer) -> String? {
        do {
            let jsonData = try encoder.encode(customer)
            return String(data: jsonData, encoding: .utf8)
        } catch {
            print("JSON Serialization Error: \(error)")
            return nil
        }
    }
    
    public func deserializeCustomerFromJSON(_ jsonString: String) -> Customer? {
        guard let jsonData = jsonString.data(using: .utf8) else {
            print("Failed to convert string to data")
            return nil
        }
        
        do {
            return try decoder.decode(Customer.self, from: jsonData)
        } catch {
            print("JSON Deserialization Error: \(error)")
            return nil
        }
    }
    
    public func massSerializationTest(customerCount: Int) {
        var customers: [Customer] = []
        var jsonStrings: [String] = []
        
        print("Generating \(customerCount) complex customers...")
        for i in 1...customerCount {
            let customer = generateComplexCustomer(customerId: i)
            customers.append(customer)
        }
        
        print("Serializing \(customerCount) customers to JSON...")
        for customer in customers {
            if let jsonString = serializeCustomerToJSON(customer) {
                jsonStrings.append(jsonString)
            }
        }
        
        print("Deserializing \(jsonStrings.count) JSON strings back to objects...")
        var deserializedCustomers: [Customer] = []
        for jsonString in jsonStrings {
            if let customer = deserializeCustomerFromJSON(jsonString) {
                deserializedCustomers.append(customer)
            }
        }
        
        print("Completed JSON serialization test: Generated \(customers.count), Serialized \(jsonStrings.count), Deserialized \(deserializedCustomers.count)")
        
        for i in 0..<min(3, jsonStrings.count) {
            let jsonString = jsonStrings[i]
            print("Sample JSON length \(i): \(jsonString.count) characters")
        }
    }
}

public class IosSizeBenchmark {
    private let jsonService = JSONSerializationService()
    
    public init() {}
    
    public func runBenchmark() {
        jsonService.performComplexJSONSerializationTest()
    }
}