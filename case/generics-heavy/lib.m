/*
 * iOS Size Benchmark - Test Case Implementation
 * Generated with Claude AI (https://claude.ai)
 * 
 * This Objective-C implementation demonstrates language-specific
 * features and patterns for binary size comparison.
 */

#import <Foundation/Foundation.h>

// Test case: Generics Heavy - Tests impact of extensive generic usage on code size
// Note: Objective-C doesn't have true generics, but we simulate with id types and protocols

// Generic-like container using id types
@interface Container : NSObject
@property (nonatomic, strong) id value;
- (instancetype)initWithValue:(id)value;
- (id)getValue;
- (Container *)mapWithTransform:(id (^)(id))transform;
- (Container *)flatMapWithTransform:(Container * (^)(id))transform;
@end

@implementation Container
- (instancetype)initWithValue:(id)value {
    self = [super init];
    if (self) {
        _value = value;
    }
    return self;
}
- (id)getValue { return self.value; }
- (Container *)mapWithTransform:(id (^)(id))transform {
    return [[Container alloc] initWithValue:transform(self.value)];
}
- (Container *)flatMapWithTransform:(Container * (^)(id))transform {
    return transform(self.value);
}
@end

@interface Pair : NSObject
@property (nonatomic, strong) id first;
@property (nonatomic, strong) id second;
- (instancetype)initWithFirst:(id)first second:(id)second;
- (Pair *)mapFirstWithTransform:(id (^)(id))transform;
- (Pair *)mapSecondWithTransform:(id (^)(id))transform;
- (Pair *)mapBothWithFirstTransform:(id (^)(id))firstTransform secondTransform:(id (^)(id))secondTransform;
@end

@implementation Pair
- (instancetype)initWithFirst:(id)first second:(id)second {
    self = [super init];
    if (self) {
        _first = first;
        _second = second;
    }
    return self;
}
- (Pair *)mapFirstWithTransform:(id (^)(id))transform {
    return [[Pair alloc] initWithFirst:transform(self.first) second:self.second];
}
- (Pair *)mapSecondWithTransform:(id (^)(id))transform {
    return [[Pair alloc] initWithFirst:self.first second:transform(self.second)];
}
- (Pair *)mapBothWithFirstTransform:(id (^)(id))firstTransform secondTransform:(id (^)(id))secondTransform {
    return [[Pair alloc] initWithFirst:firstTransform(self.first) second:secondTransform(self.second)];
}
@end

@interface Triple : NSObject
@property (nonatomic, strong) id first;
@property (nonatomic, strong) id second;
@property (nonatomic, strong) id third;
- (instancetype)initWithFirst:(id)first second:(id)second third:(id)third;
- (Triple *)mapFirstWithTransform:(id (^)(id))transform;
- (Triple *)mapSecondWithTransform:(id (^)(id))transform;
- (Triple *)mapThirdWithTransform:(id (^)(id))transform;
@end

@implementation Triple
- (instancetype)initWithFirst:(id)first second:(id)second third:(id)third {
    self = [super init];
    if (self) {
        _first = first;
        _second = second;
        _third = third;
    }
    return self;
}
- (Triple *)mapFirstWithTransform:(id (^)(id))transform {
    return [[Triple alloc] initWithFirst:transform(self.first) second:self.second third:self.third];
}
- (Triple *)mapSecondWithTransform:(id (^)(id))transform {
    return [[Triple alloc] initWithFirst:self.first second:transform(self.second) third:self.third];
}
- (Triple *)mapThirdWithTransform:(id (^)(id))transform {
    return [[Triple alloc] initWithFirst:self.first second:self.second third:transform(self.third)];
}
@end

// Generic-like collection utilities
@interface GenericList : NSObject
@property (nonatomic, strong) NSMutableArray *items;
- (void)addItem:(id)item;
- (id)getItemAtIndex:(NSInteger)index;
- (GenericList *)mapWithTransform:(id (^)(id))transform;
- (GenericList *)filterWithPredicate:(BOOL (^)(id))predicate;
- (id)foldWithInitial:(id)initial operation:(id (^)(id, id))operation;
@end

@implementation GenericList
- (instancetype)init {
    self = [super init];
    if (self) {
        _items = [[NSMutableArray alloc] init];
    }
    return self;
}
- (void)addItem:(id)item { [self.items addObject:item]; }
- (id)getItemAtIndex:(NSInteger)index {
    return index < self.items.count ? self.items[index] : nil;
}
- (GenericList *)mapWithTransform:(id (^)(id))transform {
    GenericList *result = [[GenericList alloc] init];
    for (id item in self.items) {
        [result addItem:transform(item)];
    }
    return result;
}
- (GenericList *)filterWithPredicate:(BOOL (^)(id))predicate {
    GenericList *result = [[GenericList alloc] init];
    for (id item in self.items) {
        if (predicate(item)) {
            [result addItem:item];
        }
    }
    return result;
}
- (id)foldWithInitial:(id)initial operation:(id (^)(id, id))operation {
    id accumulator = initial;
    for (id item in self.items) {
        accumulator = operation(accumulator, item);
    }
    return accumulator;
}
@end

@interface GenericMap : NSObject
@property (nonatomic, strong) NSMutableDictionary *items;
- (void)putKey:(id)key value:(id)value;
- (id)getValueForKey:(id)key;
- (GenericMap *)mapValuesWithTransform:(id (^)(id))transform;
- (GenericMap *)mapKeysWithTransform:(id (^)(id))transform;
@end

@implementation GenericMap
- (instancetype)init {
    self = [super init];
    if (self) {
        _items = [[NSMutableDictionary alloc] init];
    }
    return self;
}
- (void)putKey:(id)key value:(id)value { self.items[key] = value; }
- (id)getValueForKey:(id)key { return self.items[key]; }
- (GenericMap *)mapValuesWithTransform:(id (^)(id))transform {
    GenericMap *result = [[GenericMap alloc] init];
    for (id key in self.items) {
        [result putKey:key value:transform(self.items[key])];
    }
    return result;
}
- (GenericMap *)mapKeysWithTransform:(id (^)(id))transform {
    GenericMap *result = [[GenericMap alloc] init];
    for (id key in self.items) {
        [result putKey:transform(key) value:self.items[key]];
    }
    return result;
}
@end

// Processing classes
@interface Processor : NSObject
@property (nonatomic, copy) id (^processBlock)(id);
- (instancetype)initWithProcessBlock:(id (^)(id))processBlock;
- (id)executeWithInput:(id)input;
- (Processor *)chainWithProcessor:(Processor *)nextProcessor;
@end

@implementation Processor
- (instancetype)initWithProcessBlock:(id (^)(id))processBlock {
    self = [super init];
    if (self) {
        _processBlock = processBlock;
    }
    return self;
}
- (id)executeWithInput:(id)input { return self.processBlock(input); }
- (Processor *)chainWithProcessor:(Processor *)nextProcessor {
    return [[Processor alloc] initWithProcessBlock:^id(id input) {
        return [nextProcessor executeWithInput:[self executeWithInput:input]];
    }];
}
@end

@interface BatchProcessor : NSObject
- (NSArray *)processBatch:(NSArray *)items withProcessor:(id (^)(id))processor;
- (NSArray *)processFiltered:(NSArray *)items withFilter:(BOOL (^)(id))filter processor:(id (^)(id))processor;
@end

@implementation BatchProcessor
- (NSArray *)processBatch:(NSArray *)items withProcessor:(id (^)(id))processor {
    NSMutableArray *result = [[NSMutableArray alloc] init];
    for (id item in items) {
        [result addObject:processor(item)];
    }
    return result;
}
- (NSArray *)processFiltered:(NSArray *)items withFilter:(BOOL (^)(id))filter processor:(id (^)(id))processor {
    NSMutableArray *result = [[NSMutableArray alloc] init];
    for (id item in items) {
        if (filter(item)) {
            [result addObject:processor(item)];
        }
    }
    return result;
}
@end

@interface Cache : NSObject
@property (nonatomic, strong) NSMutableDictionary *storage;
- (id)getValueForKey:(id)key;
- (void)putKey:(id)key value:(id)value;
- (id)getOrComputeForKey:(id)key withCompute:(id (^)(id))compute;
@end

@implementation Cache
- (instancetype)init {
    self = [super init];
    if (self) {
        _storage = [[NSMutableDictionary alloc] init];
    }
    return self;
}
- (id)getValueForKey:(id)key { return self.storage[key]; }
- (void)putKey:(id)key value:(id)value { self.storage[key] = value; }
- (id)getOrComputeForKey:(id)key withCompute:(id (^)(id))compute {
    id value = self.storage[key];
    if (!value) {
        value = compute(key);
        self.storage[key] = value;
    }
    return value;
}
@end

// Protocols for type-safe interfaces
@protocol Transformer <NSObject>
- (id)transformInput:(id)input;
@end

@protocol Validator <NSObject>
- (BOOL)validateItem:(id)item;
@end

@protocol Comparator <NSObject>
- (NSComparisonResult)compareItemA:(id)itemA withItemB:(id)itemB;
@end

// Implementations
@interface StringTransformer : NSObject <Transformer>
@end

@implementation StringTransformer
- (id)transformInput:(id)input {
    if ([input isKindOfClass:[NSString class]]) {
        return @([(NSString *)input length]);
    }
    return @0;
}
@end

@interface NumberValidator : NSObject <Validator>
@end

@implementation NumberValidator
- (BOOL)validateItem:(id)item {
    if ([item isKindOfClass:[NSNumber class]]) {
        return [(NSNumber *)item doubleValue] > 0;
    }
    return NO;
}
@end

@interface StringComparator : NSObject <Comparator>
@end

@implementation StringComparator
- (NSComparisonResult)compareItemA:(id)itemA withItemB:(id)itemB {
    if ([itemA isKindOfClass:[NSString class]] && [itemB isKindOfClass:[NSString class]]) {
        return [(NSString *)itemA compare:(NSString *)itemB];
    }
    return NSOrderedSame;
}
@end

// Main benchmark class
@interface IosSizeBenchmark : NSObject
@property (nonatomic, strong) Container *stringContainer;
@property (nonatomic, strong) Container *numberContainer;
@property (nonatomic, strong) GenericList *stringList;
@property (nonatomic, strong) GenericMap *stringMap;
@property (nonatomic, strong) Processor *stringProcessor;
@property (nonatomic, strong) BatchProcessor *batchProcessor;
@property (nonatomic, strong) Cache *cache;
@property (nonatomic, strong) id<Transformer> transformer;
@property (nonatomic, strong) id<Validator> validator;
@property (nonatomic, strong) id<Comparator> comparator;
- (void)runBenchmark;
@end

@implementation IosSizeBenchmark

- (instancetype)init {
    self = [super init];
    if (self) {
        _stringContainer = [[Container alloc] initWithValue:@"test"];
        _numberContainer = [[Container alloc] initWithValue:@42];
        _stringList = [[GenericList alloc] init];
        _stringMap = [[GenericMap alloc] init];
        _stringProcessor = [[Processor alloc] initWithProcessBlock:^id(id input) {
            return [input isKindOfClass:[NSString class]] ? @([(NSString *)input length]) : @0;
        }];
        _batchProcessor = [[BatchProcessor alloc] init];
        _cache = [[Cache alloc] init];
        _transformer = [[StringTransformer alloc] init];
        _validator = [[NumberValidator alloc] init];
        _comparator = [[StringComparator alloc] init];
    }
    return self;
}

- (void)runBenchmark {
    // Test containers
    Container *mappedString = [self.stringContainer mapWithTransform:^id(id input) {
        return [input isKindOfClass:[NSString class]] ? [(NSString *)input uppercaseString] : input;
    }];
    
    Container *mappedNumber = [self.numberContainer mapWithTransform:^id(id input) {
        return [input isKindOfClass:[NSNumber class]] ? @([(NSNumber *)input intValue] * 2) : input;
    }];
    
    // Test pairs and triples
    Pair *pair = [[Pair alloc] initWithFirst:@"hello" second:@42];
    Pair *mappedPair = [pair mapFirstWithTransform:^id(id input) {
        return [input isKindOfClass:[NSString class]] ? @([(NSString *)input length]) : input;
    }];
    
    Triple *triple = [[Triple alloc] initWithFirst:@"a" second:@1 third:@2.0];
    Triple *mappedTriple = [triple mapSecondWithTransform:^id(id input) {
        return [input isKindOfClass:[NSNumber class]] ? @([(NSNumber *)input intValue] * 2) : input;
    }];
    
    // Test collections
    [self.stringList addItem:@"test"];
    [self.stringList addItem:@"example"];
    GenericList *mappedList = [self.stringList mapWithTransform:^id(id input) {
        return [input isKindOfClass:[NSString class]] ? @([(NSString *)input length]) : @0;
    }];
    
    GenericList *filteredList = [self.stringList filterWithPredicate:^BOOL(id input) {
        return [input isKindOfClass:[NSString class]] && [(NSString *)input length] > 3;
    }];
    
    [self.stringMap putKey:@"key1" value:@10];
    [self.stringMap putKey:@"key2" value:@20];
    GenericMap *mappedValues = [self.stringMap mapValuesWithTransform:^id(id input) {
        return [input isKindOfClass:[NSNumber class]] ? @([(NSNumber *)input intValue] * 2) : input;
    }];
    
    // Test processors
    id result1 = [self.stringProcessor executeWithInput:@"hello"];
    NSArray *batchResult = [self.batchProcessor processBatch:@[@"a", @"bb", @"ccc"] withProcessor:^id(id input) {
        return [input isKindOfClass:[NSString class]] ? @([(NSString *)input length]) : @0;
    }];
    
    [self.cache putKey:@"test" value:@42];
    id cachedValue = [self.cache getOrComputeForKey:@"new" withCompute:^id(id key) {
        return [key isKindOfClass:[NSString class]] ? @([(NSString *)key length]) : @0;
    }];
    
    // Test interfaces
    id transformedString = [self.transformer transformInput:@"hello"];
    BOOL isValid = [self.validator validateItem:@42];
    NSComparisonResult comparisonResult = [self.comparator compareItemA:@"a" withItemB:@"b"];
}

@end