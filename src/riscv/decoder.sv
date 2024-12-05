`ifndef __DECODER_SV
`define __DECODER_SV

`include "riscv/types.sv"

module decoder(
  input wire [31:0] instr,
  output wire [6:0] opcode,
  output wire [2:0] funct3,
  output wire [6:0] funct7,
  output wire [4:0] rs1,
  output wire [4:0] rs2,
  output wire [4:0] rd,
  output wire [11:0] imm_i,
  output wire [11:0] imm_s,
  output wire [11:0] imm_b,
  output wire [19:0] imm_u,
  output wire [19:0] imm_j
);
  assign opcode = instr[6:0];
  assign funct3 = instr[14:12];
  assign funct7 = instr[31:25];
  assign rs1 = instr[19:15];
  assign rs2 = instr[24:20];
  assign rd = instr[11:7];
  assign imm_i = instr[31:20];
  assign imm_s = {instr[31:25], instr[11:7]};
  assign imm_b = {instr[31], instr[7], instr[30:25], instr[11:8]};
  assign imm_u = instr[31:12];
  assign imm_j = {instr[31], instr[19:12], instr[20], instr[30:21]};
endmodule

`endif
