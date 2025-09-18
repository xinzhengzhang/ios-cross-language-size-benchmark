/*
 * iOS Size Benchmark - Test Case Implementation
 * Generated with Claude AI (https://claude.ai)
 * 
 * This Kotlin Native implementation demonstrates language-specific
 * features and patterns for binary size comparison.
 */

package kntr.examples.ios.size.benchmark

import kotlin.math.PI
import kotlin.time.TimeSource

// Kotlin 接口导向编程 vs 继承层次对比

// 接口导向方法
interface Drawable {
    fun draw(): String
    fun area(): Double
}

interface Colorable {
    var color: String
    fun applyColor(color: String) {
        this.color = color
    }
}

interface Transformable {
    fun transform(scale: Double, rotation: Double)
}

interface Animatable {
    fun animate(duration: Double): String {
        return "Animating for $duration seconds"
    }
}

// 组合多个接口
interface AdvancedShape : Drawable, Colorable, Transformable, Animatable {
    val id: String
}

// 扩展函数提供默认实现
fun Drawable.description(): String {
    return "Shape with area: ${area()}"
}

// 数据类实现接口
data class Circle(
    override val id: String,
    val radius: Double,
    override var color: String,
    var scale: Double = 1.0,
    var rotation: Double = 0.0
) : AdvancedShape {
    
    override fun draw(): String {
        return "Drawing circle with radius ${radius * scale} at rotation $rotation"
    }
    
    override fun area(): Double {
        return PI * radius * radius * scale * scale
    }
    
    override fun transform(scale: Double, rotation: Double) {
        this.scale *= scale
        this.rotation += rotation
    }
}

data class Rectangle(
    override val id: String,
    val width: Double,
    val height: Double,
    override var color: String,
    var scale: Double = 1.0,
    var rotation: Double = 0.0
) : AdvancedShape {
    
    override fun draw(): String {
        return "Drawing rectangle ${width * scale}x${height * scale} at rotation $rotation"
    }
    
    override fun area(): Double {
        return width * height * scale * scale
    }
    
    override fun transform(scale: Double, rotation: Double) {
        this.scale *= scale
        this.rotation += rotation
    }
}

data class Triangle(
    override val id: String,
    val base: Double,
    val height: Double,
    override var color: String,
    var scale: Double = 1.0,
    var rotation: Double = 0.0
) : AdvancedShape {
    
    override fun draw(): String {
        return "Drawing triangle with base ${base * scale} and height ${height * scale}"
    }
    
    override fun area(): Double {
        return 0.5 * base * height * scale * scale
    }
    
    override fun transform(scale: Double, rotation: Double) {
        this.scale *= scale
        this.rotation += rotation
    }
}

// 继承层次方法（对比）
abstract class InheritanceShape(
    val id: String,
    var color: String
) {
    var scale: Double = 1.0
    var rotation: Double = 0.0
    
    abstract fun draw(): String
    abstract fun area(): Double
    
    fun transform(scale: Double, rotation: Double) {
        this.scale *= scale
        this.rotation += rotation
    }
    
    open fun animate(duration: Double): String {
        return "Animating ${this::class.simpleName} for $duration seconds"
    }
    
    fun applyColor(color: String) {
        this.color = color
    }
    
    fun description(): String {
        return "Shape with area: ${area()}"
    }
    
    protected val currentScale: Double get() = scale
    protected val currentRotation: Double get() = rotation
}

class InheritanceCircle(
    id: String,
    color: String,
    val radius: Double
) : InheritanceShape(id, color) {
    
    override fun draw(): String {
        return "Drawing circle with radius ${radius * currentScale} at rotation $currentRotation"
    }
    
    override fun area(): Double {
        return PI * radius * radius * currentScale * currentScale
    }
}

class InheritanceRectangle(
    id: String,
    color: String,
    val width: Double,
    val height: Double
) : InheritanceShape(id, color) {
    
    override fun draw(): String {
        return "Drawing rectangle ${width * currentScale}x${height * currentScale} at rotation $currentRotation"
    }
    
    override fun area(): Double {
        return width * height * currentScale * currentScale
    }
}

class InheritanceTriangle(
    id: String,
    color: String,
    val base: Double,
    val height: Double
) : InheritanceShape(id, color) {
    
    override fun draw(): String {
        return "Drawing triangle with base ${base * currentScale} and height ${height * currentScale}"
    }
    
    override fun area(): Double {
        return 0.5 * base * height * currentScale * currentScale
    }
}

// 泛型接口处理
class ShapeProcessor {
    // 使用接口约束的泛型函数
    inline fun <reified T : AdvancedShape> processShapes(shapes: List<T>): List<String> {
        return shapes.map { shape ->
            "${shape.id}: ${shape.draw()} - Area: ${shape.area()} - ${shape.animate(1.0)}"
        }
    }
    
    // 使用接口的函数
    fun processAnyShapes(shapes: List<AdvancedShape>): List<String> {
        return shapes.map { shape ->
            "${shape.id}: ${shape.draw()} - Area: ${shape.area()} - ${shape.animate(1.0)}"
        }
    }
    
    // 查找最大形状
    fun findLargestShape(shapes: List<AdvancedShape>): AdvancedShape? {
        return shapes.maxByOrNull { it.area() }
    }
    
    // 条件接口组合
    fun processDrawableColorableShapes(shapes: List<AdvancedShape>): List<String> {
        return shapes.map { shape ->
            "${shape.draw()} with color ${shape.color}"
        }
    }
}

// 接口性能测试
class ProtocolPerformanceTester {
    fun testInterfaceDispatch(shapes: List<AdvancedShape>, iterations: Int): Long {
        val startTime = TimeSource.Monotonic.markNow()
        
        repeat(iterations) {
            var totalArea = 0.0
            for (shape in shapes) {
                totalArea += shape.area()
                shape.draw()
                shape.animate(0.1)
            }
        }
        
        val endTime = TimeSource.Monotonic.markNow()
        return (endTime - startTime).inWholeNanoseconds
    }
    
    fun testInheritanceDispatch(shapes: List<InheritanceShape>, iterations: Int): Long {
        val startTime = TimeSource.Monotonic.markNow()
        
        repeat(iterations) {
            var totalArea = 0.0
            for (shape in shapes) {
                totalArea += shape.area()
                shape.draw()
                shape.animate(0.1)
            }
        }
        
        val endTime = TimeSource.Monotonic.markNow()
        return (endTime - startTime).inWholeNanoseconds
    }
    
    inline fun <reified T : AdvancedShape> testGenericDispatch(shapes: List<T>, iterations: Int): Long {
        val startTime = TimeSource.Monotonic.markNow()
        
        repeat(iterations) {
            var totalArea = 0.0
            for (shape in shapes) {
                totalArea += shape.area()
                shape.draw()
                shape.animate(0.1)
            }
        }
        
        val endTime = TimeSource.Monotonic.markNow()
        return (endTime - startTime).inWholeNanoseconds
    }
}

// 接口组合和扩展
interface Identifiable {
    val id: String
}

// 比较接口
interface Comparable<T> {
    fun compareTo(other: T): Int
}

// 为Circle实现比较
class ComparableCircle(
    override val id: String,
    val radius: Double,
    override var color: String
) : AdvancedShape, Comparable<ComparableCircle> {
    var scale: Double = 1.0
    var rotation: Double = 0.0
    
    override fun draw(): String {
        return "Drawing comparable circle with radius ${radius * scale}"
    }
    
    override fun area(): Double {
        return PI * radius * radius * scale * scale
    }
    
    override fun transform(scale: Double, rotation: Double) {
        this.scale *= scale
        this.rotation += rotation
    }
    
    override fun compareTo(other: ComparableCircle): Int {
        return area().compareTo(other.area())
    }
}

// 工厂接口
interface ShapeFactory<T : AdvancedShape> {
    fun createShape(id: String): T
}

class CircleFactory : ShapeFactory<Circle> {
    override fun createShape(id: String): Circle {
        return Circle(id, (1..10).random().toDouble(), "red")
    }
}

class RectangleFactory : ShapeFactory<Rectangle> {
    override fun createShape(id: String): Rectangle {
        return Rectangle(id, (1..10).random().toDouble(), (1..10).random().toDouble(), "blue")
    }
}

class InterfaceOrientedBenchmark {
    val processor = ShapeProcessor()
    val performanceTester = ProtocolPerformanceTester()
    
    fun runInterfaceOrientedComparison() {
        println("Running interface-oriented vs inheritance comparison...")
        
        val count = 1000
        
        // 创建接口导向的形状
        val interfaceShapes = mutableListOf<AdvancedShape>()
        repeat(count) { i ->
            when (i % 3) {
                0 -> interfaceShapes.add(Circle("circle_$i", (i % 10 + 1).toDouble(), "red"))
                1 -> interfaceShapes.add(Rectangle("rect_$i", (i % 8 + 1).toDouble(), (i % 6 + 1).toDouble(), "blue"))
                2 -> interfaceShapes.add(Triangle("triangle_$i", (i % 7 + 1).toDouble(), (i % 5 + 1).toDouble(), "green"))
            }
        }
        
        // 创建继承层次的形状
        val inheritanceShapes = mutableListOf<InheritanceShape>()
        repeat(count) { i ->
            when (i % 3) {
                0 -> inheritanceShapes.add(InheritanceCircle("circle_$i", "red", (i % 10 + 1).toDouble()))
                1 -> inheritanceShapes.add(InheritanceRectangle("rect_$i", "blue", (i % 8 + 1).toDouble(), (i % 6 + 1).toDouble()))
                2 -> inheritanceShapes.add(InheritanceTriangle("triangle_$i", "green", (i % 7 + 1).toDouble(), (i % 5 + 1).toDouble()))
            }
        }
        
        // 测试处理性能
        println("Testing processing performance...")
        val interfaceResults = processor.processAnyShapes(interfaceShapes.take(10))
        val largestInterfaceShape = processor.findLargestShape(interfaceShapes)
        
        // 测试泛型性能
        val circles = interfaceShapes.filterIsInstance<Circle>()
        val rectangles = interfaceShapes.filterIsInstance<Rectangle>()
        
        val circleResults = processor.processShapes(circles)
        val rectangleResults = processor.processShapes(rectangles)
        
        // 测试接口组合
        val drawableColorableShapes = interfaceShapes.filter { it is Drawable && it is Colorable }
        
        // 性能基准测试
        println("Running performance benchmarks...")
        val interfaceTime = performanceTester.testInterfaceDispatch(interfaceShapes, 100)
        val inheritanceTime = performanceTester.testInheritanceDispatch(inheritanceShapes, 100)
        val genericCircleTime = performanceTester.testGenericDispatch(circles, 100)
        val genericRectangleTime = performanceTester.testGenericDispatch(rectangles, 100)
        
        // 测试工厂模式
        val circleFactory = CircleFactory()
        val rectangleFactory = RectangleFactory()
        
        val factoryCircles = (0 until 100).map { circleFactory.createShape("factory_circle_$it") }
        val factoryRectangles = (0 until 100).map { rectangleFactory.createShape("factory_rect_$it") }
        
        // 测试比较（模拟排序）
        val comparableCircles = (0 until 100).map { ComparableCircle("comp_circle_$it", (it % 10 + 1).toDouble(), "red") }
        val sortedCircles = comparableCircles.sortedWith(compareBy { it.area() })
        
        println("Interface-oriented benchmark completed:")
        println("- Interface shapes: ${interfaceShapes.size}")
        println("- Inheritance shapes: ${inheritanceShapes.size}")
        println("- Interface results: ${interfaceResults.size}")
        println("- Largest shape area: ${largestInterfaceShape?.area() ?: 0}")
        println("- Circle results: ${circleResults.size}")
        println("- Rectangle results: ${rectangleResults.size}")
        println("- Drawable+Colorable shapes: ${drawableColorableShapes.size}")
        println("- Interface dispatch time: ${interfaceTime / 1_000_000}ms")
        println("- Inheritance dispatch time: ${inheritanceTime / 1_000_000}ms")
        println("- Generic circle dispatch time: ${genericCircleTime / 1_000_000}ms")
        println("- Generic rectangle dispatch time: ${genericRectangleTime / 1_000_000}ms")
        println("- Factory circles: ${factoryCircles.size}")
        println("- Factory rectangles: ${factoryRectangles.size}")
        println("- Sorted circles: ${sortedCircles.size}")
        
        // 接口开销分析
        val interfaceOverhead = (interfaceTime - genericCircleTime).toDouble() / genericCircleTime * 100
        val inheritanceOverhead = (inheritanceTime - genericCircleTime).toDouble() / genericCircleTime * 100
        
        println("Performance overhead analysis:")
        println("- Interface overhead vs generics: ${interfaceOverhead}%")
        println("- Inheritance overhead vs generics: ${inheritanceOverhead}%")
    }
}

class IosSizeBenchmark {
    val benchmark = InterfaceOrientedBenchmark()
    
    fun runBenchmark() {
        benchmark.runInterfaceOrientedComparison()
    }
}