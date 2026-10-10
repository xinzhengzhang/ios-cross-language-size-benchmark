/*
 * iOS Size Benchmark - Test Case Implementation
 * Generated with Claude AI (https://claude.ai)
 *
 * This scriptc (TypeScript-to-native) implementation mirrors the Kotlin/
 * Swift/Objective-C versions for binary size comparison. A single exported
 * entry (runBenchmark) exercises every type so nothing is dead-code
 * eliminated, matching the `public` requirement used for the Swift cases.
 */

// 最小化代码体积的集合操作测试
// 避免复杂的函数式编程，使用最基本的操作

class MinimalCollectionProcessor {
  processBasicArray(size: number): number[] {
    const array: number[] = [];
    for (let i = 0; i < size; i++) {
      array.push(i * 2);
    }
    for (let i = 0; i < array.length; i++) {
      array[i] += 1;
    }
    return array;
  }

  processBasicList(size: number): string[] {
    const array: string[] = [];
    for (let i = 0; i < size; i++) {
      array.push(`Item${i}`);
    }
    return array;
  }

  processBasicMap(size: number): Map<number, string> {
    const dict = new Map<number, string>();
    for (let i = 0; i < size; i++) {
      dict.set(i, `Value${i}`);
    }
    return dict;
  }

  filterEvenNumbers(numbers: number[]): number[] {
    const result: number[] = [];
    for (const num of numbers) {
      if (num % 2 === 0) {
        result.push(num);
      }
    }
    return result;
  }

  doubleNumbers(numbers: number[]): number[] {
    const result: number[] = [];
    for (const num of numbers) {
      result.push(num * 2);
    }
    return result;
  }

  sumNumbers(numbers: number[]): number {
    let sum = 0;
    for (const num of numbers) {
      sum += num;
    }
    return sum;
  }

  findFirst(numbers: number[], target: number): number {
    for (let i = 0; i < numbers.length; i++) {
      if (numbers[i] === target) {
        return i;
      }
    }
    return -1;
  }

  simpleSort(numbers: number[]): number[] {
    const result = numbers.slice();
    const n = result.length;
    for (let i = 0; i < n - 1; i++) {
      for (let j = 0; j < n - i - 1; j++) {
        if (result[j] > result[j + 1]) {
          const temp = result[j];
          result[j] = result[j + 1];
          result[j + 1] = temp;
        }
      }
    }
    return result;
  }

  processBasicStringArray(size: number): string[] {
    const array: string[] = [];
    for (let i = 0; i < size; i++) {
      array.push(`Item${i}`);
    }
    return array;
  }

  processBasicDictionary(size: number): Map<number, string> {
    const dict = new Map<number, string>();
    for (let i = 0; i < size; i++) {
      dict.set(i, `Value${i}`);
    }
    return dict;
  }
}

class SimpleUser {
  constructor(public readonly id: number, public readonly name: string) {}
}

class SimpleProduct {
  constructor(public readonly id: number, public readonly price: number) {}
}

class MinimalDataProcessor {
  createUsers(count: number): SimpleUser[] {
    const users: SimpleUser[] = [];
    for (let i = 0; i < count; i++) {
      users.push(new SimpleUser(i, `User${i}`));
    }
    return users;
  }

  createProducts(count: number): SimpleProduct[] {
    const products: SimpleProduct[] = [];
    for (let i = 0; i < count; i++) {
      products.push(new SimpleProduct(i, 10.0 + i));
    }
    return products;
  }

  processUserData(users: SimpleUser[]): string {
    let result = "";
    for (const user of users) {
      result += `${user.id}:${user.name};`;
    }
    return result;
  }

  calculateTotal(products: SimpleProduct[]): number {
    let total = 0.0;
    for (const product of products) {
      total += product.price;
    }
    return total;
  }
}

class MinimalBenchmark {
  private collectionProcessor = new MinimalCollectionProcessor();
  private dataProcessor = new MinimalDataProcessor();

  runMinimalTest(): void {
    console.log("Running minimal collection benchmark...");

    const array = this.collectionProcessor.processBasicArray(100);
    const doubled = this.collectionProcessor.doubleNumbers(array);
    const filtered = this.collectionProcessor.filterEvenNumbers(doubled);
    const sorted = this.collectionProcessor.simpleSort(filtered);
    const sum = this.collectionProcessor.sumNumbers(sorted);
    const index = this.collectionProcessor.findFirst(sorted, 50);

    const stringArray = this.collectionProcessor.processBasicStringArray(50);
    const dictionary = this.collectionProcessor.processBasicDictionary(50);

    const users = this.dataProcessor.createUsers(20);
    const products = this.dataProcessor.createProducts(20);
    const userData = this.dataProcessor.processUserData(users);
    const total = this.dataProcessor.calculateTotal(products);

    console.log("Minimal benchmark completed:");
    console.log(`- Array size: ${array.length}`);
    console.log(`- Doubled size: ${doubled.length}`);
    console.log(`- Filtered size: ${filtered.length}`);
    console.log(`- Sorted size: ${sorted.length}`);
    console.log(`- Sum: ${sum}`);
    console.log(`- Found index: ${index}`);
    console.log(`- String array size: ${stringArray.length}`);
    console.log(`- Dictionary size: ${dictionary.size}`);
    console.log(`- Users: ${users.length}`);
    console.log(`- Products: ${products.length}`);
    console.log(`- User data length: ${userData.length}`);
    console.log(`- Total price: ${total}`);
  }
}

export function runBenchmark(): void {
  const benchmark = new MinimalBenchmark();
  benchmark.runMinimalTest();
}
