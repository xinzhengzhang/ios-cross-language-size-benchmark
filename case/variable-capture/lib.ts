/*
 * iOS Size Benchmark - Test Case Implementation
 * Generated with Claude AI (https://claude.ai)
 *
 * scriptc (TypeScript-to-native) port of the Kotlin `variable-capture` case
 * (lib.kt is authoritative). It models the closures-capturing-many-variables
 * pattern with TS arrow functions capturing the same locals (strings, arrays,
 * maps, a mutable string builder, byte arrays, numbers, and object refs),
 * including nested closures and a recursive closure. The Kotlin lambdas are
 * synchronous (the "async" lambda is invoked directly), so this port stays
 * synchronous too.
 *
 * Kotlin `List<Any>` / `Map<String, Any>` are forbidden on the static tier
 * (`any`), so they become a narrow union: scalars plus scalar arrays, which
 * covers every value stored in this case. Kotlin `StringBuilder` becomes a
 * small MutableString class; `ByteArray` becomes number[] (UTF-8 bytes).
 */

type Scalar = string | number;
type CaptureValue = string | number | Array<Scalar>;

function utf8Encode(text: string): number[] {
  const out: number[] = [];
  for (let i = 0; i < text.length; i++) {
    const code = text.charCodeAt(i);
    if (code < 0x80) {
      out.push(code);
    } else if (code < 0x800) {
      out.push(0xc0 | (code >> 6), 0x80 | (code & 0x3f));
    } else {
      out.push(0xe0 | (code >> 12), 0x80 | ((code >> 6) & 0x3f), 0x80 | (code & 0x3f));
    }
  }
  return out;
}

// Mirrors the mutable, by-reference capture semantics of Kotlin's StringBuilder.
class MutableString {
  private value: string;
  constructor(initial: string) {
    this.value = initial;
  }
  append(s: string): MutableString {
    this.value = this.value + s;
    return this;
  }
  get length(): number {
    return this.value.length;
  }
  toString(): string {
    return this.value;
  }
}

function captureValueToString(v: CaptureValue): string {
  if (typeof v === "string") return v;
  if (typeof v === "number") return `${v}`;
  return `[${v.join(", ")}]`;
}

// Kotlin `data class DataContainer`; only field access is exercised here, so
// no generated equals/hashCode/copy are needed.
class DataContainer {
  constructor(
    public stringValue: string,
    public arrayValue: Scalar[],
    public dictValue: Map<string, CaptureValue>,
    public mutableString: MutableString,
    public dataValue: number[],
  ) {}
}
class CaptureTestService {
  // Accumulated so the captured work is observably used (printed by runBenchmark).
  sink = 0;

  performVariableCaptureStressTest(): void {
    for (let i = 1; i <= 1000; i++) {
      this.createComplexClosureWithManyCaptures(i);
      if (i % 100 === 0) {
        this.nestedCaptureTest(10);
      }
    }
  }

  createComplexClosureWithManyCaptures(iteration: number): void {
    const str1 = `String_${iteration}`;
    const str2 = `AnotherString_${iteration * 2}`;
    const str3 = `ThirdString_${iteration * 3}`;
    const str4 = `FourthString_${iteration * 4}`;
    const str5 = `FifthString_${iteration * 5}`;

    const array1: Scalar[] = [iteration, iteration * 2, iteration * 3];
    const array2: Scalar[] = [str1, str2, str3];
    const array3: Scalar[] = [iteration + 100, iteration + 200, iteration + 300];
    const array4: Scalar[] = [str4, str5, `Extra_${iteration}`];
    const array5: Scalar[] = [iteration % 10, iteration % 20, iteration % 30];

    const dict1 = new Map<string, CaptureValue>([["key1", str1], ["key2", iteration], ["key3", array1]]);
    const dict2 = new Map<string, CaptureValue>([["data", str2], ["count", iteration * 2], ["items", array2]]);
    const dict3 = new Map<string, CaptureValue>([["id", iteration], ["name", str3], ["values", array3]]);
    const dict4 = new Map<string, CaptureValue>([["type", str4], ["index", iteration * 4], ["list", array4]]);
    const dict5 = new Map<string, CaptureValue>([["category", str5], ["size", iteration * 5], ["elements", array5]]);

    const mutable1 = new MutableString(`Mutable_${iteration}`);
    const mutable2 = new MutableString(`Dynamic_${iteration * 2}`);
    const mutable3 = new MutableString(`Buffer_${iteration * 3}`);
    const mutable4 = new MutableString(`Content_${iteration * 4}`);
    const mutable5 = new MutableString(`Text_${iteration * 5}`);

    const data1 = utf8Encode(str1);
    const data2 = utf8Encode(str2);
    const data3 = utf8Encode(str3);
    const data4 = utf8Encode(str4);
    const data5 = utf8Encode(str5);

    const container1 = new DataContainer(str1, array1, dict1, mutable1, data1);
    const container2 = new DataContainer(str2, array2, dict2, mutable2, data2);
    const container3 = new DataContainer(str3, array3, dict3, mutable3, data3);
    const container4 = new DataContainer(str4, array4, dict4, mutable4, data4);
    const container5 = new DataContainer(str5, array5, dict5, mutable5, data5);

    const num1 = iteration;
    const num2 = iteration * 1.5;
    const num3 = iteration * 2.5;
    const num4 = iteration * 3.5;
    const num5 = iteration * 4.5;

    const complexClosure: () => void = () => {
      console.log(`Processing: ${str1}, ${str2}, ${str3}, ${str4}, ${str5}`);

      for (const item of array1) console.log(`Array1 item: ${item}`);
      for (const item of array2) console.log(`Array2 item: ${item}`);
      for (const item of array3) console.log(`Array3 item: ${item}`);
      for (const item of array4) console.log(`Array4 item: ${item}`);
      for (const item of array5) console.log(`Array5 item: ${item}`);

      for (const [key, value] of dict1) console.log(`Dict1 ${key}: ${captureValueToString(value)}`);
      for (const [key, value] of dict2) console.log(`Dict2 ${key}: ${captureValueToString(value)}`);
      for (const [key, value] of dict3) console.log(`Dict3 ${key}: ${captureValueToString(value)}`);
      for (const [key, value] of dict4) console.log(`Dict4 ${key}: ${captureValueToString(value)}`);
      for (const [key, value] of dict5) console.log(`Dict5 ${key}: ${captureValueToString(value)}`);

      mutable1.append("_modified");
      mutable2.append("_modified");
      mutable3.append("_modified");
      mutable4.append("_modified");
      mutable5.append("_modified");

      console.log(`Data lengths: ${data1.length}, ${data2.length}, ${data3.length}, ${data4.length}, ${data5.length}`);

      console.log(`Container values: ${container1.stringValue}, ${container2.stringValue}, ${container3.stringValue}, ${container4.stringValue}, ${container5.stringValue}`);

      const calculation = num1 + num2 + num3 + num4 + num5;
      console.log(`Calculation result: ${calculation}`);
      this.sink += Math.trunc(calculation) + mutable1.length + container5.dataValue.length;

      const nestedClosure: () => void = () => {
        console.log(`Nested access: ${str1}, ${str3}`);
        console.log(`Nested containers: ${container1.stringValue}, ${container3.stringValue}`);
        console.log(`Nested numbers: ${num1}, ${num3}`);

        const deepNestedClosure: () => void = () => {
          console.log(`Deep nested: ${str2}`);
          console.log(`Deep container: ${container2.stringValue}`);
          mutable2.append("_deep");
        };
        deepNestedClosure();
      };
      nestedClosure();
    };

    complexClosure();

    // Kotlin models the async path as a directly-invoked lambda.
    const asyncClosure: () => void = () => {
      console.log(`Async processing: ${str1}, ${str5}`);
      console.log(`Async data: ${container1.stringValue}`);
      const asyncCalc = num1 * num5;
      console.log(`Async calculation: ${asyncCalc}`);
      this.sink += Math.trunc(asyncCalc);
    };
    asyncClosure();
  }

  nestedCaptureTest(depth: number): void {
    if (depth <= 0) return;

    const depthString = `Depth_${depth}`;
    const depthArray: Scalar[] = [depth, depth * 10, depth * 100];
    const depthDict = new Map<string, CaptureValue>([["level", depth], ["data", depthString]]);
    const depthMutable = new MutableString(`Mutable_Depth_${depth}`);
    const depthData = utf8Encode(depthString);

    const recursiveClosure: () => void = () => {
      console.log(`Recursive level ${depth}: ${depthString}`);

      for (const item of depthArray) console.log(`Depth array item: ${item}`);

      for (const [key, value] of depthDict) console.log(`Depth dict ${key}: ${captureValueToString(value)}`);

      depthMutable.append("_processed");
      console.log(`Processed mutable: ${depthMutable.toString()}`);
      console.log(`Data length at depth ${depth}: ${depthData.length}`);
      this.sink += depthMutable.length + depthData.length;

      this.nestedCaptureTest(depth - 1);
    };

    recursiveClosure();
  }
}

class IosSizeBenchmark {
  private readonly captureTestService = new CaptureTestService();

  runBenchmark(): void {
    this.captureTestService.performVariableCaptureStressTest();
    console.log("Variable capture benchmark completed:");
    console.log(`- Aggregate signal: ${this.captureTestService.sink}`);
  }
}

export function runBenchmark(): void {
  const benchmark = new IosSizeBenchmark();
  benchmark.runBenchmark();
}

