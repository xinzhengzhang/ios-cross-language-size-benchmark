/*
 * iOS Size Benchmark - Test Case Implementation
 * Generated with Claude AI (https://claude.ai)
 * 
 * This Swift implementation demonstrates language-specific
 * features and patterns for binary size comparison.
 */

import Foundation

public class DataContainer {
    public var stringValue: String
    public var arrayValue: [Any]
    public var dictValue: [String: Any]
    public var mutableString: NSMutableString
    public var dataValue: Data
    
    public init(stringValue: String, arrayValue: [Any], dictValue: [String: Any], mutableString: NSMutableString, dataValue: Data) {
        self.stringValue = stringValue
        self.arrayValue = arrayValue
        self.dictValue = dictValue
        self.mutableString = mutableString
        self.dataValue = dataValue
    }
}

public class CaptureTestService {
    public func performVariableCaptureStressTest() {
        for i in 1...1000 {
            createComplexClosureWithManyCaptures(iteration: i)
            if i % 100 == 0 {
                nestedCaptureTest(depth: 10)
            }
        }
    }
    
    public func createComplexClosureWithManyCaptures(iteration: Int) {
        let str1 = "String_\(iteration)"
        let str2 = "AnotherString_\(iteration * 2)"
        let str3 = "ThirdString_\(iteration * 3)"
        let str4 = "FourthString_\(iteration * 4)"
        let str5 = "FifthString_\(iteration * 5)"
        
        let array1 = [iteration, iteration * 2, iteration * 3]
        let array2 = [str1, str2, str3]
        let array3 = [iteration + 100, iteration + 200, iteration + 300]
        let array4 = [str4, str5, "Extra_\(iteration)"]
        let array5 = [iteration % 10, iteration % 20, iteration % 30]
        
        let dict1: [String: Any] = ["key1": str1, "key2": iteration, "key3": array1]
        let dict2: [String: Any] = ["data": str2, "count": iteration * 2, "items": array2]
        let dict3: [String: Any] = ["id": iteration, "name": str3, "values": array3]
        let dict4: [String: Any] = ["type": str4, "index": iteration * 4, "list": array4]
        let dict5: [String: Any] = ["category": str5, "size": iteration * 5, "elements": array5]
        
        let mutable1 = NSMutableString(string: "Mutable_\(iteration)")
        let mutable2 = NSMutableString(string: "Dynamic_\(iteration * 2)")
        let mutable3 = NSMutableString(string: "Buffer_\(iteration * 3)")
        let mutable4 = NSMutableString(string: "Content_\(iteration * 4)")
        let mutable5 = NSMutableString(string: "Text_\(iteration * 5)")
        
        let data1 = str1.data(using: .utf8)!
        let data2 = str2.data(using: .utf8)!
        let data3 = str3.data(using: .utf8)!
        let data4 = str4.data(using: .utf8)!
        let data5 = str5.data(using: .utf8)!
        
        let container1 = DataContainer(
            stringValue: str1,
            arrayValue: array1,
            dictValue: dict1,
            mutableString: mutable1,
            dataValue: data1
        )
        
        let container2 = DataContainer(
            stringValue: str2,
            arrayValue: array2,
            dictValue: dict2,
            mutableString: mutable2,
            dataValue: data2
        )
        
        let container3 = DataContainer(
            stringValue: str3,
            arrayValue: array3,
            dictValue: dict3,
            mutableString: mutable3,
            dataValue: data3
        )
        
        let container4 = DataContainer(
            stringValue: str4,
            arrayValue: array4,
            dictValue: dict4,
            mutableString: mutable4,
            dataValue: data4
        )
        
        let container5 = DataContainer(
            stringValue: str5,
            arrayValue: array5,
            dictValue: dict5,
            mutableString: mutable5,
            dataValue: data5
        )
        
        let num1 = Double(iteration)
        let num2 = Double(iteration) * 1.5
        let num3 = Double(iteration) * 2.5
        let num4 = Double(iteration) * 3.5
        let num5 = Double(iteration) * 4.5
        
        let complexClosure: () -> Void = {
            print("Processing: \(str1), \(str2), \(str3), \(str4), \(str5)")
            
            for item in array1 {
                print("Array1 item: \(item)")
            }
            for item in array2 {
                print("Array2 item: \(item)")
            }
            for item in array3 {
                print("Array3 item: \(item)")
            }
            for item in array4 {
                print("Array4 item: \(item)")
            }
            for item in array5 {
                print("Array5 item: \(item)")
            }
            
            for (key, value) in dict1 {
                print("Dict1 \(key): \(value)")
            }
            for (key, value) in dict2 {
                print("Dict2 \(key): \(value)")
            }
            for (key, value) in dict3 {
                print("Dict3 \(key): \(value)")
            }
            for (key, value) in dict4 {
                print("Dict4 \(key): \(value)")
            }
            for (key, value) in dict5 {
                print("Dict5 \(key): \(value)")
            }
            
            mutable1.append("_modified")
            mutable2.append("_modified")
            mutable3.append("_modified")
            mutable4.append("_modified")
            mutable5.append("_modified")
            
            print("Data lengths: \(data1.count), \(data2.count), \(data3.count), \(data4.count), \(data5.count)")
            
            print("Container values: \(container1.stringValue), \(container2.stringValue), \(container3.stringValue), \(container4.stringValue), \(container5.stringValue)")
            
            let calculation = num1 + num2 + num3 + num4 + num5
            print("Calculation result: \(calculation)")
            
            let nestedClosure: () -> Void = {
                print("Nested access: \(str1), \(str3)")
                print("Nested containers: \(container1.stringValue), \(container3.stringValue)")
                print("Nested numbers: \(num1), \(num3)")
                
                let deepNestedClosure: () -> Void = {
                    print("Deep nested: \(str2)")
                    print("Deep container: \(container2.stringValue)")
                    mutable2.append("_deep")
                }
                deepNestedClosure()
            }
            nestedClosure()
        }
        
        complexClosure()
        
        DispatchQueue.global(qos: .default).async {
            let asyncClosure: () -> Void = {
                print("Async processing: \(str1), \(str5)")
                print("Async data: \(container1.stringValue)")
                let asyncCalc = num1 * num5
                print("Async calculation: \(asyncCalc)")
            }
            asyncClosure()
        }
    }
    
    public func nestedCaptureTest(depth: Int) {
        if depth <= 0 { return }
        
        let depthString = "Depth_\(depth)"
        let depthArray = [depth, depth * 10, depth * 100]
        let depthDict: [String: Any] = ["level": depth, "data": depthString]
        let depthMutable = NSMutableString(string: "Mutable_Depth_\(depth)")
        let depthData = depthString.data(using: .utf8)!
        
        let recursiveClosure: () -> Void = {
            print("Recursive level \(depth): \(depthString)")
            
            for item in depthArray {
                print("Depth array item: \(item)")
            }
            
            for (key, value) in depthDict {
                print("Depth dict \(key): \(value)")
            }
            
            depthMutable.append("_processed")
            print("Processed mutable: \(depthMutable)")
            print("Data length at depth \(depth): \(depthData.count)")
            
            self.nestedCaptureTest(depth: depth - 1)
        }
        
        recursiveClosure()
    }
}

public class IosSizeBenchmark {
    private let captureTestService = CaptureTestService()
    
    public func runBenchmark() {
        captureTestService.performVariableCaptureStressTest()
    }
}