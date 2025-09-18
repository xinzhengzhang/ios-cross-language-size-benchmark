/*
 * iOS Size Benchmark - Test Case Implementation
 * Generated with Claude AI (https://claude.ai)
 * 
 * This Swift implementation demonstrates language-specific
 * features and patterns for binary size comparison.
 */

import Foundation

// Test case: String Processing - Tests impact of heavy string operations on code size

// String utilities
public struct StringUtils {
    
    // Basic string operations
    public static func reverse(_ text: String) -> String {
        return String(text.reversed())
    }
    
    public static func capitalize(_ text: String) -> String {
        return text.prefix(1).uppercased() + text.dropFirst().lowercased()
    }
    
    public static func camelCase(_ text: String) -> String {
        let words = text.components(separatedBy: CharacterSet(charactersIn: " _-"))
            .filter { !$0.isEmpty }
        
        guard !words.isEmpty else { return "" }
        
        let firstWord = words[0].lowercased()
        let remainingWords = words.dropFirst().map { $0.lowercased().capitalized }
        
        return firstWord + remainingWords.joined()
    }
    
    public static func snakeCase(_ text: String) -> String {
        return text.components(separatedBy: CharacterSet(charactersIn: " -"))
            .filter { !$0.isEmpty }
            .map { $0.lowercased() }
            .joined(separator: "_")
    }
    
    public static func kebabCase(_ text: String) -> String {
        return text.components(separatedBy: CharacterSet(charactersIn: " _"))
            .filter { !$0.isEmpty }
            .map { $0.lowercased() }
            .joined(separator: "-")
    }
    
    public static func titleCase(_ text: String) -> String {
        return text.components(separatedBy: " ")
            .filter { !$0.isEmpty }
            .map { $0.lowercased().capitalized }
            .joined(separator: " ")
    }
    
    // String validation and analysis
    public static func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
    }
    
    public static func isValidPhone(_ phone: String) -> Bool {
        let cleanPhone = phone.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        return cleanPhone.count >= 10 && cleanPhone.count <= 15
    }
    
    public static func isValidUrl(_ url: String) -> Bool {
        let urlRegex = "^https?://[A-Za-z0-9.-]+\\.[A-Za-z]{2,}(/.*)?$"
        return NSPredicate(format: "SELF MATCHES %@", urlRegex).evaluate(with: url)
    }
    
    public static func containsOnlyAlphanumeric(_ text: String) -> Bool {
        return text.allSatisfy { $0.isLetter || $0.isNumber }
    }
    
    public static func containsSpecialChars(_ text: String) -> Bool {
        return text.contains { !$0.isLetter && !$0.isNumber && !$0.isWhitespace }
    }
    
    public static func countWords(_ text: String) -> Int {
        return text.components(separatedBy: .whitespaces)
            .filter { !$0.isEmpty }
            .count
    }
    
    public static func countCharacters(_ text: String, character: Character) -> Int {
        return text.filter { $0 == character }.count
    }
    
    public static func countVowels(_ text: String) -> Int {
        let vowels = Set("aeiouAEIOU")
        return text.filter { vowels.contains($0) }.count
    }
    
    public static func countConsonants(_ text: String) -> Int {
        let vowels = Set("aeiouAEIOU")
        return text.filter { $0.isLetter && !vowels.contains($0) }.count
    }
}

// Advanced string processor
public class StringProcessor {
    
    public init() {}
    
    // Text cleaning operations
    public func removeExtraSpaces(_ text: String) -> String {
        return text.replacingOccurrences(of: "\\s+", with: " ", options: .regularExpression)
            .trimmingCharacters(in: .whitespaces)
    }
    
    public func removePunctuation(_ text: String) -> String {
        return text.replacingOccurrences(of: "[^\\w\\s]", with: "", options: .regularExpression)
    }
    
    public func removeNumbers(_ text: String) -> String {
        return text.replacingOccurrences(of: "\\d", with: "", options: .regularExpression)
    }
    
    public func removeSpecialChars(_ text: String) -> String {
        return text.replacingOccurrences(of: "[^A-Za-z0-9\\s]", with: "", options: .regularExpression)
    }
    
    public func extractNumbers(_ text: String) -> [String] {
        let regex = try! NSRegularExpression(pattern: "\\d+")
        let matches = regex.matches(in: text, range: NSRange(text.startIndex..., in: text))
        return matches.map { String(text[Range($0.range, in: text)!]) }
    }
    
    public func extractEmails(_ text: String) -> [String] {
        let regex = try! NSRegularExpression(pattern: "[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}")
        let matches = regex.matches(in: text, range: NSRange(text.startIndex..., in: text))
        return matches.map { String(text[Range($0.range, in: text)!]) }
    }
    
    public func extractUrls(_ text: String) -> [String] {
        let regex = try! NSRegularExpression(pattern: "https?://[A-Za-z0-9.-]+\\.[A-Za-z]{2,}(/[^\\s]*)?")
        let matches = regex.matches(in: text, range: NSRange(text.startIndex..., in: text))
        return matches.map { String(text[Range($0.range, in: text)!]) }
    }
    
    public func extractHashtags(_ text: String) -> [String] {
        let regex = try! NSRegularExpression(pattern: "#\\w+")
        let matches = regex.matches(in: text, range: NSRange(text.startIndex..., in: text))
        return matches.map { String(text[Range($0.range, in: text)!]) }
    }
    
    public func extractMentions(_ text: String) -> [String] {
        let regex = try! NSRegularExpression(pattern: "@\\w+")
        let matches = regex.matches(in: text, range: NSRange(text.startIndex..., in: text))
        return matches.map { String(text[Range($0.range, in: text)!]) }
    }
    
    // Text transformation operations
    public func insertCharAt(_ text: String, index: Int, character: Character) -> String {
        var chars = Array(text)
        chars.insert(character, at: index)
        return String(chars)
    }
    
    public func replaceCharAt(_ text: String, index: Int, character: Character) -> String {
        var chars = Array(text)
        chars[index] = character
        return String(chars)
    }
    
    public func removeCharAt(_ text: String, index: Int) -> String {
        var chars = Array(text)
        chars.remove(at: index)
        return String(chars)
    }
    
    public func swapChars(_ text: String, index1: Int, index2: Int) -> String {
        var chars = Array(text)
        chars.swapAt(index1, index2)
        return String(chars)
    }
    
    public func rotateLeft(_ text: String, positions: Int) -> String {
        guard !text.isEmpty else { return text }
        let pos = positions % text.count
        let index = text.index(text.startIndex, offsetBy: pos)
        return String(text[index...]) + String(text[..<index])
    }
    
    public func rotateRight(_ text: String, positions: Int) -> String {
        guard !text.isEmpty else { return text }
        let pos = positions % text.count
        let index = text.index(text.endIndex, offsetBy: -pos)
        return String(text[index...]) + String(text[..<index])
    }
}

// String encoding and formatting
public class StringEncoder {
    
    public init() {}
    
    // Base64-like encoding simulation
    public func encodeBase64Like(_ text: String) -> String {
        let data = text.data(using: .utf8) ?? Data()
        return data.map { String(format: "%02x", $0) }.joined()
    }
    
    public func decodeBase64Like(_ encoded: String) -> String {
        var data = Data()
        var index = encoded.startIndex
        
        while index < encoded.endIndex {
            let nextIndex = encoded.index(index, offsetBy: 2, limitedBy: encoded.endIndex) ?? encoded.endIndex
            let hex = String(encoded[index..<nextIndex])
            if let byte = UInt8(hex, radix: 16) {
                data.append(byte)
            }
            index = nextIndex
        }
        
        return String(data: data, encoding: .utf8) ?? ""
    }
    
    // URL encoding simulation
    public func urlEncode(_ text: String) -> String {
        return text.map { char in
            if char.isLetter || char.isNumber {
                return String(char)
            } else {
                switch char {
                case " ": return "%20"
                case "&": return "%26"
                case "=": return "%3D"
                case "?": return "%3F"
                default: return String(format: "%%%02X", char.asciiValue ?? 0)
                }
            }
        }.joined()
    }
    
    public func urlDecode(_ encoded: String) -> String {
        return encoded
            .replacingOccurrences(of: "%20", with: " ")
            .replacingOccurrences(of: "%26", with: "&")
            .replacingOccurrences(of: "%3D", with: "=")
            .replacingOccurrences(of: "%3F", with: "?")
    }
    
    // HTML encoding simulation
    public func htmlEncode(_ text: String) -> String {
        return text
            .replacingOccurrences(of: "&", with: "&amp;")
            .replacingOccurrences(of: "<", with: "&lt;")
            .replacingOccurrences(of: ">", with: "&gt;")
            .replacingOccurrences(of: "\"", with: "&quot;")
            .replacingOccurrences(of: "'", with: "&#39;")
    }
    
    public func htmlDecode(_ encoded: String) -> String {
        return encoded
            .replacingOccurrences(of: "&amp;", with: "&")
            .replacingOccurrences(of: "&lt;", with: "<")
            .replacingOccurrences(of: "&gt;", with: ">")
            .replacingOccurrences(of: "&quot;", with: "\"")
            .replacingOccurrences(of: "&#39;", with: "'")
    }
    
    // JSON string escaping
    public func jsonEscape(_ text: String) -> String {
        return text
            .replacingOccurrences(of: "\\", with: "\\\\")
            .replacingOccurrences(of: "\"", with: "\\\"")
            .replacingOccurrences(of: "\n", with: "\\n")
            .replacingOccurrences(of: "\r", with: "\\r")
            .replacingOccurrences(of: "\t", with: "\\t")
    }
    
    public func jsonUnescape(_ escaped: String) -> String {
        return escaped
            .replacingOccurrences(of: "\\\\", with: "\\")
            .replacingOccurrences(of: "\\\"", with: "\"")
            .replacingOccurrences(of: "\\n", with: "\n")
            .replacingOccurrences(of: "\\r", with: "\r")
            .replacingOccurrences(of: "\\t", with: "\t")
    }
}

// Text analysis and metrics
public class TextAnalyzer {
    
    public init() {}
    
    // Readability metrics
    public func calculateReadabilityScore(_ text: String) -> Double {
        let sentences = text.components(separatedBy: CharacterSet(charactersIn: ".!?"))
            .filter { !$0.trimmingCharacters(in: .whitespaces).isEmpty }
        
        let words = text.components(separatedBy: .whitespaces)
            .filter { !$0.isEmpty }
        
        guard !sentences.isEmpty && !words.isEmpty else { return 0.0 }
        
        let avgWordsPerSentence = Double(words.count) / Double(sentences.count)
        let avgSyllablesPerWord = words.map { countSyllables($0) }.reduce(0, +) / words.count
        
        return 206.835 - (1.015 * avgWordsPerSentence) - (84.6 * Double(avgSyllablesPerWord))
    }
    
    private func countSyllables(_ word: String) -> Int {
        let vowels = Set("aeiouAEIOU")
        var count = 0
        var previousWasVowel = false
        
        for char in word {
            let isVowel = vowels.contains(char)
            if isVowel && !previousWasVowel {
                count += 1
            }
            previousWasVowel = isVowel
        }
        
        if word.lowercased().hasSuffix("e") && count > 1 {
            count -= 1
        }
        
        return max(1, count)
    }
    
    // Sentiment analysis simulation
    public func analyzeSentiment(_ text: String) -> String {
        let positiveWords = Set(["good", "great", "excellent", "amazing", "wonderful", "fantastic", "love", "like", "happy", "joy"])
        let negativeWords = Set(["bad", "terrible", "awful", "horrible", "hate", "dislike", "sad", "angry", "disappointed", "frustrated"])
        
        let words = text.lowercased().components(separatedBy: .whitespaces)
        let positiveCount = words.filter { positiveWords.contains($0) }.count
        let negativeCount = words.filter { negativeWords.contains($0) }.count
        
        if positiveCount > negativeCount {
            return "Positive"
        } else if negativeCount > positiveCount {
            return "Negative"
        } else {
            return "Neutral"
        }
    }
    
    // Language detection simulation
    public func detectLanguage(_ text: String) -> String {
        let englishPatterns = Set(["the", "and", "is", "in", "to", "of", "a", "that", "it", "with"])
        let spanishPatterns = Set(["el", "la", "de", "que", "y", "a", "en", "un", "es", "se"])
        let frenchPatterns = Set(["le", "de", "et", "à", "un", "il", "être", "et", "en", "avoir"])
        
        let words = text.lowercased().components(separatedBy: .whitespaces)
        let englishScore = words.filter { englishPatterns.contains($0) }.count
        let spanishScore = words.filter { spanishPatterns.contains($0) }.count
        let frenchScore = words.filter { frenchPatterns.contains($0) }.count
        
        let maxScore = max(englishScore, spanishScore, frenchScore)
        if maxScore == englishScore {
            return "English"
        } else if maxScore == spanishScore {
            return "Spanish"
        } else if maxScore == frenchScore {
            return "French"
        } else {
            return "Unknown"
        }
    }
    
    // Text complexity metrics
    public func calculateComplexity(_ text: String) -> [String: Any] {
        let words = text.components(separatedBy: .whitespaces).filter { !$0.isEmpty }
        let sentences = text.components(separatedBy: CharacterSet(charactersIn: ".!?"))
            .filter { !$0.trimmingCharacters(in: .whitespaces).isEmpty }
        let characters = text.count
        let charactersNoSpaces = text.replacingOccurrences(of: " ", with: "").count
        
        return [
            "wordCount": words.count,
            "sentenceCount": sentences.count,
            "characterCount": characters,
            "characterCountNoSpaces": charactersNoSpaces,
            "averageWordsPerSentence": sentences.isEmpty ? 0.0 : Double(words.count) / Double(sentences.count),
            "averageCharactersPerWord": words.isEmpty ? 0.0 : Double(charactersNoSpaces) / Double(words.count),
            "longestWord": words.map { $0.count }.max() ?? 0,
            "shortestWord": words.map { $0.count }.min() ?? 0
        ]
    }
}

// String formatting and templates
public class StringFormatter {
    
    public init() {}
    
    // Template processing
    public func processTemplate(_ template: String, variables: [String: String]) -> String {
        var result = template
        for (key, value) in variables {
            result = result.replacingOccurrences(of: "{{\(key)}}", with: value)
            result = result.replacingOccurrences(of: "{\(key)}", with: value)
            result = result.replacingOccurrences(of: "${\(key)}", with: value)
        }
        return result
    }
    
    // Number formatting
    public func formatNumber(_ number: Double, decimals: Int) -> String {
        return String(format: "%.\(decimals)f", number)
    }
    
    public func formatCurrency(_ amount: Double, currency: String = "USD") -> String {
        return "\(currency) \(String(format: "%.2f", amount))"
    }
    
    public func formatPercentage(_ value: Double) -> String {
        return "\(String(format: "%.1f", value * 100))%"
    }
    
    // Date formatting simulation
    public func formatDate(_ timestamp: Int64) -> String {
        let days = timestamp / (24 * 60 * 60 * 1000)
        let hours = (timestamp % (24 * 60 * 60 * 1000)) / (60 * 60 * 1000)
        let minutes = (timestamp % (60 * 60 * 1000)) / (60 * 1000)
        return String(format: "%02lld:%02lld:%02lld", days, hours, minutes)
    }
    
    // String padding and alignment
    public func padLeft(_ text: String, length: Int, character: Character = " ") -> String {
        guard text.count < length else { return text }
        let padding = String(repeating: String(character), count: length - text.count)
        return padding + text
    }
    
    public func padRight(_ text: String, length: Int, character: Character = " ") -> String {
        guard text.count < length else { return text }
        let padding = String(repeating: String(character), count: length - text.count)
        return text + padding
    }
    
    public func padCenter(_ text: String, length: Int, character: Character = " ") -> String {
        guard text.count < length else { return text }
        let totalPadding = length - text.count
        let leftPadding = totalPadding / 2
        let rightPadding = totalPadding - leftPadding
        
        let leftPad = String(repeating: String(character), count: leftPadding)
        let rightPad = String(repeating: String(character), count: rightPadding)
        
        return leftPad + text + rightPad
    }
    
    // Text wrapping
    public func wrapText(_ text: String, maxLineLength: Int) -> [String] {
        let words = text.components(separatedBy: " ")
        var lines: [String] = []
        var currentLine = ""
        
        for word in words {
            if currentLine.isEmpty {
                currentLine = word
            } else if currentLine.count + word.count + 1 <= maxLineLength {
                currentLine += " \(word)"
            } else {
                lines.append(currentLine)
                currentLine = word
            }
        }
        
        if !currentLine.isEmpty {
            lines.append(currentLine)
        }
        
        return lines
    }
}

// Extension for additional string operations
extension String {
    public func levenshteinDistance(to other: String) -> Int {
        let selfCount = self.count
        let otherCount = other.count
        
        if selfCount == 0 { return otherCount }
        if otherCount == 0 { return selfCount }
        
        var matrix = Array(repeating: Array(repeating: 0, count: otherCount + 1), count: selfCount + 1)
        
        for i in 0...selfCount {
            matrix[i][0] = i
        }
        
        for j in 0...otherCount {
            matrix[0][j] = j
        }
        
        let selfArray = Array(self)
        let otherArray = Array(other)
        
        for i in 1...selfCount {
            for j in 1...otherCount {
                let cost = selfArray[i-1] == otherArray[j-1] ? 0 : 1
                matrix[i][j] = Swift.min(
                    matrix[i-1][j] + 1,     // deletion
                    matrix[i][j-1] + 1,     // insertion
                    matrix[i-1][j-1] + cost // substitution
                )
            }
        }
        
        return matrix[selfCount][otherCount]
    }
    
    public func jaccardSimilarity(to other: String) -> Double {
        let selfSet = Set(self.lowercased())
        let otherSet = Set(other.lowercased())
        
        let intersection = selfSet.intersection(otherSet)
        let union = selfSet.union(otherSet)
        
        guard !union.isEmpty else { return 0.0 }
        return Double(intersection.count) / Double(union.count)
    }
}

// Main benchmark class
public class IosSizeBenchmark {
    private let stringProcessor = StringProcessor()
    private let stringEncoder = StringEncoder()
    private let textAnalyzer = TextAnalyzer()
    private let stringFormatter = StringFormatter()
    
    private let sampleTexts = [
        "Hello, World! This is a sample text for string processing benchmarks.",
        "The quick brown fox jumps over the lazy dog. This sentence contains every letter of the alphabet.",
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
        "In computer science, a string is traditionally a sequence of characters, either as a literal constant or as some kind of variable.",
        "String processing is a fundamental operation in computer programming and text analysis applications.",
        "Regular expressions are powerful tools for pattern matching and string manipulation in various programming languages.",
        "Unicode support enables applications to handle text in multiple languages and character sets from around the world.",
        "Performance optimization of string operations is crucial for applications that process large amounts of text data.",
        "Encoding and decoding operations ensure proper representation of text data across different systems and protocols.",
        "Text analysis algorithms can extract meaningful insights from unstructured textual data sources."
    ]
    
    public init() {}
    
    public func runBenchmark() {
        // Basic string operations
        for text in sampleTexts {
            let reversed = StringUtils.reverse(text)
            let capitalized = StringUtils.capitalize(text)
            let camelCased = StringUtils.camelCase(text)
            let snakeCased = StringUtils.snakeCase(text)
            let kebabCased = StringUtils.kebabCase(text)
            let titleCased = StringUtils.titleCase(text)
            
            // String validation and analysis
            let wordCount = StringUtils.countWords(text)
            let vowelCount = StringUtils.countVowels(text)
            let consonantCount = StringUtils.countConsonants(text)
            let hasSpecialChars = StringUtils.containsSpecialChars(text)
            let isAlphanumeric = StringUtils.containsOnlyAlphanumeric(text)
        }
        
        // Email validation tests
        let emailTests = [
            "user@example.com",
            "invalid.email",
            "test.email+tag@domain.org",
            "not-an-email",
            "user.name@company.co.uk"
        ]
        
        for email in emailTests {
            let isValid = StringUtils.isValidEmail(email)
        }
        
        // Phone validation tests
        let phoneTests = [
            "+1-555-123-4567",
            "555.123.4567",
            "(555) 123-4567",
            "5551234567",
            "invalid-phone"
        ]
        
        for phone in phoneTests {
            let isValid = StringUtils.isValidPhone(phone)
        }
        
        // URL validation tests
        let urlTests = [
            "https://www.example.com",
            "http://domain.org/path",
            "ftp://invalid.url",
            "https://api.service.com/v1/data",
            "not-a-url"
        ]
        
        for url in urlTests {
            let isValid = StringUtils.isValidUrl(url)
        }
        
        // Text processing operations
        for text in sampleTexts {
            let cleaned = stringProcessor.removeExtraSpaces(text)
            let noPunctuation = stringProcessor.removePunctuation(text)
            let noNumbers = stringProcessor.removeNumbers(text)
            let noSpecialChars = stringProcessor.removeSpecialChars(text)
            
            let extractedNumbers = stringProcessor.extractNumbers(text)
            let extractedEmails = stringProcessor.extractEmails(text)
            let extractedUrls = stringProcessor.extractUrls(text)
            let extractedHashtags = stringProcessor.extractHashtags("#hashtag \(text) #another")
            let extractedMentions = stringProcessor.extractMentions("@user \(text) @another")
        }
        
        // Text transformation operations
        for text in sampleTexts {
            if !text.isEmpty {
                let withInsert = stringProcessor.insertCharAt(text, index: text.count / 2, character: "*")
                let withReplace = stringProcessor.replaceCharAt(text, index: 0, character: "X")
                let withRemove = text.count > 1 ? stringProcessor.removeCharAt(text, index: 1) : text
                let rotatedLeft = stringProcessor.rotateLeft(text, positions: 3)
                let rotatedRight = stringProcessor.rotateRight(text, positions: 3)
                
                if text.count > 1 {
                    let swapped = stringProcessor.swapChars(text, index1: 0, index2: text.count - 1)
                }
            }
        }
        
        // Encoding and decoding operations
        for text in sampleTexts {
            let base64Encoded = stringEncoder.encodeBase64Like(text)
            let base64Decoded = stringEncoder.decodeBase64Like(base64Encoded)
            
            let urlEncoded = stringEncoder.urlEncode(text)
            let urlDecoded = stringEncoder.urlDecode(urlEncoded)
            
            let htmlEncoded = stringEncoder.htmlEncode(text)
            let htmlDecoded = stringEncoder.htmlDecode(htmlEncoded)
            
            let jsonEscaped = stringEncoder.jsonEscape(text)
            let jsonUnescaped = stringEncoder.jsonUnescape(jsonEscaped)
        }
        
        // Text analysis operations
        for text in sampleTexts {
            let readabilityScore = textAnalyzer.calculateReadabilityScore(text)
            let sentiment = textAnalyzer.analyzeSentiment(text)
            let language = textAnalyzer.detectLanguage(text)
            let complexity = textAnalyzer.calculateComplexity(text)
        }
        
        // String formatting operations
        let templateVariables = [
            "name": "John Doe",
            "age": "30",
            "city": "New York",
            "occupation": "Developer"
        ]
        
        let templates = [
            "Hello {{name}}, you are {age} years old.",
            "Welcome to ${city}, {name}!",
            "Your occupation is {{occupation}} in {city}."
        ]
        
        for template in templates {
            let processed = stringFormatter.processTemplate(template, variables: templateVariables)
        }
        
        // Number and currency formatting
        let numbers = [123.456, 789.123, 456.789, 101.101, 999.999]
        for number in numbers {
            let formatted2 = stringFormatter.formatNumber(number, decimals: 2)
            let formatted4 = stringFormatter.formatNumber(number, decimals: 4)
            let currency = stringFormatter.formatCurrency(number)
            let percentage = stringFormatter.formatPercentage(number / 1000)
        }
        
        // Date formatting
        let timestamps: [Int64] = [86400000, 3600000, 180000, 86460000, 90061000]
        for timestamp in timestamps {
            let formatted = stringFormatter.formatDate(timestamp)
        }
        
        // Text padding and alignment
        let shortTexts = ["Short", "Medium text", "Very long text example", "X", "Test string"]
        for text in shortTexts {
            let paddedLeft = stringFormatter.padLeft(text, length: 20, character: "-")
            let paddedRight = stringFormatter.padRight(text, length: 20, character: "=")
            let paddedCenter = stringFormatter.padCenter(text, length: 25, character: " ")
        }
        
        // Text wrapping
        for text in sampleTexts {
            let wrapped40 = stringFormatter.wrapText(text, maxLineLength: 40)
            let wrapped60 = stringFormatter.wrapText(text, maxLineLength: 60)
            let wrapped80 = stringFormatter.wrapText(text, maxLineLength: 80)
        }
        
        // String similarity and distance calculations
        let textPairs = Array(zip(sampleTexts, sampleTexts.dropFirst()))
        for (text1, text2) in textPairs {
            let levenshteinDist = text1.levenshteinDistance(to: text2)
            let jaccardSim = text1.jaccardSimilarity(to: text2)
            
            let commonChars = Set(text1).intersection(Set(text2)).count
            let unionChars = Set(text1).union(Set(text2)).count
            let similarity = unionChars > 0 ? Double(commonChars) / Double(unionChars) : 0.0
            
            let longerText = text1.count > text2.count ? text1 : text2
            let shorterText = text1.count <= text2.count ? text1 : text2
            let containsSubstring = longerText.localizedCaseInsensitiveContains(shorterText)
        }
        
        // Complex string manipulation chains
        for text in sampleTexts {
            let complexResult = text
                |> StringUtils.reverse
                |> stringProcessor.removeExtraSpaces
                |> StringUtils.camelCase
                |> stringEncoder.urlEncode
                |> { stringFormatter.padCenter($0, length: 50, character: "*") }
                |> StringUtils.titleCase
                |> { stringProcessor.rotateLeft($0, positions: 5) }
                |> stringEncoder.htmlEncode
        }
        
        // Performance stress tests with large strings
        let largeText = sampleTexts.joined(separator: " ").repeatString(100)
        let veryLargeText = largeText.repeatString(10)
        
        // Heavy string operations on large text
        let largeCleaned = stringProcessor.removeExtraSpaces(veryLargeText)
        let largeEncoded = stringEncoder.encodeBase64Like(largeText)
        let largeAnalyzed = textAnalyzer.calculateComplexity(largeText)
        let largeWrapped = stringFormatter.wrapText(veryLargeText, maxLineLength: 100)
        
        // Multiple transformations on the same text
        var transformedText = largeText
        for i in 0..<10 {
            transformedText = StringUtils.reverse(transformedText)
            transformedText = stringProcessor.removeExtraSpaces(transformedText)
            transformedText = StringUtils.camelCase(transformedText)
            transformedText = stringProcessor.rotateLeft(transformedText, positions: i + 1)
        }
        
        // Advanced pattern matching and replacement
        for text in sampleTexts {
            let withNumbersReplaced = text.replacingOccurrences(
                of: "\\d+",
                with: "[NUMBER]",
                options: .regularExpression
            )
            
            let withEmailsReplaced = text.replacingOccurrences(
                of: "[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}",
                with: "[EMAIL]",
                options: .regularExpression
            )
            
            let withUrlsReplaced = text.replacingOccurrences(
                of: "https?://[A-Za-z0-9.-]+\\.[A-Za-z]{2,}(/[^\\s]*)?",
                with: "[URL]",
                options: .regularExpression
            )
        }
    }
}

// Custom operators for functional string processing
precedencegroup ForwardApplication {
    associativity: left
    higherThan: AssignmentPrecedence
}

infix operator |>: ForwardApplication

public func |><T, U>(_ value: T, _ function: (T) -> U) -> U {
    return function(value)
}

// Extension for string repetition
extension String {
    public func repeatString(_ count: Int) -> String {
        return String(repeating: self, count: count)
    }
}