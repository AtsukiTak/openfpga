`ifndef __CONTROLLER_SC
`define __CONTROLLER_SC

`include "types.sv"

module controller(
  input wire [6:0] opcode,
  input wire [2:0] funct3,
  input wire [6:0] funct7,
  input wire [11:0] imm_i,
  input wire [11:0] imm_s,
  input wire [11:0] imm_b,
  input wire [31:0] rs1_rd,
  input wire [31:0] rs2_rd,
  input wire [31:0] alu_out,
  input wire [31:0] mem_out,
  input wire [31:0] pc,
  output alu_op_e alu_op,
  output logic [31:0] alu_src_a,
  output logic [31:0] alu_src_b,
  output logic [31:0] mem_addr,
  output logic mem_we,
  output logic [31:0] mem_wd,
  output logic rd_we,
  output logic [31:0] rd_wd,
  output logic [31:0] pc_next
);
  wire [31:0] sign_ext_imm_i = {{20{imm_i[11]}}, imm_i};
  wire [31:0] sign_ext_imm_s = {{20{imm_s[11]}}, imm_s};
  wire [31:0] sign_ext_imm_b = {{19{imm_b[11]}}, imm_b, 1'b0};
  wire [31:0] branch_addr = pc + sign_ext_imm_b;

  always_comb begin
    case(opcode)
      7'b0000011: begin // Load Ops (I-Type)
        alu_op = ALU_ADD;
        alu_src_a = rs1_rd;
        alu_src_b = sign_ext_imm_i;
        mem_addr = alu_out;
        rd_we = 1;
        rd_wd = mem_out;
        mem_we = 0;
        mem_wd = 0;
        pc_next = pc + 4;
      end
      7'b0100011: begin // Store Ops (S-Type)
        alu_op = ALU_ADD;
        alu_src_a = rs1_rd;
        alu_src_b = sign_ext_imm_s;
        mem_addr = alu_out;
        mem_we = 1;
        mem_wd = rs2_rd;
        rd_we = 0;
        rd_wd = 0;
        pc_next = pc + 4;
      end
      7'b0010011: begin // Imm ALU Ops (I-Type)
        mem_addr = 0;
        mem_we = 0;
        mem_wd = 0;
        pc_next = pc + 4;
        case (funct3)
          3'b000: begin // addi
            alu_op = ALU_ADD;
            alu_src_a = rs1_rd;
            alu_src_b = sign_ext_imm_i;
            rd_we = 1;
            rd_wd = alu_out;
          end
        endcase
      end
      7'b0110011: begin // ALU Ops (R-Type)
        alu_src_a = rs1_rd;
        alu_src_b = rs2_rd;
        rd_we = 1;
        rd_wd = alu_out;
        mem_addr = 0;
        mem_we = 0;
        mem_wd = 0;
        pc_next = pc + 4;
        case (funct3)
          3'b000: begin
            case (funct7)
              7'b0000000: alu_op = ALU_ADD;
              7'b0100000: alu_op = ALU_SUB;
            endcase
          end
          3'b001: alu_op = ALU_SLL;
          3'b010: alu_op = ALU_SLT;
          3'b011: alu_op = ALU_SLTU;
          3'b100: alu_op = ALU_XOR;
          3'b101: begin
            case (funct7)
              7'b0000000: alu_op = ALU_SRL;
              7'b0100000: alu_op = ALU_SRA;
            endcase
          end
          3'b110: alu_op = ALU_OR;
          3'b111: alu_op = ALU_AND;
        endcase
      end
      7'b1100011: begin // Branch Ops (B-Type)
        pc_next = pc + 4;
        alu_src_a = rs1_rd;
        alu_src_b = rs2_rd;
        rd_we = 0;
        rd_wd = 0;
        mem_addr = 0;
        mem_we = 0;
        mem_wd = 0;
        case (funct3)
          3'b000: begin // beq
            alu_op = ALU_SUB;
            if (alu_out == 0) begin
              pc_next = branch_addr;
            end
          end
          3'b001: begin // bne
            alu_op = ALU_SUB;
            if (alu_out != 0) begin
              pc_next = branch_addr;
            end
          end
          3'b100: begin // blt
            alu_op = ALU_SLT;
            if (alu_out == 1) begin
              pc_next = branch_addr;
            end
          end
          3'b101: begin // bge
            alu_op = ALU_SLT;
            if (alu_out == 0) begin
              pc_next = branch_addr;
            end
          end
          3'b110: begin // bltu
            alu_op = ALU_SLTU;
            if (alu_out == 1) begin
              pc_next = branch_addr;
            end
          end
          3'b111: begin // bgeu
            alu_op = ALU_SLTU;
            if (alu_out == 0) begin
              pc_next = branch_addr;
            end
          end
        endcase
      end
    endcase
  end
endmodule

`endif
