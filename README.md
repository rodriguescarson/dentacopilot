# DentaCoPilot

**An LLM-Augmented Next-Procedure Recommender for General Dentistry, Designed for Dentist Augmentation**

Carson Conception Rodrigues (CELABE) · Steffie Dione Rebello (KLE Vishwanath Katti Institute of Dental Sciences, Belgaum, India)

📄 **Preprint:** [medRxiv 10.64898/2026.05.07.26352635](https://medrxiv.org/cgi/content/short/2026.05.07.26352635v1)

---

## What this is

DentaCoPilot is a clinician-augmenting recommender that, given a patient's structured chart, returns:

1. A calibrated top-K probability distribution over Current Dental Terminology (CDT) codes for the next procedure
2. A verbalised confidence label (`low` / `medium` / `high`)
3. An explicit `abstain` flag when chart context is genuinely insufficient
4. A chart-grounded rationale

It is designed and evaluated as **decision support** for dentists, not as an autonomous classifier.

The headline empirical finding (M5): **prompt-conditioning a small LLM on a classical baseline's top-K candidates closes the LLM-vs-baseline accuracy gap on synthetic dental procedure-prediction data**, raising top-5 from 0.733 to 0.933 — matching classical baselines while preserving rationale and abstention.

## What's in this repo

| Path | Contents |
|---|---|
| `draft/paper.tex` | The full manuscript (LaTeX source; PDF builds via `make pdf`) |
| `references/references.bib` | Bibliography (48 entries) |
| `figures/` | Figures 1–5 (PDF + PNG) |
| `data/` | All code: synthetic chart generator, baselines, LLM models, eval harness, calibration, abstention, plotting |
| `data/models/` | B0–B3 classical baselines, M1–M6 LLM variants |
| `data/loaders/` | DENTEX, MMDental, DenPAR public-dataset loaders |
| `data/evidence_corpus/` | 20-card open-source clinical-evidence corpus for the M3 retrieval variant |
| `data/results_*/` | Per-run experimental records: `config.json`, `results.json`, `summary.json`, `llm_calls.jsonl` (full LLM-call audit logs) |
| `notes/` | Planning notes, BigMouth proposal materials, OSF-style preregistration draft, KLE IRB protocol draft |
| `submission/` | medRxiv / OSF Preprints / Research Square submission folders + bundle scripts |
| `Makefile`, `build.sh` | Self-contained PDF + DOCX build (tectonic + pandoc) |

## Quick start

```bash
# Install Python deps (the `anthropic` SDK is deliberately NOT included — see below)
pip install -r data/requirements.txt

# Verify the Claude Code CLI is available (LLM compute substrate)
claude --version

# Run a full smoke pass (no LLM cost, ~2 minutes)
make smoke

# Run the full baseline pipeline (n=500 synthetic charts)
make full

# Build the PDF
make pdf
```

## Compute substrate — Claude Code, not the Anthropic API

Every LLM inference call in this work is routed through the local Anthropic Claude Code CLI via a single subprocess wrapper at `data/cc_compute.py`. We deliberately do **not** import the Anthropic Python SDK — there is a CI grep guard (`make check-no-anthropic`) that enforces this.

Reasons:

1. **Audit trail.** Every LLM call is logged to `data/results_<run>/llm_calls.jsonl` with prompt, response, model identifier, latency, and token counts. A reviewer can replay any decision the system makes from the logs alone.
2. **Cost.** Researchers with a Claude Code subscription pay no marginal cost; the experiment becomes reproducible by replay rather than re-execution.
3. **Operational simplicity.** One auth, one wrapper, one log file.

## Reproducibility

* Seeds fixed: `random.seed(42)`, `numpy.random.seed(42)`, `torch.manual_seed(42)`.
* Each run writes `config.json` with git SHA + CLI args + Python and platform version.
* Per-trial predictions and gold labels in `results.json`.
* Aggregated metrics in `summary.json`.
* Full LLM call audit in `llm_calls.jsonl`.

Re-running any baseline with the same seed reproduces `summary.json` byte-for-byte; LLM models reproduce within the stochastic tolerance documented in the manuscript.

## Status

* **First-stage methods + framework paper** — synthetic-data results only.
* **Pre-registered next-stage work**: (a) the multi-institutional BigMouth dental data repository (controlled access; application pending) and (b) a retrospective chart pull at the KLE V K Institute conducted under the institution's standard ethics-review process. The clinician-in-the-loop study at KLE is the empirical test of the augmentation framing.

## Citing

If you use this code or build on the M5 design, please cite:

```
Rodrigues, C. C. & Rebello, S. D. (2026). DentaCoPilot: An LLM-Augmented
Next-Procedure Recommender for General Dentistry, Designed for Dentist
Augmentation. medRxiv 2026.05.07.26352635.
https://doi.org/10.64898/2026.05.07.26352635
```

BibTeX:

```bibtex
@article{rodrigues2026dentacopilot,
  title   = {{DentaCoPilot}: An {LLM}-Augmented Next-Procedure Recommender for General Dentistry, Designed for Dentist Augmentation},
  author  = {Rodrigues, Carson Conception and Rebello, Steffie Dione},
  journal = {medRxiv},
  year    = {2026},
  doi     = {10.64898/2026.05.07.26352635},
  url     = {https://medrxiv.org/cgi/content/short/2026.05.07.26352635v1}
}
```

## Licence

Code and synthetic chart generator: **MIT** (see `LICENSE`).
Manuscript and figures: **CC BY 4.0** (per the medRxiv submission).

## Contact

Carson Conception Rodrigues — `carson@celabe.com`
