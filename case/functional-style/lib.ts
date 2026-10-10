/*
 * iOS Size Benchmark - Test Case Implementation
 * Generated with Claude AI (https://claude.ai)
 *
 * scriptc (TypeScript-to-native) port of the Kotlin/Swift "functional-style"
 * case. Mirrors the higher-order utilities, closure factories, functional
 * data processors, event handlers, stream pipeline and chain-of-
 * responsibility one-for-one. Kotlin lambdas become TypeScript function
 * values; the `object FunctionalUtils` singleton becomes a class with static
 * methods. All logic is synchronous exactly as the Kotlin version is. A
 * single exported entry (runBenchmark) constructs and exercises every type
 * and method so nothing is dead-code eliminated.
 */

// Test case: Functional Style - lambdas, higher-order functions, closures

// Kotlin's Pair<A, B> has no structural TS analogue in the static tier; model
// it as a tiny immutable class (used by measureAndExecute and Stream.zip).
class Pair<A, B> {
  constructor(public readonly first: A, public readonly second: B) {}
}

function reverseString(s: string): string {
  let out = "";
  for (let i = s.length - 1; i >= 0; i--) {
    out += s.charAt(i);
  }
  return out;
}

function capitalizeFirst(s: string): string {
  if (s.length === 0) {
    return s;
  }
  return s.charAt(0).toUpperCase() + s.slice(1);
}

function isLetterOrDigit(ch: string): boolean {
  const c = ch.charCodeAt(0);
  return (c >= 48 && c <= 57) || (c >= 65 && c <= 90) || (c >= 97 && c <= 122);
}

function allLetterOrDigit(text: string): boolean {
  for (let i = 0; i < text.length; i++) {
    if (!isLetterOrDigit(text.charAt(i))) {
      return false;
    }
  }
  return true;
}

// Kotlin String.toIntOrNull(): returns null for blank/non-integer input
// rather than JS parseInt's NaN/partial-parse behavior.
function toIntOrNull(text: string): number | null {
  if (text.length === 0) {
    return null;
  }
  let start = 0;
  let sign = 1;
  const firstChar = text.charAt(0);
  if (firstChar === "-" || firstChar === "+") {
    if (text.length === 1) {
      return null;
    }
    if (firstChar === "-") {
      sign = -1;
    }
    start = 1;
  }
  let value = 0;
  for (let i = start; i < text.length; i++) {
    const code = text.charCodeAt(i);
    if (code < 48 || code > 57) {
      return null;
    }
    value = value * 10 + (code - 48);
  }
  return sign * value;
}

// Higher-order function utilities. Kotlin `object` singleton -> class with
// static methods preserving the same generic signatures.
class FunctionalUtils {
  static map<T, R>(list: T[], transform: (v: T) => R): R[] {
    return list.map(transform);
  }

  static filter<T>(list: T[], predicate: (v: T) => boolean): T[] {
    return list.filter(predicate);
  }

  static fold<T, R>(list: T[], initial: R, operation: (acc: R, v: T) => R): R {
    return list.reduce(operation, initial);
  }

  static flatMap<T, R>(list: T[], transform: (v: T) => R[]): R[] {
    const result: R[] = [];
    for (const item of list) {
      for (const r of transform(item)) {
        result.push(r);
      }
    }
    return result;
  }

  // Complex function combinators
  static compose<T, R, S>(f: (v: R) => S, g: (v: T) => R): (v: T) => S {
    return (x: T) => f(g(x));
  }

  static curry<T>(f: (a: T, b: T) => T): (a: T) => (b: T) => T {
    return (x: T) => (y: T) => f(x, y);
  }

  static partial<T, R>(f: (a: T, b: T) => R, x: T): (b: T) => R {
    return (y: T) => f(x, y);
  }

  static pipe<T>(value: T, ...functions: Array<(v: T) => T>): T {
    return functions.reduce((acc, fn) => fn(acc), value);
  }

  // Monadic operations
  static bind<T, R>(value: T | null, transform: (v: T) => R | null): R | null {
    return value !== null ? transform(value) : null;
  }

  static unit<T>(value: T): T[] {
    return [value];
  }

  static flatMapMaybe<T, R>(value: T | null, transform: (v: T) => R | null): R | null {
    return value !== null ? transform(value) : null;
  }
}

// Functional data processing
class DataProcessor<T> {
  readonly processors: Array<(v: T) => T> = [];

  addProcessor(processor: (v: T) => T): DataProcessor<T> {
    this.processors.push(processor);
    return this;
  }

  process(data: T): T {
    return this.processors.reduce((acc, processor) => processor(acc), data);
  }

  processMany(data: T[]): T[] {
    return data.map((it) => this.process(it));
  }

  processAsync(data: T, callback: (v: T) => void): void {
    callback(this.process(data));
  }

  processConditional(data: T, condition: (v: T) => boolean, processor: (v: T) => T): T {
    return condition(data) ? processor(data) : data;
  }
}

// Event-driven functional patterns
class EventHandler<T> {
  readonly handlers: Array<(v: T) => void> = [];
  readonly filters: Array<(v: T) => boolean> = [];
  readonly transformers: Array<(v: T) => T> = [];

  addHandler(handler: (v: T) => void): EventHandler<T> {
    this.handlers.push(handler);
    return this;
  }

  addFilter(filter: (v: T) => boolean): EventHandler<T> {
    this.filters.push(filter);
    return this;
  }

  addTransformer(transformer: (v: T) => T): EventHandler<T> {
    this.transformers.push(transformer);
    return this;
  }

  handle(event: T): void {
    if (this.filters.every((it) => it(event))) {
      const transformedEvent = this.transformers.reduce(
        (acc, transformer) => transformer(acc),
        event,
      );
      this.handlers.forEach((it) => it(transformedEvent));
    }
  }

  handleMany(events: T[]): void {
    events.forEach((it) => this.handle(it));
  }

  handleWithCallback(event: T, callback: (v: T) => void): void {
    this.handle(event);
    callback(event);
  }
}

// Stream-like operations
class FunctionalStream<T> {
  constructor(public readonly data: T[]) {}

  map<R>(transform: (v: T) => R): FunctionalStream<R> {
    return new FunctionalStream<R>(this.data.map(transform));
  }

  filter(predicate: (v: T) => boolean): FunctionalStream<T> {
    return new FunctionalStream<T>(this.data.filter(predicate));
  }

  flatMap<R>(transform: (v: T) => R[]): FunctionalStream<R> {
    const result: R[] = [];
    for (const item of this.data) {
      for (const r of transform(item)) {
        result.push(r);
      }
    }
    return new FunctionalStream<R>(result);
  }

  forEach(action: (v: T) => void): void {
    this.data.forEach(action);
  }

  fold<R>(initial: R, operation: (acc: R, v: T) => R): R {
    return this.data.reduce(operation, initial);
  }

  // Kotlin List.reduce throws on an empty list; mirror that semantics.
  reduce(operation: (a: T, b: T) => T): T {
    if (this.data.length === 0) {
      throw new Error("Empty collection can't be reduced.");
    }
    let acc = this.data[0];
    for (let i = 1; i < this.data.length; i++) {
      acc = operation(acc, this.data[i]);
    }
    return acc;
  }

  take(n: number): FunctionalStream<T> {
    return new FunctionalStream<T>(this.data.slice(0, n));
  }

  drop(n: number): FunctionalStream<T> {
    return new FunctionalStream<T>(this.data.slice(n));
  }

  // Kotlin returns FunctionalStream<Pair<T,T>>; scriptc's static tier cannot
  // monomorphize a self-referential FunctionalStream<Pair<...>> (unbounded
  // instantiation), so this returns the zipped Pair[] directly. The pairing
  // data/behavior is identical; only the wrapper differs.
  zip(other: FunctionalStream<T>): Array<Pair<T, T>> {
    const n = Math.min(this.data.length, other.data.length);
    const result: Array<Pair<T, T>> = [];
    for (let i = 0; i < n; i++) {
      result.push(new Pair<T, T>(this.data[i], other.data[i]));
    }
    return result;
  }

  groupBy(keySelector: (v: T) => string): Map<string, T[]> {
    const result = new Map<string, T[]>();
    for (const item of this.data) {
      const key = keySelector(item);
      const bucket = result.get(key);
      if (bucket === undefined) {
        result.set(key, [item]);
      } else {
        bucket.push(item);
      }
    }
    return result;
  }

  sortedBy(selector: (v: T) => number): FunctionalStream<T> {
    const copy = this.data.slice();
    copy.sort((a, b) => selector(a) - selector(b));
    return new FunctionalStream<T>(copy);
  }

  distinct(): FunctionalStream<T> {
    const seen = new Set<T>();
    const result: T[] = [];
    for (const item of this.data) {
      if (!seen.has(item)) {
        seen.add(item);
        result.push(item);
      }
    }
    return new FunctionalStream<T>(result);
  }

  toList(): T[] {
    return this.data;
  }
}

// Complex lambda expressions and closures
class LambdaFactory {
  createNumberProcessor(): (m: number) => (n: number) => number {
    return (multiplier: number) => (num: number) => num * multiplier;
  }

  createStringProcessor(): (p: string) => (t: string) => string {
    return (prefix: string) => (text: string) => `${prefix}: ${text}`;
  }

  createValidator(): (t: string) => boolean {
    return (text: string) => text.length > 0 && text.length > 3 && allLetterOrDigit(text);
  }

  createTransformer(): (t: string) => string {
    return (text: string) =>
      text
        .split(" ")
        .filter((it) => it.length > 0)
        .map((it) => capitalizeFirst(it.toLowerCase()))
        .join(" ");
  }

  createAggregator(): (nums: number[]) => number {
    return (numbers: number[]) =>
      numbers
        .filter((it) => it > 0)
        .map((it) => it * it)
        .reduce((acc, value) => acc + value);
  }

  createComplexProcessor(): (strings: string[]) => Map<string, number> {
    return (strings: string[]) => {
      const grouped = new Map<string, string[]>();
      for (const it of strings.filter((s) => s.length > 0)) {
        const key = it.charAt(0);
        const bucket = grouped.get(key);
        if (bucket === undefined) {
          grouped.set(key, [it]);
        } else {
          bucket.push(it);
        }
      }
      const result = new Map<string, number>();
      for (const entry of grouped) {
        if (entry[1].length > 1) {
          result.set(entry[0], entry[1].length);
        }
      }
      return result;
    };
  }

  createNestedFunction(): (inner: (v: number) => number) => (x: number) => number {
    return (innerFunc: (v: number) => number) => (x: number) => innerFunc(innerFunc(x));
  }

  createConditionalFunction(): (n: number) => string {
    return (num: number) => {
      if (num % 15 === 0) {
        return "FizzBuzz";
      } else if (num % 3 === 0) {
        return "Fizz";
      } else if (num % 5 === 0) {
        return "Buzz";
      } else {
        return `${num}`;
      }
    };
  }
}

// Functional patterns with side effects
class FunctionalSideEffects {
  readonly logs: string[] = [];
  readonly counters = new Map<string, number>();

  logAndProcess(text: string, processor: (v: string) => string): string {
    this.logs.push(`Processing: ${text}`);
    const result = processor(text);
    this.logs.push(`Result: ${result}`);
    return result;
  }

  countAndFilter(items: string[], predicate: (v: string) => boolean): string[] {
    this.counters.set("total", items.length);
    const filtered = items.filter((item) => {
      const passes = predicate(item);
      if (passes) {
        const current = this.counters.get("passed");
        this.counters.set("passed", (current === undefined ? 0 : current) + 1);
      } else {
        const current = this.counters.get("failed");
        this.counters.set("failed", (current === undefined ? 0 : current) + 1);
      }
      return passes;
    });
    return filtered;
  }

  measureAndExecute(operation: () => string): Pair<string, number> {
    const startTime = this.getCurrentTimeMillis();
    const result = operation();
    const endTime = this.getCurrentTimeMillis();
    this.logs.push(`Operation took ${endTime - startTime}ms`);
    return new Pair<string, number>(result, endTime - startTime);
  }

  getCurrentTimeMillis(): number {
    // Platform-agnostic time measurement (matches Kotlin placeholder).
    return 0;
  }
}

// Chain of responsibility with lambdas
class FunctionalChain<T> {
  readonly handlers: Array<(v: T) => T | null> = [];

  addHandler(handler: (v: T) => T | null): FunctionalChain<T> {
    this.handlers.push(handler);
    return this;
  }

  handle(input: T): T | null {
    let current: T | null = input;
    for (const handler of this.handlers) {
      current = current !== null ? handler(current) : null;
    }
    return current;
  }

  handleWithFallback(input: T, fallback: (v: T) => T): T {
    const result = this.handle(input);
    return result !== null ? result : fallback(input);
  }
}

// Main benchmark class
class IosSizeBenchmark {
  readonly dataProcessor = new DataProcessor<string>();
  readonly eventHandler = new EventHandler<string>();
  readonly sideEffects = new FunctionalSideEffects();
  readonly lambdaFactory = new LambdaFactory();
  readonly functionalChain = new FunctionalChain<string>();

  readonly numberProcessor = this.lambdaFactory.createNumberProcessor();
  readonly stringProcessor = this.lambdaFactory.createStringProcessor();
  readonly validator = this.lambdaFactory.createValidator();
  readonly transformer = this.lambdaFactory.createTransformer();
  readonly aggregator = this.lambdaFactory.createAggregator();
  readonly complexProcessor = this.lambdaFactory.createComplexProcessor();

  runBenchmark(): void {
    // Test basic higher-order functions
    const numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
    const strings = ["hello", "world", "functional", "programming", "kotlin", "lambdas"];

    // Map operations with different lambda styles
    const doubled = FunctionalUtils.map(numbers, (it) => it * 2);
    const uppercased = FunctionalUtils.map(strings, (it) => it.toUpperCase());
    const lengths = FunctionalUtils.map(strings, (text) => text.length);

    // Filter operations
    const evens = FunctionalUtils.filter(numbers, (it) => it % 2 === 0);
    const longStrings = FunctionalUtils.filter(strings, (it) => it.length > 5);
    const validStrings = FunctionalUtils.filter(strings, this.validator);

    // Fold operations
    const sum = FunctionalUtils.fold(numbers, 0, (acc, n) => acc + n);
    const concatenated = FunctionalUtils.fold(strings, "", (acc, s) => `${acc} ${s}`);
    const maxLength = FunctionalUtils.fold(strings, 0, (acc, s) => Math.max(acc, s.length));

    // Complex function composition
    const multiplyBy2 = (x: number) => x * 2;
    const add10 = (x: number) => x + 10;
    const composed = FunctionalUtils.compose(add10, multiplyBy2);
    const composedResults = numbers.map(composed);

    // Currying and partial application
    const add = (x: number, y: number) => x + y;
    const curriedAdd = FunctionalUtils.curry(add);
    const add5 = curriedAdd(5);
    const addedResults = numbers.map(add5);

    // Data processing with lambdas
    this.dataProcessor
      .addProcessor((it) => it.trim())
      .addProcessor((it) => it.toLowerCase())
      .addProcessor((it) => it.split(" ").join("_"))
      .addProcessor((it) => `processed_${it}`);

    const processedStrings = this.dataProcessor.processMany(strings);

    // Event handling with lambdas
    this.eventHandler
      .addFilter((it) => it.length > 0)
      .addFilter((it) => it.length > 2)
      .addTransformer((it) => it.toUpperCase())
      .addTransformer((it) => `EVENT_${it}`)
      .addHandler((logs) => console.log(`Handled: ${logs}`))
      .addHandler((logs) => {
        this.sideEffects.logAndProcess(logs, (it) => `logged_${it}`);
      });

    this.eventHandler.handleMany(strings);

    // Stream operations. The static tier only resolves generic methods
    // (map/fold/groupBy) through a plain variable receiver, so each pipeline
    // stage is bound to its own variable instead of fluent-chained.
    const stream = new FunctionalStream(numbers);
    const streamFiltered = stream.filter((it) => it > 3);
    const streamMapped = streamFiltered.map((it) => it * 3);
    const streamTaken = streamMapped.take(5);
    const streamResult = streamTaken.fold(0, (acc, n) => acc + n);

    const stringStream = new FunctionalStream(strings);
    const stringFiltered = stringStream.filter((it) => it.length > 4);
    const stringMapped = stringFiltered.map((it) => it.toUpperCase());
    const groupedResults = stringMapped.groupBy((it) => it.charAt(0));

    // Complex lambda operations
    const nestedProcessor = this.lambdaFactory.createNestedFunction();
    const doubleDouble = nestedProcessor(multiplyBy2);
    const nestedResults = numbers.map(doubleDouble);

    const conditionalFunc = this.lambdaFactory.createConditionalFunction();
    const fizzBuzzNumbers: number[] = [];
    for (let i = 1; i <= 20; i++) {
      fizzBuzzNumbers.push(i);
    }
    const fizzBuzzResults = fizzBuzzNumbers.map(conditionalFunc);

    // Side effects with functional style
    const countedStrings = this.sideEffects.countAndFilter(strings, (it) => it.includes("a"));
    const measured = this.sideEffects.measureAndExecute(() =>
      strings.map((it) => reverseString(it)).join(","),
    );
    const measuredResult = measured.first;
    const duration = measured.second;

    // Functional chain
    this.functionalChain
      .addHandler((it) => (it.length > 0 ? it.toUpperCase() : null))
      .addHandler((it) => (it.length > 3 ? `LONG_${it}` : null))
      .addHandler((it) => (it.includes("L") ? it.split("L").join("X") : null));

    const chainResults: string[] = [];
    for (const s of strings) {
      const handled = this.functionalChain.handle(s);
      if (handled !== null) {
        chainResults.push(handled);
      }
    }

    // Complex functional operations: filter > reverse > group by length >
    // join uppercased values with '|' > keep groups whose value length > 10.
    const complexFiltered = strings
      .filter((it) => it.length > 3)
      .map((it) => reverseString(it));
    const complexGrouped = new Map<number, string[]>();
    for (const it of complexFiltered) {
      const bucket = complexGrouped.get(it.length);
      if (bucket === undefined) {
        complexGrouped.set(it.length, [it]);
      } else {
        bucket.push(it);
      }
    }
    const complexResults = new Map<number, string>();
    for (const entry of complexGrouped) {
      const joined = entry[1]
        .map((it) => it.toUpperCase())
        .reduce((acc, s) => `${acc}|${s}`);
      if (joined.length > 10) {
        complexResults.set(entry[0], joined);
      }
    }

    // Higher-order function chaining
    const finalProcessor = (input: string): string => {
      const functions: Array<(s: string) => string> = [
        (s: string) => s.trim(),
        (s: string) => s.toLowerCase(),
        (s: string) => s.split(" ").join("_"),
        (s: string) => `final_${s}`,
      ];
      return functions.reduce((acc, func) => func(acc), input);
    };

    const finalResults = strings.map(finalProcessor);

    // Functional error handling
    const safeProcessor = (input: string): string | null => {
      const parsed = toIntOrNull(input);
      if (parsed === null) {
        return null;
      }
      if (parsed > 0) {
        return "positive";
      } else if (parsed < 0) {
        return "negative";
      } else {
        return "zero";
      }
    };

    const errorHandledResults: string[] = [];
    for (const value of ["1", "abc", "-5", "0", "xyz"]) {
      const mapped = safeProcessor(value);
      if (mapped !== null) {
        errorHandledResults.push(mapped);
      }
    }

    // Exercise the remainder of the declared API surface so nothing is
    // dead-code eliminated (the Kotlin version declares these too). Every
    // call below is a faithful use of the same operation.
    const flatMapped = FunctionalUtils.flatMap(numbers, (n) => [n, n * 10]);
    const partialAdd = FunctionalUtils.partial<number, number>(add, 100);
    const partialResults = numbers.map(partialAdd);
    const piped = FunctionalUtils.pipe(5, multiplyBy2, add10);
    const bound = FunctionalUtils.bind(7, (v) => v * 3);
    const maybe = FunctionalUtils.flatMapMaybe<number, number>(null, (v) => v + 1);
    const unitList = FunctionalUtils.unit("solo");

    const asyncOutputs: string[] = [];
    this.dataProcessor.processAsync("async input", (v) => asyncOutputs.push(v));
    const conditional = this.dataProcessor.processConditional(
      "cond",
      (v) => v.length > 2,
      (v) => `cond_${v}`,
    );

    const callbackSeen: string[] = [];
    this.eventHandler.handleWithCallback("direct", (v) => callbackSeen.push(v));

    const baseStringStream = new FunctionalStream(strings);
    const flatStream = baseStringStream.flatMap((s) => s.split(""));
    let forEachCount = 0;
    flatStream.forEach(() => {
      forEachCount++;
    });
    const flatStreamList = flatStream.toList();
    const reduceStream = new FunctionalStream(numbers);
    const streamReduced = reduceStream.reduce((a, b) => a + b);
    const dropStream = new FunctionalStream(numbers);
    const dropped = dropStream.drop(3).toList();
    const zipStream = new FunctionalStream(numbers);
    const zipped = zipStream.zip(new FunctionalStream(doubled));
    const sortStream = new FunctionalStream([3, 1, 2]);
    const sorted = sortStream.sortedBy((v) => v).toList();
    const distinctStream = new FunctionalStream([1, 1, 2, 3, 3]);
    const distinctValues = distinctStream.distinct().toList();

    const numberFn = this.numberProcessor(3);
    const numberFnResult = numberFn(4);
    const stringFn = this.stringProcessor("prefix");
    const stringFnResult = stringFn("body");
    const transformed = this.transformer("hello world functional");
    const aggregated = this.aggregator(numbers);
    const complexMap = this.complexProcessor(strings);
    const fallbackResult = this.functionalChain.handleWithFallback("", (v) => `fallback_${v}`);

    console.log("Functional-style benchmark completed:");
    console.log(
      `- doubled: ${doubled.length}, uppercased: ${uppercased.length}, lengths: ${lengths.length}`,
    );
    console.log(
      `- evens: ${evens.length}, longStrings: ${longStrings.length}, validStrings: ${validStrings.length}`,
    );
    console.log(`- sum: ${sum}, concatenated len: ${concatenated.length}, maxLength: ${maxLength}`);
    console.log(
      `- composed: ${composedResults.length}, added: ${addedResults.length}, processed: ${processedStrings.length}`,
    );
    console.log(
      `- streamResult: ${streamResult}, grouped keys: ${groupedResults.size}, nested: ${nestedResults.length}`,
    );
    console.log(
      `- fizzBuzz: ${fizzBuzzResults.length}, counted: ${countedStrings.length}, measured: ${measuredResult.length}/${duration}`,
    );
    console.log(
      `- chain: ${chainResults.length}, complex: ${complexResults.size}, final: ${finalResults.length}, errors: ${errorHandledResults.length}`,
    );
    console.log(
      `- flatMapped: ${flatMapped.length}, partial: ${partialResults.length}, piped: ${piped}, bound: ${bound}, maybe: ${maybe === null ? "null" : maybe}, unit: ${unitList.length}`,
    );
    console.log(
      `- async: ${asyncOutputs.length}, conditional: ${conditional}, callback: ${callbackSeen.length}`,
    );
    console.log(
      `- flatStream: ${flatStreamList.length}/${forEachCount}, reduced: ${streamReduced}, dropped: ${dropped.length}, zipped: ${zipped.length}, sorted: ${sorted.length}, distinct: ${distinctValues.length}`,
    );
    console.log(
      `- numberFn: ${numberFnResult}, stringFn: ${stringFnResult}, transformed: ${transformed}, aggregated: ${aggregated}, complexMap: ${complexMap.size}, fallback: ${fallbackResult}`,
    );
  }
}

export function runBenchmark(): void {
  const benchmark = new IosSizeBenchmark();
  benchmark.runBenchmark();
}
