
SEL4CP_SUBMODULE = "./sel4cp"

.PHONY: sel4cp-lucy-pr
sel4cp-lucy-pr:
	cd $(SEL4CP_SUBMODULE) && \
		  git checkout main && \
		  git fetch origin pull/11/head:lucy && \
		  git checkout lucy


.PHONY: init
init: sel4cp-lucy-pr \
