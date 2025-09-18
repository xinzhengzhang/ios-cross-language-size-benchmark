/*
 * iOS Size Benchmark - Test Case Implementation
 * Generated with Claude AI (https://claude.ai)
 * 
 * This Kotlin Native implementation demonstrates language-specific
 * features and patterns for binary size comparison.
 */

package kntr.examples.ios.size.benchmark

// 最小化代码体积的集合操作测试
// 避免复杂的函数式编程链，使用最基本的操作

class MinimalCollectionProcessor {
    
    // 基础数组操作 - 避免复杂的链式调用
    fun processBasicArray(size: Int): IntArray {
        val array = IntArray(size)
        for (i in 0 until size) {
            array[i] = i * 2
        }
        
        for (i in array.indices) {
            array[i] += 1
        }
        
        return array
    }
    
    // 简单的列表操作
    fun processBasicList(size: Int): List<String> {
        val list = mutableListOf<String>()
        for (i in 0 until size) {
            list.add("Item$i")
        }
        return list
    }
    
    // 基础映射操作
    fun processBasicMap(size: Int): Map<Int, String> {
        val map = mutableMapOf<Int, String>()
        for (i in 0 until size) {
            map[i] = "Value$i"
        }
        return map
    }
    
    // 简单过滤 - 避免使用 filter 等高阶函数
    fun filterEvenNumbers(numbers: IntArray): IntArray {
        val result = mutableListOf<Int>()
        for (num in numbers) {
            if (num % 2 == 0) {
                result.add(num)
            }
        }
        return result.toIntArray()
    }
    
    // 简单变换 - 避免使用 map
    fun doubleNumbers(numbers: IntArray): IntArray {
        val result = IntArray(numbers.size)
        for (i in numbers.indices) {
            result[i] = numbers[i] * 2
        }
        return result
    }
    
    // 基础聚合操作 - 避免使用 reduce/fold
    fun sumNumbers(numbers: IntArray): Long {
        var sum = 0L
        for (num in numbers) {
            sum += num
        }
        return sum
    }
    
    // 简单查找 - 避免使用 find
    fun findFirst(numbers: IntArray, target: Int): Int {
        for (i in numbers.indices) {
            if (numbers[i] == target) {
                return i
            }
        }
        return -1
    }
    
    // 基础排序 - 使用简单的冒泡排序避免复杂算法
    fun simpleSort(numbers: IntArray): IntArray {
        val result = numbers.copyOf()
        val n = result.size
        
        for (i in 0 until n - 1) {
            for (j in 0 until n - i - 1) {
                if (result[j] > result[j + 1]) {
                    val temp = result[j]
                    result[j] = result[j + 1]
                    result[j + 1] = temp
                }
            }
        }
        
        return result
    }
    
    // 基础字符串数组操作 - 对应 Objective-C 中的 processBasicStringArrayWithSize
    fun processBasicStringArray(size: Int): List<String> {
        val list = mutableListOf<String>()
        for (i in 0 until size) {
            list.add("Item$i")
        }
        return list
    }
    
    // 基础字典操作 - 对应 Objective-C 中的 processBasicDictionaryWithSize
    fun processBasicDictionary(size: Int): Map<Int, String> {
        val map = mutableMapOf<Int, String>()
        for (i in 0 until size) {
            map[i] = "Value$i"
        }
        return map
    }
}

// 最小化的数据结构
data class SimpleUser(val id: Int, val name: String)
data class SimpleProduct(val id: Int, val price: Double)

class MinimalDataProcessor {
    
    fun createUsers(count: Int): Array<SimpleUser> {
        val users = Array(count) { i ->
            SimpleUser(i, "User$i")
        }
        return users
    }
    
    fun createProducts(count: Int): Array<SimpleProduct> {
        val products = Array(count) { i ->
            SimpleProduct(i, 10.0 + i)
        }
        return products
    }
    
    // 简单的数据处理，避免复杂的业务逻辑
    fun processUserData(users: Array<SimpleUser>): String {
        var result = ""
        for (user in users) {
            result += "${user.id}:${user.name};"
        }
        return result
    }
    
    fun calculateTotal(products: Array<SimpleProduct>): Double {
        var total = 0.0
        for (product in products) {
            total += product.price
        }
        return total
    }
}

class MinimalBenchmark {
    val collectionProcessor = MinimalCollectionProcessor()
    val dataProcessor = MinimalDataProcessor()
    
    fun runMinimalTest() {
        println("Running minimal collection benchmark...")
        
        // 测试基础数组操作
        val array = collectionProcessor.processBasicArray(100)
        val doubled = collectionProcessor.doubleNumbers(array)
        val filtered = collectionProcessor.filterEvenNumbers(doubled)
        val sorted = collectionProcessor.simpleSort(filtered)
        val sum = collectionProcessor.sumNumbers(sorted)
        val index = collectionProcessor.findFirst(sorted, 50)
        
        // 测试基础集合操作
        val stringArray = collectionProcessor.processBasicStringArray(50)
        val dictionary = collectionProcessor.processBasicDictionary(50)
        
        // 测试简单数据处理
        val users = dataProcessor.createUsers(20)
        val products = dataProcessor.createProducts(20)
        val userData = dataProcessor.processUserData(users)
        val total = dataProcessor.calculateTotal(products)
        
        println("Minimal benchmark completed:")
        println("- Array size: ${array.size}")
        println("- Doubled size: ${doubled.size}")
        println("- Filtered size: ${filtered.size}")
        println("- Sorted size: ${sorted.size}")
        println("- Sum: $sum")
        println("- Found index: $index")
        println("- String array size: ${stringArray.size}")
        println("- Dictionary size: ${dictionary.size}")
        println("- Users: ${users.size}")
        println("- Products: ${products.size}")
        println("- User data length: ${userData.length}")
        println("- Total price: $total")
    }
}

class IosSizeBenchmark {
    val benchmark = MinimalBenchmark()
    
    fun runBenchmark() {
        benchmark.runMinimalTest()
    }
}