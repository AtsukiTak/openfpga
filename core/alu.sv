`ifndef __ALU_SV
`define __ALU_SV

`include "types.sv"

module alu(
  input logic [31:0] src_a,
  input logic [31:0] src_b,
  input alu_op_e alu_op,
  output logic [31:0] result
);
  always_comb begin
    unique case(alu_op)
      ALU_ADD: result = src_a + src_b;
      ALU_SUB: result = src_a - src_b;
      ALU_AND: result = src_a & src_b;
      ALU_OR: result = src_a | src_b;
      ALU_XOR: result = src_a ^ src_b;
      default: result = 0;
    endcase
  end

endmodule

`endif
