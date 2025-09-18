/*
 * iOS Size Benchmark - Test Case Implementation
 * Generated with Claude AI (https://claude.ai)
 * 
 * This Kotlin Native implementation demonstrates language-specific
 * features and patterns for binary size comparison.
 */

package kntr.examples.ios.size.benchmark

import kotlin.text.*
import kotlin.math.pow

// Test case: String Processing - Tests impact of heavy string operations on code size

// String manipulation utilities
object StringUtils {
    
    // Basic string operations
    fun reverse(text: String): String = text.reversed()
    
    fun capitalize(text: String): String = text.replaceFirstChar { 
        if (it.isLowerCase()) it.titlecase() else it.toString() 
    }
    
    fun camelCase(text: String): String = text.split(" ", "_", "-")
        .filter { it.isNotEmpty() }
        .mapIndexed { index, word -> 
            if (index == 0) word.lowercase() 
            else word.lowercase().replaceFirstChar { it.uppercase() }
        }
        .joinToString("")
    
    fun snakeCase(text: String): String = text.split(" ", "-")
        .filter { it.isNotEmpty() }
        .joinToString("_") { it.lowercase() }
    
    fun kebabCase(text: String): String = text.split(" ", "_")
        .filter { it.isNotEmpty() }
        .joinToString("-") { it.lowercase() }
    
    fun titleCase(text: String): String = text.split(" ")
        .filter { it.isNotEmpty() }
        .joinToString(" ") { word ->
            word.lowercase().replaceFirstChar { it.uppercase() }
        }
    
    // String validation and analysis
    fun isValidEmail(email: String): Boolean {
        val emailRegex = "^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$".toRegex()
        return emailRegex.matches(email)
    }
    
    fun isValidPhone(phone: String): Boolean {
        val cleanPhone = phone.replace("[^0-9]".toRegex(), "")
        return cleanPhone.length in 10..15
    }
    
    fun isValidUrl(url: String): Boolean {
        val urlRegex = "^https?://[A-Za-z0-9.-]+\\.[A-Za-z]{2,}(/.*)?$".toRegex()
        return urlRegex.matches(url)
    }
    
    fun containsOnlyAlphanumeric(text: String): Boolean = 
        text.all { it.isLetterOrDigit() }
    
    fun containsSpecialChars(text: String): Boolean = 
        text.any { !it.isLetterOrDigit() && !it.isWhitespace() }
    
    fun countWords(text: String): Int = 
        text.split("\\s+".toRegex()).filter { it.isNotEmpty() }.size
    
    fun countCharacters(text: String, char: Char): Int = 
        text.count { it == char }
    
    fun countVowels(text: String): Int = 
        text.lowercase().count { it in "aeiou" }
    
    fun countConsonants(text: String): Int = 
        text.lowercase().count { it.isLetter() && it !in "aeiou" }
}

// Advanced string processors
class StringProcessor {
    
    // Text cleaning operations
    fun removeExtraSpaces(text: String): String = 
        text.replace("\\s+".toRegex(), " ").trim()
    
    fun removePunctuation(text: String): String = 
        text.replace("[^\\w\\s]".toRegex(), "")
    
    fun removeNumbers(text: String): String = 
        text.replace("\\d".toRegex(), "")
    
    fun removeSpecialChars(text: String): String = 
        text.replace("[^A-Za-z0-9\\s]".toRegex(), "")
    
    fun extractNumbers(text: String): List<String> = 
        "\\d+".toRegex().findAll(text).map { it.value }.toList()
    
    fun extractEmails(text: String): List<String> = 
        "[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}".toRegex()
            .findAll(text).map { it.value }.toList()
    
    fun extractUrls(text: String): List<String> = 
        "https?://[A-Za-z0-9.-]+\\.[A-Za-z]{2,}(/[^\\s]*)?".toRegex()
            .findAll(text).map { it.value }.toList()
    
    fun extractHashtags(text: String): List<String> = 
        "#\\w+".toRegex().findAll(text).map { it.value }.toList()
    
    fun extractMentions(text: String): List<String> = 
        "@\\w+".toRegex().findAll(text).map { it.value }.toList()
    
    // Text transformation operations
    fun insertCharAt(text: String, index: Int, char: Char): String = 
        text.substring(0, index) + char + text.substring(index)
    
    fun replaceCharAt(text: String, index: Int, char: Char): String = 
        text.substring(0, index) + char + text.substring(index + 1)
    
    fun removeCharAt(text: String, index: Int): String = 
        text.substring(0, index) + text.substring(index + 1)
    
    fun swapChars(text: String, index1: Int, index2: Int): String {
        val chars = text.toCharArray()
        val temp = chars[index1]
        chars[index1] = chars[index2]
        chars[index2] = temp
        return chars.concatToString()
    }
    
    fun rotateLeft(text: String, positions: Int): String {
        val pos = positions % text.length
        return text.substring(pos) + text.substring(0, pos)
    }
    
    fun rotateRight(text: String, positions: Int): String {
        val pos = positions % text.length
        return text.substring(text.length - pos) + text.substring(0, text.length - pos)
    }
}

// String encoding and formatting
class StringEncoder {
    
    // Base64-like encoding simulation
    fun encodeBase64Like(text: String): String = 
        text.encodeToByteArray().joinToString("") { byte ->
            (byte.toInt() and 0xFF).toString(16).padStart(2, '0')
        }
    
    fun decodeBase64Like(encoded: String): String = 
        encoded.chunked(2)
            .map { it.toInt(16).toByte() }
            .toByteArray()
            .decodeToString()

    // URL encoding simulation
    fun urlEncode(text: String): String = 
        text.map { char ->
            when {
                char.isLetterOrDigit() -> char.toString()
                char == ' ' -> "%20"
                char == '&' -> "%26"
                char == '=' -> "%3D"
                char == '?' -> "%3F"
                else -> "%${char.code.toString(16).padStart(2, '0').uppercase()}"
            }
        }.joinToString("")
    
    fun urlDecode(encoded: String): String {
        var result = encoded
        result = result.replace("%20", " ")
        result = result.replace("%26", "&")
        result = result.replace("%3D", "=")
        result = result.replace("%3F", "?")
        return result
    }
    
    // HTML encoding simulation
    fun htmlEncode(text: String): String = 
        text.replace("&", "&amp;")
            .replace("<", "&lt;")
            .replace(">", "&gt;")
            .replace("\"", "&quot;")
            .replace("'", "&#39;")
    
    fun htmlDecode(encoded: String): String = 
        encoded.replace("&amp;", "&")
            .replace("&lt;", "<")
            .replace("&gt;", ">")
            .replace("&quot;", "\"")
            .replace("&#39;", "'")
    
    // JSON string escaping
    fun jsonEscape(text: String): String = 
        text.replace("\\", "\\\\")
            .replace("\"", "\\\"")
            .replace("\n", "\\n")
            .replace("\r", "\\r")
            .replace("\t", "\\t")
    
    fun jsonUnescape(escaped: String): String = 
        escaped.replace("\\\\", "\\")
            .replace("\\\"", "\"")
            .replace("\\n", "\n")
            .replace("\\r", "\r")
            .replace("\\t", "\t")
}

// Text analysis and metrics
class TextAnalyzer {
    
    // Readability metrics
    fun calculateReadabilityScore(text: String): Double {
        val sentences = text.split("[.!?]+".toRegex()).filter { it.trim().isNotEmpty() }
        val words = text.split("\\s+".toRegex()).filter { it.isNotEmpty() }
        val syllables = words.sumOf { countSyllables(it) }
        
        if (sentences.isEmpty() || words.isEmpty()) return 0.0
        
        val avgWordsPerSentence = words.size.toDouble() / sentences.size
        val avgSyllablesPerWord = syllables.toDouble() / words.size
        
        return 206.835 - (1.015 * avgWordsPerSentence) - (84.6 * avgSyllablesPerWord)
    }
    
    fun countSyllables(word: String): Int {
        val vowels = "aeiouAEIOU"
        var count = 0
        var previousWasVowel = false
        
        for (char in word) {
            val isVowel = char in vowels
            if (isVowel && !previousWasVowel) {
                count++
            }
            previousWasVowel = isVowel
        }
        
        if (word.endsWith("e", ignoreCase = true) && count > 1) {
            count--
        }
        
        return maxOf(1, count)
    }
    
    // Sentiment analysis simulation
    fun analyzeSentiment(text: String): String {
        val positiveWords = setOf("good", "great", "excellent", "amazing", "wonderful", "fantastic", "love", "like", "happy", "joy")
        val negativeWords = setOf("bad", "terrible", "awful", "horrible", "hate", "dislike", "sad", "angry", "disappointed", "frustrated")
        
        val words = text.lowercase().split("\\s+".toRegex())
        val positiveCount = words.count { it in positiveWords }
        val negativeCount = words.count { it in negativeWords }
        
        return when {
            positiveCount > negativeCount -> "Positive"
            negativeCount > positiveCount -> "Negative"
            else -> "Neutral"
        }
    }
    
    // Language detection simulation
    fun detectLanguage(text: String): String {
        val englishPatterns = setOf("the", "and", "is", "in", "to", "of", "a", "that", "it", "with")
        val spanishPatterns = setOf("el", "la", "de", "que", "y", "a", "en", "un", "es", "se")
        val frenchPatterns = setOf("le", "de", "et", "à", "un", "il", "être", "et", "en", "avoir")
        
        val words = text.lowercase().split("\\s+".toRegex())
        val englishScore = words.count { it in englishPatterns }
        val spanishScore = words.count { it in spanishPatterns }
        val frenchScore = words.count { it in frenchPatterns }
        
        return when (maxOf(englishScore, spanishScore, frenchScore)) {
            englishScore -> "English"
            spanishScore -> "Spanish"
            frenchScore -> "French"
            else -> "Unknown"
        }
    }
    
    // Text complexity metrics
    fun calculateComplexity(text: String): Map<String, Any> {
        val words = text.split("\\s+".toRegex()).filter { it.isNotEmpty() }
        val sentences = text.split("[.!?]+".toRegex()).filter { it.trim().isNotEmpty() }
        val characters = text.length
        val charactersNoSpaces = text.replace("\\s".toRegex(), "").length
        
        return mapOf(
            "wordCount" to words.size,
            "sentenceCount" to sentences.size,
            "characterCount" to characters,
            "characterCountNoSpaces" to charactersNoSpaces,
            "averageWordsPerSentence" to if (sentences.isNotEmpty()) words.size.toDouble() / sentences.size else 0.0,
            "averageCharactersPerWord" to if (words.isNotEmpty()) charactersNoSpaces.toDouble() / words.size else 0.0,
            "longestWord" to (words.maxByOrNull { it.length }?.length ?: 0),
            "shortestWord" to (words.minByOrNull { it.length }?.length ?: 0)
        )
    }
}

// String formatting and templates
class StringFormatter {
    
    // Template processing
    fun processTemplate(template: String, variables: Map<String, String>): String {
        var result = template
        variables.forEach { (key, value) ->
            result = result.replace("{{$key}}", value)
            result = result.replace("{$key}", value)
            result = result.replace("\${$key}", value)
        }
        return result
    }
    
    // Number formatting
    fun formatNumber(number: Double, decimals: Int): String {
        val factor = 10.0.pow(decimals.toDouble()).toLong()
        val rounded = (number * factor).toLong().toDouble() / factor
        return rounded.toString()
    }
    
    fun formatCurrency(amount: Double, currency: String = "USD"): String {
        val formatted = (amount * 100).toLong().toDouble() / 100
        return "$currency $formatted"
    }
    
    fun formatPercentage(value: Double): String {
        val percentage = (value * 1000).toLong().toDouble() / 10
        return "$percentage%"
    }
    
    // Date formatting simulation
    fun formatDate(timestamp: Long): String {
        val days = timestamp / (24 * 60 * 60 * 1000)
        val hours = (timestamp % (24 * 60 * 60 * 1000)) / (60 * 60 * 1000)
        val minutes = (timestamp % (60 * 60 * 1000)) / (60 * 1000)
        return "${days.toString().padStart(2, '0')}:${hours.toString().padStart(2, '0')}:${minutes.toString().padStart(2, '0')}"
    }
    
    // String padding and alignment
    fun padLeft(text: String, length: Int, char: Char = ' '): String = 
        text.padStart(length, char)
    
    fun padRight(text: String, length: Int, char: Char = ' '): String = 
        text.padEnd(length, char)
    
    fun padCenter(text: String, length: Int, char: Char = ' '): String {
        if (text.length >= length) return text
        val totalPadding = length - text.length
        val leftPadding = totalPadding / 2
        val rightPadding = totalPadding - leftPadding
        return char.toString().repeat(leftPadding) + text + char.toString().repeat(rightPadding)
    }
    
    // Text wrapping
    fun wrapText(text: String, maxLineLength: Int): List<String> {
        val words = text.split(" ")
        val lines = mutableListOf<String>()
        var currentLine = ""
        
        for (word in words) {
            if (currentLine.isEmpty()) {
                currentLine = word
            } else if (currentLine.length + word.length + 1 <= maxLineLength) {
                currentLine += " $word"
            } else {
                lines.add(currentLine)
                currentLine = word
            }
        }
        
        if (currentLine.isNotEmpty()) {
            lines.add(currentLine)
        }
        
        return lines
    }
}

// Main benchmark class
class IosSizeBenchmark {
    val stringProcessor = StringProcessor()
    val stringEncoder = StringEncoder()
    val textAnalyzer = TextAnalyzer()
    val stringFormatter = StringFormatter()
    
    val sampleTexts = listOf(
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
    )
    
    fun runBenchmark() {
        // Basic string operations
        sampleTexts.forEach { text ->
            val reversed = StringUtils.reverse(text)
            val capitalized = StringUtils.capitalize(text)
            val camelCased = StringUtils.camelCase(text)
            val snakeCased = StringUtils.snakeCase(text)
            val kebabCased = StringUtils.kebabCase(text)
            val titleCased = StringUtils.titleCase(text)
            
            // String validation
            val wordCount = StringUtils.countWords(text)
            val vowelCount = StringUtils.countVowels(text)
            val consonantCount = StringUtils.countConsonants(text)
            val hasSpecialChars = StringUtils.containsSpecialChars(text)
            val isAlphanumeric = StringUtils.containsOnlyAlphanumeric(text)
        }
        
        // Email validation tests
        val emailTests = listOf(
            "user@example.com",
            "invalid.email",
            "test.email+tag@domain.org",
            "not-an-email",
            "user.name@company.co.uk"
        )
        
        emailTests.forEach { email ->
            val isValid = StringUtils.isValidEmail(email)
        }
        
        // Phone validation tests
        val phoneTests = listOf(
            "+1-555-123-4567",
            "555.123.4567",
            "(555) 123-4567",
            "5551234567",
            "invalid-phone"
        )
        
        phoneTests.forEach { phone ->
            val isValid = StringUtils.isValidPhone(phone)
        }
        
        // URL validation tests
        val urlTests = listOf(
            "https://www.example.com",
            "http://domain.org/path",
            "ftp://invalid.url",
            "https://api.service.com/v1/data",
            "not-a-url"
        )
        
        urlTests.forEach { url ->
            val isValid = StringUtils.isValidUrl(url)
        }
        
        // Text processing operations
        sampleTexts.forEach { text ->
            val cleaned = stringProcessor.removeExtraSpaces(text)
            val noPunctuation = stringProcessor.removePunctuation(text)
            val noNumbers = stringProcessor.removeNumbers(text)
            val noSpecialChars = stringProcessor.removeSpecialChars(text)
            
            val extractedNumbers = stringProcessor.extractNumbers(text)
            val extractedEmails = stringProcessor.extractEmails(text)
            val extractedUrls = stringProcessor.extractUrls(text)
            val extractedHashtags = stringProcessor.extractHashtags("#hashtag $text #another")
            val extractedMentions = stringProcessor.extractMentions("@user $text @another")
        }
        
        // Text transformation operations
        sampleTexts.forEach { text ->
            if (text.isNotEmpty()) {
                val withInsert = stringProcessor.insertCharAt(text, text.length / 2, '*')
                val withReplace = stringProcessor.replaceCharAt(text, 0, 'X')
                val withRemove = if (text.length > 1) stringProcessor.removeCharAt(text, 1) else text
                val rotatedLeft = stringProcessor.rotateLeft(text, 3)
                val rotatedRight = stringProcessor.rotateRight(text, 3)
                
                if (text.length > 1) {
                    val swapped = stringProcessor.swapChars(text, 0, text.length - 1)
                }
            }
        }
        
        // Encoding and decoding operations
        sampleTexts.forEach { text ->
            val base64Encoded = stringEncoder.encodeBase64Like(text)
            val base64Decoded = stringEncoder.decodeBase64Like(base64Encoded)
            
            val urlEncoded = stringEncoder.urlEncode(text)
            val urlDecoded = stringEncoder.urlDecode(urlEncoded)
            
            val htmlEncoded = stringEncoder.htmlEncode(text)
            val htmlDecoded = stringEncoder.htmlDecode(htmlEncoded)
            
            val jsonEscaped = stringEncoder.jsonEscape(text)
            val jsonUnescaped = stringEncoder.jsonUnescape(jsonEscaped)
        }
        
        // Text analysis operations
        sampleTexts.forEach { text ->
            val readabilityScore = textAnalyzer.calculateReadabilityScore(text)
            val sentiment = textAnalyzer.analyzeSentiment(text)
            val language = textAnalyzer.detectLanguage(text)
            val complexity = textAnalyzer.calculateComplexity(text)
        }
        
        // String formatting operations
        val templateVariables = mapOf(
            "name" to "John Doe",
            "age" to "30",
            "city" to "New York",
            "occupation" to "Developer"
        )
        
        val templates = listOf(
            "Hello {{name}}, you are {age} years old.",
            "Welcome to \${city}, {name}!",
            "Your occupation is {{occupation}} in {city}."
        )
        
        templates.forEach { template ->
            val processed = stringFormatter.processTemplate(template, templateVariables)
        }
        
        // Number and currency formatting
        val numbers = listOf(123.456, 789.123, 456.789, 101.101, 999.999)
        numbers.forEach { number ->
            val formatted2 = stringFormatter.formatNumber(number, 2)
            val formatted4 = stringFormatter.formatNumber(number, 4)
            val currency = stringFormatter.formatCurrency(number)
            val percentage = stringFormatter.formatPercentage(number / 1000)
        }
        
        // Date formatting
        val timestamps = listOf(86400000L, 3600000L, 180000L, 86460000L, 90061000L)
        timestamps.forEach { timestamp ->
            val formatted = stringFormatter.formatDate(timestamp)
        }
        
        // Text padding and alignment
        val shortTexts = listOf("Short", "Medium text", "Very long text example", "X", "Test string")
        shortTexts.forEach { text ->
            val paddedLeft = stringFormatter.padLeft(text, 20, '-')
            val paddedRight = stringFormatter.padRight(text, 20, '=')
            val paddedCenter = stringFormatter.padCenter(text, 25, ' ')
        }
        
        // Text wrapping
        sampleTexts.forEach { text ->
            val wrapped40 = stringFormatter.wrapText(text, 40)
            val wrapped60 = stringFormatter.wrapText(text, 60)
            val wrapped80 = stringFormatter.wrapText(text, 80)
        }
        
        // Complex string manipulation chains
        sampleTexts.forEach { text ->
            val complexResult = text
                .let { StringUtils.reverse(it) }
                .let { stringProcessor.removeExtraSpaces(it) }
                .let { StringUtils.camelCase(it) }
                .let { stringEncoder.urlEncode(it) }
                .let { stringFormatter.padCenter(it, 50, '*') }
                .let { StringUtils.titleCase(it) }
                .let { stringProcessor.rotateLeft(it, 5) }
                .let { stringEncoder.htmlEncode(it) }
        }
        
        // String comparison and similarity
        val textPairs = sampleTexts.zipWithNext()
        textPairs.forEach { (text1, text2) ->
            val commonChars = text1.toSet().intersect(text2.toSet()).size
            val unionChars = text1.toSet().union(text2.toSet()).size
            val similarity = if (unionChars > 0) commonChars.toDouble() / unionChars else 0.0
            
            val longerText = if (text1.length > text2.length) text1 else text2
            val shorterText = if (text1.length <= text2.length) text1 else text2
            val containsSubstring = longerText.contains(shorterText, ignoreCase = true)
        }
        
        // Performance stress tests with large strings
        val largeText = sampleTexts.joinToString(" ").repeat(100)
        val veryLargeText = largeText.repeat(10)
        
        // Heavy string operations on large text
        val largeCleaned = stringProcessor.removeExtraSpaces(veryLargeText)
        val largeEncoded = stringEncoder.encodeBase64Like(largeText)
        val largeAnalyzed = textAnalyzer.calculateComplexity(largeText)
        val largeWrapped = stringFormatter.wrapText(veryLargeText, 100)
        
        // Multiple transformations on the same text
        var transformedText = largeText
        repeat(10) {
            transformedText = StringUtils.reverse(transformedText)
            transformedText = stringProcessor.removeExtraSpaces(transformedText)
            transformedText = StringUtils.camelCase(transformedText)
            transformedText = stringProcessor.rotateLeft(transformedText, it + 1)
        }
    }
}