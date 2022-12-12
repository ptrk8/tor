
SEL4CP_SUBMODULE = "./sel4cp"


.PHONY: init
init:
	cd $(SEL4CP_SUBMODULE) && \
		  git checkout main && \
		  git fetch origin pull/11/head:lucy && \
		  git checkout lucy
