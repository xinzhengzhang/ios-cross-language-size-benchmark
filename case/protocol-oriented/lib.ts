/*
 * iOS Size Benchmark - Test Case Implementation
 * Generated with Claude AI (https://claude.ai)
 *
 * scriptc (TypeScript-to-native) port of the Kotlin/Swift "protocol-oriented"
 * case. Mirrors the interface-oriented design (interfaces with default
 * methods, data classes implementing a composed AdvancedShape interface) and
 * the parallel inheritance hierarchy used for comparison. Kotlin interface
 * default methods (Colorable.applyColor, Animatable.animate) are preserved
 * via a shared base class so behavior is identical. A single exported entry
 * (runBenchmark) exercises every type so nothing is dead-code eliminated.
 */

// Kotlin 接口导向编程 vs 继承层次对比

// 接口导向方法
interface Drawable {
  draw(): string;
  area(): number;
}

interface Colorable {
  color: string;
  applyColor(color: string): void;
}

interface Transformable {
  transform(scale: number, rotation: number): void;
}

interface Animatable {
  animate(duration: number): string;
}

// 组合多个接口
interface AdvancedShape extends Drawable, Colorable, Transformable, Animatable {
  readonly id: string;
}

// 扩展函数提供默认实现 (Kotlin extension function -> free function)
function describeShape(shape: Drawable): string {
  return `Shape with area: ${shape.area()}`;
}

// 共享默认实现：Kotlin 接口默认方法 applyColor / animate 在此基类中实现，
// 保证值类型（data class）实现接口时行为一致。
abstract class ShapeDefaults implements AdvancedShape {
  scale: number = 1.0;
  rotation: number = 0.0;
  constructor(public readonly id: string, public color: string) {}

  abstract draw(): string;
  abstract area(): number;

  transform(scale: number, rotation: number): void {
    this.scale *= scale;
    this.rotation += rotation;
  }
  // 默认实现 (来自 Colorable)
  applyColor(color: string): void {
    this.color = color;
  }
  // 默认实现 (来自 Animatable)
  animate(duration: number): string {
    return `Animating for ${duration} seconds`;
  }
}

// 数据类实现接口
class Circle extends ShapeDefaults {
  constructor(id: string, public readonly radius: number, color: string) {
    super(id, color);
  }
  draw(): string {
    return `Drawing circle with radius ${this.radius * this.scale} at rotation ${this.rotation}`;
  }
  area(): number {
    return Math.PI * this.radius * this.radius * this.scale * this.scale;
  }
}

class Rectangle extends ShapeDefaults {
  constructor(id: string, public readonly width: number, public readonly height: number, color: string) {
    super(id, color);
  }
  draw(): string {
    return `Drawing rectangle ${this.width * this.scale}x${this.height * this.scale} at rotation ${this.rotation}`;
  }
  area(): number {
    return this.width * this.height * this.scale * this.scale;
  }
}

class Triangle extends ShapeDefaults {
  constructor(id: string, public readonly base: number, public readonly height: number, color: string) {
    super(id, color);
  }
  draw(): string {
    return `Drawing triangle with base ${this.base * this.scale} and height ${this.height * this.scale}`;
  }
  area(): number {
    return 0.5 * this.base * this.height * this.scale * this.scale;
  }
}

// 继承层次方法（对比）
abstract class InheritanceShape {
  scale: number = 1.0;
  rotation: number = 0.0;
  constructor(public readonly id: string, public color: string) {}

  abstract draw(): string;
  abstract area(): number;

  transform(scale: number, rotation: number): void {
    this.scale *= scale;
    this.rotation += rotation;
  }
  animate(duration: number): string {
    return `Animating ${this.simpleName()} for ${duration} seconds`;
  }
  applyColor(color: string): void {
    this.color = color;
  }
  description(): string {
    return `Shape with area: ${this.area()}`;
  }
  protected simpleName(): string { return "InheritanceShape"; }
  protected get currentScale(): number { return this.scale; }
  protected get currentRotation(): number { return this.rotation; }
}

class InheritanceCircle extends InheritanceShape {
  constructor(id: string, color: string, public readonly radius: number) { super(id, color); }
  draw(): string {
    return `Drawing circle with radius ${this.radius * this.currentScale} at rotation ${this.currentRotation}`;
  }
  area(): number {
    return Math.PI * this.radius * this.radius * this.currentScale * this.currentScale;
  }
  protected simpleName(): string { return "InheritanceCircle"; }
}

class InheritanceRectangle extends InheritanceShape {
  constructor(id: string, color: string, public readonly width: number, public readonly height: number) { super(id, color); }
  draw(): string {
    return `Drawing rectangle ${this.width * this.currentScale}x${this.height * this.currentScale} at rotation ${this.currentRotation}`;
  }
  area(): number {
    return this.width * this.height * this.currentScale * this.currentScale;
  }
  protected simpleName(): string { return "InheritanceRectangle"; }
}

class InheritanceTriangle extends InheritanceShape {
  constructor(id: string, color: string, public readonly base: number, public readonly height: number) { super(id, color); }
  draw(): string {
    return `Drawing triangle with base ${this.base * this.currentScale} and height ${this.height * this.currentScale}`;
  }
  area(): number {
    return 0.5 * this.base * this.height * this.currentScale * this.currentScale;
  }
  protected simpleName(): string { return "InheritanceTriangle"; }
}

// 泛型接口处理
class ShapeProcessor {
  // 使用接口约束的泛型函数 (Kotlin reified inline -> TS generic)
  processShapes<T extends AdvancedShape>(shapes: T[]): string[] {
    const result: string[] = [];
    for (const shape of shapes) {
      result.push(`${shape.id}: ${shape.draw()} - Area: ${shape.area()} - ${shape.animate(1.0)}`);
    }
    return result;
  }
  // 使用接口的函数
  processAnyShapes(shapes: AdvancedShape[]): string[] {
    const result: string[] = [];
    for (const shape of shapes) {
      result.push(`${shape.id}: ${shape.draw()} - Area: ${shape.area()} - ${shape.animate(1.0)}`);
    }
    return result;
  }
  // 查找最大形状 (arithmetic on area() needs class dispatch, not interface
  // dispatch — all shapes share the ShapeDefaults base that implements
  // AdvancedShape, so this stays behaviorally identical)
  findLargestShape(shapes: ShapeDefaults[]): ShapeDefaults | null {
    let largest: ShapeDefaults | null = null;
    for (const shape of shapes) {
      if (largest === null || shape.area() > largest.area()) {
        largest = shape;
      }
    }
    return largest;
  }
  // 条件接口组合
  processDrawableColorableShapes(shapes: AdvancedShape[]): string[] {
    const result: string[] = [];
    for (const shape of shapes) {
      result.push(`${shape.draw()} with color ${shape.color}`);
    }
    return result;
  }
}

// 接口性能测试
class ProtocolPerformanceTester {
  // Dispatch timer: arithmetic on area() uses class (vtable) dispatch via the
  // shared ShapeDefaults base; behavior matches interface dispatch exactly.
  testInterfaceDispatch(shapes: ShapeDefaults[], iterations: number): number {
    const startTime = Date.now();
    for (let iter = 0; iter < iterations; iter++) {
      let totalArea = 0.0;
      for (const shape of shapes) {
        totalArea += shape.area();
        shape.draw();
        shape.animate(0.1);
      }
    }
    const endTime = Date.now();
    return (endTime - startTime) * 1000000;
  }

  testInheritanceDispatch(shapes: InheritanceShape[], iterations: number): number {
    const startTime = Date.now();
    for (let iter = 0; iter < iterations; iter++) {
      let totalArea = 0.0;
      for (const shape of shapes) {
        totalArea += shape.area();
        shape.draw();
        shape.animate(0.1);
      }
    }
    const endTime = Date.now();
    return (endTime - startTime) * 1000000;
  }

  testGenericDispatch<T extends AdvancedShape>(shapes: T[], iterations: number): number {
    const startTime = Date.now();
    for (let iter = 0; iter < iterations; iter++) {
      let totalArea = 0.0;
      for (const shape of shapes) {
        totalArea += shape.area();
        shape.draw();
        shape.animate(0.1);
      }
    }
    const endTime = Date.now();
    return (endTime - startTime) * 1000000;
  }
}

// 接口组合和扩展
interface Identifiable {
  readonly id: string;
}

// 比较接口
interface ComparableShape<T> {
  compareTo(other: T): number;
}

// 为Circle实现比较
class ComparableCircle extends ShapeDefaults implements Identifiable, ComparableShape<ComparableCircle> {
  constructor(id: string, public readonly radius: number, color: string) {
    super(id, color);
  }
  draw(): string {
    return `Drawing comparable circle with radius ${this.radius * this.scale}`;
  }
  area(): number {
    return Math.PI * this.radius * this.radius * this.scale * this.scale;
  }
  compareTo(other: ComparableCircle): number {
    const a = this.area();
    const b = other.area();
    return a < b ? -1 : (a > b ? 1 : 0);
  }
}

// 工厂接口
interface ShapeFactory<T extends AdvancedShape> {
  createShape(id: string): T;
}

class CircleFactory implements ShapeFactory<Circle> {
  createShape(id: string): Circle {
    return new Circle(id, Math.trunc(Math.random() * 10) + 1, "red");
  }
}

class RectangleFactory implements ShapeFactory<Rectangle> {
  createShape(id: string): Rectangle {
    return new Rectangle(id, Math.trunc(Math.random() * 10) + 1, Math.trunc(Math.random() * 10) + 1, "blue");
  }
}

class InterfaceOrientedBenchmark {
  readonly processor = new ShapeProcessor();
  readonly performanceTester = new ProtocolPerformanceTester();

  runInterfaceOrientedComparison(): void {
    console.log("Running interface-oriented vs inheritance comparison...");

    const count = 1000;

    // 创建接口导向的形状 (typed as the shared ShapeDefaults base so area()
    // arithmetic resolves; still assignable to AdvancedShape[] for the
    // string-interpolating processor methods)
    const interfaceShapes: ShapeDefaults[] = [];
    for (let i = 0; i < count; i++) {
      switch (i % 3) {
        case 0: interfaceShapes.push(new Circle(`circle_${i}`, (i % 10) + 1, "red")); break;
        case 1: interfaceShapes.push(new Rectangle(`rect_${i}`, (i % 8) + 1, (i % 6) + 1, "blue")); break;
        case 2: interfaceShapes.push(new Triangle(`triangle_${i}`, (i % 7) + 1, (i % 5) + 1, "green")); break;
      }
    }

    // 创建继承层次的形状
    const inheritanceShapes: InheritanceShape[] = [];
    for (let i = 0; i < count; i++) {
      switch (i % 3) {
        case 0: inheritanceShapes.push(new InheritanceCircle(`circle_${i}`, "red", (i % 10) + 1)); break;
        case 1: inheritanceShapes.push(new InheritanceRectangle(`rect_${i}`, "blue", (i % 8) + 1, (i % 6) + 1)); break;
        case 2: inheritanceShapes.push(new InheritanceTriangle(`triangle_${i}`, "green", (i % 7) + 1, (i % 5) + 1)); break;
      }
    }

    // 测试处理性能
    console.log("Testing processing performance...");
    const interfaceResults = this.processor.processAnyShapes(interfaceShapes.slice(0, 10));
    const largestInterfaceShape = this.processor.findLargestShape(interfaceShapes);

    // 测试泛型性能 (filterIsInstance -> manual instanceof loops)
    const circles: Circle[] = [];
    const rectangles: Rectangle[] = [];
    for (const shape of interfaceShapes) {
      if (shape instanceof Circle) { circles.push(shape); }
      else if (shape instanceof Rectangle) { rectangles.push(shape); }
    }

    const circleResults = this.processor.processShapes(circles);
    const rectangleResults = this.processor.processShapes(rectangles);

    // 测试接口组合
    const drawableColorableShapes = this.processor.processDrawableColorableShapes(interfaceShapes);
    const describeFirst = describeShape(interfaceShapes[0]);

    // 性能基准测试
    console.log("Running performance benchmarks...");
    const interfaceTime = this.performanceTester.testInterfaceDispatch(interfaceShapes, 100);
    const inheritanceTime = this.performanceTester.testInheritanceDispatch(inheritanceShapes, 100);
    const genericCircleTime = this.performanceTester.testGenericDispatch(circles, 100);
    const genericRectangleTime = this.performanceTester.testGenericDispatch(rectangles, 100);

    // 测试工厂模式
    const circleFactory = new CircleFactory();
    const rectangleFactory = new RectangleFactory();

    const factoryCircles: Circle[] = [];
    const factoryRectangles: Rectangle[] = [];
    for (let i = 0; i < 100; i++) {
      factoryCircles.push(circleFactory.createShape(`factory_circle_${i}`));
      factoryRectangles.push(rectangleFactory.createShape(`factory_rect_${i}`));
    }

    // 测试比较（模拟排序）
    const comparableCircles: ComparableCircle[] = [];
    for (let i = 0; i < 100; i++) {
      comparableCircles.push(new ComparableCircle(`comp_circle_${i}`, (i % 10) + 1, "red"));
    }
    const sortedCircles = comparableCircles.slice().sort((a, b) => a.compareTo(b));

    // 测试 transform / applyColor（接口默认实现）
    interfaceShapes[0].transform(2.0, 1.0);
    interfaceShapes[0].applyColor("purple");
    inheritanceShapes[0].transform(2.0, 1.0);
    inheritanceShapes[0].applyColor("purple");
    const inheritanceDesc = inheritanceShapes[0].description();

    console.log("Interface-oriented benchmark completed:");
    console.log(`- Interface shapes: ${interfaceShapes.length}`);
    console.log(`- Inheritance shapes: ${inheritanceShapes.length}`);
    console.log(`- Interface results: ${interfaceResults.length}`);
    console.log(`- Largest shape area: ${largestInterfaceShape === null ? 0 : largestInterfaceShape.area()}`);
    console.log(`- Circle results: ${circleResults.length}`);
    console.log(`- Rectangle results: ${rectangleResults.length}`);
    console.log(`- Drawable+Colorable shapes: ${drawableColorableShapes.length}`);
    console.log(`- Describe first: ${describeFirst}`);
    console.log(`- Interface dispatch time: ${Math.trunc(interfaceTime / 1000000)}ms`);
    console.log(`- Inheritance dispatch time: ${Math.trunc(inheritanceTime / 1000000)}ms`);
    console.log(`- Generic circle dispatch time: ${Math.trunc(genericCircleTime / 1000000)}ms`);
    console.log(`- Generic rectangle dispatch time: ${Math.trunc(genericRectangleTime / 1000000)}ms`);
    console.log(`- Factory circles: ${factoryCircles.length}`);
    console.log(`- Factory rectangles: ${factoryRectangles.length}`);
    console.log(`- Sorted circles: ${sortedCircles.length}`);
    console.log(`- Inheritance desc: ${inheritanceDesc}`);

    // 接口开销分析
    const interfaceOverhead = genericCircleTime === 0 ? 0 : (interfaceTime - genericCircleTime) / genericCircleTime * 100;
    const inheritanceOverhead = genericCircleTime === 0 ? 0 : (inheritanceTime - genericCircleTime) / genericCircleTime * 100;

    console.log("Performance overhead analysis:");
    console.log(`- Interface overhead vs generics: ${interfaceOverhead}%`);
    console.log(`- Inheritance overhead vs generics: ${inheritanceOverhead}%`);
  }
}

class IosSizeBenchmark {
  readonly benchmark = new InterfaceOrientedBenchmark();
  runBenchmark(): void {
    this.benchmark.runInterfaceOrientedComparison();
  }
}

export function runBenchmark(): void {
  const benchmark = new IosSizeBenchmark();
  benchmark.runBenchmark();
}



