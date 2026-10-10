/*
 * iOS Size Benchmark - Test Case Implementation
 * Generated with Claude AI (https://claude.ai)
 *
 * scriptc (TypeScript-to-native) port of the Kotlin/Swift "extension-
 * functions" case. Kotlin extension functions/properties have no direct
 * TypeScript equivalent, so each is modeled as a free function that takes the
 * receiver as its first argument (`self`), named `<receiver><Member>` (e.g.
 * `String.isValidEmail()` -> `strIsValidEmail(self)`, `Int.isPrime()` ->
 * `intIsPrime(self)`, `List<T>.second()` -> `lstSecond(self)`). Behavior and
 * call sites are preserved. A single exported entry (runBenchmark) exercises
 * every type and function so nothing is dead-code eliminated.
 */

// Test case: Extension Functions - Kotlin extensions modeled as free functions

// Kotlin Pair<A, B> has no static-tier structural analogue; small class.
class Pair<A, B> {
  constructor(public readonly first: A, public readonly second: B) {}
}

// Narrow union for Kotlin's Map<String, Any> analysis payloads (no `any`).
type AnalysisValue = string | number | boolean | string[] | Map<string, number>;

// Platform-specific current time (mock timestamp, matches Kotlin).
function getCurrentTimeMillis(): number {
  return 1640995200000;
}

// --- Char/string primitives (Kotlin Char.isX helpers over ASCII) ---
function isDigitCh(c: string): boolean {
  const n = c.charCodeAt(0);
  return n >= 48 && n <= 57;
}

function isLetterCh(c: string): boolean {
  const n = c.charCodeAt(0);
  return (n >= 65 && n <= 90) || (n >= 97 && n <= 122);
}

function isUpperCh(c: string): boolean {
  const n = c.charCodeAt(0);
  return n >= 65 && n <= 90;
}

function isLowerCh(c: string): boolean {
  const n = c.charCodeAt(0);
  return n >= 97 && n <= 122;
}

function isLetterOrDigitCh(c: string): boolean {
  return isLetterCh(c) || isDigitCh(c);
}

function capitalizeFirst(s: string): string {
  if (s.length === 0) {
    return s;
  }
  return s.charAt(0).toUpperCase() + s.slice(1);
}

function reverseStr(s: string): string {
  let out = "";
  for (let i = s.length - 1; i >= 0; i--) {
    out += s.charAt(i);
  }
  return out;
}

// Kotlin substringAfter(delimiter): everything after the first occurrence, or
// the whole string if the delimiter is absent.
function substringAfter(s: string, delimiter: string): string {
  const idx = s.indexOf(delimiter);
  return idx === -1 ? s : s.slice(idx + delimiter.length);
}

// Kotlin substringAfterLast(delimiter, missingDelimiterValue).
function substringAfterLast(s: string, delimiter: string, missing: string): string {
  const idx = s.lastIndexOf(delimiter);
  return idx === -1 ? missing : s.slice(idx + delimiter.length);
}

// Kotlin substringBefore(delimiter): everything before first occurrence.
function substringBefore(s: string, delimiter: string): string {
  const idx = s.indexOf(delimiter);
  return idx === -1 ? s : s.slice(0, idx);
}

// Kotlin substringBeforeLast(delimiter): everything before last occurrence,
// or the whole string if absent.
function substringBeforeLast(s: string, delimiter: string): string {
  const idx = s.lastIndexOf(delimiter);
  return idx === -1 ? s : s.slice(0, idx);
}

function removePrefix(s: string, prefix: string): string {
  return s.startsWith(prefix) ? s.slice(prefix.length) : s;
}

function padStart2(n: number): string {
  const s = `${n}`;
  return s.length >= 2 ? s : "0".repeat(2 - s.length) + s;
}

function averageOf(values: number[]): number {
  if (values.length === 0) {
    return 0.0;
  }
  let total = 0;
  for (const v of values) {
    total += v;
  }
  return total / values.length;
}

// Kotlin String.toDoubleOrNull(): null on blank/non-numeric input.
function toDoubleOrNull(text: string): number | null {
  if (text.trim().length === 0) {
    return null;
  }
  let seenDot = false;
  let start = 0;
  const first = text.charAt(0);
  if (first === "-" || first === "+") {
    start = 1;
  }
  if (start >= text.length) {
    return null;
  }
  for (let i = start; i < text.length; i++) {
    const ch = text.charAt(i);
    if (ch === ".") {
      if (seenDot) {
        return null;
      }
      seenDot = true;
    } else if (!isDigitCh(ch)) {
      return null;
    }
  }
  return Number(text);
}

// --- String extensions ---
function strIsValidEmail(self: string): boolean {
  return self.includes("@") && self.includes(".") && self.length > 5;
}

function strIsValidPhone(self: string): boolean {
  const cleaned = self.replace(/[^0-9]/g, "");
  return cleaned.length >= 10 && cleaned.length <= 15;
}

function strToTitleCase(self: string): string {
  return self
    .split(" ")
    .map((word) => capitalizeFirst(word.toLowerCase()))
    .join(" ");
}

function strToCamelCase(self: string): string {
  return self
    .split(/[ _-]/)
    .filter((it) => it.length > 0)
    .map((word, index) => (index === 0 ? word.toLowerCase() : capitalizeFirst(word.toLowerCase())))
    .join("");
}

function strToSnakeCase(self: string): string {
  return self
    .replace(/([a-z])([A-Z])/g, "$1_$2")
    .replace(/ /g, "_")
    .replace(/-/g, "_")
    .toLowerCase();
}

function strTruncate(self: string, maxLength: number, suffix: string): string {
  return self.length <= maxLength ? self : self.slice(0, maxLength - suffix.length) + suffix;
}

function strRemoveWhitespace(self: string): string {
  return self.replace(/\s/g, "");
}

function strCountWords(self: string): number {
  return self.trim().split(/\s+/).length;
}

function strReverse(self: string): string {
  return reverseStr(self);
}

function strIsPalindrome(self: string): boolean {
  const cleaned = strRemoveWhitespace(self).toLowerCase();
  return cleaned === reverseStr(cleaned);
}

function strExtractNumbers(self: string): number[] {
  const matches = self.match(/\d+/g);
  if (matches === null) {
    return [];
  }
  return matches.map((it) => Number(it));
}

function strExtractEmails(self: string): string[] {
  const matches = self.match(/[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}/g);
  return matches === null ? [] : matches;
}

function strMaskEmail(self: string): string {
  if (strIsValidEmail(self)) {
    const parts = self.split("@");
    const username = parts[0];
    const domain = parts[1];
    const maskedUsername =
      username.length <= 2 ? "**" : username.slice(0, 2) + "*".repeat(username.length - 2);
    return `${maskedUsername}@${domain}`;
  }
  return self;
}

function strWordFrequency(self: string): Map<string, number> {
  const result = new Map<string, number>();
  const words = self
    .toLowerCase()
    .split(/\W+/)
    .filter((it) => it.length > 0);
  for (const word of words) {
    const current = result.get(word);
    result.set(word, (current === undefined ? 0 : current) + 1);
  }
  return result;
}

// --- Number (Int) extensions ---
function intIsEven(self: number): boolean {
  return self % 2 === 0;
}

function intIsOdd(self: number): boolean {
  return self % 2 !== 0;
}

function intIsPrime(self: number): boolean {
  if (self < 2) {
    return false;
  }
  const limit = Math.trunc(Math.sqrt(self));
  for (let i = 2; i <= limit; i++) {
    if (self % i === 0) {
      return false;
    }
  }
  return true;
}

function intFactorial(self: number): number {
  return self <= 1 ? 1 : self * intFactorial(self - 1);
}

function intToRoman(self: number): string {
  const values = [1000, 900, 500, 400, 100, 90, 50, 40, 10, 9, 5, 4, 1];
  const symbols = ["M", "CM", "D", "CD", "C", "XC", "L", "XL", "X", "IX", "V", "IV", "I"];
  let num = self;
  let result = "";
  for (let i = 0; i < values.length; i++) {
    while (num >= values[i]) {
      result += symbols[i];
      num -= values[i];
    }
  }
  return result;
}

// --- Double extensions ---
function dblFormatCurrency(self: number, currency: string): string {
  return `$${Math.trunc(self * 100) / 100.0} ${currency}`;
}

// Faithful to Kotlin: the original uses an escaped '$' so the body renders as
// a literal (the computed value is never interpolated). Reproduced exactly.
function dblToPercentage(self: number): string {
  return "${((this * 100 * 10).toInt() / 10.0)}%";
}

function dblRound(self: number, decimals: number): number {
  const factor = Math.pow(10.0, decimals);
  return Math.round(self * factor) / factor;
}

// --- Long (timestamp) extensions ---
function lngToDateString(self: number): string {
  const seconds = Math.trunc(self / 1000);
  const minutes = Math.trunc(seconds / 60);
  const hours = Math.trunc(minutes / 60);
  const days = Math.trunc(hours / 24);
  if (days > 0) {
    return `${days} days ago`;
  } else if (hours > 0) {
    return `${hours} hours ago`;
  } else if (minutes > 0) {
    return `${minutes} minutes ago`;
  } else {
    return `${seconds} seconds ago`;
  }
}

function lngFormatDuration(self: number): string {
  const hours = Math.trunc(self / 3600000);
  const minutes = Math.trunc((self % 3600000) / 60000);
  const seconds = Math.trunc((self % 60000) / 1000);
  if (hours > 0) {
    return `${hours}:${padStart2(minutes)}:${padStart2(seconds)}`;
  } else if (minutes > 0) {
    return `${minutes}:${padStart2(seconds)}`;
  } else {
    return `${seconds} seconds`;
  }
}

// Fisher-Yates shuffle (Kotlin List.shuffled()).
function shuffled<T>(source: T[]): T[] {
  const result = source.slice();
  for (let i = result.length - 1; i > 0; i--) {
    const j = Math.floor(Math.random() * (i + 1));
    const tmp = result[i];
    result[i] = result[j];
    result[j] = tmp;
  }
  return result;
}

// --- Collection (List) extensions ---
function lstSecond<T>(self: T[]): T | null {
  return self.length >= 2 ? self[1] : null;
}

function lstThird<T>(self: T[]): T | null {
  return self.length >= 3 ? self[2] : null;
}

function lstSecondToLast<T>(self: T[]): T | null {
  return self.length >= 2 ? self[self.length - 2] : null;
}

function lstTakeRandom<T>(self: T[], count: number): T[] {
  return shuffled(self).slice(0, count);
}

function lstSplit<T>(self: T[], predicate: (v: T) => boolean): Pair<T[], T[]> {
  const first: T[] = [];
  const second: T[] = [];
  self.forEach((it) => {
    if (predicate(it)) {
      first.push(it);
    } else {
      second.push(it);
    }
  });
  return new Pair<T[], T[]>(first, second);
}

function lstChunks<T>(self: T[], size: number): T[][] {
  const result: T[][] = [];
  for (let i = 0; i < self.length; i += size) {
    result.push(self.slice(i, i + size));
  }
  return result;
}

function lstFrequencyMap<T>(self: T[]): Map<T, number> {
  const result = new Map<T, number>();
  for (const it of self) {
    const current = result.get(it);
    result.set(it, (current === undefined ? 0 : current) + 1);
  }
  return result;
}

function lstDuplicates<T>(self: T[]): T[] {
  const counts = lstFrequencyMap(self);
  const result: T[] = [];
  for (const entry of counts) {
    if (entry[1] > 1) {
      result.push(entry[0]);
    }
  }
  return result;
}

function lstUnique<T>(self: T[]): T[] {
  const seen = new Set<T>();
  const result: T[] = [];
  for (const it of self) {
    if (!seen.has(it)) {
      seen.add(it);
      result.push(it);
    }
  }
  return result;
}

function lstWithoutNulls<T>(self: Array<T | null>): T[] {
  const result: T[] = [];
  for (const it of self) {
    if (it !== null) {
      result.push(it);
    }
  }
  return result;
}

function lstRotateLeft<T>(self: T[], positions: number): T[] {
  if (self.length === 0) {
    return self;
  }
  const pos = positions % self.length;
  return self.slice(pos).concat(self.slice(0, pos));
}

function lstRotateRight<T>(self: T[], positions: number): T[] {
  if (self.length === 0) {
    return self;
  }
  const pos = positions % self.length;
  return self.slice(self.length - pos).concat(self.slice(0, self.length - pos));
}

// --- Map extensions ---
function mapFilterByKeys<K, V>(self: Map<K, V>, predicate: (k: K) => boolean): Map<K, V> {
  const result = new Map<K, V>();
  for (const entry of self) {
    if (predicate(entry[0])) {
      result.set(entry[0], entry[1]);
    }
  }
  return result;
}

function mapFilterByValues<K, V>(self: Map<K, V>, predicate: (v: V) => boolean): Map<K, V> {
  const result = new Map<K, V>();
  for (const entry of self) {
    if (predicate(entry[1])) {
      result.set(entry[0], entry[1]);
    }
  }
  return result;
}

function mapSwap<K, V>(self: Map<K, V>): Map<V, K> {
  const result = new Map<V, K>();
  for (const entry of self) {
    result.set(entry[1], entry[0]);
  }
  return result;
}

function mapGetOrDefault<K, V>(self: Map<K, V>, key: K, defaultValue: V): V {
  const v = self.get(key);
  return v === undefined ? defaultValue : v;
}

// --- Person data class + extensions ---
class Person {
  constructor(
    public readonly id: string,
    public readonly name: string,
    public readonly email: string,
    public readonly age: number,
  ) {}
}

function personIsAdult(self: Person): boolean {
  return self.age >= 18;
}

function personIsMinor(self: Person): boolean {
  return self.age < 18;
}

function personAgeGroup(self: Person): string {
  if (self.age < 13) {
    return "Child";
  } else if (self.age < 20) {
    return "Teenager";
  } else if (self.age < 30) {
    return "Young Adult";
  } else if (self.age < 60) {
    return "Adult";
  } else {
    return "Senior";
  }
}

function personEmailDomain(self: Person): string {
  return substringAfter(self.email, "@");
}

function personInitials(self: Person): string {
  return self.name
    .split(" ")
    .map((it) => (it.length > 0 ? it.charAt(0) : ""))
    .filter((it) => it.length > 0)
    .join("");
}

function personDisplayName(self: Person): string {
  return `${self.name} (${self.age})`;
}

// --- Product data class + extensions ---
class Product {
  constructor(
    public readonly id: string,
    public readonly name: string,
    public readonly price: number,
    public readonly category: string,
    public readonly inStock: boolean,
  ) {}

  copyPrice(price: number): Product {
    return new Product(this.id, this.name, price, this.category, this.inStock);
  }
}

function productIsExpensive(self: Product): boolean {
  return self.price > 100.0;
}

function productIsCheap(self: Product): boolean {
  return self.price < 20.0;
}

function productIsAvailable(self: Product): boolean {
  return self.inStock;
}

function productPriceRange(self: Product): string {
  if (self.price < 20) {
    return "Budget";
  } else if (self.price < 50) {
    return "Mid-range";
  } else if (self.price < 100) {
    return "Premium";
  } else {
    return "Luxury";
  }
}

function productDiscountedPrice(self: Product, discount: number): number {
  return self.price * (1 - discount);
}

function productWithDiscount(self: Product, discount: number): Product {
  return self.copyPrice(productDiscountedPrice(self, discount));
}

function productCategoryPrefix(self: Product): string {
  return self.category.slice(0, 3).toUpperCase();
}

// --- Order data class + extensions ---
class Order {
  constructor(
    public readonly id: string,
    public readonly items: Product[],
    public readonly customerEmail: string,
    public readonly timestamp: number,
  ) {}
}

function orderTotalAmount(self: Order): number {
  return self.items.reduce((acc, it) => acc + it.price, 0);
}

function orderItemCount(self: Order): number {
  return self.items.length;
}

function orderHasExpensiveItems(self: Order): boolean {
  return self.items.some((it) => productIsExpensive(it));
}

function orderCategorySummary(self: Order): Map<string, number> {
  const result = new Map<string, number>();
  for (const it of self.items) {
    const current = result.get(it.category);
    result.set(it.category, (current === undefined ? 0 : current) + 1);
  }
  return result;
}

function orderAverageItemPrice(self: Order): number {
  return self.items.length > 0 ? averageOf(self.items.map((it) => it.price)) : 0.0;
}

function orderCustomerDomain(self: Order): string {
  return substringAfter(self.customerEmail, "@");
}

function orderIsRecent(self: Order): boolean {
  return getCurrentTimeMillis() - self.timestamp < 86400000;
}

function orderAgeInHours(self: Order): number {
  return Math.trunc((getCurrentTimeMillis() - self.timestamp) / 3600000);
}

// --- BankAccount data class + extensions ---
class BankAccount {
  constructor(
    public readonly accountNumber: string,
    public readonly balance: number,
    public readonly currency: string,
    public readonly type: string,
  ) {}

  copyBalance(balance: number): BankAccount {
    return new BankAccount(this.accountNumber, balance, this.currency, this.type);
  }
}

function accIsOverdrawn(self: BankAccount): boolean {
  return self.balance < 0;
}

function accHasPositiveBalance(self: BankAccount): boolean {
  return self.balance > 0;
}

function accBalanceFormatted(self: BankAccount): string {
  return dblFormatCurrency(self.balance, self.currency);
}

function accAccountType(self: BankAccount): string {
  return capitalizeFirst(self.type);
}

function accCanWithdraw(self: BankAccount, amount: number): boolean {
  return self.balance >= amount;
}

function accWithdraw(self: BankAccount, amount: number): BankAccount {
  return self.copyBalance(self.balance - amount);
}

function accDeposit(self: BankAccount, amount: number): BankAccount {
  return self.copyBalance(self.balance + amount);
}

function accTransfer(
  self: BankAccount,
  amount: number,
  targetAccount: BankAccount,
): Pair<BankAccount, BankAccount> {
  if (accCanWithdraw(self, amount)) {
    return new Pair<BankAccount, BankAccount>(
      accWithdraw(self, amount),
      accDeposit(targetAccount, amount),
    );
  }
  return new Pair<BankAccount, BankAccount>(self, targetAccount);
}

// --- Transaction data class + extensions ---
class Transaction {
  constructor(
    public readonly id: string,
    public readonly amount: number,
    public readonly type: string,
    public readonly timestamp: number,
    public readonly description: string,
  ) {}
}

function txnIsDebit(self: Transaction): boolean {
  return self.amount < 0;
}

function txnIsCredit(self: Transaction): boolean {
  return self.amount > 0;
}

function txnAmountFormatted(self: Transaction): string {
  return dblFormatCurrency(self.amount, "USD");
}

function txnTypeCapitalized(self: Transaction): string {
  return capitalizeFirst(self.type);
}

function txnIsToday(self: Transaction): boolean {
  return getCurrentTimeMillis() - self.timestamp < 86400000;
}

function txnDaysAgo(self: Transaction): number {
  return Math.trunc((getCurrentTimeMillis() - self.timestamp) / 86400000);
}

function txnCategory(self: Transaction): string {
  const desc = self.description.toLowerCase();
  if (desc.includes("grocery")) {
    return "Groceries";
  } else if (desc.includes("gas")) {
    return "Transportation";
  } else if (desc.includes("restaurant")) {
    return "Dining";
  } else if (desc.includes("salary")) {
    return "Income";
  } else {
    return "Other";
  }
}

// --- File/Path string extensions ---
function strFileExtension(self: string): string {
  return substringAfterLast(self, ".", "");
}

function strFileName(self: string): string {
  return substringAfterLast(self, "/", self);
}

function strFilePath(self: string): string {
  return substringBeforeLast(self, "/");
}

function strIsImageFile(self: string): boolean {
  const ext = strFileExtension(self).toLowerCase();
  return ["jpg", "jpeg", "png", "gif", "bmp"].includes(ext);
}

function strIsTextFile(self: string): boolean {
  const ext = strFileExtension(self).toLowerCase();
  return ["txt", "md", "doc", "docx"].includes(ext);
}

function strIsExecutable(self: string): boolean {
  const ext = strFileExtension(self).toLowerCase();
  return ["exe", "app", "deb", "dmg"].includes(ext);
}

// --- URL string extensions ---
function strIsValidUrl(self: string): boolean {
  return self.startsWith("http://") || self.startsWith("https://");
}

function strDomain(self: string): string {
  if (strIsValidUrl(self)) {
    return substringBefore(removePrefix(removePrefix(self, "https://"), "http://"), "/");
  }
  return "";
}

function strProtocol(self: string): string {
  if (self.startsWith("https://")) {
    return "HTTPS";
  } else if (self.startsWith("http://")) {
    return "HTTP";
  } else {
    return "Unknown";
  }
}

function strIsSecureUrl(self: string): boolean {
  return self.startsWith("https://");
}

// --- Validation string extensions ---
function strIsNumeric(self: string): boolean {
  return toDoubleOrNull(self) !== null;
}

function strIsAlphabetic(self: string): boolean {
  if (self.length === 0) {
    return true;
  }
  for (let i = 0; i < self.length; i++) {
    if (!isLetterCh(self.charAt(i))) {
      return false;
    }
  }
  return true;
}

function strIsAlphanumeric(self: string): boolean {
  for (let i = 0; i < self.length; i++) {
    if (!isLetterOrDigitCh(self.charAt(i))) {
      return false;
    }
  }
  return true;
}

function strHasUppercase(self: string): boolean {
  for (let i = 0; i < self.length; i++) {
    if (isUpperCh(self.charAt(i))) {
      return true;
    }
  }
  return false;
}

function strHasLowercase(self: string): boolean {
  for (let i = 0; i < self.length; i++) {
    if (isLowerCh(self.charAt(i))) {
      return true;
    }
  }
  return false;
}

function strHasDigits(self: string): boolean {
  for (let i = 0; i < self.length; i++) {
    if (isDigitCh(self.charAt(i))) {
      return true;
    }
  }
  return false;
}

function strHasSpecialChars(self: string): boolean {
  for (let i = 0; i < self.length; i++) {
    if (!isLetterOrDigitCh(self.charAt(i))) {
      return true;
    }
  }
  return false;
}

function strIsStrongPassword(self: string): boolean {
  return (
    self.length >= 8 &&
    strHasUppercase(self) &&
    strHasLowercase(self) &&
    strHasDigits(self) &&
    strHasSpecialChars(self)
  );
}

// --- Functional generic extensions ---
function applyIf<T>(self: T, condition: boolean, transform: (v: T) => T): T {
  return condition ? transform(self) : self;
}

function takeIfFn<T>(self: T, predicate: (v: T) => boolean): T | null {
  return predicate(self) ? self : null;
}

function takeUnlessFn<T>(self: T, predicate: (v: T) => boolean): T | null {
  return !predicate(self) ? self : null;
}

// --- Network/API generic data class + extensions ---
class ApiResponse<T> {
  constructor(
    public readonly data: T | null,
    public readonly status: number,
    public readonly message: string,
  ) {}
}

function apiIsSuccess<T>(self: ApiResponse<T>): boolean {
  return self.status >= 200 && self.status <= 299;
}

function apiIsError<T>(self: ApiResponse<T>): boolean {
  return self.status >= 400;
}

function apiIsClientError<T>(self: ApiResponse<T>): boolean {
  return self.status >= 400 && self.status <= 499;
}

function apiIsServerError<T>(self: ApiResponse<T>): boolean {
  return self.status >= 500 && self.status <= 599;
}

function apiHasData<T>(self: ApiResponse<T>): boolean {
  return self.data !== null;
}

// --- Configuration data class + extensions ---
class AppConfig {
  constructor(
    public readonly apiUrl: string,
    public readonly timeout: number,
    public readonly retries: number,
    public readonly debug: boolean,
  ) {}
}

function cfgIsProduction(self: AppConfig): boolean {
  return !self.debug;
}

function cfgIsDevelopment(self: AppConfig): boolean {
  return self.debug;
}

function cfgTimeoutInSeconds(self: AppConfig): number {
  return Math.trunc(self.timeout / 1000);
}

function cfgHasRetries(self: AppConfig): boolean {
  return self.retries > 0;
}

function cfgMaxRetries(self: AppConfig): number {
  return Math.max(self.retries, 1);
}

// --- Gaming data class + extensions ---
class Player {
  constructor(
    public readonly id: string,
    public readonly name: string,
    public readonly level: number,
    public readonly experience: number,
    public readonly achievements: string[],
  ) {}
}

function playerIsMaxLevel(self: Player): boolean {
  return self.level >= 100;
}

function playerExperienceToNextLevel(self: Player): number {
  return (self.level + 1) * 1000 - self.experience;
}

function playerProgressToNextLevel(self: Player): number {
  return self.experience / ((self.level + 1) * 1000);
}

function playerHasAchievement(self: Player, achievement: string): boolean {
  return self.achievements.includes(achievement);
}

function playerAchievementCount(self: Player): number {
  return self.achievements.length;
}

function playerIsVeteran(self: Player): boolean {
  return playerHasAchievement(self, "veteran");
}

function playerDisplayLevel(self: Player): string {
  return `Level ${self.level}`;
}

function playerRankTitle(self: Player): string {
  if (self.level < 10) {
    return "Novice";
  } else if (self.level < 25) {
    return "Apprentice";
  } else if (self.level < 50) {
    return "Expert";
  } else if (self.level < 75) {
    return "Master";
  } else {
    return "Grandmaster";
  }
}

// Main benchmark class demonstrating extension function usage
class IosSizeBenchmark {
  runBenchmark(): void {
    // String extension demonstrations
    const emails = [
      "john.doe@example.com",
      "invalid-email",
      "jane.smith@test.org",
      "not-an-email-at-all",
      "admin@company.co.uk",
    ];

    const validEmails = emails.filter((it) => strIsValidEmail(it));
    const maskedEmails = validEmails.map((it) => strMaskEmail(it));

    const phones = [
      "+1-555-123-4567",
      "555.123.4567",
      "(555) 123-4567",
      "5551234567",
      "invalid-phone",
    ];

    const validPhones = phones.filter((it) => strIsValidPhone(it));

    const texts = [
      "hello world programming",
      "the quick brown fox jumps over the lazy dog",
      "a man a plan a canal panama",
      "racecar level madam",
      "this is a sample text with numbers 123 and 456",
    ];

    let titleCaseChecksum = 0;
    let paletteCount = 0;
    texts.forEach((text) => {
      const titleCase = strToTitleCase(text);
      const camelCase = strToCamelCase(text);
      const snakeCase = strToSnakeCase(text);
      const truncated = strTruncate(text, 20, "...");
      const wordCount = strCountWords(text);
      const isPalindrome = strIsPalindrome(text);
      const numbers = strExtractNumbers(text);
      const frequency = strWordFrequency(text);
      titleCaseChecksum += titleCase.length + camelCase.length + snakeCase.length + truncated.length + wordCount + numbers.length + frequency.size;
      if (isPalindrome) {
        paletteCount++;
      }
    });

    // Number extension demonstrations
    const numbers = [2, 3, 4, 5, 7, 8, 10, 11, 13, 17, 25, 30];
    let primeCount = 0;
    let romanChecksum = 0;
    numbers.forEach((num) => {
      const isEven = intIsEven(num);
      const isOdd = intIsOdd(num);
      const isPrime = intIsPrime(num);
      const factorial = num <= 10 ? intFactorial(num) : 0;
      const roman = num <= 50 ? intToRoman(num) : "";
      if (isPrime) {
        primeCount++;
      }
      romanChecksum += roman.length + (isEven ? 1 : 0) + (isOdd ? 1 : 0) + (factorial > 0 ? 1 : 0);
    });

    const prices = [19.99, 45.5, 123.75, 999.99, 0.5];
    let currencyChecksum = 0;
    prices.forEach((price) => {
      const currency = dblFormatCurrency(price, "USD");
      const percentage = dblToPercentage(price / 1000);
      const rounded = dblRound(price, 1);
      currencyChecksum += currency.length + percentage.length + Math.trunc(rounded);
    });

    // Collection extension demonstrations
    const wordList = ["apple", "banana", "cherry", "date", "elderberry", "fig", "grape"];
    const secondItem = lstSecond(wordList);
    const thirdItem = lstThird(wordList);
    const secondToLastItem = lstSecondToLast(wordList);
    const randomItems = lstTakeRandom(wordList, 3);
    const splitWords = lstSplit(wordList, (it) => it.length <= 5);
    const shortWords = splitWords.first;
    const longWords = splitWords.second;
    const chunks = lstChunks(wordList, 3);
    const frequency = lstFrequencyMap(wordList);
    const rotatedLeft = lstRotateLeft(wordList, 2);
    const rotatedRight = lstRotateRight(wordList, 2);

    const duplicateList = ["a", "b", "c", "a", "b", "d", "e", "a"];
    const duplicates = lstDuplicates(duplicateList);
    const unique = lstUnique(duplicateList);

    // Map extension demonstrations
    const scoreMap = new Map<string, number>();
    scoreMap.set("Alice", 95);
    scoreMap.set("Bob", 87);
    scoreMap.set("Charlie", 92);
    scoreMap.set("David", 78);
    scoreMap.set("Eve", 89);
    const highScores = mapFilterByValues(scoreMap, (it) => it > 85);
    const swappedMap = mapSwap(scoreMap);
    const defaultScore = mapGetOrDefault(scoreMap, "Unknown", 0);

    // Time extension demonstrations
    const timestamps = [
      getCurrentTimeMillis() - 3600000,
      getCurrentTimeMillis() - 86400000,
      getCurrentTimeMillis() - 604800000,
    ];
    let timeChecksum = 0;
    timestamps.forEach((timestamp) => {
      const dateString = lngToDateString(timestamp);
      const duration = lngFormatDuration(getCurrentTimeMillis() - timestamp);
      timeChecksum += dateString.length + duration.length;
    });

    // Custom data class extension demonstrations
    const persons = [
      new Person("1", "John Doe", "john@example.com", 25),
      new Person("2", "Jane Smith", "jane@test.com", 17),
      new Person("3", "Bob Johnson", "bob@company.org", 45),
      new Person("4", "Alice Brown", "alice@email.net", 35),
    ];
    let personChecksum = 0;
    persons.forEach((person) => {
      const isAdult = personIsAdult(person);
      const ageGroup = personAgeGroup(person);
      const domain = personEmailDomain(person);
      const initials = personInitials(person);
      const displayName = personDisplayName(person);
      personChecksum += ageGroup.length + domain.length + initials.length + displayName.length + (isAdult ? 1 : 0);
    });
    const adults = persons.filter((it) => personIsAdult(it));
    const minors = persons.filter((it) => personIsMinor(it));
    const ageGroups = new Map<string, Person[]>();
    for (const p of persons) {
      const key = personAgeGroup(p);
      const bucket = ageGroups.get(key);
      if (bucket === undefined) {
        ageGroups.set(key, [p]);
      } else {
        bucket.push(p);
      }
    }

    // Product extension demonstrations
    const products = [
      new Product("1", "Laptop", 899.99, "Electronics", true),
      new Product("2", "Coffee Mug", 12.5, "Kitchen", true),
      new Product("3", "Designer Watch", 1299.99, "Accessories", false),
      new Product("4", "Book", 15.99, "Books", true),
      new Product("5", "Smartphone", 699.99, "Electronics", true),
    ];
    let productChecksum = 0;
    products.forEach((product) => {
      const isExpensive = productIsExpensive(product);
      const priceRange = productPriceRange(product);
      const discounted = productWithDiscount(product, 0.1);
      const prefix = productCategoryPrefix(product);
      productChecksum += priceRange.length + prefix.length + Math.trunc(discounted.price) + (isExpensive ? 1 : 0);
    });
    const availableProducts = products.filter((it) => productIsAvailable(it));
    const expensiveProducts = products.filter((it) => productIsExpensive(it));
    const electronicsProducts = products.filter((it) => it.category === "Electronics");
    const cheapProducts = products.filter((it) => productIsCheap(it));

    // Order extension demonstrations
    const orders = [
      new Order("1", products.slice(0, 2), "customer1@email.com", getCurrentTimeMillis() - 3600000),
      new Order("2", products.slice(2, 4), "customer2@test.com", getCurrentTimeMillis() - 86400000),
      new Order("3", products.slice(products.length - 1), "customer3@company.org", getCurrentTimeMillis() - 7200000),
    ];
    let orderChecksum = 0;
    orders.forEach((order) => {
      const total = orderTotalAmount(order);
      const itemCount = orderItemCount(order);
      const hasExpensive = orderHasExpensiveItems(order);
      const categories = orderCategorySummary(order);
      const averagePrice = orderAverageItemPrice(order);
      const domain = orderCustomerDomain(order);
      const isRecent = orderIsRecent(order);
      const age = orderAgeInHours(order);
      orderChecksum += itemCount + categories.size + domain.length + Math.trunc(total + averagePrice) + (hasExpensive ? 1 : 0) + (isRecent ? 1 : 0) + Math.trunc(age / 1000000);
    });

    // Banking extension demonstrations
    const accounts = [
      new BankAccount("12345", 1500.5, "USD", "checking"),
      new BankAccount("67890", -200.0, "USD", "checking"),
      new BankAccount("11111", 5000.0, "EUR", "savings"),
      new BankAccount("22222", 0.0, "USD", "savings"),
    ];
    let accountChecksum = 0;
    accounts.forEach((account) => {
      const isOverdrawn = accIsOverdrawn(account);
      const formatted = accBalanceFormatted(account);
      const canWithdraw = accCanWithdraw(account, 100.0);
      const type = accAccountType(account);
      accountChecksum += formatted.length + type.length + (isOverdrawn ? 1 : 0) + (canWithdraw ? 1 : 0);
    });
    const overdrawnAccounts = accounts.filter((it) => accIsOverdrawn(it));
    const positiveBalances = accounts.filter((it) => accHasPositiveBalance(it));
    const transferResult = accTransfer(accounts[0], 100.0, accounts[2]);

    // Transaction processing
    const transactions = [
      new Transaction("1", -50.0, "debit", getCurrentTimeMillis(), "Grocery Store"),
      new Transaction("2", 2500.0, "credit", getCurrentTimeMillis() - 86400000, "Salary Payment"),
      new Transaction("3", -75.5, "debit", getCurrentTimeMillis() - 3600000, "Gas Station"),
      new Transaction("4", -120.0, "debit", getCurrentTimeMillis() - 7200000, "Restaurant Dinner"),
    ];
    let transactionChecksum = 0;
    transactions.forEach((transaction) => {
      const isDebit = txnIsDebit(transaction);
      const formatted = txnAmountFormatted(transaction);
      const category = txnCategory(transaction);
      const daysAgo = txnDaysAgo(transaction);
      const typeCap = txnTypeCapitalized(transaction);
      transactionChecksum += formatted.length + category.length + typeCap.length + (isDebit ? 1 : 0) + Math.trunc(daysAgo / 1000000);
    });
    const recentTransactions = transactions.filter((it) => txnIsToday(it));
    const debits = transactions.filter((it) => txnIsDebit(it));
    const credits = transactions.filter((it) => txnIsCredit(it));

    // File path demonstrations
    const filePaths = [
      "/home/user/documents/report.pdf",
      "/var/log/system.log",
      "/usr/bin/application.exe",
      "/home/photos/vacation.jpg",
      "/downloads/music.mp3",
    ];
    let fileChecksum = 0;
    filePaths.forEach((path) => {
      const extension = strFileExtension(path);
      const fileName = strFileName(path);
      const directory = strFilePath(path);
      const isImage = strIsImageFile(path);
      const isText = strIsTextFile(path);
      const isExecutable = strIsExecutable(path);
      fileChecksum += extension.length + fileName.length + directory.length + (isImage ? 1 : 0) + (isText ? 1 : 0) + (isExecutable ? 1 : 0);
    });

    // URL demonstrations
    const urls = [
      "https://www.example.com/page",
      "http://api.service.org/data",
      "https://secure.bank.com/login",
      "ftp://files.domain.net/download",
      "invalid-url",
    ];
    let urlChecksum = 0;
    urls.forEach((url) => {
      const isValid = strIsValidUrl(url);
      const domain = strDomain(url);
      const protocol = strProtocol(url);
      const isSecure = strIsSecureUrl(url);
      urlChecksum += domain.length + protocol.length + (isValid ? 1 : 0) + (isSecure ? 1 : 0);
    });

    // Password validation
    const passwords = [
      "Password123!",
      "weakpass",
      "ONLYUPPER",
      "onlylower",
      "12345678",
      "Strong1Pass!",
    ];
    let passwordChecksum = 0;
    passwords.forEach((password) => {
      const isStrong = strIsStrongPassword(password);
      const hasUpper = strHasUppercase(password);
      const hasLower = strHasLowercase(password);
      const hasDigitsFlag = strHasDigits(password);
      const hasSpecial = strHasSpecialChars(password);
      passwordChecksum += (isStrong ? 1 : 0) + (hasUpper ? 1 : 0) + (hasLower ? 1 : 0) + (hasDigitsFlag ? 1 : 0) + (hasSpecial ? 1 : 0);
    });
    const strongPasswords = passwords.filter((it) => strIsStrongPassword(it));

    // API response demonstrations
    const apiResponses = [
      new ApiResponse<string>("Success data", 200, "OK"),
      new ApiResponse<string>(null, 404, "Not Found"),
      new ApiResponse<string>("Server data", 500, "Internal Server Error"),
      new ApiResponse<string>("Created", 201, "Created"),
    ];
    let apiChecksum = 0;
    apiResponses.forEach((response) => {
      const isSuccess = apiIsSuccess(response);
      const isError = apiIsError(response);
      const isClientError = apiIsClientError(response);
      const isServerError = apiIsServerError(response);
      const hasData = apiHasData(response);
      apiChecksum += (isSuccess ? 1 : 0) + (isError ? 1 : 0) + (isClientError ? 1 : 0) + (isServerError ? 1 : 0) + (hasData ? 1 : 0);
    });

    // Gaming demonstrations
    const players = [
      new Player("1", "ProGamer", 95, 94500, ["veteran", "champion", "speedrun"]),
      new Player("2", "Newbie", 5, 4200, ["first_login"]),
      new Player("3", "Expert", 45, 44800, ["veteran", "collector", "explorer"]),
      new Player("4", "Master", 78, 77100, ["veteran", "champion", "mentor"]),
    ];
    let playerChecksum = 0;
    players.forEach((player) => {
      const isMaxLevel = playerIsMaxLevel(player);
      const expToNext = playerExperienceToNextLevel(player);
      const progress = playerProgressToNextLevel(player);
      const isVeteran = playerIsVeteran(player);
      const achievementCount = playerAchievementCount(player);
      const title = playerRankTitle(player);
      const displayLevel = playerDisplayLevel(player);
      playerChecksum += title.length + displayLevel.length + achievementCount + expToNext + Math.trunc(progress * 100) + (isMaxLevel ? 1 : 0) + (isVeteran ? 1 : 0);
    });
    const veterans = players.filter((it) => playerIsVeteran(it));
    const highLevelPlayers = players.filter((it) => it.level > 50);

    // Complex chaining demonstrations (Map<String, Any> -> narrow union).
    const processedData: Array<Map<string, AnalysisValue>> = texts
      .filter((it) => it.length > 10)
      .map((it) => strToTitleCase(it))
      .map((it) => strTruncate(it, 30, "..."))
      .filter((it) => strCountWords(it) > 3)
      .map((text) => {
        const entry = new Map<string, AnalysisValue>();
        entry.set("text", text);
        entry.set("wordCount", strCountWords(text));
        entry.set("hasNumbers", strExtractNumbers(text).length > 0);
        entry.set("frequency", strWordFrequency(text));
        return entry;
      });

    const adultsByGroup = new Map<string, Person[]>();
    for (const p of persons.filter((it) => personIsAdult(it))) {
      const key = personAgeGroup(p);
      const bucket = adultsByGroup.get(key);
      if (bucket === undefined) {
        adultsByGroup.set(key, [p]);
      } else {
        bucket.push(p);
      }
    }
    const userAnalysis = new Map<string, Map<string, AnalysisValue>>();
    for (const entry of adultsByGroup) {
      const people = entry[1];
      const analysis = new Map<string, AnalysisValue>();
      analysis.set("count", people.length);
      analysis.set("averageAge", averageOf(people.map((it) => it.age)));
      analysis.set("domains", lstUnique(people.map((it) => personEmailDomain(it))));
      userAnalysis.set(entry[0], analysis);
    }

    const availableByRange = new Map<string, Product[]>();
    for (const prod of products.filter((it) => productIsAvailable(it))) {
      const key = productPriceRange(prod);
      const bucket = availableByRange.get(key);
      if (bucket === undefined) {
        availableByRange.set(key, [prod]);
      } else {
        bucket.push(prod);
      }
    }
    const productAnalysis = new Map<string, Map<string, AnalysisValue>>();
    for (const entry of availableByRange) {
      const prods = entry[1];
      const analysis = new Map<string, AnalysisValue>();
      analysis.set("count", prods.length);
      analysis.set("averagePrice", averageOf(prods.map((it) => it.price)));
      analysis.set("categories", lstUnique(prods.map((it) => it.category)));
      productAnalysis.set(entry[0], analysis);
    }

    // Exercise remaining declared extensions (the Kotlin file declares these
    // too). Each is a faithful use of the same operation.
    const extractedEmails = strExtractEmails("contact john@a.com or jane@b.org now");
    const reversedWord = strReverse("extension");
    const numericCheck = strIsNumeric("123.45");
    const alphaCheck = strIsAlphabetic("Hello");
    const alnumCheck = strIsAlphanumeric("Hello123");
    const nullableWords: Array<string | null> = ["a", null, "b", null, "c"];
    const compactWords = lstWithoutNulls(nullableWords);
    const highKeyScores = mapFilterByKeys(scoreMap, (k) => k.length > 3);
    const appliedPerson = applyIf(persons[0], true, (p) => new Person(p.id, p.name.toUpperCase(), p.email, p.age));
    const takenPerson = takeIfFn(persons[0], (p) => personIsAdult(p));
    const unlessPerson = takeUnlessFn(persons[1], (p) => personIsAdult(p));
    const appConfig = new AppConfig("https://api.example.com", 30000, 3, false);
    const configChecksum =
      cfgTimeoutInSeconds(appConfig) +
      cfgMaxRetries(appConfig) +
      (cfgIsProduction(appConfig) ? 1 : 0) +
      (cfgIsDevelopment(appConfig) ? 1 : 0) +
      (cfgHasRetries(appConfig) ? 1 : 0);
    const serverErrors = apiResponses.filter((it) => apiIsServerError(it));
    const cheapCount = cheapProducts.length;

    console.log("Extension-functions benchmark completed:");
    console.log(
      `- validEmails: ${validEmails.length}, masked: ${maskedEmails.length}, validPhones: ${validPhones.length}`,
    );
    console.log(
      `- titleChecksum: ${titleCaseChecksum}, palindromes: ${paletteCount}, primes: ${primeCount}, roman: ${romanChecksum}, currency: ${currencyChecksum}`,
    );
    console.log(
      `- second: ${secondItem}, third: ${thirdItem}, secondToLast: ${secondToLastItem}, random: ${randomItems.length}, short: ${shortWords.length}, long: ${longWords.length}`,
    );
    console.log(
      `- chunks: ${chunks.length}, freq: ${frequency.size}, rotL: ${rotatedLeft.length}, rotR: ${rotatedRight.length}, dup: ${duplicates.length}, uniq: ${unique.length}`,
    );
    console.log(
      `- highScores: ${highScores.size}, swapped: ${swappedMap.size}, default: ${defaultScore}, time: ${timeChecksum}`,
    );
    console.log(
      `- persons: ${personChecksum}, adults: ${adults.length}, minors: ${minors.length}, ageGroups: ${ageGroups.size}`,
    );
    console.log(
      `- products: ${productChecksum}, available: ${availableProducts.length}, expensive: ${expensiveProducts.length}, electronics: ${electronicsProducts.length}, cheap: ${cheapCount}`,
    );
    console.log(
      `- orders: ${orderChecksum}, accounts: ${accountChecksum}, overdrawn: ${overdrawnAccounts.length}, positive: ${positiveBalances.length}, transfer: ${transferResult.first.balance}/${transferResult.second.balance}`,
    );
    console.log(
      `- transactions: ${transactionChecksum}, recent: ${recentTransactions.length}, debits: ${debits.length}, credits: ${credits.length}`,
    );
    console.log(
      `- files: ${fileChecksum}, urls: ${urlChecksum}, passwords: ${passwordChecksum}, strong: ${strongPasswords.length}, api: ${apiChecksum}, serverErrors: ${serverErrors.length}`,
    );
    console.log(
      `- players: ${playerChecksum}, veterans: ${veterans.length}, highLevel: ${highLevelPlayers.length}`,
    );
    console.log(
      `- processedData: ${processedData.length}, userAnalysis: ${userAnalysis.size}, productAnalysis: ${productAnalysis.size}`,
    );
    console.log(
      `- emails: ${extractedEmails.length}, reversed: ${reversedWord}, numeric: ${numericCheck}, alpha: ${alphaCheck}, alnum: ${alnumCheck}`,
    );
    console.log(
      `- compact: ${compactWords.length}, highKeys: ${highKeyScores.size}, applied: ${appliedPerson.name}, taken: ${takenPerson === null ? "null" : takenPerson.name}, unless: ${unlessPerson === null ? "null" : unlessPerson.name}, config: ${configChecksum}`,
    );
  }
}

export function runBenchmark(): void {
  const benchmark = new IosSizeBenchmark();
  benchmark.runBenchmark();
}
