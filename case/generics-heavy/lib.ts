/*
 * iOS Size Benchmark - Test Case Implementation
 * Generated with Claude AI (https://claude.ai)
 *
 * scriptc (TypeScript-to-native) port of the Kotlin/Swift "generics-heavy"
 * case. Mirrors the generic container/collection/processor/repository types
 * and the generic function interfaces one-for-one. A single exported entry
 * (runBenchmark) constructs and exercises every generic type and method so
 * nothing is dead-code eliminated, matching the Swift `public` requirement.
 */

// Test case: Generics Heavy - Tests impact of extensive generic usage on code size

// Generic container classes
class Container<T> {
  constructor(public readonly value: T) {}
  get(): T { return this.value; }
  map<R>(transform: (v: T) => R): Container<R> { return new Container<R>(transform(this.value)); }
  flatMap<R>(transform: (v: T) => Container<R>): Container<R> { return transform(this.value); }
}

class Pair<T, U> {
  constructor(public readonly first: T, public readonly second: U) {}
  mapFirst<R>(transform: (t: T) => R): Pair<R, U> { return new Pair<R, U>(transform(this.first), this.second); }
  mapSecond<R>(transform: (u: U) => R): Pair<T, R> { return new Pair<T, R>(this.first, transform(this.second)); }
  mapBoth<R, S>(transformFirst: (t: T) => R, transformSecond: (u: U) => S): Pair<R, S> {
    return new Pair<R, S>(transformFirst(this.first), transformSecond(this.second));
  }
}

class Triple<T, U, V> {
  constructor(public readonly first: T, public readonly second: U, public readonly third: V) {}
  mapFirst<R>(transform: (t: T) => R): Triple<R, U, V> { return new Triple<R, U, V>(transform(this.first), this.second, this.third); }
  mapSecond<R>(transform: (u: U) => R): Triple<T, R, V> { return new Triple<T, R, V>(this.first, transform(this.second), this.third); }
  mapThird<R>(transform: (v: V) => R): Triple<T, U, R> { return new Triple<T, U, R>(this.first, this.second, transform(this.third)); }
}

// Generic collection utilities
class GenericList<T> {
  readonly items: T[] = [];
  add(item: T): void { this.items.push(item); }
  get(index: number): T | null { return index >= 0 && index < this.items.length ? this.items[index] : null; }
  map<R>(transform: (v: T) => R): GenericList<R> {
    const result = new GenericList<R>();
    for (const it of this.items) { result.add(transform(it)); }
    return result;
  }
  filter(predicate: (v: T) => boolean): GenericList<T> {
    const result = new GenericList<T>();
    for (const it of this.items) { if (predicate(it)) { result.add(it); } }
    return result;
  }
  fold<R>(initial: R, operation: (acc: R, v: T) => R): R {
    let accumulator = initial;
    for (const it of this.items) { accumulator = operation(accumulator, it); }
    return accumulator;
  }
}

class GenericMap<K, V> {
  readonly items = new Map<K, V>();
  put(key: K, value: V): void { this.items.set(key, value); }
  get(key: K): V | null { const v = this.items.get(key); return v === undefined ? null : v; }
  mapValues<R>(transform: (v: V) => R): GenericMap<K, R> {
    const result = new GenericMap<K, R>();
    for (const entry of this.items) { result.put(entry[0], transform(entry[1])); }
    return result;
  }
  mapKeys<R>(transform: (k: K) => R): GenericMap<R, V> {
    const result = new GenericMap<R, V>();
    for (const entry of this.items) { result.put(transform(entry[0]), entry[1]); }
    return result;
  }
}

class GenericSet<T> {
  readonly items = new Set<T>();
  add(item: T): void { this.items.add(item); }
  contains(item: T): boolean { return this.items.has(item); }
  map<R>(transform: (v: T) => R): GenericSet<R> {
    const result = new GenericSet<R>();
    for (const it of this.items) { result.add(transform(it)); }
    return result;
  }
}

// Generic processing classes
class Processor<Input, Output> {
  constructor(public readonly process: (input: Input) => Output) {}
  execute(input: Input): Output { return this.process(input); }
  chain<NewOutput>(next: Processor<Output, NewOutput>): Processor<Input, NewOutput> {
    return new Processor<Input, NewOutput>((it: Input) => next.execute(this.execute(it)));
  }
}

class BatchProcessor<T, R> {
  processBatch(items: T[], processor: (v: T) => R): R[] {
    const result: R[] = [];
    for (const it of items) { result.push(processor(it)); }
    return result;
  }
  processParallel(items: T[], processor: (v: T) => R): R[] {
    const result: R[] = [];
    for (const it of items) { result.push(processor(it)); }
    return result;
  }
  processFiltered(items: T[], filter: (v: T) => boolean, processor: (v: T) => R): R[] {
    const result: R[] = [];
    for (const it of items) { if (filter(it)) { result.push(processor(it)); } }
    return result;
  }
}

class Cache<K, V> {
  readonly storage = new Map<K, V>();
  get(key: K): V | null { const v = this.storage.get(key); return v === undefined ? null : v; }
  put(key: K, value: V): void { this.storage.set(key, value); }
  getOrCompute(key: K, compute: (k: K) => V): V {
    const existing = this.storage.get(key);
    if (existing !== undefined) { return existing; }
    const computed = compute(key);
    this.storage.set(key, computed);
    return computed;
  }
}

// Nested generics
class Repository<Entity, Id> {
  readonly entities = new Map<Id, Entity>();
  save(id: Id, entity: Entity): void { this.entities.set(id, entity); }
  findById(id: Id): Entity | null { const v = this.entities.get(id); return v === undefined ? null : v; }
  findAll(): Entity[] {
    const result: Entity[] = [];
    for (const entry of this.entities) { result.push(entry[1]); }
    return result;
  }
  transform<R>(transformer: (e: Entity) => R): R[] {
    const result: R[] = [];
    for (const entry of this.entities) { result.push(transformer(entry[1])); }
    return result;
  }
}

class Service<Request, Response> {
  handle(request: Request, handler: (r: Request) => Response): Response { return handler(request); }
  map<NewResponse>(handler: (r: Request) => Response, mapper: (r: Response) => NewResponse): (r: Request) => NewResponse {
    return (request: Request) => mapper(handler(request));
  }
}

class Pipeline<T> {
  readonly stages: Array<(v: T) => T> = [];
  addStage(stage: (v: T) => T): void { this.stages.push(stage); }
  execute(input: T): T {
    let acc = input;
    for (const stage of this.stages) { acc = stage(acc); }
    return acc;
  }
  transform<R>(input: T, finalTransform: (v: T) => R): R { return finalTransform(this.execute(input)); }
}

// Complex nested generics
class ComplexContainer<A, B, C> {
  readonly data = new Map<A, Pair<B, C[]>>();
  store(key: A, value: B, items: C[]): void { this.data.set(key, new Pair<B, C[]>(value, items)); }
  retrieve(key: A): Pair<B, C[]> | null { const v = this.data.get(key); return v === undefined ? null : v; }
  mapItems<D>(key: A, transform: (c: C) => D): D[] | null {
    const entry = this.data.get(key);
    if (entry === undefined) { return null; }
    const result: D[] = [];
    for (const it of entry.second) { result.push(transform(it)); }
    return result;
  }
}

class MultiLevelGeneric<T, U, V, W> {
  process(
    input: Container<Pair<T, U>>,
    transformer: (t: T) => V,
    combiner: (v: V, u: U) => W
  ): Container<W> {
    return input.map((pair: Pair<T, U>) => combiner(transformer(pair.first), pair.second));
  }
}

// Generic function interfaces
interface Transformer<In, Out> {
  transform(input: In): Out;
}

interface Validator<T> {
  validate(item: T): boolean;
}

interface Comparator<T> {
  compare(a: T, b: T): number;
}

// Implementations
class StringTransformer implements Transformer<string, number> {
  transform(input: string): number { return input.length; }
}

class NumberValidator implements Validator<number> {
  validate(item: number): boolean { return item > 0; }
}

class StringComparator implements Comparator<string> {
  compare(a: string, b: string): number { return a < b ? -1 : (a > b ? 1 : 0); }
}

function reverseString(s: string): string {
  let out = "";
  for (let i = s.length - 1; i >= 0; i--) { out += s.charAt(i); }
  return out;
}

// Main benchmark class that uses all generics
class IosSizeBenchmark {
  readonly stringContainer = new Container<string>("test");
  readonly numberContainer = new Container<number>(42);
  readonly pairContainer = new Container<Pair<string, number>>(new Pair<string, number>("hello", 123));

  readonly stringList = new GenericList<string>();
  readonly numberList = new GenericList<number>();
  readonly stringMap = new GenericMap<string, number>();
  readonly numberSet = new GenericSet<number>();

  readonly stringProcessor = new Processor<string, number>((it: string) => it.length);
  readonly numberProcessor = new Processor<number, string>((it: number) => `${it}`);
  readonly batchProcessor = new BatchProcessor<string, number>();
  readonly cache = new Cache<string, number>();

  readonly repository = new Repository<string, number>();
  readonly service = new Service<string, number>();
  readonly pipeline = new Pipeline<string>();

  readonly complexContainer = new ComplexContainer<string, number, number>();
  readonly multiLevel = new MultiLevelGeneric<string, number, number, string>();

  readonly transformer = new StringTransformer();
  readonly validator = new NumberValidator();
  readonly comparator = new StringComparator();

  runBenchmark(): void {
    // Test containers
    const mappedString = this.stringContainer.map((it: string) => it.toUpperCase());
    const mappedNumber = this.numberContainer.map((it: number) => it * 2);
    const flatMapped = this.numberContainer.flatMap((it: number) => new Container<number>(it + 1));
    const containedPair = this.pairContainer.get();

    // Test pairs and triples
    const pair = new Pair<string, number>("hello", 42);
    const mappedPair = pair.mapFirst((it: string) => it.length);
    const bothPair = pair.mapBoth((a: string) => a.length, (b: number) => b + 1);
    const triple = new Triple<string, number, number>("a", 1, 2.0);
    const mappedTriple = triple.mapSecond((it: number) => it * 2);
    const firstTriple = triple.mapFirst((it: string) => it.length);
    const thirdTriple = triple.mapThird((it: number) => it + 1.0);

    // Test collections
    this.stringList.add("test");
    this.stringList.add("example");
    const firstItem = this.stringList.get(0);
    const mappedList = this.stringList.map((it: string) => it.length);
    const filteredList = this.stringList.filter((it: string) => it.length > 3);
    const foldedResult = this.stringList.fold(0, (acc: number, str: string) => acc + str.length);
    this.numberList.add(7);

    this.stringMap.put("key1", 10);
    this.stringMap.put("key2", 20);
    const mappedValues = this.stringMap.mapValues((it: number) => it * 2);
    const mappedKeys = this.stringMap.mapKeys((it: string) => it.length);

    this.numberSet.add(1.0);
    this.numberSet.add(2.0);
    const hasOne = this.numberSet.contains(1.0);
    const mappedSet = this.numberSet.map((it: number) => Math.trunc(it));

    // Test processors
    const result1 = this.stringProcessor.execute("hello");
    const result2 = this.numberProcessor.execute(42);
    const chainedProcessor = this.stringProcessor.chain(this.numberProcessor);
    const chainedResult = chainedProcessor.execute("test");

    const batchResult = this.batchProcessor.processBatch(["a", "bb", "ccc"], (it: string) => it.length);
    const parallelResult = this.batchProcessor.processParallel(["a", "bb"], (it: string) => it.length);
    const filteredBatch = this.batchProcessor.processFiltered(["a", "bb", "ccc"], (it: string) => it.length > 1, (it: string) => it.length);

    this.cache.put("test", 42);
    const cachedValue = this.cache.getOrCompute("new", (it: string) => it.length);
    const existingValue = this.cache.get("test");

    // Test repository and service
    this.repository.save(1, "entity1");
    this.repository.save(2, "entity2");
    const foundEntity = this.repository.findById(1);
    const allEntities = this.repository.findAll();
    const transformedEntities = this.repository.transform((it: string) => it.toUpperCase());

    const serviceResult = this.service.handle("request", (it: string) => it.length);
    const serviceMapped = this.service.map((it: string) => it.length, (n: number) => n * 2);
    const serviceMappedResult = serviceMapped("abcd");

    this.pipeline.addStage((it: string) => it.toUpperCase());
    this.pipeline.addStage((it: string) => reverseString(it));
    const pipelineResult = this.pipeline.execute("test");
    const pipelineTransform = this.pipeline.transform("test", (it: string) => it.length);

    // Test complex containers
    this.complexContainer.store("key", 42, [1.0, 2.0, 3.0]);
    const retrieved = this.complexContainer.retrieve("key");
    const mappedItems = this.complexContainer.mapItems("key", (it: number) => it * 2);

    const multiLevelInput = new Container<Pair<string, number>>(new Pair<string, number>("hello", 42));
    const multiLevelResult = this.multiLevel.process(
      multiLevelInput,
      (it: string) => it.length,
      (v: number, u: number) => `${v}_${u}`
    );

    // Test interfaces
    const transformedString = this.transformer.transform("hello");
    const isValid = this.validator.validate(42.0);
    const comparisonResult = this.comparator.compare("a", "b");

    console.log("Generics-heavy benchmark completed:");
    console.log(`- mappedString: ${mappedString.get()}, mappedNumber: ${mappedNumber.get()}, flatMapped: ${flatMapped.get()}`);
    console.log(`- containedPair: ${containedPair.first}/${containedPair.second}`);
    console.log(`- mappedPair: ${mappedPair.first}, both: ${bothPair.first}/${bothPair.second}`);
    console.log(`- triple: ${mappedTriple.second}/${firstTriple.first}/${thirdTriple.third}`);
    console.log(`- firstItem: ${firstItem}, mappedList: ${mappedList.items.length}, filteredList: ${filteredList.items.length}, folded: ${foldedResult}`);
    console.log(`- numberList: ${this.numberList.items.length}, mappedValues(key1): ${mappedValues.get("key1")}, mappedKeys(5): ${mappedKeys.get(4)}`);
    console.log(`- hasOne: ${hasOne}, mappedSet: ${mappedSet.items.size}`);
    console.log(`- result1: ${result1}, result2: ${result2}, chained: ${chainedResult}`);
    console.log(`- batch: ${batchResult.length}, parallel: ${parallelResult.length}, filteredBatch: ${filteredBatch.length}`);
    console.log(`- cached: ${cachedValue}, existing: ${existingValue}`);
    console.log(`- found: ${foundEntity}, all: ${allEntities.length}, transformed: ${transformedEntities.length}`);
    console.log(`- service: ${serviceResult}, serviceMapped: ${serviceMappedResult}`);
    console.log(`- pipeline: ${pipelineResult}, pipelineTransform: ${pipelineTransform}`);
    console.log(`- retrieved: ${retrieved === null ? 0 : retrieved.second.length}, mappedItems: ${mappedItems === null ? 0 : mappedItems.length}`);
    console.log(`- multiLevel: ${multiLevelResult.get()}`);
    console.log(`- transformedString: ${transformedString}, isValid: ${isValid}, comparison: ${comparisonResult}`);
  }
}

export function runBenchmark(): void {
  const benchmark = new IosSizeBenchmark();
  benchmark.runBenchmark();
}




