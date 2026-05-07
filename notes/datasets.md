# Dataset shortlist (decision matrix)

Last updated: 2026-05-02

## Tier 1 — primary candidates (procedure-history / EHR)

### BigMouth Dental Data Repository (UTHealth Houston)
- URL: https://www.uth.edu/bigmouth/ · NIH mirror: https://www.ddshub.nih.gov/data-sources/human-phenotype-data/bigmouth-data
- Scale: ~6M patients, multi-institutional dental schools.
- Coding: CDT + CPT procedure codes; diagnoses; demographics; medical history.
- Access: Controlled. Email proposal to BigMouth@uth.tmc.edu. Project review committee with reps from each contributing school.
- Why it fits: Only public-ish corpus with real CDT procedure sequences at scale. The exact signal we need.
- Effort: Medium — written proposal, IRB, signed DUA. Plan for 4–8 wk turnaround.
- Reference paper: Walji et al., JAMIA 2022.

### Patel et al. linked EHR-EDR cohort (Temple)
- URL: https://journals.sagepub.com/doi/10.1177/23800844251408849
- Scale: 20,946 adult patients, EHR + EDR linked.
- Why: Recent (2026), already used for prediction modeling, demonstrates feasibility.
- Access: Likely on request to corresponding author (J.S. Patel).
- Effort: Low–medium. Email + DUA.

### MultiTP authors' dataset (Liu et al., AIM 2024)
- URL: https://www.sciencedirect.com/science/article/abs/pii/S0933365723002488
- Scale: unclear; partial edentulism only.
- Why: Direct comparator. We can replicate their setup and add LLM models on the same data.
- Access: Email authors.

## Tier 2 — imaging (for chart context grounding)

### DENTEX (MICCAI '23 grand-challenge)
- URL: https://dentex.grand-challenge.org/data/
- Scale: 693 quadrant + 634 tooth + 1005 fully labeled panoramic.
- Classes: caries, deep caries, periapical lesions, impacted teeth.
- License: Research / challenge use. Must register.

### MMDental (Sci Data 2025)
- URL: https://www.nature.com/articles/s41597-025-05398-7
- Scale: 660 patients, 3D CBCT + expert medical records (rare combo of imaging + chart).
- License: CC BY (open).

### TED3 aggregated panoramic
- URL: arxiv 2509.09254
- Scale: 16,639 unique panoramic, aggregated from 18 sources.
- License: mixed; verify per-source.
- Use: pretraining only.

### DenPAR — periapical (Sci Data 2025)
- URL: https://www.nature.com/articles/s41597-025-05906-9
- Scale: annotated periapical radiographs.
- License: open.

### Children's panoramic (Sci Data 2023)
- URL: https://www.nature.com/articles/s41597-023-02237-5
- Scale: 93 pediatric + ~2,599 adult from 3 datasets = 2,692.
- License: open.

### Multi-center panoramic (PMC11031544)
- 2,555 impacted-teeth + 2,735 periodontitis + 1,246 caries.

## Tier 3 — local clinical (KLE, fallback / augmentation arm)

### KLE V K Institute of Dental Sciences EHR
- Steffie's home institution; KLE-side ethics sponsorship to be confirmed by Steffie before any clinical-data work begins.
- Realistic scope: 200–500 retrospective de-identified charts.
- Why valuable: enables matched clinician-in-the-loop study on the same population — methodological strength even if BigMouth comes through.

## Tier 4 — synthetic (always-available backup)

- Generate CDT procedure sequences from published bigram statistics + tooth-level constraints + patient-trajectory templates.
- Validate against any small real cohort we obtain.
- Release the generator as open source — that itself is a contribution.

## Decision

- **Apply to BigMouth Week 1.**
- **In parallel** start on DENTEX + DenPAR + MMDental for imaging context, and synthetic generator for procedure sequences.
- **In parallel** Steffie initiates KLE IRB conversation.
- Final dataset choice locked by Week 4.
