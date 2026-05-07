#!/usr/bin/env bash
# Paper 7 — DentaCoPilot
# Self-contained build script. Does NOT use the repo-root build.sh.
# Builds PDF (tectonic) + DOCX (pandoc with figure-format conversion).

set -euo pipefail

PAPER_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DRAFT_DIR="${PAPER_DIR}/draft"
FIG_DIR="${PAPER_DIR}/figures"
REF_BIB="${PAPER_DIR}/references/references.bib"
BUILD_DIR="${PAPER_DIR}/build/draft"

mkdir -p "${BUILD_DIR}"

# ----------------------------------------------------------------------
# PDF — tectonic resolves \graphicspath{{../figures/}} relative to draft/
# ----------------------------------------------------------------------
echo "→ Building PDF via tectonic..."
( cd "${DRAFT_DIR}" \
  && cp "${REF_BIB}" ./references.bib 2>/dev/null || true \
  && tectonic --outdir "${BUILD_DIR}" paper.tex )
echo "  → ${BUILD_DIR}/paper.pdf"

# ----------------------------------------------------------------------
# DOCX — pandoc cannot embed PDF figures; convert PDF → PNG with sips
# ----------------------------------------------------------------------
echo "→ Preparing PNG copies of any PDF figures (for DOCX embedding)..."
if [ -d "${FIG_DIR}" ]; then
  for pdf in "${FIG_DIR}"/*.pdf; do
    [ -e "${pdf}" ] || continue
    png="${pdf%.pdf}.png"
    if [ ! -f "${png}" ] || [ "${pdf}" -nt "${png}" ]; then
      echo "  → ${png}"
      if command -v sips >/dev/null 2>&1; then
        sips -s format png "${pdf}" --out "${png}" >/dev/null
      else
        echo "    (sips unavailable; skipping ${pdf} — DOCX may show blank figure)"
      fi
    fi
  done
fi

echo "→ Building DOCX via pandoc..."
TMP_TEX="$(mktemp /tmp/paper7.XXXXXX.tex)"
python3 - "${DRAFT_DIR}/paper.tex" "${TMP_TEX}" <<'PY'
import sys, re, pathlib
src, dst = sys.argv[1], sys.argv[2]
text = pathlib.Path(src).read_text()
# Pandoc's LaTeX reader chokes on PDF figures in DOCX; rewrite to .png references
text = re.sub(r'\.pdf\}', r'.png}', text)
pathlib.Path(dst).write_text(text)
PY

( cd "${DRAFT_DIR}" \
  && pandoc "${TMP_TEX}" -o "${BUILD_DIR}/paper.docx" \
       --bibliography="${REF_BIB}" --citeproc \
       --resource-path=".:..:${FIG_DIR}" )
rm -f "${TMP_TEX}"
echo "  → ${BUILD_DIR}/paper.docx"

echo
echo "Build complete:"
ls -la "${BUILD_DIR}"
