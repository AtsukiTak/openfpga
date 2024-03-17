# e.x.: make test_pc
test_%: dist/%_tb
	vvp $^

dist/%_tb: %_tb.sv
	iverilog -g2012 -o $@ $^
