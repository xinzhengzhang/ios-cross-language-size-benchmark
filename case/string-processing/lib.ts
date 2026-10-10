/*
 * iOS Size Benchmark - Test Case Implementation
 * Generated with Claude AI (https://claude.ai)
 *
 * scriptc (TypeScript-to-native) port of the Kotlin `string-processing` case
 * (lib.kt is authoritative). Kotlin's `object StringUtils` becomes a class
 * with static methods; the processor/encoder/analyzer/formatter classes map
 * 1:1. Kotlin regex (`toRegex`, `findAll`, `matches`, split-on-regex) maps to
 * JS RegExp; `String.replace(old,new)` (which replaces ALL in Kotlin) maps to
 * literal split/join. `Map<String, Any>` from calculateComplexity is modeled
 * as a typed `TextComplexity` class (the static tier forbids `any`). A single
 * exported entry (runBenchmark) constructs and uses every type and logs an
 * aggregate so nothing is dead-code eliminated.
 */

// ---- small stdlib-equivalent helpers ----
function padStart2(s: string): string {
  return s.length >= 2 ? s : "0".repeat(2 - s.length) + s;
}

// Kotlin String.replace(old, new) replaces every occurrence; JS String.replace
// with a string replaces only the first. split/join replaces all, literally.
function replaceAllLiteral(s: string, find: string, repl: string): string {
  return s.split(find).join(repl);
}

// Kotlin Regex.findAll(...).map { it.value }.toList(). The passed RegExp must
// carry the global flag so exec() advances through every match.
function findAll(re: RegExp, text: string): string[] {
  re.lastIndex = 0;
  const out: string[] = [];
  let m = re.exec(text);
  while (m !== null) {
    out.push(m[0]);
    if (m.index === re.lastIndex) re.lastIndex = re.lastIndex + 1;
    m = re.exec(text);
  }
  return out;
}

// UTF-8 byte encoding (Kotlin String.encodeToByteArray()).
function utf8Encode(text: string): number[] {
  const out: number[] = [];
  for (let i = 0; i < text.length; i++) {
    let code = text.charCodeAt(i);
    if (code >= 0xd800 && code <= 0xdbff && i + 1 < text.length) {
      const next = text.charCodeAt(i + 1);
      if (next >= 0xdc00 && next <= 0xdfff) {
        code = 0x10000 + ((code - 0xd800) << 10) + (next - 0xdc00);
        i++;
      }
    }
    if (code < 0x80) {
      out.push(code);
    } else if (code < 0x800) {
      out.push(0xc0 | (code >> 6), 0x80 | (code & 0x3f));
    } else if (code < 0x10000) {
      out.push(0xe0 | (code >> 12), 0x80 | ((code >> 6) & 0x3f), 0x80 | (code & 0x3f));
    } else {
      out.push(0xf0 | (code >> 18), 0x80 | ((code >> 12) & 0x3f), 0x80 | ((code >> 6) & 0x3f), 0x80 | (code & 0x3f));
    }
  }
  return out;
}
function utf8Decode(bytes: number[]): string {
  let out = "";
  let i = 0;
  while (i < bytes.length) {
    const b0 = bytes[i++];
    let cp = 0;
    if (b0 < 0x80) {
      cp = b0;
    } else if ((b0 & 0xe0) === 0xc0) {
      cp = ((b0 & 0x1f) << 6) | (bytes[i++] & 0x3f);
    } else if ((b0 & 0xf0) === 0xe0) {
      cp = ((b0 & 0x0f) << 12) | ((bytes[i++] & 0x3f) << 6) | (bytes[i++] & 0x3f);
    } else {
      cp = ((b0 & 0x07) << 18) | ((bytes[i++] & 0x3f) << 12) | ((bytes[i++] & 0x3f) << 6) | (bytes[i++] & 0x3f);
    }
    if (cp > 0xffff) {
      cp -= 0x10000;
      out += String.fromCharCode(0xd800 + (cp >> 10), 0xdc00 + (cp & 0x3ff));
    } else {
      out += String.fromCharCode(cp);
    }
  }
  return out;
}

function isLetter(ch: string): boolean {
  return (ch >= "a" && ch <= "z") || (ch >= "A" && ch <= "Z");
}
function isDigit(ch: string): boolean {
  return ch >= "0" && ch <= "9";
}
function isLetterOrDigit(ch: string): boolean {
  return isLetter(ch) || isDigit(ch);
}
function isWhitespace(ch: string): boolean {
  return ch === " " || ch === "\t" || ch === "\n" || ch === "\r";
}

// String manipulation utilities (Kotlin `object StringUtils`).
class StringUtils {
  static reverse(text: string): string {
    return text.split("").reverse().join("");
  }

  static capitalize(text: string): string {
    if (text.length === 0) return text;
    const first = text.charAt(0);
    const head = first >= "a" && first <= "z" ? first.toUpperCase() : first;
    return head + text.substring(1);
  }

  static camelCase(text: string): string {
    const words = text.split(/[ _-]/).filter((it) => it.length > 0);
    return words
      .map((word, index) =>
        index === 0 ? word.toLowerCase() : StringUtils.capitalizeFirst(word.toLowerCase()),
      )
      .join("");
  }

  static snakeCase(text: string): string {
    return text
      .split(/[ -]/)
      .filter((it) => it.length > 0)
      .map((it) => it.toLowerCase())
      .join("_");
  }

  static kebabCase(text: string): string {
    return text
      .split(/[ _]/)
      .filter((it) => it.length > 0)
      .map((it) => it.toLowerCase())
      .join("-");
  }

  static titleCase(text: string): string {
    return text
      .split(" ")
      .filter((it) => it.length > 0)
      .map((word) => StringUtils.capitalizeFirst(word.toLowerCase()))
      .join(" ");
  }

  private static capitalizeFirst(word: string): string {
    if (word.length === 0) return word;
    return word.charAt(0).toUpperCase() + word.substring(1);
  }

  static isValidEmail(email: string): boolean {
    const emailRegex = /^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$/;
    return emailRegex.test(email);
  }

  static isValidPhone(phone: string): boolean {
    const cleanPhone = phone.replace(/[^0-9]/g, "");
    return cleanPhone.length >= 10 && cleanPhone.length <= 15;
  }

  static isValidUrl(url: string): boolean {
    const urlRegex = /^https?:\/\/[A-Za-z0-9.-]+\.[A-Za-z]{2,}(\/.*)?$/;
    return urlRegex.test(url);
  }

  static containsOnlyAlphanumeric(text: string): boolean {
    for (const ch of text) {
      if (!isLetterOrDigit(ch)) return false;
    }
    return true;
  }

  static containsSpecialChars(text: string): boolean {
    for (const ch of text) {
      if (!isLetterOrDigit(ch) && !isWhitespace(ch)) return true;
    }
    return false;
  }

  static countWords(text: string): number {
    return text.split(/\s+/).filter((it) => it.length > 0).length;
  }

  static countCharacters(text: string, ch: string): number {
    let count = 0;
    for (const c of text) if (c === ch) count++;
    return count;
  }

  static countVowels(text: string): number {
    const lower = text.toLowerCase();
    let count = 0;
    for (const ch of lower) if ("aeiou".indexOf(ch) >= 0) count++;
    return count;
  }

  static countConsonants(text: string): number {
    const lower = text.toLowerCase();
    let count = 0;
    for (const ch of lower) if (isLetter(ch) && "aeiou".indexOf(ch) < 0) count++;
    return count;
  }
}
// Advanced string processors.
class StringProcessor {
  removeExtraSpaces(text: string): string {
    return text.replace(/\s+/g, " ").trim();
  }

  removePunctuation(text: string): string {
    return text.replace(/[^\w\s]/g, "");
  }

  removeNumbers(text: string): string {
    return text.replace(/\d/g, "");
  }

  removeSpecialChars(text: string): string {
    return text.replace(/[^A-Za-z0-9\s]/g, "");
  }

  extractNumbers(text: string): string[] {
    return findAll(/\d+/g, text);
  }

  extractEmails(text: string): string[] {
    return findAll(/[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}/g, text);
  }

  extractUrls(text: string): string[] {
    return findAll(/https?:\/\/[A-Za-z0-9.-]+\.[A-Za-z]{2,}(\/[^\s]*)?/g, text);
  }

  extractHashtags(text: string): string[] {
    return findAll(/#\w+/g, text);
  }

  extractMentions(text: string): string[] {
    return findAll(/@\w+/g, text);
  }

  insertCharAt(text: string, index: number, ch: string): string {
    return text.substring(0, index) + ch + text.substring(index);
  }

  replaceCharAt(text: string, index: number, ch: string): string {
    return text.substring(0, index) + ch + text.substring(index + 1);
  }

  removeCharAt(text: string, index: number): string {
    return text.substring(0, index) + text.substring(index + 1);
  }

  swapChars(text: string, index1: number, index2: number): string {
    const chars = text.split("");
    const temp = chars[index1];
    chars[index1] = chars[index2];
    chars[index2] = temp;
    return chars.join("");
  }

  rotateLeft(text: string, positions: number): string {
    if (text.length === 0) return text;
    const pos = positions % text.length;
    return text.substring(pos) + text.substring(0, pos);
  }

  rotateRight(text: string, positions: number): string {
    if (text.length === 0) return text;
    const pos = positions % text.length;
    return text.substring(text.length - pos) + text.substring(0, text.length - pos);
  }
}

// String encoding and formatting.
class StringEncoder {
  encodeBase64Like(text: string): string {
    const bytes = utf8Encode(text);
    let out = "";
    for (const byte of bytes) {
      out += padStart2((byte & 0xff).toString(16));
    }
    return out;
  }

  decodeBase64Like(encoded: string): string {
    const bytes: number[] = [];
    for (let i = 0; i < encoded.length; i += 2) {
      bytes.push(parseInt(encoded.substring(i, i + 2), 16));
    }
    return utf8Decode(bytes);
  }

  urlEncode(text: string): string {
    let out = "";
    for (const ch of text) {
      if (isLetterOrDigit(ch)) {
        out += ch;
      } else if (ch === " ") {
        out += "%20";
      } else if (ch === "&") {
        out += "%26";
      } else if (ch === "=") {
        out += "%3D";
      } else if (ch === "?") {
        out += "%3F";
      } else {
        out += "%" + padStart2(ch.charCodeAt(0).toString(16)).toUpperCase();
      }
    }
    return out;
  }

  urlDecode(encoded: string): string {
    let result = encoded;
    result = replaceAllLiteral(result, "%20", " ");
    result = replaceAllLiteral(result, "%26", "&");
    result = replaceAllLiteral(result, "%3D", "=");
    result = replaceAllLiteral(result, "%3F", "?");
    return result;
  }

  htmlEncode(text: string): string {
    let r = text;
    r = replaceAllLiteral(r, "&", "&amp;");
    r = replaceAllLiteral(r, "<", "&lt;");
    r = replaceAllLiteral(r, ">", "&gt;");
    r = replaceAllLiteral(r, '"', "&quot;");
    r = replaceAllLiteral(r, "'", "&#39;");
    return r;
  }

  htmlDecode(encoded: string): string {
    let r = encoded;
    r = replaceAllLiteral(r, "&amp;", "&");
    r = replaceAllLiteral(r, "&lt;", "<");
    r = replaceAllLiteral(r, "&gt;", ">");
    r = replaceAllLiteral(r, "&quot;", '"');
    r = replaceAllLiteral(r, "&#39;", "'");
    return r;
  }

  jsonEscape(text: string): string {
    let r = text;
    r = replaceAllLiteral(r, "\\", "\\\\");
    r = replaceAllLiteral(r, '"', '\\"');
    r = replaceAllLiteral(r, "\n", "\\n");
    r = replaceAllLiteral(r, "\r", "\\r");
    r = replaceAllLiteral(r, "\t", "\\t");
    return r;
  }

  jsonUnescape(escaped: string): string {
    let r = escaped;
    r = replaceAllLiteral(r, "\\\\", "\\");
    r = replaceAllLiteral(r, '\\"', '"');
    r = replaceAllLiteral(r, "\\n", "\n");
    r = replaceAllLiteral(r, "\\r", "\r");
    r = replaceAllLiteral(r, "\\t", "\t");
    return r;
  }
}
// Kotlin's calculateComplexity returns Map<String, Any>; the static tier
// forbids `any`, so the identical metrics are returned via a typed shape.
class TextComplexity {
  constructor(
    readonly wordCount: number,
    readonly sentenceCount: number,
    readonly characterCount: number,
    readonly characterCountNoSpaces: number,
    readonly averageWordsPerSentence: number,
    readonly averageCharactersPerWord: number,
    readonly longestWord: number,
    readonly shortestWord: number,
  ) {}
}

// Text analysis and metrics.
class TextAnalyzer {
  calculateReadabilityScore(text: string): number {
    const sentences = text.split(/[.!?]+/).filter((it) => it.trim().length > 0);
    const words = text.split(/\s+/).filter((it) => it.length > 0);
    let syllables = 0;
    for (const w of words) syllables += this.countSyllables(w);

    if (sentences.length === 0 || words.length === 0) return 0.0;

    const avgWordsPerSentence = words.length / sentences.length;
    const avgSyllablesPerWord = syllables / words.length;

    return 206.835 - 1.015 * avgWordsPerSentence - 84.6 * avgSyllablesPerWord;
  }

  countSyllables(word: string): number {
    const vowels = "aeiouAEIOU";
    let count = 0;
    let previousWasVowel = false;

    for (const ch of word) {
      const isVowel = vowels.indexOf(ch) >= 0;
      if (isVowel && !previousWasVowel) count++;
      previousWasVowel = isVowel;
    }

    const lower = word.toLowerCase();
    if (lower.length > 0 && lower.charAt(lower.length - 1) === "e" && count > 1) {
      count--;
    }

    return Math.max(1, count);
  }

  analyzeSentiment(text: string): string {
    const positiveWords = new Set<string>([
      "good", "great", "excellent", "amazing", "wonderful", "fantastic", "love", "like", "happy", "joy",
    ]);
    const negativeWords = new Set<string>([
      "bad", "terrible", "awful", "horrible", "hate", "dislike", "sad", "angry", "disappointed", "frustrated",
    ]);

    const words = text.toLowerCase().split(/\s+/);
    let positiveCount = 0;
    let negativeCount = 0;
    for (const w of words) {
      if (positiveWords.has(w)) positiveCount++;
      if (negativeWords.has(w)) negativeCount++;
    }

    if (positiveCount > negativeCount) return "Positive";
    if (negativeCount > positiveCount) return "Negative";
    return "Neutral";
  }

  detectLanguage(text: string): string {
    const englishPatterns = new Set<string>(["the", "and", "is", "in", "to", "of", "a", "that", "it", "with"]);
    const spanishPatterns = new Set<string>(["el", "la", "de", "que", "y", "a", "en", "un", "es", "se"]);
    const frenchPatterns = new Set<string>(["le", "de", "et", "à", "un", "il", "être", "en", "avoir"]);

    const words = text.toLowerCase().split(/\s+/);
    let englishScore = 0;
    let spanishScore = 0;
    let frenchScore = 0;
    for (const w of words) {
      if (englishPatterns.has(w)) englishScore++;
      if (spanishPatterns.has(w)) spanishScore++;
      if (frenchPatterns.has(w)) frenchScore++;
    }

    const maxScore = Math.max(englishScore, spanishScore, frenchScore);
    if (maxScore === englishScore) return "English";
    if (maxScore === spanishScore) return "Spanish";
    if (maxScore === frenchScore) return "French";
    return "Unknown";
  }

  calculateComplexity(text: string): TextComplexity {
    const words = text.split(/\s+/).filter((it) => it.length > 0);
    const sentences = text.split(/[.!?]+/).filter((it) => it.trim().length > 0);
    const characters = text.length;
    const charactersNoSpaces = text.replace(/\s/g, "").length;

    let longest = 0;
    let shortest = words.length > 0 ? words[0].length : 0;
    for (const w of words) {
      if (w.length > longest) longest = w.length;
      if (w.length < shortest) shortest = w.length;
    }

    return new TextComplexity(
      words.length,
      sentences.length,
      characters,
      charactersNoSpaces,
      sentences.length > 0 ? words.length / sentences.length : 0.0,
      words.length > 0 ? charactersNoSpaces / words.length : 0.0,
      words.length > 0 ? longest : 0,
      words.length > 0 ? shortest : 0,
    );
  }
}
// String formatting and templates.
class StringFormatter {
  processTemplate(template: string, variables: Map<string, string>): string {
    let result = template;
    for (const [key, value] of variables) {
      result = replaceAllLiteral(result, `{{${key}}}`, value);
      result = replaceAllLiteral(result, `{${key}}`, value);
      result = replaceAllLiteral(result, `\${${key}}`, value);
    }
    return result;
  }

  // Kotlin: factor = 10^decimals (as Long); rounded = (number*factor).toLong()/factor
  formatNumber(num: number, decimals: number): string {
    const factor = Math.pow(10.0, decimals);
    const rounded = Math.trunc(num * factor) / factor;
    return `${rounded}`;
  }

  formatCurrency(amount: number, currency: string = "USD"): string {
    const formatted = Math.trunc(amount * 100) / 100;
    return `${currency} ${formatted}`;
  }

  formatPercentage(value: number): string {
    const percentage = Math.trunc(value * 1000) / 10;
    return `${percentage}%`;
  }

  formatDate(timestamp: number): string {
    const days = Math.trunc(timestamp / (24 * 60 * 60 * 1000));
    const hours = Math.trunc((timestamp % (24 * 60 * 60 * 1000)) / (60 * 60 * 1000));
    const minutes = Math.trunc((timestamp % (60 * 60 * 1000)) / (60 * 1000));
    return `${padStart2(`${days}`)}:${padStart2(`${hours}`)}:${padStart2(`${minutes}`)}`;
  }

  padLeft(text: string, length: number, ch: string = " "): string {
    if (text.length >= length) return text;
    return ch.repeat(length - text.length) + text;
  }

  padRight(text: string, length: number, ch: string = " "): string {
    if (text.length >= length) return text;
    return text + ch.repeat(length - text.length);
  }

  padCenter(text: string, length: number, ch: string = " "): string {
    if (text.length >= length) return text;
    const totalPadding = length - text.length;
    const leftPadding = Math.trunc(totalPadding / 2);
    const rightPadding = totalPadding - leftPadding;
    return ch.repeat(leftPadding) + text + ch.repeat(rightPadding);
  }

  wrapText(text: string, maxLineLength: number): string[] {
    const words = text.split(" ");
    const lines: string[] = [];
    let currentLine = "";

    for (const word of words) {
      if (currentLine.length === 0) {
        currentLine = word;
      } else if (currentLine.length + word.length + 1 <= maxLineLength) {
        currentLine += ` ${word}`;
      } else {
        lines.push(currentLine);
        currentLine = word;
      }
    }

    if (currentLine.length > 0) lines.push(currentLine);
    return lines;
  }
}
// Main benchmark class.
class IosSizeBenchmark {
  private readonly stringProcessor = new StringProcessor();
  private readonly stringEncoder = new StringEncoder();
  private readonly textAnalyzer = new TextAnalyzer();
  private readonly stringFormatter = new StringFormatter();

  private readonly sampleTexts: string[] = [
    "Hello, World! This is a sample text for string processing benchmarks.",
    "The quick brown fox jumps over the lazy dog. This sentence contains every letter of the alphabet.",
    "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
    "In computer science, a string is traditionally a sequence of characters, either as a literal constant or as some kind of variable.",
    "String processing is a fundamental operation in computer programming and text analysis applications.",
    "Regular expressions are powerful tools for pattern matching and string manipulation in various programming languages.",
    "Unicode support enables applications to handle text in multiple languages and character sets from around the world.",
    "Performance optimization of string operations is crucial for applications that process large amounts of text data.",
    "Encoding and decoding operations ensure proper representation of text data across different systems and protocols.",
    "Text analysis algorithms can extract meaningful insights from unstructured textual data sources.",
  ];

  runBenchmark(): void {
    let acc = 0;

    // Basic string operations.
    for (const text of this.sampleTexts) {
      acc += StringUtils.reverse(text).length;
      acc += StringUtils.capitalize(text).length;
      acc += StringUtils.camelCase(text).length;
      acc += StringUtils.snakeCase(text).length;
      acc += StringUtils.kebabCase(text).length;
      acc += StringUtils.titleCase(text).length;

      acc += StringUtils.countWords(text);
      acc += StringUtils.countVowels(text);
      acc += StringUtils.countConsonants(text);
      acc += StringUtils.countCharacters(text, "e");
      if (StringUtils.containsSpecialChars(text)) acc++;
      if (StringUtils.containsOnlyAlphanumeric(text)) acc++;
    }

    // Email validation tests.
    const emailTests = [
      "user@example.com", "invalid.email", "test.email+tag@domain.org", "not-an-email", "user.name@company.co.uk",
    ];
    for (const email of emailTests) if (StringUtils.isValidEmail(email)) acc++;

    // Phone validation tests.
    const phoneTests = ["+1-555-123-4567", "555.123.4567", "(555) 123-4567", "5551234567", "invalid-phone"];
    for (const phone of phoneTests) if (StringUtils.isValidPhone(phone)) acc++;

    // URL validation tests.
    const urlTests = [
      "https://www.example.com", "http://domain.org/path", "ftp://invalid.url",
      "https://api.service.com/v1/data", "not-a-url",
    ];
    for (const url of urlTests) if (StringUtils.isValidUrl(url)) acc++;

    // Text processing operations.
    for (const text of this.sampleTexts) {
      acc += this.stringProcessor.removeExtraSpaces(text).length;
      acc += this.stringProcessor.removePunctuation(text).length;
      acc += this.stringProcessor.removeNumbers(text).length;
      acc += this.stringProcessor.removeSpecialChars(text).length;

      acc += this.stringProcessor.extractNumbers(text).length;
      acc += this.stringProcessor.extractEmails(text).length;
      acc += this.stringProcessor.extractUrls(text).length;
      acc += this.stringProcessor.extractHashtags(`#hashtag ${text} #another`).length;
      acc += this.stringProcessor.extractMentions(`@user ${text} @another`).length;
    }

    // Text transformation operations.
    for (const text of this.sampleTexts) {
      if (text.length > 0) {
        acc += this.stringProcessor.insertCharAt(text, Math.trunc(text.length / 2), "*").length;
        acc += this.stringProcessor.replaceCharAt(text, 0, "X").length;
        acc += (text.length > 1 ? this.stringProcessor.removeCharAt(text, 1) : text).length;
        acc += this.stringProcessor.rotateLeft(text, 3).length;
        acc += this.stringProcessor.rotateRight(text, 3).length;
        if (text.length > 1) {
          acc += this.stringProcessor.swapChars(text, 0, text.length - 1).length;
        }
      }
    }

    // Encoding and decoding operations.
    for (const text of this.sampleTexts) {
      const base64Encoded = this.stringEncoder.encodeBase64Like(text);
      acc += base64Encoded.length;
      acc += this.stringEncoder.decodeBase64Like(base64Encoded).length;

      const urlEncoded = this.stringEncoder.urlEncode(text);
      acc += urlEncoded.length;
      acc += this.stringEncoder.urlDecode(urlEncoded).length;

      const htmlEncoded = this.stringEncoder.htmlEncode(text);
      acc += htmlEncoded.length;
      acc += this.stringEncoder.htmlDecode(htmlEncoded).length;

      const jsonEscaped = this.stringEncoder.jsonEscape(text);
      acc += jsonEscaped.length;
      acc += this.stringEncoder.jsonUnescape(jsonEscaped).length;
    }

    // Text analysis operations.
    for (const text of this.sampleTexts) {
      acc += Math.trunc(this.textAnalyzer.calculateReadabilityScore(text));
      acc += this.textAnalyzer.analyzeSentiment(text).length;
      acc += this.textAnalyzer.detectLanguage(text).length;
      const complexity = this.textAnalyzer.calculateComplexity(text);
      acc += complexity.wordCount + complexity.sentenceCount + complexity.characterCount +
        complexity.characterCountNoSpaces + complexity.longestWord + complexity.shortestWord;
    }
    // String formatting operations.
    const templateVariables = new Map<string, string>();
    templateVariables.set("name", "John Doe");
    templateVariables.set("age", "30");
    templateVariables.set("city", "New York");
    templateVariables.set("occupation", "Developer");

    const templates = [
      "Hello {{name}}, you are {age} years old.",
      "Welcome to ${city}, {name}!",
      "Your occupation is {{occupation}} in {city}.",
    ];
    for (const template of templates) {
      acc += this.stringFormatter.processTemplate(template, templateVariables).length;
    }

    // Number and currency formatting.
    const numbers = [123.456, 789.123, 456.789, 101.101, 999.999];
    for (const number of numbers) {
      acc += this.stringFormatter.formatNumber(number, 2).length;
      acc += this.stringFormatter.formatNumber(number, 4).length;
      acc += this.stringFormatter.formatCurrency(number).length;
      acc += this.stringFormatter.formatPercentage(number / 1000).length;
    }

    // Date formatting.
    const timestamps = [86400000, 3600000, 180000, 86460000, 90061000];
    for (const timestamp of timestamps) {
      acc += this.stringFormatter.formatDate(timestamp).length;
    }

    // Text padding and alignment.
    const shortTexts = ["Short", "Medium text", "Very long text example", "X", "Test string"];
    for (const text of shortTexts) {
      acc += this.stringFormatter.padLeft(text, 20, "-").length;
      acc += this.stringFormatter.padRight(text, 20, "=").length;
      acc += this.stringFormatter.padCenter(text, 25, " ").length;
    }

    // Text wrapping.
    for (const text of this.sampleTexts) {
      acc += this.stringFormatter.wrapText(text, 40).length;
      acc += this.stringFormatter.wrapText(text, 60).length;
      acc += this.stringFormatter.wrapText(text, 80).length;
    }

    // Complex string manipulation chains (Kotlin `let` pipeline).
    for (const text of this.sampleTexts) {
      let r = StringUtils.reverse(text);
      r = this.stringProcessor.removeExtraSpaces(r);
      r = StringUtils.camelCase(r);
      r = this.stringEncoder.urlEncode(r);
      r = this.stringFormatter.padCenter(r, 50, "*");
      r = StringUtils.titleCase(r);
      r = this.stringProcessor.rotateLeft(r, 5);
      r = this.stringEncoder.htmlEncode(r);
      acc += r.length;
    }

    // String comparison and similarity.
    for (let i = 0; i + 1 < this.sampleTexts.length; i++) {
      const text1 = this.sampleTexts[i];
      const text2 = this.sampleTexts[i + 1];
      const set1 = new Set<string>(text1.split(""));
      const set2 = new Set<string>(text2.split(""));
      let common = 0;
      const union = new Set<string>(text1.split(""));
      for (const c of set2) {
        if (set1.has(c)) common++;
        union.add(c);
      }
      const similarity = union.size > 0 ? common / union.size : 0.0;
      acc += Math.trunc(similarity * 100);

      const longerText = text1.length > text2.length ? text1 : text2;
      const shorterText = text1.length <= text2.length ? text1 : text2;
      if (longerText.toLowerCase().includes(shorterText.toLowerCase())) acc++;
    }

    // Performance stress tests with large strings.
    const largeText = this.sampleTexts.join(" ").repeat(100);
    const veryLargeText = largeText.repeat(10);

    const largeCleaned = this.stringProcessor.removeExtraSpaces(veryLargeText);
    acc += largeCleaned.length;
    const largeEncoded = this.stringEncoder.encodeBase64Like(largeText);
    acc += largeEncoded.length;
    const largeAnalyzed = this.textAnalyzer.calculateComplexity(largeText);
    acc += largeAnalyzed.wordCount;
    const largeWrapped = this.stringFormatter.wrapText(veryLargeText, 100);
    acc += largeWrapped.length;

    // Multiple transformations on the same text.
    let transformedText = largeText;
    for (let it = 0; it < 10; it++) {
      transformedText = StringUtils.reverse(transformedText);
      transformedText = this.stringProcessor.removeExtraSpaces(transformedText);
      transformedText = StringUtils.camelCase(transformedText);
      transformedText = this.stringProcessor.rotateLeft(transformedText, it + 1);
    }
    acc += transformedText.length;

    // Advanced pattern matching and replacement (mirrors the Swift pass; the
    // Kotlin `let` chain above already exercises replace, so this keeps the
    // regex-replace paths observably used).
    for (const text of this.sampleTexts) {
      acc += text.replace(/\d+/g, "[NUMBER]").length;
      acc += text.replace(/[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}/g, "[EMAIL]").length;
      acc += text.replace(/https?:\/\/[A-Za-z0-9.-]+\.[A-Za-z]{2,}(\/[^\s]*)?/g, "[URL]").length;
    }

    console.log("String processing benchmark completed:");
    console.log(`- Sample texts: ${this.sampleTexts.length}`);
    console.log(`- Aggregate signal: ${acc}`);
    console.log(`- Large cleaned length: ${largeCleaned.length}`);
    console.log(`- Large encoded length: ${largeEncoded.length}`);
    console.log(`- Transformed length: ${transformedText.length}`);
  }
}

export function runBenchmark(): void {
  const benchmark = new IosSizeBenchmark();
  benchmark.runBenchmark();
}






