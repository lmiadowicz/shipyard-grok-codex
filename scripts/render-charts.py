#!/usr/bin/env python3
"""Rebuild TARGET spider charts from charts/mega-assessment-TARGET-100.md.

Default: polished matplotlib radar (dark GitHub-ready showpiece).
Optional: --mega-card for Chrome headless FUT card via vendored skill.
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

# Short English labels for spokes (readable on README)
SHORT = {
    "T01": "Intent",
    "T02": "Framing",
    "T03": "State",
    "T04": "Anchor",
    "T05": "Constraints",
    "T06": "Done-when",
    "T07": "Understand",
    "T08": "Root-cause",
    "T09": "Evidence",
    "T10": "Disclose",
    "T11": "Economy",
    "T12": "Memory",
    "T13": "Inspect",
    "T14": "Capability",
    "T15": "Delegate",
    "T16": "Decompose",
    "T17": "Brief",
    "T18": "Rights",
    "T19": "Parallel",
    "T20": "Integrate",
    "T21": "Feedback",
    "T22": "Steer",
    "T23": "Verify",
    "T24": "Recover",
}


def parse_scores(text: str) -> list[tuple[str, str, float]]:
    seen: dict[str, tuple[str, float]] = {}
    for m in TRAIT_ROW.finditer(text):
        tid, name = m.group(1), m.group(2).strip()
        if re.match(r"^[a-z0-9]+(?:-[a-z0-9]+)+$", name):
            continue
        elig, applied, declined = int(m.group(3)), int(m.group(4)), int(m.group(5))
        score = round((applied + declined) / elig * 100) if elig else 0
        seen.setdefault(tid, (name, float(score)))
    out = []
    for i in range(1, 25):
        tid = f"T{i:02d}"
        name, score = seen.get(tid, (SHORT.get(tid, tid), 100.0))
        out.append((tid, name, score))
    return out


def matplotlib_radar(
    scores: list[tuple[str, str, float]],
    path: Path,
    *,
    title: str = "MEGA TARGET 100%",
    dark: bool = True,
) -> None:
    try:
        import matplotlib.pyplot as plt
        from matplotlib.patches import FancyBboxPatch
        import matplotlib.patheffects as pe
    except ImportError:
        subprocess.check_call([sys.executable, "-m", "pip", "install", "-q", "matplotlib"])
        import matplotlib.pyplot as plt
        from matplotlib.patches import FancyBboxPatch
        import matplotlib.patheffects as pe

    labels = [f"{tid}\n{SHORT.get(tid, tid)}" for tid, _, _ in scores]
    values = [v for _, _, v in scores]
    N = len(values)
    angles = [n / float(N) * 2 * math.pi for n in range(N)]
    values_c = values + values[:1]
    angles_c = angles + angles[:1]

    if dark:
        bg = "#0d1117"
        grid = "#30363d"
        spine = "#3fb950"
        fill = "#238636"
        text = "#e6edf3"
        muted = "#8b949e"
        accent = "#58a6ff"
        ring = "#21262d"
    else:
        bg = "#ffffff"
        grid = "#d0d7de"
        spine = "#1a7f37"
        fill = "#2da44e"
        text = "#1f2328"
        muted = "#656d76"
        accent = "#0969da"
        ring = "#f6f8fa"

    fig = plt.figure(figsize=(12.5, 12.5), facecolor=bg)
    ax = fig.add_axes([0.08, 0.08, 0.84, 0.78], projection="polar", facecolor=bg)
    ax.set_theta_offset(math.pi / 2)
    ax.set_theta_direction(-1)
    ax.set_ylim(0, 100)

    # Concentric rings
    ax.set_yticks([20, 40, 60, 80, 100])
    ax.set_yticklabels(["20", "40", "60", "80", "100"], fontsize=8, color=muted)
    ax.yaxis.grid(True, color=grid, linewidth=0.8, linestyle="-")
    ax.xaxis.grid(True, color=grid, linewidth=0.6)
    ax.spines["polar"].set_color(grid)
    ax.spines["polar"].set_linewidth(1.2)
    ax.set_rlabel_position(8)

    # Soft outer glow ring at 100
    ax.plot(angles_c, [100] * len(angles_c), color=spine, linewidth=1.0, alpha=0.35, zorder=1)

    # Main polygon
    ax.plot(
        angles_c,
        values_c,
        color=spine,
        linewidth=2.8,
        solid_capstyle="round",
        zorder=3,
        path_effects=[pe.SimpleLineShadow(offset=(0, 0), alpha=0.35, linewidth=6), pe.Normal()],
    )
    ax.fill(angles_c, values_c, color=fill, alpha=0.32, zorder=2)

    # Vertex markers
    ax.scatter(
        angles,
        values,
        s=42,
        c=spine,
        edgecolors=bg,
        linewidths=1.2,
        zorder=4,
    )

    ax.set_thetagrids([a * 180 / math.pi for a in angles], labels, fontsize=7.5, color=text)
    for lbl in ax.get_xticklabels():
        lbl.set_fontweight("medium")

    # Title block
    fig.text(
        0.5,
        0.965,
        title,
        ha="center",
        va="top",
        fontsize=22,
        fontweight="bold",
        color=text,
        fontfamily="sans-serif",
    )
    fig.text(
        0.5,
        0.925,
        "TARGET design bar — NOT a measured MEGA / ORC score",
        ha="center",
        va="top",
        fontsize=11,
        color=accent,
        fontfamily="sans-serif",
    )
    fig.text(
        0.5,
        0.018,
        "All 24 traits at 100% radius  ·  aspirational harness goal  ·  regenerate: scripts/render-charts.py",
        ha="center",
        va="bottom",
        fontsize=8.5,
        color=muted,
        fontfamily="sans-serif",
    )

    # Corner badge
    badge_ax = fig.add_axes([0.78, 0.86, 0.16, 0.08])
    badge_ax.set_xlim(0, 1)
    badge_ax.set_ylim(0, 1)
    badge_ax.axis("off")
    badge_ax.add_patch(
        FancyBboxPatch(
            (0.05, 0.15),
            0.9,
            0.7,
            boxstyle="round,pad=0.05,rounding_size=0.15",
            facecolor=ring,
            edgecolor=spine,
            linewidth=1.5,
        )
    )
    badge_ax.text(0.5, 0.55, "ORC 100", ha="center", va="center", fontsize=12, fontweight="bold", color=spine)
    badge_ax.text(0.5, 0.28, "TARGET", ha="center", va="center", fontsize=7, color=muted)

    path.parent.mkdir(parents=True, exist_ok=True)
    fig.savefig(path, dpi=180, facecolor=bg, edgecolor="none")
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
            dest = OUT / "examples" / "target-100-megacard-example.png"
            dest.parent.mkdir(parents=True, exist_ok=True)
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
    ap.add_argument("--light", action="store_true", help="light theme instead of dark")
    args = ap.parse_args()
    OUT.mkdir(parents=True, exist_ok=True)
    text = REPORT.read_text(encoding="utf-8")
    scores = parse_scores(text)
    # Force full radius for TARGET design bar
    scores = [(tid, name, 100.0) for tid, name, _ in scores]

    primary = OUT / "target-100.png"
    alt = OUT / "target-100-matplotlib.png"
    matplotlib_radar(scores, primary, dark=not args.light)
    # twin copy for explicit matplotlib filename
    alt.write_bytes(primary.read_bytes())
    print(f"Wrote {alt} (copy of primary)")

    if args.mega_card:
        try_mega_card()
    print("Done. Remember: 100% charts are TARGET / design bar, not measured ORC.")


if __name__ == "__main__":
    main()
