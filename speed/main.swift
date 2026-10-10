// Swift speed driver for the macOS execution-speed benchmark.
// Compiled together with a case's lib.swift (same module, so IosSizeBenchmark is
// directly visible). Loops runBenchmark `iters` times (argv[1]) and exits; all
// benchmark console output is sent to /dev/null by the harness. Timing is external.
import Foundation

let iters = CommandLine.arguments.count > 1 ? (Int(CommandLine.arguments[1]) ?? 1000) : 1000
// Fresh instance per iteration (see main.m for the rationale): keeps the measured
// unit stateless/linear and consistent with scriptc's fresh-state-per-call driver.
for _ in 0..<iters {
    let bench = IosSizeBenchmark()
    bench.runBenchmark()
}
