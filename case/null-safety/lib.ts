/*
 * iOS Size Benchmark - Test Case Implementation
 * Generated with Claude AI (https://claude.ai)
 *
 * scriptc (TypeScript-to-native) port of the Kotlin/Swift "null-safety" case.
 * Kotlin nullable types (`T?`) map to TS `T | null`; safe calls (`?.`) to
 * optional chaining; the elvis operator (`?:`) to `??`; `takeIf`/`let` chains
 * to explicit null checks. The same null-handling logic is preserved
 * one-for-one. A single exported entry (runBenchmark) exercises every type
 * and service so nothing is dead-code eliminated.
 */

// Test case: Null Safety - compile-time null safety via `T | null` + optional chaining

// User data model with nullable fields
class User {
  constructor(
    public readonly id: string,
    public readonly name: string | null,
    public readonly email: string | null,
    public readonly phone: string | null,
    public readonly address: Address | null,
    public readonly preferences: UserPreferences | null
  ) {}
}

class Address {
  constructor(
    public readonly street: string | null,
    public readonly city: string | null,
    public readonly state: string | null,
    public readonly zipCode: string | null,
    public readonly country: string | null
  ) {}
}

class UserPreferences {
  constructor(
    public readonly theme: string | null,
    public readonly language: string | null,
    public readonly notifications: NotificationSettings | null,
    public readonly privacy: PrivacySettings | null
  ) {}
}

class NotificationSettings {
  constructor(
    public readonly email: boolean | null,
    public readonly push: boolean | null,
    public readonly sms: boolean | null
  ) {}
}

class PrivacySettings {
  constructor(
    public readonly profileVisibility: string | null,
    public readonly dataSharing: boolean | null,
    public readonly analytics: boolean | null
  ) {}
}

// Network response models with nullable data
class ApiResponse<T> {
  constructor(
    public readonly data: T | null,
    public readonly error: ErrorInfo | null,
    public readonly metadata: ResponseMetadata | null
  ) {}
}

class ErrorInfo {
  constructor(
    public readonly code: string | null,
    public readonly message: string | null,
    public readonly details: Map<string, string> | null
  ) {}
}

class ResponseMetadata {
  constructor(
    public readonly timestamp: number | null,
    public readonly version: string | null,
    public readonly requestId: string | null
  ) {}
}

// Configuration classes with nullable settings
class AppConfig {
  constructor(
    public readonly apiUrl: string | null,
    public readonly apiKey: string | null,
    public readonly features: FeatureFlags | null,
    public readonly cache: CacheConfig | null,
    public readonly analytics: AnalyticsConfig | null
  ) {}
}

class FeatureFlags {
  constructor(
    public readonly newUI: boolean | null,
    public readonly betaFeatures: boolean | null,
    public readonly experimentalMode: boolean | null
  ) {}
}

class CacheConfig {
  constructor(
    public readonly enabled: boolean | null,
    public readonly maxSize: number | null,
    public readonly ttl: number | null
  ) {}
}

class AnalyticsConfig {
  constructor(
    public readonly enabled: boolean | null,
    public readonly trackingId: string | null,
    public readonly samplingRate: number | null
  ) {}
}

function isNotBlank(s: string): boolean { return s.trim().length > 0; }

// Service classes demonstrating null-safe operations
class UserService {
  getUserDisplayName(user: User | null): string {
    const name = user?.name;
    if (name !== null && name !== undefined && isNotBlank(name)) { return name; }
    return "Anonymous User";
  }

  getUserContactInfo(user: User | null): string {
    const rawEmail = user?.email;
    const rawPhone = user?.phone;
    const email = (rawEmail !== null && rawEmail !== undefined && rawEmail.includes("@")) ? rawEmail : null;
    const phone = (rawPhone !== null && rawPhone !== undefined && isNotBlank(rawPhone)) ? rawPhone : null;

    if (email !== null && phone !== null) { return `Email: ${email}, Phone: ${phone}`; }
    if (email !== null) { return `Email: ${email}`; }
    if (phone !== null) { return `Phone: ${phone}`; }
    return "No contact information available";
  }

  getUserFullAddress(user: User | null): string | null {
    const address = user?.address;
    if (address === null || address === undefined) { return null; }
    const parts: string[] = [];
    if (address.street !== null) { parts.push(address.street); }
    if (address.city !== null) { parts.push(address.city); }
    if (address.state !== null) { parts.push(address.state); }
    if (address.zipCode !== null) { parts.push(address.zipCode); }
    if (address.country !== null) { parts.push(address.country); }
    return parts.length > 0 ? parts.join(", ") : null;
  }

  isUserPreferencesComplete(user: User | null): boolean {
    const prefs = user?.preferences;
    if (prefs === null || prefs === undefined) { return false; }
    const notif = prefs.notifications;
    const notifComplete = notif !== null && notif.email !== null && notif.push !== null && notif.sms !== null;
    const privacy = prefs.privacy;
    const privacyComplete = privacy !== null && privacy.profileVisibility !== null &&
      privacy.dataSharing !== null && privacy.analytics !== null;
    return prefs.theme !== null && prefs.language !== null && notifComplete && privacyComplete;
  }

  updateUserEmail(user: User | null, newEmail: string | null): User | null {
    if (user === null) { return null; }
    if (newEmail !== null && newEmail.includes("@")) {
      return new User(user.id, user.name, newEmail, user.phone, user.address, user.preferences);
    }
    return null;
  }

  mergeUserData(primary: User | null, secondary: User | null): User | null {
    if (primary === null) { return secondary; }
    if (secondary === null) { return primary; }
    return new User(
      primary.id,
      primary.name ?? secondary.name,
      primary.email ?? secondary.email,
      primary.phone ?? secondary.phone,
      primary.address ?? secondary.address,
      this.mergePreferences(primary.preferences, secondary.preferences)
    );
  }

  mergePreferences(primary: UserPreferences | null, secondary: UserPreferences | null): UserPreferences | null {
    if (primary === null) { return secondary; }
    if (secondary === null) { return primary; }
    return new UserPreferences(
      primary.theme ?? secondary.theme,
      primary.language ?? secondary.language,
      this.mergeNotificationSettings(primary.notifications, secondary.notifications),
      this.mergePrivacySettings(primary.privacy, secondary.privacy)
    );
  }

  mergeNotificationSettings(primary: NotificationSettings | null, secondary: NotificationSettings | null): NotificationSettings | null {
    if (primary === null) { return secondary; }
    if (secondary === null) { return primary; }
    return new NotificationSettings(
      primary.email ?? secondary.email,
      primary.push ?? secondary.push,
      primary.sms ?? secondary.sms
    );
  }

  mergePrivacySettings(primary: PrivacySettings | null, secondary: PrivacySettings | null): PrivacySettings | null {
    if (primary === null) { return secondary; }
    if (secondary === null) { return primary; }
    return new PrivacySettings(
      primary.profileVisibility ?? secondary.profileVisibility,
      primary.dataSharing ?? secondary.dataSharing,
      primary.analytics ?? secondary.analytics
    );
  }
}

class ApiService {
  handleApiResponse<T>(response: ApiResponse<T> | null): T | null {
    if (response !== null && response.error === null) { return response.data; }
    return null;
  }

  getErrorMessage<T>(response: ApiResponse<T> | null): string {
    const message = response?.error?.message;
    if (message !== null && message !== undefined && isNotBlank(message)) { return message; }
    const code = response?.error?.code;
    if (code !== null && code !== undefined) { return `Error code: ${code}`; }
    return "Unknown error occurred";
  }

  getResponseMetadata<T>(response: ApiResponse<T> | null): Map<string, string> {
    const result = new Map<string, string>();
    const metadata = response?.metadata;
    if (metadata !== null && metadata !== undefined) {
      if (metadata.timestamp !== null) { result.set("timestamp", `${metadata.timestamp}`); }
      if (metadata.version !== null) { result.set("version", metadata.version); }
      if (metadata.requestId !== null) { result.set("requestId", metadata.requestId); }
    }
    return result;
  }

  validateApiResponse<T>(response: ApiResponse<T> | null): boolean {
    if (response === null) { return false; }
    const metadata = response.metadata;
    const metaValid = metadata !== null && metadata.timestamp !== null && metadata.timestamp > 0;
    return response.data !== null && response.error === null && metaValid;
  }

  processApiErrorDetails<T>(response: ApiResponse<T> | null): string[] {
    const result: string[] = [];
    const details = response?.error?.details;
    if (details !== null && details !== undefined) {
      for (const entry of details) {
        const key = entry[0];
        const value = entry[1];
        if (isNotBlank(key) && isNotBlank(value)) { result.push(`${key}: ${value}`); }
      }
    }
    return result;
  }
}

type ConfigValue = string | number | boolean;

class ConfigService {
  isConfigValid(config: AppConfig | null): boolean {
    if (config === null) { return false; }
    const apiUrlValid = config.apiUrl !== null && isNotBlank(config.apiUrl);
    const apiKeyValid = config.apiKey !== null && isNotBlank(config.apiKey);
    return apiUrlValid && apiKeyValid && config.features !== null &&
      config.cache !== null && config.analytics !== null;
  }

  getApiEndpoint(config: AppConfig | null, path: string | null): string | null {
    const baseUrl = config?.apiUrl;
    if (baseUrl === null || baseUrl === undefined || !isNotBlank(baseUrl)) { return null; }
    if (path !== null && isNotBlank(path)) { return `${baseUrl}/${path}`; }
    return baseUrl;
  }

  isFeatureEnabled(config: AppConfig | null, featureName: string): boolean {
    switch (featureName) {
      case "newUI": return config?.features?.newUI ?? false;
      case "betaFeatures": return config?.features?.betaFeatures ?? false;
      case "experimentalMode": return config?.features?.experimentalMode ?? false;
      default: return false;
    }
  }

  getCacheSettings(config: AppConfig | null): [boolean, number, number] {
    const cache = config?.cache;
    return [
      cache?.enabled ?? false,
      cache?.maxSize ?? 0,
      cache?.ttl ?? 0
    ];
  }

  getAnalyticsConfig(config: AppConfig | null): Map<string, ConfigValue> {
    const result = new Map<string, ConfigValue>();
    const analytics = config?.analytics;
    if (analytics !== null && analytics !== undefined) {
      if (analytics.enabled !== null) { result.set("enabled", analytics.enabled); }
      if (analytics.trackingId !== null && isNotBlank(analytics.trackingId)) { result.set("trackingId", analytics.trackingId); }
      if (analytics.samplingRate !== null && analytics.samplingRate > 0.0) { result.set("samplingRate", analytics.samplingRate); }
    }
    return result;
  }
}

class DataProcessor {
  processUserList(users: Array<User | null> | null): string[] {
    const result: string[] = [];
    if (users === null) { return result; }
    for (const user of users) {
      const name = user?.name;
      if (name !== null && name !== undefined && isNotBlank(name)) { result.push(name); }
    }
    return result;
  }

  getUsersByCity(users: Array<User | null> | null, city: string | null): User[] {
    const result: User[] = [];
    if (users === null || city === null) { return result; }
    for (const user of users) {
      const userCity = user?.address?.city;
      if (userCity !== null && userCity !== undefined && userCity.toLowerCase() === city.toLowerCase()) {
        result.push(user as User);
      }
    }
    return result;
  }

  calculateUserStats(users: Array<User | null> | null): Map<string, number> {
    const validUsers: User[] = [];
    if (users !== null) {
      for (const user of users) { if (user !== null) { validUsers.push(user); } }
    }
    let withEmail = 0;
    let withPhone = 0;
    let withAddress = 0;
    let withPreferences = 0;
    for (const user of validUsers) {
      if (user.email !== null && user.email.includes("@")) { withEmail++; }
      if (user.phone !== null && isNotBlank(user.phone)) { withPhone++; }
      if (user.address !== null) { withAddress++; }
      if (user.preferences !== null) { withPreferences++; }
    }
    const stats = new Map<string, number>();
    stats.set("total", validUsers.length);
    stats.set("withEmail", withEmail);
    stats.set("withPhone", withPhone);
    stats.set("withAddress", withAddress);
    stats.set("withPreferences", withPreferences);
    return stats;
  }

  extractContactEmails(users: Array<User | null> | null): Set<string> {
    const emails = new Set<string>();
    if (users === null) { return emails; }
    for (const user of users) {
      const email = user?.email;
      if (email !== null && email !== undefined && email.includes("@") && isNotBlank(email)) {
        emails.add(email);
      }
    }
    return emails;
  }

  groupUsersByCountry(users: Array<User | null> | null): Map<string, User[]> {
    const result = new Map<string, User[]>();
    if (users === null) { return result; }
    for (const user of users) {
      if (user === null) { continue; }
      const rawCountry = user.address?.country;
      const country = (rawCountry !== null && rawCountry !== undefined && isNotBlank(rawCountry)) ? rawCountry : "Unknown";
      let arr = result.get(country);
      if (arr === undefined) { arr = []; result.set(country, arr); }
      arr.push(user);
    }
    return result;
  }
}

// Kotlin String.toIntOrNull / toDoubleOrNull equivalents (return null on
// blank or non-numeric input rather than JS's NaN/0 coercions).
function toIntOrNull(s: string): number | null {
  if (s.trim().length === 0) { return null; }
  const n = Number(s);
  if (n !== n || !Number.isInteger(n)) { return null; }
  return n;
}

function toDoubleOrNull(s: string): number | null {
  if (s.trim().length === 0) { return null; }
  const n = Number(s);
  return n !== n ? null : n;
}

class StringUtils {
  safeSubstring(text: string | null, start: number, end: number | null): string | null {
    if (text === null || text.length <= start) { return null; }
    const endIndex = end !== null ? Math.min(end, text.length) : text.length;
    if (start < endIndex) { return text.substring(start, endIndex); }
    return null;
  }

  safeStringJoin(strings: Array<string | null> | null, separator: string | null): string | null {
    if (strings === null) { return null; }
    const valid: string[] = [];
    for (const s of strings) {
      if (s !== null && isNotBlank(s)) { valid.push(s); }
    }
    if (valid.length === 0) { return null; }
    return valid.join(separator ?? ",");
  }

  safeStringFormat(template: string | null, args: Array<string | number | boolean | null>): string | null {
    if (template === null || !isNotBlank(template)) { return null; }
    const safeArgs: string[] = [];
    for (const arg of args) { safeArgs.push(arg === null ? "null" : `${arg}`); }
    // Simplified formatting for cross-platform compatibility (matches Kotlin).
    return template;
  }

  extractNumbers(text: string | null): number[] {
    const result: number[] = [];
    if (text === null) { return result; }
    const matches = text.match(/\d+/g);
    if (matches !== null) {
      for (const m of matches) {
        const n = toIntOrNull(m);
        if (n !== null) { result.push(n); }
      }
    }
    return result;
  }

  parseKeyValuePairs(text: string | null, delimiter: string | null): Map<string, string> {
    const result = new Map<string, string>();
    if (text === null || !isNotBlank(text)) { return result; }
    const delim = delimiter ?? "=";
    const lines = text.split(/[\n;,]/);
    for (const line of lines) {
      const idx = line.indexOf(delim);
      if (idx < 0) { continue; }
      const key = line.substring(0, idx).trim();
      const value = line.substring(idx + delim.length).trim();
      if (isNotBlank(key) && isNotBlank(value)) { result.set(key, value); }
    }
    return result;
  }
}

class IosSizeBenchmark {
  readonly userService = new UserService();
  readonly apiService = new ApiService();
  readonly configService = new ConfigService();
  readonly dataProcessor = new DataProcessor();
  readonly stringUtils = new StringUtils();

  runBenchmark(): void {
    // Create test data with nullable fields
    const users: Array<User | null> = [
      new User("1", "John Doe", "john@example.com", "+1234567890",
        new Address("123 Main St", "New York", "NY", "10001", "USA"),
        new UserPreferences("dark", "en",
          new NotificationSettings(true, false, true),
          new PrivacySettings("public", true, false))),
      new User("2", null, null, null, null, null),
      new User("3", "Jane Smith", "jane@test.com", null,
        new Address(null, "Los Angeles", null, null, "USA"), null),
      null
    ];

    const detailsMap = new Map<string, string>();
    detailsMap.set("reason", "User not found");
    const apiResponses: Array<ApiResponse<string> | null> = [
      new ApiResponse<string>("success", null, new ResponseMetadata(1234567890, "1.0", "req-123")),
      new ApiResponse<string>(null, new ErrorInfo("404", "Not found", detailsMap), null),
      null
    ];

    const configs: Array<AppConfig | null> = [
      new AppConfig("https://api.example.com", "key123",
        new FeatureFlags(true, false, null),
        new CacheConfig(true, 1024, 3600),
        new AnalyticsConfig(true, "GA-123", 0.1)),
      new AppConfig(null, null, null, null, null),
      null
    ];

    // Test user service operations
    let displayNameLen = 0;
    let contactLen = 0;
    let addressCount = 0;
    let prefsCompleteCount = 0;
    let updatedCount = 0;
    for (const user of users) {
      displayNameLen += this.userService.getUserDisplayName(user).length;
      contactLen += this.userService.getUserContactInfo(user).length;
      const fullAddress = this.userService.getUserFullAddress(user);
      if (fullAddress !== null) { addressCount++; }
      if (this.userService.isUserPreferencesComplete(user)) { prefsCompleteCount++; }
      const updatedUser = this.userService.updateUserEmail(user, "newemail@example.com");
      if (updatedUser !== null) { updatedCount++; }
    }

    // Test user merging
    const mergedUser = this.userService.mergeUserData(users[0], users[2]);

    // Test API service operations
    let dataCount = 0;
    let errorMsgLen = 0;
    let metadataCount = 0;
    let validCount = 0;
    let errorDetailCount = 0;
    for (const response of apiResponses) {
      const data = this.apiService.handleApiResponse(response);
      if (data !== null) { dataCount++; }
      errorMsgLen += this.apiService.getErrorMessage(response).length;
      metadataCount += this.apiService.getResponseMetadata(response).size;
      if (this.apiService.validateApiResponse(response)) { validCount++; }
      errorDetailCount += this.apiService.processApiErrorDetails(response).length;
    }

    // Test config service operations
    let configValidCount = 0;
    let endpointCount = 0;
    let newUICount = 0;
    let betaCount = 0;
    let cacheMaxTotal = 0;
    let analyticsCount = 0;
    for (const config of configs) {
      if (this.configService.isConfigValid(config)) { configValidCount++; }
      const endpoint = this.configService.getApiEndpoint(config, "users");
      if (endpoint !== null) { endpointCount++; }
      if (this.configService.isFeatureEnabled(config, "newUI")) { newUICount++; }
      if (this.configService.isFeatureEnabled(config, "betaFeatures")) { betaCount++; }
      const cacheSettings = this.configService.getCacheSettings(config);
      cacheMaxTotal += cacheSettings[1];
      analyticsCount += this.configService.getAnalyticsConfig(config).size;
    }

    // Test data processing operations
    const userNames = this.dataProcessor.processUserList(users);
    const nyUsers = this.dataProcessor.getUsersByCity(users, "New York");
    const userStats = this.dataProcessor.calculateUserStats(users);
    const emails = this.dataProcessor.extractContactEmails(users);
    const usersByCountry = this.dataProcessor.groupUsersByCountry(users);

    // Test string utility operations
    const testStrings: Array<string | null> = ["Hello World", null, "", "   ", "Test123"];
    let substringCount = 0;
    let numberCount = 0;
    for (const str of testStrings) {
      const substring = this.stringUtils.safeSubstring(str, 2, 8);
      if (substring !== null) { substringCount++; }
      numberCount += this.stringUtils.extractNumbers(str).length;
    }

    const stringList: Array<string | null> = ["apple", null, "banana", "", "cherry"];
    const joinedString = this.stringUtils.safeStringJoin(stringList, ", ");

    const formatResult = this.stringUtils.safeStringFormat("Hello %s, you have %d messages", ["John", 5]);

    const kvText = "name=John\nemail=john@example.com\nage=30";
    const kvPairs = this.stringUtils.parseKeyValuePairs(kvText, "=");

    // Complex null-safe operations chains
    let complexResult = "No email notifications configured";
    const firstUser = users.length > 0 ? users[0] : null;
    const notifications = firstUser?.preferences?.notifications;
    if (notifications !== null && notifications !== undefined && notifications.email === true) {
      const email = firstUser?.email;
      if (email !== null && email !== undefined && email.includes("@")) {
        complexResult = `Email notifications enabled for ${email}`;
      }
    }

    // Safe collection operations
    const validEmails: string[] = [];
    for (const user of users) {
      const email = user?.email;
      if (email !== null && email !== undefined && email.includes("@")) { validEmails.push(email); }
    }

    const addressSummary: string[] = [];
    for (const user of users) {
      const address = user?.address;
      if (address !== null && address !== undefined) {
        const parts: string[] = [];
        if (address.city !== null) { parts.push(address.city); }
        if (address.state !== null) { parts.push(address.state); }
        if (address.country !== null) { parts.push(address.country); }
        if (parts.length > 0) { addressSummary.push(parts.join(", ")); }
      }
    }

    // Null-safe error handling patterns
    const processedConfigs: Array<Map<string, string>> = [];
    for (const config of configs) {
      if (config !== null && this.configService.isConfigValid(config)) {
        const configMap = new Map<string, string>();
        configMap.set("apiUrl", config.apiUrl ?? "");
        configMap.set("hasFeatures", `${config.features !== null}`);
        configMap.set("cacheEnabled", `${config.cache?.enabled ?? false}`);
        processedConfigs.push(configMap);
      }
    }

    // Safe numeric operations
    const numericData: Array<string | null> = ["123", null, "456.78", "invalid", "789"];
    const validNumbers: number[] = [];
    for (const str of numericData) {
      if (str !== null) {
        const n = toDoubleOrNull(str);
        if (n !== null) { validNumbers.push(n); }
      }
    }
    let sum = 0.0;
    for (const n of validNumbers) { sum += n; }
    const average = validNumbers.length > 0 ? sum / validNumbers.length : 0.0;

    // Safe date/time operations simulation
    const timestamps: Array<number | null> = [1234567890, null, 0, -1, 987654321];
    const validTimestamps: number[] = [];
    for (const timestamp of timestamps) {
      if (timestamp !== null && timestamp > 0) { validTimestamps.push(timestamp); }
    }

    // Null-safe resource management patterns
    const resourcePaths: Array<string | null> = ["/path/to/file.txt", null, "", "/another/path"];
    const validPaths: string[] = [];
    for (const path of resourcePaths) {
      if (path !== null && isNotBlank(path) && path.startsWith("/")) { validPaths.push(path); }
    }

    console.log("Null-safety benchmark completed:");
    console.log(`- displayNameLen: ${displayNameLen}, contactLen: ${contactLen}, addressCount: ${addressCount}, prefsComplete: ${prefsCompleteCount}, updated: ${updatedCount}`);
    console.log(`- mergedUser: ${mergedUser === null ? "null" : mergedUser.id}`);
    console.log(`- dataCount: ${dataCount}, errorMsgLen: ${errorMsgLen}, metadataCount: ${metadataCount}, validCount: ${validCount}, errorDetails: ${errorDetailCount}`);
    console.log(`- configValid: ${configValidCount}, endpoints: ${endpointCount}, newUI: ${newUICount}, beta: ${betaCount}, cacheMax: ${cacheMaxTotal}, analytics: ${analyticsCount}`);
    console.log(`- userNames: ${userNames.length}, nyUsers: ${nyUsers.length}, stats total: ${userStats.get("total")}, emails: ${emails.size}, countries: ${usersByCountry.size}`);
    console.log(`- substrings: ${substringCount}, numbers: ${numberCount}, joined: ${joinedString}, format: ${formatResult}, kvPairs: ${kvPairs.size}`);
    console.log(`- complexResult: ${complexResult}`);
    console.log(`- validEmails: ${validEmails.length}, addressSummary: ${addressSummary.length}, processedConfigs: ${processedConfigs.length}`);
    console.log(`- validNumbers: ${validNumbers.length}, sum: ${sum}, average: ${average}, validTimestamps: ${validTimestamps.length}, validPaths: ${validPaths.length}`);
  }
}

export function runBenchmark(): void {
  const benchmark = new IosSizeBenchmark();
  benchmark.runBenchmark();
}






