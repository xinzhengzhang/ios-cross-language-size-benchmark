/*
 * iOS Size Benchmark - Test Case Implementation
 * Generated with Claude AI (https://claude.ai)
 * 
 * This Objective-C implementation demonstrates language-specific
 * features and patterns for binary size comparison.
 */

#import <Foundation/Foundation.h>

// Objective-C 协议导向编程 vs 继承层次对比
// 使用protocol模拟Swift的协议导向编程

// 协议定义
@protocol Drawable <NSObject>
- (NSString *)draw;
- (double)area;
@end

@protocol Colorable <NSObject>
@property (nonatomic, strong) NSString *color;
- (void)applyColor:(NSString *)color;
@end

@protocol Transformable <NSObject>
- (void)transformWithScale:(double)scale rotation:(double)rotation;
@end

@protocol Animatable <NSObject>
- (NSString *)animateWithDuration:(double)duration;
@end

// 组合协议（通过继承多个协议）
@protocol AdvancedShape <Drawable, Colorable, Transformable, Animatable>
@property (nonatomic, readonly) NSString *shapeId;
@end

// 协议的分类扩展提供默认实现
@interface NSObject (DrawableExtensions)
- (NSString *)shapeDescription;
@end

@implementation NSObject (DrawableExtensions)
- (NSString *)shapeDescription {
    if ([self conformsToProtocol:@protocol(Drawable)]) {
        id<Drawable> drawable = (id<Drawable>)self;
        return [NSString stringWithFormat:@"Shape with area: %.2f", [drawable area]];
    }
    return @"Unknown shape";
}
@end

@interface NSObject (ColorableExtensions)
- (void)defaultApplyColor:(NSString *)color;
@end

@implementation NSObject (ColorableExtensions)
- (void)defaultApplyColor:(NSString *)color {
    if ([self conformsToProtocol:@protocol(Colorable)]) {
        id<Colorable> colorable = (id<Colorable>)self;
        colorable.color = color;
    }
}
@end

@interface NSObject (AnimatableExtensions)
- (NSString *)defaultAnimateWithDuration:(double)duration;
@end

@implementation NSObject (AnimatableExtensions)
- (NSString *)defaultAnimateWithDuration:(double)duration {
    return [NSString stringWithFormat:@"Animating for %.1f seconds", duration];
}
@end

// 实现协议的类
@interface Circle : NSObject <AdvancedShape>
@property (nonatomic, readonly) NSString *shapeId;
@property (nonatomic, strong) NSString *color;
@property (nonatomic, assign) double radius;
@property (nonatomic, assign) double scale;
@property (nonatomic, assign) double rotation;
- (instancetype)initWithId:(NSString *)shapeId radius:(double)radius color:(NSString *)color;
@end

@implementation Circle
- (instancetype)initWithId:(NSString *)shapeId radius:(double)radius color:(NSString *)color {
    self = [super init];
    if (self) {
        _shapeId = [shapeId copy];
        _radius = radius;
        _color = [color copy];
        _scale = 1.0;
        _rotation = 0.0;
    }
    return self;
}

- (NSString *)draw {
    return [NSString stringWithFormat:@"Drawing circle with radius %.2f at rotation %.2f", 
            self.radius * self.scale, self.rotation];
}

- (double)area {
    return M_PI * self.radius * self.radius * self.scale * self.scale;
}

- (void)transformWithScale:(double)scale rotation:(double)rotation {
    self.scale *= scale;
    self.rotation += rotation;
}

- (void)applyColor:(NSString *)color {
    self.color = color;
}

- (NSString *)animateWithDuration:(double)duration {
    return [self defaultAnimateWithDuration:duration];
}

- (NSUInteger)hash {
    return [self.shapeId hash] ^ [@(self.radius) hash];
}

- (BOOL)isEqual:(id)object {
    if (![object isKindOfClass:[Circle class]]) return NO;
    Circle *other = (Circle *)object;
    return [self.shapeId isEqualToString:other.shapeId] && self.radius == other.radius;
}
@end

@interface Rectangle : NSObject <AdvancedShape>
@property (nonatomic, readonly) NSString *shapeId;
@property (nonatomic, strong) NSString *color;
@property (nonatomic, assign) double width;
@property (nonatomic, assign) double height;
@property (nonatomic, assign) double scale;
@property (nonatomic, assign) double rotation;
- (instancetype)initWithId:(NSString *)shapeId width:(double)width height:(double)height color:(NSString *)color;
@end

@implementation Rectangle
- (instancetype)initWithId:(NSString *)shapeId width:(double)width height:(double)height color:(NSString *)color {
    self = [super init];
    if (self) {
        _shapeId = [shapeId copy];
        _width = width;
        _height = height;
        _color = [color copy];
        _scale = 1.0;
        _rotation = 0.0;
    }
    return self;
}

- (NSString *)draw {
    return [NSString stringWithFormat:@"Drawing rectangle %.2fx%.2f at rotation %.2f", 
            self.width * self.scale, self.height * self.scale, self.rotation];
}

- (double)area {
    return self.width * self.height * self.scale * self.scale;
}

- (void)transformWithScale:(double)scale rotation:(double)rotation {
    self.scale *= scale;
    self.rotation += rotation;
}

- (void)applyColor:(NSString *)color {
    self.color = color;
}

- (NSString *)animateWithDuration:(double)duration {
    return [self defaultAnimateWithDuration:duration];
}

- (NSUInteger)hash {
    return [self.shapeId hash] ^ [@(self.width) hash] ^ [@(self.height) hash];
}

- (BOOL)isEqual:(id)object {
    if (![object isKindOfClass:[Rectangle class]]) return NO;
    Rectangle *other = (Rectangle *)object;
    return [self.shapeId isEqualToString:other.shapeId] && 
           self.width == other.width && self.height == other.height;
}
@end

@interface Triangle : NSObject <AdvancedShape>
@property (nonatomic, readonly) NSString *shapeId;
@property (nonatomic, strong) NSString *color;
@property (nonatomic, assign) double base;
@property (nonatomic, assign) double height;
@property (nonatomic, assign) double scale;
@property (nonatomic, assign) double rotation;
- (instancetype)initWithId:(NSString *)shapeId base:(double)base height:(double)height color:(NSString *)color;
@end

@implementation Triangle
- (instancetype)initWithId:(NSString *)shapeId base:(double)base height:(double)height color:(NSString *)color {
    self = [super init];
    if (self) {
        _shapeId = [shapeId copy];
        _base = base;
        _height = height;
        _color = [color copy];
        _scale = 1.0;
        _rotation = 0.0;
    }
    return self;
}

- (NSString *)draw {
    return [NSString stringWithFormat:@"Drawing triangle with base %.2f and height %.2f", 
            self.base * self.scale, self.height * self.scale];
}

- (double)area {
    return 0.5 * self.base * self.height * self.scale * self.scale;
}

- (void)transformWithScale:(double)scale rotation:(double)rotation {
    self.scale *= scale;
    self.rotation += rotation;
}

- (void)applyColor:(NSString *)color {
    self.color = color;
}

- (NSString *)animateWithDuration:(double)duration {
    return [self defaultAnimateWithDuration:duration];
}

- (NSUInteger)hash {
    return [self.shapeId hash] ^ [@(self.base) hash] ^ [@(self.height) hash];
}

- (BOOL)isEqual:(id)object {
    if (![object isKindOfClass:[Triangle class]]) return NO;
    Triangle *other = (Triangle *)object;
    return [self.shapeId isEqualToString:other.shapeId] && 
           self.base == other.base && self.height == other.height;
}
@end

// 继承层次方法（对比）
@interface InheritanceShape : NSObject
@property (nonatomic, readonly) NSString *shapeId;
@property (nonatomic, strong) NSString *color;
@property (nonatomic, assign) double scale;
@property (nonatomic, assign) double rotation;
- (instancetype)initWithId:(NSString *)shapeId color:(NSString *)color;
- (NSString *)draw; // 抽象方法，子类必须实现
- (double)area; // 抽象方法，子类必须实现
- (void)transformWithScale:(double)scale rotation:(double)rotation;
- (NSString *)animateWithDuration:(double)duration;
- (void)applyColor:(NSString *)color;
- (NSString *)shapeDescription;
@end

@implementation InheritanceShape
- (instancetype)initWithId:(NSString *)shapeId color:(NSString *)color {
    self = [super init];
    if (self) {
        _shapeId = [shapeId copy];
        _color = [color copy];
        _scale = 1.0;
        _rotation = 0.0;
    }
    return self;
}

- (NSString *)draw {
    @throw [NSException exceptionWithName:@"AbstractMethodException" 
                                   reason:@"Must be overridden" userInfo:nil];
}

- (double)area {
    @throw [NSException exceptionWithName:@"AbstractMethodException" 
                                   reason:@"Must be overridden" userInfo:nil];
}

- (void)transformWithScale:(double)scale rotation:(double)rotation {
    self.scale *= scale;
    self.rotation += rotation;
}

- (NSString *)animateWithDuration:(double)duration {
    return [NSString stringWithFormat:@"Animating %@ for %.1f seconds", 
            NSStringFromClass([self class]), duration];
}

- (void)applyColor:(NSString *)color {
    self.color = color;
}

- (NSString *)shapeDescription {
    return [NSString stringWithFormat:@"Shape with area: %.2f", [self area]];
}
@end

@interface InheritanceCircle : InheritanceShape
@property (nonatomic, assign) double radius;
- (instancetype)initWithId:(NSString *)shapeId color:(NSString *)color radius:(double)radius;
@end

@implementation InheritanceCircle
- (instancetype)initWithId:(NSString *)shapeId color:(NSString *)color radius:(double)radius {
    self = [super initWithId:shapeId color:color];
    if (self) {
        _radius = radius;
    }
    return self;
}

- (NSString *)draw {
    return [NSString stringWithFormat:@"Drawing circle with radius %.2f at rotation %.2f", 
            self.radius * self.scale, self.rotation];
}

- (double)area {
    return M_PI * self.radius * self.radius * self.scale * self.scale;
}
@end

@interface InheritanceRectangle : InheritanceShape
@property (nonatomic, assign) double width;
@property (nonatomic, assign) double height;
- (instancetype)initWithId:(NSString *)shapeId color:(NSString *)color width:(double)width height:(double)height;
@end

@implementation InheritanceRectangle
- (instancetype)initWithId:(NSString *)shapeId color:(NSString *)color width:(double)width height:(double)height {
    self = [super initWithId:shapeId color:color];
    if (self) {
        _width = width;
        _height = height;
    }
    return self;
}

- (NSString *)draw {
    return [NSString stringWithFormat:@"Drawing rectangle %.2fx%.2f at rotation %.2f", 
            self.width * self.scale, self.height * self.scale, self.rotation];
}

- (double)area {
    return self.width * self.height * self.scale * self.scale;
}
@end

@interface InheritanceTriangle : InheritanceShape
@property (nonatomic, assign) double base;
@property (nonatomic, assign) double triangleHeight;
- (instancetype)initWithId:(NSString *)shapeId color:(NSString *)color base:(double)base height:(double)height;
@end

@implementation InheritanceTriangle
- (instancetype)initWithId:(NSString *)shapeId color:(NSString *)color base:(double)base height:(double)height {
    self = [super initWithId:shapeId color:color];
    if (self) {
        _base = base;
        _triangleHeight = height;
    }
    return self;
}

- (NSString *)draw {
    return [NSString stringWithFormat:@"Drawing triangle with base %.2f and height %.2f", 
            self.base * self.scale, self.triangleHeight * self.scale];
}

- (double)area {
    return 0.5 * self.base * self.triangleHeight * self.scale * self.scale;
}
@end

// 形状处理器
@interface ShapeProcessor : NSObject
- (NSArray<NSString *> *)processShapes:(NSArray<id<AdvancedShape>> *)shapes;
- (id<AdvancedShape>)findLargestShape:(NSArray<id<AdvancedShape>> *)shapes;
- (NSArray<NSString *> *)processDrawableColorableShapes:(NSArray<id<AdvancedShape>> *)shapes;
@end

@implementation ShapeProcessor
- (NSArray<NSString *> *)processShapes:(NSArray<id<AdvancedShape>> *)shapes {
    NSMutableArray<NSString *> *results = [NSMutableArray array];
    for (id<AdvancedShape> shape in shapes) {
        NSString *result = [NSString stringWithFormat:@"%@: %@ - Area: %.2f - %@", 
                           shape.shapeId, [shape draw], [shape area], [shape animateWithDuration:1.0]];
        [results addObject:result];
    }
    return [results copy];
}

- (id<AdvancedShape>)findLargestShape:(NSArray<id<AdvancedShape>> *)shapes {
    id<AdvancedShape> largest = nil;
    double maxArea = 0.0;
    
    for (id<AdvancedShape> shape in shapes) {
        double area = [shape area];
        if (area > maxArea) {
            maxArea = area;
            largest = shape;
        }
    }
    
    return largest;
}

- (NSArray<NSString *> *)processDrawableColorableShapes:(NSArray<id<AdvancedShape>> *)shapes {
    NSMutableArray<NSString *> *results = [NSMutableArray array];
    for (id<AdvancedShape> shape in shapes) {
        NSString *result = [NSString stringWithFormat:@"%@ with color %@", [shape draw], shape.color];
        [results addObject:result];
    }
    return [results copy];
}
@end

// 协议性能测试
@interface ProtocolPerformanceTester : NSObject
- (NSTimeInterval)testProtocolDispatch:(NSArray<id<AdvancedShape>> *)shapes iterations:(NSInteger)iterations;
- (NSTimeInterval)testInheritanceDispatch:(NSArray<InheritanceShape *> *)shapes iterations:(NSInteger)iterations;
- (NSTimeInterval)testConcreteDispatch:(NSArray<Circle *> *)circles iterations:(NSInteger)iterations;
@end

@implementation ProtocolPerformanceTester
- (NSTimeInterval)testProtocolDispatch:(NSArray<id<AdvancedShape>> *)shapes iterations:(NSInteger)iterations {
    NSDate *startTime = [NSDate date];
    
    for (NSInteger i = 0; i < iterations; i++) {
        double totalArea = 0.0;
        for (id<AdvancedShape> shape in shapes) {
            totalArea += [shape area];
            [shape draw];
            [shape animateWithDuration:0.1];
        }
    }
    
    NSDate *endTime = [NSDate date];
    return [endTime timeIntervalSinceDate:startTime];
}

- (NSTimeInterval)testInheritanceDispatch:(NSArray<InheritanceShape *> *)shapes iterations:(NSInteger)iterations {
    NSDate *startTime = [NSDate date];
    
    for (NSInteger i = 0; i < iterations; i++) {
        double totalArea = 0.0;
        for (InheritanceShape *shape in shapes) {
            totalArea += [shape area];
            [shape draw];
            [shape animateWithDuration:0.1];
        }
    }
    
    NSDate *endTime = [NSDate date];
    return [endTime timeIntervalSinceDate:startTime];
}

- (NSTimeInterval)testConcreteDispatch:(NSArray<Circle *> *)circles iterations:(NSInteger)iterations {
    NSDate *startTime = [NSDate date];
    
    for (NSInteger i = 0; i < iterations; i++) {
        double totalArea = 0.0;
        for (Circle *circle in circles) {
            totalArea += [circle area];
            [circle draw];
            [circle animateWithDuration:0.1];
        }
    }
    
    NSDate *endTime = [NSDate date];
    return [endTime timeIntervalSinceDate:startTime];
}
@end

// 工厂协议
@protocol ShapeFactory <NSObject>
- (id)createShapeWithId:(NSString *)shapeId;
@end

@interface CircleFactory : NSObject <ShapeFactory>
@end

@implementation CircleFactory
- (id)createShapeWithId:(NSString *)shapeId {
    double radius = 1.0 + (arc4random() % 10);
    return [[Circle alloc] initWithId:shapeId radius:radius color:@"red"];
}
@end

@interface RectangleFactory : NSObject <ShapeFactory>
@end

@implementation RectangleFactory
- (id)createShapeWithId:(NSString *)shapeId {
    double width = 1.0 + (arc4random() % 10);
    double height = 1.0 + (arc4random() % 10);
    return [[Rectangle alloc] initWithId:shapeId width:width height:height color:@"blue"];
}
@end

@interface ProtocolOrientedBenchmark : NSObject
- (void)runProtocolOrientedComparison;
@end

@implementation ProtocolOrientedBenchmark {
    ShapeProcessor *_processor;
    ProtocolPerformanceTester *_performanceTester;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _processor = [[ShapeProcessor alloc] init];
        _performanceTester = [[ProtocolPerformanceTester alloc] init];
    }
    return self;
}

- (void)runProtocolOrientedComparison {
    NSLog(@"Running protocol-oriented vs inheritance comparison...");
    
    NSInteger count = 1000;
    
    // 创建协议导向的形状
    NSMutableArray<id<AdvancedShape>> *protocolShapes = [NSMutableArray array];
    for (NSInteger i = 0; i < count; i++) {
        switch (i % 3) {
            case 0:
                [protocolShapes addObject:[[Circle alloc] initWithId:[NSString stringWithFormat:@"circle_%ld", (long)i]
                                                              radius:(i % 10 + 1)
                                                               color:@"red"]];
                break;
            case 1:
                [protocolShapes addObject:[[Rectangle alloc] initWithId:[NSString stringWithFormat:@"rect_%ld", (long)i]
                                                                  width:(i % 8 + 1)
                                                                 height:(i % 6 + 1)
                                                                  color:@"blue"]];
                break;
            case 2:
                [protocolShapes addObject:[[Triangle alloc] initWithId:[NSString stringWithFormat:@"triangle_%ld", (long)i]
                                                                  base:(i % 7 + 1)
                                                                height:(i % 5 + 1)
                                                                 color:@"green"]];
                break;
        }
    }
    
    // 创建继承层次的形状
    NSMutableArray<InheritanceShape *> *inheritanceShapes = [NSMutableArray array];
    for (NSInteger i = 0; i < count; i++) {
        switch (i % 3) {
            case 0:
                [inheritanceShapes addObject:[[InheritanceCircle alloc] initWithId:[NSString stringWithFormat:@"circle_%ld", (long)i]
                                                                              color:@"red"
                                                                             radius:(i % 10 + 1)]];
                break;
            case 1:
                [inheritanceShapes addObject:[[InheritanceRectangle alloc] initWithId:[NSString stringWithFormat:@"rect_%ld", (long)i]
                                                                                 color:@"blue"
                                                                                 width:(i % 8 + 1)
                                                                                height:(i % 6 + 1)]];
                break;
            case 2:
                [inheritanceShapes addObject:[[InheritanceTriangle alloc] initWithId:[NSString stringWithFormat:@"triangle_%ld", (long)i]
                                                                                color:@"green"
                                                                                 base:(i % 7 + 1)
                                                                               height:(i % 5 + 1)]];
                break;
        }
    }
    
    // 测试处理性能
    NSLog(@"Testing processing performance...");
    NSArray<NSString *> *protocolResults = [_processor processShapes:[protocolShapes subarrayWithRange:NSMakeRange(0, 10)]];
    id<AdvancedShape> largestProtocolShape = [_processor findLargestShape:protocolShapes];
    
    // 提取具体类型
    NSMutableArray<Circle *> *circles = [NSMutableArray array];
    NSMutableArray<Rectangle *> *rectangles = [NSMutableArray array];
    
    for (id<AdvancedShape> shape in protocolShapes) {
        if ([shape isKindOfClass:[Circle class]]) {
            [circles addObject:(Circle *)shape];
        } else if ([shape isKindOfClass:[Rectangle class]]) {
            [rectangles addObject:(Rectangle *)shape];
        }
    }
    
    // 性能基准测试
    NSLog(@"Running performance benchmarks...");
    NSTimeInterval protocolTime = [_performanceTester testProtocolDispatch:protocolShapes iterations:100];
    NSTimeInterval inheritanceTime = [_performanceTester testInheritanceDispatch:inheritanceShapes iterations:100];
    NSTimeInterval concreteTime = [_performanceTester testConcreteDispatch:circles iterations:100];
    
    // 测试工厂模式
    CircleFactory *circleFactory = [[CircleFactory alloc] init];
    RectangleFactory *rectangleFactory = [[RectangleFactory alloc] init];
    
    NSMutableArray *factoryCircles = [NSMutableArray array];
    NSMutableArray *factoryRectangles = [NSMutableArray array];
    
    for (NSInteger i = 0; i < 100; i++) {
        [factoryCircles addObject:[circleFactory createShapeWithId:[NSString stringWithFormat:@"factory_circle_%ld", (long)i]]];
        [factoryRectangles addObject:[rectangleFactory createShapeWithId:[NSString stringWithFormat:@"factory_rect_%ld", (long)i]]];
    }
    
    // 模拟排序（按面积）
    NSArray<Circle *> *sortedCircles = [circles sortedArrayUsingComparator:^NSComparisonResult(Circle *obj1, Circle *obj2) {
        double area1 = [obj1 area];
        double area2 = [obj2 area];
        if (area1 < area2) return NSOrderedAscending;
        if (area1 > area2) return NSOrderedDescending;
        return NSOrderedSame;
    }];
    
    NSLog(@"Protocol-oriented benchmark completed:");
    NSLog(@"- Protocol shapes: %ld", (long)protocolShapes.count);
    NSLog(@"- Inheritance shapes: %ld", (long)inheritanceShapes.count);
    NSLog(@"- Protocol results: %ld", (long)protocolResults.count);
    NSLog(@"- Largest shape area: %.2f", [largestProtocolShape area]);
    NSLog(@"- Circles: %ld", (long)circles.count);
    NSLog(@"- Rectangles: %ld", (long)rectangles.count);
    NSLog(@"- Protocol dispatch time: %.3fs", protocolTime);
    NSLog(@"- Inheritance dispatch time: %.3fs", inheritanceTime);
    NSLog(@"- Concrete dispatch time: %.3fs", concreteTime);
    NSLog(@"- Factory circles: %ld", (long)factoryCircles.count);
    NSLog(@"- Factory rectangles: %ld", (long)factoryRectangles.count);
    NSLog(@"- Sorted circles: %ld", (long)sortedCircles.count);
    
    // 协议开销分析
    double protocolOverhead = (protocolTime - concreteTime) / concreteTime * 100;
    double inheritanceOverhead = (inheritanceTime - concreteTime) / concreteTime * 100;
    
    NSLog(@"Performance overhead analysis:");
    NSLog(@"- Protocol overhead vs concrete: %.2f%%", protocolOverhead);
    NSLog(@"- Inheritance overhead vs concrete: %.2f%%", inheritanceOverhead);
}

@end

@interface IosSizeBenchmark : NSObject
@property (nonatomic, strong) ProtocolOrientedBenchmark *benchmark;
- (void)runBenchmark;
@end

@implementation IosSizeBenchmark

- (instancetype)init {
    self = [super init];
    if (self) {
        _benchmark = [[ProtocolOrientedBenchmark alloc] init];
    }
    return self;
}

- (void)runBenchmark {
    [self.benchmark runProtocolOrientedComparison];
}

@end