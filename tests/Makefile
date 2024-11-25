SRC = $(wildcard ../src/riscv/*.sv)

.PHONY: test_riscv_all

test_riscv_all: dist/top_tb
	vvp $^ +memfile=riscv-tests/generated/rv32ui-p-add.hex
	vvp $^ +memfile=riscv-tests/generated/rv32ui-p-addi.hex
	vvp $^ +memfile=riscv-tests/generated/rv32ui-p-and.hex
	vvp $^ +memfile=riscv-tests/generated/rv32ui-p-andi.hex
	vvp $^ +memfile=riscv-tests/generated/rv32ui-p-auipc.hex
	vvp $^ +memfile=riscv-tests/generated/rv32ui-p-beq.hex
	vvp $^ +memfile=riscv-tests/generated/rv32ui-p-bge.hex
	vvp $^ +memfile=riscv-tests/generated/rv32ui-p-bgeu.hex
	vvp $^ +memfile=riscv-tests/generated/rv32ui-p-blt.hex
	vvp $^ +memfile=riscv-tests/generated/rv32ui-p-bltu.hex
	vvp $^ +memfile=riscv-tests/generated/rv32ui-p-bne.hex
	vvp $^ +memfile=riscv-tests/generated/rv32ui-p-fence_i.hex
	vvp $^ +memfile=riscv-tests/generated/rv32ui-p-jal.hex
	vvp $^ +memfile=riscv-tests/generated/rv32ui-p-jalr.hex
	vvp $^ +memfile=riscv-tests/generated/rv32ui-p-lb.hex
	vvp $^ +memfile=riscv-tests/generated/rv32ui-p-lbu.hex
	vvp $^ +memfile=riscv-tests/generated/rv32ui-p-lh.hex
	vvp $^ +memfile=riscv-tests/generated/rv32ui-p-lhu.hex
	vvp $^ +memfile=riscv-tests/generated/rv32ui-p-lui.hex
	vvp $^ +memfile=riscv-tests/generated/rv32ui-p-lw.hex
	vvp $^ +memfile=riscv-tests/generated/rv32ui-p-ma_data.hex
	vvp $^ +memfile=riscv-tests/generated/rv32ui-p-or.hex
	vvp $^ +memfile=riscv-tests/generated/rv32ui-p-ori.hex
	vvp $^ +memfile=riscv-tests/generated/rv32ui-p-sb.hex
	vvp $^ +memfile=riscv-tests/generated/rv32ui-p-sh.hex
	vvp $^ +memfile=riscv-tests/generated/rv32ui-p-simple.hex
	vvp $^ +memfile=riscv-tests/generated/rv32ui-p-sll.hex
	vvp $^ +memfile=riscv-tests/generated/rv32ui-p-slli.hex
	vvp $^ +memfile=riscv-tests/generated/rv32ui-p-slt.hex
	vvp $^ +memfile=riscv-tests/generated/rv32ui-p-slti.hex
	vvp $^ +memfile=riscv-tests/generated/rv32ui-p-sltiu.hex
	vvp $^ +memfile=riscv-tests/generated/rv32ui-p-sltu.hex
	vvp $^ +memfile=riscv-tests/generated/rv32ui-p-sra.hex
	vvp $^ +memfile=riscv-tests/generated/rv32ui-p-srai.hex
	vvp $^ +memfile=riscv-tests/generated/rv32ui-p-srl.hex
	vvp $^ +memfile=riscv-tests/generated/rv32ui-p-srli.hex
	vvp $^ +memfile=riscv-tests/generated/rv32ui-p-sub.hex
	vvp $^ +memfile=riscv-tests/generated/rv32ui-p-sw.hex
	vvp $^ +memfile=riscv-tests/generated/rv32ui-p-xor.hex
	vvp $^ +memfile=riscv-tests/generated/rv32ui-p-xori.hex

test_pc: dist/pc_tb
	vvp $^

test_ram: dist/ram_tb
	vvp $^

test_registers: dist/registers_tb
	vvp $^

dist/top_tb: top_tb.sv $(SRC)
	iverilog -g2012 -o $@ -I ../src/riscv-core top_tb.sv

dist/pc_tb: pc_tb.sv $(SRC)
	iverilog -g2012 -o $@ -I ../src/riscv-core pc_tb.sv

dist/ram_tb: ram_tb.sv $(SRC)
	iverilog -g2012 -o $@ -I ../src/riscv-core ram_tb.sv

dist/registers_tb: registers_tb.sv $(SRC)
	iverilog -g2012 -o $@ -I ../src/riscv-core registers_tb.sv
