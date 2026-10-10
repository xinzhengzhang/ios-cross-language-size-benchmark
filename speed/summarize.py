#!/usr/bin/env python3
"""Print a per-case speed table + geomean-vs-fastest from results_speed.csv."""
import csv, math, collections

rows = list(csv.DictReader(open("results_speed.csv")))
bycase = collections.defaultdict(dict)
for r in rows:
    if r["status"] == "ok":
        bycase[r["case"]][r["language"]] = float(r["ns_per_iter"])

langs = ["objc", "swift", "kotlin", "scriptc", "zig"]
print(f"\n{'case':<22}" + "".join(f"{l:>12}" for l in langs) + "   fastest")
print("-" * 98)
geo = collections.defaultdict(list)
for c in sorted(bycase):
    d = bycase[c]
    cells = "".join(f"{d[l]:>12.1f}" if l in d else f"{'N/A':>12}" for l in langs)
    fastest = min(d, key=d.get) if d else "-"
    print(f"{c:<22}{cells}   {fastest}")
    fv = min(d.values()) if d else None
    for l, v in d.items():
        geo[l].append(v / fv)

print("\nGeomean ns/iter vs fastest-in-case (1.00 = fastest; higher = slower):")
for l in langs:
    if geo[l]:
        g = math.exp(sum(math.log(x) for x in geo[l]) / len(geo[l]))
        print(f"  {l:<9} {g:.2f}x   ({len(geo[l])} cases)")
