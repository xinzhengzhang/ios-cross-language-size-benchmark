/*
 * iOS Size Benchmark - Test Case Implementation
 * Generated with Claude AI (https://claude.ai)
 * 
 * This Objective-C implementation demonstrates language-specific
 * features and patterns for binary size comparison.
 */

#import <Foundation/Foundation.h>

// Test case: String Processing - Tests impact of heavy string operations on code size

// String utilities
@interface StringUtils : NSObject

+ (NSString *)reverse:(NSString *)text;
+ (NSString *)capitalize:(NSString *)text;
+ (NSString *)camelCase:(NSString *)text;
+ (NSString *)snakeCase:(NSString *)text;
+ (NSString *)kebabCase:(NSString *)text;
+ (NSString *)titleCase:(NSString *)text;
+ (BOOL)isValidEmail:(NSString *)email;
+ (BOOL)isValidPhone:(NSString *)phone;
+ (BOOL)isValidUrl:(NSString *)url;
+ (BOOL)containsOnlyAlphanumeric:(NSString *)text;
+ (BOOL)containsSpecialChars:(NSString *)text;
+ (NSInteger)countWords:(NSString *)text;
+ (NSInteger)countCharacters:(NSString *)text character:(unichar)character;
+ (NSInteger)countVowels:(NSString *)text;
+ (NSInteger)countConsonants:(NSString *)text;

@end

@implementation StringUtils

+ (NSString *)reverse:(NSString *)text {
    NSMutableString *reversed = [NSMutableString string];
    for (NSInteger i = text.length - 1; i >= 0; i--) {
        [reversed appendString:[text substringWithRange:NSMakeRange(i, 1)]];
    }
    return reversed;
}

+ (NSString *)capitalize:(NSString *)text {
    if (text.length == 0) return text;
    NSString *firstChar = [[text substringToIndex:1] uppercaseString];
    NSString *restOfString = [text substringFromIndex:1];
    return [firstChar stringByAppendingString:restOfString];
}

+ (NSString *)camelCase:(NSString *)text {
    NSArray *words = [text componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" _-"]];
    NSMutableString *result = [NSMutableString string];
    
    for (NSInteger i = 0; i < words.count; i++) {
        NSString *word = words[i];
        if (word.length > 0) {
            if (i == 0) {
                [result appendString:[word lowercaseString]];
            } else {
                [result appendString:[self capitalize:[word lowercaseString]]];
            }
        }
    }
    return result;
}

+ (NSString *)snakeCase:(NSString *)text {
    NSArray *words = [text componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" -"]];
    NSMutableArray *lowercaseWords = [NSMutableArray array];
    
    for (NSString *word in words) {
        if (word.length > 0) {
            [lowercaseWords addObject:[word lowercaseString]];
        }
    }
    return [lowercaseWords componentsJoinedByString:@"_"];
}

+ (NSString *)kebabCase:(NSString *)text {
    NSArray *words = [text componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" _"]];
    NSMutableArray *lowercaseWords = [NSMutableArray array];
    
    for (NSString *word in words) {
        if (word.length > 0) {
            [lowercaseWords addObject:[word lowercaseString]];
        }
    }
    return [lowercaseWords componentsJoinedByString:@"-"];
}

+ (NSString *)titleCase:(NSString *)text {
    NSArray *words = [text componentsSeparatedByString:@" "];
    NSMutableArray *titleWords = [NSMutableArray array];
    
    for (NSString *word in words) {
        if (word.length > 0) {
            [titleWords addObject:[self capitalize:[word lowercaseString]]];
        }
    }
    return [titleWords componentsJoinedByString:@" "];
}

+ (BOOL)isValidEmail:(NSString *)email {
    NSString *emailRegex = @"^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

+ (BOOL)isValidPhone:(NSString *)phone {
    NSString *cleanPhone = [phone stringByReplacingOccurrencesOfString:@"[^0-9]" 
                                                            withString:@"" 
                                                               options:NSRegularExpressionSearch 
                                                                 range:NSMakeRange(0, phone.length)];
    return cleanPhone.length >= 10 && cleanPhone.length <= 15;
}

+ (BOOL)isValidUrl:(NSString *)url {
    NSString *urlRegex = @"^https?://[A-Za-z0-9.-]+\\.[A-Za-z]{2,}(/.*)?$";
    NSPredicate *urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", urlRegex];
    return [urlTest evaluateWithObject:url];
}

+ (BOOL)containsOnlyAlphanumeric:(NSString *)text {
    NSCharacterSet *alphanumericSet = [NSCharacterSet alphanumericCharacterSet];
    NSCharacterSet *textSet = [NSCharacterSet characterSetWithCharactersInString:text];
    return [alphanumericSet isSupersetOfSet:textSet];
}

+ (BOOL)containsSpecialChars:(NSString *)text {
    NSCharacterSet *alphanumericAndSpace = [[NSCharacterSet alphanumericCharacterSet] 
                                           mutableCopy];
    [(NSMutableCharacterSet *)alphanumericAndSpace addCharactersInString:@" "];
    
    for (NSInteger i = 0; i < text.length; i++) {
        unichar character = [text characterAtIndex:i];
        if (![alphanumericAndSpace characterIsMember:character]) {
            return YES;
        }
    }
    return NO;
}

+ (NSInteger)countWords:(NSString *)text {
    NSArray *words = [text componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSInteger count = 0;
    for (NSString *word in words) {
        if (word.length > 0) {
            count++;
        }
    }
    return count;
}

+ (NSInteger)countCharacters:(NSString *)text character:(unichar)character {
    NSInteger count = 0;
    for (NSInteger i = 0; i < text.length; i++) {
        if ([text characterAtIndex:i] == character) {
            count++;
        }
    }
    return count;
}

+ (NSInteger)countVowels:(NSString *)text {
    NSString *vowels = @"aeiouAEIOU";
    NSInteger count = 0;
    for (NSInteger i = 0; i < text.length; i++) {
        unichar character = [text characterAtIndex:i];
        if ([vowels rangeOfString:[NSString stringWithFormat:@"%C", character]].location != NSNotFound) {
            count++;
        }
    }
    return count;
}

+ (NSInteger)countConsonants:(NSString *)text {
    NSCharacterSet *letterSet = [NSCharacterSet letterCharacterSet];
    NSString *vowels = @"aeiouAEIOU";
    NSInteger count = 0;
    
    for (NSInteger i = 0; i < text.length; i++) {
        unichar character = [text characterAtIndex:i];
        if ([letterSet characterIsMember:character] && 
            [vowels rangeOfString:[NSString stringWithFormat:@"%C", character]].location == NSNotFound) {
            count++;
        }
    }
    return count;
}

@end

// String processor
@interface StringProcessor : NSObject

- (NSString *)removeExtraSpaces:(NSString *)text;
- (NSString *)removePunctuation:(NSString *)text;
- (NSString *)removeNumbers:(NSString *)text;
- (NSString *)removeSpecialChars:(NSString *)text;
- (NSArray<NSString *> *)extractNumbers:(NSString *)text;
- (NSArray<NSString *> *)extractEmails:(NSString *)text;
- (NSArray<NSString *> *)extractUrls:(NSString *)text;
- (NSArray<NSString *> *)extractHashtags:(NSString *)text;
- (NSArray<NSString *> *)extractMentions:(NSString *)text;
- (NSString *)insertCharAt:(NSString *)text index:(NSInteger)index character:(unichar)character;
- (NSString *)replaceCharAt:(NSString *)text index:(NSInteger)index character:(unichar)character;
- (NSString *)removeCharAt:(NSString *)text index:(NSInteger)index;
- (NSString *)swapChars:(NSString *)text index1:(NSInteger)index1 index2:(NSInteger)index2;
- (NSString *)rotateLeft:(NSString *)text positions:(NSInteger)positions;
- (NSString *)rotateRight:(NSString *)text positions:(NSInteger)positions;

@end

@implementation StringProcessor

- (NSString *)removeExtraSpaces:(NSString *)text {
    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"\\s+" 
                                                                           options:0 
                                                                             error:&error];
    NSString *result = [regex stringByReplacingMatchesInString:text 
                                                       options:0 
                                                         range:NSMakeRange(0, text.length) 
                                                  withTemplate:@" "];
    return [result stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

- (NSString *)removePunctuation:(NSString *)text {
    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[^\\w\\s]" 
                                                                           options:0 
                                                                             error:&error];
    return [regex stringByReplacingMatchesInString:text 
                                           options:0 
                                             range:NSMakeRange(0, text.length) 
                                      withTemplate:@""];
}

- (NSString *)removeNumbers:(NSString *)text {
    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"\\d" 
                                                                           options:0 
                                                                             error:&error];
    return [regex stringByReplacingMatchesInString:text 
                                           options:0 
                                             range:NSMakeRange(0, text.length) 
                                      withTemplate:@""];
}

- (NSString *)removeSpecialChars:(NSString *)text {
    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[^A-Za-z0-9\\s]" 
                                                                           options:0 
                                                                             error:&error];
    return [regex stringByReplacingMatchesInString:text 
                                           options:0 
                                             range:NSMakeRange(0, text.length) 
                                      withTemplate:@""];
}

- (NSArray<NSString *> *)extractNumbers:(NSString *)text {
    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"\\d+" 
                                                                           options:0 
                                                                             error:&error];
    NSArray *matches = [regex matchesInString:text options:0 range:NSMakeRange(0, text.length)];
    NSMutableArray *results = [NSMutableArray array];
    
    for (NSTextCheckingResult *match in matches) {
        [results addObject:[text substringWithRange:match.range]];
    }
    return results;
}

- (NSArray<NSString *> *)extractEmails:(NSString *)text {
    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}" 
                                                                           options:0 
                                                                             error:&error];
    NSArray *matches = [regex matchesInString:text options:0 range:NSMakeRange(0, text.length)];
    NSMutableArray *results = [NSMutableArray array];
    
    for (NSTextCheckingResult *match in matches) {
        [results addObject:[text substringWithRange:match.range]];
    }
    return results;
}

- (NSArray<NSString *> *)extractUrls:(NSString *)text {
    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"https?://[A-Za-z0-9.-]+\\.[A-Za-z]{2,}(/[^\\s]*)?" 
                                                                           options:0 
                                                                             error:&error];
    NSArray *matches = [regex matchesInString:text options:0 range:NSMakeRange(0, text.length)];
    NSMutableArray *results = [NSMutableArray array];
    
    for (NSTextCheckingResult *match in matches) {
        [results addObject:[text substringWithRange:match.range]];
    }
    return results;
}

- (NSArray<NSString *> *)extractHashtags:(NSString *)text {
    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"#\\w+" 
                                                                           options:0 
                                                                             error:&error];
    NSArray *matches = [regex matchesInString:text options:0 range:NSMakeRange(0, text.length)];
    NSMutableArray *results = [NSMutableArray array];
    
    for (NSTextCheckingResult *match in matches) {
        [results addObject:[text substringWithRange:match.range]];
    }
    return results;
}

- (NSArray<NSString *> *)extractMentions:(NSString *)text {
    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"@\\w+" 
                                                                           options:0 
                                                                             error:&error];
    NSArray *matches = [regex matchesInString:text options:0 range:NSMakeRange(0, text.length)];
    NSMutableArray *results = [NSMutableArray array];
    
    for (NSTextCheckingResult *match in matches) {
        [results addObject:[text substringWithRange:match.range]];
    }
    return results;
}

- (NSString *)insertCharAt:(NSString *)text index:(NSInteger)index character:(unichar)character {
    NSMutableString *mutable = [text mutableCopy];
    [mutable insertString:[NSString stringWithFormat:@"%C", character] atIndex:index];
    return mutable;
}

- (NSString *)replaceCharAt:(NSString *)text index:(NSInteger)index character:(unichar)character {
    NSMutableString *mutable = [text mutableCopy];
    [mutable replaceCharactersInRange:NSMakeRange(index, 1) 
                           withString:[NSString stringWithFormat:@"%C", character]];
    return mutable;
}

- (NSString *)removeCharAt:(NSString *)text index:(NSInteger)index {
    NSMutableString *mutable = [text mutableCopy];
    [mutable deleteCharactersInRange:NSMakeRange(index, 1)];
    return mutable;
}

- (NSString *)swapChars:(NSString *)text index1:(NSInteger)index1 index2:(NSInteger)index2 {
    NSMutableString *mutable = [text mutableCopy];
    unichar char1 = [text characterAtIndex:index1];
    unichar char2 = [text characterAtIndex:index2];
    
    [mutable replaceCharactersInRange:NSMakeRange(index1, 1) 
                           withString:[NSString stringWithFormat:@"%C", char2]];
    [mutable replaceCharactersInRange:NSMakeRange(index2, 1) 
                           withString:[NSString stringWithFormat:@"%C", char1]];
    return mutable;
}

- (NSString *)rotateLeft:(NSString *)text positions:(NSInteger)positions {
    if (text.length == 0) return text;
    NSInteger pos = positions % text.length;
    return [[text substringFromIndex:pos] stringByAppendingString:[text substringToIndex:pos]];
}

- (NSString *)rotateRight:(NSString *)text positions:(NSInteger)positions {
    if (text.length == 0) return text;
    NSInteger pos = positions % text.length;
    NSInteger splitPoint = text.length - pos;
    return [[text substringFromIndex:splitPoint] stringByAppendingString:[text substringToIndex:splitPoint]];
}

@end

// String encoder
@interface StringEncoder : NSObject

- (NSString *)encodeBase64Like:(NSString *)text;
- (NSString *)decodeBase64Like:(NSString *)encoded;
- (NSString *)urlEncode:(NSString *)text;
- (NSString *)urlDecode:(NSString *)encoded;
- (NSString *)htmlEncode:(NSString *)text;
- (NSString *)htmlDecode:(NSString *)encoded;
- (NSString *)jsonEscape:(NSString *)text;
- (NSString *)jsonUnescape:(NSString *)escaped;

@end

@implementation StringEncoder

- (NSString *)encodeBase64Like:(NSString *)text {
    NSData *data = [text dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableString *result = [NSMutableString string];
    
    const unsigned char *bytes = [data bytes];
    for (NSInteger i = 0; i < data.length; i++) {
        [result appendFormat:@"%02x", bytes[i]];
    }
    return result;
}

- (NSString *)decodeBase64Like:(NSString *)encoded {
    NSMutableData *data = [NSMutableData data];
    for (NSInteger i = 0; i < encoded.length; i += 2) {
        NSString *hex = [encoded substringWithRange:NSMakeRange(i, 2)];
        unsigned int value;
        [[NSScanner scannerWithString:hex] scanHexInt:&value];
        unsigned char byte = value;
        [data appendBytes:&byte length:1];
    }
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

- (NSString *)urlEncode:(NSString *)text {
    NSMutableString *result = [NSMutableString string];
    for (NSInteger i = 0; i < text.length; i++) {
        unichar character = [text characterAtIndex:i];
        if ([[NSCharacterSet alphanumericCharacterSet] characterIsMember:character]) {
            [result appendFormat:@"%C", character];
        } else if (character == ' ') {
            [result appendString:@"%20"];
        } else if (character == '&') {
            [result appendString:@"%26"];
        } else if (character == '=') {
            [result appendString:@"%3D"];
        } else if (character == '?') {
            [result appendString:@"%3F"];
        } else {
            [result appendFormat:@"%%%02X", (unsigned int)character];
        }
    }
    return result;
}

- (NSString *)urlDecode:(NSString *)encoded {
    NSString *result = encoded;
    result = [result stringByReplacingOccurrencesOfString:@"%20" withString:@" "];
    result = [result stringByReplacingOccurrencesOfString:@"%26" withString:@"&"];
    result = [result stringByReplacingOccurrencesOfString:@"%3D" withString:@"="];
    result = [result stringByReplacingOccurrencesOfString:@"%3F" withString:@"?"];
    return result;
}

- (NSString *)htmlEncode:(NSString *)text {
    NSString *result = text;
    result = [result stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"];
    result = [result stringByReplacingOccurrencesOfString:@"<" withString:@"&lt;"];
    result = [result stringByReplacingOccurrencesOfString:@">" withString:@"&gt;"];
    result = [result stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"];
    result = [result stringByReplacingOccurrencesOfString:@"'" withString:@"&#39;"];
    return result;
}

- (NSString *)htmlDecode:(NSString *)encoded {
    NSString *result = encoded;
    result = [result stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
    result = [result stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
    result = [result stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
    result = [result stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
    result = [result stringByReplacingOccurrencesOfString:@"&#39;" withString:@"'"];
    return result;
}

- (NSString *)jsonEscape:(NSString *)text {
    NSString *result = text;
    result = [result stringByReplacingOccurrencesOfString:@"\\" withString:@"\\\\"];
    result = [result stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    result = [result stringByReplacingOccurrencesOfString:@"\n" withString:@"\\n"];
    result = [result stringByReplacingOccurrencesOfString:@"\r" withString:@"\\r"];
    result = [result stringByReplacingOccurrencesOfString:@"\t" withString:@"\\t"];
    return result;
}

- (NSString *)jsonUnescape:(NSString *)escaped {
    NSString *result = escaped;
    result = [result stringByReplacingOccurrencesOfString:@"\\\"" withString:@"\""];
    result = [result stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"];
    result = [result stringByReplacingOccurrencesOfString:@"\\r" withString:@"\r"];
    result = [result stringByReplacingOccurrencesOfString:@"\\t" withString:@"\t"];
    result = [result stringByReplacingOccurrencesOfString:@"\\\\" withString:@"\\"];
    return result;
}

@end

// Text analyzer
@interface TextAnalyzer : NSObject

- (double)calculateReadabilityScore:(NSString *)text;
- (NSString *)analyzeSentiment:(NSString *)text;
- (NSString *)detectLanguage:(NSString *)text;
- (NSDictionary *)calculateComplexity:(NSString *)text;

@end

@implementation TextAnalyzer

- (double)calculateReadabilityScore:(NSString *)text {
    NSArray *sentences = [text componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@".!?"]];
    sentences = [sentences filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"length > 0"]];
    
    NSArray *words = [text componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    words = [words filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"length > 0"]];
    
    if (sentences.count == 0 || words.count == 0) return 0.0;
    
    double avgWordsPerSentence = (double)words.count / sentences.count;
    double avgSyllablesPerWord = 1.5; // Simplified approximation
    
    return 206.835 - (1.015 * avgWordsPerSentence) - (84.6 * avgSyllablesPerWord);
}

- (NSString *)analyzeSentiment:(NSString *)text {
    NSSet *positiveWords = [NSSet setWithArray:@[@"good", @"great", @"excellent", @"amazing", @"wonderful", @"fantastic", @"love", @"like", @"happy", @"joy"]];
    NSSet *negativeWords = [NSSet setWithArray:@[@"bad", @"terrible", @"awful", @"horrible", @"hate", @"dislike", @"sad", @"angry", @"disappointed", @"frustrated"]];
    
    NSArray *words = [[text lowercaseString] componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    NSInteger positiveCount = 0, negativeCount = 0;
    for (NSString *word in words) {
        if ([positiveWords containsObject:word]) positiveCount++;
        if ([negativeWords containsObject:word]) negativeCount++;
    }
    
    if (positiveCount > negativeCount) return @"Positive";
    if (negativeCount > positiveCount) return @"Negative";
    return @"Neutral";
}

- (NSString *)detectLanguage:(NSString *)text {
    NSSet *englishPatterns = [NSSet setWithArray:@[@"the", @"and", @"is", @"in", @"to", @"of", @"a", @"that", @"it", @"with"]];
    NSSet *spanishPatterns = [NSSet setWithArray:@[@"el", @"la", @"de", @"que", @"y", @"a", @"en", @"un", @"es", @"se"]];
    NSSet *frenchPatterns = [NSSet setWithArray:@[@"le", @"de", @"et", @"à", @"un", @"il", @"être", @"et", @"en", @"avoir"]];
    
    NSArray *words = [[text lowercaseString] componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    NSInteger englishScore = 0, spanishScore = 0, frenchScore = 0;
    for (NSString *word in words) {
        if ([englishPatterns containsObject:word]) englishScore++;
        if ([spanishPatterns containsObject:word]) spanishScore++;
        if ([frenchPatterns containsObject:word]) frenchScore++;
    }
    
    NSInteger maxScore = MAX(MAX(englishScore, spanishScore), frenchScore);
    if (maxScore == englishScore) return @"English";
    if (maxScore == spanishScore) return @"Spanish";
    if (maxScore == frenchScore) return @"French";
    return @"Unknown";
}

- (NSDictionary *)calculateComplexity:(NSString *)text {
    NSArray *words = [text componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    words = [words filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"length > 0"]];
    
    NSArray *sentences = [text componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@".!?"]];
    sentences = [sentences filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"length > 0"]];
    
    NSString *textNoSpaces = [text stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    return @{
        @"wordCount": @(words.count),
        @"sentenceCount": @(sentences.count),
        @"characterCount": @(text.length),
        @"characterCountNoSpaces": @(textNoSpaces.length),
        @"averageWordsPerSentence": sentences.count > 0 ? @((double)words.count / sentences.count) : @0,
        @"averageCharactersPerWord": words.count > 0 ? @((double)textNoSpaces.length / words.count) : @0
    };
}

@end

// String formatter
@interface StringFormatter : NSObject

- (NSString *)processTemplate:(NSString *)template withVariables:(NSDictionary *)variables;
- (NSString *)formatNumber:(double)number withDecimals:(NSInteger)decimals;
- (NSString *)formatCurrency:(double)amount withCurrency:(NSString *)currency;
- (NSString *)formatPercentage:(double)value;
- (NSString *)formatDate:(long long)timestamp;
- (NSString *)padLeft:(NSString *)text length:(NSInteger)length character:(unichar)character;
- (NSString *)padRight:(NSString *)text length:(NSInteger)length character:(unichar)character;
- (NSString *)padCenter:(NSString *)text length:(NSInteger)length character:(unichar)character;
- (NSArray<NSString *> *)wrapText:(NSString *)text maxLineLength:(NSInteger)maxLineLength;

@end

@implementation StringFormatter

- (NSString *)processTemplate:(NSString *)template withVariables:(NSDictionary *)variables {
    NSString *result = template;
    for (NSString *key in variables) {
        NSString *value = variables[key];
        result = [result stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"{{%@}}", key] withString:value];
        result = [result stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"{%@}", key] withString:value];
        result = [result stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"${%@}", key] withString:value];
    }
    return result;
}

- (NSString *)formatNumber:(double)number withDecimals:(NSInteger)decimals {
    return [NSString stringWithFormat:@"%.*f", (int)decimals, number];
}

- (NSString *)formatCurrency:(double)amount withCurrency:(NSString *)currency {
    return [NSString stringWithFormat:@"%@ %.2f", currency, amount];
}

- (NSString *)formatPercentage:(double)value {
    return [NSString stringWithFormat:@"%.1f%%", value * 100];
}

- (NSString *)formatDate:(long long)timestamp {
    long long days = timestamp / (24 * 60 * 60 * 1000);
    long long hours = (timestamp % (24 * 60 * 60 * 1000)) / (60 * 60 * 1000);
    long long minutes = (timestamp % (60 * 60 * 1000)) / (60 * 1000);
    return [NSString stringWithFormat:@"%02lld:%02lld:%02lld", days, hours, minutes];
}

- (NSString *)padLeft:(NSString *)text length:(NSInteger)length character:(unichar)character {
    if (text.length >= length) return text;
    NSString *padding = [@"" stringByPaddingToLength:(length - text.length) 
                                          withString:[NSString stringWithFormat:@"%C", character] 
                                     startingAtIndex:0];
    return [padding stringByAppendingString:text];
}

- (NSString *)padRight:(NSString *)text length:(NSInteger)length character:(unichar)character {
    if (text.length >= length) return text;
    return [text stringByPaddingToLength:length 
                              withString:[NSString stringWithFormat:@"%C", character] 
                         startingAtIndex:0];
}

- (NSString *)padCenter:(NSString *)text length:(NSInteger)length character:(unichar)character {
    if (text.length >= length) return text;
    NSInteger totalPadding = length - text.length;
    NSInteger leftPadding = totalPadding / 2;
    NSInteger rightPadding = totalPadding - leftPadding;
    
    NSString *leftPad = [@"" stringByPaddingToLength:leftPadding 
                                          withString:[NSString stringWithFormat:@"%C", character] 
                                     startingAtIndex:0];
    NSString *rightPad = [@"" stringByPaddingToLength:rightPadding 
                                           withString:[NSString stringWithFormat:@"%C", character] 
                                      startingAtIndex:0];
    return [[leftPad stringByAppendingString:text] stringByAppendingString:rightPad];
}

- (NSArray<NSString *> *)wrapText:(NSString *)text maxLineLength:(NSInteger)maxLineLength {
    NSArray *words = [text componentsSeparatedByString:@" "];
    NSMutableArray *lines = [NSMutableArray array];
    NSString *currentLine = @"";
    
    for (NSString *word in words) {
        if (currentLine.length == 0) {
            currentLine = word;
        } else if (currentLine.length + word.length + 1 <= maxLineLength) {
            currentLine = [currentLine stringByAppendingFormat:@" %@", word];
        } else {
            [lines addObject:currentLine];
            currentLine = word;
        }
    }
    
    if (currentLine.length > 0) {
        [lines addObject:currentLine];
    }
    
    return lines;
}

@end

// Main benchmark class
@interface IosSizeBenchmark : NSObject
@property (nonatomic, strong) StringProcessor *stringProcessor;
@property (nonatomic, strong) StringEncoder *stringEncoder;
@property (nonatomic, strong) TextAnalyzer *textAnalyzer;
@property (nonatomic, strong) StringFormatter *stringFormatter;
@property (nonatomic, strong) NSArray<NSString *> *sampleTexts;
- (void)runBenchmark;
@end

@implementation IosSizeBenchmark

- (instancetype)init {
    self = [super init];
    if (self) {
        _stringProcessor = [[StringProcessor alloc] init];
        _stringEncoder = [[StringEncoder alloc] init];
        _textAnalyzer = [[TextAnalyzer alloc] init];
        _stringFormatter = [[StringFormatter alloc] init];
        _sampleTexts = @[
            @"Hello, World! This is a sample text for string processing benchmarks.",
            @"The quick brown fox jumps over the lazy dog. This sentence contains every letter of the alphabet.",
            @"Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
            @"In computer science, a string is traditionally a sequence of characters, either as a literal constant or as some kind of variable.",
            @"String processing is a fundamental operation in computer programming and text analysis applications."
        ];
    }
    return self;
}

- (void)runBenchmark {
    // Basic string operations
    for (NSString *text in self.sampleTexts) {
        NSString *reversed = [StringUtils reverse:text];
        NSString *capitalized = [StringUtils capitalize:text];
        NSString *camelCased = [StringUtils camelCase:text];
        NSString *snakeCased = [StringUtils snakeCase:text];
        NSString *kebabCased = [StringUtils kebabCase:text];
        NSString *titleCased = [StringUtils titleCase:text];
        
        NSInteger wordCount = [StringUtils countWords:text];
        NSInteger vowelCount = [StringUtils countVowels:text];
        NSInteger consonantCount = [StringUtils countConsonants:text];
        BOOL hasSpecialChars = [StringUtils containsSpecialChars:text];
        BOOL isAlphanumeric = [StringUtils containsOnlyAlphanumeric:text];
    }
    
    // Validation tests
    NSArray *emailTests = @[@"user@example.com", @"invalid.email", @"test.email+tag@domain.org"];
    for (NSString *email in emailTests) {
        BOOL isValid = [StringUtils isValidEmail:email];
    }
    
    NSArray *phoneTests = @[@"+1-555-123-4567", @"555.123.4567", @"invalid-phone"];
    for (NSString *phone in phoneTests) {
        BOOL isValid = [StringUtils isValidPhone:phone];
    }
    
    NSArray *urlTests = @[@"https://www.example.com", @"http://domain.org/path", @"not-a-url"];
    for (NSString *url in urlTests) {
        BOOL isValid = [StringUtils isValidUrl:url];
    }
    
    // Text processing
    for (NSString *text in self.sampleTexts) {
        NSString *cleaned = [self.stringProcessor removeExtraSpaces:text];
        NSString *noPunctuation = [self.stringProcessor removePunctuation:text];
        NSString *noNumbers = [self.stringProcessor removeNumbers:text];
        NSString *noSpecialChars = [self.stringProcessor removeSpecialChars:text];
        
        NSArray *extractedNumbers = [self.stringProcessor extractNumbers:text];
        NSArray *extractedEmails = [self.stringProcessor extractEmails:text];
        NSArray *extractedUrls = [self.stringProcessor extractUrls:text];
    }
    
    // Encoding and decoding
    for (NSString *text in self.sampleTexts) {
        NSString *base64Encoded = [self.stringEncoder encodeBase64Like:text];
        NSString *base64Decoded = [self.stringEncoder decodeBase64Like:base64Encoded];
        
        NSString *urlEncoded = [self.stringEncoder urlEncode:text];
        NSString *urlDecoded = [self.stringEncoder urlDecode:urlEncoded];
        
        NSString *htmlEncoded = [self.stringEncoder htmlEncode:text];
        NSString *htmlDecoded = [self.stringEncoder htmlDecode:htmlEncoded];
        
        NSString *jsonEscaped = [self.stringEncoder jsonEscape:text];
        NSString *jsonUnescaped = [self.stringEncoder jsonUnescape:jsonEscaped];
    }
    
    // Text analysis
    for (NSString *text in self.sampleTexts) {
        double readabilityScore = [self.textAnalyzer calculateReadabilityScore:text];
        NSString *sentiment = [self.textAnalyzer analyzeSentiment:text];
        NSString *language = [self.textAnalyzer detectLanguage:text];
        NSDictionary *complexity = [self.textAnalyzer calculateComplexity:text];
    }
    
    // String formatting
    NSDictionary *templateVariables = @{
        @"name": @"John Doe",
        @"age": @"30",
        @"city": @"New York",
        @"occupation": @"Developer"
    };
    
    NSArray *templates = @[
        @"Hello {{name}}, you are {age} years old.",
        @"Welcome to ${city}, {name}!",
        @"Your occupation is {{occupation}} in {city}."
    ];
    
    for (NSString *template in templates) {
        NSString *processed = [self.stringFormatter processTemplate:template withVariables:templateVariables];
    }
    
    // Number formatting
    NSArray *numbers = @[@123.456, @789.123, @456.789];
    for (NSNumber *number in numbers) {
        NSString *formatted = [self.stringFormatter formatNumber:[number doubleValue] withDecimals:2];
        NSString *currency = [self.stringFormatter formatCurrency:[number doubleValue] withCurrency:@"USD"];
        NSString *percentage = [self.stringFormatter formatPercentage:[number doubleValue] / 1000];
    }
    
    // Text padding and wrapping
    NSArray *shortTexts = @[@"Short", @"Medium text", @"Very long text example"];
    for (NSString *text in shortTexts) {
        NSString *paddedLeft = [self.stringFormatter padLeft:text length:20 character:'-'];
        NSString *paddedRight = [self.stringFormatter padRight:text length:20 character:'='];
        NSString *paddedCenter = [self.stringFormatter padCenter:text length:25 character:' '];
        NSArray *wrapped = [self.stringFormatter wrapText:text maxLineLength:40];
    }
}

@end