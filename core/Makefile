.PHONY: TEST_ALL TEST_NAND

TEST_ALL: TEST_NAND

TEST_NAND: nand_tb
	vvp $^

dist/nand_tb: nand_tb.sv nand.sv
	iverilog -g2012 -o $@ $^
