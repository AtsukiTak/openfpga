`ifndef __ALU_SV
`define __ALU_SV

`include "types.sv"

module alu(
  input logic [31:0] src_a,
  input logic [31:0] src_b,
  input alu_op_e alu_op,
  output logic [31:0] result
);
  wire signed [31:0] signed_src_a = signed'(src_a);
  wire signed [31:0] signed_src_b = signed'(src_b);

  wire [4:0] shamt = src_b[4:0]; // shift amount

  always_comb begin
    unique case(alu_op)
      ALU_ADD: result = src_a + src_b;
      ALU_SUB: result = src_a - src_b;
      ALU_AND: result = src_a & src_b;
      ALU_OR: result = src_a | src_b;
      ALU_XOR: result = src_a ^ src_b;
      ALU_SLL: result = src_a << shamt;
      ALU_SLT: result = (signed_src_a < signed_src_b) ? 1 : 0;
      ALU_SLTU: result = (src_a < src_b) ? 1 : 0;
      ALU_SRL: result = src_a >> shamt;
      ALU_SRA: result = signed_src_a >>> shamt;
      default: result = 0;
    endcase
  end

endmodule

`endif
