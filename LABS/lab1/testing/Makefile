# I2C Emulating module testbench Makefile
#
# (c) 2012 Stanford University All Rights Reserved
#

TESTBENCH=i2c_emulator_tb
SOURCES=../lab1/i2c_emulator.v ${TESTBENCH}.v 

all: ${TESTBENCH}.lx2
	gtkwave ${TESTBENCH}.lx2 ${TESTBENCH}.sav >/dev/null 2>&1

${TESTBENCH}.lx2: ${TESTBENCH}.sim
	./${TESTBENCH}.sim -n -lx2

${TESTBENCH}.sim: ${SOURCES}
	iverilog -o ${TESTBENCH}.sim -s ${TESTBENCH} ${SOURCES}

.PHONY: all
