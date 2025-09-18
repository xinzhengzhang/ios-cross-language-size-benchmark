/*
 * iOS Size Benchmark - Test Case Implementation
 * Generated with Claude AI (https://claude.ai)
 * 
 * This Swift implementation demonstrates language-specific
 * features and patterns for binary size comparison.
 */

import Foundation

// Test case: Functional Style - Tests impact of closures and higher-order functions on code size

// Higher-order function utilities
public struct FunctionalUtils {
    
    // Basic higher-order functions
    public static func map<T, R>(_ array: [T], transform: (T) -> R) -> [R] {
        return array.map(transform)
    }
    
    public static func filter<T>(_ array: [T], predicate: (T) -> Bool) -> [T] {
        return array.filter(predicate)
    }
    
    public static func fold<T, R>(_ array: [T], initial: R, operation: (R, T) -> R) -> R {
        return array.reduce(initial, operation)
    }
    
    public static func flatMap<T, R>(_ array: [T], transform: (T) -> [R]) -> [R] {
        return array.flatMap(transform)
    }
    
    // Function composition
    public static func compose<T, R, S>(_ f: @escaping (R) -> S, _ g: @escaping (T) -> R) -> (T) -> S {
        return { x in f(g(x)) }
    }
    
    public static func curry<T, R>(_ f: @escaping (T, T) -> R) -> (T) -> (T) -> R {
        return { x in { y in f(x, y) } }
    }
    
    public static func partial<T, R>(_ f: @escaping (T, T) -> R, _ x: T) -> (T) -> R {
        return { y in f(x, y) }
    }
    
    public static func pipe<T>(_ value: T, _ functions: (T) -> T...) -> T {
        return functions.reduce(value) { acc, fn in fn(acc) }
    }
    
    // Monadic operations
    public static func bind<T, R>(_ value: T?, transform: (T) -> R?) -> R? {
        return value.flatMap(transform)
    }
    
    public static func unit<T>(_ value: T) -> [T] {
        return [value]
    }
}

// Functional data processing
public class DataProcessor<T> {
    private var processors: [(T) -> T] = []
    
    public init() {}
    
    @discardableResult
    public func addProcessor(_ processor: @escaping (T) -> T) -> DataProcessor<T> {
        processors.append(processor)
        return self
    }
    
    public func process(_ data: T) -> T {
        return processors.reduce(data) { acc, processor in processor(acc) }
    }
    
    public func processMany(_ data: [T]) -> [T] {
        return data.map { process($0) }
    }
    
    public func processAsync(_ data: T, callback: @escaping (T) -> Void) {
        DispatchQueue.global().async {
            let result = self.process(data)
            DispatchQueue.main.async {
                callback(result)
            }
        }
    }
    
    public func processConditional(_ data: T, condition: (T) -> Bool, processor: (T) -> T) -> T {
        return condition(data) ? processor(data) : data
    }
}

// Event-driven functional patterns
public class EventHandler<T> {
    private var handlers: [(T) -> Void] = []
    private var filters: [(T) -> Bool] = []
    private var transformers: [(T) -> T] = []
    
    public init() {}
    
    @discardableResult
    public func addHandler(_ handler: @escaping (T) -> Void) -> EventHandler<T> {
        handlers.append(handler)
        return self
    }
    
    @discardableResult
    public func addFilter(_ filter: @escaping (T) -> Bool) -> EventHandler<T> {
        filters.append(filter)
        return self
    }
    
    @discardableResult
    public func addTransformer(_ transformer: @escaping (T) -> T) -> EventHandler<T> {
        transformers.append(transformer)
        return self
    }
    
    public func handle(_ event: T) {
        guard filters.allSatisfy({ $0(event) }) else { return }
        
        let transformedEvent = transformers.reduce(event) { acc, transformer in
            transformer(acc)
        }
        
        handlers.forEach { $0(transformedEvent) }
    }
    
    public func handleMany(_ events: [T]) {
        events.forEach { handle($0) }
    }
    
    public func handleWithCallback(_ event: T, callback: (T) -> Void) {
        handle(event)
        callback(event)
    }
}

// Stream-like operations
public class FunctionalStream<T> {
    private let data: [T]
    
    public init(_ data: [T]) {
        self.data = data
    }
    
    public func map<R>(_ transform: (T) -> R) -> FunctionalStream<R> {
        return FunctionalStream<R>(data.map(transform))
    }
    
    public func filter(_ predicate: (T) -> Bool) -> FunctionalStream<T> {
        return FunctionalStream(data.filter(predicate))
    }
    
    public func flatMap<R>(_ transform: (T) -> [R]) -> FunctionalStream<R> {
        return FunctionalStream<R>(data.flatMap(transform))
    }
    
    public func forEach(_ action: (T) -> Void) {
        data.forEach(action)
    }
    
    public func fold<R>(_ initial: R, operation: (R, T) -> R) -> R {
        return data.reduce(initial, operation)
    }
    
    public func reduce(_ operation: (T, T) -> T) -> T? {
        return data.reduce(nil) { acc, element in
            guard let acc = acc else { return element }
            return operation(acc, element)
        }
    }
    
    public func take(_ n: Int) -> FunctionalStream<T> {
        return FunctionalStream(Array(data.prefix(n)))
    }
    
    public func drop(_ n: Int) -> FunctionalStream<T> {
        return FunctionalStream(Array(data.dropFirst(n)))
    }
    
    public func zip<U>(_ other: FunctionalStream<U>) -> FunctionalStream<(T, U)> {
        return FunctionalStream<(T, U)>(Array(Swift.zip(data, other.data)))
    }
    
    public func groupBy(_ keySelector: (T) -> String) -> [String: [T]] {
        return Dictionary(grouping: data, by: keySelector)
    }
    
    public func sortedBy<C: Comparable>(_ selector: (T) -> C) -> FunctionalStream<T> {
        return FunctionalStream(data.sorted { selector($0) < selector($1) })
    }
    
    public func distinct() -> FunctionalStream<T> where T: Hashable {
        return FunctionalStream(Array(Set(data)))
    }
    
    public func toArray() -> [T] {
        return data
    }
}

// Complex closure expressions and function factories
public struct ClosureFactory {
    
    public static func createNumberProcessor() -> (Int) -> (Int) -> Int {
        return { multiplier in
            { number in number * multiplier }
        }
    }
    
    public static func createStringProcessor() -> (String) -> (String) -> String {
        return { prefix in
            { text in "\(prefix): \(text)" }
        }
    }
    
    public static func createValidator() -> (String) -> Bool {
        return { text in
            !text.isEmpty && text.count > 3 && text.allSatisfy { $0.isLetter || $0.isNumber }
        }
    }
    
    public static func createTransformer() -> (String) -> String {
        return { text in
            text.split(separator: " ")
                .filter { !$0.isEmpty }
                .map { $0.lowercased().capitalized }
                .joined(separator: " ")
        }
    }
    
    public static func createAggregator() -> ([Int]) -> Int {
        return { numbers in
            numbers.filter { $0 > 0 }
                .map { $0 * $0 }
                .reduce(0, +)
        }
    }
    
    public static func createComplexProcessor() -> ([String]) -> [String: Int] {
        return { strings in
            Dictionary(
                strings.filter { !$0.isEmpty }
                    .grouped { String($0.first!) }
                    .compactMap { (key, values) in
                        values.count > 1 ? (key, values.count) : nil
                    },
                uniquingKeysWith: +
            )
        }
    }
    
    public static func createNestedFunction() -> (@escaping (Int) -> Int) -> (Int) -> Int {
        return { innerFunc in
            { x in innerFunc(innerFunc(x)) }
        }
    }
    
    public static func createConditionalFunction() -> (Int) -> String {
        return { number in
            switch (number % 15, number % 3, number % 5) {
            case (0, _, _): return "FizzBuzz"
            case (_, 0, _): return "Fizz"
            case (_, _, 0): return "Buzz"
            default: return String(number)
            }
        }
    }
    
    public static func createAsyncProcessor() -> (@escaping (String) -> Void) -> (String) -> Void {
        return { completion in
            { input in
                DispatchQueue.global().async {
                    let processed = input.uppercased().reversed().map(String.init).joined()
                    DispatchQueue.main.async {
                        completion(processed)
                    }
                }
            }
        }
    }
}

// Functional patterns with side effects
public class FunctionalSideEffects {
    private var logs: [String] = []
    private var counters: [String: Int] = [:]
    
    public init() {}
    
    public func logAndProcess(_ text: String, processor: (String) -> String) -> String {
        logs.append("Processing: \(text)")
        let result = processor(text)
        logs.append("Result: \(result)")
        return result
    }
    
    public func countAndFilter(_ items: [String], predicate: (String) -> Bool) -> [String] {
        counters["total"] = items.count
        let filtered = items.filter { item in
            let passes = predicate(item)
            let key = passes ? "passed" : "failed"
            counters[key, default: 0] += 1
            return passes
        }
        return filtered
    }
    
    public func measureAndExecute<R>(_ operation: () -> R) -> (result: R, duration: TimeInterval) {
        let startTime = CFAbsoluteTimeGetCurrent()
        let result = operation()
        let endTime = CFAbsoluteTimeGetCurrent()
        let duration = (endTime - startTime) * 1000 // Convert to milliseconds
        logs.append("Operation took \(String(format: "%.2f", duration))ms")
        return (result, duration)
    }
    
    public func getLogs() -> [String] { return logs }
    public func getCounters() -> [String: Int] { return counters }
}

// Chain of responsibility with closures
public class FunctionalChain<T> {
    private var handlers: [(T) -> T?] = []
    
    public init() {}
    
    @discardableResult
    public func addHandler(_ handler: @escaping (T) -> T?) -> FunctionalChain<T> {
        handlers.append(handler)
        return self
    }
    
    public func handle(_ input: T) -> T? {
        return handlers.reduce(input as T?) { current, handler in
            current.flatMap(handler)
        }
    }
    
    public func handleWithFallback(_ input: T, fallback: (T) -> T) -> T {
        return handle(input) ?? fallback(input)
    }
}

// Extension for functional operations
extension Array {
    public func grouped<Key: Hashable>(by keyPath: (Element) -> Key) -> [Key: [Element]] {
        return Dictionary(grouping: self, by: keyPath)
    }
    
    public func partitioned(by predicate: (Element) -> Bool) -> (matching: [Element], nonMatching: [Element]) {
        var matching: [Element] = []
        var nonMatching: [Element] = []
        
        for element in self {
            if predicate(element) {
                matching.append(element)
            } else {
                nonMatching.append(element)
            }
        }
        
        return (matching, nonMatching)
    }
}

// Main benchmark class
public class IosSizeBenchmark {
    private let dataProcessor = DataProcessor<String>()
    private let eventHandler = EventHandler<String>()
    private let sideEffects = FunctionalSideEffects()
    private let functionalChain = FunctionalChain<String>()
    
    private let numberProcessor = ClosureFactory.createNumberProcessor()
    private let stringProcessor = ClosureFactory.createStringProcessor()
    private let validator = ClosureFactory.createValidator()
    private let transformer = ClosureFactory.createTransformer()
    private let aggregator = ClosureFactory.createAggregator()
    private let complexProcessor = ClosureFactory.createComplexProcessor()
    
    public init() {}
    
    public func runBenchmark() {
        // Test basic higher-order functions
        let numbers = Array(1...10)
        let strings = ["hello", "world", "functional", "programming", "swift", "closures"]
        
        // Map operations with different closure styles
        let doubled = FunctionalUtils.map(numbers) { $0 * 2 }
        let uppercased = FunctionalUtils.map(strings) { $0.uppercased() }
        let lengths = FunctionalUtils.map(strings) { text in text.count }
        
        // Filter operations
        let evens = FunctionalUtils.filter(numbers) { $0 % 2 == 0 }
        let longStrings = FunctionalUtils.filter(strings) { $0.count > 5 }
        let validStrings = FunctionalUtils.filter(strings, predicate: validator)
        
        // Fold operations
        let sum = FunctionalUtils.fold(numbers, initial: 0) { acc, n in acc + n }
        let concatenated = FunctionalUtils.fold(strings, initial: "") { acc, s in "\(acc) \(s)" }
        let maxLength = FunctionalUtils.fold(strings, initial: 0) { acc, s in max(acc, s.count) }
        
        // Complex function composition
        let multiplyBy2: (Int) -> Int = { $0 * 2 }
        let add10: (Int) -> Int = { $0 + 10 }
        let composed = FunctionalUtils.compose(add10, multiplyBy2)
        let composedResults = numbers.map(composed)
        
        // Currying and partial application
        let add: (Int, Int) -> Int = { $0 + $1 }
        let curriedAdd = FunctionalUtils.curry(add)
        let add5 = curriedAdd(5)
        let addedResults = numbers.map(add5)
        
        // Data processing with closures
        dataProcessor
            .addProcessor { $0.trimmingCharacters(in: .whitespaces) }
            .addProcessor { $0.lowercased() }
            .addProcessor { $0.replacingOccurrences(of: " ", with: "_") }
            .addProcessor { "processed_\($0)" }
        
        let processedStrings = dataProcessor.processMany(strings)
        
        // Event handling with closures
        eventHandler
            .addFilter { !$0.isEmpty }
            .addFilter { $0.count > 2 }
            .addTransformer { $0.uppercased() }
            .addTransformer { "EVENT_\($0)" }
            .addHandler { logs in print("Handled: \(logs)") }
            .addHandler { [weak sideEffects] logs in
                _ = sideEffects?.logAndProcess(logs) { "logged_\($0)" }
            }
        
        eventHandler.handleMany(strings)
        
        // Stream operations
        let stream = FunctionalStream(numbers)
        let streamResult = stream
            .filter { $0 > 3 }
            .map { $0 * 3 }
            .take(5)
            .fold(0) { acc, n in acc + n }
        
        let stringStream = FunctionalStream(strings)
        let groupedResults = stringStream
            .filter { $0.count > 4 }
            .map { $0.uppercased() }
            .groupBy { String($0.first!) }
        
        // Complex closure operations
        let nestedProcessor = ClosureFactory.createNestedFunction()
        let doubleDouble = nestedProcessor(multiplyBy2)
        let nestedResults = numbers.map(doubleDouble)
        
        let conditionalFunc = ClosureFactory.createConditionalFunction()
        let fizzBuzzResults = Array(1...20).map(conditionalFunc)
        
        // Async closure operations
        let asyncProcessor = ClosureFactory.createAsyncProcessor()
        let processAsync = asyncProcessor { result in
            print("Async result: \(result)")
        }
        strings.forEach(processAsync)
        
        // Side effects with functional style
        let countedStrings = sideEffects.countAndFilter(strings) { $0.contains("a") }
        let (measuredResult, duration) = sideEffects.measureAndExecute {
            strings.map { String($0.reversed()) }.joined(separator: ",")
        }
        
        // Functional chain
        functionalChain
            .addHandler { $0.isEmpty ? nil : $0.uppercased() }
            .addHandler { $0.count > 3 ? "LONG_\($0)" : nil }
            .addHandler { $0.contains("L") ? $0.replacingOccurrences(of: "L", with: "X") : nil }
        
        let chainResults = strings.compactMap { functionalChain.handle($0) }
        
        // Complex functional operations with sequence
        let complexResults = strings
            .lazy
            .filter { $0.count > 3 }
            .map { String($0.reversed()) }
            .grouped { String($0.count) }
            .mapValues { values in
                values.map { $0.uppercased() }
                    .reduce("") { "\($0)|\($1)" }
            }
            .filter { $0.value.count > 10 }
        
        // Higher-order function chaining
        let finalProcessor: (String) -> String = { input in
            let functions: [(String) -> String] = [
                { (s: String) in s.trimmingCharacters(in: CharacterSet.whitespaces) },
                { (s: String) in s.lowercased() },
                { (s: String) in s.split(separator: " ").joined(separator: "_") },
                { (s: String) in "final_\(s)" }
            ]
            return functions.reduce(input) { (acc: String, function: (String) -> String) in function(acc) }
        }
        
        let finalResults = strings.map(finalProcessor)
        
        // Functional error handling with Result type
        let safeProcessor: (String) -> Result<String, Error> = { input in
            return Result {
                guard let number = Int(input) else {
                    throw NSError(domain: "ParseError", code: 1, userInfo: nil)
                }
                switch number {
                case let n where n > 0: return "positive"
                case let n where n < 0: return "negative"
                default: return "zero"
                }
            }
        }
        
        let errorHandledResults = ["1", "abc", "-5", "0", "xyz"]
            .map(safeProcessor)
            .compactMap { try? $0.get() }
        
        // Partitioning and grouping operations
        let (shortStrings, longStringsPart) = strings.partitioned { $0.count <= 5 }
        let groupedByLength = strings.grouped { $0.count }
        
        // Complex nested closures with capture lists
        let captureDemo = { [weak self] in
            let localProcessor = { (text: String) -> String in
                return text.split(separator: " ")
                    .enumerated()
                    .map { index, word in "\(index):\(word)" }
                    .joined(separator: "_")
            }
            
            return strings.map { string in
                [string]
                    .map(localProcessor)
                    .map { "captured_\($0)" }
                    .first ?? ""
            }
        }()
        
        // Trailing closure syntax variations
        let trailingClosureResults = numbers.map { $0 * 2 }
            .filter { $0 > 5 }
            .reduce(0) { $0 + $1 }
        
        // Escaping and non-escaping closures
        func processWithCallback(_ input: String, completion: @escaping (String) -> Void) {
            DispatchQueue.global().async {
                let result = input.uppercased()
                DispatchQueue.main.async {
                    completion(result)
                }
            }
        }
        
        strings.forEach { string in
            processWithCallback(string) { result in
                print("Callback result: \(result)")
            }
        }
    }
}