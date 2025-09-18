/*
 * iOS Size Benchmark - Test Case Implementation
 * Generated with Claude AI (https://claude.ai)
 * 
 * This Objective-C implementation demonstrates language-specific
 * features and patterns for binary size comparison.
 */

#import <Foundation/Foundation.h>

// Test case: Functional Style - Tests impact of blocks and higher-order functions on code size
// Note: Objective-C uses blocks instead of lambdas, but we simulate functional programming patterns

// Block type definitions
typedef id (^TransformBlock)(id);
typedef BOOL (^PredicateBlock)(id);
typedef id (^ReduceBlock)(id, id);
typedef void (^ActionBlock)(id);
typedef id (^ComposerBlock)(id);

// Functional utilities using blocks
@interface FunctionalUtils : NSObject

+ (NSArray *)map:(NSArray *)array withTransform:(TransformBlock)transform;
+ (NSArray *)filter:(NSArray *)array withPredicate:(PredicateBlock)predicate;
+ (id)fold:(NSArray *)array withInitial:(id)initial operation:(ReduceBlock)operation;
+ (NSArray *)flatMap:(NSArray *)array withTransform:(NSArray * (^)(id))transform;
+ (ComposerBlock)compose:(TransformBlock)f with:(TransformBlock)g;
+ (TransformBlock)curry:(id (^)(id, id))f withFirst:(id)first;

@end

@implementation FunctionalUtils

+ (NSArray *)map:(NSArray *)array withTransform:(TransformBlock)transform {
    NSMutableArray *result = [[NSMutableArray alloc] init];
    for (id item in array) {
        [result addObject:transform(item)];
    }
    return result;
}

+ (NSArray *)filter:(NSArray *)array withPredicate:(PredicateBlock)predicate {
    NSMutableArray *result = [[NSMutableArray alloc] init];
    for (id item in array) {
        if (predicate(item)) {
            [result addObject:item];
        }
    }
    return result;
}

+ (id)fold:(NSArray *)array withInitial:(id)initial operation:(ReduceBlock)operation {
    id accumulator = initial;
    for (id item in array) {
        accumulator = operation(accumulator, item);
    }
    return accumulator;
}

+ (NSArray *)flatMap:(NSArray *)array withTransform:(NSArray * (^)(id))transform {
    NSMutableArray *result = [[NSMutableArray alloc] init];
    for (id item in array) {
        NSArray *transformed = transform(item);
        [result addObjectsFromArray:transformed];
    }
    return result;
}

+ (ComposerBlock)compose:(TransformBlock)f with:(TransformBlock)g {
    return ^id(id input) {
        return f(g(input));
    };
}

+ (TransformBlock)curry:(id (^)(id, id))f withFirst:(id)first {
    return ^id(id second) {
        return f(first, second);
    };
}

@end

// Data processor using blocks
@interface DataProcessor : NSObject
@property (nonatomic, strong) NSMutableArray<TransformBlock> *processors;
- (DataProcessor *)addProcessor:(TransformBlock)processor;
- (id)process:(id)data;
- (NSArray *)processMany:(NSArray *)data;
- (void)processAsync:(id)data withCallback:(ActionBlock)callback;
@end

@implementation DataProcessor

- (instancetype)init {
    self = [super init];
    if (self) {
        _processors = [[NSMutableArray alloc] init];
    }
    return self;
}

- (DataProcessor *)addProcessor:(TransformBlock)processor {
    [self.processors addObject:processor];
    return self;
}

- (id)process:(id)data {
    id result = data;
    for (TransformBlock processor in self.processors) {
        result = processor(result);
    }
    return result;
}

- (NSArray *)processMany:(NSArray *)data {
    return [FunctionalUtils map:data withTransform:^id(id item) {
        return [self process:item];
    }];
}

- (void)processAsync:(id)data withCallback:(ActionBlock)callback {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        id result = [self process:data];
        dispatch_async(dispatch_get_main_queue(), ^{
            callback(result);
        });
    });
}

@end

// Event handler using blocks
@interface EventHandler : NSObject
@property (nonatomic, strong) NSMutableArray<ActionBlock> *handlers;
@property (nonatomic, strong) NSMutableArray<PredicateBlock> *filters;
@property (nonatomic, strong) NSMutableArray<TransformBlock> *transformers;
- (EventHandler *)addHandler:(ActionBlock)handler;
- (EventHandler *)addFilter:(PredicateBlock)filter;
- (EventHandler *)addTransformer:(TransformBlock)transformer;
- (void)handle:(id)event;
- (void)handleMany:(NSArray *)events;
@end

@implementation EventHandler

- (instancetype)init {
    self = [super init];
    if (self) {
        _handlers = [[NSMutableArray alloc] init];
        _filters = [[NSMutableArray alloc] init];
        _transformers = [[NSMutableArray alloc] init];
    }
    return self;
}

- (EventHandler *)addHandler:(ActionBlock)handler {
    [self.handlers addObject:handler];
    return self;
}

- (EventHandler *)addFilter:(PredicateBlock)filter {
    [self.filters addObject:filter];
    return self;
}

- (EventHandler *)addTransformer:(TransformBlock)transformer {
    [self.transformers addObject:transformer];
    return self;
}

- (void)handle:(id)event {
    // Check all filters
    for (PredicateBlock filter in self.filters) {
        if (!filter(event)) {
            return;
        }
    }
    
    // Apply transformers
    id transformedEvent = event;
    for (TransformBlock transformer in self.transformers) {
        transformedEvent = transformer(transformedEvent);
    }
    
    // Call handlers
    for (ActionBlock handler in self.handlers) {
        handler(transformedEvent);
    }
}

- (void)handleMany:(NSArray *)events {
    for (id event in events) {
        [self handle:event];
    }
}

@end

// Functional stream operations
@interface FunctionalStream : NSObject
@property (nonatomic, strong) NSArray *data;
- (instancetype)initWithData:(NSArray *)data;
- (FunctionalStream *)map:(TransformBlock)transform;
- (FunctionalStream *)filter:(PredicateBlock)predicate;
- (FunctionalStream *)flatMap:(NSArray * (^)(id))transform;
- (void)forEach:(ActionBlock)action;
- (id)fold:(id)initial operation:(ReduceBlock)operation;
- (FunctionalStream *)take:(NSInteger)count;
- (FunctionalStream *)drop:(NSInteger)count;
- (NSDictionary *)groupBy:(NSString * (^)(id))keySelector;
- (NSArray *)toArray;
@end

@implementation FunctionalStream

- (instancetype)initWithData:(NSArray *)data {
    self = [super init];
    if (self) {
        _data = data;
    }
    return self;
}

- (FunctionalStream *)map:(TransformBlock)transform {
    return [[FunctionalStream alloc] initWithData:[FunctionalUtils map:self.data withTransform:transform]];
}

- (FunctionalStream *)filter:(PredicateBlock)predicate {
    return [[FunctionalStream alloc] initWithData:[FunctionalUtils filter:self.data withPredicate:predicate]];
}

- (FunctionalStream *)flatMap:(NSArray * (^)(id))transform {
    return [[FunctionalStream alloc] initWithData:[FunctionalUtils flatMap:self.data withTransform:transform]];
}

- (void)forEach:(ActionBlock)action {
    for (id item in self.data) {
        action(item);
    }
}

- (id)fold:(id)initial operation:(ReduceBlock)operation {
    return [FunctionalUtils fold:self.data withInitial:initial operation:operation];
}

- (FunctionalStream *)take:(NSInteger)count {
    NSArray *taken = [self.data subarrayWithRange:NSMakeRange(0, MIN(count, self.data.count))];
    return [[FunctionalStream alloc] initWithData:taken];
}

- (FunctionalStream *)drop:(NSInteger)count {
    if (count >= self.data.count) {
        return [[FunctionalStream alloc] initWithData:@[]];
    }
    NSArray *dropped = [self.data subarrayWithRange:NSMakeRange(count, self.data.count - count)];
    return [[FunctionalStream alloc] initWithData:dropped];
}

- (NSDictionary *)groupBy:(NSString * (^)(id))keySelector {
    NSMutableDictionary *groups = [[NSMutableDictionary alloc] init];
    for (id item in self.data) {
        NSString *key = keySelector(item);
        if (!groups[key]) {
            groups[key] = [[NSMutableArray alloc] init];
        }
        [groups[key] addObject:item];
    }
    return groups;
}

- (NSArray *)toArray {
    return self.data;
}

@end

// Block factory for complex operations
@interface BlockFactory : NSObject

+ (TransformBlock)createNumberProcessor;
+ (TransformBlock)createStringProcessor;
+ (PredicateBlock)createValidator;
+ (TransformBlock)createTransformer;
+ (ReduceBlock)createAggregator;
+ (TransformBlock)createComplexProcessor;
+ (TransformBlock)createNestedFunction:(TransformBlock)innerFunction;
+ (TransformBlock)createConditionalFunction;

@end

@implementation BlockFactory

+ (TransformBlock)createNumberProcessor {
    return ^id(id input) {
        if ([input isKindOfClass:[NSNumber class]]) {
            NSInteger value = [(NSNumber *)input integerValue];
            return @(value * 2);
        }
        return input;
    };
}

+ (TransformBlock)createStringProcessor {
    return ^id(id input) {
        if ([input isKindOfClass:[NSString class]]) {
            return [NSString stringWithFormat:@"processed: %@", (NSString *)input];
        }
        return input;
    };
}

+ (PredicateBlock)createValidator {
    return ^BOOL(id input) {
        if ([input isKindOfClass:[NSString class]]) {
            NSString *str = (NSString *)input;
            return str.length > 3 && str.length > 0;
        }
        return NO;
    };
}

+ (TransformBlock)createTransformer {
    return ^id(id input) {
        if ([input isKindOfClass:[NSString class]]) {
            NSString *str = (NSString *)input;
            NSArray *words = [str componentsSeparatedByString:@" "];
            NSMutableArray *processed = [[NSMutableArray alloc] init];
            for (NSString *word in words) {
                if (word.length > 0) {
                    [processed addObject:[word capitalizedString]];
                }
            }
            return [processed componentsJoinedByString:@" "];
        }
        return input;
    };
}

+ (ReduceBlock)createAggregator {
    return ^id(id accumulator, id current) {
        if ([accumulator isKindOfClass:[NSNumber class]] && [current isKindOfClass:[NSNumber class]]) {
            NSInteger acc = [(NSNumber *)accumulator integerValue];
            NSInteger cur = [(NSNumber *)current integerValue];
            return @(acc + cur * cur);
        }
        return accumulator;
    };
}

+ (TransformBlock)createComplexProcessor {
    return ^id(id input) {
        if ([input isKindOfClass:[NSArray class]]) {
            NSArray *strings = (NSArray *)input;
            NSMutableDictionary *result = [[NSMutableDictionary alloc] init];
            for (NSString *str in strings) {
                if ([str isKindOfClass:[NSString class]] && str.length > 0) {
                    NSString *firstChar = [str substringToIndex:1];
                    NSNumber *count = result[firstChar] ?: @0;
                    result[firstChar] = @([count integerValue] + 1);
                }
            }
            return result;
        }
        return input;
    };
}

+ (TransformBlock)createNestedFunction:(TransformBlock)innerFunction {
    return ^id(id input) {
        return innerFunction(innerFunction(input));
    };
}

+ (TransformBlock)createConditionalFunction {
    return ^id(id input) {
        if ([input isKindOfClass:[NSNumber class]]) {
            NSInteger number = [(NSNumber *)input integerValue];
            if (number % 15 == 0) return @"FizzBuzz";
            if (number % 3 == 0) return @"Fizz";
            if (number % 5 == 0) return @"Buzz";
            return [@(number) stringValue];
        }
        return input;
    };
}

@end

// Side effects with functional style
@interface FunctionalSideEffects : NSObject
@property (nonatomic, strong) NSMutableArray<NSString *> *logs;
@property (nonatomic, strong) NSMutableDictionary<NSString *, NSNumber *> *counters;
- (id)logAndProcess:(id)input withProcessor:(TransformBlock)processor;
- (NSArray *)countAndFilter:(NSArray *)items withPredicate:(PredicateBlock)predicate;
- (NSDictionary *)measureAndExecute:(id (^)(void))operation;
- (NSArray *)getLogs;
- (NSDictionary *)getCounters;
@end

@implementation FunctionalSideEffects

- (instancetype)init {
    self = [super init];
    if (self) {
        _logs = [[NSMutableArray alloc] init];
        _counters = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (id)logAndProcess:(id)input withProcessor:(TransformBlock)processor {
    [self.logs addObject:[NSString stringWithFormat:@"Processing: %@", input]];
    id result = processor(input);
    [self.logs addObject:[NSString stringWithFormat:@"Result: %@", result]];
    return result;
}

- (NSArray *)countAndFilter:(NSArray *)items withPredicate:(PredicateBlock)predicate {
    self.counters[@"total"] = @(items.count);
    NSMutableArray *filtered = [[NSMutableArray alloc] init];
    NSInteger passed = 0, failed = 0;
    
    for (id item in items) {
        if (predicate(item)) {
            [filtered addObject:item];
            passed++;
        } else {
            failed++;
        }
    }
    
    self.counters[@"passed"] = @(passed);
    self.counters[@"failed"] = @(failed);
    return filtered;
}

- (NSDictionary *)measureAndExecute:(id (^)(void))operation {
    NSTimeInterval startTime = [[NSDate date] timeIntervalSince1970];
    id result = operation();
    NSTimeInterval endTime = [[NSDate date] timeIntervalSince1970];
    NSTimeInterval duration = (endTime - startTime) * 1000; // Convert to milliseconds
    
    [self.logs addObject:[NSString stringWithFormat:@"Operation took %.2fms", duration]];
    return @{@"result": result ?: [NSNull null], @"duration": @(duration)};
}

- (NSArray *)getLogs { return [self.logs copy]; }
- (NSDictionary *)getCounters { return [self.counters copy]; }

@end

// Main benchmark class
@interface IosSizeBenchmark : NSObject
@property (nonatomic, strong) DataProcessor *dataProcessor;
@property (nonatomic, strong) EventHandler *eventHandler;
@property (nonatomic, strong) FunctionalSideEffects *sideEffects;
- (void)runBenchmark;
@end

@implementation IosSizeBenchmark

- (instancetype)init {
    self = [super init];
    if (self) {
        _dataProcessor = [[DataProcessor alloc] init];
        _eventHandler = [[EventHandler alloc] init];
        _sideEffects = [[FunctionalSideEffects alloc] init];
    }
    return self;
}

- (void)runBenchmark {
    // Test data
    NSArray *numbers = @[@1, @2, @3, @4, @5, @6, @7, @8, @9, @10];
    NSArray *strings = @[@"hello", @"world", @"functional", @"programming", @"objective", @"blocks"];
    
    // Basic higher-order functions with blocks
    NSArray *doubled = [FunctionalUtils map:numbers withTransform:^id(id item) {
        return @([(NSNumber *)item integerValue] * 2);
    }];
    
    NSArray *uppercased = [FunctionalUtils map:strings withTransform:^id(id item) {
        return [(NSString *)item uppercaseString];
    }];
    
    NSArray *lengths = [FunctionalUtils map:strings withTransform:^id(id item) {
        return @([(NSString *)item length]);
    }];
    
    // Filter operations
    NSArray *evens = [FunctionalUtils filter:numbers withPredicate:^BOOL(id item) {
        return [(NSNumber *)item integerValue] % 2 == 0;
    }];
    
    NSArray *longStrings = [FunctionalUtils filter:strings withPredicate:^BOOL(id item) {
        return [(NSString *)item length] > 5;
    }];
    
    // Fold operations
    NSNumber *sum = [FunctionalUtils fold:numbers withInitial:@0 operation:^id(id acc, id item) {
        return @([(NSNumber *)acc integerValue] + [(NSNumber *)item integerValue]);
    }];
    
    NSString *concatenated = [FunctionalUtils fold:strings withInitial:@"" operation:^id(id acc, id item) {
        return [NSString stringWithFormat:@"%@ %@", (NSString *)acc, (NSString *)item];
    }];
    
    // Complex block composition
    TransformBlock multiplyBy2 = ^id(id input) {
        return @([(NSNumber *)input integerValue] * 2);
    };
    
    TransformBlock add10 = ^id(id input) {
        return @([(NSNumber *)input integerValue] + 10);
    };
    
    ComposerBlock composed = [FunctionalUtils compose:add10 with:multiplyBy2];
    NSArray *composedResults = [FunctionalUtils map:numbers withTransform:composed];
    
    // Data processing with blocks
    [[[[self.dataProcessor addProcessor:^id(id input) {
        return [(NSString *)input stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    }] addProcessor:^id(id input) {
        return [(NSString *)input lowercaseString];
    }] addProcessor:^id(id input) {
        return [(NSString *)input stringByReplacingOccurrencesOfString:@" " withString:@"_"];
    }] addProcessor:^id(id input) {
        return [NSString stringWithFormat:@"processed_%@", (NSString *)input];
    }];
    
    NSArray *processedStrings = [self.dataProcessor processMany:strings];
    
    // Event handling with blocks
    [[[[[self.eventHandler addFilter:^BOOL(id item) {
        return [(NSString *)item length] > 0;
    }] addFilter:^BOOL(id item) {
        return [(NSString *)item length] > 2;
    }] addTransformer:^id(id item) {
        return [(NSString *)item uppercaseString];
    }] addTransformer:^id(id item) {
        return [NSString stringWithFormat:@"EVENT_%@", (NSString *)item];
    }] addHandler:^(id item) {
        NSLog(@"Handled: %@", item);
    }];
    
    [self.eventHandler handleMany:strings];
    
    // Stream operations
    FunctionalStream *stream = [[FunctionalStream alloc] initWithData:numbers];
    NSNumber *streamResult = [[[stream filter:^BOOL(id item) {
        return [(NSNumber *)item integerValue] > 3;
    }] map:^id(id item) {
        return @([(NSNumber *)item integerValue] * 3);
    }] fold:@0 operation:^id(id acc, id item) {
        return @([(NSNumber *)acc integerValue] + [(NSNumber *)item integerValue]);
    }];
    
    // Block factory operations
    TransformBlock numberProcessor = [BlockFactory createNumberProcessor];
    TransformBlock stringProcessor = [BlockFactory createStringProcessor];
    PredicateBlock validator = [BlockFactory createValidator];
    TransformBlock transformer = [BlockFactory createTransformer];
    
    NSArray *processedNumbers = [FunctionalUtils map:numbers withTransform:numberProcessor];
    NSArray *processedStrings2 = [FunctionalUtils map:strings withTransform:stringProcessor];
    NSArray *validStrings = [FunctionalUtils filter:strings withPredicate:validator];
    NSArray *transformedStrings = [FunctionalUtils map:strings withTransform:transformer];
    
    // Nested function operations
    TransformBlock nestedProcessor = [BlockFactory createNestedFunction:multiplyBy2];
    NSArray *nestedResults = [FunctionalUtils map:numbers withTransform:nestedProcessor];
    
    TransformBlock conditionalFunc = [BlockFactory createConditionalFunction];
    NSMutableArray *fizzBuzzNumbers = [[NSMutableArray alloc] init];
    for (int i = 1; i <= 20; i++) {
        [fizzBuzzNumbers addObject:@(i)];
    }
    NSArray *fizzBuzzResults = [FunctionalUtils map:fizzBuzzNumbers withTransform:conditionalFunc];
    
    // Side effects with functional style
    NSArray *countedStrings = [self.sideEffects countAndFilter:strings withPredicate:^BOOL(id item) {
        return [(NSString *)item containsString:@"a"];
    }];
    
    NSDictionary *measureResult = [self.sideEffects measureAndExecute:^id {
        NSMutableArray *reversed = [[NSMutableArray alloc] init];
        for (NSString *str in strings) {
            NSString *reversedStr = [[str componentsSeparatedByString:@""] 
                                    componentsJoinedByString:@""];
            [reversed addObject:reversedStr];
        }
        return [reversed componentsJoinedByString:@","];
    }];
    
    // Complex chained operations
    FunctionalStream *stringStream = [[FunctionalStream alloc] initWithData:strings];
    NSDictionary *groupedResults = [[stringStream filter:^BOOL(id item) {
        return [(NSString *)item length] > 4;
    }] groupBy:^NSString *(id item) {
        return [[(NSString *)item substringToIndex:1] uppercaseString];
    }];
    
    // Final complex operation with multiple nested blocks
    NSArray *finalResults = [FunctionalUtils map:strings withTransform:^id(id input) {
        NSString *str = (NSString *)input;
        return [FunctionalUtils fold:@[str] withInitial:str operation:^id(id acc, id item) {
            NSString *result = (NSString *)acc;
            result = [result stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            result = [result lowercaseString];
            result = [result stringByReplacingOccurrencesOfString:@" " withString:@"_"];
            return [NSString stringWithFormat:@"final_%@", result];
        }];
    }];
}

@end