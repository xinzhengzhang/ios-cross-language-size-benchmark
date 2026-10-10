/*
 * iOS Size Benchmark - Test Case Implementation
 * Generated with Claude AI (https://claude.ai)
 *
 * scriptc (TypeScript-to-native) port of the Kotlin `many-classes` case.
 * Mirrors 20 Entity classes, 10 Service classes and 5 Manager classes, plus
 * the IosSizeBenchmark driver that dispatches over each instance by runtime
 * type (Kotlin `when (x is T)` -> TS `instanceof`). A single exported entry
 * (runBenchmark) exercises every type so nothing is dead-code eliminated,
 * matching the Swift `public` requirement.
 */

// Entity classes (20 entities)
class Entity01 {
  constructor(readonly id: number, readonly name: string, readonly value: number) {}
  process(): number { return this.value * 1.1; }
  validate(): boolean { return this.id > 0 && this.name.length > 0; }
  transform(): Entity01 { return new Entity01(this.id + 1, this.name.toUpperCase(), this.value * 2); }
}

class Entity02 {
  constructor(readonly id: number, readonly name: string, readonly value: number) {}
  process(): number { return this.value * 1.2; }
  validate(): boolean { return this.id > 0 && this.name.length > 0; }
  transform(): Entity02 { return new Entity02(this.id + 1, this.name.toUpperCase(), this.value * 2); }
}

class Entity03 {
  constructor(readonly id: number, readonly name: string, readonly value: number) {}
  process(): number { return this.value * 1.3; }
  validate(): boolean { return this.id > 0 && this.name.length > 0; }
  transform(): Entity03 { return new Entity03(this.id + 1, this.name.toUpperCase(), this.value * 2); }
}

class Entity04 {
  constructor(readonly id: number, readonly name: string, readonly value: number) {}
  process(): number { return this.value * 1.4; }
  validate(): boolean { return this.id > 0 && this.name.length > 0; }
  transform(): Entity04 { return new Entity04(this.id + 1, this.name.toUpperCase(), this.value * 2); }
}
class Entity05 {
  constructor(readonly id: number, readonly name: string, readonly value: number) {}
  process(): number { return this.value * 1.5; }
  validate(): boolean { return this.id > 0 && this.name.length > 0; }
  transform(): Entity05 { return new Entity05(this.id + 1, this.name.toUpperCase(), this.value * 2); }
}

class Entity06 {
  constructor(readonly id: number, readonly name: string, readonly value: number) {}
  process(): number { return this.value * 1.6; }
  validate(): boolean { return this.id > 0 && this.name.length > 0; }
  transform(): Entity06 { return new Entity06(this.id + 1, this.name.toUpperCase(), this.value * 2); }
}

class Entity07 {
  constructor(readonly id: number, readonly name: string, readonly value: number) {}
  process(): number { return this.value * 1.7; }
  validate(): boolean { return this.id > 0 && this.name.length > 0; }
  transform(): Entity07 { return new Entity07(this.id + 1, this.name.toUpperCase(), this.value * 2); }
}

class Entity08 {
  constructor(readonly id: number, readonly name: string, readonly value: number) {}
  process(): number { return this.value * 1.8; }
  validate(): boolean { return this.id > 0 && this.name.length > 0; }
  transform(): Entity08 { return new Entity08(this.id + 1, this.name.toUpperCase(), this.value * 2); }
}

class Entity09 {
  constructor(readonly id: number, readonly name: string, readonly value: number) {}
  process(): number { return this.value * 1.9; }
  validate(): boolean { return this.id > 0 && this.name.length > 0; }
  transform(): Entity09 { return new Entity09(this.id + 1, this.name.toUpperCase(), this.value * 2); }
}

class Entity10 {
  constructor(readonly id: number, readonly name: string, readonly value: number) {}
  process(): number { return this.value * 2.0; }
  validate(): boolean { return this.id > 0 && this.name.length > 0; }
  transform(): Entity10 { return new Entity10(this.id + 1, this.name.toUpperCase(), this.value * 2); }
}
class Entity11 {
  constructor(readonly id: number, readonly name: string, readonly value: number) {}
  process(): number { return this.value * 2.1; }
  validate(): boolean { return this.id > 0 && this.name.length > 0; }
  transform(): Entity11 { return new Entity11(this.id + 1, this.name.toUpperCase(), this.value * 2); }
}

class Entity12 {
  constructor(readonly id: number, readonly name: string, readonly value: number) {}
  process(): number { return this.value * 2.2; }
  validate(): boolean { return this.id > 0 && this.name.length > 0; }
  transform(): Entity12 { return new Entity12(this.id + 1, this.name.toUpperCase(), this.value * 2); }
}

class Entity13 {
  constructor(readonly id: number, readonly name: string, readonly value: number) {}
  process(): number { return this.value * 2.3; }
  validate(): boolean { return this.id > 0 && this.name.length > 0; }
  transform(): Entity13 { return new Entity13(this.id + 1, this.name.toUpperCase(), this.value * 2); }
}

class Entity14 {
  constructor(readonly id: number, readonly name: string, readonly value: number) {}
  process(): number { return this.value * 2.4; }
  validate(): boolean { return this.id > 0 && this.name.length > 0; }
  transform(): Entity14 { return new Entity14(this.id + 1, this.name.toUpperCase(), this.value * 2); }
}

class Entity15 {
  constructor(readonly id: number, readonly name: string, readonly value: number) {}
  process(): number { return this.value * 2.5; }
  validate(): boolean { return this.id > 0 && this.name.length > 0; }
  transform(): Entity15 { return new Entity15(this.id + 1, this.name.toUpperCase(), this.value * 2); }
}

class Entity16 {
  constructor(readonly id: number, readonly name: string, readonly value: number) {}
  process(): number { return this.value * 2.6; }
  validate(): boolean { return this.id > 0 && this.name.length > 0; }
  transform(): Entity16 { return new Entity16(this.id + 1, this.name.toUpperCase(), this.value * 2); }
}

class Entity17 {
  constructor(readonly id: number, readonly name: string, readonly value: number) {}
  process(): number { return this.value * 2.7; }
  validate(): boolean { return this.id > 0 && this.name.length > 0; }
  transform(): Entity17 { return new Entity17(this.id + 1, this.name.toUpperCase(), this.value * 2); }
}

class Entity18 {
  constructor(readonly id: number, readonly name: string, readonly value: number) {}
  process(): number { return this.value * 2.8; }
  validate(): boolean { return this.id > 0 && this.name.length > 0; }
  transform(): Entity18 { return new Entity18(this.id + 1, this.name.toUpperCase(), this.value * 2); }
}

class Entity19 {
  constructor(readonly id: number, readonly name: string, readonly value: number) {}
  process(): number { return this.value * 2.9; }
  validate(): boolean { return this.id > 0 && this.name.length > 0; }
  transform(): Entity19 { return new Entity19(this.id + 1, this.name.toUpperCase(), this.value * 2); }
}

class Entity20 {
  constructor(readonly id: number, readonly name: string, readonly value: number) {}
  process(): number { return this.value * 3.0; }
  validate(): boolean { return this.id > 0 && this.name.length > 0; }
  transform(): Entity20 { return new Entity20(this.id + 1, this.name.toUpperCase(), this.value * 2); }
}
// Service classes (10 services)
class Service01 {
  method01(): string { return "Service01.method01"; }
  method02(): string { return "Service01.method02"; }
  method03(): string { return "Service01.method03"; }
  method04(): string { return "Service01.method04"; }
  method05(): string { return "Service01.method05"; }
}

class Service02 {
  method01(): string { return "Service02.method01"; }
  method02(): string { return "Service02.method02"; }
  method03(): string { return "Service02.method03"; }
  method04(): string { return "Service02.method04"; }
  method05(): string { return "Service02.method05"; }
}

class Service03 {
  method01(): string { return "Service03.method01"; }
  method02(): string { return "Service03.method02"; }
  method03(): string { return "Service03.method03"; }
  method04(): string { return "Service03.method04"; }
  method05(): string { return "Service03.method05"; }
}

class Service04 {
  method01(): string { return "Service04.method01"; }
  method02(): string { return "Service04.method02"; }
  method03(): string { return "Service04.method03"; }
  method04(): string { return "Service04.method04"; }
  method05(): string { return "Service04.method05"; }
}

class Service05 {
  method01(): string { return "Service05.method01"; }
  method02(): string { return "Service05.method02"; }
  method03(): string { return "Service05.method03"; }
  method04(): string { return "Service05.method04"; }
  method05(): string { return "Service05.method05"; }
}

class Service06 {
  method01(): string { return "Service06.method01"; }
  method02(): string { return "Service06.method02"; }
  method03(): string { return "Service06.method03"; }
  method04(): string { return "Service06.method04"; }
  method05(): string { return "Service06.method05"; }
}

class Service07 {
  method01(): string { return "Service07.method01"; }
  method02(): string { return "Service07.method02"; }
  method03(): string { return "Service07.method03"; }
  method04(): string { return "Service07.method04"; }
  method05(): string { return "Service07.method05"; }
}

class Service08 {
  method01(): string { return "Service08.method01"; }
  method02(): string { return "Service08.method02"; }
  method03(): string { return "Service08.method03"; }
  method04(): string { return "Service08.method04"; }
  method05(): string { return "Service08.method05"; }
}

class Service09 {
  method01(): string { return "Service09.method01"; }
  method02(): string { return "Service09.method02"; }
  method03(): string { return "Service09.method03"; }
  method04(): string { return "Service09.method04"; }
  method05(): string { return "Service09.method05"; }
}

class Service10 {
  method01(): string { return "Service10.method01"; }
  method02(): string { return "Service10.method02"; }
  method03(): string { return "Service10.method03"; }
  method04(): string { return "Service10.method04"; }
  method05(): string { return "Service10.method05"; }
}
// Manager classes with many methods (5 managers)
class Manager01 {
  initialize(): string { return "Manager01.initialize"; }
  configure(): string { return "Manager01.configure"; }
  start(): string { return "Manager01.start"; }
  stop(): string { return "Manager01.stop"; }
  restart(): string { return "Manager01.restart"; }
  pause(): string { return "Manager01.pause"; }
  resume(): string { return "Manager01.resume"; }
  reset(): string { return "Manager01.reset"; }
  cleanup(): string { return "Manager01.cleanup"; }
  validate(): string { return "Manager01.validate"; }
}

class Manager02 {
  initialize(): string { return "Manager02.initialize"; }
  configure(): string { return "Manager02.configure"; }
  start(): string { return "Manager02.start"; }
  stop(): string { return "Manager02.stop"; }
  restart(): string { return "Manager02.restart"; }
  pause(): string { return "Manager02.pause"; }
  resume(): string { return "Manager02.resume"; }
  reset(): string { return "Manager02.reset"; }
  cleanup(): string { return "Manager02.cleanup"; }
  validate(): string { return "Manager02.validate"; }
}

class Manager03 {
  initialize(): string { return "Manager03.initialize"; }
  configure(): string { return "Manager03.configure"; }
  start(): string { return "Manager03.start"; }
  stop(): string { return "Manager03.stop"; }
  restart(): string { return "Manager03.restart"; }
  pause(): string { return "Manager03.pause"; }
  resume(): string { return "Manager03.resume"; }
  reset(): string { return "Manager03.reset"; }
  cleanup(): string { return "Manager03.cleanup"; }
  validate(): string { return "Manager03.validate"; }
}

class Manager04 {
  initialize(): string { return "Manager04.initialize"; }
  configure(): string { return "Manager04.configure"; }
  start(): string { return "Manager04.start"; }
  stop(): string { return "Manager04.stop"; }
  restart(): string { return "Manager04.restart"; }
  pause(): string { return "Manager04.pause"; }
  resume(): string { return "Manager04.resume"; }
  reset(): string { return "Manager04.reset"; }
  cleanup(): string { return "Manager04.cleanup"; }
  validate(): string { return "Manager04.validate"; }
}

class Manager05 {
  initialize(): string { return "Manager05.initialize"; }
  configure(): string { return "Manager05.configure"; }
  start(): string { return "Manager05.start"; }
  stop(): string { return "Manager05.stop"; }
  restart(): string { return "Manager05.restart"; }
  pause(): string { return "Manager05.pause"; }
  resume(): string { return "Manager05.resume"; }
  reset(): string { return "Manager05.reset"; }
  cleanup(): string { return "Manager05.cleanup"; }
  validate(): string { return "Manager05.validate"; }
}
type AnyEntity =
  | Entity01 | Entity02 | Entity03 | Entity04 | Entity05
  | Entity06 | Entity07 | Entity08 | Entity09 | Entity10
  | Entity11 | Entity12 | Entity13 | Entity14 | Entity15
  | Entity16 | Entity17 | Entity18 | Entity19 | Entity20;

type AnyService =
  | Service01 | Service02 | Service03 | Service04 | Service05
  | Service06 | Service07 | Service08 | Service09 | Service10;

type AnyManager = Manager01 | Manager02 | Manager03 | Manager04 | Manager05;

// Main benchmark class
class IosSizeBenchmark {
  private readonly entities: AnyEntity[] = [
    new Entity01(1, "test", 1.0), new Entity02(2, "test", 2.0), new Entity03(3, "test", 3.0),
    new Entity04(4, "test", 4.0), new Entity05(5, "test", 5.0), new Entity06(6, "test", 6.0),
    new Entity07(7, "test", 7.0), new Entity08(8, "test", 8.0), new Entity09(9, "test", 9.0),
    new Entity10(10, "test", 10.0), new Entity11(11, "test", 11.0), new Entity12(12, "test", 12.0),
    new Entity13(13, "test", 13.0), new Entity14(14, "test", 14.0), new Entity15(15, "test", 15.0),
    new Entity16(16, "test", 16.0), new Entity17(17, "test", 17.0), new Entity18(18, "test", 18.0),
    new Entity19(19, "test", 19.0), new Entity20(20, "test", 20.0),
  ];

  private readonly services: AnyService[] = [
    new Service01(), new Service02(), new Service03(), new Service04(), new Service05(),
    new Service06(), new Service07(), new Service08(), new Service09(), new Service10(),
  ];

  private readonly managers: AnyManager[] = [
    new Manager01(), new Manager02(), new Manager03(), new Manager04(), new Manager05(),
  ];

  runBenchmark(): void {
    let processSum = 0.0;
    let validCount = 0;
    let transformSum = 0;
    let serviceChars = 0;
    let managerChars = 0;

    // Process entities with type checking
    for (const entity of this.entities) {
      if (entity instanceof Entity01) { processSum += entity.process(); if (entity.validate()) validCount++; transformSum += entity.transform().id; }
      else if (entity instanceof Entity02) { processSum += entity.process(); if (entity.validate()) validCount++; transformSum += entity.transform().id; }
      else if (entity instanceof Entity03) { processSum += entity.process(); if (entity.validate()) validCount++; transformSum += entity.transform().id; }
      else if (entity instanceof Entity04) { processSum += entity.process(); if (entity.validate()) validCount++; transformSum += entity.transform().id; }
      else if (entity instanceof Entity05) { processSum += entity.process(); if (entity.validate()) validCount++; transformSum += entity.transform().id; }
      else if (entity instanceof Entity06) { processSum += entity.process(); if (entity.validate()) validCount++; transformSum += entity.transform().id; }
      else if (entity instanceof Entity07) { processSum += entity.process(); if (entity.validate()) validCount++; transformSum += entity.transform().id; }
      else if (entity instanceof Entity08) { processSum += entity.process(); if (entity.validate()) validCount++; transformSum += entity.transform().id; }
      else if (entity instanceof Entity09) { processSum += entity.process(); if (entity.validate()) validCount++; transformSum += entity.transform().id; }
      else if (entity instanceof Entity10) { processSum += entity.process(); if (entity.validate()) validCount++; transformSum += entity.transform().id; }
      else if (entity instanceof Entity11) { processSum += entity.process(); if (entity.validate()) validCount++; transformSum += entity.transform().id; }
      else if (entity instanceof Entity12) { processSum += entity.process(); if (entity.validate()) validCount++; transformSum += entity.transform().id; }
      else if (entity instanceof Entity13) { processSum += entity.process(); if (entity.validate()) validCount++; transformSum += entity.transform().id; }
      else if (entity instanceof Entity14) { processSum += entity.process(); if (entity.validate()) validCount++; transformSum += entity.transform().id; }
      else if (entity instanceof Entity15) { processSum += entity.process(); if (entity.validate()) validCount++; transformSum += entity.transform().id; }
      else if (entity instanceof Entity16) { processSum += entity.process(); if (entity.validate()) validCount++; transformSum += entity.transform().id; }
      else if (entity instanceof Entity17) { processSum += entity.process(); if (entity.validate()) validCount++; transformSum += entity.transform().id; }
      else if (entity instanceof Entity18) { processSum += entity.process(); if (entity.validate()) validCount++; transformSum += entity.transform().id; }
      else if (entity instanceof Entity19) { processSum += entity.process(); if (entity.validate()) validCount++; transformSum += entity.transform().id; }
      else if (entity instanceof Entity20) { processSum += entity.process(); if (entity.validate()) validCount++; transformSum += entity.transform().id; }
    }

    // Use services with type checking
    for (const service of this.services) {
      if (service instanceof Service01) { serviceChars += service.method01().length + service.method02().length + service.method03().length + service.method04().length + service.method05().length; }
      else if (service instanceof Service02) { serviceChars += service.method01().length + service.method02().length + service.method03().length + service.method04().length + service.method05().length; }
      else if (service instanceof Service03) { serviceChars += service.method01().length + service.method02().length + service.method03().length + service.method04().length + service.method05().length; }
      else if (service instanceof Service04) { serviceChars += service.method01().length + service.method02().length + service.method03().length + service.method04().length + service.method05().length; }
      else if (service instanceof Service05) { serviceChars += service.method01().length + service.method02().length + service.method03().length + service.method04().length + service.method05().length; }
      else if (service instanceof Service06) { serviceChars += service.method01().length + service.method02().length + service.method03().length + service.method04().length + service.method05().length; }
      else if (service instanceof Service07) { serviceChars += service.method01().length + service.method02().length + service.method03().length + service.method04().length + service.method05().length; }
      else if (service instanceof Service08) { serviceChars += service.method01().length + service.method02().length + service.method03().length + service.method04().length + service.method05().length; }
      else if (service instanceof Service09) { serviceChars += service.method01().length + service.method02().length + service.method03().length + service.method04().length + service.method05().length; }
      else if (service instanceof Service10) { serviceChars += service.method01().length + service.method02().length + service.method03().length + service.method04().length + service.method05().length; }
    }

    // Use managers with type checking (mirrors Kotlin: only 5 of the 10 methods are called)
    for (const manager of this.managers) {
      if (manager instanceof Manager01) { managerChars += manager.initialize().length + manager.configure().length + manager.start().length + manager.stop().length + manager.cleanup().length; }
      else if (manager instanceof Manager02) { managerChars += manager.initialize().length + manager.configure().length + manager.start().length + manager.stop().length + manager.cleanup().length; }
      else if (manager instanceof Manager03) { managerChars += manager.initialize().length + manager.configure().length + manager.start().length + manager.stop().length + manager.cleanup().length; }
      else if (manager instanceof Manager04) { managerChars += manager.initialize().length + manager.configure().length + manager.start().length + manager.stop().length + manager.cleanup().length; }
      else if (manager instanceof Manager05) { managerChars += manager.initialize().length + manager.configure().length + manager.start().length + manager.stop().length + manager.cleanup().length; }
    }

    console.log("Many classes benchmark completed:");
    console.log(`- Entities: ${this.entities.length}, process sum: ${processSum}, valid: ${validCount}, transform id sum: ${transformSum}`);
    console.log(`- Services: ${this.services.length}, method chars: ${serviceChars}`);
    console.log(`- Managers: ${this.managers.length}, method chars: ${managerChars}`);
  }
}

export function runBenchmark(): void {
  const benchmark = new IosSizeBenchmark();
  benchmark.runBenchmark();
}
