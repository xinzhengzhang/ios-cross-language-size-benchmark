/*
 * iOS Size Benchmark - Test Case Implementation
 * Generated with Claude AI (https://claude.ai)
 * 
 * This Swift implementation demonstrates language-specific
 * features and patterns for binary size comparison.
 */

import Foundation

// 最小化代码体积的集合操作测试
// 避免复杂的函数式编程，使用最基本的操作

public struct MinimalCollectionProcessor {
    
    // 基础数组操作 - 避免复杂的链式调用
    public func processBasicArray(size: Int) -> [Int] {
        var array = [Int]()
        array.reserveCapacity(size)
        
        for i in 0..<size {
            array.append(i * 2)
        }
        
        for i in 0..<array.count {
            array[i] += 1
        }
        
        return array
    }
    
    // 简单的列表操作
    public func processBasicList(size: Int) -> [String] {
        var array = [String]()
        array.reserveCapacity(size)
        
        for i in 0..<size {
            array.append("Item\(i)")
        }
        
        return array
    }
    
    // 基础映射操作
    public func processBasicMap(size: Int) -> [Int: String] {
        var dict = [Int: String]()
        
        for i in 0..<size {
            dict[i] = "Value\(i)"
        }
        
        return dict
    }
    
    // 简单过滤 - 避免使用 filter
    public func filterEvenNumbers(_ numbers: [Int]) -> [Int] {
        var result = [Int]()
        
        for num in numbers {
            if num % 2 == 0 {
                result.append(num)
            }
        }
        
        return result
    }
    
    // 简单变换 - 避免使用 map
    public func doubleNumbers(_ numbers: [Int]) -> [Int] {
        var result = [Int]()
        result.reserveCapacity(numbers.count)
        
        for num in numbers {
            result.append(num * 2)
        }
        
        return result
    }
    
    // 基础聚合操作 - 避免使用 reduce
    public func sumNumbers(_ numbers: [Int]) -> Int {
        var sum = 0
        
        for num in numbers {
            sum += num
        }
        
        return sum
    }
    
    // 简单查找 - 避免使用 firstIndex
    public func findFirst(_ numbers: [Int], target: Int) -> Int {
        for i in 0..<numbers.count {
            if numbers[i] == target {
                return i
            }
        }
        return -1
    }
    
    // 基础排序 - 使用简单的冒泡排序
    public func simpleSort(_ numbers: [Int]) -> [Int] {
        var result = numbers
        let n = result.count
        
        for i in 0..<(n - 1) {
            for j in 0..<(n - i - 1) {
                if result[j] > result[j + 1] {
                    let temp = result[j]
                    result[j] = result[j + 1]
                    result[j + 1] = temp
                }
            }
        }
        
        return result
    }
    
    // 基础字符串数组操作 - 对应 Objective-C 中的 processBasicStringArrayWithSize
    public func processBasicStringArray(size: Int) -> [String] {
        var array = [String]()
        array.reserveCapacity(size)
        
        for i in 0..<size {
            array.append("Item\(i)")
        }
        
        return array
    }
    
    // 基础字典操作 - 对应 Objective-C 中的 processBasicDictionaryWithSize
    public func processBasicDictionary(size: Int) -> [Int: String] {
        var dict = [Int: String]()
        
        for i in 0..<size {
            dict[i] = "Value\(i)"
        }
        
        return dict
    }
}

// 最小化的数据结构
public struct SimpleUser {
    public let id: Int
    public let name: String
}

public struct SimpleProduct {
    public let id: Int
    public let price: Double
}

public struct MinimalDataProcessor {
    
    public func createUsers(count: Int) -> [SimpleUser] {
        var users = [SimpleUser]()
        users.reserveCapacity(count)
        
        for i in 0..<count {
            users.append(SimpleUser(id: i, name: "User\(i)"))
        }
        
        return users
    }
    
    public func createProducts(count: Int) -> [SimpleProduct] {
        var products = [SimpleProduct]()
        products.reserveCapacity(count)
        
        for i in 0..<count {
            products.append(SimpleProduct(id: i, price: 10.0 + Double(i)))
        }
        
        return products
    }
    
    // 简单的数据处理，避免复杂的业务逻辑
    public func processUserData(_ users: [SimpleUser]) -> String {
        var result = ""
        
        for user in users {
            result += "\(user.id):\(user.name);"
        }
        
        return result
    }
    
    public func calculateTotal(_ products: [SimpleProduct]) -> Double {
        var total = 0.0
        
        for product in products {
            total += product.price
        }
        
        return total
    }
}

public struct MinimalBenchmark {
    private let collectionProcessor = MinimalCollectionProcessor()
    private let dataProcessor = MinimalDataProcessor()
    
    public func runMinimalTest() {
        print("Running minimal collection benchmark...")
        
        // 测试基础数组操作
        let array = collectionProcessor.processBasicArray(size: 100)
        let doubled = collectionProcessor.doubleNumbers(array)
        let filtered = collectionProcessor.filterEvenNumbers(doubled)
        let sorted = collectionProcessor.simpleSort(filtered)
        let sum = collectionProcessor.sumNumbers(sorted)
        let index = collectionProcessor.findFirst(sorted, target: 50)
        
        // 测试基础集合操作
        let stringArray = collectionProcessor.processBasicStringArray(size: 50)
        let dictionary = collectionProcessor.processBasicDictionary(size: 50)
        
        // 测试简单数据处理
        let users = dataProcessor.createUsers(count: 20)
        let products = dataProcessor.createProducts(count: 20)
        let userData = dataProcessor.processUserData(users)
        let total = dataProcessor.calculateTotal(products)
        
        print("Minimal benchmark completed:")
        print("- Array size: \(array.count)")
        print("- Doubled size: \(doubled.count)")
        print("- Filtered size: \(filtered.count)")
        print("- Sorted size: \(sorted.count)")
        print("- Sum: \(sum)")
        print("- Found index: \(index)")
        print("- String array size: \(stringArray.count)")
        print("- Dictionary size: \(dictionary.count)")
        print("- Users: \(users.count)")
        print("- Products: \(products.count)")
        print("- User data length: \(userData.count)")
        print("- Total price: \(total)")
    }
}

public class IosSizeBenchmark {
    private let benchmark = MinimalBenchmark()
    
    public func runBenchmark() {
        benchmark.runMinimalTest()
    }
}