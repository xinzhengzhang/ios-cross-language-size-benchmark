/*
 * iOS Size Benchmark - Test Case Implementation
 * Generated with Claude AI (https://claude.ai)
 * 
 * This Objective-C implementation demonstrates language-specific
 * features and patterns for binary size comparison.
 */

#import <Foundation/Foundation.h>

@interface Address : NSObject
@property (nonatomic, strong) NSString *street;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *state;
@property (nonatomic, strong) NSString *zipCode;
@property (nonatomic, strong) NSString *country;
@property (nonatomic, assign) double latitude;
@property (nonatomic, assign) double longitude;
- (NSDictionary *)toDictionary;
+ (instancetype)fromDictionary:(NSDictionary *)dict;
@end

@implementation Address
- (NSDictionary *)toDictionary {
    return @{
        @"street": self.street ?: @"",
        @"city": self.city ?: @"",
        @"state": self.state ?: @"",
        @"zipCode": self.zipCode ?: @"",
        @"country": self.country ?: @"",
        @"latitude": @(self.latitude),
        @"longitude": @(self.longitude)
    };
}

+ (instancetype)fromDictionary:(NSDictionary *)dict {
    Address *address = [[Address alloc] init];
    address.street = dict[@"street"];
    address.city = dict[@"city"];
    address.state = dict[@"state"];
    address.zipCode = dict[@"zipCode"];
    address.country = dict[@"country"];
    address.latitude = [dict[@"latitude"] doubleValue];
    address.longitude = [dict[@"longitude"] doubleValue];
    return address;
}
@end

@interface ContactInfo : NSObject
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *website;
@property (nonatomic, strong) NSArray<NSString *> *socialMedia;
- (NSDictionary *)toDictionary;
+ (instancetype)fromDictionary:(NSDictionary *)dict;
@end

@implementation ContactInfo
- (NSDictionary *)toDictionary {
    return @{
        @"email": self.email ?: @"",
        @"phone": self.phone ?: @"",
        @"website": self.website ?: @"",
        @"socialMedia": self.socialMedia ?: @[]
    };
}

+ (instancetype)fromDictionary:(NSDictionary *)dict {
    ContactInfo *contact = [[ContactInfo alloc] init];
    contact.email = dict[@"email"];
    contact.phone = dict[@"phone"];
    contact.website = dict[@"website"];
    contact.socialMedia = dict[@"socialMedia"];
    return contact;
}
@end

@interface Product : NSObject
@property (nonatomic, assign) NSInteger productId;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *category;
@property (nonatomic, assign) double price;
@property (nonatomic, assign) NSInteger inventory;
@property (nonatomic, strong) NSArray<NSString *> *tags;
@property (nonatomic, strong) NSDictionary<NSString *, NSString *> *specifications;
@property (nonatomic, strong) NSArray<NSDictionary *> *reviews;
- (NSDictionary *)toDictionary;
+ (instancetype)fromDictionary:(NSDictionary *)dict;
@end

@implementation Product
- (NSDictionary *)toDictionary {
    return @{
        @"productId": @(self.productId),
        @"name": self.name ?: @"",
        @"category": self.category ?: @"",
        @"price": @(self.price),
        @"inventory": @(self.inventory),
        @"tags": self.tags ?: @[],
        @"specifications": self.specifications ?: @{},
        @"reviews": self.reviews ?: @[]
    };
}

+ (instancetype)fromDictionary:(NSDictionary *)dict {
    Product *product = [[Product alloc] init];
    product.productId = [dict[@"productId"] integerValue];
    product.name = dict[@"name"];
    product.category = dict[@"category"];
    product.price = [dict[@"price"] doubleValue];
    product.inventory = [dict[@"inventory"] integerValue];
    product.tags = dict[@"tags"];
    product.specifications = dict[@"specifications"];
    product.reviews = dict[@"reviews"];
    return product;
}
@end

@interface Order : NSObject
@property (nonatomic, assign) NSInteger orderId;
@property (nonatomic, assign) NSInteger customerId;
@property (nonatomic, strong) NSDate *orderDate;
@property (nonatomic, strong) NSArray<Product *> *products;
@property (nonatomic, assign) double totalAmount;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) Address *shippingAddress;
@property (nonatomic, strong) Address *billingAddress;
@property (nonatomic, strong) NSDictionary<NSString *, id> *metadata;
- (NSDictionary *)toDictionary;
+ (instancetype)fromDictionary:(NSDictionary *)dict;
@end

@implementation Order
- (NSDictionary *)toDictionary {
    NSMutableArray *productsArray = [NSMutableArray array];
    for (Product *product in self.products) {
        [productsArray addObject:[product toDictionary]];
    }
    
    return @{
        @"orderId": @(self.orderId),
        @"customerId": @(self.customerId),
        @"orderDate": @([self.orderDate timeIntervalSince1970]),
        @"products": productsArray,
        @"totalAmount": @(self.totalAmount),
        @"status": self.status ?: @"",
        @"shippingAddress": [self.shippingAddress toDictionary],
        @"billingAddress": [self.billingAddress toDictionary],
        @"metadata": self.metadata ?: @{}
    };
}

+ (instancetype)fromDictionary:(NSDictionary *)dict {
    Order *order = [[Order alloc] init];
    order.orderId = [dict[@"orderId"] integerValue];
    order.customerId = [dict[@"customerId"] integerValue];
    order.orderDate = [NSDate dateWithTimeIntervalSince1970:[dict[@"orderDate"] doubleValue]];
    
    NSMutableArray *products = [NSMutableArray array];
    for (NSDictionary *productDict in dict[@"products"]) {
        [products addObject:[Product fromDictionary:productDict]];
    }
    order.products = products;
    
    order.totalAmount = [dict[@"totalAmount"] doubleValue];
    order.status = dict[@"status"];
    order.shippingAddress = [Address fromDictionary:dict[@"shippingAddress"]];
    order.billingAddress = [Address fromDictionary:dict[@"billingAddress"]];
    order.metadata = dict[@"metadata"];
    return order;
}
@end

@interface Customer : NSObject
@property (nonatomic, assign) NSInteger customerId;
@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) NSDate *birthDate;
@property (nonatomic, strong) ContactInfo *contactInfo;
@property (nonatomic, strong) NSArray<Address *> *addresses;
@property (nonatomic, strong) NSArray<Order *> *orderHistory;
@property (nonatomic, strong) NSDictionary<NSString *, id> *preferences;
@property (nonatomic, assign) BOOL isActive;
@property (nonatomic, strong) NSArray<NSString *> *loyaltyPrograms;
- (NSDictionary *)toDictionary;
+ (instancetype)fromDictionary:(NSDictionary *)dict;
@end

@implementation Customer
- (NSDictionary *)toDictionary {
    NSMutableArray *addressesArray = [NSMutableArray array];
    for (Address *address in self.addresses) {
        [addressesArray addObject:[address toDictionary]];
    }
    
    NSMutableArray *ordersArray = [NSMutableArray array];
    for (Order *order in self.orderHistory) {
        [ordersArray addObject:[order toDictionary]];
    }
    
    return @{
        @"customerId": @(self.customerId),
        @"firstName": self.firstName ?: @"",
        @"lastName": self.lastName ?: @"",
        @"birthDate": @([self.birthDate timeIntervalSince1970]),
        @"contactInfo": [self.contactInfo toDictionary],
        @"addresses": addressesArray,
        @"orderHistory": ordersArray,
        @"preferences": self.preferences ?: @{},
        @"isActive": @(self.isActive),
        @"loyaltyPrograms": self.loyaltyPrograms ?: @[]
    };
}

+ (instancetype)fromDictionary:(NSDictionary *)dict {
    Customer *customer = [[Customer alloc] init];
    customer.customerId = [dict[@"customerId"] integerValue];
    customer.firstName = dict[@"firstName"];
    customer.lastName = dict[@"lastName"];
    customer.birthDate = [NSDate dateWithTimeIntervalSince1970:[dict[@"birthDate"] doubleValue]];
    customer.contactInfo = [ContactInfo fromDictionary:dict[@"contactInfo"]];
    
    NSMutableArray *addresses = [NSMutableArray array];
    for (NSDictionary *addressDict in dict[@"addresses"]) {
        [addresses addObject:[Address fromDictionary:addressDict]];
    }
    customer.addresses = addresses;
    
    NSMutableArray *orders = [NSMutableArray array];
    for (NSDictionary *orderDict in dict[@"orderHistory"]) {
        [orders addObject:[Order fromDictionary:orderDict]];
    }
    customer.orderHistory = orders;
    
    customer.preferences = dict[@"preferences"];
    customer.isActive = [dict[@"isActive"] boolValue];
    customer.loyaltyPrograms = dict[@"loyaltyPrograms"];
    return customer;
}
@end

@interface JSONSerializationService : NSObject
- (void)performComplexJSONSerializationTest;
- (Customer *)generateComplexCustomer:(NSInteger)customerId;
- (NSString *)serializeCustomerToJSON:(Customer *)customer;
- (Customer *)deserializeCustomerFromJSON:(NSString *)jsonString;
- (void)massSerializationTest:(NSInteger)customerCount;
@end

@implementation JSONSerializationService

- (void)performComplexJSONSerializationTest {
    [self massSerializationTest:100];
}

- (Customer *)generateComplexCustomer:(NSInteger)customerId {
    Customer *customer = [[Customer alloc] init];
    customer.customerId = customerId;
    customer.firstName = [NSString stringWithFormat:@"FirstName%ld", (long)customerId];
    customer.lastName = [NSString stringWithFormat:@"LastName%ld", (long)customerId];
    customer.birthDate = [NSDate dateWithTimeIntervalSince1970:631152000 + (customerId * 86400)];
    customer.isActive = (customerId % 2 == 0);
    customer.loyaltyPrograms = @[@"Gold", @"Premium", @"VIP"];
    
    ContactInfo *contact = [[ContactInfo alloc] init];
    contact.email = [NSString stringWithFormat:@"customer%ld@email.com", (long)customerId];
    contact.phone = [NSString stringWithFormat:@"+1-555-%04ld", (long)customerId];
    contact.website = [NSString stringWithFormat:@"https://customer%ld.com", (long)customerId];
    contact.socialMedia = @[@"twitter", @"linkedin", @"facebook"];
    customer.contactInfo = contact;
    
    NSMutableArray *addresses = [NSMutableArray array];
    for (NSInteger i = 0; i < 3; i++) {
        Address *address = [[Address alloc] init];
        address.street = [NSString stringWithFormat:@"%ld%ld Main Street", (long)customerId, (long)i];
        address.city = [NSString stringWithFormat:@"City%ld", (long)customerId + i];
        address.state = [NSString stringWithFormat:@"State%ld", (long)i];
        address.zipCode = [NSString stringWithFormat:@"%05ld", (long)(customerId * 100 + i)];
        address.country = @"USA";
        address.latitude = 40.0 + (customerId % 10);
        address.longitude = -74.0 + (customerId % 10);
        [addresses addObject:address];
    }
    customer.addresses = addresses;
    
    NSMutableArray *orders = [NSMutableArray array];
    for (NSInteger i = 0; i < 5; i++) {
        Order *order = [[Order alloc] init];
        order.orderId = customerId * 100 + i;
        order.customerId = customerId;
        order.orderDate = [NSDate dateWithTimeIntervalSince1970:1609459200 + (i * 86400)];
        order.status = @"completed";
        order.shippingAddress = [addresses firstObject];
        order.billingAddress = [addresses lastObject];
        order.metadata = @{
            @"source": @"mobile",
            @"campaign": [NSString stringWithFormat:@"campaign%ld", (long)i],
            @"discount": @(i * 5.0)
        };
        
        NSMutableArray *products = [NSMutableArray array];
        for (NSInteger j = 0; j < 3; j++) {
            Product *product = [[Product alloc] init];
            product.productId = i * 10 + j;
            product.name = [NSString stringWithFormat:@"Product%ld-%ld", (long)i, (long)j];
            product.category = [NSString stringWithFormat:@"Category%ld", (long)j];
            product.price = 99.99 + (j * 50.0);
            product.inventory = 100 + j;
            product.tags = @[@"featured", @"bestseller", @"new"];
            product.specifications = @{
                @"weight": [NSString stringWithFormat:@"%.1f kg", 1.0 + j],
                @"dimensions": [NSString stringWithFormat:@"%.0fx%.0fx%.0f cm", 10.0 + j, 20.0 + j, 5.0 + j],
                @"material": @"premium"
            };
            
            NSMutableArray *reviews = [NSMutableArray array];
            for (NSInteger k = 0; k < 2; k++) {
                NSDictionary *review = @{
                    @"reviewId": @(k),
                    @"rating": @(4 + k),
                    @"comment": [NSString stringWithFormat:@"Great product review %ld", (long)k],
                    @"reviewer": [NSString stringWithFormat:@"Reviewer%ld", (long)k]
                };
                [reviews addObject:review];
            }
            product.reviews = reviews;
            [products addObject:product];
        }
        order.products = products;
        
        double total = 0;
        for (Product *p in products) {
            total += p.price;
        }
        order.totalAmount = total;
        [orders addObject:order];
    }
    customer.orderHistory = orders;
    
    customer.preferences = @{
        @"notifications": @{
            @"email": @YES,
            @"sms": @NO,
            @"push": @YES
        },
        @"language": @"en-US",
        @"currency": @"USD",
        @"timezone": @"America/New_York"
    };
    
    return customer;
}

- (NSString *)serializeCustomerToJSON:(Customer *)customer {
    NSDictionary *customerDict = [customer toDictionary];
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:customerDict options:NSJSONWritingPrettyPrinted error:&error];
    if (error) {
        NSLog(@"JSON Serialization Error: %@", error.localizedDescription);
        return nil;
    }
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

- (Customer *)deserializeCustomerFromJSON:(NSString *)jsonString {
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSDictionary *customerDict = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
    if (error) {
        NSLog(@"JSON Deserialization Error: %@", error.localizedDescription);
        return nil;
    }
    return [Customer fromDictionary:customerDict];
}

- (void)massSerializationTest:(NSInteger)customerCount {
    NSMutableArray *customers = [NSMutableArray array];
    NSMutableArray *jsonStrings = [NSMutableArray array];
    
    NSLog(@"Generating %ld complex customers...", (long)customerCount);
    for (NSInteger i = 1; i <= customerCount; i++) {
        Customer *customer = [self generateComplexCustomer:i];
        [customers addObject:customer];
    }
    
    NSLog(@"Serializing %ld customers to JSON...", (long)customerCount);
    for (Customer *customer in customers) {
        NSString *jsonString = [self serializeCustomerToJSON:customer];
        if (jsonString) {
            [jsonStrings addObject:jsonString];
        }
    }
    
    NSLog(@"Deserializing %ld JSON strings back to objects...", (long)[jsonStrings count]);
    NSMutableArray *deserializedCustomers = [NSMutableArray array];
    for (NSString *jsonString in jsonStrings) {
        Customer *customer = [self deserializeCustomerFromJSON:jsonString];
        if (customer) {
            [deserializedCustomers addObject:customer];
        }
    }
    
    NSLog(@"Completed JSON serialization test: Generated %ld, Serialized %ld, Deserialized %ld",
          (long)[customers count], (long)[jsonStrings count], (long)[deserializedCustomers count]);
    
    for (NSInteger i = 0; i < MIN(3, [jsonStrings count]); i++) {
        NSString *jsonString = jsonStrings[i];
        NSLog(@"Sample JSON length %ld: %ld characters", (long)i, (long)[jsonString length]);
    }
}

@end

@interface IosSizeBenchmark : NSObject
@property (nonatomic, strong) JSONSerializationService *jsonService;
- (void)runBenchmark;
@end

@implementation IosSizeBenchmark

- (instancetype)init {
    self = [super init];
    if (self) {
        _jsonService = [[JSONSerializationService alloc] init];
    }
    return self;
}

- (void)runBenchmark {
    [self.jsonService performComplexJSONSerializationTest];
}

@end