`ifndef __DECODER_SV
`define __DECODER_SV

`include "types.sv"

module decoder(
  input wire [31:0] instr,
  output wire [4:0] rs1,
  output wire [4:0] rs2,
  output wire [4:0] rd,
  output logic [31:0] imm, // Sign-extended immediate
  output logic [2:0] alu_op, // ALU operation
  output alu_src_e alu_src, // ALU source
  output logic reg_we, // Register write enable
  output logic mem_we // Memory write enable
);
  wire [6:0] opcode = instr[6:0];
  assign rs1 = instr[19:15];
  assign rs2 = instr[24:20];
  assign rd = instr[11:7];

  wire [31:0] imm_i = {{20{instr[31]}}, instr[31:20]};
  wire [31:0] imm_s = {{20{instr[31]}}, instr[31:25], instr[11:7]};

  always_comb begin
    case(opcode)
      7'b0000011: begin // Load (I-type)
        imm = imm_i;
        alu_op = ALU_ADD;
        alu_src = ALU_SRC_IMM;
        reg_we = 1;
        mem_we = 0;
      end
      7'b0100011: begin // Store (S-type)
        imm = imm_s;
        alu_op = ALU_ADD;
        alu_src = ALU_SRC_IMM;
        reg_we = 0;
        mem_we = 1;
      end
    endcase
  end
endmodule

`endif
