`ifndef __CONTROLLER_SV
`define __CONTROLLER_SV

`include "riscv/types.sv"

module controller(
  input wire [6:0] opcode,
  input wire [2:0] funct3,
  input wire [6:0] funct7,
  input wire [11:0] imm_i,
  input wire [11:0] imm_s,
  input wire [11:0] imm_b,
  input wire [19:0] imm_u,
  input wire [19:0] imm_j,
  input wire [4:0] rs1,
  input wire [31:0] rs1_rd,
  input wire [31:0] rs2_rd,
  input wire [31:0] csr_rd1,
  input wire [31:0] csr_rd2,
  input wire [31:0] csr_rd3,
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
  output logic [11:0] csr_addr1,
  output logic [11:0] csr_addr2,
  output logic [11:0] csr_addr3,
  output logic csr_we1,
  output logic csr_we2,
  output logic csr_we3,
  output logic [31:0] csr_wd1,
  output logic [31:0] csr_wd2,
  output logic [31:0] csr_wd3,
  output logic [31:0] pc_next
);
  wire [31:0] sign_ext_imm_i = {{20{imm_i[11]}}, imm_i};
  wire [31:0] sign_ext_imm_s = {{20{imm_s[11]}}, imm_s};
  wire [31:0] sign_ext_imm_b = {{19{imm_b[11]}}, imm_b, 1'b0};
  wire [31:0] sign_ext_imm_j = {{11{imm_j[19]}}, imm_j, 1'b0};

  // Load用のデータ
  wire [31:0] sign_ext_byte_mem_out = {{24{mem_out[7]}}, mem_out[7:0]};
  wire [31:0] sign_ext_half_mem_out = {{16{mem_out[15]}}, mem_out[15:0]};
  wire [31:0] unsign_ext_byte_mem_out = {{24{1'b0}}, mem_out[7:0]};
  wire [31:0] unsign_ext_half_mem_out = {{16{1'b0}}, mem_out[15:0]};

  // auipc用のデータ
  wire [31:0] upimm = {imm_u, 12'b0};

  // Store用のデータ
  wire [31:0] byte_store_data = {mem_out[31:8], rs2_rd[7:0]};
  wire [31:0] half_store_data = {mem_out[31:16], rs2_rd[15:0]};

  // 分岐先アドレス
  wire [31:0] branch_addr = pc + sign_ext_imm_b;

  // ジャンプ先アドレス
  wire [31:0] jump_addr = pc + sign_ext_imm_j;

  // CSR転送命令用の即値データ
  wire [31:0] csr_imm = {{27{1'b0}}, rs1};

  always_comb begin
    // デフォルト値としてnopを設定（always_combの中では全ての信号に値を設定す
    // る必要がある）
    alu_op = ALU_ADD;
    alu_src_a = 0;
    alu_src_b = 0;
    mem_addr = 0;
    mem_we = 0;
    mem_wd = 0;
    rd_we = 0;
    rd_wd = 0;
    csr_addr1 = 0;
    csr_addr2 = 0;
    csr_addr3 = 0;
    csr_we1 = 0;
    csr_we2 = 0;
    csr_we3 = 0;
    csr_wd1 = 0;
    csr_wd2 = 0;
    csr_wd3 = 0;
    pc_next = pc + 4;
    case(opcode)
      7'b0000011: begin // Load Ops (I-Type)
        alu_op = ALU_ADD;
        alu_src_a = rs1_rd;
        alu_src_b = sign_ext_imm_i;
        mem_addr = alu_out;
        rd_we = 1;
        case (funct3)
          3'b000: rd_wd = sign_ext_byte_mem_out; // lb
          3'b001: rd_wd = sign_ext_half_mem_out; // lh
          3'b010: rd_wd = mem_out; // lw
          3'b100: rd_wd = unsign_ext_byte_mem_out; // lbu
          3'b101: rd_wd = unsign_ext_half_mem_out; // lhu
          default: ; // do nothing
        endcase
      end
      7'b0010011: begin // Imm ALU Ops (I-Type)
        alu_src_a = rs1_rd;
        alu_src_b = sign_ext_imm_i;
        rd_we = 1;
        rd_wd = alu_out;
        case (funct3)
          3'b000: alu_op = ALU_ADD; // addi
          3'b001: alu_op = ALU_SLL; // slli
          3'b010: alu_op = ALU_SLT; // slti
          3'b011: alu_op = ALU_SLTU; // sltiu
          3'b100: alu_op = ALU_XOR; // xori
          3'b101: begin
            case (funct7)
              7'b0000000: alu_op = ALU_SRL; // srli
              7'b0100000: alu_op = ALU_SRA; // srai
              default: ; // do nothing
            endcase
          end
          3'b110: alu_op = ALU_OR; // ori
          3'b111: alu_op = ALU_AND; // andi
          default: ; // do nothing
        endcase
      end
      7'b0010111: begin // auipc (rd = upimm + PC, upimm = imm_u << 12)
        alu_op = ALU_ADD;
        alu_src_a = pc;
        alu_src_b = upimm;
        rd_we = 1;
        rd_wd = alu_out;
      end
      7'b0100011: begin // Store Ops (S-Type)
        alu_op = ALU_ADD;
        alu_src_a = rs1_rd;
        alu_src_b = sign_ext_imm_s;
        mem_addr = alu_out;
        mem_we = 1;
        case (funct3)
          3'b000: mem_wd = byte_store_data; // sb
          3'b001: mem_wd = half_store_data; // sh
          3'b010: mem_wd = rs2_rd; // sw
          default: ; // do nothing
        endcase
      end
      7'b0110011: begin // ALU Ops (R-Type)
        alu_src_a = rs1_rd;
        alu_src_b = rs2_rd;
        rd_we = 1;
        rd_wd = alu_out;
        case (funct3)
          3'b000: begin
            case (funct7)
              7'b0000000: alu_op = ALU_ADD; // add
              7'b0100000: alu_op = ALU_SUB; // sub
              default: ; // do nothing
            endcase
          end
          3'b001: alu_op = ALU_SLL; // sll
          3'b010: alu_op = ALU_SLT; // slt
          3'b011: alu_op = ALU_SLTU; // sltu
          3'b100: alu_op = ALU_XOR; // xor
          3'b101: begin
            case (funct7)
              7'b0000000: alu_op = ALU_SRL; // srl
              7'b0100000: alu_op = ALU_SRA; // sra
              default: ; // do nothing
            endcase
          end
          3'b110: alu_op = ALU_OR; // or
          3'b111: alu_op = ALU_AND; // and
          default: ; // do nothing
        endcase
      end
      7'b0110111: begin // lui (rd = upimm, upimm = imm_u << 12)
        rd_we = 1;
        rd_wd = upimm;
      end
      7'b1100011: begin // Branch Ops (B-Type)
        alu_src_a = rs1_rd;
        alu_src_b = rs2_rd;
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
          default: ; // do nothing
        endcase
      end
      7'b1100111: begin // jalr
        // pcの更新
        alu_op = ALU_ADD;
        alu_src_a = rs1_rd;
        alu_src_b = sign_ext_imm_i;
        pc_next = alu_out;
        // レジスタには現在のpc+4を書き込む
        rd_we = 1;
        rd_wd = pc + 4;
      end
      7'b1101111: begin // jal
        // pcの更新
        pc_next = jump_addr;
        // レジスタには現在のpc+4を書き込む
        rd_we = 1;
        rd_wd = pc + 4;
      end
      7'b1110011: begin // System Ops
        case (funct3)
          3'b000: begin // ecall, ebreak, uret, sret, mret
            case (imm_i)
              12'h000: begin // ecall
                // mcauseレジスタの値を更新
                csr_addr1 = 12'h342;
                csr_we1 = 1;
                csr_wd1 = 11;
                // mepcレジスタの値を更新
                csr_addr2 = 12'h341;
                csr_we2 = 1;
                csr_wd2 = pc; // ecall命令のアドレスを保存
                // mstatusレジスタの値を更新
                // TODO

                // mtvecレジスタの値から例外ベクタアドレスを取得
                csr_addr3 = 12'h305;
                pc_next = csr_rd3;
              end
              12'h001: begin // ebreak
                // nopとして実装
              end
              12'h002: begin // uret
                // nopとして実装
              end
              12'h102: begin // sret
                // nopとして実装
              end
              12'h302: begin // mret
                // nopとして実装
              end
              default: ; // do nothing
            endcase
          end
          3'b001: begin // csrrw
            // レジスタにCSRの値を書き込む
            rd_we = 1;
            rd_wd = csr_rd1;
            // CSRにレジスタの値を書き込む
            csr_addr1 = imm_i;
            csr_we1 = 1;
            csr_wd1 = rs1_rd;
          end
          3'b010: begin // csrrs
            // レジスタにCSRの値を書き込む
            rd_we = 1;
            rd_wd = csr_rd1;
            // CSRをレジスタの値でビットセット
            csr_addr1 = imm_i;
            csr_we1 = 1;
            csr_wd1 = csr_rd1 | rs1_rd;
          end
          3'b011: begin // csrrc
            // レジスタにCSRの値を書き込む
            rd_we = 1;
            rd_wd = csr_rd1;
            // CSRをレジスタの値でビットクリア
            csr_addr1 = imm_i;
            csr_we1 = 1;
            csr_wd1 = csr_rd1 & ~rs1_rd;
          end
          3'b101: begin // csrrwi
            // レジスタにCSRの値を書き込む
            rd_we = 1;
            rd_wd = csr_rd1;
            // CSRに即値を書き込む
            csr_addr1 = imm_i;
            csr_we1 = 1;
            csr_wd1 = csr_imm;
          end
          3'b110: begin // csrrsi
            // レジスタにCSRの値を書き込む
            rd_we = 1;
            rd_wd = csr_rd1;
            // CSRを即値でビットセット
            csr_addr1 = imm_i;
            csr_we1 = 1;
            csr_wd1 = csr_rd1 | csr_imm;
          end
          3'b111: begin // csrrci
            // レジスタにCSRの値を書き込む
            rd_we = 1;
            rd_wd = csr_rd1;
            // CSRを即値でビットクリア
            csr_addr1 = imm_i;
            csr_we1 = 1;
            csr_wd1 = csr_rd1 & ~csr_imm;
          end
          default: ; // do nothing
        endcase
      end
      7'b0001111: begin // fence, fence.i
        // nopとして実装
      end
      default: begin
      end
    endcase
  end
endmodule

`endif
