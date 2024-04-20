`include "pc.sv"
`include "registers.sv"
`include "alu.sv"
`include "decoder.sv"

module top #(
  parameter PC_INIT = 32'h8000_0000,
  parameter int MEM_SIZE
) (
  input wire clk,
  input wire rst_n
);
  pc #(.PC_INIT(PC_INIT)) pc0(
    .clk(clk),
    .rst_n(rst_n)
  );
  assign pc0.pc_next = pc0.pc + 4;

  // Instantiate RAM
  ram #(.MEM_SIZE(MEM_SIZE)) ram0(
    .clk(clk),
    .rst_n(rst_n)
  );

  // RAMから命令を読み出し
  assign ram0.addr1 = pc0.pc;
  wire [31:0] instr = ram0.rd1;

  // Instantiate decoder
  decoder dec0(.instr(instr));
  assign ram0.we2 = dec0.mem_we;

  // Instantiate registers module
  registers regs0(
    .clk(clk),
    .rst_n(rst_n),
    .a1(dec0.rs1),
    .a2(dec0.rs2),
    .rd2(ram0.wd2),
    .a3(dec0.rd),
    .we3(dec0.reg_we),
    .wd3(ram0.rd2)
  );

  // Instantiate ALU module
  alu alu0(
    .src_a(regs0.rd1),
    .src_b(dec0.imm),
    .alu_op(3'b000),
    .result(ram0.addr2)
  );
endmodule
