
SEL4_SUBMODULE = "./seL4"
SEL4CP_SUBMODULE = "./sel4cp"

SEL4_COMMIT = "92f0f3ab28f00c97851512216c855f4180534a60"

# ==================================
# Initialisation
# ==================================

.PHONY: init
init: init-sel4cp init-sel4 \

# Makes sure you check out Lucy's sel4cp PR.
.PHONY: init-sel4cp
init-sel4cp:
	cd $(SEL4CP_SUBMODULE) && \
		  git checkout main && \
		  git fetch origin pull/11/head:lucy && \
		  git checkout lucy

# Makes sure you use this seL4 commit hash: https://github.com/BreakawayConsulting/sel4cp#sel4-version
.PHONY: init-sel4
init-sel4:
	cd $(SEL4_SUBMODULE) && \
		  git checkout $(SEL4_COMMIT)

# ==================================
# Build
# ==================================

.PHONY: build
build: build-sel4cp \

.PHONY: build-sel4cp
build-sel4cp:
	cd $(SEL4CP_SUBMODULE) && \
		python3.9 -m venv sel4cp_venv



