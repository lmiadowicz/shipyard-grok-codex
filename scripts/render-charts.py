#!/usr/bin/env python3
"""Rebuild TARGET spider charts from charts/mega-assessment-TARGET-100.md.

Default: matplotlib radar (reliable). Optional: --mega-card for Chrome headless FUT card.
Charts labeled 100% are a TARGET / design bar — NOT a measured MEGA score.
"""
from __future__ import annotations

import argparse
import math
import re
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
REPORT = ROOT / "charts" / "mega-assessment-TARGET-100.md"
OUT = ROOT / "charts"
VENDOR = ROOT / "vendor" / "mega-card" / "render.py"

TRAIT_ROW = re.compile(
    r"^\|\s*(T\d{2})\s*\|\s*([^|]+?)\s*\|\s*(\d+)\s*\|\s*(\d+)\s*\|\s*(\d+)\s*\|\s*(\d+)\s*\|\s*(\d+)\s*\|\s*$",
    re.M,
)


def parse_scores(text: str) -> list[tuple[str, float]]:
    seen = {}
    for m in TRAIT_ROW.finditer(text):
        tid, name = m.group(1), m.group(2).strip()
        if re.match(r"^[a-z0-9]+(?:-[a-z0-9]+)+$", name):
            continue
        elig, applied, declined = int(m.group(3)), int(m.group(4)), int(m.group(5))
        score = round((applied + declined) / elig * 100) if elig else 0
        seen.setdefault(tid, float(score))
    return [(f"T{i:02d}", seen[f"T{i:02d}"]) for i in range(1, 25)]


def matplotlib_radar(scores: list[tuple[str, float]], path: Path, title: str) -> None:
    try:
        import matplotlib.pyplot as plt
    except ImportError:
        subprocess.check_call([sys.executable, "-m", "pip", "install", "-q", "matplotlib"])
        import matplotlib.pyplot as plt

    labels = [t for t, _ in scores]
    values = [v for _, v in scores]
    N = len(values)
    angles = [n / float(N) * 2 * math.pi for n in range(N)]
    values_c = values + values[:1]
    angles_c = angles + angles[:1]

    fig, ax = plt.subplots(figsize=(10, 10), subplot_kw=dict(polar=True))
    ax.set_theta_offset(math.pi / 2)
    ax.set_theta_direction(-1)
    ax.set_thetagrids([a * 180 / math.pi for a in angles], labels, fontsize=7)
    ax.set_ylim(0, 100)
    ax.plot(angles_c, values_c, color="#1a7f37", linewidth=2)
    ax.fill(angles_c, values_c, color="#1a7f37", alpha=0.25)
    ax.set_title(title + "\n(TARGET design bar — NOT measured)", fontsize=12, pad=20)
    fig.tight_layout()
    fig.savefig(path, dpi=140)
    plt.close(fig)
    print(f"Wrote {path}")


def try_mega_card(timeout: int = 45) -> bool:
    if not VENDOR.exists() or not REPORT.exists():
        return False
    try:
        subprocess.run(
            [sys.executable, str(VENDOR), str(REPORT), "--name", "TARGET", "--out-dir", str(OUT)],
            check=True,
            timeout=timeout,
        )
        for p in OUT.glob("mega-pajeczyna-*.png"):
            dest = OUT / "target-100-megacard.png"
            p.replace(dest)
            print(f"mega-card → {dest}")
            return True
        return False
    except Exception as e:
        print(f"mega-card skipped ({e})", file=sys.stderr)
        return False


def main() -> None:
    ap = argparse.ArgumentParser()
    ap.add_argument("--mega-card", action="store_true", help="also try Chrome mega-card render")
    args = ap.parse_args()
    OUT.mkdir(parents=True, exist_ok=True)
    text = REPORT.read_text(encoding="utf-8")
    scores = parse_scores(text)
    matplotlib_radar(scores, OUT / "target-100-matplotlib.png", "MEGA TARGET 100%")
    # Keep packaged FUT PNGs; do not overwrite unless missing
    target = OUT / "target-100.png"
    if not target.exists():
        (OUT / "target-100-matplotlib.png").replace(target) if False else None
        target.write_bytes((OUT / "target-100-matplotlib.png").read_bytes())
    if args.mega_card:
        try_mega_card()
    print("Done. Remember: 100% charts are TARGET / design bar, not measured ORC.")


if __name__ == "__main__":
    main()
