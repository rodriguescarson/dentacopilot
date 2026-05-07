# Submission bundle — DentaCoPilot

This folder is staged for **preprint upload** of Paper 7. Carson performs
the actual upload (each venue requires individual submitter login).

**Read `PREPRINT-PATHS.md` first.** arXiv requires endorsement for first-time
cs.* submitters; we have several alternative paths that are at least as
credible for a clinical-AI paper (medRxiv recommended).

## Contents

```
submission/
├── README.md         this file
├── make-bundle.sh    builds the arXiv-ready tar.gz from the canonical sources
├── arxiv-cover.txt   suggested arXiv submission metadata (title, abstract, categories)
└── (after running make-bundle.sh)
    ├── arxiv.tar.gz   main upload artifact
    └── paper.pdf       inspection copy
```

## How to upload

1. From the paper folder root, run:

   ```bash
   ./submission/make-bundle.sh
   ```

   This re-runs `tectonic` once to make sure everything compiles, then
   tar's the LaTeX source + figures + bibliography into
   `submission/arxiv.tar.gz`.

2. Open https://arxiv.org/submit (Carson's account; we don't have it
   here). Upload `submission/arxiv.tar.gz`.

3. Use the metadata from `arxiv-cover.txt` for title, abstract, and
   primary / secondary categories.

4. After arXiv processes the source, **save the arXiv ID** (e.g.
   `2605.NNNNN`) and add it to:

   - `references/references.bib` if we self-cite the preprint later
   - The corresponding-author email signature
   - The paper's social-media + email announcement

## What NOT to include in the upload

- `data/results_*/` — these are large reproducibility artifacts, kept
  in the GitHub repo, not on arXiv.
- `data/cache/` — datasets, gitignored.
- `notes/` — internal planning, not part of the manuscript.

`make-bundle.sh` filters these automatically.
