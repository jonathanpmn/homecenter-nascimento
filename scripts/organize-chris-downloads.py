#!/usr/bin/env python3
"""Extrai zips das temporadas de Chris em Downloads e organiza para Jellyfin."""
from __future__ import annotations

import glob
import os
import re
import shutil
import sys
import zipfile

DOWNLOADS = os.path.expanduser("~/Downloads")
SHOW = "Todo Mundo Odeia o Chris"
DEST_ROOT = os.path.join(os.path.expanduser("~/Media/Series"), SHOW)
EP_RE = re.compile(r"T(\d+)_\s*Epis[oó]dio\s*(\d+)", re.IGNORECASE)
SEASON_PREFIXES = ("1ª", "2ª", "3ª", "4ª")


def season_num(prefix: str) -> int:
    return int(prefix[0])


def main() -> int:
    os.makedirs(DEST_ROOT, exist_ok=True)
    total = 0
    skipped = 0

    for sp in SEASON_PREFIXES:
        sn = season_num(sp)
        season_dir = os.path.join(DEST_ROOT, f"Season {sn:02d}")
        os.makedirs(season_dir, exist_ok=True)
        zips = sorted(glob.glob(os.path.join(DOWNLOADS, f"{sp} Temporada-*.zip")))
        if not zips:
            print(f"Aviso: nenhum zip para {sp} temporada", file=sys.stderr)

        for zpath in zips:
            print(f"ZIP: {os.path.basename(zpath)}")
            with zipfile.ZipFile(zpath) as zf:
                for info in zf.infolist():
                    if not info.filename.lower().endswith(".mkv"):
                        continue
                    base = os.path.basename(info.filename)
                    m = EP_RE.search(base)
                    if not m:
                        print(f"  ignorado (nome): {base}", file=sys.stderr)
                        skipped += 1
                        continue
                    s, e = int(m.group(1)), int(m.group(2))
                    out = os.path.join(season_dir, f"{SHOW} - S{s:02d}E{e:02d}.mkv")
                    if os.path.isfile(out) and os.path.getsize(out) > 0:
                        print(f"  já existe: {os.path.basename(out)}")
                        continue
                    print(f"  -> {os.path.basename(out)}")
                    with zf.open(info) as src, open(out, "wb") as dst:
                        shutil.copyfileobj(src, dst)
                    total += 1

    print(f"\nConcluído: {total} extraídos, {skipped} ignorados.")
    print(f"Pasta: {DEST_ROOT}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
