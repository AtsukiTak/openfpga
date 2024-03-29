# e.x.: make test_pc
test_%: dist/%_tb
	vvp $^

dist/%: %.sv
	iverilog -g2012 -o $@ $^
