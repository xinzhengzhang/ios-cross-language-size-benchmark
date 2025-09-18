/*
 * iOS Size Benchmark - Test Case Implementation
 * Generated with Claude AI (https://claude.ai)
 * 
 * This Objective-C implementation demonstrates language-specific
 * features and patterns for binary size comparison.
 */

#import <Foundation/Foundation.h>

// 数据模型
@interface User : NSObject
@property (nonatomic, assign) NSInteger userId;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, assign) NSInteger age;
- (instancetype)initWithId:(NSInteger)userId name:(NSString *)name email:(NSString *)email age:(NSInteger)age;
@end

@implementation User
- (instancetype)initWithId:(NSInteger)userId name:(NSString *)name email:(NSString *)email age:(NSInteger)age {
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

@interface Product : NSObject
@property (nonatomic, assign) NSInteger productId;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) double price;
@property (nonatomic, strong) NSString *category;
- (instancetype)initWithId:(NSInteger)productId name:(NSString *)name price:(double)price category:(NSString *)category;
@end

@implementation Product
- (instancetype)initWithId:(NSInteger)productId name:(NSString *)name price:(double)price category:(NSString *)category {
    self = [super init];
    if (self) {
        _productId = productId;
        _name = name;
        _price = price;
        _category = category;
    }
    return self;
}
@end

@interface Order : NSObject
@property (nonatomic, assign) NSInteger orderId;
@property (nonatomic, assign) NSInteger userId;
@property (nonatomic, strong) NSArray<Product *> *products;
@property (nonatomic, assign) double total;
- (instancetype)initWithId:(NSInteger)orderId userId:(NSInteger)userId products:(NSArray<Product *> *)products total:(double)total;
@end

@implementation Order
- (instancetype)initWithId:(NSInteger)orderId userId:(NSInteger)userId products:(NSArray<Product *> *)products total:(double)total {
    self = [super init];
    if (self) {
        _orderId = orderId;
        _userId = userId;
        _products = products;
        _total = total;
    }
    return self;
}
@end

@interface OrderRequest : NSObject
@property (nonatomic, assign) NSInteger userId;
@property (nonatomic, strong) NSArray<NSNumber *> *productIds;
- (instancetype)initWithUserId:(NSInteger)userId productIds:(NSArray<NSNumber *> *)productIds;
@end

@implementation OrderRequest
- (instancetype)initWithUserId:(NSInteger)userId productIds:(NSArray<NSNumber *> *)productIds {
    self = [super init];
    if (self) {
        _userId = userId;
        _productIds = productIds;
    }
    return self;
}
@end

@interface ProductMetrics : NSObject
@property (nonatomic, assign) NSInteger totalCount;
@property (nonatomic, assign) double averagePrice;
@property (nonatomic, assign) NSInteger categoryCount;
@property (nonatomic, strong) NSDictionary<NSString *, NSNumber *> *priceRangeDistribution;
- (instancetype)initWithTotalCount:(NSInteger)totalCount 
                      averagePrice:(double)averagePrice 
                     categoryCount:(NSInteger)categoryCount 
            priceRangeDistribution:(NSDictionary<NSString *, NSNumber *> *)priceRangeDistribution;
@end

@implementation ProductMetrics
- (instancetype)initWithTotalCount:(NSInteger)totalCount 
                      averagePrice:(double)averagePrice 
                     categoryCount:(NSInteger)categoryCount 
            priceRangeDistribution:(NSDictionary<NSString *, NSNumber *> *)priceRangeDistribution {
    self = [super init];
    if (self) {
        _totalCount = totalCount;
        _averagePrice = averagePrice;
        _categoryCount = categoryCount;
        _priceRangeDistribution = priceRangeDistribution;
    }
    return self;
}
@end

// 工作流结果类
@interface WorkflowResult : NSObject
@property (nonatomic, strong) User *createdUser;
@property (nonatomic, strong) User *updatedUser;
@property (nonatomic, strong) User *retrievedUser;
@property (nonatomic, assign) NSInteger allUsersCount;
@property (nonatomic, assign) NSInteger searchResultsCount;
@property (nonatomic, assign) BOOL deleteSuccess;
@property (nonatomic, strong) NSString *errorMessage;
@property (nonatomic, assign) BOOL isSuccess;
@end

@implementation WorkflowResult
@end

// 订单管道结果类
@interface OrderPipelineResult : NSObject
@property (nonatomic, strong) Order *order;
@property (nonatomic, strong) NSString *errorMessage;
@property (nonatomic, assign) BOOL isSuccess;
@end

@implementation OrderPipelineResult
@end

// 订单结果类
@interface OrderResult : NSObject
@property (nonatomic, strong) Order *order;
@property (nonatomic, assign) NSInteger userId;
@property (nonatomic, strong) NSString *errorMessage;
@property (nonatomic, assign) BOOL isSuccess;
@end

@implementation OrderResult
@end

// 异步用户服务
@interface AsyncUserService : NSObject
@property (nonatomic, strong) dispatch_queue_t queue;
- (void)createUserWithName:(NSString *)name email:(NSString *)email age:(NSInteger)age completion:(void (^)(User *user))completion;
- (void)updateUser:(User *)user completion:(void (^)(User *user))completion;
- (void)deleteUserWithId:(NSInteger)userId completion:(void (^)(BOOL success))completion;
- (void)getUserById:(NSInteger)userId completion:(void (^)(User *user))completion;
- (void)getAllUsersWithCompletion:(void (^)(NSArray<User *> *users))completion;
- (void)searchUsersWithQuery:(NSString *)query completion:(void (^)(NSArray<User *> *users))completion;
- (void)batchCreateUsersWithRequests:(NSArray<NSDictionary *> *)requests completion:(void (^)(NSArray<User *> *users))completion;
- (void)processUserWorkflowWithIndex:(NSInteger)userIndex completion:(void (^)(WorkflowResult *result))completion;
- (NSInteger)generateId;
@end

@implementation AsyncUserService

- (instancetype)init {
    self = [super init];
    if (self) {
        _queue = dispatch_queue_create("async.user.service.queue", DISPATCH_QUEUE_CONCURRENT);
    }
    return self;
}

- (void)createUserWithName:(NSString *)name email:(NSString *)email age:(NSInteger)age completion:(void (^)(User *user))completion {
    dispatch_async(self.queue, ^{
        usleep(10000); // 10ms delay
        User *user = [[User alloc] initWithId:[self generateId] name:name email:email age:age];
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(user);
        });
    });
}

- (void)updateUser:(User *)user completion:(void (^)(User *user))completion {
    dispatch_async(self.queue, ^{
        usleep(5000); // 5ms delay
        User *updatedUser = [[User alloc] initWithId:user.userId name:[NSString stringWithFormat:@"%@_updated", user.name] email:user.email age:user.age];
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(updatedUser);
        });
    });
}

- (void)deleteUserWithId:(NSInteger)userId completion:(void (^)(BOOL success))completion {
    dispatch_async(self.queue, ^{
        usleep(5000); // 5ms delay
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(YES);
        });
    });
}

- (void)getUserById:(NSInteger)userId completion:(void (^)(User *user))completion {
    dispatch_async(self.queue, ^{
        usleep(10000); // 10ms delay
        User *user = [[User alloc] initWithId:userId name:[NSString stringWithFormat:@"User%ld", (long)userId] email:[NSString stringWithFormat:@"user%ld@email.com", (long)userId] age:25];
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(user);
        });
    });
}

- (void)getAllUsersWithCompletion:(void (^)(NSArray<User *> *users))completion {
    dispatch_async(self.queue, ^{
        usleep(50000); // 50ms delay
        NSMutableArray<User *> *users = [NSMutableArray array];
        for (NSInteger i = 1; i <= 100; i++) {
            User *user = [[User alloc] initWithId:i name:[NSString stringWithFormat:@"User%ld", (long)i] email:[NSString stringWithFormat:@"user%ld@email.com", (long)i] age:20 + (i % 50)];
            [users addObject:user];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            completion([users copy]);
        });
    });
}

- (void)searchUsersWithQuery:(NSString *)query completion:(void (^)(NSArray<User *> *users))completion {
    [self getAllUsersWithCompletion:^(NSArray<User *> *allUsers) {
        dispatch_async(self.queue, ^{
            usleep(20000); // 20ms delay
            NSMutableArray<User *> *filteredUsers = [NSMutableArray array];
            for (User *user in allUsers) {
                if ([user.name localizedCaseInsensitiveContainsString:query]) {
                    [filteredUsers addObject:user];
                }
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                completion([filteredUsers copy]);
            });
        });
    }];
}

- (void)batchCreateUsersWithRequests:(NSArray<NSDictionary *> *)requests completion:(void (^)(NSArray<User *> *users))completion {
    dispatch_group_t group = dispatch_group_create();
    NSMutableArray<User *> *users = [NSMutableArray array];
    NSLock *lock = [[NSLock alloc] init];
    
    for (NSDictionary *request in requests) {
        dispatch_group_enter(group);
        [self createUserWithName:request[@"name"] email:request[@"email"] age:[request[@"age"] integerValue] completion:^(User *user) {
            [lock lock];
            [users addObject:user];
            [lock unlock];
            dispatch_group_leave(group);
        }];
    }
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        completion([users copy]);
    });
}

- (void)processUserWorkflowWithIndex:(NSInteger)userIndex completion:(void (^)(WorkflowResult *result))completion {
    WorkflowResult *result = [[WorkflowResult alloc] init];
    
    dispatch_group_t group = dispatch_group_create();
    
    // 并行执行多个异步操作
    dispatch_group_enter(group);
    [self createUserWithName:[NSString stringWithFormat:@"User%ld", (long)userIndex] 
                       email:[NSString stringWithFormat:@"user%ld@email.com", (long)userIndex] 
                         age:25 + userIndex % 50 
                  completion:^(User *user) {
        result.createdUser = user;
        dispatch_group_leave(group);
    }];
    
    dispatch_group_enter(group);
    [self getAllUsersWithCompletion:^(NSArray<User *> *users) {
        result.allUsersCount = users.count;
        dispatch_group_leave(group);
    }];
    
    dispatch_group_enter(group);
    [self searchUsersWithQuery:@"User" completion:^(NSArray<User *> *users) {
        result.searchResultsCount = users.count;
        dispatch_group_leave(group);
    }];
    
    dispatch_group_notify(group, self.queue, ^{
        // 串行执行依赖操作
        [self updateUser:result.createdUser completion:^(User *updatedUser) {
            result.updatedUser = updatedUser;
            [self getUserById:updatedUser.userId completion:^(User *retrievedUser) {
                result.retrievedUser = retrievedUser;
                [self deleteUserWithId:updatedUser.userId completion:^(BOOL deleteSuccess) {
                    result.deleteSuccess = deleteSuccess;
                    result.isSuccess = YES;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        completion(result);
                    });
                }];
            }];
        }];
    });
}

- (NSInteger)generateId {
    return arc4random_uniform(10000) + 1;
}

@end

// 异步产品服务
@interface AsyncProductService : NSObject
@property (nonatomic, strong) dispatch_queue_t queue;
- (void)createProductWithName:(NSString *)name price:(double)price category:(NSString *)category completion:(void (^)(Product *product))completion;
- (void)updateProduct:(Product *)product completion:(void (^)(Product *product))completion;
- (void)getAllProductsWithCompletion:(void (^)(NSArray<Product *> *products))completion;
- (void)getProductsByCategory:(NSString *)category completion:(void (^)(NSArray<Product *> *products))completion;
- (void)getProductById:(NSInteger)productId completion:(void (^)(Product *product))completion;
- (void)batchProcessProductsWithIds:(NSArray<NSNumber *> *)productIds completion:(void (^)(NSDictionary<NSNumber *, Product *> *results))completion;
- (void)calculateProductMetricsWithProducts:(NSArray<Product *> *)products completion:(void (^)(ProductMetrics *metrics))completion;
- (NSInteger)generateId;
@end

@implementation AsyncProductService

- (instancetype)init {
    self = [super init];
    if (self) {
        _queue = dispatch_queue_create("async.product.service.queue", DISPATCH_QUEUE_CONCURRENT);
    }
    return self;
}

- (void)createProductWithName:(NSString *)name price:(double)price category:(NSString *)category completion:(void (^)(Product *product))completion {
    dispatch_async(self.queue, ^{
        usleep(15000); // 15ms delay
        Product *product = [[Product alloc] initWithId:[self generateId] name:name price:price category:category];
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(product);
        });
    });
}

- (void)updateProduct:(Product *)product completion:(void (^)(Product *product))completion {
    dispatch_async(self.queue, ^{
        usleep(8000); // 8ms delay
        Product *updatedProduct = [[Product alloc] initWithId:product.productId name:product.name price:product.price * 1.1 category:product.category];
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(updatedProduct);
        });
    });
}

- (void)getAllProductsWithCompletion:(void (^)(NSArray<Product *> *products))completion {
    dispatch_async(self.queue, ^{
        usleep(60000); // 60ms delay
        NSMutableArray<Product *> *products = [NSMutableArray array];
        for (NSInteger i = 1; i <= 500; i++) {
            Product *product = [[Product alloc] initWithId:i name:[NSString stringWithFormat:@"Product%ld", (long)i] price:50.0 + (i % 200) category:[NSString stringWithFormat:@"Category%ld", (long)(i % 10)]];
            [products addObject:product];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            completion([products copy]);
        });
    });
}

- (void)getProductsByCategory:(NSString *)category completion:(void (^)(NSArray<Product *> *products))completion {
    [self getAllProductsWithCompletion:^(NSArray<Product *> *allProducts) {
        dispatch_async(self.queue, ^{
            usleep(30000); // 30ms delay
            NSMutableArray<Product *> *filtered = [NSMutableArray array];
            for (Product *product in allProducts) {
                if ([product.category isEqualToString:category]) {
                    [filtered addObject:product];
                }
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                completion([filtered copy]);
            });
        });
    }];
}

- (void)getProductById:(NSInteger)productId completion:(void (^)(Product *product))completion {
    dispatch_async(self.queue, ^{
        usleep(12000); // 12ms delay
        Product *product = [[Product alloc] initWithId:productId name:[NSString stringWithFormat:@"Product%ld", (long)productId] price:99.99 category:@"Electronics"];
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(product);
        });
    });
}

- (void)batchProcessProductsWithIds:(NSArray<NSNumber *> *)productIds completion:(void (^)(NSDictionary<NSNumber *, Product *> *results))completion {
    dispatch_group_t group = dispatch_group_create();
    NSMutableDictionary<NSNumber *, Product *> *results = [NSMutableDictionary dictionary];
    NSLock *lock = [[NSLock alloc] init];
    
    for (NSNumber *productId in productIds) {
        dispatch_group_enter(group);
        [self getProductById:[productId integerValue] completion:^(Product *product) {
            [lock lock];
            if (product) {
                results[productId] = product;
            }
            [lock unlock];
            dispatch_group_leave(group);
        }];
    }
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        completion([results copy]);
    });
}

- (void)calculateProductMetricsWithProducts:(NSArray<Product *> *)products completion:(void (^)(ProductMetrics *metrics))completion {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // CPU密集型计算
        double totalPrice = 0;
        NSMutableDictionary<NSString *, NSNumber *> *categoryGroups = [NSMutableDictionary dictionary];
        NSMutableDictionary<NSString *, NSNumber *> *priceRanges = [NSMutableDictionary dictionary];
        
        for (Product *product in products) {
            totalPrice += product.price;
            
            // Category groups
            NSNumber *categoryCount = categoryGroups[product.category] ?: @0;
            categoryGroups[product.category] = @([categoryCount integerValue] + 1);
            
            // Price ranges
            NSString *priceRange;
            if (product.price < 50) {
                priceRange = @"Low";
            } else if (product.price < 100) {
                priceRange = @"Medium";
            } else {
                priceRange = @"High";
            }
            
            NSNumber *rangeCount = priceRanges[priceRange] ?: @0;
            priceRanges[priceRange] = @([rangeCount integerValue] + 1);
        }
        
        double averagePrice = products.count > 0 ? totalPrice / products.count : 0;
        
        ProductMetrics *metrics = [[ProductMetrics alloc] initWithTotalCount:products.count
                                                                averagePrice:averagePrice
                                                               categoryCount:categoryGroups.count
                                                      priceRangeDistribution:[priceRanges copy]];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(metrics);
        });
    });
}

- (NSInteger)generateId {
    return arc4random_uniform(10000) + 1;
}

@end

// 异步订单服务
@interface AsyncOrderService : NSObject
@property (nonatomic, strong) dispatch_queue_t queue;
@property (nonatomic, strong) AsyncProductService *productService;
- (void)createOrderWithUserId:(NSInteger)userId products:(NSArray<Product *> *)products completion:(void (^)(Order *order))completion;
- (void)processOrderPipelineWithUserId:(NSInteger)userId productIds:(NSArray<NSNumber *> *)productIds completion:(void (^)(OrderPipelineResult *result))completion;
- (void)batchProcessOrdersWithRequests:(NSArray<OrderRequest *> *)orderRequests completion:(void (^)(NSArray<OrderResult *> *results))completion;
- (void)checkInventoryForProductId:(NSInteger)productId completion:(void (^)(BOOL available))completion;
- (void)processPaymentWithAmount:(double)amount completion:(void (^)(BOOL success))completion;
- (void)updateInventoryWithProducts:(NSArray<Product *> *)products completion:(void (^)(BOOL success))completion;
- (void)sendNotificationWithUserId:(NSInteger)userId orderId:(NSInteger)orderId completion:(void (^)(BOOL success))completion;
- (void)recordAnalyticsWithOrder:(Order *)order completion:(void (^)(BOOL success))completion;
- (NSInteger)generateId;
@end

@implementation AsyncOrderService

- (instancetype)init {
    self = [super init];
    if (self) {
        _queue = dispatch_queue_create("async.order.service.queue", DISPATCH_QUEUE_CONCURRENT);
        _productService = [[AsyncProductService alloc] init];
    }
    return self;
}

- (void)createOrderWithUserId:(NSInteger)userId products:(NSArray<Product *> *)products completion:(void (^)(Order *order))completion {
    dispatch_async(self.queue, ^{
        usleep(25000); // 25ms delay
        double total = 0;
        for (Product *product in products) {
            total += product.price;
        }
        Order *order = [[Order alloc] initWithId:[self generateId] userId:userId products:products total:total];
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(order);
        });
    });
}

- (void)processOrderPipelineWithUserId:(NSInteger)userId productIds:(NSArray<NSNumber *> *)productIds completion:(void (^)(OrderPipelineResult *result))completion {
    OrderPipelineResult *pipelineResult = [[OrderPipelineResult alloc] init];
    
    // 第一阶段：并行获取产品信息
    [self.productService batchProcessProductsWithIds:productIds completion:^(NSDictionary<NSNumber *, Product *> *productResults) {
        NSMutableArray<Product *> *products = [NSMutableArray array];
        for (NSNumber *productId in productIds) {
            Product *product = productResults[productId];
            if (product) {
                [products addObject:product];
            }
        }
        
        if (products.count != productIds.count) {
            pipelineResult.isSuccess = NO;
            pipelineResult.errorMessage = @"Some products not found";
            completion(pipelineResult);
            return;
        }
        
        // 第二阶段：验证库存（并行）
        dispatch_group_t inventoryGroup = dispatch_group_create();
        __block BOOL allInventoryAvailable = YES;
        
        for (Product *product in products) {
            dispatch_group_enter(inventoryGroup);
            [self checkInventoryForProductId:product.productId completion:^(BOOL available) {
                if (!available) {
                    allInventoryAvailable = NO;
                }
                dispatch_group_leave(inventoryGroup);
            }];
        }
        
        dispatch_group_notify(inventoryGroup, self.queue, ^{
            if (!allInventoryAvailable) {
                pipelineResult.isSuccess = NO;
                pipelineResult.errorMessage = @"Insufficient inventory";
                dispatch_async(dispatch_get_main_queue(), ^{
                    completion(pipelineResult);
                });
                return;
            }
            
            // 第三阶段：创建订单和处理支付（串行）
            [self createOrderWithUserId:userId products:[products copy] completion:^(Order *order) {
                [self processPaymentWithAmount:order.total completion:^(BOOL paymentSuccess) {
                    if (!paymentSuccess) {
                        pipelineResult.isSuccess = NO;
                        pipelineResult.errorMessage = @"Payment failed";
                        completion(pipelineResult);
                        return;
                    }
                    
                    // 第四阶段：并行执行后续操作
                    dispatch_group_t finalGroup = dispatch_group_create();
                    
                    dispatch_group_enter(finalGroup);
                    [self updateInventoryWithProducts:[products copy] completion:^(BOOL success) {
                        dispatch_group_leave(finalGroup);
                    }];
                    
                    dispatch_group_enter(finalGroup);
                    [self sendNotificationWithUserId:userId orderId:order.orderId completion:^(BOOL success) {
                        dispatch_group_leave(finalGroup);
                    }];
                    
                    dispatch_group_enter(finalGroup);
                    [self recordAnalyticsWithOrder:order completion:^(BOOL success) {
                        dispatch_group_leave(finalGroup);
                    }];
                    
                    dispatch_group_notify(finalGroup, dispatch_get_main_queue(), ^{
                        pipelineResult.isSuccess = YES;
                        pipelineResult.order = order;
                        completion(pipelineResult);
                    });
                }];
            }];
        });
    }];
}

- (void)batchProcessOrdersWithRequests:(NSArray<OrderRequest *> *)orderRequests completion:(void (^)(NSArray<OrderResult *> *results))completion {
    // 使用信号量限制并发数
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(10);
    dispatch_group_t group = dispatch_group_create();
    NSMutableArray<OrderResult *> *results = [NSMutableArray array];
    NSLock *lock = [[NSLock alloc] init];
    
    for (OrderRequest *request in orderRequests) {
        dispatch_group_enter(group);
        dispatch_async(self.queue, ^{
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
            
            [self processOrderPipelineWithUserId:request.userId productIds:request.productIds completion:^(OrderPipelineResult *pipelineResult) {
                OrderResult *orderResult = [[OrderResult alloc] init];
                orderResult.userId = request.userId;
                orderResult.isSuccess = pipelineResult.isSuccess;
                
                if (pipelineResult.isSuccess) {
                    orderResult.order = pipelineResult.order;
                } else {
                    orderResult.errorMessage = pipelineResult.errorMessage;
                }
                
                [lock lock];
                [results addObject:orderResult];
                [lock unlock];
                
                dispatch_semaphore_signal(semaphore);
                dispatch_group_leave(group);
            }];
        });
    }
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        completion([results copy]);
    });
}

- (void)checkInventoryForProductId:(NSInteger)productId completion:(void (^)(BOOL available))completion {
    dispatch_async(self.queue, ^{
        usleep(10000); // 10ms delay
        BOOL available = productId % 10 != 0; // 模拟库存检查
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(available);
        });
    });
}

- (void)processPaymentWithAmount:(double)amount completion:(void (^)(BOOL success))completion {
    dispatch_async(self.queue, ^{
        usleep(100000); // 100ms delay - 支付处理较慢
        BOOL success = amount > 0;
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(success);
        });
    });
}

- (void)updateInventoryWithProducts:(NSArray<Product *> *)products completion:(void (^)(BOOL success))completion {
    dispatch_async(self.queue, ^{
        usleep(20000); // 20ms delay
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(YES);
        });
    });
}

- (void)sendNotificationWithUserId:(NSInteger)userId orderId:(NSInteger)orderId completion:(void (^)(BOOL success))completion {
    dispatch_async(self.queue, ^{
        usleep(15000); // 15ms delay
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(YES);
        });
    });
}

- (void)recordAnalyticsWithOrder:(Order *)order completion:(void (^)(BOOL success))completion {
    dispatch_async(self.queue, ^{
        usleep(5000); // 5ms delay
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(YES);
        });
    });
}

- (NSInteger)generateId {
    return arc4random_uniform(10000) + 1;
}

@end

// 异步基准测试服务
@interface AsyncBenchmarkService : NSObject
@property (nonatomic, strong) AsyncUserService *userService;
@property (nonatomic, strong) AsyncProductService *productService;
@property (nonatomic, strong) AsyncOrderService *orderService;
- (void)runComplexAsyncWorkflowWithIterations:(NSInteger)iterations completion:(void (^)(void))completion;
- (void)runConcurrentStressTestWithConcurrencyLevel:(NSInteger)concurrencyLevel operations:(NSInteger)operations completion:(void (^)(void))completion;
@end

@implementation AsyncBenchmarkService

- (instancetype)init {
    self = [super init];
    if (self) {
        _userService = [[AsyncUserService alloc] init];
        _productService = [[AsyncProductService alloc] init];
        _orderService = [[AsyncOrderService alloc] init];
    }
    return self;
}

- (void)runComplexAsyncWorkflowWithIterations:(NSInteger)iterations completion:(void (^)(void))completion {
    NSLog(@"Starting complex async workflow with %ld iterations...", (long)iterations);
    
    // 第一阶段：并行用户工作流
    dispatch_group_t userGroup = dispatch_group_create();
    NSMutableArray<WorkflowResult *> *userResults = [NSMutableArray array];
    NSLock *userLock = [[NSLock alloc] init];
    
    for (NSInteger i = 1; i <= iterations; i++) {
        dispatch_group_enter(userGroup);
        [self.userService processUserWorkflowWithIndex:i completion:^(WorkflowResult *result) {
            [userLock lock];
            [userResults addObject:result];
            [userLock unlock];
            dispatch_group_leave(userGroup);
        }];
    }
    
    dispatch_group_notify(userGroup, dispatch_get_main_queue(), ^{
        NSArray<WorkflowResult *> *successfulUsers = [userResults filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"isSuccess == YES"]];
        NSLog(@"User workflows completed: %ld/%ld successful", (long)successfulUsers.count, (long)userResults.count);
        
        // 第二阶段：产品批处理
        NSMutableArray<NSNumber *> *productIds = [NSMutableArray array];
        for (NSInteger i = 1; i <= 100; i++) {
            [productIds addObject:@(i)];
        }
        
        [self.productService batchProcessProductsWithIds:[productIds copy] completion:^(NSDictionary<NSNumber *, Product *> *productResults) {
            NSArray<Product *> *products = [productResults.allValues filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF != nil"]];
            
            // 第四阶段：产品指标计算
            [self.productService calculateProductMetricsWithProducts:products completion:^(ProductMetrics *metrics) {
                
                // 第五阶段：批量订单处理
                NSMutableArray<OrderRequest *> *orderRequests = [NSMutableArray array];
                NSInteger maxOrders = MIN(20, successfulUsers.count);
                
                for (NSInteger i = 0; i < maxOrders; i++) {
                    WorkflowResult *userResult = successfulUsers[i];
                    NSInteger productCount = 3 + (i % 5);
                    NSArray<NSNumber *> *requestProductIds = [productIds subarrayWithRange:NSMakeRange(0, productCount)];
                    
                    OrderRequest *request = [[OrderRequest alloc] initWithUserId:userResult.createdUser.userId productIds:requestProductIds];
                    [orderRequests addObject:request];
                }
                
                [self.orderService batchProcessOrdersWithRequests:[orderRequests copy] completion:^(NSArray<OrderResult *> *orderResults) {
                    NSArray<OrderResult *> *successfulOrders = [orderResults filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"isSuccess == YES"]];
                    
                    double totalRevenue = 0;
                    for (OrderResult *result in successfulOrders) {
                        totalRevenue += result.order.total;
                    }
                    
                    NSLog(@"Async workflow completed:");
                    NSLog(@"- User workflows: %ld", (long)successfulUsers.count);
                    NSLog(@"- Products processed: %ld", (long)products.count);
                    NSLog(@"- Average product price: %.2f", metrics.averagePrice);
                    NSLog(@"- Orders processed: %ld/%ld", (long)successfulOrders.count, (long)orderResults.count);
                    NSLog(@"- Total revenue: %.2f", totalRevenue);
                    
                    completion();
                }];
            }];
        }];
    });
}

- (void)runConcurrentStressTestWithConcurrencyLevel:(NSInteger)concurrencyLevel operations:(NSInteger)operations completion:(void (^)(void))completion {
    NSLog(@"Starting concurrent stress test: %ld concurrent workers, %ld operations each", (long)concurrencyLevel, (long)operations);
    
    dispatch_group_t workerGroup = dispatch_group_create();
    dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    __block NSInteger totalSuccess = 0;
    __block NSInteger totalErrors = 0;
    NSLock *statsLock = [[NSLock alloc] init];
    
    for (NSInteger workerId = 1; workerId <= concurrencyLevel; workerId++) {
        dispatch_group_enter(workerGroup);
        dispatch_async(globalQueue, ^{
            __block NSInteger successCount = 0;
            __block NSInteger errorCount = 0;
            
            for (NSInteger opIndex = 0; opIndex < operations; opIndex++) {
                dispatch_semaphore_t opSemaphore = dispatch_semaphore_create(0);
                
                switch (opIndex % 4) {
                    case 0: {
                        [self.userService createUserWithName:[NSString stringWithFormat:@"Worker%ld_User%ld", (long)workerId, (long)opIndex]
                                                       email:[NSString stringWithFormat:@"email%ld@test.com", (long)opIndex]
                                                         age:25
                                                  completion:^(User *user) {
                            [self.userService updateUser:user completion:^(User *updatedUser) {
                                successCount++;
                                dispatch_semaphore_signal(opSemaphore);
                            }];
                        }];
                        break;
                    }
                    case 1: {
                        [self.productService createProductWithName:[NSString stringWithFormat:@"Product%ld", (long)opIndex]
                                                             price:99.99
                                                          category:[NSString stringWithFormat:@"Category%ld", (long)(opIndex % 5)]
                                                        completion:^(Product *product) {
                            [self.productService updateProduct:product completion:^(Product *updatedProduct) {
                                successCount++;
                                dispatch_semaphore_signal(opSemaphore);
                            }];
                        }];
                        break;
                    }
                    case 2: {
                        [self.productService getProductsByCategory:[NSString stringWithFormat:@"Category%ld", (long)(opIndex % 5)] completion:^(NSArray<Product *> *products) {
                            successCount++;
                            dispatch_semaphore_signal(opSemaphore);
                        }];
                        break;
                    }
                    case 3: {
                        [self.userService searchUsersWithQuery:@"User" completion:^(NSArray<User *> *users) {
                            successCount++;
                            dispatch_semaphore_signal(opSemaphore);
                        }];
                        break;
                    }
                }
                
                dispatch_semaphore_wait(opSemaphore, DISPATCH_TIME_FOREVER);
            }
            
            [statsLock lock];
            totalSuccess += successCount;
            totalErrors += errorCount;
            [statsLock unlock];
            
            NSLog(@"Worker %ld: %ld successes, %ld errors", (long)workerId, (long)successCount, (long)errorCount);
            dispatch_group_leave(workerGroup);
        });
    }
    
    dispatch_group_notify(workerGroup, dispatch_get_main_queue(), ^{
        NSLog(@"Stress test completed: %ld successes, %ld errors", (long)totalSuccess, (long)totalErrors);
        completion();
    });
}

@end

// iOS Size Benchmark 主类
@interface IosSizeBenchmark : NSObject
@property (nonatomic, strong) AsyncBenchmarkService *benchmarkService;
- (void)runBenchmark;
@end

@implementation IosSizeBenchmark

- (instancetype)init {
    self = [super init];
    if (self) {
        _benchmarkService = [[AsyncBenchmarkService alloc] init];
    }
    return self;
}

- (void)runBenchmark {
    // 运行复杂异步工作流
    [self.benchmarkService runComplexAsyncWorkflowWithIterations:50 completion:^{
        // 运行并发压力测试
        [self.benchmarkService runConcurrentStressTestWithConcurrencyLevel:10 operations:20 completion:^{
            NSLog(@"All benchmarks completed");
        }];
    }];
}

@end