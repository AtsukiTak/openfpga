`include "pc.sv"
`include "registers.sv"
`include "alu.sv"
`include "decoder.sv"

module top #(
  parameter PC_INIT = 32'h8000_0000
) (
  input wire clk,
  input wire rst_n,
  // ram port 1
  output wire [31:0] mem_addr1, // ram data input
  input wire [31:0] mem_rd1, // ram data output
  // ram port 2
  output wire [31:0] mem_addr2, // ram data input
  input wire [31:0] mem_rd2, // ram data output
  output wire mem_we2, // ram write enable
  output wire [31:0] mem_wd2 // ram data input
);
  pc #(.PC_INIT(PC_INIT)) pc0(
    .clk(clk),
    .rst_n(rst_n)
  );
  assign pc0.pc_next = pc0.pc + 4;

  // RAMから命令を読み出し
  assign mem_addr1 = pc0.pc;
  wire [31:0] instr = mem_rd1;

  // Instantiate decoder
  decoder dec0(.instr(instr));
  assign mem_we2 = dec0.mem_we;

  // Instantiate registers module
  registers regs0(
    .clk(clk),
    .rst_n(rst_n),
    .a1(dec0.rs1),
    .a2(dec0.rs2),
    .rd2(mem_wd2),
    .a3(dec0.rd),
    .we3(dec0.reg_we),
    .wd3(mem_rd2)
  );

  // Instantiate ALU module
  alu alu0(
    .src_a(regs0.rd1),
    .src_b(dec0.imm),
    .alu_op(3'b000)
  );
  assign mem_addr2 = alu0.result;
endmodule
