/*
 * iOS Size Benchmark - Test Case Implementation
 * Generated with Claude AI (https://claude.ai)
 * 
 * This Swift implementation demonstrates language-specific
 * features and patterns for binary size comparison.
 */

import Foundation

// Test case: Generics Heavy - Tests impact of extensive generic usage on code size

// Generic container classes
public class Container<T> {
    public let value: T
    
    public init(_ value: T) {
        self.value = value
    }
    
    public func get() -> T { return value }
    public func map<R>(_ transform: (T) -> R) -> Container<R> { return Container<R>(transform(value)) }
    public func flatMap<R>(_ transform: (T) -> Container<R>) -> Container<R> { return transform(value) }
}

public class Pair<T, U> {
    public let first: T
    public let second: U
    
    public init(_ first: T, _ second: U) {
        self.first = first
        self.second = second
    }
    
    public func mapFirst<R>(_ transform: (T) -> R) -> Pair<R, U> { return Pair<R, U>(transform(first), second) }
    public func mapSecond<R>(_ transform: (U) -> R) -> Pair<T, R> { return Pair<T, R>(first, transform(second)) }
    public func mapBoth<R, S>(_ transformFirst: (T) -> R, _ transformSecond: (U) -> S) -> Pair<R, S> {
        return Pair<R, S>(transformFirst(first), transformSecond(second))
    }
}

public class Triple<T, U, V> {
    public let first: T
    public let second: U
    public let third: V
    
    public init(_ first: T, _ second: U, _ third: V) {
        self.first = first
        self.second = second
        self.third = third
    }
    
    public func mapFirst<R>(_ transform: (T) -> R) -> Triple<R, U, V> { 
        return Triple<R, U, V>(transform(first), second, third) 
    }
    public func mapSecond<R>(_ transform: (U) -> R) -> Triple<T, R, V> { 
        return Triple<T, R, V>(first, transform(second), third) 
    }
    public func mapThird<R>(_ transform: (V) -> R) -> Triple<T, U, R> { 
        return Triple<T, U, R>(first, second, transform(third)) 
    }
}

// Generic collection utilities
public class GenericList<T> {
    private var items: [T] = []
    
    public init() {}
    
    public func add(_ item: T) { items.append(item) }
    public func get(_ index: Int) -> T? { return index < items.count ? items[index] : nil }
    public func map<R>(_ transform: (T) -> R) -> GenericList<R> {
        let result = GenericList<R>()
        items.forEach { result.add(transform($0)) }
        return result
    }
    public func filter(_ predicate: (T) -> Bool) -> GenericList<T> {
        let result = GenericList<T>()
        items.forEach { if predicate($0) { result.add($0) } }
        return result
    }
    public func fold<R>(_ initial: R, _ operation: (R, T) -> R) -> R {
        var accumulator = initial
        items.forEach { accumulator = operation(accumulator, $0) }
        return accumulator
    }
}

public class GenericMap<K: Hashable, V> {
    private var items: [K: V] = [:]
    
    public init() {}
    
    public func put(_ key: K, _ value: V) { items[key] = value }
    public func get(_ key: K) -> V? { return items[key] }
    public func mapValues<R>(_ transform: (V) -> R) -> GenericMap<K, R> {
        let result = GenericMap<K, R>()
        items.forEach { key, value in result.put(key, transform(value)) }
        return result
    }
    public func mapKeys<R: Hashable>(_ transform: (K) -> R) -> GenericMap<R, V> {
        let result = GenericMap<R, V>()
        items.forEach { key, value in result.put(transform(key), value) }
        return result
    }
}

public class GenericSet<T: Hashable> {
    private var items: Set<T> = []
    
    public init() {}
    
    public func add(_ item: T) { items.insert(item) }
    public func contains(_ item: T) -> Bool { return items.contains(item) }
    public func map<R: Hashable>(_ transform: (T) -> R) -> GenericSet<R> {
        let result = GenericSet<R>()
        items.forEach { result.add(transform($0)) }
        return result
    }
}

// Generic processing classes
public class Processor<Input, Output> {
    private let processFunction: (Input) -> Output
    
    public init(_ process: @escaping (Input) -> Output) {
        self.processFunction = process
    }
    
    public func execute(_ input: Input) -> Output { return processFunction(input) }
    public func chain<NewOutput>(_ next: Processor<Output, NewOutput>) -> Processor<Input, NewOutput> {
        return Processor<Input, NewOutput> { next.execute(self.execute($0)) }
    }
}

public class BatchProcessor<T, R> {
    public init() {}
    
    public func processBatch(_ items: [T], _ processor: (T) -> R) -> [R] { return items.map(processor) }
    public func processParallel(_ items: [T], _ processor: (T) -> R) -> [R] { return items.map(processor) }
    public func processFiltered(_ items: [T], _ filter: (T) -> Bool, _ processor: (T) -> R) -> [R] {
        return items.filter(filter).map(processor)
    }
}

public class Cache<K: Hashable, V> {
    private var storage: [K: V] = [:]
    
    public init() {}
    
    public func get(_ key: K) -> V? { return storage[key] }
    public func put(_ key: K, _ value: V) { storage[key] = value }
    public func getOrCompute(_ key: K, _ compute: (K) -> V) -> V {
        if let existing = storage[key] { return existing }
        let computed = compute(key)
        storage[key] = computed
        return computed
    }
}

// Nested generics
public class Repository<Entity, Id: Hashable> {
    private var entities: [Id: Entity] = [:]
    
    public init() {}
    
    public func save(_ id: Id, _ entity: Entity) { entities[id] = entity }
    public func findById(_ id: Id) -> Entity? { return entities[id] }
    public func findAll() -> [Entity] { return Array(entities.values) }
    public func transform<R>(_ transformer: (Entity) -> R) -> [R] { return entities.values.map(transformer) }
}

public class Service<Request, Response> {
    public init() {}
    
    public func handle(_ request: Request, _ handler: (Request) -> Response) -> Response { return handler(request) }
    public func map<NewResponse>(_ handler: @escaping (Request) -> Response, _ mapper: @escaping (Response) -> NewResponse) -> (Request) -> NewResponse {
        return { request in mapper(handler(request)) }
    }
}

public class Pipeline<T> {
    private var stages: [(T) -> T] = []
    
    public init() {}
    
    public func addStage(_ stage: @escaping (T) -> T) { stages.append(stage) }
    public func execute(_ input: T) -> T { return stages.reduce(input) { acc, stage in stage(acc) } }
    public func transform<R>(_ input: T, _ finalTransform: (T) -> R) -> R { return finalTransform(execute(input)) }
}

// Complex nested generics
public class ComplexContainer<A: Hashable, B, C> {
    private var data: [A: Pair<B, [C]>] = [:]
    
    public init() {}
    
    public func store(_ key: A, _ value: B, _ items: [C]) { data[key] = Pair(value, items) }
    public func retrieve(_ key: A) -> Pair<B, [C]>? { return data[key] }
    public func mapItems<D>(_ key: A, _ transform: (C) -> D) -> [D]? { 
        return data[key]?.second.map(transform) 
    }
}

public class MultiLevelGeneric<T, U, V, W> {
    public init() {}
    
    public func process(
        _ input: Container<Pair<T, U>>,
        _ transformer: (T) -> V,
        _ combiner: (V, U) -> W
    ) -> Container<W> {
        return input.map { pair in
            combiner(transformer(pair.first), pair.second)
        }
    }
}

// Generic protocols
public protocol Transformer {
    associatedtype Input
    associatedtype Output
    func transform(_ input: Input) -> Output
}

public protocol Validator {
    associatedtype Item
    func validate(_ item: Item) -> Bool
}

public protocol Comparator {
    associatedtype Item
    func compare(_ a: Item, _ b: Item) -> ComparisonResult
}

// Implementations
public struct StringTransformer: Transformer {
    public typealias Input = String
    public typealias Output = Int
    
    public init() {}
    public func transform(_ input: String) -> Int { return input.count }
}

public struct NumberValidator: Validator {
    public typealias Item = Double
    
    public init() {}
    public func validate(_ item: Double) -> Bool { return item > 0 }
}

public struct StringComparator: Comparator {
    public typealias Item = String
    
    public init() {}
    public func compare(_ a: String, _ b: String) -> ComparisonResult {
        if a < b { return .orderedAscending }
        else if a > b { return .orderedDescending }
        else { return .orderedSame }
    }
}

// Main benchmark class that uses all generics
public class IosSizeBenchmark {
    private let stringContainer = Container("test")
    private let numberContainer = Container(42)
    private let pairContainer = Container(Pair("hello", 123))
    
    private let stringList = GenericList<String>()
    private let numberList = GenericList<Int>()
    private let stringMap = GenericMap<String, Int>()
    private let numberSet = GenericSet<Double>()
    
    private let stringProcessor = Processor<String, Int> { $0.count }
    private let numberProcessor = Processor<Int, String> { String($0) }
    private let batchProcessor = BatchProcessor<String, Int>()
    private let cache = Cache<String, Int>()
    
    private let repository = Repository<String, Int>()
    private let service = Service<String, Int>()
    private let pipeline = Pipeline<String>()
    
    private let complexContainer = ComplexContainer<String, Int, Double>()
    private let multiLevel = MultiLevelGeneric<String, Int, Double, String>()
    
    private let transformer = StringTransformer()
    private let validator = NumberValidator()
    private let comparator = StringComparator()
    
    public init() {}
    
    public func runBenchmark() {
        // Test containers
        let mappedString = stringContainer.map { $0.uppercased() }
        let mappedNumber = numberContainer.map { $0 * 2 }
        
        // Test pairs and triples
        let pair = Pair("hello", 42)
        let mappedPair = pair.mapFirst { $0.count }
        let triple = Triple("a", 1, 2.0)
        let mappedTriple = triple.mapSecond { $0 * 2 }
        
        // Test collections
        stringList.add("test")
        stringList.add("example")
        let mappedList = stringList.map { $0.count }
        let filteredList = stringList.filter { $0.count > 3 }
        let foldedResult = stringList.fold(0) { acc, str in acc + str.count }
        
        stringMap.put("key1", 10)
        stringMap.put("key2", 20)
        let mappedValues = stringMap.mapValues { $0 * 2 }
        
        numberSet.add(1.0)
        numberSet.add(2.0)
        let mappedSet = numberSet.map { Int($0) }
        
        // Test processors
        let result1 = stringProcessor.execute("hello")
        let result2 = numberProcessor.execute(42)
        let chainedProcessor = stringProcessor.chain(numberProcessor)
        let chainedResult = chainedProcessor.execute("test")
        
        let batchResult = batchProcessor.processBatch(["a", "bb", "ccc"]) { $0.count }
        
        cache.put("test", 42)
        let cachedValue = cache.getOrCompute("new") { $0.count }
        
        // Test repository and service
        repository.save(1, "entity1")
        repository.save(2, "entity2")
        let allEntities = repository.findAll()
        let transformedEntities = repository.transform { $0.uppercased() }
        
        let serviceResult = service.handle("request") { $0.count }
        
        pipeline.addStage { $0.uppercased() }
        pipeline.addStage { String($0.reversed()) }
        let pipelineResult = pipeline.execute("test")
        
        // Test complex containers
        complexContainer.store("key", 42, [1.0, 2.0, 3.0])
        let mappedItems = complexContainer.mapItems("key") { $0 * 2 }
        
        let multiLevelInput = Container(Pair("hello", 42))
        let multiLevelResult = multiLevel.process(multiLevelInput, { Double($0.count) }, { v, u in "\(v)_\(u)" })
        
        // Test protocols
        let transformedString = transformer.transform("hello")
        let isValid = validator.validate(42.0)
        let comparisonResult = comparator.compare("a", "b")
    }
}