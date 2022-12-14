
PWD_DIR = "$(shell basename $$(pwd))"
RESOURCES_DIR = $(PWD)/resources

SEL4_SUBMODULE = $(PWD)/sel4
SEL4CP_SUBMODULE = $(PWD)/sel4cp
SDDF_SUBMODULE = $(PWD)/sddf
PLAYGROUND_SUBMODULE = $(PWD)/sddf-playground
SERIAL_SUBMODULE = $(PWD)/sddf-serial
HELLO_SUBMODULE = $(PWD)/hello-world
WORKSHOP_SUBMODULE = $(PWD)/sel4cp-workshop

SEL4_COMMIT = 92f0f3ab28f00c97851512216c855f4180534a60

SERVER_USER_HOST = patrick@vm_comp4961_ubuntu1804
SERVER_REMOTE_DIR = ~/remote/$(shell hostname -s)/
TS_USER_HOST = patrickh@login.trustworthy.systems
TFTP_USER_HOST = patrickh@tftp.keg.cse.unsw.edu.au

SEL4CP_PYTHON_VENV_NAME = sel4cp_venv
SEL4CP_PYTHON_VENV_PATH = $(SEL4CP_SUBMODULE)/$(SEL4CP_PYTHON_VENV_NAME)
SEL4CP_PYTHON_VENV_PYTHON = $(SEL4CP_PYTHON_VENV_PATH)/bin/python
SEL4CP_PYTHON_REQUIREMENTS = $(SEL4CP_SUBMODULE)/requirements.txt
SEL4CP_BOARD = imx8mm

LUCY_LIBC = $(RESOURCES_DIR)/lucy-libc/libc.a

SDDF_SRC_DIR = $(SDDF_SUBMODULE)/echo_server
PLAYGROUND_SRC_DIR = $(PLAYGROUND_SUBMODULE)/echo_server
SERIAL_SRC_DIR = $(SERIAL_SUBMODULE)/serial
HELLO_SRC_DIR = $(HELLO_SUBMODULE)
WORKSHOP_SRC_DIR = $(WORKSHOP_SUBMODULE)/workshop

SERIAL_TEST_DIR = $(SERIAL_SUBMODULE)/serial_test
SERIAL_TEST_E2E_DIR = $(SERIAL_TEST_DIR)/e2e

# =================================
# Build artifacts
# =================================

# seL4CP
SEL4CP_RELEASE_DIR = $(SEL4CP_SUBMODULE)/release
SEL4CP_BUILD_DIR = $(SEL4CP_SUBMODULE)/build
SEL4CP_SDK_DIR = $(SEL4CP_RELEASE_DIR)/sel4cp-sdk-1.2.6

# sDDF
SDDF_BUILD_DIR = $(SDDF_SRC_DIR)/build
SDDF_LOADER_IMG = $(SDDF_BUILD_DIR)/loader.img

# Playground
PLAYGROUND_BUILD_DIR = $(PLAYGROUND_SRC_DIR)/build
PLAYGROUND_LOADER_IMG = $(PLAYGROUND_BUILD_DIR)/loader.img

# Serial Driver
SERIAL_BUILD_DIR = $(SERIAL_SRC_DIR)/build
SERIAL_LOADER_IMG = $(SERIAL_BUILD_DIR)/loader.img

# Hello World
HELLO_BUILD_DIR = $(HELLO_SRC_DIR)/build
HELLO_LOADER_IMG = $(HELLO_BUILD_DIR)/loader.img

# Workshop
WORKSHOP_BUILD_DIR = $(WORKSHOP_SRC_DIR)/build

# =================================
# Configure CLion
# =================================

# Configures environment for CLion.
.PHONY: setup-for-ide
setup-for-ide: \
	sync-sel4cp-build-artifacts

# Run this after you have built sel4cp.
# This copies the build artifacts from the remote machine to the local machine.
# The build artifacts will be used for CLion's Intellisense.
# The header files we are interested in are in: sel4cp/release/sel4cp-sdk-1.2.6/board/imx8mm/debug/include
.PHONY: sync-sel4cp-build-artifacts
sync-sel4cp-build-artifacts:
	rsync \
		-a \
		--delete \
		$(SERVER_USER_HOST):$(SERVER_REMOTE_DIR)$(PWD_DIR)/sel4cp/release/ $(SEL4CP_RELEASE_DIR)
	rsync \
		-a \
		--delete \
		$(SERVER_USER_HOST):$(SERVER_REMOTE_DIR)$(PWD_DIR)/sel4cp/build/ $(SEL4CP_BUILD_DIR)

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
	clean-serial \
	clean-hello \
	clean-workshop \

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

.PHONY: clean-hello
clean-hello:
	rm -rf $(HELLO_BUILD_DIR)
	rm -rf $(HELLO_LOADER_IMG)

.PHONY: clean-workshop
clean-workshop:
	rm -rf $(WORKSHOP_BUILD_DIR)

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

# 1. Patch sel4 locally.
# 2. Then initialise remotely.
# This is to ensure the local version of seL4 and seL4cp are consistent with remote version.
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

# Make sure you use this seL4 commit hash: https://github.com/BreakawayConsulting/sel4cp#sel4-version
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
# Only build the Core Platform if the SDK doesn't exist already.
ifeq ("$(wildcard $(SEL4CP_SDK_DIR))","")
	cd $(SEL4CP_SUBMODULE) && \
		$(SEL4CP_PYTHON_VENV_PYTHON) build_sdk.py --sel4="$(SEL4_SUBMODULE)"
else
	@echo "No need to build Core Platform since SDK already exists"
endif

# This patch is necessary since the sDDF expects a libc via the -lc linker flag
# specified by Lucy.
.PHONY: patch-sel4cp-sdk
patch-sel4cp-sdk:
	# The -n ensures we don't overwrite an existing file.
	cp -n $(LUCY_LIBC) \
		$(SEL4CP_SDK_DIR)/board/$(SEL4CP_BOARD)/benchmark/lib/libc.a
	cp -n $(LUCY_LIBC) \
		$(SEL4CP_SDK_DIR)/board/$(SEL4CP_BOARD)/debug/lib/libc.a
	cp -n $(LUCY_LIBC) \
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

# Playground

.PHONY: build-playground
build-playground: \
	build-sel4cp \
	patch-sel4cp-sdk
	make \
		-C $(PLAYGROUND_SRC_DIR) \
		BUILD_DIR=$(PLAYGROUND_BUILD_DIR) \
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

# Hello World

.PHONY: build-hello
build-hello: \
	build-sel4cp \
	patch-sel4cp-sdk
	make \
		-C $(HELLO_SRC_DIR) \
		BUILD_DIR=$(HELLO_BUILD_DIR) \
		SEL4CP_SDK=$(SEL4CP_SDK_DIR) \
		SEL4CP_BOARD=$(SEL4CP_BOARD) \
		SEL4CP_CONFIG=debug

# Workshop

.PHONY: build-workshop
build-workshop:
	$(MAKE) \
		-C $(WORKSHOP_SUBMODULE) \
		build-part3 \
		PWD=$(WORKSHOP_SUBMODULE)

# ==================================
# Console
# ==================================

# Ctrl + e, c, f: Hooks you up to the serial port to start sending chars.
# Ctrl + e, c, .: Exits the console serial.
.PHONY: console
console:
	ssh -t $(TS_USER_HOST) "\
		ssh -t $(TFTP_USER_HOST) \"\
			console -f $(BOARD)\" ; "

# ==================================
# Run
# ==================================

MQ_COMPLETION_TEXT ?= something-obscure

.PHONY: run-img-on-mq
run-img-on-mq:
	# Copy the loader image to the TS server.
	scp $(PATH_TO_LOADER_IMG) $(TS_USER_HOST):~/Downloads/$(IMG_NAME)
	# Run the loader image on the TS server.
	ssh -t $(TS_USER_HOST) "\
		bash -ilc 'mq.sh run -c \"$(MQ_COMPLETION_TEXT)\" -l output -s $(MQ_BOARD) -f ~/Downloads/$(IMG_NAME)' ; "

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

# Playground

.PHONY: run-playground-remote
run-playground-remote:
	$(MAKE) remote MAKE_CMD="run-playground"

.PHONY: run-playground
run-playground: build-playground
	$(MAKE) run-img-on-mq \
		MQ_BOARD=$(SEL4CP_BOARD) \
		PATH_TO_LOADER_IMG=$(PLAYGROUND_LOADER_IMG) \
		IMG_NAME="playground.img"

# Serial Driver

.PHONY: run-serial-remote
run-serial-remote:
	$(MAKE) remote MAKE_CMD="run-serial"

# To test sending characters to the serial device, make sure to run `make
# console-serial` in a separate Terminal as explained below.
.PHONY: run-serial
run-serial: build-serial
	$(MAKE) run-img-on-mq \
		MQ_BOARD=$(SEL4CP_BOARD) \
		PATH_TO_LOADER_IMG=$(SERIAL_LOADER_IMG) \
		IMG_NAME="sddf-serial.img"

# Enables you to send chars to the UART port of the device.
# Ctrl + e, c, f : Hooks you up to the serial port to start sending chars. If you
# wait after the image is running on the device before you run this Make
# command, you don't need to use this command.
# Ctrl + e, c, . : Exits the console serial.
.PHONY: console-serial
console-serial:
	$(MAKE) console BOARD=$(SEL4CP_BOARD)

# Hello World

.PHONY: run-hello-remote
run-hello-remote:
	$(MAKE) remote MAKE_CMD="run-hello"

.PHONY: run-hello
run-hello: build-hello
	$(MAKE) run-img-on-mq \
		MQ_BOARD=$(SEL4CP_BOARD) \
		PATH_TO_LOADER_IMG=$(HELLO_LOADER_IMG) \
		IMG_NAME="hello-world.img"

# Workshop

.PHONY: run-workshop
run-workshop:
	$(MAKE) \
		-C $(WORKSHOP_SUBMODULE) \
		run-part3 \
		PWD=$(WORKSHOP_SUBMODULE)

# ==================================
# Debug
# ==================================

# This is the `objdump` command for ELF binaries in the $(SERIAL_BUILD_DIR).
# This command won't work if you run it remotely via $ make remote
# MAKE_CMD="objdump-serial".
.PHONY: objdump-serial
objdump-serial:
	aarch64-linux-gnu-objdump \
		-Dlx $(SERIAL_BUILD_DIR)/$(PATH_TO_ELF) \
		| less

# This command can and should be run remotely via $ make remote
# MAKE_CMD="objdump-serial-serial_client".
.PHONY: objdump-serial-serial_client
objdump-serial-serial_client:
	$(MAKE) objdump-serial PATH_TO_ELF="serial_client.elf"

# This command can and should be run remotely via $ make remote
# MAKE_CMD="objdump-serial-serial_driver".
.PHONY: objdump-serial-serial_driver
objdump-serial-serial_driver:
	$(MAKE) objdump-serial PATH_TO_ELF="serial_driver.elf"

# ==================================
# Test
# ==================================

# Serial Driver

.PHONY: test-e2e-serial-remote
test-e2e-serial-remote:
	$(MAKE) remote MAKE_CMD="test-e2e-serial"

.PHONY: test-e2e-serial
test-e2e-serial: build-serial
	$(MAKE) run-img-on-mq \
		MQ_BOARD=$(SEL4CP_BOARD) \
		PATH_TO_LOADER_IMG=$(SERIAL_LOADER_IMG) \
		IMG_NAME="sddf-serial.img" \
		MQ_COMPLETION_TEXT="=== END ===" | \
		EXPECTED=$(SERIAL_TEST_E2E_DIR)/expected/expected_imx_uart.txt $(SERIAL_TEST_E2E_DIR)/scripts/assert_imx_uart.py

# ==================================
# Machine Queue
# ==================================

.PHONY: mq-getlock
mq-getlock:
	ssh -t $(TS_USER_HOST) "\
		bash -ilc 'mq.sh sem -f -signal $(BOARD)' ; "

.PHONY: mq-getlock-imx8mm
mq-getlock-imx8mm:
	$(MAKE) mq-getlock BOARD="imx8mm"




