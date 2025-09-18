/*
 * iOS Size Benchmark - Test Case Implementation
 * Generated with Claude AI (https://claude.ai)
 * 
 * This Objective-C implementation demonstrates language-specific
 * features and patterns for binary size comparison.
 */

#import <Foundation/Foundation.h>

// Test case: Extension Functions - Objective-C equivalent using categories and utility classes
// This demonstrates how verbose Objective-C becomes compared to Kotlin's elegant extension functions

// Forward declarations
@class Person;
@class Product;
@class Order;
@class BankAccount;
@class Transaction;
@class Player;
@class ApiResponse;
@class AppConfig;

// String utility category (equivalent to Kotlin's String extensions)
@interface NSString (ExtensionFunctions)

- (BOOL)isValidEmail;
- (BOOL)isValidPhone;
- (NSString * _Nonnull)toTitleCase;
- (NSString * _Nonnull)toCamelCase;
- (NSString * _Nonnull)toSnakeCase;
- (NSString * _Nonnull)truncateWithMaxLength:(NSInteger)maxLength suffix:(NSString * _Nullable)suffix;
- (NSString * _Nonnull)removeWhitespace;
- (NSInteger)countWords;
- (NSString * _Nonnull)reverse;
- (BOOL)isPalindrome;
- (NSArray<NSNumber *> * _Nonnull)extractNumbers;
- (NSArray<NSString *> * _Nonnull)extractEmails;
- (NSString * _Nonnull)maskEmail;
- (NSString * _Nonnull)emailDomain;
- (NSDictionary<NSString *, NSNumber *> * _Nonnull)wordFrequency;
- (NSString * _Nonnull)fileExtension;
- (NSString * _Nonnull)fileName;
- (NSString * _Nonnull)filePath;
- (BOOL)isImageFile;
- (BOOL)isTextFile;
- (BOOL)isExecutable;
- (BOOL)isValidUrl;
- (NSString * _Nonnull)domain;
- (NSString * _Nonnull)protocol;
- (BOOL)isSecureUrl;
- (BOOL)isNumeric;
- (BOOL)isAlphabetic;
- (BOOL)isAlphanumeric;
- (BOOL)hasUppercase;
- (BOOL)hasLowercase;
- (BOOL)hasDigits;
- (BOOL)hasSpecialChars;
- (BOOL)isStrongPassword;

@end

// Number utility category
@interface NSNumber (ExtensionFunctions)

- (BOOL)isEven;
- (BOOL)isOdd;
- (BOOL)isPrime;
- (NSNumber * _Nonnull)factorial;
- (NSString * _Nonnull)toRoman;
- (NSString * _Nonnull)formatCurrencyWithCurrency:(NSString * _Nullable)currency;
- (NSString * _Nonnull)toPercentage;
- (NSNumber * _Nonnull)roundToDecimals:(NSInteger)decimals;
- (NSString * _Nonnull)toDateString;
- (NSString * _Nonnull)formatDuration;

@end

// Array utility category
@interface NSArray (ExtensionFunctions)

- (id _Nullable)second;
- (id _Nullable)third;
- (id _Nullable)secondToLast;
- (NSArray * _Nonnull)takeRandom:(NSInteger)count;
- (NSArray * _Nonnull)splitWithPredicate:(BOOL (^_Nonnull)(id _Nonnull))predicate;
- (NSArray<NSArray *> * _Nonnull)chunksWithSize:(NSInteger)size;
- (NSArray * _Nonnull)rotateLeft:(NSInteger)positions;
- (NSArray * _Nonnull)rotateRight:(NSInteger)positions;
- (NSDictionary * _Nonnull)frequencyMap;
- (NSArray * _Nonnull)duplicates;
- (NSArray * _Nonnull)unique;

@end

// Dictionary utility category
@interface NSDictionary (ExtensionFunctions)

- (NSDictionary * _Nonnull)filterByKeys:(BOOL (^_Nonnull)(id _Nonnull))predicate;
- (NSDictionary * _Nonnull)filterByValues:(BOOL (^_Nonnull)(id _Nonnull))predicate;
- (id _Nullable)getOrDefaultForKey:(id _Nonnull)key defaultValue:(id _Nonnull)defaultValue;
- (NSDictionary * _Nonnull)swap;

@end

// Custom data classes
@interface Person : NSObject

@property (nonatomic, strong, nonnull) NSString *userId;
@property (nonatomic, strong, nonnull) NSString *name;
@property (nonatomic, strong, nonnull) NSString *email;
@property (nonatomic, assign) NSInteger age;

- (instancetype _Nonnull)initWithId:(NSString * _Nonnull)userId
                               name:(NSString * _Nonnull)name
                              email:(NSString * _Nonnull)email
                                age:(NSInteger)age;

@end

// Person utility category (equivalent to Kotlin's Person extensions)
@interface Person (ExtensionFunctions)

- (BOOL)isAdult;
- (BOOL)isMinor;
- (NSString * _Nonnull)ageGroup;
- (NSString * _Nonnull)emailDomain;
- (NSString * _Nonnull)initials;
- (NSString * _Nonnull)displayName;

@end

@interface Product : NSObject

@property (nonatomic, strong, nonnull) NSString *productId;
@property (nonatomic, strong, nonnull) NSString *name;
@property (nonatomic, assign) double price;
@property (nonatomic, strong, nonnull) NSString *category;
@property (nonatomic, assign) BOOL inStock;

- (instancetype _Nonnull)initWithId:(NSString * _Nonnull)productId
                               name:(NSString * _Nonnull)name
                              price:(double)price
                           category:(NSString * _Nonnull)category
                            inStock:(BOOL)inStock;

@end

// Product utility category
@interface Product (ExtensionFunctions)

- (BOOL)isExpensive;
- (BOOL)isCheap;
- (BOOL)isAvailable;
- (NSString * _Nonnull)priceRange;
- (double)discountedPriceWithDiscount:(double)discount;
- (Product * _Nonnull)withDiscount:(double)discount;
- (NSString * _Nonnull)categoryPrefix;

@end

@interface Order : NSObject

@property (nonatomic, strong, nonnull) NSString *orderId;
@property (nonatomic, strong, nonnull) NSArray<Product *> *items;
@property (nonatomic, strong, nonnull) NSString *customerEmail;
@property (nonatomic, assign) long long timestamp;

- (instancetype _Nonnull)initWithId:(NSString * _Nonnull)orderId
                              items:(NSArray<Product *> * _Nonnull)items
                      customerEmail:(NSString * _Nonnull)customerEmail
                          timestamp:(long long)timestamp;

@end

// Order utility category
@interface Order (ExtensionFunctions)

- (double)totalAmount;
- (NSInteger)itemCount;
- (BOOL)hasExpensiveItems;
- (NSDictionary<NSString *, NSNumber *> * _Nonnull)categorySummary;
- (double)averageItemPrice;
- (NSString * _Nonnull)customerDomain;
- (BOOL)isRecent;
- (long long)ageInHours;

@end

@interface BankAccount : NSObject

@property (nonatomic, strong, nonnull) NSString *accountNumber;
@property (nonatomic, assign) double balance;
@property (nonatomic, strong, nonnull) NSString *currency;
@property (nonatomic, strong, nonnull) NSString *type;

- (instancetype _Nonnull)initWithAccountNumber:(NSString * _Nonnull)accountNumber
                                       balance:(double)balance
                                      currency:(NSString * _Nonnull)currency
                                          type:(NSString * _Nonnull)type;

@end

// BankAccount utility category
@interface BankAccount (ExtensionFunctions)

- (BOOL)isOverdrawn;
- (BOOL)hasPositiveBalance;
- (NSString * _Nonnull)balanceFormatted;
- (NSString * _Nonnull)accountType;
- (BOOL)canWithdrawAmount:(double)amount;
- (BankAccount * _Nonnull)withdrawAmount:(double)amount;
- (BankAccount * _Nonnull)depositAmount:(double)amount;

@end

@interface Transaction : NSObject

@property (nonatomic, strong, nonnull) NSString *transactionId;
@property (nonatomic, assign) double amount;
@property (nonatomic, strong, nonnull) NSString *type;
@property (nonatomic, assign) long long timestamp;
@property (nonatomic, strong, nonnull) NSString *transactionDescription;

- (instancetype _Nonnull)initWithId:(NSString * _Nonnull)transactionId
                             amount:(double)amount
                               type:(NSString * _Nonnull)type
                          timestamp:(long long)timestamp
                        description:(NSString * _Nonnull)description;

@end

// Transaction utility category
@interface Transaction (ExtensionFunctions)

- (BOOL)isDebit;
- (BOOL)isCredit;
- (NSString * _Nonnull)amountFormatted;
- (NSString * _Nonnull)typeCapitalized;
- (BOOL)isToday;
- (long long)daysAgo;
- (NSString * _Nonnull)category;

@end

@interface Player : NSObject

@property (nonatomic, strong, nonnull) NSString *playerId;
@property (nonatomic, strong, nonnull) NSString *name;
@property (nonatomic, assign) NSInteger level;
@property (nonatomic, assign) NSInteger experience;
@property (nonatomic, strong, nonnull) NSArray<NSString *> *achievements;

- (instancetype _Nonnull)initWithId:(NSString * _Nonnull)playerId
                               name:(NSString * _Nonnull)name
                              level:(NSInteger)level
                         experience:(NSInteger)experience
                       achievements:(NSArray<NSString *> * _Nonnull)achievements;

@end

// Player utility category
@interface Player (ExtensionFunctions)

- (BOOL)isMaxLevel;
- (NSInteger)experienceToNextLevel;
- (double)progressToNextLevel;
- (BOOL)hasAchievement:(NSString * _Nonnull)achievement;
- (NSInteger)achievementCount;
- (BOOL)isVeteran;
- (NSString * _Nonnull)displayLevel;
- (NSString * _Nonnull)rankTitle;

@end

// Generic API Response
@interface ApiResponse : NSObject

@property (nonatomic, strong, nullable) id data;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, strong, nonnull) NSString *message;

- (instancetype _Nonnull)initWithData:(id _Nullable)data
                               status:(NSInteger)status
                              message:(NSString * _Nonnull)message;

@end

// ApiResponse utility category
@interface ApiResponse (ExtensionFunctions)

- (BOOL)isSuccess;
- (BOOL)isError;
- (BOOL)isClientError;
- (BOOL)isServerError;
- (BOOL)hasData;

@end

@interface AppConfig : NSObject

@property (nonatomic, strong, nonnull) NSString *apiUrl;
@property (nonatomic, assign) long long timeout;
@property (nonatomic, assign) NSInteger retries;
@property (nonatomic, assign) BOOL debug;

- (instancetype _Nonnull)initWithApiUrl:(NSString * _Nonnull)apiUrl
                                timeout:(long long)timeout
                                retries:(NSInteger)retries
                                  debug:(BOOL)debug;

@end

// AppConfig utility category
@interface AppConfig (ExtensionFunctions)

- (BOOL)isProduction;
- (BOOL)isDevelopment;
- (long long)timeoutInSeconds;
- (BOOL)hasRetries;
- (NSInteger)maxRetries;

@end

// Main benchmark class
@interface IosSizeBenchmark : NSObject

- (void)runBenchmark;

@end

// Implementation section

@implementation NSString (ExtensionFunctions)

- (BOOL)isValidEmail {
    return [self containsString:@"@"] && [self containsString:@"."] && self.length > 5;
}

- (BOOL)isValidPhone {
    NSString *cleaned = [self stringByReplacingOccurrencesOfString:@"[^0-9]" 
                                                        withString:@""
                                                           options:NSRegularExpressionSearch
                                                             range:NSMakeRange(0, self.length)];
    return cleaned.length >= 10 && cleaned.length <= 15;
}

- (NSString *)toTitleCase {
    NSArray *words = [self componentsSeparatedByString:@" "];
    NSMutableArray *titleWords = [[NSMutableArray alloc] init];
    
    for (NSString *word in words) {
        if (word.length > 0) {
            NSString *titleWord = [word capitalizedString];
            [titleWords addObject:titleWord];
        }
    }
    
    return [titleWords componentsJoinedByString:@" "];
}

- (NSString *)toCamelCase {
    NSCharacterSet *separators = [NSCharacterSet characterSetWithCharactersInString:@" _-"];
    NSArray *components = [self componentsSeparatedByCharactersInSet:separators];
    NSMutableArray *filteredComponents = [[NSMutableArray alloc] init];
    
    for (NSString *component in components) {
        if (component.length > 0) {
            [filteredComponents addObject:component];
        }
    }
    
    if (filteredComponents.count == 0) return @"";
    
    NSMutableString *result = [[NSMutableString alloc] init];
    [result appendString:[[filteredComponents firstObject] lowercaseString]];
    
    for (NSInteger i = 1; i < filteredComponents.count; i++) {
        NSString *component = filteredComponents[i];
        [result appendString:[component capitalizedString]];
    }
    
    return [result copy];
}

- (NSString *)toSnakeCase {
    NSMutableString *result = [[NSMutableString alloc] initWithString:self];
    
    // Handle camelCase to snake_case conversion
    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"([a-z])([A-Z])"
                                                                           options:0
                                                                             error:&error];
    
    if (regex) {
        [regex replaceMatchesInString:result
                              options:0
                                range:NSMakeRange(0, result.length)
                         withTemplate:@"$1_$2"];
    }
    
    // Replace spaces and hyphens with underscores
    [result replaceOccurrencesOfString:@" " withString:@"_" options:0 range:NSMakeRange(0, result.length)];
    [result replaceOccurrencesOfString:@"-" withString:@"_" options:0 range:NSMakeRange(0, result.length)];
    
    return [[result copy] lowercaseString];
}

- (NSString *)truncateWithMaxLength:(NSInteger)maxLength suffix:(NSString *)suffix {
    if (self.length <= maxLength) return self;
    
    NSString *safeSuffix = suffix ?: @"...";
    NSInteger truncateLength = maxLength - safeSuffix.length;
    
    if (truncateLength < 0) return safeSuffix;
    
    return [[self substringToIndex:truncateLength] stringByAppendingString:safeSuffix];
}

- (NSString *)removeWhitespace {
    return [self stringByReplacingOccurrencesOfString:@"\\s"
                                           withString:@""
                                              options:NSRegularExpressionSearch
                                                range:NSMakeRange(0, self.length)];
}

- (NSInteger)countWords {
    NSString *trimmed = [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (trimmed.length == 0) return 0;
    
    NSArray *words = [trimmed componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSInteger count = 0;
    
    for (NSString *word in words) {
        if (word.length > 0) count++;
    }
    
    return count;
}

- (NSString *)reverse {
    NSMutableString *reversedString = [[NSMutableString alloc] init];
    for (NSInteger i = self.length - 1; i >= 0; i--) {
        [reversedString appendString:[NSString stringWithFormat:@"%C", [self characterAtIndex:i]]];
    }
    return [reversedString copy];
}

- (BOOL)isPalindrome {
    NSString *cleaned = [[self removeWhitespace] lowercaseString];
    return [cleaned isEqualToString:[cleaned reverse]];
}

- (NSArray<NSNumber *> *)extractNumbers {
    NSMutableArray *numbers = [[NSMutableArray alloc] init];
    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"\\d+"
                                                                           options:0
                                                                             error:&error];
    
    if (regex) {
        NSArray *matches = [regex matchesInString:self options:0 range:NSMakeRange(0, self.length)];
        for (NSTextCheckingResult *match in matches) {
            NSString *numberString = [self substringWithRange:match.range];
            NSNumber *number = @([numberString integerValue]);
            [numbers addObject:number];
        }
    }
    
    return [numbers copy];
}

- (NSArray<NSString *> *)extractEmails {
    NSMutableArray *emails = [[NSMutableArray alloc] init];
    NSError *error = nil;
    NSString *pattern = @"[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}";
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern
                                                                           options:0
                                                                             error:&error];
    
    if (regex) {
        NSArray *matches = [regex matchesInString:self options:0 range:NSMakeRange(0, self.length)];
        for (NSTextCheckingResult *match in matches) {
            NSString *email = [self substringWithRange:match.range];
            [emails addObject:email];
        }
    }
    
    return [emails copy];
}

- (NSString *)maskEmail {
    if (![self isValidEmail]) return self;
    
    NSArray *parts = [self componentsSeparatedByString:@"@"];
    if (parts.count != 2) return self;
    
    NSString *username = parts[0];
    NSString *domain = parts[1];
    
    NSString *maskedUsername;
    if (username.length <= 2) {
        maskedUsername = @"**";
    } else {
        NSString *prefix = [username substringToIndex:2];
        NSString *mask = [@"" stringByPaddingToLength:username.length - 2
                                           withString:@"*"
                                      startingAtIndex:0];
        maskedUsername = [prefix stringByAppendingString:mask];
    }
    
    return [NSString stringWithFormat:@"%@@%@", maskedUsername, domain];
}

- (NSString *)emailDomain {
    if (![self isValidEmail]) return @"";
    
    NSArray *parts = [self componentsSeparatedByString:@"@"];
    return parts.count > 1 ? parts[1] : @"";
}

- (NSDictionary<NSString *, NSNumber *> *)wordFrequency {
    NSCharacterSet *nonAlphanumeric = [[NSCharacterSet alphanumericCharacterSet] invertedSet];
    NSArray *words = [[self lowercaseString] componentsSeparatedByCharactersInSet:nonAlphanumeric];
    
    NSMutableDictionary *frequency = [[NSMutableDictionary alloc] init];
    
    for (NSString *word in words) {
        if (word.length > 0) {
            NSNumber *count = frequency[word] ?: @0;
            frequency[word] = @(count.integerValue + 1);
        }
    }
    
    return [frequency copy];
}

- (NSString *)fileExtension {
    return [self pathExtension];
}

- (NSString *)fileName {
    return [self lastPathComponent];
}

- (NSString *)filePath {
    return [self stringByDeletingLastPathComponent];
}

- (BOOL)isImageFile {
    NSArray *imageExtensions = @[@"jpg", @"jpeg", @"png", @"gif", @"bmp"];
    return [imageExtensions containsObject:[[self fileExtension] lowercaseString]];
}

- (BOOL)isTextFile {
    NSArray *textExtensions = @[@"txt", @"md", @"doc", @"docx"];
    return [textExtensions containsObject:[[self fileExtension] lowercaseString]];
}

- (BOOL)isExecutable {
    NSArray *executableExtensions = @[@"exe", @"app", @"deb", @"dmg"];
    return [executableExtensions containsObject:[[self fileExtension] lowercaseString]];
}

- (BOOL)isValidUrl {
    return [self hasPrefix:@"http://"] || [self hasPrefix:@"https://"];
}

- (NSString *)domain {
    if (![self isValidUrl]) return @"";
    
    NSString *withoutProtocol = [self stringByReplacingOccurrencesOfString:@"https://" withString:@""];
    withoutProtocol = [withoutProtocol stringByReplacingOccurrencesOfString:@"http://" withString:@""];
    
    NSArray *components = [withoutProtocol componentsSeparatedByString:@"/"];
    return components.count > 0 ? components[0] : @"";
}

- (NSString *)protocol {
    if ([self hasPrefix:@"https://"]) return @"HTTPS";
    if ([self hasPrefix:@"http://"]) return @"HTTP";
    return @"Unknown";
}

- (BOOL)isSecureUrl {
    return [self hasPrefix:@"https://"];
}

- (BOOL)isNumeric {
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    return [formatter numberFromString:self] != nil;
}

- (BOOL)isAlphabetic {
    NSCharacterSet *letters = [NSCharacterSet letterCharacterSet];
    for (NSInteger i = 0; i < self.length; i++) {
        if (![letters characterIsMember:[self characterAtIndex:i]]) {
            return NO;
        }
    }
    return YES;
}

- (BOOL)isAlphanumeric {
    NSCharacterSet *alphanumeric = [NSCharacterSet alphanumericCharacterSet];
    for (NSInteger i = 0; i < self.length; i++) {
        if (![alphanumeric characterIsMember:[self characterAtIndex:i]]) {
            return NO;
        }
    }
    return YES;
}

- (BOOL)hasUppercase {
    return [self rangeOfCharacterFromSet:[NSCharacterSet uppercaseLetterCharacterSet]].location != NSNotFound;
}

- (BOOL)hasLowercase {
    return [self rangeOfCharacterFromSet:[NSCharacterSet lowercaseLetterCharacterSet]].location != NSNotFound;
}

- (BOOL)hasDigits {
    return [self rangeOfCharacterFromSet:[NSCharacterSet decimalDigitCharacterSet]].location != NSNotFound;
}

- (BOOL)hasSpecialChars {
    NSCharacterSet *alphanumeric = [NSCharacterSet alphanumericCharacterSet];
    return [self rangeOfCharacterFromSet:[alphanumeric invertedSet]].location != NSNotFound;
}

- (BOOL)isStrongPassword {
    return self.length >= 8 && [self hasUppercase] && [self hasLowercase] && [self hasDigits] && [self hasSpecialChars];
}

@end

@implementation NSNumber (ExtensionFunctions)

- (BOOL)isEven {
    return self.integerValue % 2 == 0;
}

- (BOOL)isOdd {
    return self.integerValue % 2 != 0;
}

- (BOOL)isPrime {
    NSInteger n = self.integerValue;
    if (n < 2) return NO;
    
    for (NSInteger i = 2; i * i <= n; i++) {
        if (n % i == 0) return NO;
    }
    return YES;
}

- (NSNumber *)factorial {
    long long n = self.longLongValue;
    if (n <= 1) return @1;
    
    long long result = 1;
    for (long long i = 2; i <= n; i++) {
        result *= i;
    }
    return @(result);
}

- (NSString *)toRoman {
    NSInteger num = self.integerValue;
    NSArray *values = @[@1000, @900, @500, @400, @100, @90, @50, @40, @10, @9, @5, @4, @1];
    NSArray *symbols = @[@"M", @"CM", @"D", @"CD", @"C", @"XC", @"L", @"XL", @"X", @"IX", @"V", @"IV", @"I"];
    
    NSMutableString *result = [[NSMutableString alloc] init];
    
    for (NSInteger i = 0; i < values.count; i++) {
        NSInteger value = [values[i] integerValue];
        NSString *symbol = symbols[i];
        
        while (num >= value) {
            [result appendString:symbol];
            num -= value;
        }
    }
    
    return [result copy];
}

- (NSString *)formatCurrencyWithCurrency:(NSString *)currency {
    NSString *safeCurrency = currency ?: @"USD";
    return [NSString stringWithFormat:@"%.2f %@", self.doubleValue, safeCurrency];
}

- (NSString *)toPercentage {
    return [NSString stringWithFormat:@"%.1f%%", self.doubleValue * 100];
}

- (NSNumber *)roundToDecimals:(NSInteger)decimals {
    double factor = pow(10.0, decimals);
    return @(round(self.doubleValue * factor) / factor);
}

- (NSString *)toDateString {
    long long milliseconds = self.longLongValue;
    long long seconds = milliseconds / 1000;
    long long minutes = seconds / 60;
    long long hours = minutes / 60;
    long long days = hours / 24;
    
    if (days > 0) {
        return [NSString stringWithFormat:@"%lld days ago", days];
    } else if (hours > 0) {
        return [NSString stringWithFormat:@"%lld hours ago", hours];
    } else if (minutes > 0) {
        return [NSString stringWithFormat:@"%lld minutes ago", minutes];
    } else {
        return [NSString stringWithFormat:@"%lld seconds ago", seconds];
    }
}

- (NSString *)formatDuration {
    long long milliseconds = self.longLongValue;
    long long hours = milliseconds / 3600000;
    long long minutes = (milliseconds % 3600000) / 60000;
    long long seconds = (milliseconds % 60000) / 1000;
    
    if (hours > 0) {
        return [NSString stringWithFormat:@"%lld:%02lld:%02lld", hours, minutes, seconds];
    } else if (minutes > 0) {
        return [NSString stringWithFormat:@"%lld:%02lld", minutes, seconds];
    } else {
        return [NSString stringWithFormat:@"%lld seconds", seconds];
    }
}

@end

@implementation NSArray (ExtensionFunctions)

- (id)second {
    return self.count >= 2 ? self[1] : nil;
}

- (id)third {
    return self.count >= 3 ? self[2] : nil;
}

- (id)secondToLast {
    return self.count >= 2 ? self[self.count - 2] : nil;
}

- (NSArray *)takeRandom:(NSInteger)count {
    NSMutableArray *shuffled = [self mutableCopy];
    
    // Fisher-Yates shuffle
    for (NSInteger i = shuffled.count - 1; i > 0; i--) {
        NSInteger j = arc4random_uniform((uint32_t)(i + 1));
        [shuffled exchangeObjectAtIndex:i withObjectAtIndex:j];
    }
    
    NSInteger takeCount = MIN(count, shuffled.count);
    return [shuffled subarrayWithRange:NSMakeRange(0, takeCount)];
}

- (NSArray *)splitWithPredicate:(BOOL (^)(id))predicate {
    NSMutableArray *first = [[NSMutableArray alloc] init];
    NSMutableArray *second = [[NSMutableArray alloc] init];
    
    for (id element in self) {
        if (predicate(element)) {
            [first addObject:element];
        } else {
            [second addObject:element];
        }
    }
    
    return @[first, second];
}

- (NSArray<NSArray *> *)chunksWithSize:(NSInteger)size {
    NSMutableArray *result = [[NSMutableArray alloc] init];
    NSMutableArray *currentChunk = [[NSMutableArray alloc] init];
    
    for (id element in self) {
        [currentChunk addObject:element];
        if (currentChunk.count == size) {
            [result addObject:[currentChunk copy]];
            [currentChunk removeAllObjects];
        }
    }
    
    if (currentChunk.count > 0) {
        [result addObject:[currentChunk copy]];
    }
    
    return [result copy];
}

- (NSArray *)rotateLeft:(NSInteger)positions {
    if (self.count == 0) return self;
    NSInteger pos = positions % self.count;
    
    NSArray *left = [self subarrayWithRange:NSMakeRange(pos, self.count - pos)];
    NSArray *right = [self subarrayWithRange:NSMakeRange(0, pos)];
    
    return [left arrayByAddingObjectsFromArray:right];
}

- (NSArray *)rotateRight:(NSInteger)positions {
    if (self.count == 0) return self;
    NSInteger pos = positions % self.count;
    
    NSArray *right = [self subarrayWithRange:NSMakeRange(self.count - pos, pos)];
    NSArray *left = [self subarrayWithRange:NSMakeRange(0, self.count - pos)];
    
    return [right arrayByAddingObjectsFromArray:left];
}

- (NSDictionary *)frequencyMap {
    NSMutableDictionary *frequency = [[NSMutableDictionary alloc] init];
    
    for (id element in self) {
        NSNumber *count = frequency[element] ?: @0;
        frequency[element] = @(count.integerValue + 1);
    }
    
    return [frequency copy];
}

- (NSArray *)duplicates {
    NSDictionary *frequency = [self frequencyMap];
    NSMutableArray *duplicates = [[NSMutableArray alloc] init];
    
    for (id key in frequency) {
        if ([frequency[key] integerValue] > 1) {
            [duplicates addObject:key];
        }
    }
    
    return [duplicates copy];
}

- (NSArray *)unique {
    return [[NSSet setWithArray:self] allObjects];
}

@end

@implementation NSDictionary (ExtensionFunctions)

- (NSDictionary *)filterByKeys:(BOOL (^)(id))predicate {
    NSMutableDictionary *result = [[NSMutableDictionary alloc] init];
    
    for (id key in self) {
        if (predicate(key)) {
            result[key] = self[key];
        }
    }
    
    return [result copy];
}

- (NSDictionary *)filterByValues:(BOOL (^)(id))predicate {
    NSMutableDictionary *result = [[NSMutableDictionary alloc] init];
    
    for (id key in self) {
        if (predicate(self[key])) {
            result[key] = self[key];
        }
    }
    
    return [result copy];
}

- (id)getOrDefaultForKey:(id)key defaultValue:(id)defaultValue {
    return self[key] ?: defaultValue;
}

- (NSDictionary *)swap {
    NSMutableDictionary *result = [[NSMutableDictionary alloc] init];
    
    for (id key in self) {
        id value = self[key];
        result[value] = key;
    }
    
    return [result copy];
}

@end

// Data class implementations

@implementation Person

- (instancetype)initWithId:(NSString *)userId name:(NSString *)name email:(NSString *)email age:(NSInteger)age {
    self = [super init];
    if (self) {
        _userId = userId;
        _name = name;
        _email = email;
        _age = age;
    }
    return self;
}

@end

@implementation Person (ExtensionFunctions)

- (BOOL)isAdult {
    return self.age >= 18;
}

- (BOOL)isMinor {
    return self.age < 18;
}

- (NSString *)ageGroup {
    if (self.age < 13) return @"Child";
    if (self.age < 20) return @"Teenager";
    if (self.age < 30) return @"Young Adult";
    if (self.age < 60) return @"Adult";
    return @"Senior";
}

- (NSString *)emailDomain {
    NSArray *parts = [self.email componentsSeparatedByString:@"@"];
    return parts.count > 1 ? parts[1] : @"";
}

- (NSString *)initials {
    NSArray *nameComponents = [self.name componentsSeparatedByString:@" "];
    NSMutableString *initials = [[NSMutableString alloc] init];
    
    for (NSString *component in nameComponents) {
        if (component.length > 0) {
            [initials appendString:[component substringToIndex:1]];
        }
    }
    
    return [initials copy];
}

- (NSString *)displayName {
    return [NSString stringWithFormat:@"%@ (%ld)", self.name, (long)self.age];
}

@end

@implementation Product

- (instancetype)initWithId:(NSString *)productId name:(NSString *)name price:(double)price category:(NSString *)category inStock:(BOOL)inStock {
    self = [super init];
    if (self) {
        _productId = productId;
        _name = name;
        _price = price;
        _category = category;
        _inStock = inStock;
    }
    return self;
}

@end

@implementation Product (ExtensionFunctions)

- (BOOL)isExpensive {
    return self.price > 100.0;
}

- (BOOL)isCheap {
    return self.price < 20.0;
}

- (BOOL)isAvailable {
    return self.inStock;
}

- (NSString *)priceRange {
    if (self.price < 20) return @"Budget";
    if (self.price < 50) return @"Mid-range";
    if (self.price < 100) return @"Premium";
    return @"Luxury";
}

- (double)discountedPriceWithDiscount:(double)discount {
    return self.price * (1 - discount);
}

- (Product *)withDiscount:(double)discount {
    return [[Product alloc] initWithId:self.productId
                                  name:self.name
                                 price:[self discountedPriceWithDiscount:discount]
                              category:self.category
                               inStock:self.inStock];
}

- (NSString *)categoryPrefix {
    return [[self.category substringToIndex:MIN(3, self.category.length)] uppercaseString];
}

@end

@implementation Order

- (instancetype)initWithId:(NSString *)orderId items:(NSArray<Product *> *)items customerEmail:(NSString *)customerEmail timestamp:(long long)timestamp {
    self = [super init];
    if (self) {
        _orderId = orderId;
        _items = items;
        _customerEmail = customerEmail;
        _timestamp = timestamp;
    }
    return self;
}

@end

@implementation Order (ExtensionFunctions)

- (double)totalAmount {
    double total = 0;
    for (Product *item in self.items) {
        total += item.price;
    }
    return total;
}

- (NSInteger)itemCount {
    return self.items.count;
}

- (BOOL)hasExpensiveItems {
    for (Product *item in self.items) {
        if ([item isExpensive]) {
            return YES;
        }
    }
    return NO;
}

- (NSDictionary<NSString *, NSNumber *> *)categorySummary {
    NSMutableDictionary *summary = [[NSMutableDictionary alloc] init];
    
    for (Product *item in self.items) {
        NSNumber *count = summary[item.category] ?: @0;
        summary[item.category] = @(count.integerValue + 1);
    }
    
    return [summary copy];
}

- (double)averageItemPrice {
    return self.items.count > 0 ? [self totalAmount] / self.items.count : 0.0;
}

- (NSString *)customerDomain {
    return [self.customerEmail emailDomain];
}

- (BOOL)isRecent {
    long long now = (long long)([[NSDate date] timeIntervalSince1970] * 1000);
    return (now - self.timestamp) < 86400000; // 24 hours
}

- (long long)ageInHours {
    long long now = (long long)([[NSDate date] timeIntervalSince1970] * 1000);
    return (now - self.timestamp) / 3600000;
}

@end

@implementation BankAccount

- (instancetype)initWithAccountNumber:(NSString *)accountNumber balance:(double)balance currency:(NSString *)currency type:(NSString *)type {
    self = [super init];
    if (self) {
        _accountNumber = accountNumber;
        _balance = balance;
        _currency = currency;
        _type = type;
    }
    return self;
}

@end

@implementation BankAccount (ExtensionFunctions)

- (BOOL)isOverdrawn {
    return self.balance < 0;
}

- (BOOL)hasPositiveBalance {
    return self.balance > 0;
}

- (NSString *)balanceFormatted {
    return [@(self.balance) formatCurrencyWithCurrency:self.currency];
}

- (NSString *)accountType {
    return [self.type capitalizedString];
}

- (BOOL)canWithdrawAmount:(double)amount {
    return self.balance >= amount;
}

- (BankAccount *)withdrawAmount:(double)amount {
    return [[BankAccount alloc] initWithAccountNumber:self.accountNumber
                                              balance:self.balance - amount
                                             currency:self.currency
                                                 type:self.type];
}

- (BankAccount *)depositAmount:(double)amount {
    return [[BankAccount alloc] initWithAccountNumber:self.accountNumber
                                              balance:self.balance + amount
                                             currency:self.currency
                                                 type:self.type];
}

@end

@implementation Transaction

- (instancetype)initWithId:(NSString *)transactionId amount:(double)amount type:(NSString *)type timestamp:(long long)timestamp description:(NSString *)description {
    self = [super init];
    if (self) {
        _transactionId = transactionId;
        _amount = amount;
        _type = type;
        _timestamp = timestamp;
        _transactionDescription = description;
    }
    return self;
}

@end

@implementation Transaction (ExtensionFunctions)

- (BOOL)isDebit {
    return self.amount < 0;
}

- (BOOL)isCredit {
    return self.amount > 0;
}

- (NSString *)amountFormatted {
    return [@(self.amount) formatCurrencyWithCurrency:@"USD"];
}

- (NSString *)typeCapitalized {
    return [self.type capitalizedString];
}

- (BOOL)isToday {
    long long now = (long long)([[NSDate date] timeIntervalSince1970] * 1000);
    return (now - self.timestamp) < 86400000;
}

- (long long)daysAgo {
    long long now = (long long)([[NSDate date] timeIntervalSince1970] * 1000);
    return (now - self.timestamp) / 86400000;
}

- (NSString *)category {
    NSString *desc = [self.transactionDescription lowercaseString];
    if ([desc containsString:@"grocery"]) return @"Groceries";
    if ([desc containsString:@"gas"]) return @"Transportation";
    if ([desc containsString:@"restaurant"]) return @"Dining";
    if ([desc containsString:@"salary"]) return @"Income";
    return @"Other";
}

@end

@implementation Player

- (instancetype)initWithId:(NSString *)playerId name:(NSString *)name level:(NSInteger)level experience:(NSInteger)experience achievements:(NSArray<NSString *> *)achievements {
    self = [super init];
    if (self) {
        _playerId = playerId;
        _name = name;
        _level = level;
        _experience = experience;
        _achievements = achievements;
    }
    return self;
}

@end

@implementation Player (ExtensionFunctions)

- (BOOL)isMaxLevel {
    return self.level >= 100;
}

- (NSInteger)experienceToNextLevel {
    return (self.level + 1) * 1000 - self.experience;
}

- (double)progressToNextLevel {
    return (double)self.experience / ((self.level + 1) * 1000);
}

- (BOOL)hasAchievement:(NSString *)achievement {
    return [self.achievements containsObject:achievement];
}

- (NSInteger)achievementCount {
    return self.achievements.count;
}

- (BOOL)isVeteran {
    return [self hasAchievement:@"veteran"];
}

- (NSString *)displayLevel {
    return [NSString stringWithFormat:@"Level %ld", (long)self.level];
}

- (NSString *)rankTitle {
    if (self.level < 10) return @"Novice";
    if (self.level < 25) return @"Apprentice";
    if (self.level < 50) return @"Expert";
    if (self.level < 75) return @"Master";
    return @"Grandmaster";
}

@end

@implementation ApiResponse

- (instancetype)initWithData:(id)data status:(NSInteger)status message:(NSString *)message {
    self = [super init];
    if (self) {
        _data = data;
        _status = status;
        _message = message;
    }
    return self;
}

@end

@implementation ApiResponse (ExtensionFunctions)

- (BOOL)isSuccess {
    return self.status >= 200 && self.status < 300;
}

- (BOOL)isError {
    return self.status >= 400;
}

- (BOOL)isClientError {
    return self.status >= 400 && self.status < 500;
}

- (BOOL)isServerError {
    return self.status >= 500;
}

- (BOOL)hasData {
    return self.data != nil;
}

@end

@implementation AppConfig

- (instancetype)initWithApiUrl:(NSString *)apiUrl timeout:(long long)timeout retries:(NSInteger)retries debug:(BOOL)debug {
    self = [super init];
    if (self) {
        _apiUrl = apiUrl;
        _timeout = timeout;
        _retries = retries;
        _debug = debug;
    }
    return self;
}

@end

@implementation AppConfig (ExtensionFunctions)

- (BOOL)isProduction {
    return !self.debug;
}

- (BOOL)isDevelopment {
    return self.debug;
}

- (long long)timeoutInSeconds {
    return self.timeout / 1000;
}

- (BOOL)hasRetries {
    return self.retries > 0;
}

- (NSInteger)maxRetries {
    return MAX(self.retries, 1);
}

@end

@implementation IosSizeBenchmark

- (void)runBenchmark {
    // String extension demonstrations - much more verbose than Kotlin
    NSArray<NSString *> *emails = @[
        @"john.doe@example.com",
        @"invalid-email",
        @"jane.smith@test.org",
        @"not-an-email-at-all",
        @"admin@company.co.uk"
    ];
    
    NSMutableArray *validEmails = [[NSMutableArray alloc] init];
    for (NSString *email in emails) {
        if ([email isValidEmail]) {
            [validEmails addObject:email];
        }
    }
    
    NSMutableArray *maskedEmails = [[NSMutableArray alloc] init];
    for (NSString *email in validEmails) {
        [maskedEmails addObject:[email maskEmail]];
    }
    
    NSArray<NSString *> *phones = @[
        @"+1-555-123-4567",
        @"555.123.4567",
        @"(555) 123-4567",
        @"5551234567",
        @"invalid-phone"
    ];
    
    NSMutableArray *validPhones = [[NSMutableArray alloc] init];
    for (NSString *phone in phones) {
        if ([phone isValidPhone]) {
            [validPhones addObject:phone];
        }
    }
    
    NSArray<NSString *> *texts = @[
        @"hello world programming",
        @"the quick brown fox jumps over the lazy dog",
        @"a man a plan a canal panama",
        @"racecar level madam",
        @"this is a sample text with numbers 123 and 456"
    ];
    
    // Manual processing of each text - much more verbose than Kotlin's elegant extension chains
    for (NSString *text in texts) {
        NSString *titleCase = [text toTitleCase];
        NSString *camelCase = [text toCamelCase];
        NSString *snakeCase = [text toSnakeCase];
        NSString *truncated = [text truncateWithMaxLength:20 suffix:@"..."];
        NSInteger wordCount = [text countWords];
        BOOL isPalindrome = [text isPalindrome];
        NSArray *numbers = [text extractNumbers];
        NSDictionary *frequency = [text wordFrequency];
    }
    
    // Number extension demonstrations
    NSArray<NSNumber *> *numbers = @[@2, @3, @4, @5, @7, @8, @10, @11, @13, @17, @25, @30];
    
    for (NSNumber *num in numbers) {
        BOOL isEven = [num isEven];
        BOOL isOdd = [num isOdd];
        BOOL isPrime = [num isPrime];
        NSNumber *factorial = num.integerValue <= 10 ? [num factorial] : @0;
        NSString *roman = num.integerValue <= 50 ? [num toRoman] : @"";
    }
    
    NSArray<NSNumber *> *prices = @[@19.99, @45.50, @123.75, @999.99, @0.50];
    for (NSNumber *price in prices) {
        NSString *currency = [price formatCurrencyWithCurrency:@"USD"];
        NSString *percentage = [[NSNumber numberWithDouble:price.doubleValue / 1000] toPercentage];
        NSNumber *rounded = [price roundToDecimals:1];
    }
    
    // Collection extension demonstrations - much more complex than Kotlin
    NSArray<NSString *> *wordList = @[@"apple", @"banana", @"cherry", @"date", @"elderberry", @"fig", @"grape"];
    
    NSString *secondItem = [wordList second];
    NSString *thirdItem = [wordList third];
    NSString *secondToLastItem = [wordList secondToLast];
    NSArray *randomItems = [wordList takeRandom:3];
    
    NSArray *splitResult = [wordList splitWithPredicate:^BOOL(NSString *word) {
        return word.length <= 5;
    }];
    NSArray *shortWords = splitResult[0];
    NSArray *longWords = splitResult[1];
    
    NSArray<NSArray<NSString *> *> *chunks = [wordList chunksWithSize:3];
    NSDictionary *frequency = [wordList frequencyMap];
    NSArray *rotatedLeft = [wordList rotateLeft:2];
    NSArray *rotatedRight = [wordList rotateRight:2];
    
    NSArray<NSString *> *duplicateList = @[@"a", @"b", @"c", @"a", @"b", @"d", @"e", @"a"];
    NSArray *duplicates = [duplicateList duplicates];
    NSArray *unique = [duplicateList unique];
    
    // Dictionary extension demonstrations
    NSDictionary<NSString *, NSNumber *> *scoreMap = @{
        @"Alice": @95,
        @"Bob": @87,
        @"Charlie": @92,
        @"David": @78,
        @"Eve": @89
    };
    
    NSDictionary *highScores = [scoreMap filterByValues:^BOOL(NSNumber *score) {
        return score.integerValue > 85;
    }];
    NSDictionary *swappedMap = [scoreMap swap];
    NSNumber *defaultScore = [scoreMap getOrDefaultForKey:@"Unknown" defaultValue:@0];
    
    // Time extension demonstrations
    long long now = (long long)([[NSDate date] timeIntervalSince1970] * 1000);
    NSArray<NSNumber *> *timestamps = @[
        @(now - 3600000),  // 1 hour ago
        @(now - 86400000), // 1 day ago
        @(now - 604800000) // 1 week ago
    ];
    
    for (NSNumber *timestamp in timestamps) {
        NSString *dateString = [timestamp toDateString];
        NSString *duration = [@(now - timestamp.longLongValue) formatDuration];
    }
    
    // Custom data extension demonstrations
    NSArray<Person *> *persons = @[
        [[Person alloc] initWithId:@"1" name:@"John Doe" email:@"john@example.com" age:25],
        [[Person alloc] initWithId:@"2" name:@"Jane Smith" email:@"jane@test.com" age:17],
        [[Person alloc] initWithId:@"3" name:@"Bob Johnson" email:@"bob@company.org" age:45],
        [[Person alloc] initWithId:@"4" name:@"Alice Brown" email:@"alice@email.net" age:35]
    ];
    
    // Manual processing - much more verbose than Kotlin's functional style
    for (Person *person in persons) {
        BOOL isAdult = [person isAdult];
        NSString *ageGroup = [person ageGroup];
        NSString *domain = [person emailDomain];
        NSString *initials = [person initials];
        NSString *displayName = [person displayName];
    }
    
    NSMutableArray *adults = [[NSMutableArray alloc] init];
    NSMutableArray *minors = [[NSMutableArray alloc] init];
    
    for (Person *person in persons) {
        if ([person isAdult]) {
            [adults addObject:person];
        } else {
            [minors addObject:person];
        }
    }
    
    // Group by age group manually - much more complex than Kotlin's groupBy
    NSMutableDictionary<NSString *, NSMutableArray<Person *> *> *ageGroups = [[NSMutableDictionary alloc] init];
    for (Person *person in persons) {
        NSString *ageGroup = [person ageGroup];
        if (!ageGroups[ageGroup]) {
            ageGroups[ageGroup] = [[NSMutableArray alloc] init];
        }
        [ageGroups[ageGroup] addObject:person];
    }
    
    // Product extension demonstrations
    NSArray<Product *> *products = @[
        [[Product alloc] initWithId:@"1" name:@"Laptop" price:899.99 category:@"Electronics" inStock:YES],
        [[Product alloc] initWithId:@"2" name:@"Coffee Mug" price:12.50 category:@"Kitchen" inStock:YES],
        [[Product alloc] initWithId:@"3" name:@"Designer Watch" price:1299.99 category:@"Accessories" inStock:NO],
        [[Product alloc] initWithId:@"4" name:@"Book" price:15.99 category:@"Books" inStock:YES],
        [[Product alloc] initWithId:@"5" name:@"Smartphone" price:699.99 category:@"Electronics" inStock:YES]
    ];
    
    // Manual product processing
    for (Product *product in products) {
        BOOL isExpensive = [product isExpensive];
        NSString *priceRange = [product priceRange];
        Product *discounted = [product withDiscount:0.10];
        NSString *prefix = [product categoryPrefix];
    }
    
    NSMutableArray *availableProducts = [[NSMutableArray alloc] init];
    NSMutableArray *expensiveProducts = [[NSMutableArray alloc] init];
    NSMutableArray *electronicsProducts = [[NSMutableArray alloc] init];
    
    for (Product *product in products) {
        if ([product isAvailable]) {
            [availableProducts addObject:product];
        }
        if ([product isExpensive]) {
            [expensiveProducts addObject:product];
        }
        if ([product.category isEqualToString:@"Electronics"]) {
            [electronicsProducts addObject:product];
        }
    }
    
    // Complex manual text processing - demonstrating the verbosity
    NSMutableArray *processedData = [[NSMutableArray alloc] init];
    
    for (NSString *text in texts) {
        if (text.length > 10) {
            NSString *titleCased = [text toTitleCase];
            NSString *truncated = [titleCased truncateWithMaxLength:30 suffix:@"..."];
            if ([truncated countWords] > 3) {
                NSDictionary *info = @{
                    @"text": truncated,
                    @"wordCount": @([truncated countWords]),
                    @"hasNumbers": @([[truncated extractNumbers] count] > 0),
                    @"frequency": [truncated wordFrequency]
                };
                [processedData addObject:info];
            }
        }
    }
    
    // Manual user analysis - much more complex than Kotlin's functional chains
    NSMutableDictionary *userAnalysis = [[NSMutableDictionary alloc] init];
    
    for (Person *person in adults) {
        NSString *ageGroup = [person ageGroup];
        if (!userAnalysis[ageGroup]) {
            userAnalysis[ageGroup] = [@{
                @"people": [[NSMutableArray alloc] init],
                @"totalAge": @0,
                @"domains": [[NSMutableSet alloc] init]
            } mutableCopy];
        }
        
        NSMutableDictionary *groupData = userAnalysis[ageGroup];
        NSMutableArray *people = groupData[@"people"];
        [people addObject:person];
        
        NSNumber *totalAge = groupData[@"totalAge"];
        groupData[@"totalAge"] = @(totalAge.integerValue + person.age);
        
        NSMutableSet *domains = groupData[@"domains"];
        [domains addObject:[person emailDomain]];
    }
    
    // Calculate averages manually
    for (NSString *ageGroup in userAnalysis) {
        NSMutableDictionary *groupData = userAnalysis[ageGroup];
        NSArray *people = groupData[@"people"];
        NSNumber *totalAge = groupData[@"totalAge"];
        NSSet *domains = groupData[@"domains"];
        
        NSInteger averageAge = people.count > 0 ? totalAge.integerValue / people.count : 0;
        
        NSDictionary *finalData = @{
            @"count": @(people.count),
            @"averageAge": @(averageAge),
            @"domains": [domains allObjects]
        };
        userAnalysis[ageGroup] = [finalData mutableCopy];
    }
    
    // Manual product analysis
    NSMutableDictionary *productAnalysis = [[NSMutableDictionary alloc] init];
    
    for (Product *product in availableProducts) {
        NSString *priceRange = [product priceRange];
        if (!productAnalysis[priceRange]) {
            productAnalysis[priceRange] = [@{
                @"products": [[NSMutableArray alloc] init],
                @"totalPrice": @0.0,
                @"categories": [[NSMutableSet alloc] init]
            } mutableCopy];
        }
        
        NSMutableDictionary *rangeData = productAnalysis[priceRange];
        NSMutableArray *products = rangeData[@"products"];
        [products addObject:product];
        
        NSNumber *totalPrice = rangeData[@"totalPrice"];
        rangeData[@"totalPrice"] = @(totalPrice.doubleValue + product.price);
        
        NSMutableSet *categories = rangeData[@"categories"];
        [categories addObject:product.category];
    }
    
    // Calculate product averages manually
    for (NSString *priceRange in productAnalysis) {
        NSMutableDictionary *rangeData = productAnalysis[priceRange];
        NSArray *products = rangeData[@"products"];
        NSNumber *totalPrice = rangeData[@"totalPrice"];
        NSSet *categories = rangeData[@"categories"];
        
        double averagePrice = products.count > 0 ? totalPrice.doubleValue / products.count : 0.0;
        
        NSDictionary *finalData = @{
            @"count": @(products.count),
            @"averagePrice": @(averagePrice),
            @"categories": [categories allObjects]
        };
        productAnalysis[priceRange] = [finalData mutableCopy];
    }
    
    // File path demonstrations
    NSArray<NSString *> *filePaths = @[
        @"/home/user/documents/report.pdf",
        @"/var/log/system.log",
        @"/usr/bin/application.exe",
        @"/home/photos/vacation.jpg",
        @"/downloads/music.mp3"
    ];
    
    for (NSString *path in filePaths) {
        NSString *extension = [path fileExtension];
        NSString *fileName = [path fileName];
        NSString *directory = [path filePath];
        BOOL isImage = [path isImageFile];
        BOOL isText = [path isTextFile];
        BOOL isExecutable = [path isExecutable];
    }
    
    // URL demonstrations
    NSArray<NSString *> *urls = @[
        @"https://www.example.com/page",
        @"http://api.service.org/data",
        @"https://secure.bank.com/login",
        @"ftp://files.domain.net/download",
        @"invalid-url"
    ];
    
    for (NSString *url in urls) {
        BOOL isValid = [url isValidUrl];
        NSString *domain = [url domain];
        NSString *protocolType = [url protocol];
        BOOL isSecure = [url isSecureUrl];
    }
    
    // Password validation
    NSArray<NSString *> *passwords = @[
        @"Password123!",
        @"weakpass",
        @"ONLYUPPER",
        @"onlylower",
        @"12345678",
        @"Strong1Pass!"
    ];
    
    for (NSString *password in passwords) {
        BOOL isStrong = [password isStrongPassword];
        BOOL hasUpper = [password hasUppercase];
        BOOL hasLower = [password hasLowercase];
        BOOL hasDigits = [password hasDigits];
        BOOL hasSpecial = [password hasSpecialChars];
    }
    
    NSMutableArray *strongPasswords = [[NSMutableArray alloc] init];
    for (NSString *password in passwords) {
        if ([password isStrongPassword]) {
            [strongPasswords addObject:password];
        }
    }
    
    // Gaming demonstrations
    NSArray<Player *> *players = @[
        [[Player alloc] initWithId:@"1" name:@"ProGamer" level:95 experience:94500 achievements:@[@"veteran", @"champion", @"speedrun"]],
        [[Player alloc] initWithId:@"2" name:@"Newbie" level:5 experience:4200 achievements:@[@"first_login"]],
        [[Player alloc] initWithId:@"3" name:@"Expert" level:45 experience:44800 achievements:@[@"veteran", @"collector", @"explorer"]],
        [[Player alloc] initWithId:@"4" name:@"Master" level:78 experience:77100 achievements:@[@"veteran", @"champion", @"mentor"]]
    ];
    
    // Manual player processing
    for (Player *player in players) {
        BOOL isMaxLevel = [player isMaxLevel];
        NSInteger expToNext = [player experienceToNextLevel];
        double progress = [player progressToNextLevel];
        BOOL isVeteran = [player isVeteran];
        NSInteger achievementCount = [player achievementCount];
        NSString *title = [player rankTitle];
    }
    
    NSMutableArray *veterans = [[NSMutableArray alloc] init];
    NSMutableArray *highLevelPlayers = [[NSMutableArray alloc] init];
    
    for (Player *player in players) {
        if ([player isVeteran]) {
            [veterans addObject:player];
        }
        if (player.level > 50) {
            [highLevelPlayers addObject:player];
        }
    }
    
    // This demonstrates how much more verbose Objective-C categories are compared to Kotlin's elegant extension functions
    // Each operation requires manual loops, temporary arrays, and explicit type management
    // Kotlin's extension functions with method chaining provide much cleaner, more readable code
}

@end