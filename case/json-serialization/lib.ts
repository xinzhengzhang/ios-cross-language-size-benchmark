/*
 * iOS Size Benchmark - Test Case Implementation
 * Generated with Claude AI (https://claude.ai)
 *
 * scriptc (TypeScript-to-native) port of the Kotlin `json-serialization` case
 * (lib.kt is authoritative). The Kotlin model uses kotlinx.serialization
 * (@Serializable data classes + Json { prettyPrint = true }). scriptc's STATIC
 * tier has JSON.parse/JSON.stringify natively, but — unlike kotlinx — it only
 * stringifies plain records/arrays/scalars, NOT class instances. So the data
 * model is expressed as typed record shapes (object types), which is the
 * faithful equivalent of kotlinx's generated serializers over data classes:
 *   - serialize  : JSON.stringify(customer, null, 2)  == Json{prettyPrint}.encodeToString
 *   - deserialize: JSON.parse(jsonString) as Customer, in try/catch returning
 *                  null — the same round-trip + error handling as decodeFromString.
 * Strongly-typed reconstruction into nominal classes isn't expressible on the
 * static tier for arbitrary parsed JSON, so we parse into the identical typed
 * shape and read fields back out, preserving the round-trip behavior.
 *
 * A single exported entry (runBenchmark) builds, serializes, and deserializes
 * the full object graph and logs results so nothing is dead-code eliminated.
 */

type Address = {
  street: string;
  city: string;
  state: string;
  zipCode: string;
  country: string;
  latitude: number;
  longitude: number;
};

type ContactInfo = {
  email: string;
  phone: string;
  website: string;
  socialMedia: string[];
};

type Review = {
  reviewId: number;
  rating: number;
  comment: string;
  reviewer: string;
};

type Product = {
  productId: number;
  name: string;
  category: string;
  price: number;
  inventory: number;
  tags: string[];
  specifications: { [key: string]: string };
  reviews: Review[];
};

type Order = {
  orderId: number;
  customerId: number;
  orderDate: number;
  products: Product[];
  totalAmount: number;
  status: string;
  shippingAddress: Address;
  billingAddress: Address;
  metadata: { [key: string]: string };
};

type NotificationPreferences = {
  email: boolean;
  sms: boolean;
  push: boolean;
};

type Preferences = {
  notifications: NotificationPreferences;
  language: string;
  currency: string;
  timezone: string;
};

type Customer = {
  customerId: number;
  firstName: string;
  lastName: string;
  birthDate: number;
  contactInfo: ContactInfo;
  addresses: Address[];
  orderHistory: Order[];
  preferences: Preferences;
  isActive: boolean;
  loyaltyPrograms: string[];
};

// Kotlin Int.toString().padStart(width, '0').
function padStartZeros(value: number, width: number): string {
  let s = `${value}`;
  while (s.length < width) s = "0" + s;
  return s;
}

// Kotlin Double.toString() renders whole doubles as "N.0" (e.g. "1.0 kg",
// discount "5.0"). JS would drop the ".0"; this keeps the serialized strings
// byte-faithful for the whole-number doubles this case produces.
function kdoubleWhole(value: number): string {
  return `${value}.0`;
}
class JSONSerializationService {
  performComplexJSONSerializationTest(): void {
    this.massSerializationTest(100);
  }

  generateComplexCustomer(customerId: number): Customer {
    const contactInfo: ContactInfo = {
      email: `customer${customerId}@email.com`,
      phone: `+1-555-${padStartZeros(customerId, 4)}`,
      website: `https://customer${customerId}.com`,
      socialMedia: ["twitter", "linkedin", "facebook"],
    };

    const addresses: Address[] = [];
    for (let i = 0; i < 3; i++) {
      addresses.push({
        street: `${customerId}${i} Main Street`,
        city: `City${customerId + i}`,
        state: `State${i}`,
        zipCode: padStartZeros(customerId * 100 + i, 5),
        country: "USA",
        latitude: 40.0 + (customerId % 10),
        longitude: -74.0 + (customerId % 10),
      });
    }

    const orders: Order[] = [];
    for (let i = 0; i < 5; i++) {
      const products: Product[] = [];
      for (let j = 0; j < 3; j++) {
        const reviews: Review[] = [];
        for (let k = 0; k < 2; k++) {
          reviews.push({
            reviewId: k,
            rating: 4 + k,
            comment: `Great product review ${k}`,
            reviewer: `Reviewer${k}`,
          });
        }

        const specifications: { [key: string]: string } = {
          weight: `${kdoubleWhole(1 + j)} kg`,
          dimensions: `${10 + j}x${20 + j}x${5 + j} cm`,
          material: "premium",
        };

        products.push({
          productId: i * 10 + j,
          name: `Product${i}-${j}`,
          category: `Category${j}`,
          price: 99.99 + j * 50.0,
          inventory: 100 + j,
          tags: ["featured", "bestseller", "new"],
          specifications: specifications,
          reviews: reviews,
        });
      }

      let totalAmount = 0;
      for (const p of products) totalAmount += p.price;

      orders.push({
        orderId: customerId * 100 + i,
        customerId: customerId,
        orderDate: 1609459200 + i * 86400,
        products: products,
        totalAmount: totalAmount,
        status: "completed",
        shippingAddress: addresses[0],
        billingAddress: addresses[addresses.length - 1],
        metadata: {
          source: "mobile",
          campaign: `campaign${i}`,
          discount: kdoubleWhole(i * 5),
        },
      });
    }

    const preferences: Preferences = {
      notifications: { email: true, sms: false, push: true },
      language: "en-US",
      currency: "USD",
      timezone: "America/New_York",
    };

    return {
      customerId: customerId,
      firstName: `FirstName${customerId}`,
      lastName: `LastName${customerId}`,
      birthDate: 631152000 + customerId * 86400,
      contactInfo: contactInfo,
      addresses: addresses,
      orderHistory: orders,
      preferences: preferences,
      isActive: customerId % 2 === 0,
      loyaltyPrograms: ["Gold", "Premium", "VIP"],
    };
  }

  serializeCustomerToJSON(customer: Customer): string {
    return JSON.stringify(customer, null, 2);
  }

  deserializeCustomerFromJSON(jsonString: string): Customer | null {
    try {
      return JSON.parse(jsonString) as Customer;
    } catch (e) {
      console.log(`JSON Deserialization Error: ${e}`);
      return null;
    }
  }

  massSerializationTest(customerCount: number): void {
    const customers: Customer[] = [];
    const jsonStrings: string[] = [];

    console.log(`Generating ${customerCount} complex customers...`);
    for (let i = 0; i < customerCount; i++) {
      customers.push(this.generateComplexCustomer(i + 1));
    }

    console.log(`Serializing ${customerCount} customers to JSON...`);
    for (const customer of customers) {
      jsonStrings.push(this.serializeCustomerToJSON(customer));
    }

    console.log(`Deserializing ${jsonStrings.length} JSON strings back to objects...`);
    const deserializedCustomers: Customer[] = [];
    for (const jsonString of jsonStrings) {
      const customer = this.deserializeCustomerFromJSON(jsonString);
      if (customer !== null) deserializedCustomers.push(customer);
    }

    console.log(
      `Completed JSON serialization test: Generated ${customers.length}, Serialized ${jsonStrings.length}, Deserialized ${deserializedCustomers.length}`,
    );

    const sampleCount = Math.min(3, jsonStrings.length);
    for (let i = 0; i < sampleCount; i++) {
      console.log(`Sample JSON length ${i}: ${jsonStrings[i].length} characters`);
    }

    // Read fields back off a round-tripped object so the typed deserialize
    // path is observably used (the scriptc analogue of Kotlin keeping the
    // decoded Customer reachable).
    if (deserializedCustomers.length > 0) {
      const first = deserializedCustomers[0];
      console.log(
        `First customer: id=${first.customerId}, orders=${first.orderHistory.length}, firstOrderProducts=${first.orderHistory[0].products.length}, firstSpecWeight=${first.orderHistory[0].products[0].specifications["weight"]}, lat=${first.addresses[0].latitude}`,
      );
    }
  }
}

class IosSizeBenchmark {
  private readonly jsonService = new JSONSerializationService();

  runBenchmark(): void {
    this.jsonService.performComplexJSONSerializationTest();
  }
}

export function runBenchmark(): void {
  const benchmark = new IosSizeBenchmark();
  benchmark.runBenchmark();
}

