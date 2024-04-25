`ifndef __DECODER_SV
`define __DECODER_SV

`include "types.sv"

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
  output wire [12:1] imm_b
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
endmodule

`endif
