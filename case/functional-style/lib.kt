/*
 * iOS Size Benchmark - Test Case Implementation
 * Generated with Claude AI (https://claude.ai)
 * 
 * This Kotlin Native implementation demonstrates language-specific
 * features and patterns for binary size comparison.
 */

package kntr.examples.ios.size.benchmark

// Test case: Functional Style - Tests impact of lambdas and higher-order functions on code size

// Higher-order function utilities
object FunctionalUtils {
    
    // Basic higher-order functions
    fun <T, R> map(list: List<T>, transform: (T) -> R): List<R> = 
        list.map(transform)
    
    fun <T> filter(list: List<T>, predicate: (T) -> Boolean): List<T> = 
        list.filter(predicate)
    
    fun <T, R> fold(list: List<T>, initial: R, operation: (R, T) -> R): R = 
        list.fold(initial, operation)
    
    fun <T, R> flatMap(list: List<T>, transform: (T) -> List<R>): List<R> = 
        list.flatMap(transform)
    
    // Complex function combinators
    fun <T, R, S> compose(f: (R) -> S, g: (T) -> R): (T) -> S = { x -> f(g(x)) }
    
    fun <T> curry(f: (T, T) -> T): (T) -> (T) -> T = { x -> { y -> f(x, y) } }
    
    fun <T, R> partial(f: (T, T) -> R, x: T): (T) -> R = { y -> f(x, y) }
    
    fun <T> pipe(value: T, vararg functions: (T) -> T): T = 
        functions.fold(value) { acc, fn -> fn(acc) }
    
    // Monadic operations
    fun <T, R> bind(value: T?, transform: (T) -> R?): R? = 
        value?.let(transform)
    
    fun <T> unit(value: T): List<T> = listOf(value)
    
    fun <T, R> flatMapMaybe(value: T?, transform: (T) -> R?): R? = 
        value?.let(transform)
}

// Functional data processing
class DataProcessor<T> {
    val processors: MutableList<(T) -> T> = mutableListOf()
    
    fun addProcessor(processor: (T) -> T): DataProcessor<T> {
        processors.add(processor)
        return this
    }
    
    fun process(data: T): T = processors.fold(data) { acc, processor -> processor(acc) }
    
    fun processMany(data: List<T>): List<T> = data.map { process(it) }
    
    fun processAsync(data: T, callback: (T) -> Unit) = callback(process(data))
    
    fun processConditional(data: T, condition: (T) -> Boolean, processor: (T) -> T): T =
        if (condition(data)) processor(data) else data
}

// Event-driven functional patterns
class EventHandler<T> {
    val handlers: MutableList<(T) -> Unit> = mutableListOf()
    val filters: MutableList<(T) -> Boolean> = mutableListOf()
    val transformers: MutableList<(T) -> T> = mutableListOf()
    
    fun addHandler(handler: (T) -> Unit): EventHandler<T> {
        handlers.add(handler)
        return this
    }
    
    fun addFilter(filter: (T) -> Boolean): EventHandler<T> {
        filters.add(filter)
        return this
    }
    
    fun addTransformer(transformer: (T) -> T): EventHandler<T> {
        transformers.add(transformer)
        return this
    }
    
    fun handle(event: T) {
        if (filters.all { it(event) }) {
            val transformedEvent = transformers.fold(event) { acc, transformer -> transformer(acc) }
            handlers.forEach { it(transformedEvent) }
        }
    }
    
    fun handleMany(events: List<T>) = events.forEach { handle(it) }
    
    fun handleWithCallback(event: T, callback: (T) -> Unit) {
        handle(event)
        callback(event)
    }
}

// Stream-like operations
class FunctionalStream<T>(val data: List<T>) {
    
    fun <R> map(transform: (T) -> R): FunctionalStream<R> = 
        FunctionalStream(data.map(transform))
    
    fun filter(predicate: (T) -> Boolean): FunctionalStream<T> = 
        FunctionalStream(data.filter(predicate))
    
    fun <R> flatMap(transform: (T) -> List<R>): FunctionalStream<R> = 
        FunctionalStream(data.flatMap(transform))
    
    fun forEach(action: (T) -> Unit) = data.forEach(action)
    
    fun <R> fold(initial: R, operation: (R, T) -> R): R = 
        data.fold(initial, operation)
    
    fun reduce(operation: (T, T) -> T): T = data.reduce(operation)
    
    fun take(n: Int): FunctionalStream<T> = FunctionalStream(data.take(n))
    
    fun drop(n: Int): FunctionalStream<T> = FunctionalStream(data.drop(n))
    
    fun zip(other: FunctionalStream<T>): FunctionalStream<Pair<T, T>> = 
        FunctionalStream(data.zip(other.data))
    
    fun groupBy(keySelector: (T) -> String): Map<String, List<T>> = 
        data.groupBy(keySelector)
    
    fun sortedBy(selector: (T) -> Comparable<Any?>): FunctionalStream<T> = 
        FunctionalStream(data.sortedBy(selector))
    
    fun distinct(): FunctionalStream<T> = FunctionalStream(data.distinct())
    
    fun toList(): List<T> = data
}

// Complex lambda expressions and closures
class LambdaFactory {
    
    fun createNumberProcessor(): (Int) -> (Int) -> Int = { multiplier ->
        { number -> number * multiplier }
    }
    
    fun createStringProcessor(): (String) -> (String) -> String = { prefix ->
        { text -> "$prefix: $text" }
    }
    
    fun createValidator(): (String) -> Boolean = { text ->
        text.isNotEmpty() && text.length > 3 && text.all { it.isLetterOrDigit() }
    }
    
    fun createTransformer(): (String) -> String = { text ->
        text.split(" ")
            .filter { it.isNotEmpty() }
            .map { it.lowercase().capitalize() }
            .joinToString(" ")
    }
    
    fun createAggregator(): (List<Int>) -> Int = { numbers ->
        numbers.filter { it > 0 }
            .map { it * it }
            .reduce { acc, value -> acc + value }
    }
    
    fun createComplexProcessor(): (List<String>) -> Map<String, Int> = { strings ->
        strings.filter { it.isNotEmpty() }
            .groupBy { it.first().toString() }
            .mapValues { (_, values) -> values.size }
            .filterValues { it > 1 }
    }
    
    fun createNestedFunction(): ((Int) -> Int) -> (Int) -> Int = { innerFunc ->
        { x -> innerFunc(innerFunc(x)) }
    }
    
    fun createConditionalFunction(): (Int) -> String = { number ->
        when {
            number % 15 == 0 -> "FizzBuzz"
            number % 3 == 0 -> "Fizz"
            number % 5 == 0 -> "Buzz"
            else -> number.toString()
        }
    }
}

// Functional patterns with side effects
class FunctionalSideEffects {
    val logs: MutableList<String> = mutableListOf()
    val counters: MutableMap<String, Int> = mutableMapOf()
    
    fun logAndProcess(text: String, processor: (String) -> String): String {
        logs.add("Processing: $text")
        val result = processor(text)
        logs.add("Result: $result")
        return result
    }
    
    fun countAndFilter(items: List<String>, predicate: (String) -> Boolean): List<String> {
        counters["total"] = items.size
        val filtered = items.filter { item ->
            val passes = predicate(item)
            if (passes) {
                val currentPassed = counters["passed"] ?: 0
                counters["passed"] = currentPassed + 1
            } else {
                val currentFailed = counters["failed"] ?: 0
                counters["failed"] = currentFailed + 1
            }
            passes
        }
        return filtered
    }
    
    fun measureAndExecute(operation: () -> String): Pair<String, Long> {
        val startTime = getCurrentTimeMillis()
        val result = operation()
        val endTime = getCurrentTimeMillis()
        logs.add("Operation took ${endTime - startTime}ms")
        return Pair(result, endTime - startTime)
    }
    
    fun getCurrentTimeMillis(): Long {
        // Platform-agnostic time measurement
        return 0 // Placeholder, replace with actual implementation
    }
}

// Chain of responsibility with lambdas
class FunctionalChain<T> {
    val handlers: MutableList<(T) -> T?> = mutableListOf()
    
    fun addHandler(handler: (T) -> T?): FunctionalChain<T> {
        handlers.add(handler)
        return this
    }
    
    fun handle(input: T): T? {
        return handlers.fold(input as T?) { current, handler ->
            current?.let(handler)
        }
    }
    
    fun handleWithFallback(input: T, fallback: (T) -> T): T {
        return handle(input) ?: fallback(input)
    }
}

// Main benchmark class
class IosSizeBenchmark {
    val dataProcessor = DataProcessor<String>()
    val eventHandler = EventHandler<String>()
    val sideEffects = FunctionalSideEffects()
    val lambdaFactory = LambdaFactory()
    val functionalChain = FunctionalChain<String>()
    
    val numberProcessor = lambdaFactory.createNumberProcessor()
    val stringProcessor = lambdaFactory.createStringProcessor()
    val validator = lambdaFactory.createValidator()
    val transformer = lambdaFactory.createTransformer()
    val aggregator = lambdaFactory.createAggregator()
    val complexProcessor = lambdaFactory.createComplexProcessor()
    
    fun runBenchmark() {
        // Test basic higher-order functions
        val numbers = listOf(1, 2, 3, 4, 5, 6, 7, 8, 9, 10)
        val strings = listOf("hello", "world", "functional", "programming", "kotlin", "lambdas")
        
        // Map operations with different lambda styles
        val doubled = FunctionalUtils.map(numbers) { it * 2 }
        val uppercased = FunctionalUtils.map(strings) { it.uppercase() }
        val lengths = FunctionalUtils.map(strings) { text -> text.length }
        
        // Filter operations
        val evens = FunctionalUtils.filter(numbers) { it % 2 == 0 }
        val longStrings = FunctionalUtils.filter(strings) { it.length > 5 }
        val validStrings = FunctionalUtils.filter(strings, validator)
        
        // Fold operations
        val sum = FunctionalUtils.fold(numbers, 0) { acc, n -> acc + n }
        val concatenated = FunctionalUtils.fold(strings, "") { acc, s -> "$acc $s" }
        val maxLength = FunctionalUtils.fold(strings, 0) { acc, s -> maxOf(acc, s.length) }
        
        // Complex function composition
        val multiplyBy2 = { x: Int -> x * 2 }
        val add10 = { x: Int -> x + 10 }
        val composed = FunctionalUtils.compose(add10, multiplyBy2)
        val composedResults = numbers.map(composed)
        
        // Currying and partial application
        val add = { x: Int, y: Int -> x + y }
        val curriedAdd = FunctionalUtils.curry(add)
        val add5 = curriedAdd(5)
        val addedResults = numbers.map(add5)
        
        // Data processing with lambdas
        dataProcessor
            .addProcessor { it.trim() }
            .addProcessor { it.lowercase() }
            .addProcessor { it.replace(" ", "_") }
            .addProcessor { "processed_$it" }
        
        val processedStrings = dataProcessor.processMany(strings)
        
        // Event handling with lambdas
        eventHandler
            .addFilter { it.isNotEmpty() }
            .addFilter { it.length > 2 }
            .addTransformer { it.uppercase() }
            .addTransformer { "EVENT_$it" }
            .addHandler { logs -> println("Handled: $logs") }
            .addHandler { logs -> sideEffects.logAndProcess(logs) { "logged_$it" } }
        
        eventHandler.handleMany(strings)
        
        // Stream operations
        val stream = FunctionalStream(numbers)
        val streamResult = stream
            .filter { it > 3 }
            .map { it * 3 }
            .take(5)
            .fold(0) { acc, n -> acc + n }
        
        val stringStream = FunctionalStream(strings)
        val groupedResults = stringStream
            .filter { it.length > 4 }
            .map { it.uppercase() }
            .groupBy { it.first().toString() }
        
        // Complex lambda operations
        val nestedProcessor = lambdaFactory.createNestedFunction()
        val doubleDouble = nestedProcessor(multiplyBy2)
        val nestedResults = numbers.map(doubleDouble)
        
        val conditionalFunc = lambdaFactory.createConditionalFunction()
        val fizzBuzzResults = (1..20).map(conditionalFunc)
        
        // Side effects with functional style
        val countedStrings = sideEffects.countAndFilter(strings) { it.contains("a") }
        val (measuredResult, duration) = sideEffects.measureAndExecute {
            strings.map { it.reversed() }.joinToString(",")
        }
        
        // Functional chain
        functionalChain
            .addHandler { if (it.isNotEmpty()) it.uppercase() else null }
            .addHandler { if (it.length > 3) "LONG_$it" else null }
            .addHandler { if (it.contains("L")) it.replace("L", "X") else null }
        
        val chainResults = strings.mapNotNull { functionalChain.handle(it) }
        
        // Complex functional operations
        val complexResults = strings
            .asSequence()
            .filter { it.length > 3 }
            .map { it.reversed() }
            .groupBy { it.length }
            .mapValues { (_, values) -> 
                values.map { it.uppercase() }
                    .reduce { acc, s -> "$acc|$s" }
            }
            .filterValues { it.length > 10 }
            .toMap()
        
        // Higher-order function chaining
        val finalProcessor: (String) -> String = { input ->
            listOf(
                { s: String -> s.trim() },
                { s: String -> s.lowercase() },
                { s: String -> s.split(" ").joinToString("_") },
                { s: String -> "final_$s" }
            ).fold(input) { acc, func -> func(acc) }
        }
        
        val finalResults = strings.map(finalProcessor)
        
        // Functional error handling
        val safeProcessor: (String) -> String? = { input ->
            try {
                input.toIntOrNull()?.let { 
                    when {
                        it > 0 -> "positive"
                        it < 0 -> "negative"
                        else -> "zero"
                    }
                }
            } catch (e: Exception) {
                null
            }
        }
        
        val errorHandledResults = listOf("1", "abc", "-5", "0", "xyz")
            .mapNotNull(safeProcessor)
    }
}