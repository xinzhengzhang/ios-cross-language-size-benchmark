/*
 * iOS Size Benchmark - Test Case Implementation
 * Generated with Claude AI (https://claude.ai)
 * 
 * This Kotlin Native implementation demonstrates language-specific
 * features and patterns for binary size comparison.
 */

package kntr.examples.ios.size.benchmark

// Test case: Generics Heavy - Tests impact of extensive generic usage on code size

// Generic container classes
class Container<T>(val value: T) {
    fun get(): T = value
    fun <R> map(transform: (T) -> R): Container<R> = Container(transform(value))
    fun <R> flatMap(transform: (T) -> Container<R>): Container<R> = transform(value)
}

class Pair<T, U>(val first: T, val second: U) {
    fun <R> mapFirst(transform: (T) -> R): Pair<R, U> = Pair(transform(first), second)
    fun <R> mapSecond(transform: (U) -> R): Pair<T, R> = Pair(first, transform(second))
    fun <R, S> mapBoth(transformFirst: (T) -> R, transformSecond: (U) -> S): Pair<R, S> = 
        Pair(transformFirst(first), transformSecond(second))
}

class Triple<T, U, V>(val first: T, val second: U, val third: V) {
    fun <R> mapFirst(transform: (T) -> R): Triple<R, U, V> = Triple(transform(first), second, third)
    fun <R> mapSecond(transform: (U) -> R): Triple<T, R, V> = Triple(first, transform(second), third)
    fun <R> mapThird(transform: (V) -> R): Triple<T, U, R> = Triple(first, second, transform(third))
}

// Generic collection utilities
class GenericList<T> {
    val items = mutableListOf<T>()
    
    fun add(item: T) { items.add(item) }
    fun get(index: Int): T? = items.getOrNull(index)
    fun <R> map(transform: (T) -> R): GenericList<R> {
        val result = GenericList<R>()
        items.forEach { result.add(transform(it)) }
        return result
    }
    fun filter(predicate: (T) -> Boolean): GenericList<T> {
        val result = GenericList<T>()
        items.forEach { if (predicate(it)) result.add(it) }
        return result
    }
    fun <R> fold(initial: R, operation: (R, T) -> R): R {
        var accumulator = initial
        items.forEach { accumulator = operation(accumulator, it) }
        return accumulator
    }
}

class GenericMap<K, V> {
    val items = mutableMapOf<K, V>()
    
    fun put(key: K, value: V) { items[key] = value }
    fun get(key: K): V? = items[key]
    fun <R> mapValues(transform: (V) -> R): GenericMap<K, R> {
        val result = GenericMap<K, R>()
        items.forEach { (k, v) -> result.put(k, transform(v)) }
        return result
    }
    fun <R> mapKeys(transform: (K) -> R): GenericMap<R, V> {
        val result = GenericMap<R, V>()
        items.forEach { (k, v) -> result.put(transform(k), v) }
        return result
    }
}

class GenericSet<T> {
    val items = mutableSetOf<T>()
    
    fun add(item: T) { items.add(item) }
    fun contains(item: T): Boolean = items.contains(item)
    fun <R> map(transform: (T) -> R): GenericSet<R> {
        val result = GenericSet<R>()
        items.forEach { result.add(transform(it)) }
        return result
    }
}

// Generic processing classes
class Processor<Input, Output>(val process: (Input) -> Output) {
    fun execute(input: Input): Output = process(input)
    fun <NewOutput> chain(next: Processor<Output, NewOutput>): Processor<Input, NewOutput> =
        Processor { next.execute(execute(it)) }
}

class BatchProcessor<T, R> {
    fun processBatch(items: List<T>, processor: (T) -> R): List<R> = items.map(processor)
    fun processParallel(items: List<T>, processor: (T) -> R): List<R> = items.map(processor)
    fun processFiltered(items: List<T>, filter: (T) -> Boolean, processor: (T) -> R): List<R> =
        items.filter(filter).map(processor)
}

class Cache<K, V> {
    val storage = mutableMapOf<K, V>()
    
    fun get(key: K): V? = storage[key]
    fun put(key: K, value: V) { storage[key] = value }
    fun getOrCompute(key: K, compute: (K) -> V): V {
        return storage[key] ?: compute(key).also { storage[key] = it }
    }
}

// Nested generics
class Repository<Entity, Id> {
    val entities = mutableMapOf<Id, Entity>()
    
    fun save(id: Id, entity: Entity) { entities[id] = entity }
    fun findById(id: Id): Entity? = entities[id]
    fun findAll(): List<Entity> = entities.values.toList()
    fun <R> transform(transformer: (Entity) -> R): List<R> = entities.values.map(transformer)
}

class Service<Request, Response> {
    fun handle(request: Request, handler: (Request) -> Response): Response = handler(request)
    fun <NewResponse> map(handler: (Request) -> Response, mapper: (Response) -> NewResponse): (Request) -> NewResponse =
        { request -> mapper(handler(request)) }
}

class Pipeline<T> {
    val stages = mutableListOf<(T) -> T>()
    
    fun addStage(stage: (T) -> T) { stages.add(stage) }
    fun execute(input: T): T = stages.fold(input) { acc, stage -> stage(acc) }
    fun <R> transform(input: T, finalTransform: (T) -> R): R = finalTransform(execute(input))
}

// Complex nested generics
class ComplexContainer<A, B, C> {
    val data = mutableMapOf<A, Pair<B, List<C>>>()
    
    fun store(key: A, value: B, items: List<C>) { data[key] = Pair(value, items) }
    fun retrieve(key: A): Pair<B, List<C>>? = data[key]
    fun <D> mapItems(key: A, transform: (C) -> D): List<D>? = 
        data[key]?.second?.map(transform)
}

class MultiLevelGeneric<T, U, V, W> {
    fun process(
        input: Container<Pair<T, U>>,
        transformer: (T) -> V,
        combiner: (V, U) -> W
    ): Container<W> {
        return input.map { pair ->
            combiner(transformer(pair.first), pair.second)
        }
    }
}

// Generic function interfaces
interface Transformer<In, Out> {
    fun transform(input: In): Out
}

interface Validator<T> {
    fun validate(item: T): Boolean
}

interface Comparator<T> {
    fun compare(a: T, b: T): Int
}

// Implementations
class StringTransformer : Transformer<String, Int> {
    override fun transform(input: String): Int = input.length
}

class NumberValidator : Validator<Number> {
    override fun validate(item: Number): Boolean = item.toDouble() > 0
}

class StringComparator : Comparator<String> {
    override fun compare(a: String, b: String): Int = a.compareTo(b)
}

// Main benchmark class that uses all generics
class IosSizeBenchmark {
    val stringContainer = Container("test")
    val numberContainer = Container(42)
    val pairContainer = Container(Pair("hello", 123))
    
    val stringList = GenericList<String>()
    val numberList = GenericList<Int>()
    val stringMap = GenericMap<String, Int>()
    val numberSet = GenericSet<Double>()
    
    val stringProcessor = Processor<String, Int> { it.length }
    val numberProcessor = Processor<Int, String> { it.toString() }
    val batchProcessor = BatchProcessor<String, Int>()
    val cache = Cache<String, Int>()
    
    val repository = Repository<String, Int>()
    val service = Service<String, Int>()
    val pipeline = Pipeline<String>()
    
    val complexContainer = ComplexContainer<String, Int, Double>()
    val multiLevel = MultiLevelGeneric<String, Int, Double, String>()
    
    val transformer = StringTransformer()
    val validator = NumberValidator()
    val comparator = StringComparator()
    
    fun runBenchmark() {
        // Test containers
        val mappedString = stringContainer.map { it.uppercase() }
        val mappedNumber = numberContainer.map { it * 2 }
        
        // Test pairs and triples
        val pair = Pair("hello", 42)
        val mappedPair = pair.mapFirst { it.length }
        val triple = Triple("a", 1, 2.0)
        val mappedTriple = triple.mapSecond { it * 2 }
        
        // Test collections
        stringList.add("test")
        stringList.add("example")
        val mappedList = stringList.map { it.length }
        val filteredList = stringList.filter { it.length > 3 }
        val foldedResult = stringList.fold(0) { acc, str -> acc + str.length }
        
        stringMap.put("key1", 10)
        stringMap.put("key2", 20)
        val mappedValues = stringMap.mapValues { it * 2 }
        
        numberSet.add(1.0)
        numberSet.add(2.0)
        val mappedSet = numberSet.map { it.toInt() }
        
        // Test processors
        val result1 = stringProcessor.execute("hello")
        val result2 = numberProcessor.execute(42)
        val chainedProcessor = stringProcessor.chain(numberProcessor)
        val chainedResult = chainedProcessor.execute("test")
        
        val batchResult = batchProcessor.processBatch(listOf("a", "bb", "ccc")) { it.length }
        
        cache.put("test", 42)
        val cachedValue = cache.getOrCompute("new") { it.length }
        
        // Test repository and service
        repository.save(1, "entity1")
        repository.save(2, "entity2")
        val allEntities = repository.findAll()
        val transformedEntities = repository.transform { it.uppercase() }
        
        val serviceResult = service.handle("request") { it.length }
        
        pipeline.addStage { it.uppercase() }
        pipeline.addStage { it.reversed() }
        val pipelineResult = pipeline.execute("test")
        
        // Test complex containers
        complexContainer.store("key", 42, listOf(1.0, 2.0, 3.0))
        val mappedItems = complexContainer.mapItems("key") { it * 2 }
        
        val multiLevelInput = Container(Pair("hello", 42))
        val multiLevelResult = multiLevel.process(multiLevelInput, { it.length.toDouble() }, { v, u -> "${v}_$u" })
        
        // Test interfaces
        val transformedString = transformer.transform("hello")
        val isValid = validator.validate(42)
        val comparisonResult = comparator.compare("a", "b")
    }
}