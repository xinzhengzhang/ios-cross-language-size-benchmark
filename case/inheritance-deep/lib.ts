/*
 * iOS Size Benchmark - Test Case Implementation
 * Generated with Claude AI (https://claude.ai)
 *
 * scriptc (TypeScript-to-native) port of the Kotlin/Swift "inheritance-deep"
 * case. Replicates three 8-level class hierarchies (Entity/Service/Manager),
 * five interfaces, and three hybrid classes that combine deep inheritance
 * with multiple interface implementation. A single exported entry
 * (runBenchmark) exercises every class via polymorphic dispatch so nothing
 * is dead-code eliminated, matching the Swift `public` requirement.
 */

// Test case: Inheritance Deep - Tests impact of deep inheritance chains on code size

// Deep inheritance chain - Base classes
class BaseEntity {
  getId(): number { return 0; }
  getName(): string { return "base"; }
  getType(): string { return "entity"; }
  validate(): boolean { return true; }
  process(): string { return "processed"; }
}

class AbstractEntity extends BaseEntity {
  getId(): number { return 1; }
  getName(): string { return "abstract"; }
  getCategory(): string { return "abstract"; }
  initialize(): boolean { return true; }
  configure(): string { return "configured"; }
}

class CoreEntity extends AbstractEntity {
  getId(): number { return 2; }
  getName(): string { return "core"; }
  getCategory(): string { return "core"; }
  getVersion(): string { return "1.0"; }
  setup(): boolean { return true; }
  prepare(): string { return "prepared"; }
}

class StandardEntity extends CoreEntity {
  getId(): number { return 3; }
  getName(): string { return "standard"; }
  getVersion(): string { return "1.1"; }
  getFormat(): string { return "standard"; }
  activate(): boolean { return true; }
  execute(): string { return "executed"; }
}

class AdvancedEntity extends StandardEntity {
  getId(): number { return 4; }
  getName(): string { return "advanced"; }
  getFormat(): string { return "advanced"; }
  getLevel(): number { return 10; }
  enhance(): boolean { return true; }
  optimize(): string { return "optimized"; }
}

class PremiumEntity extends AdvancedEntity {
  getId(): number { return 5; }
  getName(): string { return "premium"; }
  getLevel(): number { return 20; }
  getFeatures(): string[] { return ["feature1", "feature2"]; }
  upgrade(): boolean { return true; }
  customize(): string { return "customized"; }
}

class EliteEntity extends PremiumEntity {
  getId(): number { return 6; }
  getName(): string { return "elite"; }
  getLevel(): number { return 30; }
  getFeatures(): string[] { return ["elite1", "elite2", "elite3"]; }
  getPriority(): number { return 1; }
  accelerate(): boolean { return true; }
  specialize(): string { return "specialized"; }
}

class UltimateEntity extends EliteEntity {
  getId(): number { return 7; }
  getName(): string { return "ultimate"; }
  getLevel(): number { return 50; }
  getPriority(): number { return 0; }
  getCapabilities(): Map<string, number> {
    const m = new Map<string, number>();
    m.set("power", 100);
    m.set("speed", 100);
    return m;
  }
  transcend(): boolean { return true; }
  perfect(): string { return "perfected"; }
}

// Another deep inheritance chain - Service classes
class BaseService {
  start(): boolean { return true; }
  stop(): boolean { return true; }
  getStatus(): string { return "base"; }
  reset(): boolean { return true; }
  monitor(): string { return "monitoring"; }
}

class AbstractService extends BaseService {
  start(): boolean { return super.start(); }
  getStatus(): string { return "abstract"; }
  configure(): boolean { return true; }
  validate(): boolean { return true; }
  initialize(): string { return "initialized"; }
}

class CoreService extends AbstractService {
  getStatus(): string { return "core"; }
  configure(): boolean { return super.configure(); }
  connect(): boolean { return true; }
  authenticate(): boolean { return true; }
  authorize(): string { return "authorized"; }
}

class StandardService extends CoreService {
  getStatus(): string { return "standard"; }
  connect(): boolean { return super.connect(); }
  process(): boolean { return true; }
  transform(): boolean { return true; }
  deliver(): string { return "delivered"; }
}

class AdvancedService extends StandardService {
  getStatus(): string { return "advanced"; }
  process(): boolean { return super.process(); }
  optimize(): boolean { return true; }
  // Optional param so the Scalable override in SuperHybridService (which
  // adds a factor argument) keeps an exact-matching signature. Kotlin models
  // these as two overloaded methods; scriptc needs one unified signature.
  scale(factor?: number): boolean { return true; }
  distribute(): string { return "distributed"; }
}

class PremiumService extends AdvancedService {
  getStatus(): string { return "premium"; }
  optimize(): boolean { return super.optimize(); }
  accelerate(): boolean { return true; }
  cache(): boolean { return true; }
  replicate(): string { return "replicated"; }
}

class EliteService extends PremiumService {
  getStatus(): string { return "elite"; }
  accelerate(): boolean { return super.accelerate(); }
  parallelize(): boolean { return true; }
  cluster(): boolean { return true; }
  orchestrate(): string { return "orchestrated"; }
}

class UltimateService extends EliteService {
  getStatus(): string { return "ultimate"; }
  parallelize(): boolean { return super.parallelize(); }
  autoScale(): boolean { return true; }
  selfHeal(): boolean { return true; }
  transcend(): string { return "transcended"; }
}

// Third inheritance chain - Manager classes
class BaseManager {
  manage(): boolean { return true; }
  coordinate(): boolean { return true; }
  supervise(): string { return "base"; }
  delegate(): boolean { return true; }
  report(): string { return "reported"; }
}

class AbstractManager extends BaseManager {
  supervise(): string { return "abstract"; }
  manage(): boolean { return super.manage(); }
  plan(): boolean { return true; }
  organize(): boolean { return true; }
  control(): string { return "controlled"; }
}

class CoreManager extends AbstractManager {
  supervise(): string { return "core"; }
  plan(): boolean { return super.plan(); }
  direct(): boolean { return true; }
  monitor(): boolean { return true; }
  evaluate(): string { return "evaluated"; }
}

class StandardManager extends CoreManager {
  supervise(): string { return "standard"; }
  direct(): boolean { return super.direct(); }
  lead(): boolean { return true; }
  motivate(): boolean { return true; }
  develop(): string { return "developed"; }
}

class AdvancedManager extends StandardManager {
  supervise(): string { return "advanced"; }
  lead(): boolean { return super.lead(); }
  strategize(): boolean { return true; }
  innovate(): boolean { return true; }
  transform(): string { return "transformed"; }
}

class PremiumManager extends AdvancedManager {
  supervise(): string { return "premium"; }
  strategize(): boolean { return super.strategize(); }
  optimize(): boolean { return true; }
  automate(): boolean { return true; }
  revolutionize(): string { return "revolutionized"; }
}

class EliteManager extends PremiumManager {
  supervise(): string { return "elite"; }
  optimize(): boolean { return super.optimize(); }
  visualize(): boolean { return true; }
  predict(): boolean { return true; }
  transcend(): string { return "transcended"; }
}

class UltimateManager extends EliteManager {
  supervise(): string { return "ultimate"; }
  visualize(): boolean { return super.visualize(); }
  evolve(): boolean { return true; }
  singularize(): boolean { return true; }
  infinity(): string { return "infinite"; }
}

// Multiple inheritance through interfaces
interface Processable {
  processData(): string;
}

interface Cacheable {
  cache(): boolean;
  invalidate(): boolean;
}

interface Serializable {
  serialize(): string;
  deserialize(data: string): boolean;
}

interface Optimizable {
  optimize(): boolean;
  benchmark(): number;
}

interface Scalable {
  scale(factor: number): boolean;
  getCapacity(): number;
}

// Combined inheritance and interface implementation
class HybridEntity extends UltimateEntity implements Processable, Cacheable, Serializable {
  processData(): string { return "hybrid-processed"; }
  cache(): boolean { return true; }
  invalidate(): boolean { return true; }
  serialize(): string { return "serialized-hybrid"; }
  deserialize(data: string): boolean { return true; }
}

class SuperHybridService extends UltimateService implements Optimizable, Scalable, Processable {
  optimize(): boolean { return true; }
  benchmark(): number { return 99.9; }
  // UltimateService inherits a no-arg scale() from AdvancedService; the
  // Scalable interface adds scale(factor). An optional parameter preserves
  // both call shapes (Kotlin models these as two overloaded methods).
  scale(factor?: number): boolean { return true; }
  getCapacity(): number { return 1000; }
  processData(): string { return "super-hybrid-processed"; }
}

class MegaHybridManager extends UltimateManager implements Cacheable, Serializable, Optimizable, Scalable {
  cache(): boolean { return true; }
  invalidate(): boolean { return true; }
  serialize(): string { return "mega-serialized"; }
  deserialize(data: string): boolean { return true; }
  optimize(): boolean { return true; }
  benchmark(): number { return 100.0; }
  scale(factor: number): boolean { return true; }
  getCapacity(): number { return 10000; }
}

// Main benchmark class
class IosSizeBenchmark {
  readonly baseEntity = new BaseEntity();
  readonly abstractEntity = new AbstractEntity();
  readonly coreEntity = new CoreEntity();
  readonly standardEntity = new StandardEntity();
  readonly advancedEntity = new AdvancedEntity();
  readonly premiumEntity = new PremiumEntity();
  readonly eliteEntity = new EliteEntity();
  readonly ultimateEntity = new UltimateEntity();

  readonly baseService = new BaseService();
  readonly abstractService = new AbstractService();
  readonly coreService = new CoreService();
  readonly standardService = new StandardService();
  readonly advancedService = new AdvancedService();
  readonly premiumService = new PremiumService();
  readonly eliteService = new EliteService();
  readonly ultimateService = new UltimateService();

  readonly baseManager = new BaseManager();
  readonly abstractManager = new AbstractManager();
  readonly coreManager = new CoreManager();
  readonly standardManager = new StandardManager();
  readonly advancedManager = new AdvancedManager();
  readonly premiumManager = new PremiumManager();
  readonly eliteManager = new EliteManager();
  readonly ultimateManager = new UltimateManager();

  readonly hybridEntity = new HybridEntity();
  readonly superHybridService = new SuperHybridService();
  readonly megaHybridManager = new MegaHybridManager();

  private sink = 0;
  private note(s: string): void { this.sink += s.length; }
  private flag(b: boolean): void { this.sink += b ? 1 : 0; }
  private num(n: number): void { this.sink += n; }

  runBenchmark(): void {
    // Test deep inheritance with polymorphic method calls
    const entities: BaseEntity[] = [
      this.baseEntity, this.abstractEntity, this.coreEntity, this.standardEntity,
      this.advancedEntity, this.premiumEntity, this.eliteEntity, this.ultimateEntity
    ];

    for (const entity of entities) {
      if (entity instanceof UltimateEntity) {
        this.num(entity.getId()); this.note(entity.getName()); this.note(entity.getType());
        this.flag(entity.validate()); this.note(entity.process());
        this.num(entity.getCapabilities().size); this.flag(entity.transcend()); this.note(entity.perfect());
      } else if (entity instanceof EliteEntity) {
        this.num(entity.getId()); this.note(entity.getName());
        this.num(entity.getFeatures().length); this.num(entity.getPriority());
        this.flag(entity.accelerate()); this.note(entity.specialize());
      } else if (entity instanceof PremiumEntity) {
        this.num(entity.getId()); this.note(entity.getName());
        this.num(entity.getFeatures().length); this.flag(entity.upgrade()); this.note(entity.customize());
      } else if (entity instanceof AdvancedEntity) {
        this.num(entity.getId()); this.num(entity.getLevel());
        this.flag(entity.enhance()); this.note(entity.optimize());
      } else if (entity instanceof StandardEntity) {
        this.num(entity.getId()); this.note(entity.getFormat());
        this.flag(entity.activate()); this.note(entity.execute());
      } else if (entity instanceof CoreEntity) {
        this.num(entity.getId()); this.note(entity.getVersion());
        this.flag(entity.setup()); this.note(entity.prepare());
      } else if (entity instanceof AbstractEntity) {
        this.num(entity.getId()); this.note(entity.getCategory());
        this.flag(entity.initialize()); this.note(entity.configure());
      } else {
        this.num(entity.getId()); this.note(entity.getName());
        this.flag(entity.validate()); this.note(entity.process());
      }
    }

    // Test services
    const services: BaseService[] = [
      this.baseService, this.abstractService, this.coreService, this.standardService,
      this.advancedService, this.premiumService, this.eliteService, this.ultimateService
    ];

    for (const service of services) {
      if (service instanceof UltimateService) {
        this.flag(service.start()); this.note(service.getStatus());
        this.flag(service.autoScale()); this.flag(service.selfHeal()); this.note(service.transcend());
      } else if (service instanceof EliteService) {
        this.flag(service.start()); this.note(service.getStatus());
        this.flag(service.parallelize()); this.flag(service.cluster()); this.note(service.orchestrate());
      } else if (service instanceof PremiumService) {
        this.flag(service.start()); this.note(service.getStatus());
        this.flag(service.accelerate()); this.flag(service.cache()); this.note(service.replicate());
      } else if (service instanceof AdvancedService) {
        this.flag(service.process()); this.flag(service.scale()); this.note(service.distribute());
      } else {
        this.flag(service.start()); this.note(service.getStatus());
        this.flag(service.reset()); this.note(service.monitor());
      }
    }

    // Test managers
    const managers: BaseManager[] = [
      this.baseManager, this.abstractManager, this.coreManager, this.standardManager,
      this.advancedManager, this.premiumManager, this.eliteManager, this.ultimateManager
    ];

    for (const manager of managers) {
      if (manager instanceof UltimateManager) {
        this.flag(manager.manage()); this.note(manager.supervise());
        this.flag(manager.evolve()); this.flag(manager.singularize()); this.note(manager.infinity());
      } else if (manager instanceof EliteManager) {
        this.flag(manager.manage()); this.flag(manager.visualize());
        this.flag(manager.predict()); this.note(manager.transcend());
      } else {
        this.flag(manager.manage()); this.flag(manager.coordinate()); this.note(manager.supervise());
        this.flag(manager.delegate()); this.note(manager.report());
      }
    }

    // Test hybrid classes with multiple inheritance
    this.note(this.hybridEntity.processData());
    this.flag(this.hybridEntity.cache());
    this.flag(this.hybridEntity.invalidate());
    this.note(this.hybridEntity.serialize());
    this.flag(this.hybridEntity.deserialize("x"));
    this.flag(this.hybridEntity.transcend());
    this.note(this.hybridEntity.perfect());

    this.flag(this.superHybridService.optimize());
    this.num(this.superHybridService.benchmark());
    this.flag(this.superHybridService.scale(2.0));
    this.num(this.superHybridService.getCapacity());
    this.note(this.superHybridService.processData());
    this.note(this.superHybridService.transcend());

    this.flag(this.megaHybridManager.cache());
    this.flag(this.megaHybridManager.invalidate());
    this.note(this.megaHybridManager.serialize());
    this.flag(this.megaHybridManager.deserialize("y"));
    this.flag(this.megaHybridManager.optimize());
    this.num(this.megaHybridManager.benchmark());
    this.flag(this.megaHybridManager.scale(10.0));
    this.num(this.megaHybridManager.getCapacity());
    this.note(this.megaHybridManager.infinity());

    console.log("Inheritance-deep benchmark completed:");
    console.log(`- Entities: ${entities.length}, Services: ${services.length}, Managers: ${managers.length}`);
    console.log(`- Ultimate entity id: ${this.ultimateEntity.getId()}, name: ${this.ultimateEntity.getName()}, level: ${this.ultimateEntity.getLevel()}`);
    console.log(`- Hybrid: ${this.hybridEntity.processData()}, SuperHybrid cap: ${this.superHybridService.getCapacity()}, MegaHybrid cap: ${this.megaHybridManager.getCapacity()}`);
    console.log(`- Dispatch sink: ${this.sink}`);
  }
}

export function runBenchmark(): void {
  const benchmark = new IosSizeBenchmark();
  benchmark.runBenchmark();
}





