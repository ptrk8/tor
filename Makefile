
PWD_DIR = "$(shell basename $$(pwd))"
SEL4_SUBMODULE = $(PWD)/seL4
SEL4CP_SUBMODULE = $(PWD)/sel4cp

SEL4_COMMIT = 92f0f3ab28f00c97851512216c855f4180534a60

SERVER_USER_HOST = patrick@vm_comp4961_ubuntu1804
SERVER_REMOTE_DIR = ~/remote/$(shell hostname -s)/

SEL4CP_PYTHON_VENV_NAME = sel4cp_venv
SEL4CP_PYTHON_VENV_PATH = $(SEL4CP_SUBMODULE)/$(SEL4CP_PYTHON_VENV_NAME)
SEL4CP_PYTHON_VENV_PYTHON = $(SEL4CP_PYTHON_VENV_PATH)/bin/python
SEL4CP_PYTHON_REQUIREMENTS = $(SEL4CP_SUBMODULE)/requirements.txt

# =================================
# Generated Files
# =================================
SEL4CP_SDK = $(SEL4CP_SUBMODULE)/release

# =================================
# Clean
# =================================

.PHONY: clean
clean:
	rm -rf $(SEL4CP_PYTHON_VENV_PATH)
	rm -rf $(SEL4CP_SDK)

.PHONY: clean-remote
clean-remote: push-home
	ssh -t $(SERVER_USER_HOST) "\
		cd $(SERVER_REMOTE_DIR)$(PWD_DIR) ; \
		make clean ; "

# =================================
# Push to remote servers
# =================================

push-home:
	# Make the directory on the remote if it doesn't exist already.
	ssh -t $(SERVER_USER_HOST) "mkdir -p $(SERVER_REMOTE_DIR)$(PWD_DIR)"
	# Sync our current directory with the remote.
	rsync -a \
 			--delete \
 			--exclude "$(SEL4CP_PYTHON_VENV_NAME)" \
 			./ $(SERVER_USER_HOST):$(SERVER_REMOTE_DIR)$(PWD_DIR)

# ==================================
# Initialisation
# ==================================

.PHONY: init
init: init-sel4cp init-sel4 \

.PHONY: init-sel4cp
init-sel4cp:
	# Checkout Lucy's sel4cp PR.
	cd $(SEL4CP_SUBMODULE) && \
		  git checkout main && \
		  git fetch origin pull/11/head:lucy && \
		  git checkout lucy
	# Create Python Virtual Environment
	python3.9 -m venv $(SEL4CP_PYTHON_VENV_PATH)
	# Upgrade pip, setuptools and wheel.
	$(SEL4CP_PYTHON_VENV_PYTHON) -m pip install --upgrade pip setuptools wheel
	# Install Python requirements into Virtual Environment.
	$(SEL4CP_PYTHON_VENV_PYTHON) -m pip install -r $(SEL4CP_PYTHON_REQUIREMENTS)
	# Install missing Python requirements into Virtual Environment.
	$(SEL4CP_PYTHON_VENV_PYTHON) -m pip install six future

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

# ==================================
# Core Platform Build Steps
# ==================================

.PHONY: fix-sel4
fix-sel4:
	rm $(SEL4_SUBMODULE)/libsel4/sel4_plat_include/imx8mm-evk
	cp -r $(SEL4_SUBMODULE)/libsel4/sel4_plat_include/imx8mq-evk \
		  $(SEL4_SUBMODULE)/libsel4/sel4_plat_include/imx8mm-evk

.PHONY: build-sel4cp
build-sel4cp: fix-sel4
	cd $(SEL4CP_SUBMODULE) && \
		  $(SEL4CP_PYTHON_VENV_PYTHON) build_sdk.py --sel4="$(SEL4_SUBMODULE)"







