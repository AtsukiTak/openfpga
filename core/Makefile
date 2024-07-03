SV_SRC = $(wildcard *.sv)
SV_OBJ = $(patsubst %.sv, dist/%, $(SV_SRC))
TESTS = $(patsubst %_tb.sv, %, $(wildcard *_tb.sv))
TEST_CASES = $(patsubst %, test_%, $(TESTS))
TEST_OBJS = $(patsubst %, dist/%_tb, $(TESTS))

.PHONY: $(TEST_CASES) $(SV_OBJ)

${TEST_CASES}: test_%: dist/%_tb
	vvp $^

$(SV_OBJ): dist/%: %.sv
	iverilog -g2012 -o $@ $^
