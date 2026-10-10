#!/usr/bin/env python3
"""Minimal wall-clock timer for the speed benchmark.

Usage: measure.py <reps> <exe> [exe args...]
Runs the command <reps> times with stdout/stderr discarded and prints the
MINIMUM elapsed wall-clock seconds (least-noisy sample). Prints "ERR" and exits
non-zero if any run fails, so the orchestrator can mark the case N/A.
"""
import subprocess
import sys
import time

reps = int(sys.argv[1])
cmd = sys.argv[2:]

# One untimed warmup run first: pays dyld load, page faults, and cache fill so the
# timed samples reflect steady-state work. Without this, a cold first sample can make
# a light workload look heavy and wreck N calibration.
w = subprocess.run(cmd, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
if w.returncode != 0:
    print("ERR")
    sys.exit(1)

best = None
for _ in range(reps):
    t0 = time.perf_counter()
    r = subprocess.run(cmd, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
    dt = time.perf_counter() - t0
    if r.returncode != 0:
        print("ERR")
        sys.exit(1)
    if best is None or dt < best:
        best = dt
print(f"{best:.9f}")
