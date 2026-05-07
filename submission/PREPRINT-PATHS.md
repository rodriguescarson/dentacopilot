# Preprint paths — pick one (or do several in parallel)

arXiv blocked you on endorsement. That's normal for first-time cs.* submitters.
Two ways forward:

1. **Skip arXiv for now** — use medRxiv, OSF Preprints, or Research Square.
   These are at least as credible for a clinical-AI paper and don't gate on
   endorsement.
2. **Get an arXiv endorser** — one-time per category; once you're endorsed
   you can submit any future cs.CL / cs.LG paper without further endorsement.

Recommendation: **submit to medRxiv now** (no endorsement, DOI, dental-journal
editors trust it), and **request arXiv endorsement in parallel** so it's ready
for Paper B (the Sci Data spinoff).

---

## Option A — medRxiv (RECOMMENDED for this paper)

medRxiv is operated by Cold Spring Harbor Laboratory + BMJ + Yale. It's the
standard preprint server for clinical AI in 2026. JDR, JADA, and JDR-CTR all
accept medRxiv preprints.

### What you need
- Carson + Steffie author info (Steffie's KLE affiliation is your academic
  anchor; CELABE is your sponsor).
- The PDF (`submission/paper.pdf`).
- A short plain-language summary (under 200 words). Drafted in
  `submission/medrxiv/plain-summary.txt`.
- The competing-interests + funding statements
  (`submission/medrxiv/disclosures.txt`).
- An ORCID for at least one author (Carson should have one; if not,
  https://orcid.org/register takes ~2 minutes).

### How to submit
1. Open https://www.medrxiv.org/submit-a-manuscript
2. Sign in (or register; medRxiv accepts non-academic emails).
3. Upload `submission/paper.pdf` as the manuscript file.
4. Paste the title and the abstract from `submission/arxiv-cover.txt`.
5. Add authors (Carson Conception Rodrigues — CELABE; Steffie Dione Rebello
   — KLE Vishwanath Katti Institute of Dental Sciences). Both need
   institutional emails and ORCIDs at submission time.
6. Choose subject area: **Health Informatics** (primary).
   Secondary: **Dentistry and Oral Medicine**.
7. Paste the disclosures.
8. Submit. Posting typically takes 1–3 business days after triage.

### After posting
- You get a DOI like `10.1101/2026.05.NN.NNNNNNN` and a citable URL.
- Add the DOI to:
  - The BigMouth proposal email (`notes/bigmouth-proposal-final.txt`)
  - The KLE IRB protocol (`notes/kle-irb-protocol.md`)
  - Carson's CV / LinkedIn

---

## Option B — OSF Preprints (parallel to medRxiv, fast, simple)

OSF Preprints is run by the Center for Open Science. No endorsement, immediate
posting, gets a DOI. Lower prestige than medRxiv for clinical work but higher
discoverability via OSF's project pages — and we're already going to deposit
the **preregistration** on OSF (per `notes/preregistration.md`), so co-locating
the preprint is convenient.

### How to submit
1. Open https://osf.io/preprints/
2. Sign in / register.
3. Click **"Add a preprint"**.
4. Provider: **OSF Preprints** (general) or **MedArXiv** (medical-specific
   provider hosted on OSF — different from medRxiv).
5. Upload `submission/paper.pdf`.
6. Title + abstract from `submission/arxiv-cover.txt`.
7. Tags: dental AI, clinical decision support, large language models,
   procedure prediction, augmentation, calibration.
8. License: **CC-BY 4.0** (matches our MIT code license).
9. Link the preregistration project once it's deposited.

---

## Option C — Research Square (Springer Nature, "In Review")

If you go with a journal that has Springer's "In Review" partnership
(Frontiers in Dental Medicine doesn't; *Scientific Reports* does), the
Research Square preprint is auto-deposited at submission. Otherwise:

1. Open https://www.researchsquare.com/
2. Upload PDF.
3. Same metadata as medRxiv.
4. Posts within 24 hours; DOI issued.

Trade-off: Research Square has lower citation impact than medRxiv but is
faster and totally hands-off.

---

## arXiv endorsement workaround (for Paper B and beyond)

arXiv's endorsement requirement is one-time per category. Once you're
endorsed in cs.CL (say), you can post any future cs.CL / cs.LG / cs.AI paper.

### Who can endorse you?
Anyone with an active arXiv submission in the same category. Pragmatic
candidates from your network:

- **Oysturn Vas** (University of Waterloo, your Voice AI Latency co-author).
  Likely has arXiv submissions in cs.CL / cs.SD given a Waterloo affiliation
  and an ASR research orientation.
- **Authors of MultiTP** (Liu et al., AIM 2024) — direct prior-art author,
  may have arXiv submissions; reach out citing the comparator relationship.
- **Authors of the DENTEX 2023 challenge** (Hamamci et al.) — MICCAI
  community is very arXiv-active.
- **Anyone you've co-authored with on Papers 1–6** if any of them have arXiv
  credit.

### The ask (template, paste into email or DM)

Draft in `submission/arxiv-endorsement-request.txt`. The pattern is:
- Be specific about which paper you want endorsed (give the paper title +
  abstract).
- Make it clear you only need them to click a single arXiv endorsement link
  — no review, no commitment.
- Offer to reciprocate / send the published version later as a courtesy.

### Endorsement code path

Once you have someone willing:
1. They go to https://arxiv.org/auth/endorse?x=ABC123 (you'll generate that
   link from your arXiv account once you have one).
2. They click "Endorse".
3. You can submit. The endorsement is permanent in that category.

---

## What I'd actually do (if I were Carson)

1. **Tonight**: submit to medRxiv. Draft is in `submission/medrxiv/`. ~30
   minutes of clicking, including ORCID setup.
2. **Tonight**: also post to OSF Preprints — ~10 minutes.
3. **This week**: email Oysturn Vas asking for arXiv cs.CL endorsement.
   Use the template in `submission/arxiv-endorsement-request.txt`.
4. **Once endorsed**: re-do `make-bundle.sh` and submit to arXiv.

medRxiv + OSF cover the citable-DOI need today; arXiv adds visibility within
the cs research community for Paper B.
