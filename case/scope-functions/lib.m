/*
 * iOS Size Benchmark - Test Case Implementation
 * Generated with Claude AI (https://claude.ai)
 * 
 * This Objective-C implementation demonstrates language-specific
 * features and patterns for binary size comparison.
 */

#import <Foundation/Foundation.h>

// Test case: Scope Functions - Objective-C equivalent requiring manual patterns for Kotlin's scope functions
// This demonstrates how extremely verbose Objective-C becomes without Kotlin's elegant scope functions

// Forward declarations
@class Address;
@class UserPreferences;
@class Product;
@class ShoppingCart;
@class CartItem;
@class Order;
@class BankAccount;
@class ApiResponse;
@class DatabaseConfig;
@class ConnectionPoolConfig;
@class AppConfig;

// Data model interfaces - much more verbose than Kotlin data classes
@interface User : NSObject

@property (nonatomic, strong, nonnull) NSString *userId;
@property (nonatomic, strong, nonnull) NSString *name;
@property (nonatomic, strong, nonnull) NSString *email;
@property (nonatomic, assign) NSInteger age;
@property (nonatomic, strong, nullable) Address *address;
@property (nonatomic, strong, nullable) UserPreferences *preferences;

- (instancetype _Nonnull)initWithId:(NSString * _Nonnull)userId
                               name:(NSString * _Nonnull)name
                              email:(NSString * _Nonnull)email
                                age:(NSInteger)age
                            address:(Address * _Nullable)address
                        preferences:(UserPreferences * _Nullable)preferences;

@end

@interface Address : NSObject

@property (nonatomic, strong, nonnull) NSString *street;
@property (nonatomic, strong, nonnull) NSString *city;
@property (nonatomic, strong, nonnull) NSString *state;
@property (nonatomic, strong, nonnull) NSString *zipCode;
@property (nonatomic, strong, nonnull) NSString *country;

- (instancetype _Nonnull)initWithStreet:(NSString * _Nonnull)street
                                   city:(NSString * _Nonnull)city
                                  state:(NSString * _Nonnull)state
                                zipCode:(NSString * _Nonnull)zipCode
                                country:(NSString * _Nonnull)country;

@end

@interface UserPreferences : NSObject

@property (nonatomic, strong, nonnull) NSString *theme;
@property (nonatomic, strong, nonnull) NSString *language;
@property (nonatomic, assign) BOOL notifications;
@property (nonatomic, assign) BOOL newsletter;

- (instancetype _Nonnull)initWithTheme:(NSString * _Nonnull)theme
                              language:(NSString * _Nonnull)language
                         notifications:(BOOL)notifications
                            newsletter:(BOOL)newsletter;

@end

@interface Product : NSObject

@property (nonatomic, strong, nonnull) NSString *productId;
@property (nonatomic, strong, nonnull) NSString *name;
@property (nonatomic, assign) double price;
@property (nonatomic, strong, nonnull) NSString *category;
@property (nonatomic, strong, nonnull) NSString *productDescription;
@property (nonatomic, assign) BOOL inStock;
@property (nonatomic, strong, nonnull) NSMutableArray<NSString *> *tags;

- (instancetype _Nonnull)initWithId:(NSString * _Nonnull)productId
                               name:(NSString * _Nonnull)name
                              price:(double)price
                           category:(NSString * _Nonnull)category
                        description:(NSString * _Nonnull)description
                            inStock:(BOOL)inStock
                               tags:(NSMutableArray<NSString *> * _Nonnull)tags;

@end

@interface ShoppingCart : NSObject

@property (nonatomic, strong, nonnull) NSString *cartId;
@property (nonatomic, strong, nonnull) NSString *userId;
@property (nonatomic, strong, nonnull) NSMutableArray<CartItem *> *items;
@property (nonatomic, strong, nullable) NSString *discountCode;
@property (nonatomic, assign) double discountAmount;

- (instancetype _Nonnull)initWithId:(NSString * _Nonnull)cartId
                             userId:(NSString * _Nonnull)userId
                              items:(NSMutableArray<CartItem *> * _Nonnull)items
                       discountCode:(NSString * _Nullable)discountCode
                     discountAmount:(double)discountAmount;

@end

@interface CartItem : NSObject

@property (nonatomic, strong, nonnull) NSString *productId;
@property (nonatomic, assign) NSInteger quantity;
@property (nonatomic, assign) double price;

- (instancetype _Nonnull)initWithProductId:(NSString * _Nonnull)productId
                                  quantity:(NSInteger)quantity
                                     price:(double)price;

@end

@interface Order : NSObject

@property (nonatomic, strong, nonnull) NSString *orderId;
@property (nonatomic, strong, nonnull) ShoppingCart *cart;
@property (nonatomic, strong, nonnull) Address *shippingAddress;
@property (nonatomic, strong, nonnull) NSString *paymentMethod;
@property (nonatomic, strong, nonnull) NSString *status;
@property (nonatomic, assign) long long timestamp;

- (instancetype _Nonnull)initWithId:(NSString * _Nonnull)orderId
                               cart:(ShoppingCart * _Nonnull)cart
                    shippingAddress:(Address * _Nonnull)shippingAddress
                      paymentMethod:(NSString * _Nonnull)paymentMethod
                             status:(NSString * _Nonnull)status
                          timestamp:(long long)timestamp;

@end

@interface BankAccount : NSObject

@property (nonatomic, strong, nonnull) NSString *accountNumber;
@property (nonatomic, assign) double balance;
@property (nonatomic, strong, nonnull) NSString *accountType;
@property (nonatomic, assign) BOOL isActive;

- (instancetype _Nonnull)initWithAccountNumber:(NSString * _Nonnull)accountNumber
                                       balance:(double)balance
                                   accountType:(NSString * _Nonnull)accountType
                                      isActive:(BOOL)isActive;

@end

@interface ApiResponse : NSObject

@property (nonatomic, strong, nullable) id data;
@property (nonatomic, strong, nullable) NSString *errorMessage;
@property (nonatomic, assign) NSInteger statusCode;
@property (nonatomic, strong, nonnull) NSMutableDictionary<NSString *, NSString *> *headers;

- (instancetype _Nonnull)initWithData:(id _Nullable)data
                         errorMessage:(NSString * _Nullable)errorMessage
                           statusCode:(NSInteger)statusCode
                              headers:(NSMutableDictionary<NSString *, NSString *> * _Nonnull)headers;

@end

// Configuration classes
@interface DatabaseConfig : NSObject

@property (nonatomic, strong, nonnull) NSString *host;
@property (nonatomic, assign) NSInteger port;
@property (nonatomic, strong, nonnull) NSString *database;
@property (nonatomic, strong, nonnull) NSString *username;
@property (nonatomic, strong, nonnull) NSString *password;
@property (nonatomic, strong, nullable) ConnectionPoolConfig *connectionPool;

- (instancetype _Nonnull)initWithHost:(NSString * _Nonnull)host
                                 port:(NSInteger)port
                             database:(NSString * _Nonnull)database
                             username:(NSString * _Nonnull)username
                             password:(NSString * _Nonnull)password
                       connectionPool:(ConnectionPoolConfig * _Nullable)connectionPool;

@end

@interface ConnectionPoolConfig : NSObject

@property (nonatomic, assign) NSInteger minConnections;
@property (nonatomic, assign) NSInteger maxConnections;
@property (nonatomic, assign) long long timeout;

- (instancetype _Nonnull)initWithMinConnections:(NSInteger)minConnections
                                 maxConnections:(NSInteger)maxConnections
                                        timeout:(long long)timeout;

@end

@interface AppConfig : NSObject

@property (nonatomic, strong, nonnull) NSString *appName;
@property (nonatomic, strong, nonnull) NSString *version;
@property (nonatomic, strong, nonnull) NSString *environment;
@property (nonatomic, strong, nonnull) DatabaseConfig *database;
@property (nonatomic, strong, nonnull) NSMutableDictionary<NSString *, NSNumber *> *features;
@property (nonatomic, strong, nonnull) NSMutableDictionary<NSString *, NSString *> *settings;

- (instancetype _Nonnull)initWithAppName:(NSString * _Nonnull)appName
                                 version:(NSString * _Nonnull)version
                             environment:(NSString * _Nonnull)environment
                                database:(DatabaseConfig * _Nonnull)database
                                features:(NSMutableDictionary<NSString *, NSNumber *> * _Nonnull)features
                                settings:(NSMutableDictionary<NSString *, NSString *> * _Nonnull)settings;

@end

// Service classes demonstrating extremely verbose patterns instead of Kotlin's elegant scope functions
@interface UserService : NSObject

- (User * _Nonnull)createUserWithName:(NSString * _Nonnull)name
                                email:(NSString * _Nonnull)email
                                  age:(NSInteger)age;

- (User * _Nullable)updateUserWithValidation:(User * _Nonnull)user
                                    newEmail:(NSString * _Nullable)newEmail
                                      newAge:(NSNumber * _Nullable)newAge;

- (NSString * _Nonnull)processUserData:(User * _Nullable)user;

- (User * _Nonnull)configureUserPreferences:(User * _Nonnull)user;

- (NSString * _Nonnull)validateAndFormatUser:(User * _Nonnull)user;

- (NSDictionary<NSString *, id> * _Nonnull)getUserSummary:(User * _Nullable)user;

@end

@interface ProductService : NSObject

- (Product * _Nonnull)createProductWithName:(NSString * _Nonnull)name
                                      price:(double)price
                                   category:(NSString * _Nonnull)category;

- (Product * _Nullable)updateProductPrice:(Product * _Nonnull)product
                                 newPrice:(double)newPrice;

- (NSArray<NSString *> * _Nonnull)processProductBatch:(NSArray<Product *> * _Nonnull)products;

- (Product * _Nonnull)configureProductForSale:(Product * _Nonnull)product
                               discountPercent:(double)discountPercent;

- (NSDictionary<NSString *, id> * _Nonnull)analyzeProduct:(Product * _Nonnull)product;

@end

@interface ShoppingCartService : NSObject

- (ShoppingCart * _Nonnull)createCartWithUserId:(NSString * _Nonnull)userId;

- (ShoppingCart * _Nonnull)addItemToCart:(ShoppingCart * _Nonnull)cart
                               productId:(NSString * _Nonnull)productId
                                quantity:(NSInteger)quantity
                                   price:(double)price;

- (ShoppingCart * _Nullable)applyDiscount:(ShoppingCart * _Nonnull)cart
                             discountCode:(NSString * _Nonnull)discountCode;

- (Order * _Nullable)processCartCheckout:(ShoppingCart * _Nonnull)cart
                         shippingAddress:(Address * _Nonnull)shippingAddress
                           paymentMethod:(NSString * _Nonnull)paymentMethod;

- (NSDictionary<NSString *, id> * _Nonnull)calculateCartSummary:(ShoppingCart * _Nonnull)cart;

@end

@interface BankingService : NSObject

- (BankAccount * _Nonnull)createAccountWithAccountNumber:(NSString * _Nonnull)accountNumber
                                             accountType:(NSString * _Nonnull)accountType;

- (BankAccount * _Nullable)processTransaction:(BankAccount * _Nonnull)account
                                       amount:(double)amount
                                         type:(NSString * _Nonnull)type;

- (NSDictionary<NSString *, id> * _Nonnull)generateAccountStatement:(BankAccount * _Nonnull)account;

- (NSArray<BankAccount *> * _Nonnull)transferFunds:(BankAccount * _Nonnull)fromAccount
                                         toAccount:(BankAccount * _Nonnull)toAccount
                                            amount:(double)amount;

@end

@interface ApiService : NSObject

- (id _Nullable)processApiResponse:(ApiResponse * _Nonnull)response;

- (ApiResponse * _Nonnull)createApiResponseWithData:(id _Nullable)data
                                         statusCode:(NSInteger)statusCode
                                       errorMessage:(NSString * _Nullable)errorMessage;

- (NSString * _Nonnull)handleApiError:(ApiResponse * _Nonnull)response;

- (ApiResponse * _Nullable)retryApiCallWithMaxRetries:(NSInteger)maxRetries
                                              apiCall:(ApiResponse * (^_Nonnull)(void))apiCall;

@end

@interface ConfigurationService : NSObject

- (DatabaseConfig * _Nonnull)createDatabaseConfigWithHost:(NSString * _Nonnull)host
                                                     port:(NSInteger)port
                                                 database:(NSString * _Nonnull)database;

- (AppConfig * _Nonnull)createAppConfigWithAppName:(NSString * _Nonnull)appName
                                            version:(NSString * _Nonnull)version
                                        environment:(NSString * _Nonnull)environment;

- (NSDictionary<NSString *, id> * _Nonnull)validateConfiguration:(AppConfig * _Nonnull)config;

- (AppConfig * _Nonnull)updateConfiguration:(AppConfig * _Nonnull)config
                                withUpdates:(NSDictionary<NSString *, NSString *> * _Nonnull)updates;

@end

@interface IosSizeBenchmark : NSObject

- (void)runBenchmark;

@end

// Implementation section - demonstrating the extreme verbosity of Objective-C

@implementation User

- (instancetype)initWithId:(NSString *)userId name:(NSString *)name email:(NSString *)email age:(NSInteger)age address:(Address *)address preferences:(UserPreferences *)preferences {
    self = [super init];
    if (self) {
        _userId = userId;
        _name = name;
        _email = email;
        _age = age;
        _address = address;
        _preferences = preferences;
    }
    return self;
}

@end

@implementation Address

- (instancetype)initWithStreet:(NSString *)street city:(NSString *)city state:(NSString *)state zipCode:(NSString *)zipCode country:(NSString *)country {
    self = [super init];
    if (self) {
        _street = street;
        _city = city;
        _state = state;
        _zipCode = zipCode;
        _country = country;
    }
    return self;
}

@end

@implementation UserPreferences

- (instancetype)initWithTheme:(NSString *)theme language:(NSString *)language notifications:(BOOL)notifications newsletter:(BOOL)newsletter {
    self = [super init];
    if (self) {
        _theme = theme;
        _language = language;
        _notifications = notifications;
        _newsletter = newsletter;
    }
    return self;
}

@end

@implementation Product

- (instancetype)initWithId:(NSString *)productId name:(NSString *)name price:(double)price category:(NSString *)category description:(NSString *)description inStock:(BOOL)inStock tags:(NSMutableArray<NSString *> *)tags {
    self = [super init];
    if (self) {
        _productId = productId;
        _name = name;
        _price = price;
        _category = category;
        _productDescription = description;
        _inStock = inStock;
        _tags = tags;
    }
    return self;
}

@end

@implementation ShoppingCart

- (instancetype)initWithId:(NSString *)cartId userId:(NSString *)userId items:(NSMutableArray<CartItem *> *)items discountCode:(NSString *)discountCode discountAmount:(double)discountAmount {
    self = [super init];
    if (self) {
        _cartId = cartId;
        _userId = userId;
        _items = items;
        _discountCode = discountCode;
        _discountAmount = discountAmount;
    }
    return self;
}

@end

@implementation CartItem

- (instancetype)initWithProductId:(NSString *)productId quantity:(NSInteger)quantity price:(double)price {
    self = [super init];
    if (self) {
        _productId = productId;
        _quantity = quantity;
        _price = price;
    }
    return self;
}

@end

@implementation Order

- (instancetype)initWithId:(NSString *)orderId cart:(ShoppingCart *)cart shippingAddress:(Address *)shippingAddress paymentMethod:(NSString *)paymentMethod status:(NSString *)status timestamp:(long long)timestamp {
    self = [super init];
    if (self) {
        _orderId = orderId;
        _cart = cart;
        _shippingAddress = shippingAddress;
        _paymentMethod = paymentMethod;
        _status = status;
        _timestamp = timestamp;
    }
    return self;
}

@end

@implementation BankAccount

- (instancetype)initWithAccountNumber:(NSString *)accountNumber balance:(double)balance accountType:(NSString *)accountType isActive:(BOOL)isActive {
    self = [super init];
    if (self) {
        _accountNumber = accountNumber;
        _balance = balance;
        _accountType = accountType;
        _isActive = isActive;
    }
    return self;
}

@end

@implementation ApiResponse

- (instancetype)initWithData:(id)data errorMessage:(NSString *)errorMessage statusCode:(NSInteger)statusCode headers:(NSMutableDictionary<NSString *,NSString *> *)headers {
    self = [super init];
    if (self) {
        _data = data;
        _errorMessage = errorMessage;
        _statusCode = statusCode;
        _headers = headers;
    }
    return self;
}

@end

@implementation DatabaseConfig

- (instancetype)initWithHost:(NSString *)host port:(NSInteger)port database:(NSString *)database username:(NSString *)username password:(NSString *)password connectionPool:(ConnectionPoolConfig *)connectionPool {
    self = [super init];
    if (self) {
        _host = host;
        _port = port;
        _database = database;
        _username = username;
        _password = password;
        _connectionPool = connectionPool;
    }
    return self;
}

@end

@implementation ConnectionPoolConfig

- (instancetype)initWithMinConnections:(NSInteger)minConnections maxConnections:(NSInteger)maxConnections timeout:(long long)timeout {
    self = [super init];
    if (self) {
        _minConnections = minConnections;
        _maxConnections = maxConnections;
        _timeout = timeout;
    }
    return self;
}

@end

@implementation AppConfig

- (instancetype)initWithAppName:(NSString *)appName version:(NSString *)version environment:(NSString *)environment database:(DatabaseConfig *)database features:(NSMutableDictionary<NSString *,NSNumber *> *)features settings:(NSMutableDictionary<NSString *,NSString *> *)settings {
    self = [super init];
    if (self) {
        _appName = appName;
        _version = version;
        _environment = environment;
        _database = database;
        _features = features;
        _settings = settings;
    }
    return self;
}

@end

@implementation UserService

- (User *)createUserWithName:(NSString *)name email:(NSString *)email age:(NSInteger)age {
    // Manual equivalent of Kotlin's 'apply' - extremely verbose in Objective-C
    User *user = [[User alloc] initWithId:@"" name:@"" email:@"" age:0 address:nil preferences:nil];
    
    // Manual configuration - no 'apply' equivalent
    user.userId = [self generateUserId];
    user.name = name;
    user.email = email;
    user.age = age;
    
    // Manual nested object creation - extremely verbose without 'apply'
    Address *address = [[Address alloc] initWithStreet:@"" city:@"" state:@"" zipCode:@"" country:@""];
    address.street = @"";
    address.city = @"";
    address.state = @"";
    address.zipCode = @"";
    address.country = @"USA";
    user.address = address;
    
    // Manual preferences setup - no nested 'apply'
    UserPreferences *preferences = [[UserPreferences alloc] initWithTheme:@"" language:@"" notifications:NO newsletter:NO];
    preferences.theme = @"light";
    preferences.language = @"en";
    preferences.notifications = YES;
    preferences.newsletter = NO;
    user.preferences = preferences;
    
    return user;
}

- (User *)updateUserWithValidation:(User *)user newEmail:(NSString *)newEmail newAge:(NSNumber *)newAge {
    // Manual equivalent of Kotlin's 'let' - extremely verbose with manual validation
    BOOL updated = NO;
    
    if (newEmail != nil) {
        if ([newEmail containsString:@"@"]) {
            user.email = newEmail;
            updated = YES;
        }
    }
    
    if (newAge != nil) {
        NSInteger ageValue = [newAge integerValue];
        if (ageValue > 0 && ageValue < 120) {
            user.age = ageValue;
            updated = YES;
        }
    }
    
    return updated ? user : nil;
}

- (NSString *)processUserData:(User *)user {
    // Manual equivalent of Kotlin's 'let' with null safety
    if (user != nil) {
        return [NSString stringWithFormat:@"Processing user: %@ (%@)", user.name, user.email];
    } else {
        return @"No user to process";
    }
}

- (User *)configureUserPreferences:(User *)user {
    // Manual equivalent of Kotlin's 'also' - no elegant side effects pattern
    if (user.preferences != nil) {
        user.preferences.theme = @"dark";
        user.preferences.notifications = YES;
        [self logPreferenceChangeForUserId:user.userId key:@"theme" value:@"dark"];
        [self logPreferenceChangeForUserId:user.userId key:@"notifications" value:@"enabled"];
    }
    return user;
}

- (NSString *)validateAndFormatUser:(User *)user {
    // Manual equivalent of Kotlin's 'run' - no receiver context
    BOOL isValidEmail = [user.email containsString:@"@"];
    BOOL isValidAge = user.age >= 1 && user.age <= 120;
    BOOL hasAddress = user.address != nil;
    
    if (!isValidEmail) {
        return [NSString stringWithFormat:@"Invalid email: %@", user.email];
    } else if (!isValidAge) {
        return [NSString stringWithFormat:@"Invalid age: %ld", (long)user.age];
    } else if (!hasAddress) {
        return @"Missing address information";
    } else {
        return [NSString stringWithFormat:@"Valid user: %@ (%@, age %ld)", user.name, user.email, (long)user.age];
    }
}

- (NSDictionary<NSString *,id> *)getUserSummary:(User *)user {
    // Manual equivalent of Kotlin's 'let' with complex transformations - extremely verbose
    if (user == nil) {
        return @{};
    }
    
    NSString *addressSummary;
    if (user.address != nil) {
        addressSummary = [NSString stringWithFormat:@"%@, %@, %@", user.address.city, user.address.state, user.address.country];
    } else {
        addressSummary = @"No address";
    }
    
    NSString *preferencesSummary;
    if (user.preferences != nil) {
        preferencesSummary = [NSString stringWithFormat:@"Theme: %@, Language: %@", user.preferences.theme, user.preferences.language];
    } else {
        preferencesSummary = @"No preferences";
    }
    
    return @{
        @"id": user.userId,
        @"name": user.name,
        @"email": user.email,
        @"age": @(user.age),
        @"hasAddress": @(user.address != nil),
        @"hasPreferences": @(user.preferences != nil),
        @"addressSummary": addressSummary,
        @"preferencesSummary": preferencesSummary
    };
}

- (NSString *)generateUserId {
    return [NSString stringWithFormat:@"USER_%lld", (long long)([[NSDate date] timeIntervalSince1970] * 1000)];
}

- (void)logPreferenceChangeForUserId:(NSString *)userId key:(NSString *)key value:(NSString *)value {
    // Logging implementation
}

@end

@implementation ProductService

- (Product *)createProductWithName:(NSString *)name price:(double)price category:(NSString *)category {
    // Manual equivalent of Kotlin's 'apply' - extremely verbose
    NSMutableArray *tags = [[NSMutableArray alloc] init];
    Product *product = [[Product alloc] initWithId:@"" name:@"" price:0.0 category:@"" description:@"" inStock:NO tags:tags];
    
    product.productId = [self generateProductId];
    product.name = name;
    product.price = price;
    product.category = category;
    product.productDescription = [NSString stringWithFormat:@"Default description for %@", name];
    product.inStock = YES;
    
    // Manual tag manipulation - no 'apply' for collections
    [product.tags addObject:@"new"];
    [product.tags addObject:[category lowercaseString]];
    if (price > 100) {
        [product.tags addObject:@"premium"];
    }
    
    return product;
}

- (Product *)updateProductPrice:(Product *)product newPrice:(double)newPrice {
    // Manual equivalent of Kotlin's 'takeIf' with 'apply' - extremely complex
    if (newPrice <= 0) {
        return nil;
    }
    
    double oldPrice = product.price;
    product.price = newPrice;
    
    // Manual tag updates - no elegant collection 'apply'
    NSMutableArray *tagsToRemove = [[NSMutableArray alloc] init];
    for (NSString *tag in product.tags) {
        if ([tag isEqualToString:@"budget"] || [tag isEqualToString:@"premium"] || [tag isEqualToString:@"luxury"]) {
            [tagsToRemove addObject:tag];
        }
    }
    [product.tags removeObjectsInArray:tagsToRemove];
    
    if (newPrice < 50) {
        [product.tags addObject:@"budget"];
    } else if (newPrice > 500) {
        [product.tags addObject:@"luxury"];
    } else if (newPrice > 100) {
        [product.tags addObject:@"premium"];
    }
    
    [self logPriceChangeForProductId:product.productId oldPrice:oldPrice newPrice:newPrice];
    return product;
}

- (NSArray<NSString *> *)processProductBatch:(NSArray<Product *> *)products {
    // Manual equivalent of Kotlin's scope functions in collections
    NSMutableArray *results = [[NSMutableArray alloc] init];
    
    for (Product *product in products) {
        if (product.inStock) {
            NSString *message = [NSString stringWithFormat:@"Processing: %@ - $%.2f", product.name, product.price];
            [results addObject:message];
        }
    }
    
    return [results copy];
}

- (Product *)configureProductForSale:(Product *)product discountPercent:(double)discountPercent {
    // Manual equivalent of Kotlin's 'also' with nested 'apply' - extremely verbose
    product.price *= (1 - discountPercent / 100);
    [product.tags addObject:@"sale"];
    [product.tags addObject:@"discounted"];
    
    // Manual side effects - no 'also' chaining
    [self logSaleConfigurationForProductId:product.productId discountPercent:discountPercent];
    [self notifyPriceChangeForProductId:product.productId newPrice:product.price];
    
    return product;
}

- (NSDictionary<NSString *,id> *)analyzeProduct:(Product *)product {
    // Manual equivalent of Kotlin's 'run' - no receiver context
    NSString *priceCategory;
    if (product.price < 20) {
        priceCategory = @"budget";
    } else if (product.price < 100) {
        priceCategory = @"mid-range";
    } else if (product.price < 500) {
        priceCategory = @"premium";
    } else {
        priceCategory = @"luxury";
    }
    
    // Manual tag analysis - no 'run' for collections
    NSArray *promoTags = @[@"sale", @"new", @"featured"];
    NSArray *categoryTags = @[@"electronics", @"clothing", @"books"];
    
    BOOL hasPromoTags = NO;
    for (NSString *tag in product.tags) {
        if ([promoTags containsObject:tag]) {
            hasPromoTags = YES;
            break;
        }
    }
    
    NSMutableArray *filteredCategoryTags = [[NSMutableArray alloc] init];
    for (NSString *tag in product.tags) {
        if ([categoryTags containsObject:tag]) {
            [filteredCategoryTags addObject:tag];
        }
    }
    
    NSDictionary *tagAnalysis = @{
        @"tagCount": @(product.tags.count),
        @"hasPromoTags": @(hasPromoTags),
        @"categoryTags": [filteredCategoryTags copy]
    };
    
    return @{
        @"productId": product.productId,
        @"priceCategory": priceCategory,
        @"availability": product.inStock ? @"available" : @"out_of_stock",
        @"tagAnalysis": tagAnalysis,
        @"summary": [NSString stringWithFormat:@"%@ (%@) - %@", product.name, priceCategory, product.inStock ? @"In Stock" : @"Out of Stock"]
    };
}

- (NSString *)generateProductId {
    return [NSString stringWithFormat:@"PROD_%lld", (long long)([[NSDate date] timeIntervalSince1970] * 1000)];
}

- (void)logPriceChangeForProductId:(NSString *)productId oldPrice:(double)oldPrice newPrice:(double)newPrice {}
- (void)logSaleConfigurationForProductId:(NSString *)productId discountPercent:(double)discountPercent {}
- (void)notifyPriceChangeForProductId:(NSString *)productId newPrice:(double)newPrice {}

@end

@implementation ShoppingCartService

- (ShoppingCart *)createCartWithUserId:(NSString *)userId {
    // Manual equivalent of Kotlin's 'apply' - verbose initialization
    NSMutableArray *items = [[NSMutableArray alloc] init];
    ShoppingCart *cart = [[ShoppingCart alloc] initWithId:@"" userId:@"" items:items discountCode:nil discountAmount:0.0];
    cart.cartId = [self generateCartId];
    cart.userId = userId;
    cart.discountAmount = 0.0;
    return cart;
}

- (ShoppingCart *)addItemToCart:(ShoppingCart *)cart productId:(NSString *)productId quantity:(NSInteger)quantity price:(double)price {
    // Manual equivalent of Kotlin's 'also' - no elegant side effects
    CartItem *item = [[CartItem alloc] initWithProductId:productId quantity:quantity price:price];
    [cart.items addObject:item];
    [self logCartItemAddedForCartId:cart.cartId productId:productId quantity:quantity];
    return cart;
}

- (ShoppingCart *)applyDiscount:(ShoppingCart *)cart discountCode:(NSString *)discountCode {
    // Manual equivalent of Kotlin's 'takeIf' with 'apply' and 'also' - extremely complex
    if (![self validateDiscountCode:discountCode]) {
        return nil;
    }
    
    cart.discountCode = discountCode;
    cart.discountAmount = [self calculateDiscountForCart:cart discountCode:discountCode];
    
    [self logDiscountAppliedForCartId:cart.cartId discountCode:discountCode amount:cart.discountAmount];
    return cart;
}

- (Order *)processCartCheckout:(ShoppingCart *)cart shippingAddress:(Address *)shippingAddress paymentMethod:(NSString *)paymentMethod {
    // Manual equivalent of Kotlin's 'takeIf' with 'let' and 'also' - extremely verbose
    if (cart.items.count == 0) {
        return nil;
    }
    
    Order *order = [[Order alloc] initWithId:@"" cart:cart shippingAddress:shippingAddress paymentMethod:paymentMethod status:@"" timestamp:0];
    order.orderId = [self generateOrderId];
    order.status = @"pending";
    order.timestamp = (long long)([[NSDate date] timeIntervalSince1970] * 1000);
    
    [self logOrderCreatedForOrderId:order.orderId cartId:cart.cartId];
    [self clearCart:cart];
    
    return order;
}

- (NSDictionary<NSString *,id> *)calculateCartSummary:(ShoppingCart *)cart {
    // Manual equivalent of Kotlin's 'run' - no receiver context
    double subtotal = 0;
    for (CartItem *item in cart.items) {
        subtotal += item.price * item.quantity;
    }
    
    double total = subtotal - cart.discountAmount;
    
    NSInteger itemCount = 0;
    for (CartItem *item in cart.items) {
        itemCount += item.quantity;
    }
    
    NSMutableArray *itemsData = [[NSMutableArray alloc] init];
    for (CartItem *item in cart.items) {
        NSDictionary *itemData = @{
            @"productId": item.productId,
            @"quantity": @(item.quantity),
            @"price": @(item.price),
            @"total": @(item.price * item.quantity)
        };
        [itemsData addObject:itemData];
    }
    
    return @{
        @"cartId": cart.cartId,
        @"itemCount": @(itemCount),
        @"subtotal": @(subtotal),
        @"discountAmount": @(cart.discountAmount),
        @"total": @(total),
        @"hasDiscount": @(cart.discountCode != nil),
        @"discountCode": cart.discountCode ?: @"none",
        @"items": [itemsData copy]
    };
}

- (NSString *)generateCartId {
    return [NSString stringWithFormat:@"CART_%lld", (long long)([[NSDate date] timeIntervalSince1970] * 1000)];
}

- (NSString *)generateOrderId {
    return [NSString stringWithFormat:@"ORDER_%lld", (long long)([[NSDate date] timeIntervalSince1970] * 1000)];
}

- (BOOL)validateDiscountCode:(NSString *)discountCode {
    return discountCode.length > 0;
}

- (double)calculateDiscountForCart:(ShoppingCart *)cart discountCode:(NSString *)discountCode {
    return 10.0;
}

- (void)logCartItemAddedForCartId:(NSString *)cartId productId:(NSString *)productId quantity:(NSInteger)quantity {}
- (void)logDiscountAppliedForCartId:(NSString *)cartId discountCode:(NSString *)discountCode amount:(double)amount {}
- (void)logOrderCreatedForOrderId:(NSString *)orderId cartId:(NSString *)cartId {}
- (void)clearCart:(ShoppingCart *)cart {
    [cart.items removeAllObjects];
}

@end

@implementation BankingService

- (BankAccount *)createAccountWithAccountNumber:(NSString *)accountNumber accountType:(NSString *)accountType {
    // Manual equivalent of Kotlin's 'apply' with 'also' - verbose setup
    BankAccount *account = [[BankAccount alloc] initWithAccountNumber:@"" balance:0.0 accountType:@"" isActive:NO];
    account.accountNumber = accountNumber;
    account.balance = 0.0;
    account.accountType = accountType;
    account.isActive = YES;
    
    [self logAccountCreatedWithAccountNumber:account.accountNumber type:account.accountType];
    return account;
}

- (BankAccount *)processTransaction:(BankAccount *)account amount:(double)amount type:(NSString *)type {
    // Manual equivalent of Kotlin's 'takeIf' with 'let' - complex nested logic
    if (!account.isActive) {
        return nil;
    }
    
    if ([type isEqualToString:@"deposit"]) {
        account.balance += amount;
        [self logTransactionForAccountNumber:account.accountNumber amount:amount type:type];
        return account;
    } else if ([type isEqualToString:@"withdrawal"]) {
        if (account.balance >= amount) {
            account.balance -= amount;
            [self logTransactionForAccountNumber:account.accountNumber amount:amount type:type];
            return account;
        } else {
            return nil;
        }
    } else {
        return nil;
    }
}

- (NSDictionary<NSString *,id> *)generateAccountStatement:(BankAccount *)account {
    // Manual equivalent of Kotlin's 'run' - no receiver context
    NSString *accountStatus;
    if (!account.isActive) {
        accountStatus = @"inactive";
    } else if (account.balance < 0) {
        accountStatus = @"overdrawn";
    } else if (account.balance < 100) {
        accountStatus = @"low_balance";
    } else {
        accountStatus = @"normal";
    }
    
    return @{
        @"accountNumber": account.accountNumber,
        @"accountType": account.accountType,
        @"balance": @(account.balance),
        @"status": accountStatus,
        @"isActive": @(account.isActive),
        @"formattedBalance": [NSString stringWithFormat:@"$%.2f", account.balance],
        @"canWithdraw": @(account.isActive && account.balance > 0),
        @"summary": [NSString stringWithFormat:@"%@ account #%@: %.2f (%@)", account.accountType, account.accountNumber, account.balance, accountStatus]
    };
}

- (NSArray<BankAccount *> *)transferFunds:(BankAccount *)fromAccount toAccount:(BankAccount *)toAccount amount:(double)amount {
    // Manual equivalent of complex Kotlin scope function chaining - extremely verbose
    if (!fromAccount.isActive || fromAccount.balance < amount) {
        return @[[NSNull null], [NSNull null]];
    }
    
    if (!toAccount.isActive) {
        return @[[NSNull null], [NSNull null]];
    }
    
    fromAccount.balance -= amount;
    toAccount.balance += amount;
    
    [self logTransferFromAccount:fromAccount.accountNumber toAccount:toAccount.accountNumber amount:amount];
    
    return @[fromAccount, toAccount];
}

- (void)logAccountCreatedWithAccountNumber:(NSString *)accountNumber type:(NSString *)type {}
- (void)logTransactionForAccountNumber:(NSString *)accountNumber amount:(double)amount type:(NSString *)type {}
- (void)logTransferFromAccount:(NSString *)fromAccount toAccount:(NSString *)toAccount amount:(double)amount {}

@end

@implementation ApiService

- (id)processApiResponse:(ApiResponse *)response {
    // Manual equivalent of Kotlin's 'takeIf' and 'let' - verbose validation
    if (response.statusCode >= 200 && response.statusCode < 300) {
        if (response.data != nil) {
            [self logSuccessfulResponseWithStatusCode:response.statusCode];
            return response.data;
        }
    }
    
    [self logErrorResponseWithStatusCode:response.statusCode error:response.errorMessage ?: @"Unknown error"];
    return nil;
}

- (ApiResponse *)createApiResponseWithData:(id)data statusCode:(NSInteger)statusCode errorMessage:(NSString *)errorMessage {
    // Manual equivalent of Kotlin's 'apply' - verbose initialization
    NSMutableDictionary *headers = [[NSMutableDictionary alloc] init];
    ApiResponse *response = [[ApiResponse alloc] initWithData:data errorMessage:errorMessage statusCode:statusCode headers:headers];
    
    response.data = data;
    response.statusCode = statusCode;
    response.errorMessage = errorMessage;
    
    [response.headers setObject:@"application/json" forKey:@"Content-Type"];
    [response.headers setObject:[NSString stringWithFormat:@"%lld", (long long)([[NSDate date] timeIntervalSince1970] * 1000)] forKey:@"Timestamp"];
    [response.headers setObject:@"ObjC-Service" forKey:@"Server"];
    
    return response;
}

- (NSString *)handleApiError:(ApiResponse *)response {
    // Manual equivalent of Kotlin's 'run' - no receiver context
    switch (response.statusCode) {
        case 404:
            return [NSString stringWithFormat:@"Resource not found: %@", response.errorMessage ?: @"Unknown resource"];
        case 401:
            return @"Unauthorized access";
        case 403:
            return @"Forbidden operation";
        case 500:
            return [NSString stringWithFormat:@"Internal server error: %@", response.errorMessage ?: @"Unknown error"];
        default:
            return [NSString stringWithFormat:@"API error (%ld): %@", (long)response.statusCode, response.errorMessage ?: @"Unknown error"];
    }
}

- (ApiResponse *)retryApiCallWithMaxRetries:(NSInteger)maxRetries apiCall:(ApiResponse *(^)(void))apiCall {
    // Manual equivalent of Kotlin's scope functions in retry logic
    for (NSInteger attempt = 0; attempt < maxRetries; attempt++) {
        ApiResponse *response = apiCall();
        
        if (response.statusCode >= 200 && response.statusCode < 300) {
            [self logRetrySuccessWithAttempt:attempt + 1 maxRetries:maxRetries];
            return response;
        }
        
        if (attempt < maxRetries - 1) {
            [self logRetryAttemptWithAttempt:attempt + 1 maxRetries:maxRetries statusCode:response.statusCode];
        }
    }
    
    return nil;
}

- (void)logSuccessfulResponseWithStatusCode:(NSInteger)statusCode {}
- (void)logErrorResponseWithStatusCode:(NSInteger)statusCode error:(NSString *)error {}
- (void)logRetrySuccessWithAttempt:(NSInteger)attempt maxRetries:(NSInteger)maxRetries {}
- (void)logRetryAttemptWithAttempt:(NSInteger)attempt maxRetries:(NSInteger)maxRetries statusCode:(NSInteger)statusCode {}

@end

@implementation ConfigurationService

- (DatabaseConfig *)createDatabaseConfigWithHost:(NSString *)host port:(NSInteger)port database:(NSString *)database {
    // Manual equivalent of Kotlin's 'apply' - extremely verbose nested configuration
    DatabaseConfig *config = [[DatabaseConfig alloc] initWithHost:@"" port:0 database:@"" username:@"" password:@"" connectionPool:nil];
    config.host = host;
    config.port = port;
    config.database = database;
    config.username = @"defaultUser";
    config.password = @"defaultPassword";
    
    ConnectionPoolConfig *poolConfig = [[ConnectionPoolConfig alloc] initWithMinConnections:0 maxConnections:0 timeout:0];
    poolConfig.minConnections = 5;
    poolConfig.maxConnections = 20;
    poolConfig.timeout = 30000;
    config.connectionPool = poolConfig;
    
    return config;
}

- (AppConfig *)createAppConfigWithAppName:(NSString *)appName version:(NSString *)version environment:(NSString *)environment {
    // Manual equivalent of Kotlin's nested 'apply' - incredibly verbose
    DatabaseConfig *dbConfig = [self createDatabaseConfigWithHost:@"localhost" port:5432 database:@"app_db"];
    NSMutableDictionary *features = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *settings = [[NSMutableDictionary alloc] init];
    
    AppConfig *config = [[AppConfig alloc] initWithAppName:@"" version:@"" environment:@"" database:dbConfig features:features settings:settings];
    
    config.appName = appName;
    config.version = version;
    config.environment = environment;
    config.database = dbConfig;
    
    // Manual feature configuration - no 'apply' for dictionaries
    [config.features setObject:@YES forKey:@"feature_flags"];
    [config.features setObject:@(![environment isEqualToString:@"development"]) forKey:@"analytics"];
    [config.features setObject:@YES forKey:@"logging"];
    [config.features setObject:@([environment isEqualToString:@"production"]) forKey:@"cache"];
    
    // Manual settings configuration
    [config.settings setObject:([environment isEqualToString:@"production"] ? @"ERROR" : @"DEBUG") forKey:@"log_level"];
    [config.settings setObject:@"3600" forKey:@"cache_ttl"];
    [config.settings setObject:@"100" forKey:@"max_connections"];
    [config.settings setObject:@"30000" forKey:@"timeout"];
    
    [self logConfigurationCreatedWithAppName:config.appName environment:config.environment];
    return config;
}

- (NSDictionary<NSString *,id> *)validateConfiguration:(AppConfig *)config {
    // Manual equivalent of Kotlin's 'run' - no receiver context
    NSMutableArray *issues = [[NSMutableArray alloc] init];
    
    if (config.appName.length == 0) {
        [issues addObject:@"App name is required"];
    }
    if (config.version.length == 0) {
        [issues addObject:@"Version is required"];
    }
    NSArray *validEnvironments = @[@"development", @"staging", @"production"];
    if (![validEnvironments containsObject:config.environment]) {
        [issues addObject:[NSString stringWithFormat:@"Invalid environment: %@", config.environment]];
    }
    
    // Manual database validation - no 'run' for nested objects
    if (config.database.host.length == 0) {
        [issues addObject:@"Database host is required"];
    }
    if (config.database.port <= 0) {
        [issues addObject:@"Database port must be positive"];
    }
    if (config.database.database.length == 0) {
        [issues addObject:@"Database name is required"];
    }
    
    return @{
        @"isValid": @(issues.count == 0),
        @"issues": [issues copy],
        @"summary": issues.count == 0 ? @"Configuration is valid" : [NSString stringWithFormat:@"Found %lu issues", (unsigned long)issues.count]
    };
}

- (AppConfig *)updateConfiguration:(AppConfig *)config withUpdates:(NSDictionary<NSString *,NSString *> *)updates {
    // Manual equivalent of Kotlin's 'also' - no elegant side effects
    for (NSString *key in updates) {
        NSString *value = updates[key];
        if ([key isEqualToString:@"log_level"] || [key isEqualToString:@"cache_ttl"] || [key isEqualToString:@"max_connections"]) {
            [config.settings setObject:value forKey:key];
        } else {
            [config.settings setObject:value forKey:key];
        }
    }
    
    [self logConfigurationUpdatedWithAppName:config.appName updatedKeys:[updates allKeys]];
    return config;
}

- (void)logConfigurationCreatedWithAppName:(NSString *)appName environment:(NSString *)environment {}
- (void)logConfigurationUpdatedWithAppName:(NSString *)appName updatedKeys:(NSArray<NSString *> *)updatedKeys {}

@end

@implementation IosSizeBenchmark

- (void)runBenchmark {
    UserService *userService = [[UserService alloc] init];
    ProductService *productService = [[ProductService alloc] init];
    ShoppingCartService *cartService = [[ShoppingCartService alloc] init];
    BankingService *bankingService = [[BankingService alloc] init];
    ApiService *apiService = [[ApiService alloc] init];
    ConfigurationService *configService = [[ConfigurationService alloc] init];
    
    // User service demonstrations - extremely verbose compared to Kotlin's scope functions
    User *user = [userService createUserWithName:@"John Doe" email:@"john@example.com" age:30];
    
    User *updatedUser = [userService updateUserWithValidation:user newEmail:@"newemail@test.com" newAge:@31];
    NSString *processedData = [userService processUserData:updatedUser];
    User *configuredUser = [userService configureUserPreferences:user];
    NSString *validationResult = [userService validateAndFormatUser:user];
    NSDictionary *userSummary = [userService getUserSummary:user];
    
    // Product service demonstrations - manual object manipulation
    Product *product = [productService createProductWithName:@"Laptop" price:999.99 category:@"Electronics"];
    Product *updatedProduct = [productService updateProductPrice:product newPrice:899.99];
    Product *saleProduct = [productService configureProductForSale:product discountPercent:15.0];
    NSDictionary *productAnalysis = [productService analyzeProduct:product];
    
    NSArray<Product *> *products = @[
        [productService createProductWithName:@"Mouse" price:29.99 category:@"Electronics"],
        [productService createProductWithName:@"Keyboard" price:79.99 category:@"Electronics"],
        [productService createProductWithName:@"Monitor" price:299.99 category:@"Electronics"]
    ];
    NSArray<NSString *> *processedProducts = [productService processProductBatch:products];
    
    // Shopping cart demonstrations - manual chaining instead of elegant 'let' chains
    ShoppingCart *cart = [cartService createCartWithUserId:@"USER_123"];
    ShoppingCart *cartWithItem1 = [cartService addItemToCart:cart productId:@"PROD_1" quantity:2 price:29.99];
    ShoppingCart *cartWithItem2 = [cartService addItemToCart:cartWithItem1 productId:@"PROD_2" quantity:1 price:79.99];
    ShoppingCart *cartWithItems = [cartService addItemToCart:cartWithItem2 productId:@"PROD_3" quantity:1 price:299.99];
    
    ShoppingCart *discountedCart = [cartService applyDiscount:cartWithItems discountCode:@"SAVE10"];
    NSDictionary *cartSummary = [cartService calculateCartSummary:cartWithItems];
    
    Address *address = [[Address alloc] initWithStreet:@"123 Main St" city:@"New York" state:@"NY" zipCode:@"10001" country:@"USA"];
    Order *order = [cartService processCartCheckout:cartWithItems shippingAddress:address paymentMethod:@"credit_card"];
    
    // Banking demonstrations - manual null handling instead of elegant 'let' chains
    BankAccount *checkingAccount = [bankingService createAccountWithAccountNumber:@"CHK001" accountType:@"checking"];
    BankAccount *savingsAccount = [bankingService createAccountWithAccountNumber:@"SAV001" accountType:@"savings"];
    
    BankAccount *accountAfterDeposit = [bankingService processTransaction:checkingAccount amount:1000.0 type:@"deposit"];
    BankAccount *accountAfterWithdrawal = nil;
    if (accountAfterDeposit != nil) {
        accountAfterWithdrawal = [bankingService processTransaction:accountAfterDeposit amount:250.0 type:@"withdrawal"];
    }
    
    NSDictionary *accountStatement = nil;
    if (accountAfterWithdrawal != nil) {
        accountStatement = [bankingService generateAccountStatement:accountAfterWithdrawal];
    }
    
    NSArray<BankAccount *> *transferResult = [bankingService transferFunds:checkingAccount toAccount:savingsAccount amount:500.0];
    BankAccount *fromAccount = transferResult[0];
    BankAccount *toAccount = transferResult[1];
    
    // API service demonstrations - manual response handling
    ApiResponse *successResponse = [apiService createApiResponseWithData:@"Success data" statusCode:200 errorMessage:nil];
    ApiResponse *errorResponse = [apiService createApiResponseWithData:nil statusCode:404 errorMessage:@"Not found"];
    
    id processedSuccess = [apiService processApiResponse:successResponse];
    id processedError = [apiService processApiResponse:errorResponse];
    NSString *errorMessage = [apiService handleApiError:errorResponse];
    
    // Configuration demonstrations - manual nested object creation
    DatabaseConfig *dbConfig = [configService createDatabaseConfigWithHost:@"localhost" port:5432 database:@"myapp_db"];
    AppConfig *appConfig = [configService createAppConfigWithAppName:@"MyApp" version:@"1.0.0" environment:@"production"];
    NSDictionary *validationResult2 = [configService validateConfiguration:appConfig];
    AppConfig *updatedConfig = [configService updateConfiguration:appConfig withUpdates:@{
        @"log_level": @"INFO",
        @"cache_ttl": @"7200"
    }];
    
    // Complex processing chains - extremely verbose manual processing instead of Kotlin's elegant scope function chaining
    NSArray<User *> *usersToProcess = @[
        [[User alloc] initWithId:@"1" name:@"Alice" email:@"alice@test.com" age:25 address:nil preferences:nil],
        [[User alloc] initWithId:@"2" name:@"Bob" email:@"bob@example.com" age:35 address:nil preferences:nil],
        [[User alloc] initWithId:@"3" name:@"Charlie" email:@"charlie@company.org" age:45 address:nil preferences:nil]
    ];
    
    // Manual processing instead of elegant map + apply + filter + map + also chain
    NSMutableArray<NSDictionary<NSString *, id> *> *processedUsers = [[NSMutableArray alloc] init];
    
    for (User *processingUser in usersToProcess) {
        // Manual equivalent of 'apply'
        processingUser.preferences = [[UserPreferences alloc] initWithTheme:@"dark" language:@"en" notifications:YES newsletter:NO];
        processingUser.address = [[Address alloc] initWithStreet:@"" city:@"" state:@"" zipCode:@"" country:@"USA"];
        
        // Manual equivalent of 'filter'
        if ([processingUser.email containsString:@"@"]) {
            // Manual equivalent of 'map'
            NSDictionary *summary = [userService getUserSummary:processingUser];
            [processedUsers addObject:summary];
        }
    }
    
    // Manual side effects instead of 'also'
    for (NSDictionary *summary in processedUsers) {
        // Log processing results
    }
    
    // Complex product processing chain - extremely verbose manual processing
    NSMutableArray<NSDictionary<NSString *, id> *> *productProcessingResults = [[NSMutableArray alloc] init];
    
    for (NSInteger i = 1; i <= 10; i++) {
        Product *prod = [productService createProductWithName:[NSString stringWithFormat:@"Product %ld", (long)i] 
                                                        price:i * 10.0 
                                                     category:[NSString stringWithFormat:@"Category%ld", (long)(i % 3)]];
        
        // Manual price update instead of 'map' + optional chaining
        Product *updatedProd = [productService updateProductPrice:prod newPrice:prod.price * 0.9];
        if (updatedProd != nil) {
            // Manual filtering instead of 'takeIf'
            if (updatedProd.price > 50) {
                Product *processedSaleProduct = [productService configureProductForSale:updatedProd discountPercent:20.0];
                NSDictionary *analysis = [productService analyzeProduct:processedSaleProduct];
                [productProcessingResults addObject:analysis];
            }
        }
    }
    
    // Manual side effects processing
    for (NSDictionary *analysis in productProcessingResults) {
        // Process analysis results
    }
    
    // Complex cart and order processing - manual instead of Kotlin's elegant chains
    NSArray<NSString *> *userIds = @[@"USER_1", @"USER_2", @"USER_3"];
    NSMutableArray<NSDictionary<NSString *, id> *> *orderSummaries = [[NSMutableArray alloc] init];
    
    for (NSString *userId in userIds) {
        ShoppingCart *userCart = [cartService createCartWithUserId:userId];
        
        // Manual item addition - no elegant 'apply'
        for (NSInteger index = 0; index < MIN(3, products.count); index++) {
            Product *productToAdd = products[index];
            [cartService addItemToCart:userCart productId:productToAdd.productId quantity:1 price:productToAdd.price];
        }
        
        // Manual discount application with null handling
        ShoppingCart *discountedUserCart = [cartService applyDiscount:userCart discountCode:@"SAVE15"];
        if (discountedUserCart != nil) {
            NSDictionary *summary = [cartService calculateCartSummary:discountedUserCart];
            [orderSummaries addObject:summary];
        }
    }
    
    // Manual processing of summaries
    for (NSDictionary *summary in orderSummaries) {
        // Process cart summaries
    }
    
    // Banking operation chains - manual instead of elegant Kotlin chains
    NSArray<NSArray *> *accountData = @[
        @[@"ACC001", @"checking"],
        @[@"ACC002", @"savings"],
        @[@"ACC003", @"business"]
    ];
    
    NSMutableArray<NSDictionary<NSString *, id> *> *bankingStatements = [[NSMutableArray alloc] init];
    
    for (NSArray *accInfo in accountData) {
        NSString *accNum = accInfo[0];
        NSString *type = accInfo[1];
        
        BankAccount *account = [bankingService createAccountWithAccountNumber:accNum accountType:type];
        
        // Manual transaction chaining
        BankAccount *deposited = [bankingService processTransaction:account amount:1000.0 type:@"deposit"];
        if (deposited != nil) {
            BankAccount *withdrawn = [bankingService processTransaction:deposited amount:100.0 type:@"withdrawal"];
            if (withdrawn != nil) {
                NSDictionary *statement = [bankingService generateAccountStatement:withdrawn];
                [bankingStatements addObject:statement];
            }
        }
    }
    
    // Manual statement processing
    for (NSDictionary *statement in bankingStatements) {
        // Process account statements
    }
    
    // API response processing chains - manual instead of Kotlin's elegant patterns
    NSArray<NSArray<NSNumber *> *> *responseData = @[
        @[@200, @"Success"],
        @[@404, @"Not Found"],
        @[@500, @"Server Error"]
    ];
    
    NSMutableArray<NSString *> *apiResults = [[NSMutableArray alloc] init];
    
    for (NSArray *responseInfo in responseData) {
        NSInteger status = [responseInfo[0] integerValue];
        NSString *message = (NSString *)responseInfo[1];
        
        ApiResponse *response;
        if (status == 200) {
            response = [apiService createApiResponseWithData:@"Data" statusCode:status errorMessage:nil];
        } else {
            response = [apiService createApiResponseWithData:nil statusCode:status errorMessage:message];
        }
        
        // Manual success/error handling instead of elegant 'takeIf' + 'let' + 'run'
        if (response.statusCode >= 200 && response.statusCode < 300) {
            id data = [apiService processApiResponse:response];
            if (data != nil) {
                [apiResults addObject:[NSString stringWithFormat:@"Success: %@", data]];
            } else {
                [apiResults addObject:@"Error: No data"];
            }
        } else {
            NSString *errorMsg = [apiService handleApiError:response];
            [apiResults addObject:[NSString stringWithFormat:@"Error: %@", errorMsg]];
        }
    }
    
    // Manual result processing
    for (NSString *result in apiResults) {
        // Process API results
    }
    
    // Configuration processing chains - manual validation and updates
    NSArray<NSArray<NSString *> *> *configData = @[
        @[@"App1", @"development"],
        @[@"App2", @"staging"],
        @[@"App3", @"production"]
    ];
    
    NSMutableArray<AppConfig *> *finalConfigs = [[NSMutableArray alloc] init];
    
    for (NSArray<NSString *> *configInfo in configData) {
        NSString *name = configInfo[0];
        NSString *env = configInfo[1];
        
        AppConfig *config = [configService createAppConfigWithAppName:name version:@"1.0.0" environment:env];
        NSDictionary *validation = [configService validateConfiguration:config];
        
        // Manual validation handling instead of elegant 'let' + conditional 'apply'
        NSNumber *isValidNumber = validation[@"isValid"];
        BOOL isValid = [isValidNumber boolValue];
        
        if (isValid) {
            // Configuration is valid, use as is
            [finalConfigs addObject:config];
        } else {
            // Fix configuration issues manually
            if (config.appName.length == 0) {
                config.appName = @"DefaultApp";
            }
            if (config.version.length == 0) {
                config.version = @"1.0.0";
            }
            [finalConfigs addObject:config];
        }
    }
    
    // Manual configuration updates
    for (AppConfig *config in finalConfigs) {
        [configService updateConfiguration:config withUpdates:@{
            @"log_level": @"INFO",
            @"timeout": @"60000"
        }];
    }
    
    // Manual final config processing
    for (AppConfig *config in finalConfigs) {
        // Process final configurations
    }
    
    // Nested scope function equivalent - extremely verbose in Objective-C
    User *userToProcess = user;
    userToProcess.name = [NSString stringWithFormat:@"Updated %@", userToProcess.name];
    userToProcess.email = [userToProcess.email lowercaseString];
    
    NSString *validationMessage = [userService validateAndFormatUser:userToProcess];
    // Manual side effect logging
    
    BOOL isLongMessage = validationMessage.length > 10;
    NSString *finalMessage = isLongMessage ? @"Long validation message" : @"Short validation message";
    
    // Error handling with manual null checks - no elegant scope function chaining
    NSString *safeOperationResult = @"Invalid user data";
    
    if (user.age > 0) {
        if (user.address != nil && user.address.zipCode.length > 0) {
            safeOperationResult = [NSString stringWithFormat:@"User %@ has valid address in %@", user.name, user.address.city];
        } else {
            safeOperationResult = @"User has invalid address";
        }
    }
    
    // Resource management patterns - manual instead of elegant scope function chains
    NSMutableArray<NSString *> *resourceManagementResults = [[NSMutableArray alloc] init];
    
    if (products.count > 0) {
        for (Product *productToProcess in products) {
            if (productToProcess.inStock) {
                [resourceManagementResults addObject:[NSString stringWithFormat:@"Processing available product: %@ (%.2f)", productToProcess.name, productToProcess.price]];
            } else {
                [resourceManagementResults addObject:[NSString stringWithFormat:@"Product %@ is out of stock", productToProcess.name]];
            }
        }
    }
    
    // Manual logging of all processing messages
    for (NSString *message in resourceManagementResults) {
        // Log processing messages
    }
    
    // This demonstrates how extremely verbose Objective-C becomes without Kotlin's scope functions
    // Every operation requires explicit object creation, manual state management, verbose method calls,
    // and complex nested conditionals. Kotlin's scope functions like let, run, apply, also, and takeIf
    // provide dramatically more elegant and readable patterns compared to this verbose Objective-C approach.
}

@end