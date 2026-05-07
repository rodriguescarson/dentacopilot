# Pre-registration — DentaCoPilot

**To be deposited on OSF before any clinician participates and before the test split is read.**

**Authors:** Carson Conception Rodrigues (CELABE) · Steffie Dione Rebello (KLE V K Institute of Dental Sciences)
**Date drafted:** 2026-05-XX
**Status:** DRAFT — final version locked on OSF prior to test-split unblinding

---

## 1. Research questions

- **RQ1.** Does an LLM-based next-procedure recommender (DentaCoPilot, arm C) improve dentists' top-1 agreement with retrospective ground-truth treatment relative to dentist-alone (arm A) and a classical XGBoost recommender (arm B)?
- **RQ2.** Does it reduce time-to-decision relative to arms A and B?
- **RQ3.** Is calibrated abstention (arm C abstains when confidence < τ) associated with appropriate dentist behavior — i.e., do dentists override less often on covered cases than on cases where the system abstains?

## 2. Hypotheses

- **H1 (primary).** Mean top-1 agreement is highest in arm C, with the contrast C vs A statistically significant at α = 0.05, two-sided.
- **H2 (secondary).** Mean time-to-decision in arm C is at most 10% higher than in arm A. (We pre-commit to a non-inferiority contrast on time, so we cannot win on accuracy by burying a time regression.)
- **H3 (exploratory).** Override rate on covered cases is < override rate on abstained cases.

## 3. Design

Within-subject crossover. Each dentist sees three blocks of ~33 cases under arms A / B / C, block-to-arm randomized per dentist via Latin square. Cases are stratified to span all nine CDT categories with weights matching KLE's actual case mix.

## 4. Sample size

Target N = 12 dentists × ~33 cases per arm ≈ 400 case-arm observations per arm. Mixed-effects logistic regression (random intercept per dentist) gives ≥80% power to detect a Cohen's d = 0.4 difference in agreement at α = 0.05. If recruitment falls below N = 8, the study is reframed as a *pilot* with descriptive results only and **no inferential claims**.

## 5. Primary outcome

Top-1 agreement (binary) between dentist's pick and retrospective ground-truth procedure code (exact CDT match), per case-arm observation. Analyzed via mixed-effects logistic regression with random intercepts for dentist and for case, fixed effect for arm (treatment-coded with arm A as reference).

## 6. Secondary outcomes

- **S1.** Top-1 agreement allowing CDT *category* match instead of exact code (more lenient definition).
- **S2.** Time-to-decision (seconds), log-transformed for analysis. Random intercept per dentist.
- **S3.** Override rate in arms B and C: P(dentist's final pick ≠ recommender's top-1 | recommender provided a recommendation).
- **S4.** Trust (Likert 1–5), per case, per arm where applicable.

## 7. Models trained on the dev split (locked specification)

- **B0 — frequency baseline:** marginal P(p_{t+1} | p_t) bigram from the training split.
- **B1 — TF-IDF + logistic regression** on chart-token features.
- **B2 — XGBoost** on engineered chart-history features.
- **B3 — MultiTP-style CNN-RNN** reimplementation (Liu et al., AIM 2024) for direct comparator.
- **M1 — Claude Haiku** with structured chart prompt, top-K + verbalized confidence + abstain.
- **M2 — Claude Sonnet + chain-of-thought** with chart-citation rationale.
- **M3 — Claude Sonnet + retrieval** over the ADA-guidelines evidence corpus.

For the clinical-evaluation arm (B vs C contrast), the *frozen* models used are: **B = B2 (XGBoost)** and **C = whichever LLM model achieves the best calibrated top-1 accuracy on the dev split, locked before test-split unblinding**.

## 8. Calibration and abstention

- Temperature scaling on the dev split.
- Verbalized confidence prompt: model returns a self-rated confidence ∈ {low, medium, high}, mapped to thresholds.
- **Abstention threshold τ** is selected on the dev split as the smallest τ that achieves ≥95% precision on covered cases. **Locked before test-split unblinding.**

## 9. Stopping rules

- If the dev-split top-1 accuracy of the best LLM model is < the XGBoost baseline by more than 3 percentage points, the LLM arm is **not** taken to the clinical study; the paper reports a negative result.
- If recruitment yields fewer than 8 dentists, the study is reported as a pilot with descriptive results only; no inferential test is run on H1–H3.

## 10. Analyses we will NOT run

- We will not split the test set further "to find a subset where C wins."
- We will not change the abstention threshold τ after seeing the test split.
- We will not switch from exact CDT match to category match after seeing results.
- We will not drop dentists from analysis based on their performance.

Any post-hoc analyses are clearly labeled as exploratory and will not be used to support the primary claims.

## 11. Reproducibility

- All code open-sourced (MIT) at submission.
- All seeds fixed (`random.seed(42); numpy.seed(42); torch.manual_seed(42)`).
- All LLM calls logged to `data/results_<run>/llm_calls.jsonl` with prompt, response, model, latency, and token counts.
- A reviewer can replay every call from the logs without spending money on the Anthropic API; if they wish to re-execute, they do so through their own Claude Code subscription.
- This pre-registration's OSF DOI will be cited in the paper's methods section.
