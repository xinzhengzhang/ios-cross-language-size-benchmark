/*
 * iOS Size Benchmark - Test Case Implementation
 * Generated with Claude AI (https://claude.ai)
 * 
 * This Objective-C implementation demonstrates language-specific
 * features and patterns for binary size comparison.
 */

#import <Foundation/Foundation.h>

// Objective-C 使用传统的类结构模拟数据类

@interface Address : NSObject
@property (nonatomic, strong) NSString *street;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, assign) double latitude;
@property (nonatomic, assign) double longitude;
@property (nonatomic, strong) NSDictionary *metadata;
- (instancetype)initWithStreet:(NSString *)street city:(NSString *)city latitude:(double)latitude longitude:(double)longitude metadata:(NSDictionary *)metadata;
- (BOOL)isEqualToAddress:(Address *)other;
- (Address *)copyWithUpdates:(NSDictionary *)updates;
@end

@implementation Address
- (instancetype)initWithStreet:(NSString *)street city:(NSString *)city latitude:(double)latitude longitude:(double)longitude metadata:(NSDictionary *)metadata {
    self = [super init];
    if (self) {
        _street = [street copy];
        _city = [city copy];
        _latitude = latitude;
        _longitude = longitude;
        _metadata = [metadata copy] ?: @{};
    }
    return self;
}

- (BOOL)isEqualToAddress:(Address *)other {
    if (!other) return NO;
    return [self.street isEqualToString:other.street] &&
           [self.city isEqualToString:other.city] &&
           self.latitude == other.latitude &&
           self.longitude == other.longitude &&
           [self.metadata isEqualToDictionary:other.metadata];
}

- (NSUInteger)hash {
    return [self.street hash] ^ [self.city hash] ^ [@(self.latitude) hash] ^ [@(self.longitude) hash];
}

- (Address *)copyWithUpdates:(NSDictionary *)updates {
    return [[Address alloc] initWithStreet:updates[@"street"] ?: self.street
                                      city:updates[@"city"] ?: self.city
                                  latitude:updates[@"latitude"] ? [updates[@"latitude"] doubleValue] : self.latitude
                                 longitude:updates[@"longitude"] ? [updates[@"longitude"] doubleValue] : self.longitude
                                  metadata:updates[@"metadata"] ?: self.metadata];
}
@end

@interface ContactInfo : NSObject
@property (nonatomic, strong) NSArray<NSString *> *emails;
@property (nonatomic, strong) NSSet<NSString *> *phones;
@property (nonatomic, strong) NSDictionary<NSString *, NSString *> *socialMedia;
@property (nonatomic, strong) NSDictionary<NSString *, NSNumber *> *preferences;
- (instancetype)initWithEmails:(NSArray<NSString *> *)emails phones:(NSSet<NSString *> *)phones socialMedia:(NSDictionary<NSString *, NSString *> *)socialMedia preferences:(NSDictionary<NSString *, NSNumber *> *)preferences;
- (ContactInfo *)copyWithUpdates:(NSDictionary *)updates;
@end

@implementation ContactInfo
- (instancetype)initWithEmails:(NSArray<NSString *> *)emails phones:(NSSet<NSString *> *)phones socialMedia:(NSDictionary<NSString *, NSString *> *)socialMedia preferences:(NSDictionary<NSString *, NSNumber *> *)preferences {
    self = [super init];
    if (self) {
        _emails = [emails copy] ?: @[];
        _phones = [phones copy] ?: [NSSet set];
        _socialMedia = [socialMedia copy] ?: @{};
        _preferences = preferences ?: @{@"notifications": @YES, @"marketing": @NO};
    }
    return self;
}

- (ContactInfo *)copyWithUpdates:(NSDictionary *)updates {
    return [[ContactInfo alloc] initWithEmails:updates[@"emails"] ?: self.emails
                                        phones:updates[@"phones"] ?: self.phones
                                   socialMedia:updates[@"socialMedia"] ?: self.socialMedia
                                   preferences:updates[@"preferences"] ?: self.preferences];
}

- (NSUInteger)hash {
    return [self.emails hash] ^ [self.phones hash] ^ [self.socialMedia hash];
}
@end

@interface Product : NSObject
@property (nonatomic, assign) NSInteger productId;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *category;
@property (nonatomic, assign) double basePrice;
@property (nonatomic, strong) NSArray<NSNumber *> *taxes;
@property (nonatomic, strong) NSDictionary<NSString *, NSNumber *> *discounts;
@property (nonatomic, strong) NSSet<NSString *> *tags;
@property (nonatomic, readonly) double finalPrice;
@property (nonatomic, readonly) NSString *displayName;
- (instancetype)initWithId:(NSInteger)productId name:(NSString *)name category:(NSString *)category basePrice:(double)basePrice taxes:(NSArray<NSNumber *> *)taxes discounts:(NSDictionary<NSString *, NSNumber *> *)discounts tags:(NSSet<NSString *> *)tags;
@end

@implementation Product
- (instancetype)initWithId:(NSInteger)productId name:(NSString *)name category:(NSString *)category basePrice:(double)basePrice taxes:(NSArray<NSNumber *> *)taxes discounts:(NSDictionary<NSString *, NSNumber *> *)discounts tags:(NSSet<NSString *> *)tags {
    self = [super init];
    if (self) {
        _productId = productId;
        _name = [name copy];
        _category = [category copy];
        _basePrice = basePrice;
        _taxes = [taxes copy] ?: @[];
        _discounts = [discounts copy] ?: @{};
        _tags = [tags copy] ?: [NSSet set];
    }
    return self;
}

- (double)finalPrice {
    double taxSum = 0;
    for (NSNumber *tax in self.taxes) {
        taxSum += [tax doubleValue];
    }
    
    double discountSum = 0;
    for (NSNumber *discount in self.discounts.allValues) {
        discountSum += [discount doubleValue];
    }
    
    return self.basePrice + taxSum - discountSum;
}

- (NSString *)displayName {
    if ([self.tags containsObject:@"featured"]) {
        return [NSString stringWithFormat:@"⭐ %@", self.name];
    }
    return self.name;
}
@end

@interface OrderItem : NSObject
@property (nonatomic, strong) Product *product;
@property (nonatomic, assign) NSInteger quantity;
@property (nonatomic, strong) NSDictionary<NSString *, id> *customizations;
@property (nonatomic, strong) NSArray<OrderItem *> *bundledItems;
@property (nonatomic, readonly) double totalPrice;
- (instancetype)initWithProduct:(Product *)product quantity:(NSInteger)quantity customizations:(NSDictionary<NSString *, id> *)customizations bundledItems:(NSArray<OrderItem *> *)bundledItems;
@end

@implementation OrderItem
- (instancetype)initWithProduct:(Product *)product quantity:(NSInteger)quantity customizations:(NSDictionary<NSString *, id> *)customizations bundledItems:(NSArray<OrderItem *> *)bundledItems {
    self = [super init];
    if (self) {
        _product = product;
        _quantity = quantity;
        _customizations = [customizations copy] ?: @{};
        _bundledItems = [bundledItems copy] ?: @[];
    }
    return self;
}

- (double)totalPrice {
    double bundledTotal = 0;
    for (OrderItem *item in self.bundledItems) {
        bundledTotal += item.totalPrice;
    }
    return self.product.finalPrice * self.quantity + bundledTotal;
}
@end

// 枚举模拟密封类
typedef NS_ENUM(NSInteger, PaymentMethodType) {
    PaymentMethodTypeCreditCard,
    PaymentMethodTypeBankTransfer,
    PaymentMethodTypeDigitalWallet,
    PaymentMethodTypeCash
};

@interface PaymentMethod : NSObject
@property (nonatomic, assign) PaymentMethodType type;
@property (nonatomic, strong) NSDictionary *data;
+ (instancetype)creditCardWithNumber:(NSString *)number expiryMonth:(NSInteger)month expiryYear:(NSInteger)year securityCode:(NSString *)code billingAddress:(Address *)address;
+ (instancetype)bankTransferWithAccount:(NSString *)account routing:(NSString *)routing bankName:(NSString *)bankName;
+ (instancetype)digitalWalletWithProvider:(NSString *)provider accountId:(NSString *)accountId linkedCards:(NSArray *)cards;
+ (instancetype)cash;
@end

@implementation PaymentMethod
+ (instancetype)creditCardWithNumber:(NSString *)number expiryMonth:(NSInteger)month expiryYear:(NSInteger)year securityCode:(NSString *)code billingAddress:(Address *)address {
    PaymentMethod *method = [[PaymentMethod alloc] init];
    method.type = PaymentMethodTypeCreditCard;
    method.data = @{
        @"number": number,
        @"expiryMonth": @(month),
        @"expiryYear": @(year),
        @"securityCode": code,
        @"billingAddress": address
    };
    return method;
}

+ (instancetype)bankTransferWithAccount:(NSString *)account routing:(NSString *)routing bankName:(NSString *)bankName {
    PaymentMethod *method = [[PaymentMethod alloc] init];
    method.type = PaymentMethodTypeBankTransfer;
    method.data = @{
        @"accountNumber": account,
        @"routingNumber": routing,
        @"bankName": bankName
    };
    return method;
}

+ (instancetype)digitalWalletWithProvider:(NSString *)provider accountId:(NSString *)accountId linkedCards:(NSArray *)cards {
    PaymentMethod *method = [[PaymentMethod alloc] init];
    method.type = PaymentMethodTypeDigitalWallet;
    method.data = @{
        @"provider": provider,
        @"accountId": accountId,
        @"linkedCards": cards ?: @[]
    };
    return method;
}

+ (instancetype)cash {
    PaymentMethod *method = [[PaymentMethod alloc] init];
    method.type = PaymentMethodTypeCash;
    method.data = @{};
    return method;
}
@end

// 更多数据类...
@interface PersonalInfo : NSObject
@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) NSString *dateOfBirth;
@property (nonatomic, strong) NSString *nationality;
@property (nonatomic, strong) NSDictionary<NSString *, NSString *> *governmentIds;
- (instancetype)initWithFirstName:(NSString *)firstName lastName:(NSString *)lastName dateOfBirth:(NSString *)dateOfBirth nationality:(NSString *)nationality governmentIds:(NSDictionary<NSString *, NSString *> *)governmentIds;
- (PersonalInfo *)copyWithUpdates:(NSDictionary *)updates;
@end

@implementation PersonalInfo
- (instancetype)initWithFirstName:(NSString *)firstName lastName:(NSString *)lastName dateOfBirth:(NSString *)dateOfBirth nationality:(NSString *)nationality governmentIds:(NSDictionary<NSString *, NSString *> *)governmentIds {
    self = [super init];
    if (self) {
        _firstName = [firstName copy];
        _lastName = [lastName copy];
        _dateOfBirth = [dateOfBirth copy];
        _nationality = [nationality copy];
        _governmentIds = [governmentIds copy] ?: @{};
    }
    return self;
}

- (PersonalInfo *)copyWithUpdates:(NSDictionary *)updates {
    return [[PersonalInfo alloc] initWithFirstName:updates[@"firstName"] ?: self.firstName
                                          lastName:updates[@"lastName"] ?: self.lastName
                                       dateOfBirth:updates[@"dateOfBirth"] ?: self.dateOfBirth
                                       nationality:updates[@"nationality"] ?: self.nationality
                                     governmentIds:updates[@"governmentIds"] ?: self.governmentIds];
}
@end

@interface Customer : NSObject
@property (nonatomic, assign) NSInteger customerId;
@property (nonatomic, strong) PersonalInfo *personalInfo;
@property (nonatomic, strong) ContactInfo *contactInfo;
@property (nonatomic, strong) NSArray<Address *> *addresses;
@property (nonatomic, strong) NSArray<PaymentMethod *> *paymentMethods;
@property (nonatomic, strong) NSDictionary *preferences;
- (instancetype)initWithId:(NSInteger)customerId personalInfo:(PersonalInfo *)personalInfo contactInfo:(ContactInfo *)contactInfo addresses:(NSArray<Address *> *)addresses paymentMethods:(NSArray<PaymentMethod *> *)paymentMethods preferences:(NSDictionary *)preferences;
- (Customer *)copyWithUpdates:(NSDictionary *)updates;
@end

@implementation Customer
- (instancetype)initWithId:(NSInteger)customerId personalInfo:(PersonalInfo *)personalInfo contactInfo:(ContactInfo *)contactInfo addresses:(NSArray<Address *> *)addresses paymentMethods:(NSArray<PaymentMethod *> *)paymentMethods preferences:(NSDictionary *)preferences {
    self = [super init];
    if (self) {
        _customerId = customerId;
        _personalInfo = personalInfo;
        _contactInfo = contactInfo;
        _addresses = [addresses copy] ?: @[];
        _paymentMethods = [paymentMethods copy] ?: @[];
        _preferences = [preferences copy] ?: @{};
    }
    return self;
}

- (Customer *)copyWithUpdates:(NSDictionary *)updates {
    return [[Customer alloc] initWithId:updates[@"customerId"] ? [updates[@"customerId"] integerValue] : self.customerId
                           personalInfo:updates[@"personalInfo"] ?: self.personalInfo
                            contactInfo:updates[@"contactInfo"] ?: self.contactInfo
                              addresses:updates[@"addresses"] ?: self.addresses
                         paymentMethods:updates[@"paymentMethods"] ?: self.paymentMethods
                            preferences:updates[@"preferences"] ?: self.preferences];
}
@end

@interface DataClassesService : NSObject
- (Customer *)generateComplexCustomer:(NSInteger)customerId;
- (void)massDataProcessing:(NSInteger)customerCount;
@end

@implementation DataClassesService

- (Customer *)generateComplexCustomer:(NSInteger)customerId {
    PersonalInfo *personalInfo = [[PersonalInfo alloc] initWithFirstName:[NSString stringWithFormat:@"John%ld", (long)customerId]
                                                                lastName:[NSString stringWithFormat:@"Doe%ld", (long)customerId]
                                                             dateOfBirth:@"1990-01-01"
                                                             nationality:@"US"
                                                           governmentIds:@{
                                                               @"ssn": [NSString stringWithFormat:@"123-45-%04ld", (long)customerId],
                                                               @"passport": [NSString stringWithFormat:@"P%ld234567", (long)customerId]
                                                           }];
    
    ContactInfo *contactInfo = [[ContactInfo alloc] initWithEmails:@[
                                    [NSString stringWithFormat:@"john.doe%ld@email.com", (long)customerId],
                                    [NSString stringWithFormat:@"john%ld@work.com", (long)customerId]
                                ]
                                                               phones:[NSSet setWithArray:@[
                                                                   [NSString stringWithFormat:@"+1-555-%04ld", (long)customerId],
                                                                   [NSString stringWithFormat:@"+1-555-%04ld", (long)customerId + 1000]
                                                               ]]
                                                          socialMedia:@{
                                                              @"twitter": [NSString stringWithFormat:@"@john%ld", (long)customerId],
                                                              @"linkedin": [NSString stringWithFormat:@"john-doe-%ld", (long)customerId]
                                                          }
                                                          preferences:@{
                                                              @"notifications": @YES,
                                                              @"marketing": @NO
                                                          }];
    
    NSArray<Address *> *addresses = @[
        [[Address alloc] initWithStreet:[NSString stringWithFormat:@"%ld00 Main St", (long)customerId]
                                   city:@"New York"
                               latitude:40.7128
                              longitude:-74.0060
                               metadata:@{@"type": @"home", @"primary": @YES}],
        [[Address alloc] initWithStreet:[NSString stringWithFormat:@"%ld01 Business Ave", (long)customerId]
                                   city:@"Boston"
                               latitude:42.3601
                              longitude:-71.0589
                               metadata:@{@"type": @"work", @"primary": @NO}]
    ];
    
    NSArray<PaymentMethod *> *paymentMethods = @[
        [PaymentMethod creditCardWithNumber:[NSString stringWithFormat:@"4532-1234-5678-%04ld", (long)customerId]
                                expiryMonth:12
                                 expiryYear:2027
                               securityCode:@"123"
                             billingAddress:addresses.firstObject],
        [PaymentMethod digitalWalletWithProvider:@"ApplePay"
                                       accountId:[NSString stringWithFormat:@"apple_%ld", (long)customerId]
                                     linkedCards:@[]]
    ];
    
    NSDictionary *preferences = @{
        @"language": @"en-US",
        @"currency": @"USD",
        @"timezone": @"America/New_York",
        @"notifications": @{
            @"email": @YES,
            @"sms": @NO,
            @"push": @YES,
            @"marketing": @NO
        },
        @"privacy": @{
            @"share_data": @"no",
            @"cookies": @"essential_only",
            @"analytics": @"anonymized"
        }
    };
    
    return [[Customer alloc] initWithId:customerId
                           personalInfo:personalInfo
                            contactInfo:contactInfo
                              addresses:addresses
                         paymentMethods:paymentMethods
                            preferences:preferences];
}

- (void)massDataProcessing:(NSInteger)customerCount {
    NSLog(@"Generating %ld complex customers with nested data structures...", (long)customerCount);
    
    NSMutableArray<Customer *> *customers = [NSMutableArray array];
    for (NSInteger i = 1; i <= customerCount; i++) {
        Customer *customer = [self generateComplexCustomer:i];
        [customers addObject:customer];
    }
    
    NSLog(@"Processing data class operations...");
    
    // 测试复制操作
    NSMutableArray<Customer *> *updatedCustomers = [NSMutableArray array];
    for (Customer *customer in customers) {
        PersonalInfo *updatedPersonalInfo = [customer.personalInfo copyWithUpdates:@{
            @"firstName": [NSString stringWithFormat:@"%@_Updated", customer.personalInfo.firstName]
        }];
        
        Customer *updatedCustomer = [customer copyWithUpdates:@{
            @"personalInfo": updatedPersonalInfo
        }];
        [updatedCustomers addObject:updatedCustomer];
    }
    
    // 测试数据转换
    NSMutableArray<NSDictionary *> *customerSummaries = [NSMutableArray array];
    for (Customer *customer in customers) {
        NSDictionary *summary = @{
            @"id": @(customer.customerId),
            @"name": [NSString stringWithFormat:@"%@ %@", customer.personalInfo.firstName, customer.personalInfo.lastName],
            @"primaryEmail": customer.contactInfo.emails.firstObject ?: @"",
            @"addressCount": @(customer.addresses.count),
            @"paymentMethodCount": @(customer.paymentMethods.count)
        };
        [customerSummaries addObject:summary];
    }
    
    NSLog(@"Completed data class processing: %ld customers, %ld updates, %ld summaries", 
          (long)customers.count, (long)updatedCustomers.count, (long)customerSummaries.count);
}

@end

@interface IosSizeBenchmark : NSObject
@property (nonatomic, strong) DataClassesService *service;
- (void)runBenchmark;
@end

@implementation IosSizeBenchmark

- (instancetype)init {
    self = [super init];
    if (self) {
        _service = [[DataClassesService alloc] init];
    }
    return self;
}

- (void)runBenchmark {
    [self.service massDataProcessing:50];
}

@end