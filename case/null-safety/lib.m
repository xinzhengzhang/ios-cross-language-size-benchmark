/*
 * iOS Size Benchmark - Test Case Implementation
 * Generated with Claude AI (https://claude.ai)
 * 
 * This Objective-C implementation demonstrates language-specific
 * features and patterns for binary size comparison.
 */

#import <Foundation/Foundation.h>

// Test case: Null Safety - Objective-C equivalent with manual nil checking and NSNull handling

// Forward declarations
@class Address;
@class UserPreferences;
@class NotificationSettings;
@class PrivacySettings;
@class ErrorInfo;
@class ResponseMetadata;
@class FeatureFlags;
@class CacheConfig;
@class AnalyticsConfig;

// User data model with nullable properties
@interface User : NSObject
@property (nonatomic, strong, nonnull) NSString *userId;
@property (nonatomic, strong, nullable) NSString *name;
@property (nonatomic, strong, nullable) NSString *email;
@property (nonatomic, strong, nullable) NSString *phone;
@property (nonatomic, strong, nullable) Address *address;
@property (nonatomic, strong, nullable) UserPreferences *preferences;

- (instancetype _Nonnull)initWithId:(NSString * _Nonnull)userId
                               name:(NSString * _Nullable)name
                              email:(NSString * _Nullable)email
                              phone:(NSString * _Nullable)phone
                            address:(Address * _Nullable)address
                        preferences:(UserPreferences * _Nullable)preferences;
@end

@interface Address : NSObject
@property (nonatomic, strong, nullable) NSString *street;
@property (nonatomic, strong, nullable) NSString *city;
@property (nonatomic, strong, nullable) NSString *state;
@property (nonatomic, strong, nullable) NSString *zipCode;
@property (nonatomic, strong, nullable) NSString *country;

- (instancetype _Nonnull)initWithStreet:(NSString * _Nullable)street
                                   city:(NSString * _Nullable)city
                                  state:(NSString * _Nullable)state
                                zipCode:(NSString * _Nullable)zipCode
                                country:(NSString * _Nullable)country;
@end

@interface UserPreferences : NSObject
@property (nonatomic, strong, nullable) NSString *theme;
@property (nonatomic, strong, nullable) NSString *language;
@property (nonatomic, strong, nullable) NotificationSettings *notifications;
@property (nonatomic, strong, nullable) PrivacySettings *privacy;

- (instancetype _Nonnull)initWithTheme:(NSString * _Nullable)theme
                              language:(NSString * _Nullable)language
                         notifications:(NotificationSettings * _Nullable)notifications
                               privacy:(PrivacySettings * _Nullable)privacy;
@end

@interface NotificationSettings : NSObject
@property (nonatomic, strong, nullable) NSNumber *email;
@property (nonatomic, strong, nullable) NSNumber *push;
@property (nonatomic, strong, nullable) NSNumber *sms;

- (instancetype _Nonnull)initWithEmail:(NSNumber * _Nullable)email
                                  push:(NSNumber * _Nullable)push
                                   sms:(NSNumber * _Nullable)sms;
@end

@interface PrivacySettings : NSObject
@property (nonatomic, strong, nullable) NSString *profileVisibility;
@property (nonatomic, strong, nullable) NSNumber *dataSharing;
@property (nonatomic, strong, nullable) NSNumber *analytics;

- (instancetype _Nonnull)initWithProfileVisibility:(NSString * _Nullable)profileVisibility
                                        dataSharing:(NSNumber * _Nullable)dataSharing
                                          analytics:(NSNumber * _Nullable)analytics;
@end

// Network response models with nullable data
@interface ApiResponse : NSObject
@property (nonatomic, strong, nullable) id data;
@property (nonatomic, strong, nullable) ErrorInfo *error;
@property (nonatomic, strong, nullable) ResponseMetadata *metadata;

- (instancetype _Nonnull)initWithData:(id _Nullable)data
                                error:(ErrorInfo * _Nullable)error
                             metadata:(ResponseMetadata * _Nullable)metadata;
@end

@interface ErrorInfo : NSObject
@property (nonatomic, strong, nullable) NSString *code;
@property (nonatomic, strong, nullable) NSString *message;
@property (nonatomic, strong, nullable) NSDictionary<NSString *, NSString *> *details;

- (instancetype _Nonnull)initWithCode:(NSString * _Nullable)code
                              message:(NSString * _Nullable)message
                              details:(NSDictionary<NSString *, NSString *> * _Nullable)details;
@end

@interface ResponseMetadata : NSObject
@property (nonatomic, strong, nullable) NSNumber *timestamp;
@property (nonatomic, strong, nullable) NSString *version;
@property (nonatomic, strong, nullable) NSString *requestId;

- (instancetype _Nonnull)initWithTimestamp:(NSNumber * _Nullable)timestamp
                                   version:(NSString * _Nullable)version
                                 requestId:(NSString * _Nullable)requestId;
@end

// Configuration classes with nullable settings
@interface AppConfig : NSObject
@property (nonatomic, strong, nullable) NSString *apiUrl;
@property (nonatomic, strong, nullable) NSString *apiKey;
@property (nonatomic, strong, nullable) FeatureFlags *features;
@property (nonatomic, strong, nullable) CacheConfig *cache;
@property (nonatomic, strong, nullable) AnalyticsConfig *analytics;

- (instancetype _Nonnull)initWithApiUrl:(NSString * _Nullable)apiUrl
                                 apiKey:(NSString * _Nullable)apiKey
                               features:(FeatureFlags * _Nullable)features
                                  cache:(CacheConfig * _Nullable)cache
                              analytics:(AnalyticsConfig * _Nullable)analytics;
@end

@interface FeatureFlags : NSObject
@property (nonatomic, strong, nullable) NSNumber *enableNewUI;
@property (nonatomic, strong, nullable) NSNumber *betaFeatures;
@property (nonatomic, strong, nullable) NSNumber *experimentalMode;

- (instancetype _Nonnull)initWithNewUI:(NSNumber * _Nullable)newUI
                          betaFeatures:(NSNumber * _Nullable)betaFeatures
                      experimentalMode:(NSNumber * _Nullable)experimentalMode;
@end

@interface CacheConfig : NSObject
@property (nonatomic, strong, nullable) NSNumber *enabled;
@property (nonatomic, strong, nullable) NSNumber *maxSize;
@property (nonatomic, strong, nullable) NSNumber *ttl;

- (instancetype _Nonnull)initWithEnabled:(NSNumber * _Nullable)enabled
                                 maxSize:(NSNumber * _Nullable)maxSize
                                     ttl:(NSNumber * _Nullable)ttl;
@end

@interface AnalyticsConfig : NSObject
@property (nonatomic, strong, nullable) NSNumber *enabled;
@property (nonatomic, strong, nullable) NSString *trackingId;
@property (nonatomic, strong, nullable) NSNumber *samplingRate;

- (instancetype _Nonnull)initWithEnabled:(NSNumber * _Nullable)enabled
                              trackingId:(NSString * _Nullable)trackingId
                            samplingRate:(NSNumber * _Nullable)samplingRate;
@end

// Service classes demonstrating manual nil handling in Objective-C
@interface UserService : NSObject

- (NSString * _Nonnull)getUserDisplayName:(User * _Nullable)user;
- (NSString * _Nonnull)getUserContactInfo:(User * _Nullable)user;
- (NSString * _Nullable)getUserFullAddress:(User * _Nullable)user;
- (BOOL)isUserPreferencesComplete:(User * _Nullable)user;
- (User * _Nullable)updateUserEmail:(User * _Nullable)user newEmail:(NSString * _Nullable)newEmail;
- (User * _Nullable)mergeUserData:(User * _Nullable)primary secondary:(User * _Nullable)secondary;

@end

@interface ApiService : NSObject

- (id _Nullable)handleApiResponse:(ApiResponse * _Nullable)response;
- (NSString * _Nonnull)getErrorMessage:(ApiResponse * _Nullable)response;
- (NSDictionary<NSString *, NSString *> * _Nonnull)getResponseMetadata:(ApiResponse * _Nullable)response;
- (BOOL)validateApiResponse:(ApiResponse * _Nullable)response;
- (NSArray<NSString *> * _Nonnull)processApiErrorDetails:(ApiResponse * _Nullable)response;

@end

@interface ConfigService : NSObject

- (BOOL)isConfigValid:(AppConfig * _Nullable)config;
- (NSString * _Nullable)getApiEndpoint:(AppConfig * _Nullable)config path:(NSString * _Nullable)path;
- (BOOL)isFeatureEnabled:(AppConfig * _Nullable)config featureName:(NSString * _Nonnull)featureName;
- (NSArray * _Nonnull)getCacheSettings:(AppConfig * _Nullable)config;
- (NSDictionary<NSString *, id> * _Nonnull)getAnalyticsConfig:(AppConfig * _Nullable)config;

@end

@interface DataProcessor : NSObject

- (NSArray<NSString *> * _Nonnull)processUserList:(NSArray<User *> * _Nullable)users;
- (NSArray<User *> * _Nonnull)getUsersByCity:(NSArray<User *> * _Nullable)users city:(NSString * _Nullable)city;
- (NSDictionary<NSString *, NSNumber *> * _Nonnull)calculateUserStats:(NSArray<User *> * _Nullable)users;
- (NSSet<NSString *> * _Nonnull)extractContactEmails:(NSArray<User *> * _Nullable)users;
- (NSDictionary<NSString *, NSArray<User *> *> * _Nonnull)groupUsersByCountry:(NSArray<User *> * _Nullable)users;

@end

@interface StringUtils : NSObject

- (NSString * _Nullable)safeSubstring:(NSString * _Nullable)text start:(NSInteger)start end:(NSNumber * _Nullable)end;
- (NSString * _Nullable)safeStringJoin:(NSArray<NSString *> * _Nullable)strings separator:(NSString * _Nullable)separator;
- (NSString * _Nullable)safeStringFormat:(NSString * _Nullable)template args:(NSArray * _Nullable)args;
- (NSArray<NSNumber *> * _Nonnull)extractNumbers:(NSString * _Nullable)text;
- (NSDictionary<NSString *, NSString *> * _Nonnull)parseKeyValuePairs:(NSString * _Nullable)text delimiter:(NSString * _Nullable)delimiter;

@end

@interface IosSizeBenchmark : NSObject

- (void)runBenchmark;

@end

// Implementation

@implementation User

- (instancetype)initWithId:(NSString *)userId
                      name:(NSString *)name
                     email:(NSString *)email
                     phone:(NSString *)phone
                   address:(Address *)address
               preferences:(UserPreferences *)preferences {
    self = [super init];
    if (self) {
        _userId = userId;
        _name = name;
        _email = email;
        _phone = phone;
        _address = address;
        _preferences = preferences;
    }
    return self;
}

@end

@implementation Address

- (instancetype)initWithStreet:(NSString *)street
                          city:(NSString *)city
                         state:(NSString *)state
                       zipCode:(NSString *)zipCode
                       country:(NSString *)country {
    self = [super init];
    if (self) {
        _street = street;
        _city = city;
        _state = state;
        _zipCode = zipCode;
        _country = country;
    }
    return self;
}

@end

@implementation UserPreferences

- (instancetype)initWithTheme:(NSString *)theme
                     language:(NSString *)language
                notifications:(NotificationSettings *)notifications
                      privacy:(PrivacySettings *)privacy {
    self = [super init];
    if (self) {
        _theme = theme;
        _language = language;
        _notifications = notifications;
        _privacy = privacy;
    }
    return self;
}

@end

@implementation NotificationSettings

- (instancetype)initWithEmail:(NSNumber *)email
                         push:(NSNumber *)push
                          sms:(NSNumber *)sms {
    self = [super init];
    if (self) {
        _email = email;
        _push = push;
        _sms = sms;
    }
    return self;
}

@end

@implementation PrivacySettings

- (instancetype)initWithProfileVisibility:(NSString *)profileVisibility
                               dataSharing:(NSNumber *)dataSharing
                                 analytics:(NSNumber *)analytics {
    self = [super init];
    if (self) {
        _profileVisibility = profileVisibility;
        _dataSharing = dataSharing;
        _analytics = analytics;
    }
    return self;
}

@end

@implementation ApiResponse

- (instancetype)initWithData:(id)data
                       error:(ErrorInfo *)error
                    metadata:(ResponseMetadata *)metadata {
    self = [super init];
    if (self) {
        _data = data;
        _error = error;
        _metadata = metadata;
    }
    return self;
}

@end

@implementation ErrorInfo

- (instancetype)initWithCode:(NSString *)code
                     message:(NSString *)message
                     details:(NSDictionary<NSString *,NSString *> *)details {
    self = [super init];
    if (self) {
        _code = code;
        _message = message;
        _details = details;
    }
    return self;
}

@end

@implementation ResponseMetadata

- (instancetype)initWithTimestamp:(NSNumber *)timestamp
                          version:(NSString *)version
                        requestId:(NSString *)requestId {
    self = [super init];
    if (self) {
        _timestamp = timestamp;
        _version = version;
        _requestId = requestId;
    }
    return self;
}

@end

@implementation AppConfig

- (instancetype)initWithApiUrl:(NSString *)apiUrl
                        apiKey:(NSString *)apiKey
                      features:(FeatureFlags *)features
                         cache:(CacheConfig *)cache
                     analytics:(AnalyticsConfig *)analytics {
    self = [super init];
    if (self) {
        _apiUrl = apiUrl;
        _apiKey = apiKey;
        _features = features;
        _cache = cache;
        _analytics = analytics;
    }
    return self;
}

@end

@implementation FeatureFlags

- (instancetype)initWithNewUI:(NSNumber *)newUI
                 betaFeatures:(NSNumber *)betaFeatures
             experimentalMode:(NSNumber *)experimentalMode {
    self = [super init];
    if (self) {
        _enableNewUI = newUI;
        _betaFeatures = betaFeatures;
        _experimentalMode = experimentalMode;
    }
    return self;
}

@end

@implementation CacheConfig

- (instancetype)initWithEnabled:(NSNumber *)enabled
                        maxSize:(NSNumber *)maxSize
                            ttl:(NSNumber *)ttl {
    self = [super init];
    if (self) {
        _enabled = enabled;
        _maxSize = maxSize;
        _ttl = ttl;
    }
    return self;
}

@end

@implementation AnalyticsConfig

- (instancetype)initWithEnabled:(NSNumber *)enabled
                     trackingId:(NSString *)trackingId
                   samplingRate:(NSNumber *)samplingRate {
    self = [super init];
    if (self) {
        _enabled = enabled;
        _trackingId = trackingId;
        _samplingRate = samplingRate;
    }
    return self;
}

@end

@implementation UserService

- (NSString *)getUserDisplayName:(User *)user {
    // Objective-C manual nil checking - very verbose
    if (user != nil) {
        if (user.name != nil) {
            NSString *trimmedName = [user.name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            if (trimmedName.length > 0) {
                return user.name;
            }
        }
    }
    return @"Anonymous User";
}

- (NSString *)getUserContactInfo:(User *)user {
    // Manual nil checking with multiple conditionals
    if (user != nil) {
        NSString *email = nil;
        NSString *phone = nil;
        
        if (user.email != nil) {
            if ([user.email containsString:@"@"]) {
                email = user.email;
            }
        }
        
        if (user.phone != nil) {
            NSString *trimmedPhone = [user.phone stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            if (trimmedPhone.length > 0) {
                phone = user.phone;
            }
        }
        
        if (email != nil && phone != nil) {
            return [NSString stringWithFormat:@"Email: %@, Phone: %@", email, phone];
        } else if (email != nil) {
            return [NSString stringWithFormat:@"Email: %@", email];
        } else if (phone != nil) {
            return [NSString stringWithFormat:@"Phone: %@", phone];
        }
    }
    return @"No contact information available";
}

- (NSString *)getUserFullAddress:(User *)user {
    // Manual nil checking through nested objects
    if (user != nil) {
        if (user.address != nil) {
            NSMutableArray *addressParts = [[NSMutableArray alloc] init];
            
            if (user.address.street != nil) {
                [addressParts addObject:user.address.street];
            }
            if (user.address.city != nil) {
                [addressParts addObject:user.address.city];
            }
            if (user.address.state != nil) {
                [addressParts addObject:user.address.state];
            }
            if (user.address.zipCode != nil) {
                [addressParts addObject:user.address.zipCode];
            }
            if (user.address.country != nil) {
                [addressParts addObject:user.address.country];
            }
            
            if (addressParts.count > 0) {
                return [addressParts componentsJoinedByString:@", "];
            }
        }
    }
    return nil;
}

- (BOOL)isUserPreferencesComplete:(User *)user {
    // Complex manual nil checking - extremely verbose in Objective-C
    if (user != nil) {
        if (user.preferences != nil) {
            if (user.preferences.theme != nil && user.preferences.language != nil) {
                if (user.preferences.notifications != nil) {
                    if (user.preferences.notifications.email != nil && 
                        user.preferences.notifications.push != nil && 
                        user.preferences.notifications.sms != nil) {
                        if (user.preferences.privacy != nil) {
                            if (user.preferences.privacy.profileVisibility != nil &&
                                user.preferences.privacy.dataSharing != nil &&
                                user.preferences.privacy.analytics != nil) {
                                return YES;
                            }
                        }
                    }
                }
            }
        }
    }
    return NO;
}

- (User *)updateUserEmail:(User *)user newEmail:(NSString *)newEmail {
    // Manual nil checking for update operations
    if (user != nil) {
        if (newEmail != nil) {
            if ([newEmail containsString:@"@"]) {
                return [[User alloc] initWithId:user.userId
                                           name:user.name
                                          email:newEmail
                                          phone:user.phone
                                        address:user.address
                                    preferences:user.preferences];
            }
        }
    }
    return nil;
}

- (User *)mergeUserData:(User *)primary secondary:(User *)secondary {
    // Manual merging with extensive nil checks
    if (primary == nil) {
        return secondary;
    }
    if (secondary == nil) {
        return primary;
    }
    
    NSString *mergedName = primary.name != nil ? primary.name : secondary.name;
    NSString *mergedEmail = primary.email != nil ? primary.email : secondary.email;
    NSString *mergedPhone = primary.phone != nil ? primary.phone : secondary.phone;
    Address *mergedAddress = primary.address != nil ? primary.address : secondary.address;
    UserPreferences *mergedPreferences = [self mergePreferences:primary.preferences secondary:secondary.preferences];
    
    return [[User alloc] initWithId:primary.userId
                               name:mergedName
                              email:mergedEmail
                              phone:mergedPhone
                            address:mergedAddress
                        preferences:mergedPreferences];
}

- (UserPreferences *)mergePreferences:(UserPreferences *)primary secondary:(UserPreferences *)secondary {
    if (primary == nil) {
        return secondary;
    }
    if (secondary == nil) {
        return primary;
    }
    
    NSString *mergedTheme = primary.theme != nil ? primary.theme : secondary.theme;
    NSString *mergedLanguage = primary.language != nil ? primary.language : secondary.language;
    NotificationSettings *mergedNotifications = [self mergeNotificationSettings:primary.notifications secondary:secondary.notifications];
    PrivacySettings *mergedPrivacy = [self mergePrivacySettings:primary.privacy secondary:secondary.privacy];
    
    return [[UserPreferences alloc] initWithTheme:mergedTheme
                                         language:mergedLanguage
                                    notifications:mergedNotifications
                                          privacy:mergedPrivacy];
}

- (NotificationSettings *)mergeNotificationSettings:(NotificationSettings *)primary secondary:(NotificationSettings *)secondary {
    if (primary == nil) {
        return secondary;
    }
    if (secondary == nil) {
        return primary;
    }
    
    NSNumber *mergedEmail = primary.email != nil ? primary.email : secondary.email;
    NSNumber *mergedPush = primary.push != nil ? primary.push : secondary.push;
    NSNumber *mergedSms = primary.sms != nil ? primary.sms : secondary.sms;
    
    return [[NotificationSettings alloc] initWithEmail:mergedEmail push:mergedPush sms:mergedSms];
}

- (PrivacySettings *)mergePrivacySettings:(PrivacySettings *)primary secondary:(PrivacySettings *)secondary {
    if (primary == nil) {
        return secondary;
    }
    if (secondary == nil) {
        return primary;
    }
    
    NSString *mergedProfileVisibility = primary.profileVisibility != nil ? primary.profileVisibility : secondary.profileVisibility;
    NSNumber *mergedDataSharing = primary.dataSharing != nil ? primary.dataSharing : secondary.dataSharing;
    NSNumber *mergedAnalytics = primary.analytics != nil ? primary.analytics : secondary.analytics;
    
    return [[PrivacySettings alloc] initWithProfileVisibility:mergedProfileVisibility
                                                  dataSharing:mergedDataSharing
                                                    analytics:mergedAnalytics];
}

@end

@implementation ApiService

- (id)handleApiResponse:(ApiResponse *)response {
    // Manual nil checking for API responses
    if (response != nil) {
        if (response.error == nil) {
            return response.data;
        }
    }
    return nil;
}

- (NSString *)getErrorMessage:(ApiResponse *)response {
    // Manual error message extraction
    if (response != nil) {
        if (response.error != nil) {
            if (response.error.message != nil) {
                NSString *trimmedMessage = [response.error.message stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                if (trimmedMessage.length > 0) {
                    return response.error.message;
                }
            }
            if (response.error.code != nil) {
                return [NSString stringWithFormat:@"Error code: %@", response.error.code];
            }
        }
    }
    return @"Unknown error occurred";
}

- (NSDictionary<NSString *,NSString *> *)getResponseMetadata:(ApiResponse *)response {
    // Manual metadata extraction
    NSMutableDictionary *result = [[NSMutableDictionary alloc] init];
    
    if (response != nil) {
        if (response.metadata != nil) {
            if (response.metadata.timestamp != nil) {
                result[@"timestamp"] = [response.metadata.timestamp stringValue];
            }
            if (response.metadata.version != nil) {
                result[@"version"] = response.metadata.version;
            }
            if (response.metadata.requestId != nil) {
                result[@"requestId"] = response.metadata.requestId;
            }
        }
    }
    
    return [result copy];
}

- (BOOL)validateApiResponse:(ApiResponse *)response {
    // Complex manual validation
    if (response != nil) {
        if (response.data != nil && response.error == nil) {
            if (response.metadata != nil) {
                if (response.metadata.timestamp != nil) {
                    if ([response.metadata.timestamp longLongValue] > 0) {
                        return YES;
                    }
                }
            }
        }
    }
    return NO;
}

- (NSArray<NSString *> *)processApiErrorDetails:(ApiResponse *)response {
    // Manual error details processing
    NSMutableArray *result = [[NSMutableArray alloc] init];
    
    if (response != nil) {
        if (response.error != nil) {
            if (response.error.details != nil) {
                for (NSString *key in response.error.details) {
                    NSString *value = response.error.details[key];
                    NSString *trimmedKey = [key stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                    NSString *trimmedValue = [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                    
                    if (trimmedKey.length > 0 && trimmedValue.length > 0) {
                        [result addObject:[NSString stringWithFormat:@"%@: %@", key, value]];
                    }
                }
            }
        }
    }
    
    return [result copy];
}

@end

@implementation ConfigService

- (BOOL)isConfigValid:(AppConfig *)config {
    // Manual configuration validation
    if (config != nil) {
        if (config.apiUrl != nil) {
            NSString *trimmedUrl = [config.apiUrl stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            if (trimmedUrl.length > 0) {
                if (config.apiKey != nil) {
                    NSString *trimmedKey = [config.apiKey stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                    if (trimmedKey.length > 0) {
                        if (config.features != nil && config.cache != nil && config.analytics != nil) {
                            return YES;
                        }
                    }
                }
            }
        }
    }
    return NO;
}

- (NSString *)getApiEndpoint:(AppConfig *)config path:(NSString *)path {
    // Manual URL construction
    if (config != nil) {
        if (config.apiUrl != nil) {
            NSString *trimmedUrl = [config.apiUrl stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            if (trimmedUrl.length > 0) {
                if (path != nil) {
                    NSString *trimmedPath = [path stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                    if (trimmedPath.length > 0) {
                        return [NSString stringWithFormat:@"%@/%@", config.apiUrl, path];
                    }
                }
                return config.apiUrl;
            }
        }
    }
    return nil;
}

- (BOOL)isFeatureEnabled:(AppConfig *)config featureName:(NSString *)featureName {
    // Manual feature flag checking
    if (config != nil) {
        if (config.features != nil) {
            if ([featureName isEqualToString:@"newUI"]) {
                return config.features.enableNewUI != nil ? [config.features.enableNewUI boolValue] : NO;
            } else if ([featureName isEqualToString:@"betaFeatures"]) {
                return config.features.betaFeatures != nil ? [config.features.betaFeatures boolValue] : NO;
            } else if ([featureName isEqualToString:@"experimentalMode"]) {
                return config.features.experimentalMode != nil ? [config.features.experimentalMode boolValue] : NO;
            }
        }
    }
    return NO;
}

- (NSArray *)getCacheSettings:(AppConfig *)config {
    // Manual cache configuration extraction
    BOOL enabled = NO;
    long long maxSize = 0;
    long long ttl = 0;
    
    if (config != nil) {
        if (config.cache != nil) {
            enabled = config.cache.enabled != nil ? [config.cache.enabled boolValue] : NO;
            maxSize = config.cache.maxSize != nil ? [config.cache.maxSize longLongValue] : 0;
            ttl = config.cache.ttl != nil ? [config.cache.ttl longLongValue] : 0;
        }
    }
    
    return @[@(enabled), @(maxSize), @(ttl)];
}

- (NSDictionary<NSString *,id> *)getAnalyticsConfig:(AppConfig *)config {
    // Manual analytics configuration extraction
    NSMutableDictionary *result = [[NSMutableDictionary alloc] init];
    
    if (config != nil) {
        if (config.analytics != nil) {
            if (config.analytics.enabled != nil) {
                result[@"enabled"] = config.analytics.enabled;
            }
            if (config.analytics.trackingId != nil) {
                NSString *trimmedId = [config.analytics.trackingId stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                if (trimmedId.length > 0) {
                    result[@"trackingId"] = config.analytics.trackingId;
                }
            }
            if (config.analytics.samplingRate != nil) {
                if ([config.analytics.samplingRate doubleValue] > 0.0) {
                    result[@"samplingRate"] = config.analytics.samplingRate;
                }
            }
        }
    }
    
    return [result copy];
}

@end

@implementation DataProcessor

- (NSArray<NSString *> *)processUserList:(NSArray<User *> *)users {
    // Manual processing of nullable list with nullable elements
    NSMutableArray *result = [[NSMutableArray alloc] init];
    
    if (users != nil) {
        for (User *user in users) {
            if (user != nil) {
                if (user.name != nil) {
                    NSString *trimmedName = [user.name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                    if (trimmedName.length > 0) {
                        [result addObject:user.name];
                    }
                }
            }
        }
    }
    
    return [result copy];
}

- (NSArray<User *> *)getUsersByCity:(NSArray<User *> *)users city:(NSString *)city {
    // Manual filtering with nested nil checks
    NSMutableArray *result = [[NSMutableArray alloc] init];
    
    if (users != nil && city != nil) {
        for (User *user in users) {
            if (user != nil) {
                if (user.address != nil) {
                    if (user.address.city != nil) {
                        if ([user.address.city caseInsensitiveCompare:city] == NSOrderedSame) {
                            [result addObject:user];
                        }
                    }
                }
            }
        }
    }
    
    return [result copy];
}

- (NSDictionary<NSString *,NSNumber *> *)calculateUserStats:(NSArray<User *> *)users {
    // Manual statistics calculation
    NSMutableArray *validUsers = [[NSMutableArray alloc] init];
    
    if (users != nil) {
        for (User *user in users) {
            if (user != nil) {
                [validUsers addObject:user];
            }
        }
    }
    
    int withEmail = 0;
    int withPhone = 0;
    int withAddress = 0;
    int withPreferences = 0;
    
    for (User *user in validUsers) {
        if (user.email != nil) {
            if ([user.email containsString:@"@"]) {
                withEmail++;
            }
        }
        
        if (user.phone != nil) {
            NSString *trimmedPhone = [user.phone stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            if (trimmedPhone.length > 0) {
                withPhone++;
            }
        }
        
        if (user.address != nil) {
            withAddress++;
        }
        
        if (user.preferences != nil) {
            withPreferences++;
        }
    }
    
    return @{
        @"total": @(validUsers.count),
        @"withEmail": @(withEmail),
        @"withPhone": @(withPhone),
        @"withAddress": @(withAddress),
        @"withPreferences": @(withPreferences)
    };
}

- (NSSet<NSString *> *)extractContactEmails:(NSArray<User *> *)users {
    // Manual email extraction and deduplication
    NSMutableSet *emails = [[NSMutableSet alloc] init];
    
    if (users != nil) {
        for (User *user in users) {
            if (user != nil) {
                if (user.email != nil) {
                    if ([user.email containsString:@"@"]) {
                        NSString *trimmedEmail = [user.email stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                        if (trimmedEmail.length > 0) {
                            [emails addObject:user.email];
                        }
                    }
                }
            }
        }
    }
    
    return [emails copy];
}

- (NSDictionary<NSString *,NSArray<User *> *> *)groupUsersByCountry:(NSArray<User *> *)users {
    // Manual grouping with nested navigation
    NSMutableDictionary *result = [[NSMutableDictionary alloc] init];
    
    if (users != nil) {
        for (User *user in users) {
            if (user != nil) {
                NSString *country = @"Unknown";
                if (user.address != nil) {
                    if (user.address.country != nil) {
                        NSString *trimmedCountry = [user.address.country stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                        if (trimmedCountry.length > 0) {
                            country = user.address.country;
                        }
                    }
                }
                
                if (result[country] == nil) {
                    result[country] = [[NSMutableArray alloc] init];
                }
                [result[country] addObject:user];
            }
        }
    }
    
    return [result copy];
}

@end

@implementation StringUtils

- (NSString *)safeSubstring:(NSString *)text start:(NSInteger)start end:(NSNumber *)end {
    // Manual string operations with nil checks
    if (text != nil) {
        if (text.length > start) {
            NSInteger endIndex;
            if (end != nil) {
                endIndex = MIN([end integerValue], text.length);
            } else {
                endIndex = text.length;
            }
            
            if (start < endIndex) {
                return [text substringWithRange:NSMakeRange(start, endIndex - start)];
            }
        }
    }
    return nil;
}

- (NSString *)safeStringJoin:(NSArray<NSString *> *)strings separator:(NSString *)separator {
    // Manual string joining with nil filtering
    NSMutableArray *validStrings = [[NSMutableArray alloc] init];
    
    if (strings != nil) {
        for (NSString *string in strings) {
            if (string != nil) {
                NSString *trimmedString = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                if (trimmedString.length > 0) {
                    [validStrings addObject:string];
                }
            }
        }
    }
    
    if (validStrings.count > 0) {
        NSString *sep = separator != nil ? separator : @",";
        return [validStrings componentsJoinedByString:sep];
    }
    
    return nil;
}

- (NSString *)safeStringFormat:(NSString *)template args:(NSArray *)args {
    // Manual string formatting with nil handling
    if (template != nil) {
        NSString *trimmedTemplate = [template stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if (trimmedTemplate.length > 0) {
            NSMutableArray *safeArgs = [[NSMutableArray alloc] init];
            if (args != nil) {
                for (id arg in args) {
                    if (arg != nil) {
                        [safeArgs addObject:arg];
                    } else {
                        [safeArgs addObject:@"null"];
                    }
                }
            }
            
            // Simplified string formatting (would need more complex implementation in real code)
            return template;
        }
    }
    return nil;
}

- (NSArray<NSNumber *> *)extractNumbers:(NSString *)text {
    // Manual number extraction from nullable string
    NSMutableArray *numbers = [[NSMutableArray alloc] init];
    
    if (text != nil) {
        NSError *error = nil;
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"\\d+" options:0 error:&error];
        
        if (regex != nil) {
            NSArray *matches = [regex matchesInString:text options:0 range:NSMakeRange(0, text.length)];
            
            for (NSTextCheckingResult *match in matches) {
                NSString *numberString = [text substringWithRange:match.range];
                NSNumber *number = @([numberString integerValue]);
                [numbers addObject:number];
            }
        }
    }
    
    return [numbers copy];
}

- (NSDictionary<NSString *,NSString *> *)parseKeyValuePairs:(NSString *)text delimiter:(NSString *)delimiter {
    // Manual parsing of key-value pairs
    NSMutableDictionary *result = [[NSMutableDictionary alloc] init];
    
    if (text != nil) {
        NSString *trimmedText = [text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if (trimmedText.length > 0) {
            NSString *delim = delimiter != nil ? delimiter : @"=";
            NSArray *lines = [text componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"\n;,"]];
            
            for (NSString *line in lines) {
                NSArray *parts = [line componentsSeparatedByString:delim];
                if (parts.count == 2) {
                    NSString *key = [parts[0] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                    NSString *value = [parts[1] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                    
                    if (key.length > 0 && value.length > 0) {
                        result[key] = value;
                    }
                }
            }
        }
    }
    
    return [result copy];
}

@end

@implementation IosSizeBenchmark

- (void)runBenchmark {
    UserService *userService = [[UserService alloc] init];
    ApiService *apiService = [[ApiService alloc] init];
    ConfigService *configService = [[ConfigService alloc] init];
    DataProcessor *dataProcessor = [[DataProcessor alloc] init];
    StringUtils *stringUtils = [[StringUtils alloc] init];
    
    // Create test data with nullable fields - extremely verbose in Objective-C
    NSArray<User *> *users = @[
        [[User alloc] initWithId:@"1" 
                            name:@"John Doe" 
                           email:@"john@example.com" 
                           phone:@"+1234567890"
                         address:[[Address alloc] initWithStreet:@"123 Main St" 
                                                            city:@"New York" 
                                                           state:@"NY" 
                                                         zipCode:@"10001" 
                                                         country:@"USA"]
                     preferences:[[UserPreferences alloc] initWithTheme:@"dark" 
                                                               language:@"en"
                                                          notifications:[[NotificationSettings alloc] initWithEmail:@YES push:@NO sms:@YES]
                                                                privacy:[[PrivacySettings alloc] initWithProfileVisibility:@"public" dataSharing:@YES analytics:@NO]]],
        [[User alloc] initWithId:@"2" name:nil email:nil phone:nil address:nil preferences:nil],
        [[User alloc] initWithId:@"3" 
                            name:@"Jane Smith" 
                           email:@"jane@test.com" 
                           phone:nil
                         address:[[Address alloc] initWithStreet:nil city:@"Los Angeles" state:nil zipCode:nil country:@"USA"] 
                     preferences:nil]
    ];
    
    NSArray<ApiResponse *> *apiResponses = @[
        [[ApiResponse alloc] initWithData:@"success" 
                                    error:nil 
                                 metadata:[[ResponseMetadata alloc] initWithTimestamp:@([[NSDate date] timeIntervalSince1970] * 1000) version:@"1.0" requestId:@"req-123"]],
        [[ApiResponse alloc] initWithData:nil 
                                    error:[[ErrorInfo alloc] initWithCode:@"404" message:@"Not found" details:@{@"reason": @"User not found"}] 
                                 metadata:nil]
    ];
    
    NSArray<AppConfig *> *configs = @[
        [[AppConfig alloc] initWithApiUrl:@"https://api.example.com" 
                                   apiKey:@"key123"
                                 features:[[FeatureFlags alloc] initWithNewUI:@YES betaFeatures:@NO experimentalMode:nil]
                                    cache:[[CacheConfig alloc] initWithEnabled:@YES maxSize:@1024 ttl:@3600]
                                analytics:[[AnalyticsConfig alloc] initWithEnabled:@YES trackingId:@"GA-123" samplingRate:@0.1]],
        [[AppConfig alloc] initWithApiUrl:nil apiKey:nil features:nil cache:nil analytics:nil]
    ];
    
    // Test user service operations - extremely verbose nil checking in Objective-C
    for (User *user in users) {
        NSString *displayName = [userService getUserDisplayName:user];
        NSString *contactInfo = [userService getUserContactInfo:user];
        NSString *fullAddress = [userService getUserFullAddress:user];
        BOOL preferencesComplete = [userService isUserPreferencesComplete:user];
        User *updatedUser = [userService updateUserEmail:user newEmail:@"newemail@example.com"];
    }
    
    // Test user merging
    User *mergedUser = [userService mergeUserData:users[0] secondary:users[2]];
    
    // Test API service operations
    for (ApiResponse *response in apiResponses) {
        id data = [apiService handleApiResponse:response];
        NSString *errorMessage = [apiService getErrorMessage:response];
        NSDictionary *metadata = [apiService getResponseMetadata:response];
        BOOL isValid = [apiService validateApiResponse:response];
        NSArray *errorDetails = [apiService processApiErrorDetails:response];
    }
    
    // Test config service operations
    for (AppConfig *config in configs) {
        BOOL isValid = [configService isConfigValid:config];
        NSString *endpoint = [configService getApiEndpoint:config path:@"users"];
        BOOL newUIEnabled = [configService isFeatureEnabled:config featureName:@"newUI"];
        BOOL betaEnabled = [configService isFeatureEnabled:config featureName:@"betaFeatures"];
        NSArray *cacheSettings = [configService getCacheSettings:config];
        NSDictionary *analyticsConfig = [configService getAnalyticsConfig:config];
    }
    
    // Test data processing operations
    NSArray *userNames = [dataProcessor processUserList:users];
    NSArray *nyUsers = [dataProcessor getUsersByCity:users city:@"New York"];
    NSDictionary *userStats = [dataProcessor calculateUserStats:users];
    NSSet *emails = [dataProcessor extractContactEmails:users];
    NSDictionary *usersByCountry = [dataProcessor groupUsersByCountry:users];
    
    // Test string utility operations - more verbose than Kotlin extensions
    NSArray<NSString *> *testStrings = @[@"Hello World", @"", @"   ", @"Test123"];
    for (NSString *str in testStrings) {
        NSString *substring = [stringUtils safeSubstring:str start:2 end:@8];
        NSArray *numbers = [stringUtils extractNumbers:str];
    }
    
    NSArray<NSString *> *stringList = @[@"apple", @"banana", @"", @"cherry"];
    NSString *joinedString = [stringUtils safeStringJoin:stringList separator:@", "];
    
    NSString *formatResult = [stringUtils safeStringFormat:@"Hello %@, you have %d messages" args:@[@"John", @5]];
    
    NSString *kvText = @"name=John\nemail=john@example.com\nage=30";
    NSDictionary *kvPairs = [stringUtils parseKeyValuePairs:kvText delimiter:@"="];
    
    // Objective-C requires extremely verbose manual nil checking compared to Kotlin's elegant operators
}

@end