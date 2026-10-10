// Objective-C speed driver for the macOS execution-speed benchmark.
// Linked with a case's lib.m (which defines @implementation IosSizeBenchmark).
// Loops runBenchmark `iters` times (argv[1]) and exits; all benchmark console
// output is sent to /dev/null by the harness. Timing is external (two-point).
#import <Foundation/Foundation.h>
#include <stdlib.h>

// Forward declaration; the real @implementation lives in the case's lib.m.
@interface IosSizeBenchmark : NSObject
- (void)runBenchmark;
@end

int main(int argc, const char *argv[]) {
    @autoreleasepool {
        long iters = (argc > 1) ? atol(argv[1]) : 1000;
        // Fresh instance per iteration: the measured unit is one full benchmark run
        // with its own state. Reusing one instance would let stateful cases
        // accumulate across calls (super-linear) and diverge from scriptc, whose
        // free-function runBenchmark builds fresh state each call.
        for (long i = 0; i < iters; i++) {
            @autoreleasepool {
                IosSizeBenchmark *bench = [[IosSizeBenchmark alloc] init];
                [bench runBenchmark];
            }
        }
    }
    return 0;
}
