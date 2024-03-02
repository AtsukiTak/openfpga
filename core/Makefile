.PHONY: TEST_ALL TEST_NAND

TEST_ALL: TEST_PC TEST_NAND

TEST_PC: dist/pc_tb
	vvp $^

TEST_NAND: dist/nand_tb
	vvp $^

dist/pc_tb: pc_tb.sv pc.sv
	iverilog -g2012 -o $@ $^

dist/nand_tb: nand_tb.sv nand.sv
	iverilog -g2012 -o $@ $^
