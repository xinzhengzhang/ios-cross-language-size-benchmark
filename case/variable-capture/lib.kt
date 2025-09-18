/*
 * iOS Size Benchmark - Test Case Implementation
 * Generated with Claude AI (https://claude.ai)
 * 
 * This Kotlin Native implementation demonstrates language-specific
 * features and patterns for binary size comparison.
 */

package kntr.examples.ios.size.benchmark

data class DataContainer(
    var stringValue: String,
    var arrayValue: List<Any>,
    var dictValue: Map<String, Any>,
    var mutableString: StringBuilder,
    var dataValue: ByteArray
)

class CaptureTestService {
    fun performVariableCaptureStressTest() {
        for (i in 1..1000) {
            createComplexClosureWithManyCaptures(i)
            if (i % 100 == 0) {
                nestedCaptureTest(10)
            }
        }
    }
    
    fun createComplexClosureWithManyCaptures(iteration: Int) {
        val str1 = "String_$iteration"
        val str2 = "AnotherString_${iteration * 2}"
        val str3 = "ThirdString_${iteration * 3}"
        val str4 = "FourthString_${iteration * 4}"
        val str5 = "FifthString_${iteration * 5}"
        
        val array1 = listOf(iteration, iteration * 2, iteration * 3)
        val array2 = listOf(str1, str2, str3)
        val array3 = listOf(iteration + 100, iteration + 200, iteration + 300)
        val array4 = listOf(str4, str5, "Extra_$iteration")
        val array5 = listOf(iteration % 10, iteration % 20, iteration % 30)
        
        val dict1 = mapOf("key1" to str1, "key2" to iteration, "key3" to array1)
        val dict2 = mapOf("data" to str2, "count" to iteration * 2, "items" to array2)
        val dict3 = mapOf("id" to iteration, "name" to str3, "values" to array3)
        val dict4 = mapOf("type" to str4, "index" to iteration * 4, "list" to array4)
        val dict5 = mapOf("category" to str5, "size" to iteration * 5, "elements" to array5)
        
        val mutable1 = StringBuilder("Mutable_$iteration")
        val mutable2 = StringBuilder("Dynamic_${iteration * 2}")
        val mutable3 = StringBuilder("Buffer_${iteration * 3}")
        val mutable4 = StringBuilder("Content_${iteration * 4}")
        val mutable5 = StringBuilder("Text_${iteration * 5}")
        
        val data1 = str1.encodeToByteArray()
        val data2 = str2.encodeToByteArray()
        val data3 = str3.encodeToByteArray()
        val data4 = str4.encodeToByteArray()
        val data5 = str5.encodeToByteArray()
        
        val container1 = DataContainer(
            stringValue = str1,
            arrayValue = array1,
            dictValue = dict1,
            mutableString = mutable1,
            dataValue = data1
        )
        
        val container2 = DataContainer(
            stringValue = str2,
            arrayValue = array2,
            dictValue = dict2,
            mutableString = mutable2,
            dataValue = data2
        )
        
        val container3 = DataContainer(
            stringValue = str3,
            arrayValue = array3,
            dictValue = dict3,
            mutableString = mutable3,
            dataValue = data3
        )
        
        val container4 = DataContainer(
            stringValue = str4,
            arrayValue = array4,
            dictValue = dict4,
            mutableString = mutable4,
            dataValue = data4
        )
        
        val container5 = DataContainer(
            stringValue = str5,
            arrayValue = array5,
            dictValue = dict5,
            mutableString = mutable5,
            dataValue = data5
        )
        
        val num1 = iteration.toDouble()
        val num2 = iteration * 1.5
        val num3 = iteration * 2.5
        val num4 = iteration * 3.5
        val num5 = iteration * 4.5
        
        val complexLambda = {
            println("Processing: $str1, $str2, $str3, $str4, $str5")
            
            array1.forEach { item ->
                println("Array1 item: $item")
            }
            array2.forEach { item ->
                println("Array2 item: $item")
            }
            array3.forEach { item ->
                println("Array3 item: $item")
            }
            array4.forEach { item ->
                println("Array4 item: $item")
            }
            array5.forEach { item ->
                println("Array5 item: $item")
            }
            
            dict1.forEach { (key, value) ->
                println("Dict1 $key: $value")
            }
            dict2.forEach { (key, value) ->
                println("Dict2 $key: $value")
            }
            dict3.forEach { (key, value) ->
                println("Dict3 $key: $value")
            }
            dict4.forEach { (key, value) ->
                println("Dict4 $key: $value")
            }
            dict5.forEach { (key, value) ->
                println("Dict5 $key: $value")
            }
            
            mutable1.append("_modified")
            mutable2.append("_modified")
            mutable3.append("_modified")
            mutable4.append("_modified")
            mutable5.append("_modified")
            
            println("Data lengths: ${data1.size}, ${data2.size}, ${data3.size}, ${data4.size}, ${data5.size}")
            
            println("Container values: ${container1.stringValue}, ${container2.stringValue}, ${container3.stringValue}, ${container4.stringValue}, ${container5.stringValue}")
            
            val calculation = num1 + num2 + num3 + num4 + num5
            println("Calculation result: $calculation")
            
            val nestedLambda = {
                println("Nested access: $str1, $str3")
                println("Nested containers: ${container1.stringValue}, ${container3.stringValue}")
                println("Nested numbers: $num1, $num3")
                
                val deepNestedLambda = {
                    println("Deep nested: $str2")
                    println("Deep container: ${container2.stringValue}")
                    mutable2.append("_deep")
                }
                deepNestedLambda()
            }
            nestedLambda()
        }
        
        complexLambda()
        
        // Simulate async processing
        val asyncLambda = {
            println("Async processing: $str1, $str5")
            println("Async data: ${container1.stringValue}")
            val asyncCalc = num1 * num5
            println("Async calculation: $asyncCalc")
        }
        asyncLambda()
    }
    
    fun nestedCaptureTest(depth: Int) {
        if (depth <= 0) return
        
        val depthString = "Depth_$depth"
        val depthArray = listOf(depth, depth * 10, depth * 100)
        val depthDict = mapOf("level" to depth, "data" to depthString)
        val depthMutable = StringBuilder("Mutable_Depth_$depth")
        val depthData = depthString.encodeToByteArray()
        
        val recursiveLambda = {
            println("Recursive level $depth: $depthString")
            
            depthArray.forEach { item ->
                println("Depth array item: $item")
            }
            
            depthDict.forEach { (key, value) ->
                println("Depth dict $key: $value")
            }
            
            depthMutable.append("_processed")
            println("Processed mutable: $depthMutable")
            println("Data length at depth $depth: ${depthData.size}")
            
            nestedCaptureTest(depth - 1)
        }
        
        recursiveLambda()
    }
}

class IosSizeBenchmark {
    val captureTestService = CaptureTestService()
    
    fun runBenchmark() {
        captureTestService.performVariableCaptureStressTest()
    }
}