
PWD_DIR = "$(shell basename $$(pwd))"
RESOURCES_DIR = $(PWD)/resources

SEL4_SUBMODULE = $(PWD)/sel4
SEL4CP_SUBMODULE = $(PWD)/sel4cp
SEL4CP_PATRICK_SUBMODULE = $(PWD)/sel4cp-patrick
SDDF_SUBMODULE = $(PWD)/sddf
PLAYGROUND_SUBMODULE = $(PWD)/sddf-playground
SERIAL_SUBMODULE = $(PWD)/sddf-serial
SERIAL_RPI3B_SUBMODULE = $(PWD)/sddf-serial-rpi3b
MMC_SUBMODULE = $(PWD)/sddf-mmc
HELLO_SUBMODULE = $(PWD)/hello-world
WORKSHOP_SUBMODULE = $(PWD)/sel4cp-workshop
XAVIER_PORT_IVAN_SUBMODULE = $(PWD)/xavier-port-ivan
UBOOT_RPI4B_SUBMODULE = $(PWD)/uboot-rpi4b
UBOOT_RPI3B_SUBMODULE = $(PWD)/uboot-rpi3b

SEL4_COMMIT = 92f0f3ab28f00c97851512216c855f4180534a60

SERVER_USER_HOST = patrick@vm_comp4961_ubuntu1804
SERVER_REMOTE_DIR = ~/remote/$(shell hostname -s)/
TS_USER_HOST = patrickh@login.trustworthy.systems
TFTP_UNSW_USER_HOST = patrickh@tftp.keg.cse.unsw.edu.au
TFTP_HOME_USER_HOST = patrick@192.168.0.198

# =================================
# Python Virtual Environments.
# =================================

SEL4CP_PYTHON_VENV_NAME = sel4cp_venv
SEL4CP_PYTHON_VENV_PATH = $(SEL4CP_SUBMODULE)/$(SEL4CP_PYTHON_VENV_NAME)
SEL4CP_PYTHON_VENV_PYTHON = $(SEL4CP_PYTHON_VENV_PATH)/bin/python
SEL4CP_PYTHON_REQUIREMENTS = $(SEL4CP_SUBMODULE)/requirements.txt
SEL4CP_BOARD = imx8mm

SEL4CP_PATRICK_PYTHON_VENV_NAME = sel4cp_patrick_venv
SEL4CP_PATRICK_PYTHON_VENV_PATH = $(SEL4CP_PATRICK_SUBMODULE)/$(SEL4CP_PATRICK_PYTHON_VENV_NAME)
SEL4CP_PATRICK_PYTHON_VENV_PYTHON = $(SEL4CP_PATRICK_PYTHON_VENV_PATH)/bin/python
SEL4CP_PATRICK_PYTHON_REQUIREMENTS = $(SEL4CP_PATRICK_SUBMODULE)/requirements.txt

LUCY_LIBC = $(RESOURCES_DIR)/lucy-libc/libc.a

SDDF_SRC_DIR = $(SDDF_SUBMODULE)/echo_server
PLAYGROUND_SRC_DIR = $(PLAYGROUND_SUBMODULE)/echo_server
SERIAL_SRC_DIR = $(SERIAL_SUBMODULE)/serial
SERIAL_RPI3B_SRC_DIR = $(SERIAL_RPI3B_SUBMODULE)/serial
MMC_SRC_DIR = $(MMC_SUBMODULE)/mmc
HELLO_SRC_DIR = $(HELLO_SUBMODULE)
WORKSHOP_SRC_DIR = $(WORKSHOP_SUBMODULE)/workshop

SERIAL_TEST_DIR = $(SERIAL_SUBMODULE)/serial_test
SERIAL_TEST_E2E_DIR = $(SERIAL_TEST_DIR)/e2e

MMC_TEST_DIR = $(MMC_SUBMODULE)/mmc_test
MMC_TEST_E2E_DIR = $(MMC_TEST_DIR)/e2e

# SoCs / SoMs.
IMX8MM_BOARD = imx8mm
XAVIER_BOARD = xavier_1
RPI3B_BOARD = rpi3b
RPI4B_BOARD = rpi4b
ODROIDC2_BOARD = odroidc2
ZCU102_BOARD = zcu102

# =================================
# Build artifacts
# =================================

# seL4CP
SEL4CP_RELEASE_DIR = $(SEL4CP_SUBMODULE)/release
SEL4CP_BUILD_DIR = $(SEL4CP_SUBMODULE)/build
SEL4CP_SDK_DIR = $(SEL4CP_RELEASE_DIR)/sel4cp-sdk-1.2.6

# sel4cp-patrick
SEL4CP_PATRICK_RELEASE_DIR = $(SEL4CP_PATRICK_SUBMODULE)/release
SEL4CP_PATRICK_BUILD_DIR = $(SEL4CP_PATRICK_SUBMODULE)/build
SEL4CP_PATRICK_SDK_DIR = $(SEL4CP_PATRICK_RELEASE_DIR)/sel4cp-sdk-1.2.6

# sDDF
SDDF_BUILD_DIR = $(SDDF_SRC_DIR)/build
SDDF_LOADER_IMG = $(SDDF_BUILD_DIR)/loader.img

# Playground
PLAYGROUND_BUILD_DIR = $(PLAYGROUND_SRC_DIR)/build
PLAYGROUND_LOADER_IMG = $(PLAYGROUND_BUILD_DIR)/loader.img

# Serial Driver
SERIAL_BUILD_DIR = $(SERIAL_SRC_DIR)/build
SERIAL_LOADER_IMG = $(SERIAL_BUILD_DIR)/loader.img

SERIAL_RPI3B_BUILD_DIR = $(SERIAL_RPI3B_SRC_DIR)/build
SERIAL_RPI3B_LOADER_IMG = $(SERIAL_RPI3B_BUILD_DIR)/loader.img

# MMC Driver
MMC_BUILD_DIR = $(MMC_SRC_DIR)/build
MMC_LOADER_IMG = $(MMC_BUILD_DIR)/loader.img

# Hello World
HELLO_BUILD_DIR_IMX8MM = $(HELLO_SRC_DIR)/build-imx8mm
HELLO_LOADER_IMG_IMX8MM = $(HELLO_BUILD_DIR_IMX8MM)/loader.img

HELLO_BUILD_DIR_RPI3B = $(HELLO_SRC_DIR)/build-rpi3b
HELLO_LOADER_IMG_RPI3B = $(HELLO_BUILD_DIR_RPI3B)/loader.img

HELLO_BUILD_DIR_ODROIDC2 = $(HELLO_SRC_DIR)/build-odroidc2
HELLO_LOADER_IMG_ODROIDC2 = $(HELLO_BUILD_DIR_ODROIDC2)/loader.img

HELLO_BUILD_DIR_ZCU102 = $(HELLO_SRC_DIR)/build-zcu102
HELLO_LOADER_IMG_ZCU102 = $(HELLO_BUILD_DIR_ZCU102)/loader.img

HELLO_BUILD_DIR_RPI4B = $(HELLO_SRC_DIR)/build-rpi4b
HELLO_LOADER_IMG_RPI4B = $(HELLO_BUILD_DIR_RPI4B)/loader.img

# Workshop
WORKSHOP_BUILD_DIR = $(WORKSHOP_SRC_DIR)/build

# Ivan's Xavier Port
XAVIER_PORT_IVAN_BUILD_DIR = $(XAVIER_PORT_IVAN_SUBMODULE)/build
XAVIER_PORT_IVAN_SEL4TEST_IMG = $(XAVIER_PORT_IVAN_BUILD_DIR)/images/sel4test-driver-image-arm-xavier

# =================================
# Configure CLion
# =================================

# Configures environment for CLion.
# Run this AFTER you have built sel4cp.
.PHONY: setup-for-ide
setup-for-ide: \
	sync-sel4cp-build-artifacts \
	sync-sel4cp-patrick-build-artifacts \

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

.PHONY: sync-sel4cp-patrick-build-artifacts
sync-sel4cp-patrick-build-artifacts:
	rsync \
		-a \
		--delete \
		$(SERVER_USER_HOST):$(SERVER_REMOTE_DIR)$(PWD_DIR)/sel4cp-patrick/release/ \
		$(SEL4CP_PATRICK_RELEASE_DIR)
	rsync \
		-a \
		--delete \
		$(SERVER_USER_HOST):$(SERVER_REMOTE_DIR)$(PWD_DIR)/sel4cp-patrick/build/ \
		$(SEL4CP_PATRICK_BUILD_DIR)

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
	clean-sel4cp-patrick \
	clean-sddf \
	clean-serial \
	clean-hello-imx8mm \
	clean-hello-rpi3b \
	clean-hello-odroidc2 \
	clean-hello-zcu102 \
	clean-workshop \

.PHONY: clean-sel4cp
clean-sel4cp:
	rm -rf $(SEL4CP_PYTHON_VENV_PATH)
	rm -rf $(SEL4CP_RELEASE_DIR)
	rm -rf $(SEL4CP_BUILD_DIR)
	rm -rf $(SEL4CP_SDK_DIR)

.PHONY: clean-sel4cp-patrick
clean-sel4cp-patrick:
	rm -rf $(SEL4CP_PATRICK_PYTHON_VENV_PATH)
	rm -rf $(SEL4CP_PATRICK_RELEASE_DIR)
	rm -rf $(SEL4CP_PATRICK_BUILD_DIR)
	rm -rf $(SEL4CP_PATRICK_SDK_DIR)

.PHONY: clean-sddf
clean-sddf:
	rm -rf $(SDDF_BUILD_DIR)
	rm -rf $(SDDF_LOADER_IMG)

.PHONY: clean-serial
clean-serial:
	rm -rf $(SERIAL_BUILD_DIR)
	rm -rf $(SERIAL_LOADER_IMG)

.PHONY: clean-mmc
clean-mmc:
	rm -rf $(MMC_BUILD_DIR)
	rm -rf $(MMC_LOADER_IMG)

.PHONY: clean-hello-imx8mm
clean-hello-imx8mm:
	rm -rf $(HELLO_BUILD_DIR_IMX8MM)
	rm -rf $(HELLO_LOADER_IMG_IMX8MM)

.PHONY: clean-hello-rpi3b
clean-hello-rpi3b:
	rm -rf $(HELLO_BUILD_DIR_RPI3B)
	rm -rf $(HELLO_LOADER_IMG_RPI3B)

.PHONY: clean-hello-odroidc2
clean-hello-odroidc2:
	rm -rf $(HELLO_BUILD_DIR_ODROIDC2)
	rm -rf $(HELLO_LOADER_IMG_ODROIDC2)

.PHONY: clean-hello-zcu102
clean-hello-zcu102:
	rm -rf $(HELLO_BUILD_DIR_ZCU102)
	rm -rf $(HELLO_LOADER_IMG_ZCU102)

.PHONY: clean-workshop
clean-workshop:
	rm -rf $(WORKSHOP_BUILD_DIR)

.PHONY: clean-xavier-port-ivan
clean-xavier-port-ivan:
	# Call the `clean` Make command in the `xavier-port-ivan` submodule.
	$(MAKE) -C $(XAVIER_PORT_IVAN_SUBMODULE) clean

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
 			--exclude "$(SEL4CP_PATRICK_PYTHON_VENV_NAME)" \
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
	init-sel4cp-patrick \
	init-sel4 \
	init-sddf \

# 1. Patch sel4 locally.
# 2. Then initialise remotely.
# This is to ensure the local version of seL4 and seL4cp are consistent with remote version.
.PHONY: init-remote
init-remote: fix-sel4
	$(MAKE) remote MAKE_CMD="init"

# The following should be run using:
# $ make remote MAKE_CMD="init-sel4cp"
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

# The following should be run using:
# $ make remote MAKE_CMD="init-sel4cp-patrick"
.PHONY: init-sel4cp-patrick
init-sel4cp-patrick:
	# Checkout "rpi4b_rpi3b_odroidc2_support" branch.
	cd $(SEL4CP_PATRICK_SUBMODULE) && \
		  git checkout rpi4b_rpi3b_odroidc2_support
	# Create Python Virtual Environment
	python3.9 -m venv $(SEL4CP_PATRICK_PYTHON_VENV_PATH)
	# Upgrade pip, setuptools and wheel.
	$(SEL4CP_PATRICK_PYTHON_VENV_PYTHON) -m pip install --upgrade pip setuptools wheel
	# Install Python requirements into Virtual Environment.
	$(SEL4CP_PATRICK_PYTHON_VENV_PYTHON) -m pip install -r $(SEL4CP_PATRICK_PYTHON_REQUIREMENTS)
	# Install missing Python requirements into Virtual Environment.
	$(SEL4CP_PATRICK_PYTHON_VENV_PYTHON) -m pip install six future

# The seL4 commit hash we checked out is from here: https://github.com/BreakawayConsulting/sel4cp#sel4-version
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

.PHONY: init-xavier-port-ivan
init-xavier-port-ivan:
	# Call the `init` Make command in the `xavier-port-ivan` submodule.
	$(MAKE) -C $(XAVIER_PORT_IVAN_SUBMODULE) init

# This command should be run locally.
.PHONY: init-uboot-rpi4b
init-uboot-rpi4b:
# Only build the Core Platform if the SDK doesn't exist already.
ifeq ("$(wildcard $(UBOOT_RPI4B_SUBMODULE))","")
	git submodule add -b patrick -- git@github.com:patrick-forks/uboot-patrick.git uboot-rpi4b
else
	@echo "No need to initialise RPI4B U-Boot submodule since it already exists."
endif

# This command should be run locally.
.PHONY: init-uboot-rpi3b
init-uboot-rpi3b:
# Only build the Core Platform if the SDK doesn't exist already.
ifeq ("$(wildcard $(UBOOT_RPI3B_SUBMODULE))","")
	git submodule add -b patrick -- git@github.com:patrick-forks/uboot-patrick.git uboot-rpi3b
else
	@echo "No need to initialise RPI3B U-Boot submodule since it already exists."
endif

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

.PHONY: build-sel4cp-patrick
build-sel4cp-patrick:
# Only build the Core Platform if the SDK doesn't exist already.
ifeq ("$(wildcard $(SEL4CP_PATRICK_SDK_DIR))","")
	cd $(SEL4CP_PATRICK_SUBMODULE) && \
		$(SEL4CP_PATRICK_PYTHON_VENV_PYTHON) build_sdk.py --sel4="$(SEL4_SUBMODULE)"
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

.PHONY: patch-sel4cp-patrick-sdk
patch-sel4cp-patrick-sdk:
	# The -n ensures we don't overwrite an existing file.
	cp -n $(LUCY_LIBC) \
		$(SEL4CP_PATRICK_SDK_DIR)/board/$(SEL4CP_BOARD)/debug/lib/libc.a
	cp -n $(LUCY_LIBC) \
		$(SEL4CP_PATRICK_SDK_DIR)/board/$(SEL4CP_BOARD)/release/lib/libc.a

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

.PHONY: build-serial-rpi3b
build-serial-rpi3b: \
	build-sel4cp-patrick
	$(MAKE) patch-sel4cp-patrick-sdk \
		SEL4CP_BOARD=$(RPI3B_BOARD)
	$(MAKE) \
		-C $(SERIAL_RPI3B_SRC_DIR) \
		BUILD_DIR=$(SERIAL_RPI3B_BUILD_DIR) \
		SEL4CP_SDK=$(SEL4CP_PATRICK_SDK_DIR) \
		SEL4CP_BOARD=$(RPI3B_BOARD) \
		SEL4CP_CONFIG=debug

# MMC Driver

.PHONY: build-mmc
build-mmc: \
	build-sel4cp \
	patch-sel4cp-sdk
	make \
		-C $(MMC_SRC_DIR) \
		BUILD_DIR=$(MMC_BUILD_DIR) \
		SEL4CP_SDK=$(SEL4CP_SDK_DIR) \
		SEL4CP_BOARD=$(SEL4CP_BOARD) \
		SEL4CP_CONFIG=debug

# Hello World

.PHONY: build-hello-imx8mm
build-hello-imx8mm: \
	build-sel4cp \
	patch-sel4cp-sdk
	make \
		-C $(HELLO_SRC_DIR) \
		BUILD_DIR=$(HELLO_BUILD_DIR_IMX8MM) \
		SEL4CP_SDK=$(SEL4CP_SDK_DIR) \
		SEL4CP_BOARD=$(IMX8MM_BOARD) \
		SEL4CP_CONFIG=debug

.PHONY: build-hello-rpi3b
build-hello-rpi3b: \
	build-sel4cp-patrick
	$(MAKE) patch-sel4cp-patrick-sdk \
		SEL4CP_BOARD=$(RPI3B_BOARD)
	$(MAKE) \
		-C $(HELLO_SRC_DIR) \
		BUILD_DIR=$(HELLO_BUILD_DIR_RPI3B) \
		SEL4CP_SDK=$(SEL4CP_PATRICK_SDK_DIR) \
		SEL4CP_BOARD=$(RPI3B_BOARD) \
		SEL4CP_CONFIG=debug

.PHONY: build-hello-odroidc2
build-hello-odroidc2: \
	build-sel4cp-patrick
	$(MAKE) patch-sel4cp-patrick-sdk \
		SEL4CP_BOARD=$(ODROIDC2_BOARD)
	$(MAKE) \
		-C $(HELLO_SRC_DIR) \
		BUILD_DIR=$(HELLO_BUILD_DIR_ODROIDC2) \
		SEL4CP_SDK=$(SEL4CP_PATRICK_SDK_DIR) \
		SEL4CP_BOARD=$(ODROIDC2_BOARD) \
		SEL4CP_CONFIG=debug

.PHONY: build-hello-zcu102
build-hello-zcu102: \
	build-sel4cp-patrick
	$(MAKE) patch-sel4cp-patrick-sdk \
		SEL4CP_BOARD=$(ZCU102_BOARD)
	$(MAKE) \
		-C $(HELLO_SRC_DIR) \
		BUILD_DIR=$(HELLO_BUILD_DIR_ZCU102) \
		SEL4CP_SDK=$(SEL4CP_PATRICK_SDK_DIR) \
		SEL4CP_BOARD=$(ZCU102_BOARD) \
		SEL4CP_CONFIG=debug

.PHONY: build-hello-rpi4b
build-hello-rpi4b: \
	build-sel4cp-patrick
	$(MAKE) patch-sel4cp-patrick-sdk \
		SEL4CP_BOARD=$(RPI4B_BOARD)
	$(MAKE) \
		-C $(HELLO_SRC_DIR) \
		BUILD_DIR=$(HELLO_BUILD_DIR_RPI4B) \
		SEL4CP_SDK=$(SEL4CP_PATRICK_SDK_DIR) \
		SEL4CP_BOARD=$(RPI4B_BOARD) \
		SEL4CP_CONFIG=debug

# Workshop

.PHONY: build-workshop
build-workshop:
	$(MAKE) \
		-C $(WORKSHOP_SUBMODULE) \
		build-part3 \
		PWD=$(WORKSHOP_SUBMODULE)

# Ivan's port.

.PHONY: build-xavier-port-ivan
build-xavier-port-ivan:
	$(MAKE) \
		-C $(XAVIER_PORT_IVAN_SUBMODULE) \
		build

# uboot-rpi4b.

# This command should only be run remotely since it will not working locally.
# E.g. $ make remote MAKE_CMD="build-uboot-rpi4b"
.PHONY: build-uboot-rpi4b
build-uboot-rpi4b:
	$(MAKE) \
		-C $(UBOOT_RPI4B_SUBMODULE) \
		CROSS_COMPILE=aarch64-linux-gnu- \
		rpi_4_defconfig
	$(MAKE) \
		-C $(UBOOT_RPI4B_SUBMODULE) \
		CROSS_COMPILE=aarch64-linux-gnu-

# This command should only be run remotely since it will not working locally.
# E.g. $ make remote MAKE_CMD="build-uboot-rpi3b"
.PHONY: build-uboot-rpi3b
build-uboot-rpi3b:
	$(MAKE) \
		-C $(UBOOT_RPI3B_SUBMODULE) \
		CROSS_COMPILE=aarch64-linux-gnu- \
		rpi_3_defconfig
	$(MAKE) \
		-C $(UBOOT_RPI3B_SUBMODULE) \
		CROSS_COMPILE=aarch64-linux-gnu-

# ==================================
# Console
# ==================================

# Ctrl + e, c, f: Hooks you up to the serial port to start sending chars. If you
# wait after the image is running on the device before you run this Make
# command, you don't need to use this command.
# Ctrl + e, c, .: Exits the console serial.
.PHONY: console
console:
	ssh -t $(TS_USER_HOST) "\
		ssh -t $(TFTP_UNSW_USER_HOST) \"\
			console -f $(BOARD)\" ; "

.PHONY: console-imx8mm
console-imx8mm:
	$(MAKE) console BOARD=$(IMX8MM_BOARD)

.PHONY: console-xavier
console-xavier:
	$(MAKE) console BOARD=$(XAVIER_BOARD)

.PHONY: console-rpi3b
console-rpi3b:
	$(MAKE) console BOARD="rpi3"

.PHONY: console-rpi4b
console-rpi4b:
	$(MAKE) console BOARD=$(RPI4B_BOARD)

.PHONY: console-odroidc2
console-odroidc2:
	$(MAKE) console BOARD="odroid-c2"

.PHONY: console-zcu102
console-zcu102:
	$(MAKE) console BOARD=$(ZCU102_BOARD)

# ==================================
# Run
# ==================================

MQ_COMPLETION_TEXT ?= something-obscure

# Copies a file to a remote server.
.PHONY: scp-file-to-server
scp-file-to-server:
	scp $(SRC_PATH) $(DST_USER_HOST):$(DST_PATH)

.PHONY: run-img-on-mq
run-img-on-mq:
	# Copy the loader image to the TS server.
	#scp $(PATH_TO_LOADER_IMG) $(TS_USER_HOST):~/Downloads/$(IMG_NAME)
	$(MAKE) scp-file-to-server \
		DST_USER_HOST=$(TS_USER_HOST) \
		SRC_PATH=$(PATH_TO_LOADER_IMG) \
		DST_PATH=~/Downloads/$(IMG_NAME)
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

# This can only be run remotely.
# E.g. $ make -C ~/code/courses/unsw/tor/tor remote MAKE_CMD="run-serial-rpi3bp-home"
# Make sure to restart the Raspberry Pi after running this Make command.
.PHONY: run-serial-rpi3bp-home
run-serial-rpi3bp-home: build-serial-rpi3b
	# Copy the loader image to my home TFTP server.
	$(MAKE) scp-file-to-server \
		DST_USER_HOST=$(TFTP_HOME_USER_HOST) \
		SRC_PATH=$(SERIAL_RPI3B_LOADER_IMG) \
		DST_PATH=~/Downloads/serial-rpi3bp.img
	# Symlink /tftpboot/rpi3bp/serial-rpi3bp.img file to to the file we just scp-ed to the server's ~/Downloads dir.
	ssh -t $(TFTP_HOME_USER_HOST) "\
		bash -ilc 'ln -sf /home/patrick/Downloads/serial-rpi3bp.img /tftpboot/rpi3bp/image.bin' ; "

# This can only be run remotely.
# E.g. $ make -C ~/code/courses/unsw/tor/tor remote MAKE_CMD="run-serial-rpi3b-mq"
# Make sure to restart the Raspberry Pi after running this Make command.
.PHONY: run-serial-rpi3b-mq
run-serial-rpi3b-mq: build-serial-rpi3b
	$(MAKE) run-img-on-mq \
		MQ_BOARD="rpi3" \
		PATH_TO_LOADER_IMG=$(SERIAL_RPI3B_LOADER_IMG) \
		IMG_NAME="sddf-rpi3b.img"
	ssh -t $(TFTP_HOME_USER_HOST) "\
		bash -ilc 'ln -sf /home/patrick/Downloads/serial-rpi3b.img /tftpboot/rpi3bp/image.bin' ; "

# Enables you to send chars to the UART port of the device.
# Ctrl + e, c, f : Hooks you up to the serial port to start sending chars. If you
# wait after the image is running on the device before you run this Make
# command, you don't need to use this command.
# Ctrl + e, c, . : Exits the console serial.
.PHONY: console-serial
console-serial:
	$(MAKE) console BOARD=$(SEL4CP_BOARD)

# Hello World

.PHONY: run-hello-imx8mm
run-hello-imx8mm: build-hello-imx8mm
	$(MAKE) run-img-on-mq \
		MQ_BOARD=$(IMX8MM_BOARD) \
		PATH_TO_LOADER_IMG=$(HELLO_LOADER_IMG_IMX8MM) \
		IMG_NAME="hello-world-imx8mm.img" \
		MQ_COMPLETION_TEXT="hello, world"

.PHONY: run-hello-rpi3b
run-hello-rpi3b: build-hello-rpi3b
	$(MAKE) run-img-on-mq \
		MQ_BOARD="rpi3" \
		PATH_TO_LOADER_IMG=$(HELLO_LOADER_IMG_RPI3B) \
		IMG_NAME="hello-world-rpi3b.img" \
		MQ_COMPLETION_TEXT="hello, world"

.PHONY: run-hello-rpi3bp-home
run-hello-rpi3bp-home: build-hello-rpi3b
	# Copy the sel4test image to the TS server.
	$(MAKE) scp-file-to-server \
		DST_USER_HOST=$(TFTP_HOME_USER_HOST) \
		SRC_PATH=$(HELLO_LOADER_IMG_RPI3B) \
		DST_PATH=~/Downloads/loader-rpi3bp.img
	# Symlink /tftpboot/rpi3bp/loader-rpi3bp.img file to to the file we just scp-ed to the server's ~/Downloads dir.
	ssh -t $(TFTP_HOME_USER_HOST) "\
		bash -ilc 'ln -sf /home/patrick/Downloads/loader-rpi3bp.img /tftpboot/rpi3bp/image.bin' ; "

.PHONY: run-hello-odroidc2
run-hello-odroidc2: build-hello-odroidc2
	$(MAKE) run-img-on-mq \
		MQ_BOARD=$(ODROIDC2_BOARD) \
		PATH_TO_LOADER_IMG=$(HELLO_LOADER_IMG_ODROIDC2) \
		IMG_NAME="hello-world-odroidc2.img" \
		MQ_COMPLETION_TEXT="hello, world"

.PHONY: run-hello-zcu102
run-hello-zcu102: build-hello-zcu102
	$(MAKE) run-img-on-mq \
		MQ_BOARD=$(ZCU102_BOARD) \
		PATH_TO_LOADER_IMG=$(HELLO_LOADER_IMG_ZCU102) \
		IMG_NAME="hello-world-zcu102.img" \
		MQ_COMPLETION_TEXT="hello, world"

# MMC Driver

.PHONY: run-mmc-remote
run-mmc-remote:
	$(MAKE) remote MAKE_CMD="run-mmc"

# To test sending characters to the mmc device, make sure to run `make
# console-imx8mm` in a separate Terminal.
.PHONY: run-mmc
run-mmc: build-mmc
	$(MAKE) run-img-on-mq \
		MQ_BOARD=$(SEL4CP_BOARD) \
		PATH_TO_LOADER_IMG=$(MMC_LOADER_IMG) \
		IMG_NAME="sddf-mmc.img"

# Workshop

.PHONY: run-workshop
run-workshop:
	$(MAKE) \
		-C $(WORKSHOP_SUBMODULE) \
		run-part3 \
		PWD=$(WORKSHOP_SUBMODULE)

# Ivan's port.
.PHONY: run-xavier-port-ivan
run-xavier-port-ivan: build-xavier-port-ivan
	$(MAKE) run-img-on-mq \
		MQ_BOARD=$(XAVIER_BOARD) \
		PATH_TO_LOADER_IMG=$(XAVIER_PORT_IVAN_SEL4TEST_IMG) \
		IMG_NAME="sel4test-driver-image-arm-xavier.img"
#	# Copy the sel4test image to the TS server.
#	$(MAKE) scp-file-to-ts \
#		SRC_PATH=$(XAVIER_PORT_IVAN_SEL4TEST_IMG) \
#		DST_PATH=~/Downloads/sel4test-driver-image-arm-xavier
#	# Symlink /tftpboot file to the sel4test image on the TS server.
#	ssh -t $(TS_USER_HOST) "\
#		bash -ilc 'ssh -t patrickh@tftp \"ln -sf /home/patrickh/Downloads/sel4test-driver-image-arm-xavier /tftpboot/xavier1/grubnetaa64.efi\"' ; "

# Run Ivan's port at Home.
# Requirements:
# - Must be on the Home network with Ethernet cable plugged into device.
# - Must be attached to the device via the Serial-USB cable.
.PHONY: run-xavier-port-ivan-home
run-xavier-port-ivan-home: build-xavier-port-ivan
	# Copy the sel4test image to the TS server.
	$(MAKE) scp-file-to-server \
		DST_USER_HOST=$(TFTP_HOME_USER_HOST) \
		SRC_PATH=$(XAVIER_PORT_IVAN_SEL4TEST_IMG) \
		DST_PATH=~/Downloads/sel4test-driver-image-arm-xavier
	# Symlink /tftpboot/xavier/image.efi file to to the file we just scp-ed to the server's ~/Downloads.
	ssh -t $(TFTP_HOME_USER_HOST) "\
		bash -ilc 'ln -sf /home/patrick/Downloads/sel4test-driver-image-arm-xavier /tftpboot/xavier/image.efi' ; "

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
	$(MAKE) mq-getlock \
		BOARD=$(IMX8MM_BOARD)

.PHONY: mq-getlock-xavier
mq-getlock-xavier:
	$(MAKE) mq-getlock \
		BOARD=$(XAVIER_BOARD)

.PHONY: mq-systems
mq-systems:
	ssh -t $(TS_USER_HOST) "\
		bash -ilc 'mq.sh systems' ; "

# ==================================
# Connect to Nvidia Jetson Xavier Serial Port
# ==================================

# Use Ctrl + A, K to exit `screen`.
.PHONY: connect-device
connect-device:
	screen $(DEVICE) 115200

# Connects to the Uni Jetson Xavier device's UART interface.
connect-xavier-uart-uni:
	$(MAKE) connect-device DEVICE="/dev/tty.usbserial-AB0LZKAE"

# Connects to the Home Jetson Xavier device's UART interface.
connect-xavier-uart-home:
	$(MAKE) connect-device DEVICE="/dev/tty.usbserial-A50285BI"

# Connects to the Home Jetson Xavier device's USB Type-C serial interface.
connect-xavier-typec-home:
	$(MAKE) connect-device DEVICE="/dev/tty.usbmodem14221220642083"


