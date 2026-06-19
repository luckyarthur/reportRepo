#!/usr/bin/env bash
# Install parsers required by tasks/13-book-chapter-summaries.
# Run from the repo root.

set -e

echo "[setup-book-tools] Installing PDF / MOBI / EPUB parsers..."

# pymupdf  -> PDF text extraction (used as: import fitz)
# mobi     -> MOBI -> HTML extraction
# ebooklib -> EPUB convenience layer (zipfile also works as a fallback)
python3 -m pip install --quiet --user --no-warn-script-location \
  pymupdf mobi ebooklib

python3 - <<'PY'
import importlib
for mod in ("fitz", "mobi", "ebooklib"):
    importlib.import_module(mod)
print("[setup-book-tools] OK: fitz (pymupdf), mobi, ebooklib all import cleanly")
PY
