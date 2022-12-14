
PWD_DIR = "$(shell basename $$(pwd))"
RESOURCES_DIR = $(PWD)/resources
SEL4_SUBMODULE = $(PWD)/sel4
SEL4CP_SUBMODULE = $(PWD)/sel4cp
#SDDF_SUBMODULE = $(PWD)/sddf
SDDF_SUBMODULE = $(PWD)/sddf-playground
SERIAL_SUBMODULE = $(PWD)/sddf-serial

SEL4_COMMIT = 92f0f3ab28f00c97851512216c855f4180534a60

SERVER_USER_HOST = patrick@vm_comp4961_ubuntu1804
SERVER_REMOTE_DIR = ~/remote/$(shell hostname -s)/
TS_USER_HOST = patrickh@login.trustworthy.systems

SEL4CP_PYTHON_VENV_NAME = sel4cp_venv
SEL4CP_PYTHON_VENV_PATH = $(SEL4CP_SUBMODULE)/$(SEL4CP_PYTHON_VENV_NAME)
SEL4CP_PYTHON_VENV_PYTHON = $(SEL4CP_PYTHON_VENV_PATH)/bin/python
SEL4CP_PYTHON_REQUIREMENTS = $(SEL4CP_SUBMODULE)/requirements.txt
SEL4CP_BOARD = imx8mm

LUCY_LIBC = $(RESOURCES_DIR)/lucy-libc/libc.a

SDDF_SRC_DIR = $(SDDF_SUBMODULE)/echo_server
SERIAL_SRC_DIR = $(SERIAL_SUBMODULE)/serial

# =================================
# Generated Files
# =================================
# seL4CP
SEL4CP_RELEASE_DIR = $(SEL4CP_SUBMODULE)/release
SEL4CP_BUILD_DIR = $(SEL4CP_SUBMODULE)/build
SEL4CP_SDK_DIR = $(SEL4CP_RELEASE_DIR)/sel4cp-sdk-1.2.6
# sDDF
SDDF_BUILD_DIR = $(SDDF_SRC_DIR)/build
SDDF_LOADER_IMG = $(SDDF_BUILD_DIR)/loader.img
# Serial
SERIAL_BUILD_DIR = $(SERIAL_SRC_DIR)/build
SERIAL_LOADER_IMG = $(SERIAL_BUILD_DIR)/loader.img

# =================================
# Clean
# =================================

.PHONY: clean-remote
clean-remote: push-home
	ssh -t $(SERVER_USER_HOST) "\
		cd $(SERVER_REMOTE_DIR)$(PWD_DIR) ; \
		make clean ; "

.PHONY: clean
clean: \
	clean-sel4cp \
	clean-sddf \
	clean-serial

.PHONY: clean-sel4cp
clean-sel4cp:
	rm -rf $(SEL4CP_PYTHON_VENV_PATH)
	rm -rf $(SEL4CP_RELEASE_DIR)
	rm -rf $(SEL4CP_BUILD_DIR)
	rm -rf $(SEL4CP_SDK_DIR)

.PHONY: clean-sddf
clean-sddf:
	rm -rf $(SDDF_BUILD_DIR)
	rm -rf $(SDDF_LOADER_IMG)

.PHONY: clean-serial
clean-serial:
	rm -rf $(SERIAL_BUILD_DIR)
	rm -rf $(SERIAL_LOADER_IMG)

# =================================
# Push to remote servers
# =================================

push-home:
	# Make the directory on the remote server if it doesn't exist already.
	ssh -t $(SERVER_USER_HOST) "mkdir -p $(SERVER_REMOTE_DIR)$(PWD_DIR)"
	# Sync our current directory with the remote.
	rsync -a \
 			--delete \
 			--exclude "$(SEL4CP_PYTHON_VENV_NAME)" \
 			--exclude "build" \
 			--exclude "release" \
 			./ $(SERVER_USER_HOST):$(SERVER_REMOTE_DIR)$(PWD_DIR)

# ==================================
# Runs a Make command remotely.
# ==================================

.PHONY: remote
remote: push-home
	ssh -t $(SERVER_USER_HOST) "\
		cd $(SERVER_REMOTE_DIR)$(PWD_DIR) ; \
		zsh -ilc 'make $(MAKE_CMD)' ; "

# ==================================
# Initialisation
# ==================================

.PHONY: init
init: \
	init-sel4cp \
	init-sel4 \
	init-sddf \

# 1. Initialise locally.
# 2. Then initialise remotely.
# This is to ensure the local version of seL4 and seL4cp are consistent for rsync.
.PHONY: init-remote
init-remote: fix-sel4
	$(MAKE) remote MAKE_CMD="init"

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
	$(MAKE) fix-sel4

.PHONY: fix-sel4
fix-sel4:
	rm -rf $(SEL4_SUBMODULE)/libsel4/sel4_plat_include/imx8mm-evk
	cp -r $(SEL4_SUBMODULE)/libsel4/sel4_plat_include/imx8mq-evk \
		  $(SEL4_SUBMODULE)/libsel4/sel4_plat_include/imx8mm-evk

.PHONY: init-sddf
init-sddf:
	# Nothing needs to be done for now.

# ==================================
# Build
# ==================================

.PHONY: build-remote
build-remote:
	$(MAKE) remote MAKE_CMD="build"

.PHONY: build
build: \
	build-sel4cp \
	build-sddf \

# Core Platform

.PHONY: build-sel4cp
build-sel4cp:
	cd $(SEL4CP_SUBMODULE) && \
		  $(SEL4CP_PYTHON_VENV_PYTHON) build_sdk.py --sel4="$(SEL4_SUBMODULE)"

# This patch is necessary since the sDDF expects a libc via the -lc linker flag
# specified by Lucy.
.PHONY: patch-sel4cp-sdk
patch-sel4cp-sdk:
	cp $(LUCY_LIBC) \
		$(SEL4CP_SDK_DIR)/board/$(SEL4CP_BOARD)/benchmark/lib/libc.a
	cp $(LUCY_LIBC) \
		$(SEL4CP_SDK_DIR)/board/$(SEL4CP_BOARD)/debug/lib/libc.a
	cp $(LUCY_LIBC) \
		$(SEL4CP_SDK_DIR)/board/$(SEL4CP_BOARD)/release/lib/libc.a

# sDDF

.PHONY: build-sddf
build-sddf: \
	build-sel4cp \
	patch-sel4cp-sdk
	make \
		-C $(SDDF_SRC_DIR) \
		BUILD_DIR=$(SDDF_BUILD_DIR) \
		SEL4CP_SDK=$(SEL4CP_SDK_DIR) \
		SEL4CP_BOARD=$(SEL4CP_BOARD) \
		SEL4CP_CONFIG=debug

# Serial Driver

.PHONY: build-serial
build-serial: \
	build-sel4cp \
	patch-sel4cp-sdk
	make \
		-C $(SERIAL_SRC_DIR) \
		BUILD_DIR=$(SERIAL_BUILD_DIR) \
		SEL4CP_SDK=$(SEL4CP_SDK_DIR) \
		SEL4CP_BOARD=$(SEL4CP_BOARD) \
		SEL4CP_CONFIG=debug

# ==================================
# Run
# ==================================

.PHONY: run-img-on-mq
run-img-on-mq:
	# Copy the loader image to the TS server.
	scp $(PATH_TO_LOADER_IMG) $(TS_USER_HOST):~/Downloads/$(IMG_NAME)
	# Run the loader image on the TS server.
	ssh -t $(TS_USER_HOST) "\
		bash -ilc 'mq.sh run -c \"something\" -l output -s $(MQ_BOARD) -f ~/Downloads/$(IMG_NAME)' ; "

# sDDF

.PHONY: run-sddf-remote
run-sddf-remote:
	$(MAKE) remote MAKE_CMD="run-sddf"

.PHONY: run-sddf
run-sddf: build-sddf
	$(MAKE) run-img-on-mq \
		MQ_BOARD=$(SEL4CP_BOARD) \
		PATH_TO_LOADER_IMG=$(SDDF_LOADER_IMG) \
		IMG_NAME="sddf.img"

# Serial Driver

.PHONY: run-serial-remote
run-serial-remote:
	$(MAKE) remote MAKE_CMD="run-serial"

.PHONY: run-serial
run-serial: build-serial
	$(MAKE) run-img-on-mq \
		MQ_BOARD=$(SEL4CP_BOARD) \
		PATH_TO_LOADER_IMG=$(SERIAL_LOADER_IMG) \
		IMG_NAME="serial.img"

