/*
 * iOS Size Benchmark - Test Case Implementation
 * Generated with Claude AI (https://claude.ai)
 * 
 * This Objective-C implementation demonstrates language-specific
 * features and patterns for binary size comparison.
 */

#import <Foundation/Foundation.h>

// 最小化代码体积的集合操作测试
// 使用最基本的 C 数组和简单的 Objective-C 集合

@interface MinimalCollectionProcessor : NSObject
- (NSArray<NSNumber *> *)processBasicArrayWithSize:(NSInteger)size;
- (NSArray<NSString *> *)processBasicListWithSize:(NSInteger)size;
- (NSArray<NSString *> *)processBasicStringArrayWithSize:(NSInteger)size;
- (NSDictionary<NSNumber *, NSString *> *)processBasicMapWithSize:(NSInteger)size;
- (NSDictionary<NSNumber *, NSString *> *)processBasicDictionaryWithSize:(NSInteger)size;
- (NSArray<NSNumber *> *)filterEvenNumbers:(NSArray<NSNumber *> *)numbers;
- (NSArray<NSNumber *> *)doubleNumbers:(NSArray<NSNumber *> *)numbers;
- (NSInteger)sumNumbers:(NSArray<NSNumber *> *)numbers;
- (NSInteger)findFirst:(NSArray<NSNumber *> *)numbers target:(NSInteger)target;
- (NSArray<NSNumber *> *)simpleSort:(NSArray<NSNumber *> *)numbers;
@end

@implementation MinimalCollectionProcessor

- (NSArray<NSNumber *> *)processBasicArrayWithSize:(NSInteger)size {
    NSMutableArray<NSNumber *> *array = [[NSMutableArray alloc] initWithCapacity:size];
    
    for (NSInteger i = 0; i < size; i++) {
        [array addObject:@(i * 2)];
    }
    
    for (NSInteger i = 0; i < array.count; i++) {
        array[i] = @([array[i] integerValue] + 1);
    }
    
    return [array copy];
}

- (NSArray<NSString *> *)processBasicListWithSize:(NSInteger)size {
    NSMutableArray<NSString *> *array = [[NSMutableArray alloc] initWithCapacity:size];
    
    for (NSInteger i = 0; i < size; i++) {
        [array addObject:[NSString stringWithFormat:@"Item%ld", (long)i]];
    }
    
    return [array copy];
}

- (NSDictionary<NSNumber *, NSString *> *)processBasicMapWithSize:(NSInteger)size {
    NSMutableDictionary<NSNumber *, NSString *> *dict = [[NSMutableDictionary alloc] initWithCapacity:size];
    
    for (NSInteger i = 0; i < size; i++) {
        dict[@(i)] = [NSString stringWithFormat:@"Value%ld", (long)i];
    }
    
    return [dict copy];
}

- (NSArray<NSNumber *> *)filterEvenNumbers:(NSArray<NSNumber *> *)numbers {
    NSMutableArray<NSNumber *> *result = [[NSMutableArray alloc] init];
    
    for (NSNumber *num in numbers) {
        if ([num integerValue] % 2 == 0) {
            [result addObject:num];
        }
    }
    
    return [result copy];
}

- (NSArray<NSNumber *> *)doubleNumbers:(NSArray<NSNumber *> *)numbers {
    NSMutableArray<NSNumber *> *result = [[NSMutableArray alloc] initWithCapacity:numbers.count];
    
    for (NSNumber *num in numbers) {
        [result addObject:@([num integerValue] * 2)];
    }
    
    return [result copy];
}

- (NSInteger)sumNumbers:(NSArray<NSNumber *> *)numbers {
    NSInteger sum = 0;
    
    for (NSNumber *num in numbers) {
        sum += [num integerValue];
    }
    
    return sum;
}

- (NSInteger)findFirst:(NSArray<NSNumber *> *)numbers target:(NSInteger)target {
    for (NSInteger i = 0; i < numbers.count; i++) {
        if ([numbers[i] integerValue] == target) {
            return i;
        }
    }
    return -1;
}

- (NSArray<NSNumber *> *)simpleSort:(NSArray<NSNumber *> *)numbers {
    NSMutableArray<NSNumber *> *result = [numbers mutableCopy];
    NSInteger n = result.count;
    
    for (NSInteger i = 0; i < n - 1; i++) {
        for (NSInteger j = 0; j < n - i - 1; j++) {
            if ([result[j] integerValue] > [result[j + 1] integerValue]) {
                NSNumber *temp = result[j];
                result[j] = result[j + 1];
                result[j + 1] = temp;
            }
        }
    }
    
    return [result copy];
}

@end

// 最小化的数据结构
@interface SimpleUser : NSObject
@property (nonatomic, assign) NSInteger userId;
@property (nonatomic, strong) NSString *name;
- (instancetype)initWithId:(NSInteger)userId name:(NSString *)name;
@end

@implementation SimpleUser
- (instancetype)initWithId:(NSInteger)userId name:(NSString *)name {
    self = [super init];
    if (self) {
        _userId = userId;
        _name = name;
    }
    return self;
}
@end

@interface SimpleProduct : NSObject
@property (nonatomic, assign) NSInteger productId;
@property (nonatomic, assign) double price;
- (instancetype)initWithId:(NSInteger)productId price:(double)price;
@end

@implementation SimpleProduct
- (instancetype)initWithId:(NSInteger)productId price:(double)price {
    self = [super init];
    if (self) {
        _productId = productId;
        _price = price;
    }
    return self;
}
@end

@interface MinimalDataProcessor : NSObject
- (NSArray<SimpleUser *> *)createUsersWithCount:(NSInteger)count;
- (NSArray<SimpleProduct *> *)createProductsWithCount:(NSInteger)count;
- (NSString *)processUserData:(NSArray<SimpleUser *> *)users;
- (double)calculateTotal:(NSArray<SimpleProduct *> *)products;
@end

@implementation MinimalDataProcessor

- (NSArray<SimpleUser *> *)createUsersWithCount:(NSInteger)count {
    NSMutableArray<SimpleUser *> *users = [[NSMutableArray alloc] initWithCapacity:count];
    
    for (NSInteger i = 0; i < count; i++) {
        SimpleUser *user = [[SimpleUser alloc] initWithId:i name:[NSString stringWithFormat:@"User%ld", (long)i]];
        [users addObject:user];
    }
    
    return [users copy];
}

- (NSArray<SimpleProduct *> *)createProductsWithCount:(NSInteger)count {
    NSMutableArray<SimpleProduct *> *products = [[NSMutableArray alloc] initWithCapacity:count];
    
    for (NSInteger i = 0; i < count; i++) {
        SimpleProduct *product = [[SimpleProduct alloc] initWithId:i price:10.0 + i];
        [products addObject:product];
    }
    
    return [products copy];
}

- (NSString *)processUserData:(NSArray<SimpleUser *> *)users {
    NSMutableString *result = [[NSMutableString alloc] init];
    
    for (SimpleUser *user in users) {
        [result appendFormat:@"%ld:%@;", (long)user.userId, user.name];
    }
    
    return [result copy];
}

- (double)calculateTotal:(NSArray<SimpleProduct *> *)products {
    double total = 0.0;
    
    for (SimpleProduct *product in products) {
        total += product.price;
    }
    
    return total;
}

@end

@interface MinimalBenchmark : NSObject
- (void)runMinimalTest;
@end

@implementation MinimalBenchmark {
    MinimalCollectionProcessor *_collectionProcessor;
    MinimalDataProcessor *_dataProcessor;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _collectionProcessor = [[MinimalCollectionProcessor alloc] init];
        _dataProcessor = [[MinimalDataProcessor alloc] init];
    }
    return self;
}

- (void)runMinimalTest {
    NSLog(@"Running minimal collection benchmark...");
    
    // 测试基础数组操作
    NSArray<NSNumber *> *array = [_collectionProcessor processBasicArrayWithSize:100];
    NSArray<NSNumber *> *doubled = [_collectionProcessor doubleNumbers:array];
    NSArray<NSNumber *> *filtered = [_collectionProcessor filterEvenNumbers:doubled];
    NSArray<NSNumber *> *sorted = [_collectionProcessor simpleSort:filtered];
    NSInteger sum = [_collectionProcessor sumNumbers:sorted];
    NSInteger index = [_collectionProcessor findFirst:sorted target:50];
    
    // 测试基础集合操作
    NSArray<NSString *> *stringArray = [_collectionProcessor processBasicStringArrayWithSize:50];
    NSDictionary<NSNumber *, NSString *> *dictionary = [_collectionProcessor processBasicDictionaryWithSize:50];
    
    // 测试简单数据处理
    NSArray<SimpleUser *> *users = [_dataProcessor createUsersWithCount:20];
    NSArray<SimpleProduct *> *products = [_dataProcessor createProductsWithCount:20];
    NSString *userData = [_dataProcessor processUserData:users];
    double total = [_dataProcessor calculateTotal:products];
    
    NSLog(@"Minimal benchmark completed:");
    NSLog(@"- Array size: %ld", (long)array.count);
    NSLog(@"- Doubled size: %ld", (long)doubled.count);
    NSLog(@"- Filtered size: %ld", (long)filtered.count);
    NSLog(@"- Sorted size: %ld", (long)sorted.count);
    NSLog(@"- Sum: %ld", (long)sum);
    NSLog(@"- Found index: %ld", (long)index);
    NSLog(@"- String array size: %ld", (long)stringArray.count);
    NSLog(@"- Dictionary size: %ld", (long)dictionary.count);
    NSLog(@"- Users: %ld", (long)users.count);
    NSLog(@"- Products: %ld", (long)products.count);
    NSLog(@"- User data length: %ld", (long)userData.length);
    NSLog(@"- Total price: %.2f", total);
}

@end

@interface IosSizeBenchmark : NSObject
@property (nonatomic, strong) MinimalBenchmark *benchmark;
- (void)runBenchmark;
@end

@implementation IosSizeBenchmark

- (instancetype)init {
    self = [super init];
    if (self) {
        _benchmark = [[MinimalBenchmark alloc] init];
    }
    return self;
}

- (void)runBenchmark {
    [self.benchmark runMinimalTest];
}

@end