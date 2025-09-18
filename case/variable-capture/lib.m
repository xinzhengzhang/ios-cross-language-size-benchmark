/*
 * iOS Size Benchmark - Test Case Implementation
 * Generated with Claude AI (https://claude.ai)
 * 
 * This Objective-C implementation demonstrates language-specific
 * features and patterns for binary size comparison.
 */

#import <Foundation/Foundation.h>

@interface DataContainer : NSObject
@property (nonatomic, strong) NSString *stringValue;
@property (nonatomic, strong) NSArray *arrayValue;
@property (nonatomic, strong) NSDictionary *dictValue;
@property (nonatomic, strong) NSMutableString *mutableString;
@property (nonatomic, strong) NSData *dataValue;
@end

@implementation DataContainer
@end

@interface CaptureTestService : NSObject
- (void)performVariableCaptureStressTest;
- (void)createComplexClosureWithManyCaptures:(NSInteger)iteration;
- (void)nestedCaptureTest:(NSInteger)depth;
@end

@implementation CaptureTestService

- (void)performVariableCaptureStressTest {
    for (NSInteger i = 1; i <= 1000; i++) {
        [self createComplexClosureWithManyCaptures:i];
        if (i % 100 == 0) {
            [self nestedCaptureTest:10];
        }
    }
}

- (void)createComplexClosureWithManyCaptures:(NSInteger)iteration {
    NSString *str1 = [NSString stringWithFormat:@"String_%ld", (long)iteration];
    NSString *str2 = [NSString stringWithFormat:@"AnotherString_%ld", (long)iteration * 2];
    NSString *str3 = [NSString stringWithFormat:@"ThirdString_%ld", (long)iteration * 3];
    NSString *str4 = [NSString stringWithFormat:@"FourthString_%ld", (long)iteration * 4];
    NSString *str5 = [NSString stringWithFormat:@"FifthString_%ld", (long)iteration * 5];
    
    NSArray *array1 = @[@(iteration), @(iteration * 2), @(iteration * 3)];
    NSArray *array2 = @[str1, str2, str3];
    NSArray *array3 = @[@(iteration + 100), @(iteration + 200), @(iteration + 300)];
    NSArray *array4 = @[str4, str5, [NSString stringWithFormat:@"Extra_%ld", (long)iteration]];
    NSArray *array5 = @[@(iteration % 10), @(iteration % 20), @(iteration % 30)];
    
    NSDictionary *dict1 = @{@"key1": str1, @"key2": @(iteration), @"key3": array1};
    NSDictionary *dict2 = @{@"data": str2, @"count": @(iteration * 2), @"items": array2};
    NSDictionary *dict3 = @{@"id": @(iteration), @"name": str3, @"values": array3};
    NSDictionary *dict4 = @{@"type": str4, @"index": @(iteration * 4), @"list": array4};
    NSDictionary *dict5 = @{@"category": str5, @"size": @(iteration * 5), @"elements": array5};
    
    NSMutableString *mutable1 = [NSMutableString stringWithFormat:@"Mutable_%ld", (long)iteration];
    NSMutableString *mutable2 = [NSMutableString stringWithFormat:@"Dynamic_%ld", (long)iteration * 2];
    NSMutableString *mutable3 = [NSMutableString stringWithFormat:@"Buffer_%ld", (long)iteration * 3];
    NSMutableString *mutable4 = [NSMutableString stringWithFormat:@"Content_%ld", (long)iteration * 4];
    NSMutableString *mutable5 = [NSMutableString stringWithFormat:@"Text_%ld", (long)iteration * 5];
    
    NSData *data1 = [str1 dataUsingEncoding:NSUTF8StringEncoding];
    NSData *data2 = [str2 dataUsingEncoding:NSUTF8StringEncoding];
    NSData *data3 = [str3 dataUsingEncoding:NSUTF8StringEncoding];
    NSData *data4 = [str4 dataUsingEncoding:NSUTF8StringEncoding];
    NSData *data5 = [str5 dataUsingEncoding:NSUTF8StringEncoding];
    
    DataContainer *container1 = [[DataContainer alloc] init];
    container1.stringValue = str1;
    container1.arrayValue = array1;
    container1.dictValue = dict1;
    container1.mutableString = mutable1;
    container1.dataValue = data1;
    
    DataContainer *container2 = [[DataContainer alloc] init];
    container2.stringValue = str2;
    container2.arrayValue = array2;
    container2.dictValue = dict2;
    container2.mutableString = mutable2;
    container2.dataValue = data2;
    
    DataContainer *container3 = [[DataContainer alloc] init];
    container3.stringValue = str3;
    container3.arrayValue = array3;
    container3.dictValue = dict3;
    container3.mutableString = mutable3;
    container3.dataValue = data3;
    
    DataContainer *container4 = [[DataContainer alloc] init];
    container4.stringValue = str4;
    container4.arrayValue = array4;
    container4.dictValue = dict4;
    container4.mutableString = mutable4;
    container4.dataValue = data4;
    
    DataContainer *container5 = [[DataContainer alloc] init];
    container5.stringValue = str5;
    container5.arrayValue = array5;
    container5.dictValue = dict5;
    container5.mutableString = mutable5;
    container5.dataValue = data5;
    
    NSNumber *num1 = @(iteration);
    NSNumber *num2 = @(iteration * 1.5);
    NSNumber *num3 = @(iteration * 2.5);
    NSNumber *num4 = @(iteration * 3.5);
    NSNumber *num5 = @(iteration * 4.5);
    
    void (^complexBlock)(void) = ^{
        NSLog(@"Processing: %@, %@, %@, %@, %@", str1, str2, str3, str4, str5);
        
        for (id item in array1) {
            NSLog(@"Array1 item: %@", item);
        }
        for (id item in array2) {
            NSLog(@"Array2 item: %@", item);
        }
        for (id item in array3) {
            NSLog(@"Array3 item: %@", item);
        }
        for (id item in array4) {
            NSLog(@"Array4 item: %@", item);
        }
        for (id item in array5) {
            NSLog(@"Array5 item: %@", item);
        }
        
        [dict1 enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            NSLog(@"Dict1 %@: %@", key, obj);
        }];
        [dict2 enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            NSLog(@"Dict2 %@: %@", key, obj);
        }];
        [dict3 enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            NSLog(@"Dict3 %@: %@", key, obj);
        }];
        [dict4 enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            NSLog(@"Dict4 %@: %@", key, obj);
        }];
        [dict5 enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            NSLog(@"Dict5 %@: %@", key, obj);
        }];
        
        [mutable1 appendString:@"_modified"];
        [mutable2 appendString:@"_modified"];
        [mutable3 appendString:@"_modified"];
        [mutable4 appendString:@"_modified"];
        [mutable5 appendString:@"_modified"];
        
        NSLog(@"Data lengths: %lu, %lu, %lu, %lu, %lu", 
              (unsigned long)data1.length, (unsigned long)data2.length, 
              (unsigned long)data3.length, (unsigned long)data4.length, 
              (unsigned long)data5.length);
        
        NSLog(@"Container values: %@, %@, %@, %@, %@",
              container1.stringValue, container2.stringValue, 
              container3.stringValue, container4.stringValue, 
              container5.stringValue);
        
        double calculation = [num1 doubleValue] + [num2 doubleValue] + 
                           [num3 doubleValue] + [num4 doubleValue] + [num5 doubleValue];
        NSLog(@"Calculation result: %f", calculation);
        
        void (^nestedBlock)(void) = ^{
            NSLog(@"Nested access: %@, %@", str1, str3);
            NSLog(@"Nested containers: %@, %@", container1.stringValue, container3.stringValue);
            NSLog(@"Nested numbers: %@, %@", num1, num3);
            
            void (^deepNestedBlock)(void) = ^{
                NSLog(@"Deep nested: %@", str2);
                NSLog(@"Deep container: %@", container2.stringValue);
                [mutable2 appendString:@"_deep"];
            };
            deepNestedBlock();
        };
        nestedBlock();
    };
    
    complexBlock();
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        void (^asyncBlock)(void) = ^{
            NSLog(@"Async processing: %@, %@", str1, str5);
            NSLog(@"Async data: %@", container1.stringValue);
            double asyncCalc = [num1 doubleValue] * [num5 doubleValue];
            NSLog(@"Async calculation: %f", asyncCalc);
        };
        asyncBlock();
    });
}

- (void)nestedCaptureTest:(NSInteger)depth {
    if (depth <= 0) return;
    
    NSString *depthString = [NSString stringWithFormat:@"Depth_%ld", (long)depth];
    NSArray *depthArray = @[@(depth), @(depth * 10), @(depth * 100)];
    NSDictionary *depthDict = @{@"level": @(depth), @"data": depthString};
    NSMutableString *depthMutable = [NSMutableString stringWithFormat:@"Mutable_Depth_%ld", (long)depth];
    NSData *depthData = [depthString dataUsingEncoding:NSUTF8StringEncoding];
    
    void (^recursiveBlock)(void) = ^{
        NSLog(@"Recursive level %ld: %@", (long)depth, depthString);
        
        for (id item in depthArray) {
            NSLog(@"Depth array item: %@", item);
        }
        
        [depthDict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            NSLog(@"Depth dict %@: %@", key, obj);
        }];
        
        [depthMutable appendString:@"_processed"];
        NSLog(@"Processed mutable: %@", depthMutable);
        NSLog(@"Data length at depth %ld: %lu", (long)depth, (unsigned long)depthData.length);
        
        [self nestedCaptureTest:depth - 1];
    };
    
    recursiveBlock();
}

@end

@interface IosSizeBenchmark : NSObject
@property (nonatomic, strong) CaptureTestService *captureTestService;
- (void)runBenchmark;
@end

@implementation IosSizeBenchmark

- (instancetype)init {
    self = [super init];
    if (self) {
        _captureTestService = [[CaptureTestService alloc] init];
    }
    return self;
}

- (void)runBenchmark {
    [self.captureTestService performVariableCaptureStressTest];
}

@end