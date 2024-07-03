# Examples: src/top.sv src/pc.sv src/ram.sv
SV_SRC = $(wildcard src/*.sv)

# Examples: dist/top dist/pc dist/ram
SV_OBJ = $(patsubst src/%.sv, dist/%, $(SV_SRC))

# Examples: tests/top_tb.sv tests/pc_tb.sv tests/ram_tb.sv
TEST_SRC = $(wildcard tests/*_tb.sv)

# Examples: top pc ram
TESTS = $(patsubst tests/%_tb.sv, %, $(wildcard tests/*_tb.sv))

# Examples: test_top test_pc test_ram
TEST_CASES = $(patsubst %, test_%, $(TESTS))

# Examples: dist/top_tb dist/pc_tb dist/ram_tb
TEST_OBJS = $(patsubst %, dist/%_tb, $(TESTS))

.PHONY: test $(TEST_CASES) $(SV_OBJ)

test: $(TEST_CASES)

${TEST_CASES}: test_%: dist/%_tb
	vvp $^

$(SV_OBJ): dist/%: %.sv
	iverilog -g2012 -o $@ $^

$(TEST_OBJS): dist/%_tb: tests/%_tb.sv
	iverilog -g2012 -o $@ $^
