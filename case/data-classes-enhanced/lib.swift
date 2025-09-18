/*
 * iOS Size Benchmark - Test Case Implementation
 * Generated with Claude AI (https://claude.ai)
 * 
 * This Swift implementation demonstrates language-specific
 * features and patterns for binary size comparison.
 */

import Foundation

// Swift 使用结构体和枚举实现数据类功能

public struct Address: Hashable, Codable {
    public let street: String
    public let city: String
    public let coordinates: (latitude: Double, longitude: Double)
    public let metadata: [String: String] // Changed from AnyHashable to String for Codable support
    
    public init(street: String, city: String, coordinates: (latitude: Double, longitude: Double), metadata: [String: String] = [:]) {
        self.street = street
        self.city = city
        self.coordinates = coordinates
        self.metadata = metadata
    }
    
    // Custom Equatable implementation
    public static func == (lhs: Address, rhs: Address) -> Bool {
        return lhs.street == rhs.street &&
               lhs.city == rhs.city &&
               lhs.coordinates.latitude == rhs.coordinates.latitude &&
               lhs.coordinates.longitude == rhs.coordinates.longitude &&
               lhs.metadata == rhs.metadata
    }
    
    // Custom Hashable implementation
    public func hash(into hasher: inout Hasher) {
        hasher.combine(street)
        hasher.combine(city)
        hasher.combine(coordinates.latitude)
        hasher.combine(coordinates.longitude)
        hasher.combine(metadata.keys.sorted())
    }
    
    // 自定义编码/解码以处理元组
    public enum CodingKeys: String, CodingKey {
        case street, city, latitude, longitude, metadata
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        street = try container.decode(String.self, forKey: .street)
        city = try container.decode(String.self, forKey: .city)
        let latitude = try container.decode(Double.self, forKey: .latitude)
        let longitude = try container.decode(Double.self, forKey: .longitude)
        coordinates = (latitude: latitude, longitude: longitude)
        metadata = try container.decode([String: String].self, forKey: .metadata)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(street, forKey: .street)
        try container.encode(city, forKey: .city)
        try container.encode(coordinates.latitude, forKey: .latitude)
        try container.encode(coordinates.longitude, forKey: .longitude)
        try container.encode(metadata, forKey: .metadata)
    }
}

public struct ContactInfo: Hashable, Codable {
    public let emails: [String]
    public let phones: Set<String>
    public let socialMedia: [String: String]
    public let preferences: [String: Bool]
    
    public init(emails: [String], phones: Set<String>, socialMedia: [String: String], preferences: [String: Bool] = ["notifications": true, "marketing": false]) {
        self.emails = emails
        self.phones = phones
        self.socialMedia = socialMedia
        self.preferences = preferences
    }
}

public struct Product: Hashable, Codable {
    public let id: Int64
    public let name: String
    public let category: String
    public let basePrice: Double
    public let taxes: [Double]
    public let discounts: [String: Double]
    public let tags: Set<String>
    
    // 计算属性
    public var finalPrice: Double {
        let taxSum = taxes.reduce(0, +)
        let discountSum = discounts.values.reduce(0, +)
        return basePrice + taxSum - discountSum
    }
    
    public var displayName: String {
        tags.contains("featured") ? "⭐ \(name)" : name
    }
    
    public init(id: Int64, name: String, category: String, basePrice: Double, taxes: [Double] = [], discounts: [String: Double] = [:], tags: Set<String> = []) {
        self.id = id
        self.name = name
        self.category = category
        self.basePrice = basePrice
        self.taxes = taxes
        self.discounts = discounts
        self.tags = tags
    }
}

public struct OrderItem: Hashable, Codable {
    public let product: Product
    public let quantity: Int
    public let customizations: [String: String] // Changed from AnyHashable to String
    public let bundledItems: [OrderItem]
    
    public var totalPrice: Double {
        let bundledTotal = bundledItems.reduce(0) { $0 + $1.totalPrice }
        return product.finalPrice * Double(quantity) + bundledTotal
    }
    
    public init(product: Product, quantity: Int, customizations: [String: String] = [:], bundledItems: [OrderItem] = []) {
        self.product = product
        self.quantity = quantity
        self.customizations = customizations
        self.bundledItems = bundledItems
    }
    
    // 自定义编码/解码处理 AnyHashable
    public enum CodingKeys: String, CodingKey {
        case product, quantity, customizations, bundledItems
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        product = try container.decode(Product.self, forKey: .product)
        quantity = try container.decode(Int.self, forKey: .quantity)
        customizations = try container.decode([String: String].self, forKey: .customizations)
        bundledItems = try container.decode([OrderItem].self, forKey: .bundledItems)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(product, forKey: .product)
        try container.encode(quantity, forKey: .quantity)
        try container.encode(customizations, forKey: .customizations)
        try container.encode(bundledItems, forKey: .bundledItems)
    }
}

// 枚举关联值模拟密封类
public enum PaymentMethod: Hashable, Codable {
    case creditCard(number: String, expiryMonth: Int, expiryYear: Int, securityCode: String, billingAddress: Address)
    case bankTransfer(accountNumber: String, routingNumber: String, bankName: String)
    case digitalWallet(provider: String, accountId: String, linkedCards: [String])
    case cash
    
    public enum CodingKeys: String, CodingKey {
        case type, data
    }
    
    public enum PaymentType: String, Codable {
        case creditCard, bankTransfer, digitalWallet, cash
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(PaymentType.self, forKey: .type)
        
        switch type {
        case .creditCard:
            let data = try container.decode([String: String].self, forKey: .data)
            let addressData = Data(data["billingAddress"]?.utf8 ?? "".utf8)
            let billingAddress = try JSONDecoder().decode(Address.self, from: addressData)
            self = .creditCard(
                number: data["number"] ?? "",
                expiryMonth: Int(data["expiryMonth"] ?? "0") ?? 0,
                expiryYear: Int(data["expiryYear"] ?? "0") ?? 0,
                securityCode: data["securityCode"] ?? "",
                billingAddress: billingAddress
            )
        case .bankTransfer:
            let data = try container.decode([String: String].self, forKey: .data)
            self = .bankTransfer(
                accountNumber: data["accountNumber"] ?? "",
                routingNumber: data["routingNumber"] ?? "",
                bankName: data["bankName"] ?? ""
            )
        case .digitalWallet:
            let data = try container.decode([String: String].self, forKey: .data)
            let linkedCardsString = data["linkedCards"] ?? ""
            let linkedCards = linkedCardsString.isEmpty ? [] : linkedCardsString.components(separatedBy: ",")
            self = .digitalWallet(
                provider: data["provider"] ?? "",
                accountId: data["accountId"] ?? "",
                linkedCards: linkedCards
            )
        case .cash:
            self = .cash
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        switch self {
        case .creditCard(let number, let expiryMonth, let expiryYear, let securityCode, let billingAddress):
            try container.encode(PaymentType.creditCard, forKey: .type)
            let addressData = try JSONEncoder().encode(billingAddress)
            let addressString = String(data: addressData, encoding: .utf8) ?? ""
            let data = [
                "number": number,
                "expiryMonth": String(expiryMonth),
                "expiryYear": String(expiryYear),
                "securityCode": securityCode,
                "billingAddress": addressString
            ]
            try container.encode(data, forKey: .data)
        case .bankTransfer(let accountNumber, let routingNumber, let bankName):
            try container.encode(PaymentType.bankTransfer, forKey: .type)
            try container.encode([
                "accountNumber": accountNumber,
                "routingNumber": routingNumber,
                "bankName": bankName
            ], forKey: .data)
        case .digitalWallet(let provider, let accountId, let linkedCards):
            try container.encode(PaymentType.digitalWallet, forKey: .type)
            try container.encode([
                "provider": provider,
                "accountId": accountId,
                "linkedCards": linkedCards.joined(separator: ",")
            ], forKey: .data)
        case .cash:
            try container.encode(PaymentType.cash, forKey: .type)
            try container.encode([String: String](), forKey: .data)
        }
    }
}

public struct PersonalInfo: Hashable, Codable {
    public let firstName: String
    public let lastName: String
    public let dateOfBirth: String
    public let nationality: String
    public let governmentIds: [String: String]
    
    public init(firstName: String, lastName: String, dateOfBirth: String, nationality: String, governmentIds: [String: String] = [:]) {
        self.firstName = firstName
        self.lastName = lastName
        self.dateOfBirth = dateOfBirth
        self.nationality = nationality
        self.governmentIds = governmentIds
    }
}

public struct LoyaltyProgram: Hashable, Codable {
    public let tier: String
    public let points: Int
    public let benefits: Set<String>
    public let expiryDate: String?
}

public struct CustomerPreferences: Hashable, Codable {
    public let language: String
    public let currency: String
    public let timezone: String
    public let notifications: [String: Bool]
    public let privacy: [String: String]
}

public struct OrderStatus: Hashable, Codable {
    public let current: String
    public let history: [StatusChange]
    public let estimatedDelivery: String?
}

public struct StatusChange: Hashable, Codable {
    public let status: String
    public let timestamp: String
    public let reason: String?
    public let updatedBy: String
}

public struct OrderTimestamps: Hashable, Codable {
    public let created: String
    public let confirmed: String?
    public let shipped: String?
    public let delivered: String?
    public let cancelled: String?
}

public struct OrderTotals: Hashable, Codable {
    public let subtotal: Double
    public let taxes: Double
    public let shipping: Double
    public let discounts: Double
    public let total: Double
}

public struct Order: Hashable, Codable {
    public let id: Int64
    public let customerId: Int64
    public let items: [OrderItem]
    public let shippingAddress: Address
    public let billingAddress: Address
    public let paymentMethod: PaymentMethod
    public let status: OrderStatus
    public let timestamps: OrderTimestamps
    public let totals: OrderTotals
    public let metadata: [String: String] // Changed from AnyHashable to String
    
    public init(id: Int64, customerId: Int64, items: [OrderItem], shippingAddress: Address, billingAddress: Address, paymentMethod: PaymentMethod, status: OrderStatus, timestamps: OrderTimestamps, totals: OrderTotals, metadata: [String: String] = [:]) {
        self.id = id
        self.customerId = customerId
        self.items = items
        self.shippingAddress = shippingAddress
        self.billingAddress = billingAddress
        self.paymentMethod = paymentMethod
        self.status = status
        self.timestamps = timestamps
        self.totals = totals
        self.metadata = metadata
    }
}

public struct Customer: Hashable, Codable {
    public let id: Int64
    public let personalInfo: PersonalInfo
    public let contactInfo: ContactInfo
    public let addresses: [Address]
    public let paymentMethods: [PaymentMethod]
    public let orderHistory: [Order]
    public let loyaltyProgram: LoyaltyProgram?
    public let preferences: CustomerPreferences
    
    public init(id: Int64, personalInfo: PersonalInfo, contactInfo: ContactInfo, addresses: [Address], paymentMethods: [PaymentMethod], orderHistory: [Order] = [], loyaltyProgram: LoyaltyProgram? = nil, preferences: CustomerPreferences) {
        self.id = id
        self.personalInfo = personalInfo
        self.contactInfo = contactInfo
        self.addresses = addresses
        self.paymentMethods = paymentMethods
        self.orderHistory = orderHistory
        self.loyaltyProgram = loyaltyProgram
        self.preferences = preferences
    }
}

public class DataClassesService {
    
    public func generateComplexCustomer(customerId: Int64) -> Customer {
        let personalInfo = PersonalInfo(
            firstName: "John\(customerId)",
            lastName: "Doe\(customerId)",
            dateOfBirth: "1990-01-01",
            nationality: "US",
            governmentIds: [
                "ssn": "123-45-\(String(format: "%04d", customerId))",
                "passport": "P\(customerId)234567"
            ]
        )
        
        let contactInfo = ContactInfo(
            emails: [
                "john.doe\(customerId)@email.com",
                "john\(customerId)@work.com"
            ],
            phones: Set([
                "+1-555-\(String(format: "%04d", customerId))",
                "+1-555-\(String(format: "%04d", customerId + 1000))"
            ]),
            socialMedia: [
                "twitter": "@john\(customerId)",
                "linkedin": "john-doe-\(customerId)",
                "instagram": "john_\(customerId)"
            ]
        )
        
        let addresses = [
            Address(
                street: "\(customerId)00 Main St",
                city: "New York",
                coordinates: (latitude: 40.7128, longitude: -74.0060),
                metadata: ["type": "home", "primary": "true"]
            ),
            Address(
                street: "\(customerId)01 Business Ave",
                city: "Boston",
                coordinates: (latitude: 42.3601, longitude: -71.0589),
                metadata: ["type": "work", "primary": "false"]
            )
        ]
        
        let paymentMethods = [
            PaymentMethod.creditCard(
                number: "4532-1234-5678-\(String(format: "%04d", customerId))",
                expiryMonth: 12,
                expiryYear: 2027,
                securityCode: "123",
                billingAddress: addresses.first!
            ),
            PaymentMethod.digitalWallet(
                provider: "ApplePay",
                accountId: "apple_\(customerId)",
                linkedCards: []
            )
        ]
        
        // Split the product creation to avoid type checking issues
        var products: [Product] = []
        for i in 1...5 {
            let product = Product(
                id: customerId * 100 + Int64(i),
                name: "Product \(i) for Customer \(customerId)",
                category: "Category\(i % 3)",
                basePrice: 99.99 + Double(i * 10),
                taxes: [8.25, 2.5],
                discounts: i % 2 == 0 ? ["member": 5.0] : [:],
                tags: Set(["featured", "bestseller"].prefix(i % 2 + 1))
            )
            products.append(product)
        }
        
        let orderItems = products.map { product in
            OrderItem(
                product: product,
                quantity: Int.random(in: 1...3),
                customizations: [
                    "color": "blue",
                    "size": "large",
                    "engraving": "Custom text \(customerId)"
                ]
            )
        }
        
        let orders = (1...3).map { orderIndex -> Order in
            let orderItems = Array(orderItems.prefix(orderIndex + 1))
            let subtotal = orderItems.reduce(0) { $0 + $1.totalPrice }
            let taxes = subtotal * 0.0825
            let shipping = 9.99
            let discounts = orderIndex % 2 == 0 ? 15.0 : 0.0
            let total = subtotal + taxes + shipping - discounts
            
            return Order(
                id: customerId * 1000 + Int64(orderIndex),
                customerId: customerId,
                items: orderItems,
                shippingAddress: addresses.first!,
                billingAddress: addresses.last!,
                paymentMethod: paymentMethods.first!,
                status: OrderStatus(
                    current: "delivered",
                    history: [
                        StatusChange(status: "pending", timestamp: "2024-01-01T10:00:00Z", reason: nil, updatedBy: "system"),
                        StatusChange(status: "confirmed", timestamp: "2024-01-01T10:05:00Z", reason: "payment_verified", updatedBy: "system"),
                        StatusChange(status: "shipped", timestamp: "2024-01-02T14:30:00Z", reason: nil, updatedBy: "warehouse"),
                        StatusChange(status: "delivered", timestamp: "2024-01-05T16:45:00Z", reason: nil, updatedBy: "courier")
                    ],
                    estimatedDelivery: "2024-01-05"
                ),
                timestamps: OrderTimestamps(
                    created: "2024-01-01T10:00:00Z",
                    confirmed: "2024-01-01T10:05:00Z",
                    shipped: "2024-01-02T14:30:00Z",
                    delivered: "2024-01-05T16:45:00Z",
                    cancelled: nil
                ),
                totals: OrderTotals(
                    subtotal: subtotal,
                    taxes: taxes,
                    shipping: shipping,
                    discounts: discounts,
                    total: total
                )
            )
        }
        
        let loyaltyProgram = LoyaltyProgram(
            tier: "Gold",
            points: Int(customerId * 100),
            benefits: Set(["free_shipping", "priority_support", "exclusive_discounts"]),
            expiryDate: "2025-12-31"
        )
        
        let preferences = CustomerPreferences(
            language: "en-US",
            currency: "USD",
            timezone: "America/New_York",
            notifications: [
                "email": true,
                "sms": false,
                "push": true,
                "marketing": false
            ],
            privacy: [
                "share_data": "no",
                "cookies": "essential_only",
                "analytics": "anonymized"
            ]
        )
        
        return Customer(
            id: customerId,
            personalInfo: personalInfo,
            contactInfo: contactInfo,
            addresses: addresses,
            paymentMethods: paymentMethods,
            orderHistory: orders,
            loyaltyProgram: loyaltyProgram,
            preferences: preferences
        )
    }
    
    public func massDataProcessing(customerCount: Int) {
        print("Generating \(customerCount) complex customers with nested data structures...")
        
        let customers = (1...customerCount).map { generateComplexCustomer(customerId: Int64($0)) }
        
        print("Processing data class operations...")
        
        // 测试结构体的复制操作（值语义）
        let updatedCustomers = customers.map { customer in
            Customer(
                id: customer.id,
                personalInfo: PersonalInfo(
                    firstName: "\(customer.personalInfo.firstName)_Updated",
                    lastName: customer.personalInfo.lastName,
                    dateOfBirth: customer.personalInfo.dateOfBirth,
                    nationality: customer.personalInfo.nationality,
                    governmentIds: customer.personalInfo.governmentIds
                ),
                contactInfo: ContactInfo(
                    emails: customer.contactInfo.emails,
                    phones: customer.contactInfo.phones,
                    socialMedia: customer.contactInfo.socialMedia,
                    preferences: customer.contactInfo.preferences.merging(["marketing": true]) { _, new in new }
                ),
                addresses: customer.addresses,
                paymentMethods: customer.paymentMethods,
                orderHistory: customer.orderHistory,
                loyaltyProgram: customer.loyaltyProgram,
                preferences: customer.preferences
            )
        }
        
        // 测试结构体的模式匹配和解构
        for customer in customers {
            let id = customer.id
            let firstName = customer.personalInfo.firstName
            let lastName = customer.personalInfo.lastName
            let emails = customer.contactInfo.emails
            let phones = customer.contactInfo.phones
            
            _ = (id, firstName, lastName, emails, phones) // 使用解构的值
        }
        
        // 测试集合操作和哈希
        let customerSet = Set(customers)
        let customerDict = Dictionary(customers.map { ($0.id, $0) }, uniquingKeysWith: { first, _ in first })
        
        // 测试复杂的数据转换
        let customerSummaries = customers.map { customer in
            [
                "id": customer.id,
                "name": "\(customer.personalInfo.firstName) \(customer.personalInfo.lastName)",
                "totalOrders": customer.orderHistory.count,
                "totalSpent": customer.orderHistory.reduce(0) { $0 + $1.totals.total },
                "loyaltyTier": customer.loyaltyProgram?.tier ?? "None",
                "primaryEmail": customer.contactInfo.emails.first ?? "",
                "addressCount": customer.addresses.count
            ] as [String : Any]
        }
        
        print("Completed data class processing: \(customers.count) customers, \(updatedCustomers.count) updates, \(customerSummaries.count) summaries")
        print("Set size: \(customerSet.count), Dict size: \(customerDict.count)")
    }
}

public class IosSizeBenchmark {
    private let service = DataClassesService()
    
    public func runBenchmark() {
        service.massDataProcessing(customerCount: 50)
    }
}