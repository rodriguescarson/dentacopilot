# Paper 7 — DentaCoPilot
# Self-contained: never invokes the repo-root build.sh and never touches other papers.

.PHONY: help smoke full pdf docx figures clean check-no-anthropic check-claude-cli verify

PYTHON ?= python3
PAPER_DIR := $(CURDIR)
DATA_DIR  := $(PAPER_DIR)/data
DRAFT_DIR := $(PAPER_DIR)/draft
FIG_DIR   := $(PAPER_DIR)/figures
BUILD_DIR := $(PAPER_DIR)/build

help:
	@echo "Paper 7 — DentaCoPilot. Targets:"
	@echo "  make smoke               run smoke checks for every unit"
	@echo "  make full                run the full experiment pipeline"
	@echo "  make pdf                 build paper.pdf via tectonic"
	@echo "  make docx                build paper.docx via pandoc"
	@echo "  make figures             regenerate ../figures/ from latest results_*/"
	@echo "  make verify              run all reproducibility checks"
	@echo "  make clean               remove build/ and __pycache__"

# ---------------------------------------------------------------------------
# Reproducibility guards
# ---------------------------------------------------------------------------

check-no-anthropic:
	@echo "→ Checking that no script imports the anthropic SDK..."
	@! grep -rEn '^[[:space:]]*(import|from)[[:space:]]+anthropic' $(DATA_DIR) \
	  || (echo "ERROR: anthropic SDK is forbidden. Use cc_compute.py."; exit 1)
	@echo "  OK — no anthropic imports."

check-claude-cli:
	@echo "→ Checking that the Claude Code CLI is available..."
	@command -v claude > /dev/null \
	  || (echo "ERROR: 'claude' CLI not found on PATH. Install Claude Code."; exit 1)
	@echo "  OK — claude CLI is available."

# ---------------------------------------------------------------------------
# Smoke
# ---------------------------------------------------------------------------

smoke: check-no-anthropic
	@echo "→ CDT vocab smoke..."
	$(PYTHON) -c "import sys; sys.path.insert(0, 'data'); from cdt_codes import CDT_CODES, CATEGORIES; print(len(CDT_CODES), 'CDT codes loaded across', len(CATEGORIES), 'categories')"
	@echo "→ Synthetic chart generator smoke (n=20)..."
	$(PYTHON) $(DATA_DIR)/synth_charts.py generate --n 20 --seed 42 --out $(DATA_DIR)/cache/synth_smoke.json > /dev/null
	@echo "→ Baselines smoke (b0 b1 b2 on n=100)..."
	$(PYTHON) $(DATA_DIR)/evaluate.py --models b0 b1 b2 --smoke
	@echo "→ Plot smoke results..."
	$(PYTHON) $(DATA_DIR)/plot_results.py --latest --kind smoke
	@echo "Smoke complete."

# Live LLM smoke — opt-in, since it spends a Claude Code call
smoke-llm: check-no-anthropic check-claude-cli
	@echo "→ Compute wrapper round-trip smoke (uses 1 Claude call)..."
	$(PYTHON) $(DATA_DIR)/cc_compute_test.py

# ---------------------------------------------------------------------------
# Full pipeline
# ---------------------------------------------------------------------------

full: check-no-anthropic
	@echo "→ Generating synthetic corpus (n=500)..."
	$(PYTHON) $(DATA_DIR)/synth_charts.py generate --n 500 --seed 42 --out $(DATA_DIR)/cache/synth_n500.json > /dev/null
	@echo "→ Running baselines (b0 b1 b2 on n=500)..."
	$(PYTHON) $(DATA_DIR)/evaluate.py --models b0 b1 b2 --n-charts 500
	@echo "→ Generating figures..."
	$(PYTHON) $(DATA_DIR)/plot_results.py --latest --kind full
	@echo "Full baseline pipeline complete."

# Full pipeline including LLM models — opt-in, spends quota
full-llm: check-no-anthropic check-claude-cli
	@echo "→ Generating synthetic corpus (n=500)..."
	$(PYTHON) $(DATA_DIR)/synth_charts.py generate --n 500 --seed 42 --out $(DATA_DIR)/cache/synth_n500.json > /dev/null
	@echo "→ Running baselines (b0 b1 b2 b3 on n=500)..."
	$(PYTHON) $(DATA_DIR)/evaluate.py --models b0 b1 b2 b3 --n-charts 500
	@echo "→ Running LLMs (m1 m2 m3 on capped subsample)..."
	$(PYTHON) $(DATA_DIR)/evaluate.py --models m1 m2 m3 --n-charts 500 --llm-cap 30
	@echo "→ Finalizing — combining + plotting + summary..."
	$(PYTHON) $(DATA_DIR)/finalize_stage3.py

# Just the finalize step — useful when you've already run baselines + LLMs
finalize:
	$(PYTHON) $(DATA_DIR)/finalize_stage3.py

# ---------------------------------------------------------------------------
# Paper build
# ---------------------------------------------------------------------------

pdf:
	@mkdir -p $(BUILD_DIR)/draft
	cd $(DRAFT_DIR) && tectonic --outdir $(BUILD_DIR)/draft paper.tex

docx:
	@mkdir -p $(BUILD_DIR)/draft
	@echo "→ DOCX via pandoc (best-effort; PDF is the primary submission format)..."
	-cd $(DRAFT_DIR) && pandoc paper.tex -o $(BUILD_DIR)/draft/paper.docx \
	    --bibliography=$(PAPER_DIR)/references/references.bib \
	    --citeproc 2>&1 | tail -5
	@if [ -f $(BUILD_DIR)/draft/paper.docx ]; then \
	    echo "  → $(BUILD_DIR)/draft/paper.docx"; \
	else \
	    echo "  (DOCX build failed; PDF still available at $(BUILD_DIR)/draft/paper.pdf)"; \
	fi

figures:
	$(PYTHON) $(DATA_DIR)/plot_results.py --out $(FIG_DIR)

# ---------------------------------------------------------------------------
# Verification
# ---------------------------------------------------------------------------

verify: check-no-anthropic check-claude-cli smoke
	@echo "→ Determinism check (B0 baseline run twice with same seed)..."
	@# placeholder — wire up once evaluate.py exists
	@echo "  (skipped — evaluate.py not yet implemented)"

clean:
	rm -rf $(BUILD_DIR) $(DATA_DIR)/__pycache__ $(DATA_DIR)/.pytest_cache
