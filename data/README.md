# Paper 7 — code, data, and runs

**Paper:** *DentaCoPilot: An LLM-Augmented Next-Procedure Recommender for General Dentistry, Designed for Dentist Augmentation*
**Authors:** Carson Conception Rodrigues (CELABE, carson@celabe.com), Steffie Dione Rebello (KLE V K Institute of Dental Sciences)

## What lives here

```
data/
├── README.md              this file
├── requirements.txt       pinned Python deps (NO `anthropic` package — see below)
├── cc_compute.py          Claude Code compute wrapper — every LLM call goes through here
├── cc_compute_test.py     wrapper smoke test
├── cdt_codes.py           ADA CDT 2024 vocabulary + category map
├── tooth.py               Universal/FDI tooth-numbering helpers
├── synth_charts.py        synthetic chart generator (validates against bigram stats)
├── loaders/               public dataset loaders (DENTEX, MMDental, DenPAR)
├── models/                B0–B3 baselines + M1–M3 LLM models
├── calibration.py         temperature scaling + verbalized confidence
├── abstention.py          abstention threshold rule + coverage-risk
├── evaluate.py            single entry point — runs everything
├── plot_results.py        regenerates ../figures/* from results_*/
├── clinician_app/         lightweight Flask UI for KLE clinician study
├── clinician_analysis.py  per-arm agreement / time / override / Likert
├── results_<descriptor>/  one dir per run (timestamped or condition-named)
│   ├── config.json        git SHA + seed + model versions + CLI args
│   ├── results.json       per-trial raw metrics
│   ├── summary.json       aggregated metrics per condition
│   └── llm_calls.jsonl    every LLM call (prompt, response, model, latency, tokens)
└── cache/                 fetched datasets (gitignored, no PHI ever committed)
```

## Compute substrate — Claude Code, not the Anthropic API

Every LLM call in this paper goes through `cc_compute.py`, which shells out to the local `claude` CLI (Claude Code). This is a deliberate choice:

- **Cost.** Carson holds a paid Claude Code subscription. Compute should bill there, not to a separate metered Anthropic API account.
- **Reproducibility for review.** Every call is logged to `results_<run>/llm_calls.jsonl` with prompt, response, model, latency, and token counts. A reviewer can audit any decision without re-running the experiment.
- **No `import anthropic` anywhere.** The package is intentionally absent from `requirements.txt`. There is a CI grep guard in the smoke target.

If `claude` is not on `PATH`, scripts should fail loudly rather than silently fall back to a paid API.

## Run conventions

- **Seeds:** `random.seed(42); np.random.seed(42)` at the top of every script. Override with `--seed`.
- **Smoke vs full:** every script supports `--smoke` (tiny input, < 1 minute, < 50 LLM calls) and a full run (no flag).
- **Run-dir naming:** `results_smoke_<UTC-ISO>/` for smoke, `results_<condition>_<UTC-ISO>/` for full. Never overwrite an existing dir.
- **Reproducibility check:** running any non-LLM model twice with the same seed must produce byte-identical `summary.json`. LLM models reproduce within stochastic tolerance documented in the paper.

## Quick start

```bash
# from /Users/carson/Research/07-dental-procedure-prediction/
python -m venv venv
source venv/bin/activate
pip install -r data/requirements.txt

# verify Claude Code is reachable
claude --version

# smoke test the compute wrapper
python data/cc_compute_test.py

# smoke test everything
make smoke

# full run (assumes data is fetched)
make full
```

## What is NOT in this folder

- The Anthropic Python SDK (`anthropic`). Removed deliberately — see "Compute substrate" above.
- Raw patient data. Use `loaders/` to pull public datasets into `cache/`. KLE/BigMouth data is read live from access-controlled sources, never committed.
- Anything under `/Users/carson/Research/0[1-6]-*/` — Paper 7 is fully self-contained per the project's paper-isolation rule.
