
SEL4CP_SUBMODULE = "./sel4cp"

# ==================================
# Initialisation
# ==================================

.PHONY: init
init: init-sel4cp \

# Makes sure you check out Lucy's sel4cp PR.
.PHONY: init-sel4cp
init-sel4cp:
	cd $(SEL4CP_SUBMODULE) && \
		  git checkout main && \
		  git fetch origin pull/11/head:lucy && \
		  git checkout lucy

# ==================================
# Build
# ==================================

.PHONY: build
build: build-sel4cp \

.PHONY: build-sel4cp
build-sel4cp:
	cd $(SEL4CP_SUBMODULE) && \
		# Create a Python virtual environment
		python3.9 -m venv sel4cp_venv



