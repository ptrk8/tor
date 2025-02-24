#!/usr/bin/env kermit

# Serial port setup.  These settings will likely need to be
# changed to match the configuration of your workstation
# and the ARM board you're working with.
set line /dev/tty.usbserial-A50285BI
set speed 115200
set serial 8n1

# General C-Kermit settings.  These probably don't need to change.
set flow-control none
set file type bin
set carrier-watch off
set prefixing all
set modem none

echo "Prepared to boot new kernel.  Reset the board now."

# This is the string that my board outputs to allow the user to
# gain access to the U-Boot console.  Change this to suit your
# setup.
input 60 "Hit any key to stop autoboot"
# If your board wants you to press a different key to get to
# U-Boot, edit this line.
output " "
input 5 "U-Boot>"
# Here, 0x10000000 is the memory address into which the kernel
# should be loaded.
lineout "loadb 0x10000000"
# This should be the absolute path to your file.
send ../tmp/mmc-rpi3bp.img
input 5 "U-Boot>"
lineout "go 0x10000000"

# This command drops you into a console where you can interact
# with the kernel.
connect