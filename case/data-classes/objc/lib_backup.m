#import <Foundation/Foundation.h>

// Test case: Data Classes - Objective-C equivalent requiring massive manual boilerplate code

// Person class - requires extensive manual implementation
@interface Person : NSObject
@property (nonatomic, strong, nonnull) NSString *personId;
@property (nonatomic, strong, nonnull) NSString *firstName;
@property (nonatomic, strong, nonnull) NSString *lastName;
@property (nonatomic, assign) NSInteger age;
@property (nonatomic, strong, nonnull) NSString *email;

- (instancetype _Nonnull)initWithId:(NSString * _Nonnull)personId
                          firstName:(NSString * _Nonnull)firstName
                           lastName:(NSString * _Nonnull)lastName
                                age:(NSInteger)age
                              email:(NSString * _Nonnull)email;

// Manual computed properties
- (NSString * _Nonnull)fullName;
- (BOOL)isAdult;

// Manual equals, hash, description methods
- (BOOL)isEqualToPerson:(Person * _Nonnull)other;
- (NSUInteger)hash;
- (NSString * _Nonnull)description;

// Manual copy method
- (Person * _Nonnull)copyWithId:(NSString * _Nullable)personId
                      firstName:(NSString * _Nullable)firstName
                       lastName:(NSString * _Nullable)lastName
                            age:(NSNumber * _Nullable)age
                          email:(NSString * _Nullable)email;

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

- (NSString * _Nonnull)shortAddress;
- (BOOL)isUSA;
- (BOOL)isEqualToAddress:(Address * _Nonnull)other;
- (NSUInteger)hash;
- (NSString * _Nonnull)description;
- (Address * _Nonnull)copyWithStreet:(NSString * _Nullable)street
                                city:(NSString * _Nullable)city
                               state:(NSString * _Nullable)state
                             zipCode:(NSString * _Nullable)zipCode
                             country:(NSString * _Nullable)country;

@end

@interface ContactInfo : NSObject
@property (nonatomic, strong, nonnull) NSString *primaryEmail;
@property (nonatomic, strong, nullable) NSString *secondaryEmail;
@property (nonatomic, strong, nullable) NSString *phoneNumber;
@property (nonatomic, strong, nullable) Address *address;

- (instancetype _Nonnull)initWithPrimaryEmail:(NSString * _Nonnull)primaryEmail
                               secondaryEmail:(NSString * _Nullable)secondaryEmail
                                  phoneNumber:(NSString * _Nullable)phoneNumber
                                      address:(Address * _Nullable)address;

- (BOOL)hasMultipleEmails;
- (BOOL)hasCompleteInfo;
- (BOOL)isEqualToContactInfo:(ContactInfo * _Nonnull)other;
- (NSUInteger)hash;
- (NSString * _Nonnull)description;

@end

@interface Employee : NSObject
@property (nonatomic, strong, nonnull) NSString *employeeId;
@property (nonatomic, strong, nonnull) Person *person;
@property (nonatomic, strong, nonnull) ContactInfo *contactInfo;
@property (nonatomic, strong, nonnull) NSString *department;
@property (nonatomic, strong, nonnull) NSString *position;
@property (nonatomic, assign) double salary;
@property (nonatomic, strong, nonnull) NSString *startDate;
@property (nonatomic, strong, nullable) NSString *manager;
@property (nonatomic, assign) BOOL isActive;

- (instancetype _Nonnull)initWithId:(NSString * _Nonnull)employeeId
                             person:(Person * _Nonnull)person
                        contactInfo:(ContactInfo * _Nonnull)contactInfo
                         department:(NSString * _Nonnull)department
                           position:(NSString * _Nonnull)position
                             salary:(double)salary
                          startDate:(NSString * _Nonnull)startDate
                            manager:(NSString * _Nullable)manager
                           isActive:(BOOL)isActive;

- (NSString * _Nonnull)displayName;
- (BOOL)isManager;
- (NSInteger)yearsOfService;
- (BOOL)isEqualToEmployee:(Employee * _Nonnull)other;
- (NSUInteger)hash;
- (NSString * _Nonnull)description;

@end

@interface Transaction : NSObject
@property (nonatomic, strong, nonnull) NSString *transactionId;
@property (nonatomic, assign) double amount;
@property (nonatomic, strong, nonnull) NSString *currency;
@property (nonatomic, assign) int64_t timestamp;
@property (nonatomic, strong, nonnull) NSString *transactionDescription;
@property (nonatomic, strong, nonnull) NSString *category;
@property (nonatomic, strong, nonnull) NSArray<NSString *> *tags;

- (instancetype _Nonnull)initWithId:(NSString * _Nonnull)transactionId
                             amount:(double)amount
                           currency:(NSString * _Nonnull)currency
                          timestamp:(int64_t)timestamp
                        description:(NSString * _Nonnull)transactionDescription
                           category:(NSString * _Nonnull)category
                               tags:(NSArray<NSString *> * _Nonnull)tags;

- (BOOL)isExpense;
- (BOOL)isIncome;
- (NSString * _Nonnull)formattedAmount;
- (BOOL)isEqualToTransaction:(Transaction * _Nonnull)other;
- (NSUInteger)hash;
- (NSString * _Nonnull)description;

@end

@interface Product : NSObject
@property (nonatomic, strong, nonnull) NSString *productId;
@property (nonatomic, strong, nonnull) NSString *name;
@property (nonatomic, strong, nonnull) NSString *productDescription;
@property (nonatomic, assign) double price;
@property (nonatomic, strong, nonnull) NSString *currency;
@property (nonatomic, strong, nonnull) NSString *category;
@property (nonatomic, strong, nonnull) NSArray<NSString *> *tags;
@property (nonatomic, assign) BOOL inStock;
@property (nonatomic, assign) NSInteger stockQuantity;

- (instancetype _Nonnull)initWithId:(NSString * _Nonnull)productId
                               name:(NSString * _Nonnull)name
                        description:(NSString * _Nonnull)productDescription
                              price:(double)price
                           currency:(NSString * _Nonnull)currency
                           category:(NSString * _Nonnull)category
                               tags:(NSArray<NSString *> * _Nonnull)tags
                            inStock:(BOOL)inStock
                      stockQuantity:(NSInteger)stockQuantity;

- (BOOL)isAvailable;
- (NSString * _Nonnull)formattedPrice;
- (BOOL)isOnSale;
- (BOOL)isEqualToProduct:(Product * _Nonnull)other;
- (NSUInteger)hash;
- (NSString * _Nonnull)description;

@end

@interface DataClassProcessor : NSObject

- (NSDictionary<NSString *, id> * _Nonnull)processPersonData:(NSArray<Person *> * _Nonnull)persons;
- (NSDictionary<NSString *, id> * _Nonnull)analyzeEmployeeData:(NSArray<Employee *> * _Nonnull)employees;
- (NSDictionary<NSString *, id> * _Nonnull)processTransactionData:(NSArray<Transaction *> * _Nonnull)transactions;

@end

@interface IosSizeBenchmark : NSObject

- (void)runBenchmark;

@end

// Implementations - extremely verbose compared to Kotlin data classes

@implementation Person

- (instancetype)initWithId:(NSString *)personId
                 firstName:(NSString *)firstName
                  lastName:(NSString *)lastName
                       age:(NSInteger)age
                     email:(NSString *)email {
    self = [super init];
    if (self) {
        _personId = personId;
        _firstName = firstName;
        _lastName = lastName;
        _age = age;
        _email = email;
    }
    return self;
}

- (NSString *)fullName {
    return [NSString stringWithFormat:@"%@ %@", self.firstName, self.lastName];
}

- (BOOL)isAdult {
    return self.age >= 18;
}

// Manual equals implementation - extremely verbose
- (BOOL)isEqualToPerson:(Person *)other {
    if (!other) return NO;
    return [self.personId isEqualToString:other.personId] &&
           [self.firstName isEqualToString:other.firstName] &&
           [self.lastName isEqualToString:other.lastName] &&
           self.age == other.age &&
           [self.email isEqualToString:other.email];
}

- (BOOL)isEqual:(id)object {
    if (self == object) return YES;
    if (![object isKindOfClass:[Person class]]) return NO;
    return [self isEqualToPerson:(Person *)object];
}

// Manual hash implementation
- (NSUInteger)hash {
    NSUInteger result = 1;
    result = 31 * result + [self.personId hash];
    result = 31 * result + [self.firstName hash];
    result = 31 * result + [self.lastName hash];
    result = 31 * result + self.age;
    result = 31 * result + [self.email hash];
    return result;
}

// Manual description implementation
- (NSString *)description {
    return [NSString stringWithFormat:@"Person(id: %@, firstName: %@, lastName: %@, age: %ld, email: %@)",
            self.personId, self.firstName, self.lastName, (long)self.age, self.email];
}

// Manual copy implementation
- (Person *)copyWithId:(NSString *)personId
             firstName:(NSString *)firstName
              lastName:(NSString *)lastName
                   age:(NSNumber *)age
                 email:(NSString *)email {
    return [[Person alloc] initWithId:personId ?: self.personId
                            firstName:firstName ?: self.firstName
                             lastName:lastName ?: self.lastName
                                  age:age ? age.integerValue : self.age
                                email:email ?: self.email];
}

@end

@implementation Address

- (instancetype)initWithStreet:(NSString *)street
                          city:(NSString *)city
                         state:(NSString *)state
                       zipCode:(NSString *)zipCode
                       country:(NSString *)country {
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

- (NSString *)shortAddress {
    return [NSString stringWithFormat:@"%@, %@", self.city, self.state];
}

- (BOOL)isUSA {
    return [self.country.lowercaseString isEqualToString:@"usa"];
}

- (BOOL)isEqualToAddress:(Address *)other {
    if (!other) return NO;
    return [self.street isEqualToString:other.street] &&
           [self.city isEqualToString:other.city] &&
           [self.state isEqualToString:other.state] &&
           [self.zipCode isEqualToString:other.zipCode] &&
           [self.country isEqualToString:other.country];
}

- (BOOL)isEqual:(id)object {
    if (self == object) return YES;
    if (![object isKindOfClass:[Address class]]) return NO;
    return [self isEqualToAddress:(Address *)object];
}

- (NSUInteger)hash {
    NSUInteger result = 1;
    result = 31 * result + [self.street hash];
    result = 31 * result + [self.city hash];
    result = 31 * result + [self.state hash];
    result = 31 * result + [self.zipCode hash];
    result = 31 * result + [self.country hash];
    return result;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"Address(street: %@, city: %@, state: %@, zipCode: %@, country: %@)",
            self.street, self.city, self.state, self.zipCode, self.country];
}

- (Address *)copyWithStreet:(NSString *)street
                       city:(NSString *)city
                      state:(NSString *)state
                    zipCode:(NSString *)zipCode
                    country:(NSString *)country {
    return [[Address alloc] initWithStreet:street ?: self.street
                                      city:city ?: self.city
                                     state:state ?: self.state
                                   zipCode:zipCode ?: self.zipCode
                                   country:country ?: self.country];
}

@end

@implementation ContactInfo

- (instancetype)initWithPrimaryEmail:(NSString *)primaryEmail
                      secondaryEmail:(NSString *)secondaryEmail
                         phoneNumber:(NSString *)phoneNumber
                             address:(Address *)address {
    self = [super init];
    if (self) {
        _primaryEmail = primaryEmail;
        _secondaryEmail = secondaryEmail;
        _phoneNumber = phoneNumber;
        _address = address;
    }
    return self;
}

- (BOOL)hasMultipleEmails {
    return self.secondaryEmail != nil;
}

- (BOOL)hasCompleteInfo {
    return self.phoneNumber != nil && self.address != nil;
}

- (BOOL)isEqualToContactInfo:(ContactInfo *)other {
    if (!other) return NO;
    BOOL secondaryEmailEqual = (self.secondaryEmail == other.secondaryEmail) ||
                              [self.secondaryEmail isEqualToString:other.secondaryEmail];
    BOOL phoneNumberEqual = (self.phoneNumber == other.phoneNumber) ||
                           [self.phoneNumber isEqualToString:other.phoneNumber];
    BOOL addressEqual = (self.address == other.address) ||
                       [self.address isEqual:other.address];
    
    return [self.primaryEmail isEqualToString:other.primaryEmail] &&
           secondaryEmailEqual && phoneNumberEqual && addressEqual;
}

- (BOOL)isEqual:(id)object {
    if (self == object) return YES;
    if (![object isKindOfClass:[ContactInfo class]]) return NO;
    return [self isEqualToContactInfo:(ContactInfo *)object];
}

- (NSUInteger)hash {
    NSUInteger result = 1;
    result = 31 * result + [self.primaryEmail hash];
    result = 31 * result + [self.secondaryEmail hash];
    result = 31 * result + [self.phoneNumber hash];
    result = 31 * result + [self.address hash];
    return result;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"ContactInfo(primaryEmail: %@, secondaryEmail: %@, phoneNumber: %@, address: %@)",
            self.primaryEmail, self.secondaryEmail, self.phoneNumber, self.address];
}

@end

@implementation Employee

- (instancetype)initWithId:(NSString *)employeeId
                    person:(Person *)person
               contactInfo:(ContactInfo *)contactInfo
                department:(NSString *)department
                  position:(NSString *)position
                    salary:(double)salary
                 startDate:(NSString *)startDate
                   manager:(NSString *)manager
                  isActive:(BOOL)isActive {
    self = [super init];
    if (self) {
        _employeeId = employeeId;
        _person = person;
        _contactInfo = contactInfo;
        _department = department;
        _position = position;
        _salary = salary;
        _startDate = startDate;
        _manager = manager;
        _isActive = isActive;
    }
    return self;
}

- (NSString *)displayName {
    return [NSString stringWithFormat:@"%@ (%@)", [self.person fullName], self.department];
}

- (BOOL)isManager {
    return self.manager == nil;
}

- (NSInteger)yearsOfService {
    NSInteger currentYear = 2024;
    if (self.startDate.length >= 4) {
        NSString *yearString = [self.startDate substringToIndex:4];
        NSInteger startYear = yearString.integerValue;
        if (startYear > 0) {
            return currentYear - startYear;
        }
    }
    return 0;
}

- (BOOL)isEqualToEmployee:(Employee *)other {
    if (!other) return NO;
    BOOL managerEqual = (self.manager == other.manager) || [self.manager isEqualToString:other.manager];
    
    return [self.employeeId isEqualToString:other.employeeId] &&
           [self.person isEqual:other.person] &&
           [self.contactInfo isEqual:other.contactInfo] &&
           [self.department isEqualToString:other.department] &&
           [self.position isEqualToString:other.position] &&
           self.salary == other.salary &&
           [self.startDate isEqualToString:other.startDate] &&
           managerEqual &&
           self.isActive == other.isActive;
}

- (BOOL)isEqual:(id)object {
    if (self == object) return YES;
    if (![object isKindOfClass:[Employee class]]) return NO;
    return [self isEqualToEmployee:(Employee *)object];
}

- (NSUInteger)hash {
    NSUInteger result = 1;
    result = 31 * result + [self.employeeId hash];
    result = 31 * result + [self.person hash];
    result = 31 * result + [self.contactInfo hash];
    result = 31 * result + [self.department hash];
    result = 31 * result + [self.position hash];
    result = 31 * result + [@(self.salary) hash];
    result = 31 * result + [self.startDate hash];
    result = 31 * result + [self.manager hash];
    result = 31 * result + self.isActive;
    return result;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"Employee(id: %@, person: %@, contactInfo: %@, department: %@, position: %@, salary: %.2f, startDate: %@, manager: %@, isActive: %@)",
            self.employeeId, self.person, self.contactInfo, self.department, self.position, self.salary, self.startDate, self.manager, @(self.isActive)];
}

@end

@implementation Transaction

- (instancetype)initWithId:(NSString *)transactionId
                    amount:(double)amount
                  currency:(NSString *)currency
                 timestamp:(int64_t)timestamp
               description:(NSString *)transactionDescription
                  category:(NSString *)category
                      tags:(NSArray<NSString *> *)tags {
    self = [super init];
    if (self) {
        _transactionId = transactionId;
        _amount = amount;
        _currency = currency;
        _timestamp = timestamp;
        _transactionDescription = transactionDescription;
        _category = category;
        _tags = tags;
    }
    return self;
}

- (BOOL)isExpense {
    return self.amount < 0;
}

- (BOOL)isIncome {
    return self.amount > 0;
}

- (NSString *)formattedAmount {
    NSString *prefix = self.amount >= 0 ? @"+" : @"";
    return [NSString stringWithFormat:@"%@%.2f %@", prefix, self.amount, self.currency];
}

- (BOOL)isEqualToTransaction:(Transaction *)other {
    if (!other) return NO;
    return [self.transactionId isEqualToString:other.transactionId] &&
           self.amount == other.amount &&
           [self.currency isEqualToString:other.currency] &&
           self.timestamp == other.timestamp &&
           [self.transactionDescription isEqualToString:other.transactionDescription] &&
           [self.category isEqualToString:other.category] &&
           [self.tags isEqualToArray:other.tags];
}

- (BOOL)isEqual:(id)object {
    if (self == object) return YES;
    if (![object isKindOfClass:[Transaction class]]) return NO;
    return [self isEqualToTransaction:(Transaction *)object];
}

- (NSUInteger)hash {
    NSUInteger result = 1;
    result = 31 * result + [self.transactionId hash];
    result = 31 * result + [@(self.amount) hash];
    result = 31 * result + [self.currency hash];
    result = 31 * result + [@(self.timestamp) hash];
    result = 31 * result + [self.transactionDescription hash];
    result = 31 * result + [self.category hash];
    result = 31 * result + [self.tags hash];
    return result;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"Transaction(id: %@, amount: %.2f, currency: %@, timestamp: %lld, description: %@, category: %@, tags: %@)",
            self.transactionId, self.amount, self.currency, self.timestamp, self.transactionDescription, self.category, self.tags];
}

@end

@implementation Product

- (instancetype)initWithId:(NSString *)productId
                      name:(NSString *)name
               description:(NSString *)productDescription
                     price:(double)price
                  currency:(NSString *)currency
                  category:(NSString *)category
                      tags:(NSArray<NSString *> *)tags
                   inStock:(BOOL)inStock
             stockQuantity:(NSInteger)stockQuantity {
    self = [super init];
    if (self) {
        _productId = productId;
        _name = name;
        _productDescription = productDescription;
        _price = price;
        _currency = currency;
        _category = category;
        _tags = tags;
        _inStock = inStock;
        _stockQuantity = stockQuantity;
    }
    return self;
}

- (BOOL)isAvailable {
    return self.inStock && self.stockQuantity > 0;
}

- (NSString *)formattedPrice {
    return [NSString stringWithFormat:@"%.2f %@", self.price, self.currency];
}

- (BOOL)isOnSale {
    return [self.tags containsObject:@"sale"];
}

- (BOOL)isEqualToProduct:(Product *)other {
    if (!other) return NO;
    return [self.productId isEqualToString:other.productId] &&
           [self.name isEqualToString:other.name] &&
           [self.productDescription isEqualToString:other.productDescription] &&
           self.price == other.price &&
           [self.currency isEqualToString:other.currency] &&
           [self.category isEqualToString:other.category] &&
           [self.tags isEqualToArray:other.tags] &&
           self.inStock == other.inStock &&
           self.stockQuantity == other.stockQuantity;
}

- (BOOL)isEqual:(id)object {
    if (self == object) return YES;
    if (![object isKindOfClass:[Product class]]) return NO;
    return [self isEqualToProduct:(Product *)object];
}

- (NSUInteger)hash {
    NSUInteger result = 1;
    result = 31 * result + [self.productId hash];
    result = 31 * result + [self.name hash];
    result = 31 * result + [self.productDescription hash];
    result = 31 * result + [@(self.price) hash];
    result = 31 * result + [self.currency hash];
    result = 31 * result + [self.category hash];
    result = 31 * result + [self.tags hash];
    result = 31 * result + self.inStock;
    result = 31 * result + self.stockQuantity;
    return result;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"Product(id: %@, name: %@, description: %@, price: %.2f, currency: %@, category: %@, tags: %@, inStock: %@, stockQuantity: %ld)",
            self.productId, self.name, self.productDescription, self.price, self.currency, self.category, self.tags, @(self.inStock), (long)self.stockQuantity];
}

@end

@implementation DataClassProcessor

- (NSDictionary<NSString *, id> *)processPersonData:(NSArray<Person *> *)persons {
    NSInteger totalPersons = persons.count;
    NSInteger adults = 0;
    NSInteger totalAge = 0;
    NSMutableDictionary<NSString *, NSNumber *> *firstNameCounts = [[NSMutableDictionary alloc] init];
    NSMutableSet<NSString *> *emailDomains = [[NSMutableSet alloc] init];
    
    for (Person *person in persons) {
        if ([person isAdult]) {
            adults++;
        }
        totalAge += person.age;
        
        // Count first names
        NSNumber *count = firstNameCounts[person.firstName];
        firstNameCounts[person.firstName] = @(count ? count.integerValue + 1 : 1);
        
        // Extract email domains
        NSArray *emailParts = [person.email componentsSeparatedByString:@"@"];
        if (emailParts.count > 1) {
            [emailDomains addObject:emailParts[1]];
        }
    }
    
    double averageAge = totalPersons > 0 ? (double)totalAge / totalPersons : 0.0;
    
    // Get top 5 first names
    NSArray *sortedNames = [firstNameCounts keysSortedByValueUsingComparator:^NSComparisonResult(NSNumber *obj1, NSNumber *obj2) {
        return [obj2 compare:obj1];
    }];
    NSDictionary *commonFirstNames = [firstNameCounts dictionaryWithValuesForKeys:[sortedNames subarrayWithRange:NSMakeRange(0, MIN(5, sortedNames.count))]];
    
    return @{
        @"totalPersons": @(totalPersons),
        @"adults": @(adults),
        @"averageAge": @(averageAge),
        @"commonFirstNames": commonFirstNames,
        @"emailDomains": [emailDomains allObjects]
    };
}

- (NSDictionary<NSString *, id> *)analyzeEmployeeData:(NSArray<Employee *> *)employees {
    NSInteger totalEmployees = employees.count;
    NSInteger activeEmployees = 0;
    NSInteger managers = 0;
    double totalSalary = 0;
    NSMutableDictionary<NSString *, NSNumber *> *departmentCounts = [[NSMutableDictionary alloc] init];
    NSMutableDictionary<NSString *, NSNumber *> *salaryRanges = [[NSMutableDictionary alloc] init];
    
    for (Employee *employee in employees) {
        if (employee.isActive) {
            activeEmployees++;
        }
        if ([employee isManager]) {
            managers++;
        }
        totalSalary += employee.salary;
        
        // Count departments
        NSNumber *deptCount = departmentCounts[employee.department];
        departmentCounts[employee.department] = @(deptCount ? deptCount.integerValue + 1 : 1);
        
        // Categorize salary ranges
        NSString *salaryRange;
        if (employee.salary < 50000) {
            salaryRange = @"Under 50K";
        } else if (employee.salary < 100000) {
            salaryRange = @"50K-100K";
        } else if (employee.salary < 150000) {
            salaryRange = @"100K-150K";
        } else {
            salaryRange = @"150K+";
        }
        
        NSNumber *rangeCount = salaryRanges[salaryRange];
        salaryRanges[salaryRange] = @(rangeCount ? rangeCount.integerValue + 1 : 1);
    }
    
    double averageSalary = totalEmployees > 0 ? totalSalary / totalEmployees : 0.0;
    
    return @{
        @"totalEmployees": @(totalEmployees),
        @"activeEmployees": @(activeEmployees),
        @"departments": departmentCounts,
        @"averageSalary": @(averageSalary),
        @"salaryRanges": salaryRanges,
        @"managers": @(managers)
    };
}

- (NSDictionary<NSString *, id> *)processTransactionData:(NSArray<Transaction *> *)transactions {
    NSInteger totalTransactions = transactions.count;
    double totalIncome = 0;
    double totalExpenses = 0;
    double totalAmount = 0;
    NSMutableDictionary<NSString *, NSMutableDictionary *> *categories = [[NSMutableDictionary alloc] init];
    NSMutableSet<NSString *> *currencies = [[NSMutableSet alloc] init];
    
    for (Transaction *transaction in transactions) {
        if ([transaction isIncome]) {
            totalIncome += transaction.amount;
        }
        if ([transaction isExpense]) {
            totalExpenses += transaction.amount;
        }
        totalAmount += transaction.amount;
        
        [currencies addObject:transaction.currency];
        
        // Group by category
        NSMutableDictionary *categoryData = categories[transaction.category];
        if (!categoryData) {
            categoryData = [@{@"count": @0, @"total": @0.0} mutableCopy];
            categories[transaction.category] = categoryData;
        }
        
        categoryData[@"count"] = @([categoryData[@"count"] integerValue] + 1);
        categoryData[@"total"] = @([categoryData[@"total"] doubleValue] + transaction.amount);
    }
    
    double averageTransaction = totalTransactions > 0 ? totalAmount / totalTransactions : 0.0;
    
    return @{
        @"totalTransactions": @(totalTransactions),
        @"totalIncome": @(totalIncome),
        @"totalExpenses": @(totalExpenses),
        @"categories": categories,
        @"averageTransaction": @(averageTransaction),
        @"currencies": [currencies allObjects]
    };
}

@end

@implementation IosSizeBenchmark

- (void)runBenchmark {
    DataClassProcessor *processor = [[DataClassProcessor alloc] init];
    
    // Create sample data - extremely verbose constructor calls
    NSArray<Person *> *persons = @[
        [[Person alloc] initWithId:@"1" firstName:@"John" lastName:@"Doe" age:30 email:@"john.doe@example.com"],
        [[Person alloc] initWithId:@"2" firstName:@"Jane" lastName:@"Smith" age:25 email:@"jane.smith@test.com"],
        [[Person alloc] initWithId:@"3" firstName:@"Bob" lastName:@"Johnson" age:35 email:@"bob.johnson@company.org"],
        [[Person alloc] initWithId:@"4" firstName:@"Alice" lastName:@"Brown" age:28 email:@"alice.brown@email.net"],
        [[Person alloc] initWithId:@"5" firstName:@"Charlie" lastName:@"Wilson" age:42 email:@"charlie.wilson@work.com"]
    ];
    
    NSArray<Address *> *addresses = @[
        [[Address alloc] initWithStreet:@"123 Main St" city:@"New York" state:@"NY" zipCode:@"10001" country:@"USA"],
        [[Address alloc] initWithStreet:@"456 Oak Ave" city:@"Los Angeles" state:@"CA" zipCode:@"90210" country:@"USA"],
        [[Address alloc] initWithStreet:@"789 Pine Rd" city:@"Chicago" state:@"IL" zipCode:@"60601" country:@"USA"]
    ];
    
    NSMutableArray<ContactInfo *> *contactInfos = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < persons.count; i++) {
        Person *person = persons[i];
        Address *address = addresses[i % addresses.count];
        ContactInfo *contact = [[ContactInfo alloc] initWithPrimaryEmail:person.email
                                                         secondaryEmail:nil
                                                            phoneNumber:@"+1234567890"
                                                                address:address];
        [contactInfos addObject:contact];
    }
    
    NSMutableArray<Employee *> *employees = [[NSMutableArray alloc] init];
    NSArray<NSString *> *departments = @[@"Engineering", @"Marketing", @"Sales", @"HR", @"Finance"];
    NSArray<NSString *> *positions = @[@"Developer", @"Manager", @"Analyst", @"Specialist", @"Director"];
    
    for (NSInteger i = 0; i < persons.count; i++) {
        Person *person = persons[i];
        ContactInfo *contact = contactInfos[i];
        Employee *employee = [[Employee alloc] initWithId:[NSString stringWithFormat:@"EMP_%@", person.personId]
                                                   person:person
                                              contactInfo:contact
                                               department:departments[i % departments.count]
                                                 position:positions[i % positions.count]
                                                   salary:50000.0 + (i * 15000)
                                                startDate:[NSString stringWithFormat:@"202%ld-01-01", (long)(i + 1)]
                                                  manager:nil
                                                 isActive:YES];
        [employees addObject:employee];
    }
    
    // Test manual equals functionality - Kotlin data classes do this automatically
    Person *person1 = persons[0];
    Person *person2 = [[Person alloc] initWithId:@"1" firstName:@"John" lastName:@"Doe" age:30 email:@"john.doe@example.com"];
    BOOL areEqual = [person1 isEqual:person2];
    
    // Test manual hashCode functionality - Kotlin data classes do this automatically
    NSUInteger hashCode1 = [person1 hash];
    NSUInteger hashCode2 = [person2 hash];
    BOOL hashCodesEqual = hashCode1 == hashCode2;
    
    // Test manual toString functionality - Kotlin data classes do this automatically
    NSString *personString = [person1 description];
    
    // Test manual copy functionality - Kotlin data classes do this automatically with named parameters
    Person *modifiedPerson = [person1 copyWithId:nil firstName:nil lastName:nil age:@31 email:nil];
    
    // Create transactions
    NSMutableArray<Transaction *> *transactions = [[NSMutableArray alloc] init];
    NSArray<NSString *> *categories = @[@"food", @"transportation", @"entertainment", @"utilities", @"salary"];
    
    for (NSInteger i = 1; i <= 100; i++) {
        double amount = (i % 3 == 0) ? -(50.0 + i * 10) : (100.0 + i * 5);
        NSString *currency = (i % 10 == 0) ? @"EUR" : @"USD";
        NSArray<NSString *> *tags = (i % 5 == 0) ? @[@"recurring", @"essential"] : @[];
        
        Transaction *transaction = [[Transaction alloc] initWithId:[NSString stringWithFormat:@"TXN_%ld", (long)i]
                                                            amount:amount
                                                          currency:currency
                                                         timestamp:[[NSDate date] timeIntervalSince1970] * 1000 - (i * 86400000)
                                                       description:[NSString stringWithFormat:@"Transaction %ld", (long)i]
                                                          category:categories[i % categories.count]
                                                              tags:tags];
        [transactions addObject:transaction];
    }
    
    // Create products
    NSMutableArray<Product *> *products = [[NSMutableArray alloc] init];
    NSArray<NSString *> *productCategories = @[@"electronics", @"clothing", @"books", @"home", @"sports"];
    
    for (NSInteger i = 1; i <= 50; i++) {
        NSArray<NSString *> *tags;
        if (i % 10 == 0) {
            tags = @[@"sale", @"featured"];
        } else if (i % 7 == 0) {
            tags = @[@"new"];
        } else {
            tags = @[];
        }
        
        Product *product = [[Product alloc] initWithId:[NSString stringWithFormat:@"PROD_%ld", (long)i]
                                                  name:[NSString stringWithFormat:@"Product %ld", (long)i]
                                           description:[NSString stringWithFormat:@"Description for product %ld", (long)i]
                                                 price:10.0 + (i * 5)
                                              currency:@"USD"
                                              category:productCategories[i % productCategories.count]
                                                  tags:tags
                                               inStock:(i % 15 != 0)
                                         stockQuantity:(i % 15 == 0) ? 0 : i * 2];
        [products addObject:product];
    }
    
    // Process all data using manual processing methods
    NSDictionary *personStats = [processor processPersonData:persons];
    NSDictionary *employeeStats = [processor analyzeEmployeeData:employees];
    NSDictionary *transactionStats = [processor processTransactionData:transactions];
    
    // Test complex transformations - much more verbose than Kotlin data class copy
    NSMutableArray<Employee *> *promotedEmployees = [[NSMutableArray alloc] init];
    for (Employee *employee in employees) {
        if ([employee yearsOfService] > 2) {
            // Manual copy with modifications - extremely verbose
            Employee *promoted = [[Employee alloc] initWithId:employee.employeeId
                                                       person:employee.person
                                                  contactInfo:employee.contactInfo
                                                   department:employee.department
                                                     position:[NSString stringWithFormat:@"Senior %@", employee.position]
                                                       salary:employee.salary * 1.2
                                                    startDate:employee.startDate
                                                      manager:employee.manager
                                                     isActive:employee.isActive];
            [promotedEmployees addObject:promoted];
        } else {
            [promotedEmployees addObject:employee];
        }
    }
    
    // Demonstrate the massive verbosity difference between Kotlin data classes and Objective-C
    NSLog(@"Person equality check: %@", @(areEqual));
    NSLog(@"Hash codes equal: %@", @(hashCodesEqual));
    NSLog(@"Person description: %@", personString);
    NSLog(@"Modified person age: %ld", (long)modifiedPerson.age);
    NSLog(@"Total persons processed: %@", personStats[@"totalPersons"]);
    NSLog(@"Total employees processed: %@", employeeStats[@"totalEmployees"]);
    NSLog(@"Total transactions processed: %@", transactionStats[@"totalTransactions"]);
}

@end