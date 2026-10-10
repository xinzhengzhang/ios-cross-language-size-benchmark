// Kotlin Native speed driver for the macOS execution-speed benchmark.
// Compiled together with a case's lib.kt (same package, so IosSizeBenchmark is
// directly visible). Loops runBenchmark `iters` times (argv[0]) and exits; all
// benchmark console output is sent to /dev/null by the harness. Timing is external.
package kntr.examples.ios.size.benchmark

fun main(args: Array<String>) {
    val iters = if (args.isNotEmpty()) args[0].toLong() else 1000L
    // Fresh instance per iteration (see main.m for the rationale): keeps the measured
    // unit stateless/linear and consistent with scriptc's fresh-state-per-call driver.
    var i = 0L
    while (i < iters) {
        IosSizeBenchmark().runBenchmark()
        i++
    }
}
