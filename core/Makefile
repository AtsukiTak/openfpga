.PHONY: TEST_ALL TEST_NAND

TEST_ALL: TEST_pc

TEST_%: dist/%_tb
	vvp $^

dist/%_tb: %_tb.sv %.sv
	iverilog -g2012 -o $@ $^
