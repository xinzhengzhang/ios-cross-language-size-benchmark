#!/usr/bin/env python3
"""Merge Zig size-tier rows into results.csv.

For every case already present in results.csv, (re)build its Zig object with
./compile_zig.sh and insert/update a `zig` row immediately after that case's
`scriptc` row (or after `kotlin` if scriptc is absent). Idempotent: existing
zig rows are dropped and regenerated.

Row format matches the other languages:
  case,variant,language,success,text_size,data_size,final_size,lines_of_code
  final = round(TEXT*0.7 + DATA*0.2)

Cases with no case/<name>/lib.zig (e.g. async / async-enhanced — Zig 0.16 has no
stable async) get an honest N/A row: false,0,0,0,0.
"""
import csv, subprocess, sys, os

CSV = "results.csv"
VARIANT = "-Os"


def loc(path):
    try:
        with open(path, "r", encoding="utf-8") as f:
            return sum(1 for _ in f)
    except OSError:
        return 0


def build(case):
    """Return (success, text, data, final, lines) for a case's Zig port."""
    lib = os.path.join("case", case, "lib.zig")
    if not os.path.isfile(lib):
        return False, 0, 0, 0, 0
    lines = loc(lib)
    try:
        out = subprocess.run(
            ["./compile_zig.sh", case],
            capture_output=True, text=True, timeout=600,
        )
    except subprocess.TimeoutExpired:
        return False, 0, 0, 0, lines
    if out.returncode != 0:
        sys.stderr.write(f"  zig build failed for {case}:\n{out.stderr}\n")
        return False, 0, 0, 0, lines
    parts = out.stdout.split()
    if len(parts) < 2:
        return False, 0, 0, 0, lines
    text, data = int(parts[0]), int(parts[1])
    final = round(text * 0.7 + data * 0.2)
    return True, text, data, final, lines


def zig_row(case):
    ok, text, data, final, lines = build(case)
    return [case, VARIANT, "zig", "true" if ok else "false",
            str(text), str(data), str(final), str(lines)]


def main():
    with open(CSV, newline="") as f:
        reader = csv.reader(f)
        header = next(reader)
        rows = [r for r in reader if r and r[2] != "zig"]  # drop old zig rows

    # Ordered list of cases as they first appear.
    cases, seen = [], set()
    for r in rows:
        if r[0] not in seen:
            seen.add(r[0])
            cases.append(r[0])

    print(f"Building Zig rows for {len(cases)} cases...")
    zrows = {c: zig_row(c) for c in cases}
    for c in cases:
        r = zrows[c]
        print(f"  {c:<24} {r[3]:<5} text={r[4]:>7} data={r[5]:>6} final={r[6]:>7} loc={r[7]}")

    # Rebuild: after each case's scriptc row (fallback: last row of the case),
    # insert that case's zig row.
    out, i = [], 0
    n = len(rows)
    while i < n:
        case = rows[i][0]
        block = []
        while i < n and rows[i][0] == case:
            block.append(rows[i]); i += 1
        out.extend(block)
        anchor = next((j for j, r in enumerate(block) if r[2] == "scriptc"), None)
        if anchor is None:
            anchor = next((j for j, r in enumerate(block) if r[2] == "kotlin"), len(block) - 1)
        # insert zig right after the anchor within the already-appended block
        pos = len(out) - len(block) + anchor + 1
        out.insert(pos, zrows[case])

    with open(CSV, "w", newline="") as f:
        w = csv.writer(f)
        w.writerow(header)
        w.writerows(out)
    print(f"Wrote {CSV}: {len(out)} data rows ({len(cases)} cases).")


if __name__ == "__main__":
    main()
