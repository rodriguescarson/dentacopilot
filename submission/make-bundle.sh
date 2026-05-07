#!/usr/bin/env bash
# Builds the arXiv-ready tar.gz from the canonical paper sources.

set -euo pipefail

PAPER_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DRAFT_DIR="${PAPER_DIR}/draft"
FIG_DIR="${PAPER_DIR}/figures"
REF_BIB="${PAPER_DIR}/references/references.bib"
OUT_DIR="${PAPER_DIR}/submission"
STAGE="${OUT_DIR}/.stage"

# 1. Verify PDF still compiles
echo "→ Verifying tectonic build..."
( cd "${DRAFT_DIR}" \
  && cp "${REF_BIB}" ./references.bib 2>/dev/null || true \
  && tectonic --outdir "${OUT_DIR}" paper.tex >/dev/null )
echo "  → ${OUT_DIR}/paper.pdf"

# 2. Stage a flat directory
echo "→ Staging arXiv bundle layout..."
rm -rf "${STAGE}"
mkdir -p "${STAGE}"
cp "${DRAFT_DIR}/paper.tex" "${STAGE}/paper.tex"
cp "${REF_BIB}"             "${STAGE}/references.bib"
# arXiv prefers everything flat; rewrite figure include paths to be
# relative to the source root.
sed -i.bak 's|\\graphicspath{{../figures/}{./figures/}}|\\graphicspath{{./}{./figures/}}|' \
  "${STAGE}/paper.tex"
sed -i.bak 's|\\bibliography{../references/references}|\\bibliography{references}|' \
  "${STAGE}/paper.tex"
rm -f "${STAGE}/paper.tex.bak"
mkdir -p "${STAGE}/figures"
cp "${FIG_DIR}"/*.pdf "${STAGE}/figures/" 2>/dev/null || true

# 3. Compile inside the staged dir to confirm it self-builds
echo "→ Compiling inside the staged dir..."
( cd "${STAGE}" && tectonic paper.tex >/dev/null )
mv "${STAGE}/paper.pdf" "${OUT_DIR}/paper.pdf"

# 4. Tar it up
echo "→ Tarring..."
( cd "${STAGE}" && tar -czf "${OUT_DIR}/arxiv.tar.gz" \
    paper.tex references.bib figures/*.pdf )
SIZE=$(du -h "${OUT_DIR}/arxiv.tar.gz" | awk '{print $1}')
echo "  → ${OUT_DIR}/arxiv.tar.gz (${SIZE})"

# 5. Cleanup
rm -rf "${STAGE}"

echo
echo "Bundle ready. Upload to https://arxiv.org/submit"
echo "Metadata: see ${OUT_DIR}/arxiv-cover.txt"
