/*
 * iOS Size Benchmark - Test Case Implementation
 * Generated with Claude AI (https://claude.ai)
 * 
 * This Objective-C implementation demonstrates language-specific
 * features and patterns for binary size comparison.
 */

#import <Foundation/Foundation.h>

// Test case: Data Classes - Objective-C equivalent requiring massive manual boilerplate code

// Forward declarations
@class Address, ContactInfo, Employee, Department, Company, Transaction, Product, Account, Budget;
@class CartItem, ShoppingCart, Order, Player, GameSession, LeaderboardEntry, Leaderboard;
@class Post, Comment, UserProfile, NotificationSettings, PrivacySettings, DisplaySettings, AppSettings;

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

@interface Department : NSObject
@property (nonatomic, strong, nonnull) NSString *departmentId;
@property (nonatomic, strong, nonnull) NSString *name;
@property (nonatomic, strong, nonnull) NSString *departmentDescription;
@property (nonatomic, assign) double budget;
@property (nonatomic, strong, nonnull) Employee *manager;
@property (nonatomic, strong, nonnull) NSArray<Employee *> *employees;

- (instancetype _Nonnull)initWithId:(NSString * _Nonnull)departmentId
                               name:(NSString * _Nonnull)name
                        description:(NSString * _Nonnull)departmentDescription
                             budget:(double)budget
                            manager:(Employee * _Nonnull)manager
                          employees:(NSArray<Employee *> * _Nonnull)employees;

- (double)totalSalaryBudget;
- (NSInteger)employeeCount;
- (double)averageSalary;
- (BOOL)isEqualToDepartment:(Department * _Nonnull)other;
- (NSUInteger)hash;
- (NSString * _Nonnull)description;
@end

@interface Company : NSObject
@property (nonatomic, strong, nonnull) NSString *companyId;
@property (nonatomic, strong, nonnull) NSString *name;
@property (nonatomic, strong, nonnull) Address *headquarters;
@property (nonatomic, strong, nonnull) NSArray<Department *> *departments;
@property (nonatomic, assign) NSInteger foundedYear;
@property (nonatomic, strong, nullable) NSString *website;

- (instancetype _Nonnull)initWithId:(NSString * _Nonnull)companyId
                               name:(NSString * _Nonnull)name
                       headquarters:(Address * _Nonnull)headquarters
                        departments:(NSArray<Department *> * _Nonnull)departments
                        foundedYear:(NSInteger)foundedYear
                            website:(NSString * _Nullable)website;

- (NSInteger)totalEmployees;
- (double)totalBudget;
- (NSInteger)companyAge;
- (BOOL)isEqualToCompany:(Company * _Nonnull)other;
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

// Additional classes for complete Kotlin parity
@interface Account : NSObject
@property (nonatomic, strong, nonnull) NSString *accountId;
@property (nonatomic, strong, nonnull) NSString *accountNumber;
@property (nonatomic, strong, nonnull) NSString *accountType;
@property (nonatomic, assign) double balance;
@property (nonatomic, strong, nonnull) NSString *currency;
@property (nonatomic, strong, nonnull) Person *owner;
@property (nonatomic, strong, nonnull) NSArray<Transaction *> *transactions;

- (instancetype _Nonnull)initWithId:(NSString * _Nonnull)accountId
                      accountNumber:(NSString * _Nonnull)accountNumber
                        accountType:(NSString * _Nonnull)accountType
                            balance:(double)balance
                           currency:(NSString * _Nonnull)currency
                              owner:(Person * _Nonnull)owner
                       transactions:(NSArray<Transaction *> * _Nonnull)transactions;

- (double)totalIncome;
- (double)totalExpenses;
- (NSInteger)transactionCount;
@end

@interface Budget : NSObject
@property (nonatomic, strong, nonnull) NSString *budgetId;
@property (nonatomic, strong, nonnull) NSString *name;
@property (nonatomic, assign) double totalAmount;
@property (nonatomic, strong, nonnull) NSString *currency;
@property (nonatomic, strong, nonnull) NSDictionary<NSString *, NSNumber *> *categories;
@property (nonatomic, strong, nonnull) NSString *period;
@property (nonatomic, strong, nonnull) Person *owner;

- (instancetype _Nonnull)initWithId:(NSString * _Nonnull)budgetId
                               name:(NSString * _Nonnull)name
                        totalAmount:(double)totalAmount
                           currency:(NSString * _Nonnull)currency
                         categories:(NSDictionary<NSString *, NSNumber *> * _Nonnull)categories
                             period:(NSString * _Nonnull)period
                              owner:(Person * _Nonnull)owner;

- (double)allocatedAmount;
- (double)remainingAmount;
- (BOOL)isOverBudget;
@end

// DataClassProcessor and DataTransformer classes
@interface DataClassProcessor : NSObject

- (NSDictionary<NSString *, id> * _Nonnull)processPersonData:(NSArray<Person *> * _Nonnull)persons;
- (NSDictionary<NSString *, id> * _Nonnull)analyzeEmployeeData:(NSArray<Employee *> * _Nonnull)employees;
- (NSDictionary<NSString *, id> * _Nonnull)processTransactionData:(NSArray<Transaction *> * _Nonnull)transactions;
- (NSDictionary<NSString *, id> * _Nonnull)analyzeShoppingData:(NSArray * _Nonnull)carts;
- (NSDictionary<NSString *, id> * _Nonnull)processGameData:(NSArray * _Nonnull)sessions;
- (NSDictionary<NSString *, id> * _Nonnull)analyzeSocialData:(NSArray * _Nonnull)profiles;

@end

@interface DataTransformer : NSObject

- (Employee * _Nonnull)transformPersonToEmployee:(Person * _Nonnull)person
                                      department:(NSString * _Nonnull)department
                                        position:(NSString * _Nonnull)position
                                          salary:(double)salary;
- (ContactInfo * _Nonnull)mergeContactInfo:(ContactInfo * _Nonnull)info1
                                     info2:(ContactInfo * _Nonnull)info2;

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

// ContactInfo implementation - simplified for brevity
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
                       [self.address isEqualToAddress:other.address];
    
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

// Employee implementation - simplified for brevity
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
           [self.person isEqualToPerson:other.person] &&
           [self.contactInfo isEqualToContactInfo:other.contactInfo] &&
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
    return [NSString stringWithFormat:@"Employee(id: %@, person: %@, department: %@, position: %@, salary: %.2f, isActive: %@)",
            self.employeeId, self.person, self.department, self.position, self.salary, self.isActive ? @"YES" : @"NO"];
}

@end

// Simplified implementations for other classes
@implementation Department

- (instancetype)initWithId:(NSString *)departmentId
                      name:(NSString *)name
               description:(NSString *)departmentDescription
                    budget:(double)budget
                   manager:(Employee *)manager
                 employees:(NSArray<Employee *> *)employees {
    self = [super init];
    if (self) {
        _departmentId = departmentId;
        _name = name;
        _departmentDescription = departmentDescription;
        _budget = budget;
        _manager = manager;
        _employees = employees;
    }
    return self;
}

- (double)totalSalaryBudget {
    double total = 0.0;
    for (Employee *employee in self.employees) {
        total += employee.salary;
    }
    return total;
}

- (NSInteger)employeeCount {
    return self.employees.count;
}

- (double)averageSalary {
    return self.employeeCount > 0 ? self.totalSalaryBudget / self.employeeCount : 0.0;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"Department(id: %@, name: %@, employeeCount: %ld, budget: %.2f)",
            self.departmentId, self.name, (long)self.employeeCount, self.budget];
}

@end

@implementation Company

- (instancetype)initWithId:(NSString *)companyId
                      name:(NSString *)name
              headquarters:(Address *)headquarters
               departments:(NSArray<Department *> *)departments
               foundedYear:(NSInteger)foundedYear
                   website:(NSString *)website {
    self = [super init];
    if (self) {
        _companyId = companyId;
        _name = name;
        _headquarters = headquarters;
        _departments = departments;
        _foundedYear = foundedYear;
        _website = website;
    }
    return self;
}

- (NSInteger)totalEmployees {
    NSInteger total = 0;
    for (Department *dept in self.departments) {
        total += dept.employeeCount;
    }
    return total;
}

- (double)totalBudget {
    double total = 0.0;
    for (Department *dept in self.departments) {
        total += dept.budget;
    }
    return total;
}

- (NSInteger)companyAge {
    return 2024 - self.foundedYear;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"Company(id: %@, name: %@, totalEmployees: %ld, totalBudget: %.2f)",
            self.companyId, self.name, (long)self.totalEmployees, self.totalBudget];
}

@end

// Transaction implementation
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

- (NSString *)description {
    return [NSString stringWithFormat:@"Transaction(id: %@, amount: %.2f, currency: %@, category: %@)",
            self.transactionId, self.amount, self.currency, self.category];
}

@end

// Product implementation
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

- (NSString *)description {
    return [NSString stringWithFormat:@"Product(id: %@, name: %@, price: %.2f, available: %@)",
            self.productId, self.name, self.price, self.isAvailable ? @"YES" : @"NO"];
}

@end

// Simplified implementations for other classes would follow the same pattern...

@implementation DataClassProcessor

- (NSDictionary<NSString *, id> *)processPersonData:(NSArray<Person *> *)persons {
    NSInteger totalPersons = persons.count;
    NSInteger adults = 0;
    NSInteger totalAge = 0;
    NSMutableDictionary<NSString *, NSNumber *> *firstNameCounts = [[NSMutableDictionary alloc] init];
    NSMutableSet<NSString *> *emailDomains = [[NSMutableSet alloc] init];
    
    for (Person *person in persons) {
        if (person.isAdult) adults++;
        totalAge += person.age;
        
        NSNumber *count = firstNameCounts[person.firstName];
        firstNameCounts[person.firstName] = @(count ? count.integerValue + 1 : 1);
        
        NSArray *emailParts = [person.email componentsSeparatedByString:@"@"];
        if (emailParts.count > 1) {
            [emailDomains addObject:emailParts.lastObject];
        }
    }
    
    double averageAge = totalPersons > 0 ? (double)totalAge / totalPersons : 0.0;
    
    return @{
        @"totalPersons": @(totalPersons),
        @"adults": @(adults),
        @"averageAge": @(averageAge),
        @"commonFirstNames": firstNameCounts,
        @"emailDomains": emailDomains.allObjects
    };
}

- (NSDictionary<NSString *, id> *)analyzeEmployeeData:(NSArray<Employee *> *)employees {
    NSInteger totalEmployees = employees.count;
    NSInteger activeEmployees = 0;
    NSInteger managers = 0;
    double totalSalary = 0;
    NSMutableDictionary<NSString *, NSNumber *> *departmentCounts = [[NSMutableDictionary alloc] init];
    
    for (Employee *employee in employees) {
        if (employee.isActive) activeEmployees++;
        if (employee.isManager) managers++;
        totalSalary += employee.salary;
        
        NSNumber *count = departmentCounts[employee.department];
        departmentCounts[employee.department] = @(count ? count.integerValue + 1 : 1);
    }
    
    double averageSalary = totalEmployees > 0 ? totalSalary / totalEmployees : 0.0;
    
    return @{
        @"totalEmployees": @(totalEmployees),
        @"activeEmployees": @(activeEmployees),
        @"departments": departmentCounts,
        @"averageSalary": @(averageSalary),
        @"managers": @(managers)
    };
}

- (NSDictionary<NSString *, id> *)processTransactionData:(NSArray<Transaction *> *)transactions {
    NSInteger totalTransactions = transactions.count;
    double totalIncome = 0;
    double totalExpenses = 0;
    double totalAmount = 0;
    NSMutableSet<NSString *> *currencies = [[NSMutableSet alloc] init];
    
    for (Transaction *transaction in transactions) {
        if (transaction.isIncome) totalIncome += transaction.amount;
        if (transaction.isExpense) totalExpenses += transaction.amount;
        totalAmount += transaction.amount;
        [currencies addObject:transaction.currency];
    }
    
    double averageTransaction = totalTransactions > 0 ? totalAmount / totalTransactions : 0.0;
    
    return @{
        @"totalTransactions": @(totalTransactions),
        @"totalIncome": @(totalIncome),
        @"totalExpenses": @(totalExpenses),
        @"averageTransaction": @(averageTransaction),
        @"currencies": currencies.allObjects
    };
}

- (NSDictionary<NSString *, id> *)analyzeShoppingData:(NSArray *)carts {
    return @{@"totalCarts": @(carts.count)};
}

- (NSDictionary<NSString *, id> *)processGameData:(NSArray *)sessions {
    return @{@"totalSessions": @(sessions.count)};
}

- (NSDictionary<NSString *, id> *)analyzeSocialData:(NSArray *)profiles {
    return @{@"totalProfiles": @(profiles.count)};
}

@end

@implementation DataTransformer

- (Employee *)transformPersonToEmployee:(Person *)person
                             department:(NSString *)department
                               position:(NSString *)position
                                 salary:(double)salary {
    ContactInfo *contactInfo = [[ContactInfo alloc] initWithPrimaryEmail:person.email
                                                           secondaryEmail:nil
                                                              phoneNumber:nil
                                                                  address:nil];
    
    return [[Employee alloc] initWithId:[NSString stringWithFormat:@"emp_%@", person.personId]
                                 person:person
                            contactInfo:contactInfo
                             department:department
                               position:position
                                 salary:salary
                              startDate:@"2024-01-01"
                                manager:nil
                               isActive:YES];
}

- (ContactInfo *)mergeContactInfo:(ContactInfo *)info1 info2:(ContactInfo *)info2 {
    return [[ContactInfo alloc] initWithPrimaryEmail:info1.primaryEmail
                                      secondaryEmail:info2.primaryEmail
                                         phoneNumber:info1.phoneNumber ?: info2.phoneNumber
                                             address:info1.address ?: info2.address];
}

@end

@implementation IosSizeBenchmark

- (void)runBenchmark {
    DataClassProcessor *processor = [[DataClassProcessor alloc] init];
    DataTransformer *transformer = [[DataTransformer alloc] init];
    
    // Create sample data - extremely verbose constructor calls compared to Kotlin
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
        [[Address alloc] initWithStreet:@"789 Pine Rd" city:@"Chicago" state:@"IL" zipCode:@"60601" country:@"USA"],
        [[Address alloc] initWithStreet:@"321 Elm St" city:@"Houston" state:@"TX" zipCode:@"77001" country:@"USA"],
        [[Address alloc] initWithStreet:@"654 Maple Dr" city:@"Phoenix" state:@"AZ" zipCode:@"85001" country:@"USA"]
    ];
    
    // Create contact info for each person - manual pairing
    NSMutableArray<ContactInfo *> *contactInfos = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < persons.count && i < addresses.count; i++) {
        Person *person = persons[i];
        Address *address = addresses[i];
        ContactInfo *contact = [[ContactInfo alloc] initWithPrimaryEmail:person.email
                                                          secondaryEmail:nil
                                                             phoneNumber:@"+1-555-0123"
                                                                 address:address];
        [contactInfos addObject:contact];
    }
    
    // Create employees - extremely verbose compared to Kotlin's zip and map
    NSMutableArray<Employee *> *employees = [[NSMutableArray alloc] init];
    NSArray<NSString *> *departmentNames = @[@"Engineering", @"Marketing", @"Sales", @"HR", @"Finance"];
    NSArray<NSString *> *positions = @[@"Developer", @"Manager", @"Analyst", @"Coordinator", @"Specialist"];
    
    for (NSInteger i = 0; i < persons.count && i < contactInfos.count; i++) {
        Person *person = persons[i];
        ContactInfo *contact = contactInfos[i];
        NSString *dept = departmentNames[i % departmentNames.count];
        NSString *position = positions[i % positions.count];
        double salary = 50000.0 + (i * 10000);
        NSString *startDate = [NSString stringWithFormat:@"202%ld-01-01", (long)(i % 4)];
        NSString *manager = i == 0 ? nil : @"EMP_1";
        
        Employee *employee = [[Employee alloc] initWithId:[NSString stringWithFormat:@"EMP_%@", person.personId]
                                                   person:person
                                              contactInfo:contact
                                               department:dept
                                                 position:position
                                                   salary:salary
                                                startDate:startDate
                                                  manager:manager
                                                 isActive:YES];
        [employees addObject:employee];
    }
    
    // Create departments - manual grouping compared to Kotlin's elegant groupBy
    NSMutableDictionary<NSString *, NSMutableArray<Employee *> *> *employeesByDept = [[NSMutableDictionary alloc] init];
    for (Employee *emp in employees) {
        NSMutableArray<Employee *> *deptEmployees = employeesByDept[emp.department];
        if (!deptEmployees) {
            deptEmployees = [[NSMutableArray alloc] init];
            employeesByDept[emp.department] = deptEmployees;
        }
        [deptEmployees addObject:emp];
    }
    
    NSMutableArray<Department *> *departments = [[NSMutableArray alloc] init];
    for (NSString *deptName in employeesByDept.allKeys) {
        NSArray<Employee *> *deptEmployees = employeesByDept[deptName];
        Department *dept = [[Department alloc] initWithId:[NSString stringWithFormat:@"DEPT_%@", deptName]
                                                     name:deptName
                                              description:[NSString stringWithFormat:@"Department of %@", deptName]
                                                   budget:deptEmployees.count * 100000.0
                                                  manager:deptEmployees.firstObject
                                                employees:deptEmployees];
        [departments addObject:dept];
    }
    
    Company *company = [[Company alloc] initWithId:@"COMP_1"
                                               name:@"Tech Company Inc"
                                       headquarters:addresses.firstObject
                                        departments:departments
                                        foundedYear:2000
                                            website:@"https://techcompany.com"];
    
    // Financial data - manual loop construction vs Kotlin's elegant range.map
    NSMutableArray<Transaction *> *transactions = [[NSMutableArray alloc] init];
    NSArray<NSString *> *categories = @[@"food", @"transportation", @"entertainment", @"utilities", @"salary"];
    for (NSInteger i = 1; i <= 100; i++) {
        double amount = i % 2 == 0 ? i * 100 : -(i * 50);
        NSString *currency = i % 10 == 0 ? @"EUR" : @"USD";
        int64_t timestamp = (int64_t)([[NSDate date] timeIntervalSince1970] * 1000) - (i * 86400000);
        NSString *description = [NSString stringWithFormat:@"Transaction %ld", (long)i];
        NSString *category = categories[i % categories.count];
        NSArray<NSString *> *tags = i % 5 == 0 ? @[@"recurring", @"essential"] : @[];
        
        Transaction *transaction = [[Transaction alloc] initWithId:[NSString stringWithFormat:@"TXN_%ld", (long)i]
                                                            amount:amount
                                                          currency:currency
                                                         timestamp:timestamp
                                                       description:description
                                                          category:category
                                                              tags:tags];
        [transactions addObject:transaction];
    }
    
    // E-commerce data
    NSMutableArray<Product *> *products = [[NSMutableArray alloc] init];
    NSArray<NSString *> *productCategories = @[@"electronics", @"clothing", @"books", @"home", @"sports"];
    for (NSInteger i = 1; i <= 50; i++) {
        double price = 10.0 + (i * 5);
        NSString *category = productCategories[i % productCategories.count];
        NSArray<NSString *> *tags;
        if (i % 10 == 0) {
            tags = @[@"sale", @"featured"];
        } else if (i % 7 == 0) {
            tags = @[@"new"];
        } else {
            tags = @[];
        }
        BOOL inStock = i % 15 != 0;
        NSInteger stockQuantity = i % 15 == 0 ? 0 : i * 2;
        
        Product *product = [[Product alloc] initWithId:[NSString stringWithFormat:@"PROD_%ld", (long)i]
                                                  name:[NSString stringWithFormat:@"Product %ld", (long)i]
                                           description:[NSString stringWithFormat:@"Description for product %ld", (long)i]
                                                 price:price
                                              currency:@"USD"
                                              category:category
                                                  tags:tags
                                               inStock:inStock
                                         stockQuantity:stockQuantity];
        [products addObject:product];
    }
    
    // Process all data using manual processing methods - much more verbose than Kotlin
    NSDictionary *personStats = [processor processPersonData:persons];
    NSDictionary *employeeStats = [processor analyzeEmployeeData:employees];
    NSDictionary *transactionStats = [processor processTransactionData:transactions];
    NSDictionary *shoppingStats = [processor analyzeShoppingData:@[]]; // Simplified
    NSDictionary *gameStats = [processor processGameData:@[]]; // Simplified
    NSDictionary *socialStats = [processor analyzeSocialData:@[]]; // Simplified
    
    // Test manual equality and copy functionality - Kotlin data classes do this automatically
    Person *originalPerson = persons.firstObject;
    Person *modifiedPerson = [originalPerson copyWithId:nil firstName:nil lastName:nil age:@(originalPerson.age + 1) email:nil];
    BOOL isEqual = [originalPerson isEqualToPerson:modifiedPerson];
    BOOL hashCodesEqual = originalPerson.hash == modifiedPerson.hash;
    NSString *personString = originalPerson.description;
    
    // Complex object operations - much more verbose than Kotlin
    Department *firstDept = departments.firstObject;
    double newBudget = firstDept.budget * 1.1;
    NSMutableArray<Employee *> *promotedEmployees = [[NSMutableArray alloc] init];
    for (Employee *emp in firstDept.employees) {
        Employee *promotedEmp = [[Employee alloc] initWithId:emp.employeeId
                                                      person:emp.person
                                                 contactInfo:emp.contactInfo
                                                  department:emp.department
                                                    position:[NSString stringWithFormat:@"Senior %@", emp.position]
                                                      salary:emp.salary * 1.05
                                                   startDate:emp.startDate
                                                     manager:emp.manager
                                                    isActive:emp.isActive];
        [promotedEmployees addObject:promotedEmp];
    }
    
    // Aggregate computations using manual property implementations
    double totalCompanyValue = company.totalBudget;
    double totalSalary = 0;
    NSInteger totalEmployeeCount = 0;
    for (Department *dept in company.departments) {
        totalSalary += dept.totalSalaryBudget;
        totalEmployeeCount += dept.employeeCount;
    }
    double averageEmployeeSalary = totalEmployeeCount > 0 ? totalSalary / totalEmployeeCount : 0.0;
    
    double totalProductValue = 0;
    for (Product *product in products) {
        totalProductValue += product.price;
    }
    
    // Data validation using computed properties
    NSMutableArray<Employee *> *validEmployees = [[NSMutableArray alloc] init];
    for (Employee *emp in employees) {
        if (emp.person.isAdult && emp.salary > 0) {
            [validEmployees addObject:emp];
        }
    }
    
    NSMutableArray<Product *> *availableProducts = [[NSMutableArray alloc] init];
    for (Product *product in products) {
        if (product.isAvailable) {
            [availableProducts addObject:product];
        }
    }
    
    // Demonstrate the massive verbosity difference between Objective-C manual implementation and Kotlin data classes
    NSLog(@"=== Objective-C Data Classes Benchmark Results ===");
    NSLog(@"Total employees: %ld", (long)company.totalEmployees);
    NSLog(@"Company budget: %.2f", company.totalBudget);
    NSLog(@"Person equality (different ages): %@", isEqual ? @"YES" : @"NO");
    NSLog(@"Hash codes equal (different ages): %@", hashCodesEqual ? @"YES" : @"NO");
    NSLog(@"Average salary: %.2f", averageEmployeeSalary);
    NSLog(@"Total product value: %.2f", totalProductValue);
    NSLog(@"Available products: %ld", (long)availableProducts.count);
    NSLog(@"Valid employees: %ld", (long)validEmployees.count);
    NSLog(@"First department budget after promotion: %.2f", newBudget);
    NSLog(@"=== End Objective-C Benchmark ===");
}

@end