`ifndef __CONTROLLER_SC
`define __CONTROLLER_SC

`include "types.sv"

module controller(
  input wire [6:0] opcode,
  input wire [2:0] funct3,
  input wire [6:0] funct7,
  input wire [11:0] imm_i,
  input wire [11:0] imm_s,
  input wire [12:1] imm_b,
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
  wire [31:0] sext_imm_i = {{20{imm_i[11]}}, imm_i};
  wire [31:0] sext_imm_s = {{20{imm_s[11]}}, imm_s};

  always_comb begin
    case(opcode)
      7'b0000011: begin // Load Ops (I-Type)
        alu_op = ALU_ADD;
        alu_src_a = rs1_rd;
        alu_src_b = sext_imm_i;
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
        alu_src_b = sext_imm_s;
        mem_addr = alu_out;
        mem_we = 1;
        mem_wd = rs2_rd;
        rd_we = 0;
        rd_wd = 0;
        pc_next = pc + 4;
      end
      7'b0010011: begin // Imm ALU Ops (I-Type)
        case (funct3)
          3'b000: begin // addi
            alu_op = ALU_ADD;
            alu_src_a = rs1_rd;
            alu_src_b = sext_imm_i;
            rd_we = 1;
            rd_wd = alu_out;
            mem_addr = 0;
            mem_we = 0;
            mem_wd = 0;
            pc_next = pc + 4;
          end
        endcase
      end
      7'b0110011: begin // ALU Ops (R-Type)
        case (funct3)
          3'b000: begin
            case (funct7)
              7'b0000000: begin // add
                alu_op = ALU_ADD;
                alu_src_a = rs1_rd;
                alu_src_b = rs2_rd;
                rd_we = 1;
                rd_wd = alu_out;
                mem_addr = 0;
                mem_we = 0;
                mem_wd = 0;
                pc_next = pc + 4;
              end
              7'b0100000: begin // sub
                alu_op = ALU_SUB;
                alu_src_a = rs1_rd;
                alu_src_b = rs2_rd;
                rd_we = 1;
                rd_wd = alu_out;
                mem_addr = 0;
                mem_we = 0;
                mem_wd = 0;
                pc_next = pc + 4;
              end
            endcase
          end
          3'b001: begin // sll
            alu_op = ALU_SLL;
            alu_src_a = rs1_rd;
            alu_src_b = rs2_rd;
            rd_we = 1;
            rd_wd = alu_out;
            mem_addr = 0;
            mem_we = 0;
            mem_wd = 0;
            pc_next = pc + 4;
          end
          3'b010: begin // slt
            alu_op = ALU_SLT;
            alu_src_a = rs1_rd;
            alu_src_b = rs2_rd;
            rd_we = 1;
            rd_wd = alu_out;
            mem_addr = 0;
            mem_we = 0;
            mem_wd = 0;
            pc_next = pc + 4;
          end
          3'b011: begin // sltu
            alu_op = ALU_SLTU;
            alu_src_a = rs1_rd;
            alu_src_b = rs2_rd;
            rd_we = 1;
            rd_wd = alu_out;
            mem_addr = 0;
            mem_we = 0;
            mem_wd = 0;
            pc_next = pc + 4;
          end
          3'b100: begin // xor
            alu_op = ALU_XOR;
            alu_src_a = rs1_rd;
            alu_src_b = rs2_rd;
            rd_we = 1;
            rd_wd = alu_out;
            mem_addr = 0;
            mem_we = 0;
            mem_wd = 0;
            pc_next = pc + 4;
          end
          3'b101: begin
            case (funct7)
              7'b0000000: begin // srl
                alu_op = ALU_SRL;
                alu_src_a = rs1_rd;
                alu_src_b = rs2_rd;
                rd_we = 1;
                rd_wd = alu_out;
                mem_addr = 0;
                mem_we = 0;
                mem_wd = 0;
                pc_next = pc + 4;
              end
              7'b0100000: begin // sra
                alu_op = ALU_SRA;
                alu_src_a = rs1_rd;
                alu_src_b = rs2_rd;
                rd_we = 1;
                rd_wd = alu_out;
                mem_addr = 0;
                mem_we = 0;
                mem_wd = 0;
                pc_next = pc + 4;
              end
            endcase
          end
          3'b110: begin // or
            alu_op = ALU_OR;
            alu_src_a = rs1_rd;
            alu_src_b = rs2_rd;
            rd_we = 1;
            rd_wd = alu_out;
            mem_addr = 0;
            mem_we = 0;
            mem_wd = 0;
            pc_next = pc + 4;
          end
          3'b111: begin // and
            alu_op = ALU_AND;
            alu_src_a = rs1_rd;
            alu_src_b = rs2_rd;
            rd_we = 1;
            rd_wd = alu_out;
            mem_addr = 0;
            mem_we = 0;
            mem_wd = 0;
            pc_next = pc + 4;
          end
        endcase
      end
    endcase
  end
endmodule

`endif
