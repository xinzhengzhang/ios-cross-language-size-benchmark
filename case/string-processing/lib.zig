// iOS Size Benchmark - Test Case Implementation
// Generated with Claude AI (https://claude.ai)
//
// Zig port of the "string-processing" case (lib.kt / lib.ts are the source of
// truth). Idiomatic Zig has no high-level NSString/String object and no regex
// engine: every operation is manual std.mem + std.ascii work over []const u8,
// building results into std.ArrayList(u8). The Kotlin `object StringUtils` and
// the processor/encoder/analyzer/formatter classes become namespacing structs
// whose methods take an explicit allocator (a per-run arena — ideal for the
// many transient strings this case churns). Kotlin/TS regexes (toRegex, findAll,
// String.replace, JS RegExp) are reimplemented as hand-written scanners and
// matchers, the honest systems-language analogue of a managed regex library. A
// single exported entry (bench_run -> runBenchmark) constructs and uses every
// type and feeds an aggregate to doNotOptimizeAway so nothing is DCE'd.

const std = @import("std");

const WS = " \t\n\r";
const VOWELS = "aeiouAEIOU";
const HEXL = "0123456789abcdef";
const HEXU = "0123456789ABCDEF";

// ---- small stdlib-equivalent helpers (no closures: plain loops) ----
fn lowerDup(a: std.mem.Allocator, s: []const u8) ![]u8 {
    const out = try a.alloc(u8, s.len);
    for (s, 0..) |c, i| out[i] = std.ascii.toLower(c);
    return out;
}

fn reverseDup(a: std.mem.Allocator, s: []const u8) ![]u8 {
    const out = try a.dupe(u8, s);
    std.mem.reverse(u8, out);
    return out;
}

// Lowercase a word, then uppercase its first byte (Kotlin's
// `word.lowercase().replaceFirstChar { it.uppercase() }`).
fn capitalizeWord(a: std.mem.Allocator, word: []const u8) ![]u8 {
    const out = try lowerDup(a, word);
    if (out.len > 0) out[0] = std.ascii.toUpper(out[0]);
    return out;
}

// splitAny on any delimiter byte, dropping empty tokens (`.filter { it.isNotEmpty() }`).
fn splitNonEmpty(a: std.mem.Allocator, text: []const u8, delims: []const u8) ![]const []const u8 {
    var list: std.ArrayList([]const u8) = .empty;
    var it = std.mem.splitAny(u8, text, delims);
    while (it.next()) |part| if (part.len > 0) try list.append(a, part);
    return list.toOwnedSlice(a);
}

// Kotlin String.replace(old, new) replaces every occurrence; std.mem.replace
// does the same, so this is the literal split/join analogue.
fn replaceAll(a: std.mem.Allocator, input: []const u8, needle: []const u8, repl: []const u8) ![]u8 {
    if (needle.len == 0) return a.dupe(u8, input);
    const size = std.mem.replacementSize(u8, input, needle, repl);
    const out = try a.alloc(u8, size);
    _ = std.mem.replace(u8, input, needle, repl, out);
    return out;
}

fn pad2(a: std.mem.Allocator, s: []const u8) ![]u8 {
    if (s.len >= 2) return a.dupe(u8, s);
    var buf: std.ArrayList(u8) = .empty;
    var k: usize = 0;
    while (k < 2 - s.len) : (k += 1) try buf.append(a, '0');
    try buf.appendSlice(a, s);
    return buf.toOwnedSlice(a);
}

fn isWordChar(c: u8) bool {
    return std.ascii.isAlphanumeric(c) or c == '_';
}
fn isEmailLocal(c: u8) bool {
    return std.ascii.isAlphanumeric(c) or c == '+' or c == '_' or c == '.' or c == '-';
}
fn isDomainChar(c: u8) bool {
    return std.ascii.isAlphanumeric(c) or c == '.' or c == '-';
}

// Longest email match starting at `start` (findAll analogue for
// `[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}`), 0 if none.
fn matchEmailAt(s: []const u8, start: usize) usize {
    var i = start;
    while (i < s.len and isEmailLocal(s[i])) i += 1;
    if (i == start) return 0;
    if (i >= s.len or s[i] != '@') return 0;
    i += 1;
    const domStart = i;
    while (i < s.len and isDomainChar(s[i])) i += 1;
    var e = i;
    while (e > domStart) : (e -= 1) {
        if (std.mem.lastIndexOfScalar(u8, s[domStart..e], '.')) |d| {
            const dotAbs = domStart + d;
            const tld = s[dotAbs + 1 .. e];
            if (dotAbs > domStart and tld.len >= 2 and allLetters(tld)) return e - start;
        }
    }
    return 0;
}

// Longest URL match (`https?://[A-Za-z0-9.-]+\.[A-Za-z]{2,}(/[^\s]*)?`), 0 if none.
fn matchUrlAt(s: []const u8, start: usize) usize {
    var i: usize = undefined;
    if (std.mem.startsWith(u8, s[start..], "https://")) i = start + 8 else if (std.mem.startsWith(u8, s[start..], "http://")) i = start + 7 else return 0;
    const hostStart = i;
    while (i < s.len and isDomainChar(s[i])) i += 1;
    var e = i;
    var hostEnd: usize = 0;
    while (e > hostStart) : (e -= 1) {
        if (std.mem.lastIndexOfScalar(u8, s[hostStart..e], '.')) |d| {
            const dotAbs = hostStart + d;
            const tld = s[dotAbs + 1 .. e];
            if (dotAbs > hostStart and tld.len >= 2 and allLetters(tld)) {
                hostEnd = e;
                break;
            }
        }
    }
    if (hostEnd == 0) return 0;
    var pe = hostEnd;
    if (pe < s.len and s[pe] == '/') {
        pe += 1;
        while (pe < s.len and !std.ascii.isWhitespace(s[pe])) pe += 1;
    }
    return pe - start;
}

fn allLetters(s: []const u8) bool {
    for (s) |c| if (!std.ascii.isAlphabetic(c)) return false;
    return true;
}

// Kotlin `object StringUtils` -> a namespacing struct of static-style methods.
const StringUtils = struct {
    fn reverse(a: std.mem.Allocator, text: []const u8) ![]u8 {
        return reverseDup(a, text);
    }

    fn capitalize(a: std.mem.Allocator, text: []const u8) ![]u8 {
        const out = try a.dupe(u8, text);
        if (out.len > 0 and std.ascii.isLower(out[0])) out[0] = std.ascii.toUpper(out[0]);
        return out;
    }

    fn camelCase(a: std.mem.Allocator, text: []const u8) ![]u8 {
        const words = try splitNonEmpty(a, text, " _-");
        var buf: std.ArrayList(u8) = .empty;
        for (words, 0..) |w, i| {
            if (i == 0) try buf.appendSlice(a, try lowerDup(a, w)) else try buf.appendSlice(a, try capitalizeWord(a, w));
        }
        return buf.toOwnedSlice(a);
    }

    fn snakeCase(a: std.mem.Allocator, text: []const u8) ![]u8 {
        const words = try splitNonEmpty(a, text, " -");
        var buf: std.ArrayList(u8) = .empty;
        for (words, 0..) |w, i| {
            if (i > 0) try buf.append(a, '_');
            try buf.appendSlice(a, try lowerDup(a, w));
        }
        return buf.toOwnedSlice(a);
    }

    fn kebabCase(a: std.mem.Allocator, text: []const u8) ![]u8 {
        const words = try splitNonEmpty(a, text, " _");
        var buf: std.ArrayList(u8) = .empty;
        for (words, 0..) |w, i| {
            if (i > 0) try buf.append(a, '-');
            try buf.appendSlice(a, try lowerDup(a, w));
        }
        return buf.toOwnedSlice(a);
    }

    fn titleCase(a: std.mem.Allocator, text: []const u8) ![]u8 {
        const words = try splitNonEmpty(a, text, " ");
        var buf: std.ArrayList(u8) = .empty;
        for (words, 0..) |w, i| {
            if (i > 0) try buf.append(a, ' ');
            try buf.appendSlice(a, try capitalizeWord(a, w));
        }
        return buf.toOwnedSlice(a);
    }

    fn isValidEmail(email: []const u8) bool {
        const at = std.mem.indexOfScalar(u8, email, '@') orelse return false;
        if (std.mem.lastIndexOfScalar(u8, email, '@').? != at or at == 0) return false;
        for (email[0..at]) |c| if (!isEmailLocal(c)) return false;
        const dom = email[at + 1 ..];
        if (dom.len == 0) return false;
        for (dom) |c| if (!isDomainChar(c)) return false;
        const dot = std.mem.lastIndexOfScalar(u8, dom, '.') orelse return false;
        if (dot == 0) return false;
        const tld = dom[dot + 1 ..];
        return tld.len >= 2 and allLetters(tld);
    }

    fn isValidPhone(phone: []const u8) bool {
        var n: usize = 0;
        for (phone) |c| if (std.ascii.isDigit(c)) {
            n += 1;
        };
        return n >= 10 and n <= 15;
    }

    fn isValidUrl(url: []const u8) bool {
        var rest: []const u8 = undefined;
        if (std.mem.startsWith(u8, url, "https://")) rest = url[8..] else if (std.mem.startsWith(u8, url, "http://")) rest = url[7..] else return false;
        const host = if (std.mem.indexOfScalar(u8, rest, '/')) |p| rest[0..p] else rest;
        if (host.len == 0) return false;
        for (host) |c| if (!isDomainChar(c)) return false;
        const dot = std.mem.lastIndexOfScalar(u8, host, '.') orelse return false;
        if (dot == 0) return false;
        const tld = host[dot + 1 ..];
        return tld.len >= 2 and allLetters(tld);
    }

    fn containsOnlyAlphanumeric(text: []const u8) bool {
        for (text) |c| if (!std.ascii.isAlphanumeric(c)) return false;
        return true;
    }

    fn containsSpecialChars(text: []const u8) bool {
        for (text) |c| if (!std.ascii.isAlphanumeric(c) and !std.ascii.isWhitespace(c)) return true;
        return false;
    }

    fn countWords(text: []const u8) i64 {
        var it = std.mem.splitAny(u8, text, WS);
        var n: i64 = 0;
        while (it.next()) |p| if (p.len > 0) {
            n += 1;
        };
        return n;
    }

    fn countCharacters(text: []const u8, ch: u8) i64 {
        var n: i64 = 0;
        for (text) |c| if (c == ch) {
            n += 1;
        };
        return n;
    }

    fn countVowels(text: []const u8) i64 {
        var n: i64 = 0;
        for (text) |c| if (std.mem.indexOfScalar(u8, "aeiou", std.ascii.toLower(c)) != null) {
            n += 1;
        };
        return n;
    }

    fn countConsonants(text: []const u8) i64 {
        var n: i64 = 0;
        for (text) |c| {
            const l = std.ascii.toLower(c);
            if (std.ascii.isAlphabetic(l) and std.mem.indexOfScalar(u8, "aeiou", l) == null) n += 1;
        }
        return n;
    }
};

// Advanced string processors (Kotlin `class StringProcessor`).
const StringProcessor = struct {
    // `\s+` -> " " then trim: collapse whitespace runs, drop leading/trailing.
    fn removeExtraSpaces(a: std.mem.Allocator, text: []const u8) ![]u8 {
        var buf: std.ArrayList(u8) = .empty;
        var pendingSpace = false;
        for (text) |c| {
            if (std.ascii.isWhitespace(c)) {
                pendingSpace = true;
            } else {
                if (pendingSpace and buf.items.len > 0) try buf.append(a, ' ');
                pendingSpace = false;
                try buf.append(a, c);
            }
        }
        return buf.toOwnedSlice(a);
    }

    fn removePunctuation(a: std.mem.Allocator, text: []const u8) ![]u8 { // [^\w\s] removed
        var buf: std.ArrayList(u8) = .empty;
        for (text) |c| if (isWordChar(c) or std.ascii.isWhitespace(c)) try buf.append(a, c);
        return buf.toOwnedSlice(a);
    }

    fn removeNumbers(a: std.mem.Allocator, text: []const u8) ![]u8 {
        var buf: std.ArrayList(u8) = .empty;
        for (text) |c| if (!std.ascii.isDigit(c)) try buf.append(a, c);
        return buf.toOwnedSlice(a);
    }

    fn removeSpecialChars(a: std.mem.Allocator, text: []const u8) ![]u8 { // keep alnum + whitespace
        var buf: std.ArrayList(u8) = .empty;
        for (text) |c| if (std.ascii.isAlphanumeric(c) or std.ascii.isWhitespace(c)) try buf.append(a, c);
        return buf.toOwnedSlice(a);
    }

    fn extractNumbers(a: std.mem.Allocator, text: []const u8) ![]const []const u8 {
        var list: std.ArrayList([]const u8) = .empty;
        var i: usize = 0;
        while (i < text.len) {
            if (std.ascii.isDigit(text[i])) {
                const start = i;
                while (i < text.len and std.ascii.isDigit(text[i])) i += 1;
                try list.append(a, text[start..i]);
            } else i += 1;
        }
        return list.toOwnedSlice(a);
    }

    // `#\w+` / `@\w+` findAll.
    fn extractAfter(a: std.mem.Allocator, text: []const u8, marker: u8) ![]const []const u8 {
        var list: std.ArrayList([]const u8) = .empty;
        var i: usize = 0;
        while (i < text.len) {
            if (text[i] == marker and i + 1 < text.len and isWordChar(text[i + 1])) {
                const start = i;
                i += 1;
                while (i < text.len and isWordChar(text[i])) i += 1;
                try list.append(a, text[start..i]);
            } else i += 1;
        }
        return list.toOwnedSlice(a);
    }

    fn extractMatches(a: std.mem.Allocator, text: []const u8, comptime matchFn: fn ([]const u8, usize) usize) ![]const []const u8 {
        var list: std.ArrayList([]const u8) = .empty;
        var i: usize = 0;
        while (i < text.len) {
            const mlen = matchFn(text, i);
            if (mlen > 0) {
                try list.append(a, text[i .. i + mlen]);
                i += mlen;
            } else i += 1;
        }
        return list.toOwnedSlice(a);
    }

    fn insertCharAt(a: std.mem.Allocator, text: []const u8, index: usize, ch: u8) ![]u8 {
        var buf: std.ArrayList(u8) = .empty;
        try buf.appendSlice(a, text[0..index]);
        try buf.append(a, ch);
        try buf.appendSlice(a, text[index..]);
        return buf.toOwnedSlice(a);
    }

    fn replaceCharAt(a: std.mem.Allocator, text: []const u8, index: usize, ch: u8) ![]u8 {
        var buf: std.ArrayList(u8) = .empty;
        try buf.appendSlice(a, text[0..index]);
        try buf.append(a, ch);
        try buf.appendSlice(a, text[index + 1 ..]);
        return buf.toOwnedSlice(a);
    }

    fn removeCharAt(a: std.mem.Allocator, text: []const u8, index: usize) ![]u8 {
        var buf: std.ArrayList(u8) = .empty;
        try buf.appendSlice(a, text[0..index]);
        try buf.appendSlice(a, text[index + 1 ..]);
        return buf.toOwnedSlice(a);
    }

    fn swapChars(a: std.mem.Allocator, text: []const u8, ia: usize, ib: usize) ![]u8 {
        const out = try a.dupe(u8, text);
        const tmp = out[ia];
        out[ia] = out[ib];
        out[ib] = tmp;
        return out;
    }

    fn rotateLeft(a: std.mem.Allocator, text: []const u8, positions: usize) ![]u8 {
        if (text.len == 0) return a.dupe(u8, text);
        const pos = positions % text.len;
        var buf: std.ArrayList(u8) = .empty;
        try buf.appendSlice(a, text[pos..]);
        try buf.appendSlice(a, text[0..pos]);
        return buf.toOwnedSlice(a);
    }

    fn rotateRight(a: std.mem.Allocator, text: []const u8, positions: usize) ![]u8 {
        if (text.len == 0) return a.dupe(u8, text);
        const pos = positions % text.len;
        var buf: std.ArrayList(u8) = .empty;
        try buf.appendSlice(a, text[text.len - pos ..]);
        try buf.appendSlice(a, text[0 .. text.len - pos]);
        return buf.toOwnedSlice(a);
    }
};

// String encoding and formatting (Kotlin `class StringEncoder`). Zig strings
// are already UTF-8 bytes, so Kotlin's encodeToByteArray() is a no-op: we hex
// the raw bytes directly.
const StringEncoder = struct {
    fn encodeBase64Like(a: std.mem.Allocator, text: []const u8) ![]u8 {
        const out = try a.alloc(u8, text.len * 2);
        for (text, 0..) |byte, i| {
            out[i * 2] = HEXL[byte >> 4];
            out[i * 2 + 1] = HEXL[byte & 0x0f];
        }
        return out;
    }

    fn decodeBase64Like(a: std.mem.Allocator, encoded: []const u8) ![]u8 {
        var buf: std.ArrayList(u8) = .empty;
        var i: usize = 0;
        while (i + 2 <= encoded.len) : (i += 2) {
            const b = std.fmt.parseInt(u8, encoded[i .. i + 2], 16) catch 0;
            try buf.append(a, b);
        }
        return buf.toOwnedSlice(a);
    }

    fn urlEncode(a: std.mem.Allocator, text: []const u8) ![]u8 {
        var buf: std.ArrayList(u8) = .empty;
        for (text) |c| {
            if (std.ascii.isAlphanumeric(c)) {
                try buf.append(a, c);
            } else if (c == ' ') {
                try buf.appendSlice(a, "%20");
            } else if (c == '&') {
                try buf.appendSlice(a, "%26");
            } else if (c == '=') {
                try buf.appendSlice(a, "%3D");
            } else if (c == '?') {
                try buf.appendSlice(a, "%3F");
            } else {
                try buf.append(a, '%');
                try buf.append(a, HEXU[c >> 4]);
                try buf.append(a, HEXU[c & 0x0f]);
            }
        }
        return buf.toOwnedSlice(a);
    }

    fn urlDecode(a: std.mem.Allocator, encoded: []const u8) ![]u8 {
        var r = try replaceAll(a, encoded, "%20", " ");
        r = try replaceAll(a, r, "%26", "&");
        r = try replaceAll(a, r, "%3D", "=");
        r = try replaceAll(a, r, "%3F", "?");
        return r;
    }

    fn htmlEncode(a: std.mem.Allocator, text: []const u8) ![]u8 {
        var r = try replaceAll(a, text, "&", "&amp;");
        r = try replaceAll(a, r, "<", "&lt;");
        r = try replaceAll(a, r, ">", "&gt;");
        r = try replaceAll(a, r, "\"", "&quot;");
        r = try replaceAll(a, r, "'", "&#39;");
        return r;
    }

    fn htmlDecode(a: std.mem.Allocator, encoded: []const u8) ![]u8 {
        var r = try replaceAll(a, encoded, "&amp;", "&");
        r = try replaceAll(a, r, "&lt;", "<");
        r = try replaceAll(a, r, "&gt;", ">");
        r = try replaceAll(a, r, "&quot;", "\"");
        r = try replaceAll(a, r, "&#39;", "'");
        return r;
    }

    fn jsonEscape(a: std.mem.Allocator, text: []const u8) ![]u8 {
        var r = try replaceAll(a, text, "\\", "\\\\");
        r = try replaceAll(a, r, "\"", "\\\"");
        r = try replaceAll(a, r, "\n", "\\n");
        r = try replaceAll(a, r, "\r", "\\r");
        r = try replaceAll(a, r, "\t", "\\t");
        return r;
    }

    fn jsonUnescape(a: std.mem.Allocator, escaped: []const u8) ![]u8 {
        var r = try replaceAll(a, escaped, "\\\\", "\\");
        r = try replaceAll(a, r, "\\\"", "\"");
        r = try replaceAll(a, r, "\\n", "\n");
        r = try replaceAll(a, r, "\\r", "\r");
        r = try replaceAll(a, r, "\\t", "\t");
        return r;
    }
};

// Kotlin's calculateComplexity returns Map<String, Any>; Zig has no heterogeneous
// map, so the identical metrics are returned via a typed struct.
const TextComplexity = struct {
    wordCount: i64,
    sentenceCount: i64,
    characterCount: i64,
    characterCountNoSpaces: i64,
    averageWordsPerSentence: f64,
    averageCharactersPerWord: f64,
    longestWord: i64,
    shortestWord: i64,
};

fn inWordSet(word: []const u8, set: []const []const u8) bool {
    for (set) |w| if (std.mem.eql(u8, w, word)) return true;
    return false;
}

// `[.!?]+` split: splitAny then keep trimmed-non-empty tokens (consecutive
// punctuation yields empties that filter out, matching the `+` quantifier).
fn countSentences(text: []const u8) i64 {
    var it = std.mem.splitAny(u8, text, ".!?");
    var n: i64 = 0;
    while (it.next()) |p| if (std.mem.trim(u8, p, WS).len > 0) {
        n += 1;
    };
    return n;
}

// Text analysis and metrics (Kotlin `class TextAnalyzer`).
const TextAnalyzer = struct {
    fn countSyllables(word: []const u8) i64 {
        var count: i64 = 0;
        var prevVowel = false;
        for (word) |c| {
            const v = std.mem.indexOfScalar(u8, VOWELS, c) != null;
            if (v and !prevVowel) count += 1;
            prevVowel = v;
        }
        if (word.len > 0 and std.ascii.toLower(word[word.len - 1]) == 'e' and count > 1) count -= 1;
        return @max(1, count);
    }

    fn calculateReadabilityScore(a: std.mem.Allocator, text: []const u8) !f64 {
        const sentences = countSentences(text);
        const words = try splitNonEmpty(a, text, WS);
        var syllables: i64 = 0;
        for (words) |w| syllables += countSyllables(w);
        if (sentences == 0 or words.len == 0) return 0.0;
        const awps = @as(f64, @floatFromInt(words.len)) / @as(f64, @floatFromInt(sentences));
        const aspw = @as(f64, @floatFromInt(syllables)) / @as(f64, @floatFromInt(words.len));
        return 206.835 - 1.015 * awps - 84.6 * aspw;
    }

    fn analyzeSentiment(a: std.mem.Allocator, text: []const u8) ![]const u8 {
        const positive = [_][]const u8{ "good", "great", "excellent", "amazing", "wonderful", "fantastic", "love", "like", "happy", "joy" };
        const negative = [_][]const u8{ "bad", "terrible", "awful", "horrible", "hate", "dislike", "sad", "angry", "disappointed", "frustrated" };
        const lower = try lowerDup(a, text);
        var it = std.mem.splitAny(u8, lower, WS);
        var pos: i64 = 0;
        var neg: i64 = 0;
        while (it.next()) |w| {
            if (inWordSet(w, &positive)) pos += 1;
            if (inWordSet(w, &negative)) neg += 1;
        }
        if (pos > neg) return "Positive";
        if (neg > pos) return "Negative";
        return "Neutral";
    }

    fn detectLanguage(a: std.mem.Allocator, text: []const u8) ![]const u8 {
        const english = [_][]const u8{ "the", "and", "is", "in", "to", "of", "a", "that", "it", "with" };
        const spanish = [_][]const u8{ "el", "la", "de", "que", "y", "a", "en", "un", "es", "se" };
        const french = [_][]const u8{ "le", "de", "et", "à", "un", "il", "être", "et", "en", "avoir" };
        const lower = try lowerDup(a, text);
        var it = std.mem.splitAny(u8, lower, WS);
        var e: i64 = 0;
        var s: i64 = 0;
        var f: i64 = 0;
        while (it.next()) |w| {
            if (inWordSet(w, &english)) e += 1;
            if (inWordSet(w, &spanish)) s += 1;
            if (inWordSet(w, &french)) f += 1;
        }
        const max = @max(e, @max(s, f));
        if (max == e) return "English";
        if (max == s) return "Spanish";
        if (max == f) return "French";
        return "Unknown";
    }

    fn calculateComplexity(a: std.mem.Allocator, text: []const u8) !TextComplexity {
        const words = try splitNonEmpty(a, text, WS);
        const sentences = countSentences(text);
        var noSpaces: i64 = 0;
        for (text) |c| if (!std.ascii.isWhitespace(c)) {
            noSpaces += 1;
        };
        var longest: i64 = 0;
        var shortest: i64 = if (words.len > 0) @intCast(words[0].len) else 0;
        for (words) |w| {
            const l: i64 = @intCast(w.len);
            if (l > longest) longest = l;
            if (l < shortest) shortest = l;
        }
        return .{
            .wordCount = @intCast(words.len),
            .sentenceCount = sentences,
            .characterCount = @intCast(text.len),
            .characterCountNoSpaces = noSpaces,
            .averageWordsPerSentence = if (sentences > 0) @as(f64, @floatFromInt(words.len)) / @as(f64, @floatFromInt(sentences)) else 0.0,
            .averageCharactersPerWord = if (words.len > 0) @as(f64, @floatFromInt(noSpaces)) / @as(f64, @floatFromInt(words.len)) else 0.0,
            .longestWord = if (words.len > 0) longest else 0,
            .shortestWord = if (words.len > 0) shortest else 0,
        };
    }
};

// String formatting and templates (Kotlin `class StringFormatter`). The TS/Kotlin
// `Map<String,String>` of template variables is passed as parallel key/value
// slices (no closures / no forEach needed).
const StringFormatter = struct {
    fn processTemplate(a: std.mem.Allocator, template: []const u8, keys: []const []const u8, values: []const []const u8) ![]u8 {
        var r = try a.dupe(u8, template);
        for (keys, values) |k, v| {
            // Literal braces are doubled in Zig format strings: this yields
            // "{{key}}", "{key}", "${key}" respectively.
            r = try replaceAll(a, r, try std.fmt.allocPrint(a, "{{{{{s}}}}}", .{k}), v);
            r = try replaceAll(a, r, try std.fmt.allocPrint(a, "{{{s}}}", .{k}), v);
            r = try replaceAll(a, r, try std.fmt.allocPrint(a, "${{{s}}}", .{k}), v);
        }
        return r;
    }

    // Kotlin: factor = 10^decimals (Long); rounded = (num*factor).toLong()/factor.
    fn formatNumber(a: std.mem.Allocator, num: f64, decimals: u6) ![]u8 {
        const factor = std.math.pow(f64, 10.0, @floatFromInt(decimals));
        const rounded = @as(f64, @floatFromInt(@as(i64, @intFromFloat(num * factor)))) / factor;
        return std.fmt.allocPrint(a, "{d}", .{rounded});
    }

    fn formatCurrency(a: std.mem.Allocator, amount: f64, currency: []const u8) ![]u8 {
        const formatted = @as(f64, @floatFromInt(@as(i64, @intFromFloat(amount * 100.0)))) / 100.0;
        return std.fmt.allocPrint(a, "{s} {d}", .{ currency, formatted });
    }

    fn formatPercentage(a: std.mem.Allocator, value: f64) ![]u8 {
        const percentage = @as(f64, @floatFromInt(@as(i64, @intFromFloat(value * 1000.0)))) / 10.0;
        return std.fmt.allocPrint(a, "{d}%", .{percentage});
    }

    fn formatDate(a: std.mem.Allocator, timestamp: i64) ![]u8 {
        const days = @divTrunc(timestamp, 24 * 60 * 60 * 1000);
        const hours = @divTrunc(@mod(timestamp, 24 * 60 * 60 * 1000), 60 * 60 * 1000);
        const minutes = @divTrunc(@mod(timestamp, 60 * 60 * 1000), 60 * 1000);
        const d = try pad2(a, try std.fmt.allocPrint(a, "{d}", .{days}));
        const h = try pad2(a, try std.fmt.allocPrint(a, "{d}", .{hours}));
        const m = try pad2(a, try std.fmt.allocPrint(a, "{d}", .{minutes}));
        return std.fmt.allocPrint(a, "{s}:{s}:{s}", .{ d, h, m });
    }

    fn padLeft(a: std.mem.Allocator, text: []const u8, length: usize, ch: u8) ![]u8 {
        if (text.len >= length) return a.dupe(u8, text);
        var buf: std.ArrayList(u8) = .empty;
        var k: usize = 0;
        while (k < length - text.len) : (k += 1) try buf.append(a, ch);
        try buf.appendSlice(a, text);
        return buf.toOwnedSlice(a);
    }

    fn padRight(a: std.mem.Allocator, text: []const u8, length: usize, ch: u8) ![]u8 {
        if (text.len >= length) return a.dupe(u8, text);
        var buf: std.ArrayList(u8) = .empty;
        try buf.appendSlice(a, text);
        var k: usize = 0;
        while (k < length - text.len) : (k += 1) try buf.append(a, ch);
        return buf.toOwnedSlice(a);
    }

    fn padCenter(a: std.mem.Allocator, text: []const u8, length: usize, ch: u8) ![]u8 {
        if (text.len >= length) return a.dupe(u8, text);
        const total = length - text.len;
        const left = total / 2;
        const right = total - left;
        var buf: std.ArrayList(u8) = .empty;
        var k: usize = 0;
        while (k < left) : (k += 1) try buf.append(a, ch);
        try buf.appendSlice(a, text);
        k = 0;
        while (k < right) : (k += 1) try buf.append(a, ch);
        return buf.toOwnedSlice(a);
    }

    fn wrapText(a: std.mem.Allocator, text: []const u8, maxLineLength: usize) ![]const []const u8 {
        var lines: std.ArrayList([]const u8) = .empty;
        var curr: std.ArrayList(u8) = .empty;
        var it = std.mem.splitScalar(u8, text, ' ');
        while (it.next()) |word| {
            if (curr.items.len == 0) {
                try curr.appendSlice(a, word);
            } else if (curr.items.len + word.len + 1 <= maxLineLength) {
                try curr.append(a, ' ');
                try curr.appendSlice(a, word);
            } else {
                try lines.append(a, try curr.toOwnedSlice(a));
                curr = .empty;
                try curr.appendSlice(a, word);
            }
        }
        if (curr.items.len > 0) try lines.append(a, try curr.toOwnedSlice(a));
        return lines.toOwnedSlice(a);
    }
};

// Regex-replace analogues used by the "advanced pattern" pass. `\d+` collapses
// digit runs; the matcher-driven variant replaces every email/URL match.
fn replaceDigitRuns(a: std.mem.Allocator, text: []const u8, repl: []const u8) ![]u8 {
    var buf: std.ArrayList(u8) = .empty;
    var i: usize = 0;
    while (i < text.len) {
        if (std.ascii.isDigit(text[i])) {
            while (i < text.len and std.ascii.isDigit(text[i])) i += 1;
            try buf.appendSlice(a, repl);
        } else {
            try buf.append(a, text[i]);
            i += 1;
        }
    }
    return buf.toOwnedSlice(a);
}

fn replaceMatches(a: std.mem.Allocator, text: []const u8, repl: []const u8, comptime matchFn: fn ([]const u8, usize) usize) ![]u8 {
    var buf: std.ArrayList(u8) = .empty;
    var i: usize = 0;
    while (i < text.len) {
        const mlen = matchFn(text, i);
        if (mlen > 0) {
            try buf.appendSlice(a, repl);
            i += mlen;
        } else {
            try buf.append(a, text[i]);
            i += 1;
        }
    }
    return buf.toOwnedSlice(a);
}

fn len(s: []const u8) i64 {
    return @intCast(s.len);
}

// Mirrors Kotlin's IosSizeBenchmark.runBenchmark: constructs and uses every type
// and folds a single aggregate so the whole graph stays live.
fn doTheWork(a: std.mem.Allocator) !void {
    const samples = [_][]const u8{
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
    };

    var acc: i64 = 0;

    // Basic string operations.
    for (samples) |text| {
        acc += len(try StringUtils.reverse(a, text));
        acc += len(try StringUtils.capitalize(a, text));
        acc += len(try StringUtils.camelCase(a, text));
        acc += len(try StringUtils.snakeCase(a, text));
        acc += len(try StringUtils.kebabCase(a, text));
        acc += len(try StringUtils.titleCase(a, text));
        acc += StringUtils.countWords(text);
        acc += StringUtils.countVowels(text);
        acc += StringUtils.countConsonants(text);
        acc += StringUtils.countCharacters(text, 'e');
        if (StringUtils.containsSpecialChars(text)) acc += 1;
        if (StringUtils.containsOnlyAlphanumeric(text)) acc += 1;
    }

    // Validation tests.
    const emailTests = [_][]const u8{ "user@example.com", "invalid.email", "test.email+tag@domain.org", "not-an-email", "user.name@company.co.uk" };
    for (emailTests) |e| if (StringUtils.isValidEmail(e)) {
        acc += 1;
    };
    const phoneTests = [_][]const u8{ "+1-555-123-4567", "555.123.4567", "(555) 123-4567", "5551234567", "invalid-phone" };
    for (phoneTests) |p| if (StringUtils.isValidPhone(p)) {
        acc += 1;
    };
    const urlTests = [_][]const u8{ "https://www.example.com", "http://domain.org/path", "ftp://invalid.url", "https://api.service.com/v1/data", "not-a-url" };
    for (urlTests) |u| if (StringUtils.isValidUrl(u)) {
        acc += 1;
    };

    // Text processing operations.
    for (samples) |text| {
        acc += len(try StringProcessor.removeExtraSpaces(a, text));
        acc += len(try StringProcessor.removePunctuation(a, text));
        acc += len(try StringProcessor.removeNumbers(a, text));
        acc += len(try StringProcessor.removeSpecialChars(a, text));
        acc += @intCast((try StringProcessor.extractNumbers(a, text)).len);
        acc += @intCast((try StringProcessor.extractMatches(a, text, matchEmailAt)).len);
        acc += @intCast((try StringProcessor.extractMatches(a, text, matchUrlAt)).len);
        acc += @intCast((try StringProcessor.extractAfter(a, try std.fmt.allocPrint(a, "#hashtag {s} #another", .{text}), '#')).len);
        acc += @intCast((try StringProcessor.extractAfter(a, try std.fmt.allocPrint(a, "@user {s} @another", .{text}), '@')).len);
    }

    // Text transformation operations.
    for (samples) |text| {
        if (text.len > 0) {
            acc += len(try StringProcessor.insertCharAt(a, text, text.len / 2, '*'));
            acc += len(try StringProcessor.replaceCharAt(a, text, 0, 'X'));
            acc += len(if (text.len > 1) try StringProcessor.removeCharAt(a, text, 1) else text);
            acc += len(try StringProcessor.rotateLeft(a, text, 3));
            acc += len(try StringProcessor.rotateRight(a, text, 3));
            if (text.len > 1) acc += len(try StringProcessor.swapChars(a, text, 0, text.len - 1));
        }
    }

    // Encoding and decoding operations.
    for (samples) |text| {
        const b64 = try StringEncoder.encodeBase64Like(a, text);
        acc += len(b64);
        acc += len(try StringEncoder.decodeBase64Like(a, b64));
        const urlE = try StringEncoder.urlEncode(a, text);
        acc += len(urlE);
        acc += len(try StringEncoder.urlDecode(a, urlE));
        const htmlE = try StringEncoder.htmlEncode(a, text);
        acc += len(htmlE);
        acc += len(try StringEncoder.htmlDecode(a, htmlE));
        const jsonE = try StringEncoder.jsonEscape(a, text);
        acc += len(jsonE);
        acc += len(try StringEncoder.jsonUnescape(a, jsonE));
    }

    // Text analysis operations.
    for (samples) |text| {
        acc += @intFromFloat(@trunc(try TextAnalyzer.calculateReadabilityScore(a, text)));
        acc += len(try TextAnalyzer.analyzeSentiment(a, text));
        acc += len(try TextAnalyzer.detectLanguage(a, text));
        const cx = try TextAnalyzer.calculateComplexity(a, text);
        acc += cx.wordCount + cx.sentenceCount + cx.characterCount + cx.characterCountNoSpaces + cx.longestWord + cx.shortestWord;
    }

    // String formatting operations.
    const keys = [_][]const u8{ "name", "age", "city", "occupation" };
    const vals = [_][]const u8{ "John Doe", "30", "New York", "Developer" };
    const templates = [_][]const u8{
        "Hello {{name}}, you are {age} years old.",
        "Welcome to ${city}, {name}!",
        "Your occupation is {{occupation}} in {city}.",
    };
    for (templates) |t| acc += len(try StringFormatter.processTemplate(a, t, &keys, &vals));

    const numbers = [_]f64{ 123.456, 789.123, 456.789, 101.101, 999.999 };
    for (numbers) |n| {
        acc += len(try StringFormatter.formatNumber(a, n, 2));
        acc += len(try StringFormatter.formatNumber(a, n, 4));
        acc += len(try StringFormatter.formatCurrency(a, n, "USD"));
        acc += len(try StringFormatter.formatPercentage(a, n / 1000.0));
    }

    const timestamps = [_]i64{ 86400000, 3600000, 180000, 86460000, 90061000 };
    for (timestamps) |ts| acc += len(try StringFormatter.formatDate(a, ts));

    const shortTexts = [_][]const u8{ "Short", "Medium text", "Very long text example", "X", "Test string" };
    for (shortTexts) |text| {
        acc += len(try StringFormatter.padLeft(a, text, 20, '-'));
        acc += len(try StringFormatter.padRight(a, text, 20, '='));
        acc += len(try StringFormatter.padCenter(a, text, 25, ' '));
    }

    for (samples) |text| {
        acc += @intCast((try StringFormatter.wrapText(a, text, 40)).len);
        acc += @intCast((try StringFormatter.wrapText(a, text, 60)).len);
        acc += @intCast((try StringFormatter.wrapText(a, text, 80)).len);
    }

    // Complex string manipulation chains (Kotlin `let` pipeline).
    for (samples) |text| {
        var r = try StringUtils.reverse(a, text);
        r = try StringProcessor.removeExtraSpaces(a, r);
        r = try StringUtils.camelCase(a, r);
        r = try StringEncoder.urlEncode(a, r);
        r = try StringFormatter.padCenter(a, r, 50, '*');
        r = try StringUtils.titleCase(a, r);
        r = try StringProcessor.rotateLeft(a, r, 5);
        r = try StringEncoder.htmlEncode(a, r);
        acc += len(r);
    }

    // String comparison and similarity (char-set Jaccard, per byte).
    var i: usize = 0;
    while (i + 1 < samples.len) : (i += 1) {
        const t1 = samples[i];
        const t2 = samples[i + 1];
        var set1 = std.mem.zeroes([256]bool);
        var set2 = std.mem.zeroes([256]bool);
        for (t1) |c| set1[c] = true;
        for (t2) |c| set2[c] = true;
        var common: i64 = 0;
        var uni: i64 = 0;
        var ci: usize = 0;
        while (ci < 256) : (ci += 1) {
            if (set1[ci] and set2[ci]) common += 1;
            if (set1[ci] or set2[ci]) uni += 1;
        }
        const similarity = if (uni > 0) @as(f64, @floatFromInt(common)) / @as(f64, @floatFromInt(uni)) else 0.0;
        acc += @intFromFloat(@trunc(similarity * 100.0));
        const longer = if (t1.len > t2.len) t1 else t2;
        const shorter = if (t1.len <= t2.len) t1 else t2;
        if (std.mem.indexOf(u8, try lowerDup(a, longer), try lowerDup(a, shorter)) != null) acc += 1;
    }

    // Performance stress tests with large strings.
    const joined = try std.mem.join(a, " ", &samples);
    var ltb: std.ArrayList(u8) = .empty;
    var r1: usize = 0;
    while (r1 < 100) : (r1 += 1) try ltb.appendSlice(a, joined);
    const largeText = try ltb.toOwnedSlice(a);
    var vltb: std.ArrayList(u8) = .empty;
    r1 = 0;
    while (r1 < 10) : (r1 += 1) try vltb.appendSlice(a, largeText);
    const veryLargeText = try vltb.toOwnedSlice(a);

    acc += len(try StringProcessor.removeExtraSpaces(a, veryLargeText));
    acc += len(try StringEncoder.encodeBase64Like(a, largeText));
    acc += (try TextAnalyzer.calculateComplexity(a, largeText)).wordCount;
    acc += @intCast((try StringFormatter.wrapText(a, veryLargeText, 100)).len);

    // Multiple transformations on the same text.
    var transformed = largeText;
    var it2: usize = 0;
    while (it2 < 10) : (it2 += 1) {
        transformed = try StringUtils.reverse(a, transformed);
        transformed = try StringProcessor.removeExtraSpaces(a, transformed);
        transformed = try StringUtils.camelCase(a, transformed);
        transformed = try StringProcessor.rotateLeft(a, transformed, it2 + 1);
    }
    acc += len(transformed);

    // Advanced pattern matching and replacement.
    for (samples) |text| {
        acc += len(try replaceDigitRuns(a, text, "[NUMBER]"));
        acc += len(try replaceMatches(a, text, "[EMAIL]", matchEmailAt));
        acc += len(try replaceMatches(a, text, "[URL]", matchUrlAt));
    }

    std.mem.doNotOptimizeAway(acc);
}

pub fn runBenchmark() void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    doTheWork(arena.allocator()) catch {};
}

export fn bench_run() void {
    runBenchmark();
}







