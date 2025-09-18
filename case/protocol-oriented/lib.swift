/*
 * iOS Size Benchmark - Test Case Implementation
 * Generated with Claude AI (https://claude.ai)
 * 
 * This Swift implementation demonstrates language-specific
 * features and patterns for binary size comparison.
 */

import Foundation

// Swift 协议导向编程 vs 继承层次对比

// 协议导向方法
public protocol Drawable {
    func draw() -> String
    func area() -> Double
}

public protocol Colorable {
    var color: String { get set }
    mutating func applyColor(_ color: String)
}

public protocol Transformable {
    mutating func transform(scale: Double, rotation: Double)
}

public protocol Animatable {
    func animate(duration: Double) -> String
}

// 组合多个协议
public protocol AdvancedShape: Drawable, Colorable, Transformable, Animatable {
    var id: String { get }
}

// 协议扩展提供默认实现
public extension Drawable {
    func shapeDescription() -> String {
        return "Shape with area: \(area())"
    }
}

public extension Colorable {
    mutating func applyColor(_ color: String) {
        self.color = color
    }
}

public extension Animatable {
    func animate(duration: Double) -> String {
        return "Animating for \(duration) seconds"
    }
}

// 值类型实现协议
public struct Circle: AdvancedShape {
    public let id: String
    public let radius: Double
    public var color: String
    private var scale: Double = 1.0
    private var rotation: Double = 0.0
    
    public init(id: String, radius: Double, color: String) {
        self.id = id
        self.radius = radius
        self.color = color
    }
    
    public func draw() -> String {
        return "Drawing circle with radius \(radius * scale) at rotation \(rotation)"
    }
    
    public func area() -> Double {
        return Double.pi * radius * radius * scale * scale
    }
    
    public mutating func transform(scale: Double, rotation: Double) {
        self.scale *= scale
        self.rotation += rotation
    }
    
    public mutating func applyColor(_ color: String) {
        self.color = color
    }
}

public struct Rectangle: AdvancedShape {
    public let id: String
    public let width: Double
    public let height: Double
    public var color: String
    private var scale: Double = 1.0
    private var rotation: Double = 0.0
    
    public init(id: String, width: Double, height: Double, color: String) {
        self.id = id
        self.width = width
        self.height = height
        self.color = color
    }
    
    public func draw() -> String {
        return "Drawing rectangle \(width * scale)x\(height * scale) at rotation \(rotation)"
    }
    
    public func area() -> Double {
        return width * height * scale * scale
    }
    
    public mutating func transform(scale: Double, rotation: Double) {
        self.scale *= scale
        self.rotation += rotation
    }
    
    public mutating func applyColor(_ color: String) {
        self.color = color
    }
}

public struct Triangle: AdvancedShape {
    public let id: String
    public let base: Double
    public let height: Double
    public var color: String
    private var scale: Double = 1.0
    private var rotation: Double = 0.0
    
    public init(id: String, base: Double, height: Double, color: String) {
        self.id = id
        self.base = base
        self.height = height
        self.color = color
    }
    
    public func draw() -> String {
        return "Drawing triangle with base \(base * scale) and height \(height * scale)"
    }
    
    public func area() -> Double {
        return 0.5 * base * height * scale * scale
    }
    
    public mutating func transform(scale: Double, rotation: Double) {
        self.scale *= scale
        self.rotation += rotation
    }
    
    public mutating func applyColor(_ color: String) {
        self.color = color
    }
}

// 继承层次方法（对比）
public class InheritanceShape {
    public let id: String
    public var color: String
    private var scale: Double = 1.0
    private var rotation: Double = 0.0
    
    public init(id: String, color: String) {
        self.id = id
        self.color = color
    }
    
    public func draw() -> String {
        fatalError("Must be overridden")
    }
    
    public func area() -> Double {
        fatalError("Must be overridden")
    }
    
    public func transform(scale: Double, rotation: Double) {
        self.scale *= scale
        self.rotation += rotation
    }
    
    public func animate(duration: Double) -> String {
        return "Animating \(type(of: self)) for \(duration) seconds"
    }
    
    public func applyColor(_ color: String) {
        self.color = color
    }
    
    public func shapeDescription() -> String {
        return "Shape with area: \(area())"
    }
    
    public var currentScale: Double { return scale }
    public var currentRotation: Double { return rotation }
}

public class InheritanceCircle: InheritanceShape {
    public let radius: Double
    
    public init(id: String, color: String, radius: Double) {
        self.radius = radius
        super.init(id: id, color: color)
    }
    
    public override func draw() -> String {
        return "Drawing circle with radius \(radius * currentScale) at rotation \(currentRotation)"
    }
    
    public override func area() -> Double {
        return Double.pi * radius * radius * currentScale * currentScale
    }
}

public class InheritanceRectangle: InheritanceShape {
    public let width: Double
    public let height: Double
    
    public init(id: String, color: String, width: Double, height: Double) {
        self.width = width
        self.height = height
        super.init(id: id, color: color)
    }
    
    public override func draw() -> String {
        return "Drawing rectangle \(width * currentScale)x\(height * currentScale) at rotation \(currentRotation)"
    }
    
    public override func area() -> Double {
        return width * height * currentScale * currentScale
    }
}

public class InheritanceTriangle: InheritanceShape {
    public let base: Double
    public let height: Double
    
    public init(id: String, color: String, base: Double, height: Double) {
        self.base = base
        self.height = height
        super.init(id: id, color: color)
    }
    
    public override func draw() -> String {
        return "Drawing triangle with base \(base * currentScale) and height \(height * currentScale)"
    }
    
    public override func area() -> Double {
        return 0.5 * base * height * currentScale * currentScale
    }
}

// 泛型协议处理
public struct ShapeProcessor {
    // 使用协议约束的泛型函数
    public func processShapes<T: AdvancedShape>(_ shapes: [T]) -> [String] {
        return shapes.map { shape in
            "\(shape.id): \(shape.draw()) - Area: \(shape.area()) - \(shape.animate(duration: 1.0))"
        }
    }
    
    // 使用存在类型的函数
    public func processAnyShapes(_ shapes: [any AdvancedShape]) -> [String] {
        return shapes.map { shape in
            "\(shape.id): \(shape.draw()) - Area: \(shape.area()) - \(shape.animate(duration: 1.0))"
        }
    }
    
    // 协议作为类型使用
    public func findLargestShape(in shapes: [any AdvancedShape]) -> (any AdvancedShape)? {
        return shapes.max { $0.area() < $1.area() }
    }
    
    // 条件协议扩展测试
    public func processDrawableColorableShapes<T>(_ shapes: [T]) -> [String] where T: Drawable & Colorable {
        return shapes.map { shape in
            "\(shape.draw()) with color \(shape.color)"
        }
    }
}

// 协议见证表（Protocol Witness Table）测试
public struct ProtocolPerformanceTester {
    public func testProtocolDispatch(_ shapes: [any AdvancedShape], iterations: Int) -> Double {
        let startTime = CFAbsoluteTimeGetCurrent()
        
        for _ in 0..<iterations {
            var totalArea: Double = 0
            for shape in shapes {
                totalArea += shape.area()
                _ = shape.draw()
                _ = shape.animate(duration: 0.1)
            }
        }
        
        let endTime = CFAbsoluteTimeGetCurrent()
        return endTime - startTime
    }
    
    public func testInheritanceDispatch(_ shapes: [InheritanceShape], iterations: Int) -> Double {
        let startTime = CFAbsoluteTimeGetCurrent()
        
        for _ in 0..<iterations {
            var totalArea: Double = 0
            for shape in shapes {
                totalArea += shape.area()
                _ = shape.draw()
                _ = shape.animate(duration: 0.1)
            }
        }
        
        let endTime = CFAbsoluteTimeGetCurrent()
        return endTime - startTime
    }
    
    public func testGenericDispatch<T: AdvancedShape>(_ shapes: [T], iterations: Int) -> Double {
        let startTime = CFAbsoluteTimeGetCurrent()
        
        for _ in 0..<iterations {
            var totalArea: Double = 0
            for shape in shapes {
                totalArea += shape.area()
                _ = shape.draw()
                _ = shape.animate(duration: 0.1)
            }
        }
        
        let endTime = CFAbsoluteTimeGetCurrent()
        return endTime - startTime
    }
}

// 协议组合和条件扩展
public protocol Identifiable {
    var id: String { get }
}

public protocol ShapeComparable {
    static func < (lhs: Self, rhs: Self) -> Bool
}

extension Circle: Swift.Comparable {
    public static func < (lhs: Circle, rhs: Circle) -> Bool {
        return lhs.area() < rhs.area()
    }
}

extension Rectangle: Swift.Comparable {
    public static func < (lhs: Rectangle, rhs: Rectangle) -> Bool {
        return lhs.area() < rhs.area()
    }
}

// 关联类型协议
public protocol ShapeFactory {
    associatedtype ShapeType: AdvancedShape
    func createShape(id: String) -> ShapeType
}

public struct CircleFactory: ShapeFactory {
    public func createShape(id: String) -> Circle {
        return Circle(id: id, radius: Double.random(in: 1...10), color: "red")
    }
}

public struct RectangleFactory: ShapeFactory {
    public func createShape(id: String) -> Rectangle {
        return Rectangle(id: id, width: Double.random(in: 1...10), height: Double.random(in: 1...10), color: "blue")
    }
}

public class ProtocolOrientedBenchmark {
    private let processor = ShapeProcessor()
    private let performanceTester = ProtocolPerformanceTester()
    
    public func runProtocolOrientedComparison() {
        print("Running protocol-oriented vs inheritance comparison...")
        
        let count = 1000
        
        // 创建协议导向的形状
        var protocolShapes: [any AdvancedShape] = []
        for i in 0..<count {
            switch i % 3 {
            case 0:
                protocolShapes.append(Circle(id: "circle_\(i)", radius: Double(i % 10 + 1), color: "red"))
            case 1:
                protocolShapes.append(Rectangle(id: "rect_\(i)", width: Double(i % 8 + 1), height: Double(i % 6 + 1), color: "blue"))
            case 2:
                protocolShapes.append(Triangle(id: "triangle_\(i)", base: Double(i % 7 + 1), height: Double(i % 5 + 1), color: "green"))
            default:
                break
            }
        }
        
        // 创建继承层次的形状
        var inheritanceShapes: [InheritanceShape] = []
        for i in 0..<count {
            switch i % 3 {
            case 0:
                inheritanceShapes.append(InheritanceCircle(id: "circle_\(i)", color: "red", radius: Double(i % 10 + 1)))
            case 1:
                inheritanceShapes.append(InheritanceRectangle(id: "rect_\(i)", color: "blue", width: Double(i % 8 + 1), height: Double(i % 6 + 1)))
            case 2:
                inheritanceShapes.append(InheritanceTriangle(id: "triangle_\(i)", color: "green", base: Double(i % 7 + 1), height: Double(i % 5 + 1)))
            default:
                break
            }
        }
        
        // 测试处理性能
        print("Testing processing performance...")
        let protocolResults = processor.processAnyShapes(Array(protocolShapes.prefix(10)))
        let largestProtocolShape = processor.findLargestShape(in: protocolShapes)
        
        // 测试泛型性能
        let circles = protocolShapes.compactMap { $0 as? Circle }
        let rectangles = protocolShapes.compactMap { $0 as? Rectangle }
        
        let circleResults = processor.processShapes(circles)
        let rectangleResults = processor.processShapes(rectangles)
        
        // 测试协议组合
        let drawableColorableShapes = protocolShapes.filter { _ in true } // All shapes implement both protocols
        
        // 性能基准测试
        print("Running performance benchmarks...")
        let protocolTime = performanceTester.testProtocolDispatch(protocolShapes, iterations: 100)
        let inheritanceTime = performanceTester.testInheritanceDispatch(inheritanceShapes, iterations: 100)
        let genericCircleTime = performanceTester.testGenericDispatch(circles, iterations: 100)
        let genericRectangleTime = performanceTester.testGenericDispatch(rectangles, iterations: 100)
        
        // 测试工厂模式
        let circleFactory = CircleFactory()
        let rectangleFactory = RectangleFactory()
        
        let factoryCircles = (0..<100).map { circleFactory.createShape(id: "factory_circle_\($0)") }
        let factoryRectangles = (0..<100).map { rectangleFactory.createShape(id: "factory_rect_\($0)") }
        
        // 测试排序（需要 Comparable）
        let sortedCircles = circles.sorted()
        let sortedRectangles = rectangles.sorted()
        
        print("Protocol-oriented benchmark completed:")
        print("- Protocol shapes: \(protocolShapes.count)")
        print("- Inheritance shapes: \(inheritanceShapes.count)")
        print("- Protocol results: \(protocolResults.count)")
        print("- Largest shape area: \(largestProtocolShape?.area() ?? 0)")
        print("- Circle results: \(circleResults.count)")
        print("- Rectangle results: \(rectangleResults.count)")
        print("- Drawable+Colorable shapes: \(drawableColorableShapes.count)")
        print("- Protocol dispatch time: \(protocolTime)s")
        print("- Inheritance dispatch time: \(inheritanceTime)s")
        print("- Generic circle dispatch time: \(genericCircleTime)s")
        print("- Generic rectangle dispatch time: \(genericRectangleTime)s")
        print("- Factory circles: \(factoryCircles.count)")
        print("- Factory rectangles: \(factoryRectangles.count)")
        print("- Sorted circles: \(sortedCircles.count)")
        print("- Sorted rectangles: \(sortedRectangles.count)")
        
        // 协议开销分析
        let protocolOverhead = (protocolTime - genericCircleTime) / genericCircleTime * 100
        let inheritanceOverhead = (inheritanceTime - genericCircleTime) / genericCircleTime * 100
        
        print("Performance overhead analysis:")
        print("- Protocol overhead vs generics: \(String(format: "%.2f", protocolOverhead))%")
        print("- Inheritance overhead vs generics: \(String(format: "%.2f", inheritanceOverhead))%")
    }
}

public class IosSizeBenchmark {
    private let benchmark = ProtocolOrientedBenchmark()
    
    public init() {}
    
    public func runBenchmark() {
        benchmark.runProtocolOrientedComparison()
    }
}