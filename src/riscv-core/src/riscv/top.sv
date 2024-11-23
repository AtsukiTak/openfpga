`include "riscv/pc.sv"
`include "riscv/registers.sv"
`include "riscv/alu.sv"
`include "riscv/decoder.sv"
`include "riscv/ram.sv"
`include "riscv/controller.sv"
`include "riscv/types.sv"
`include "riscv/csr.sv"

module top #(
  parameter PC_INIT,
  parameter int MEM_SIZE
) (
  input wire clk,
  input wire rst_n,
  output wire [31:0] reg4
);
  logic [31:0] pc;
  logic [31:0] pc_next;

  // RAM inputs and outputs
  logic [31:0] instr;
  logic [31:0] ram_addr;
  logic [31:0] ram_rd;
  logic [31:0] ram_wd;
  logic ram_we;

  // decode outputs
  wire  [6:0] instr_opcode;
  wire  [2:0] instr_funct3;
  wire  [6:0] instr_funct7;
  wire  [4:0] instr_rs1;
  wire  [4:0] instr_rs2;
  wire  [4:0] instr_rd;
  wire  [11:0] instr_imm_i;
  wire  [11:0] instr_imm_s;
  wire  [11:0] instr_imm_b;
  wire  [19:0] instr_imm_u;
  wire  [19:0] instr_imm_j;

  // register inputs and outputs
  logic [31:0] reg_rd1;
  logic [31:0] reg_rd2;
  logic reg_we3;
  logic [31:0] reg_wd3;

  // CSR inputs and outputs
  logic [11:0] csr_addr1;
  logic [11:0] csr_addr2;
  logic [11:0] csr_addr3;
  logic [31:0] csr_rd1;
  logic [31:0] csr_rd2;
  logic [31:0] csr_rd3;
  logic csr_we1;
  logic csr_we2;
  logic csr_we3;
  logic [31:0] csr_wd1;
  logic [31:0] csr_wd2;
  logic [31:0] csr_wd3;

  // ALU inputs and outputs
  logic [31:0] alu_src_a;
  logic [31:0] alu_src_b;
  alu_op_e alu_op;
  logic [31:0] alu_out;

  // Instantiate PC
  pc #(.PC_INIT(PC_INIT)) pc0(
    .clk(clk),
    .rst_n(rst_n),
    .pc_next(pc_next),
    .pc(pc)
  );

  // Instantiate RAM
  ram #(
    .MEM_SIZE(MEM_SIZE),
    .START_ADDR(PC_INIT)
  ) ram0(
    // Inputs
    .clk(clk),
    .rst_n(rst_n),
    .addr1(pc), // RAMから命令を読み出す
    .addr2(ram_addr),
    .we2(ram_we),
    .wd2(ram_wd),

    // Outputs
    .rd1(instr),
    .rd2(ram_rd)
  );

  // Instantiate decoder
  decoder dec0(
    // Inputs
    .instr(instr),

    // Outputs
    .opcode(instr_opcode),
    .funct3(instr_funct3),
    .funct7(instr_funct7),
    .rs1(instr_rs1),
    .rs2(instr_rs2),
    .rd(instr_rd),
    .imm_i(instr_imm_i),
    .imm_s(instr_imm_s),
    .imm_b(instr_imm_b),
    .imm_u(instr_imm_u),
    .imm_j(instr_imm_j)
  );

  // Instantiate registers module
  registers regs0(
    // Inputs
    .clk(clk),
    .rst_n(rst_n),
    .a1(instr_rs1),
    .a2(instr_rs2),
    .a3(instr_rd),
    .we3(reg_we3),
    .wd3(reg_wd3),

    // Outputs
    .rd1(reg_rd1),
    .rd2(reg_rd2),
    .reg4(reg4)
  );

  // Instantiate CSR module
  csr csr0(
    // Inputs
    .clk(clk),
    .csr_addr1(csr_addr1),
    .csr_addr2(csr_addr2),
    .csr_addr3(csr_addr3),
    .csr_we1(csr_we1),
    .csr_we2(csr_we2),
    .csr_we3(csr_we3),
    .csr_wd1(csr_wd1),
    .csr_wd2(csr_wd2),
    .csr_wd3(csr_wd3),

    // Outputs
    .csr_rd1(csr_rd1),
    .csr_rd2(csr_rd2),
    .csr_rd3(csr_rd3)
  );

  // Instantiate ALU module
  alu alu0(
    // Inputs
    .src_a(alu_src_a),
    .src_b(alu_src_b),
    .alu_op(alu_op),

    // Outputs
    .result(alu_out)
  );

  // Instantiate controller module
  controller controller0(
    // Inputs
    .opcode(instr_opcode),
    .funct3(instr_funct3),
    .funct7(instr_funct7),
    .imm_i(instr_imm_i),
    .imm_s(instr_imm_s),
    .imm_b(instr_imm_b),
    .imm_u(instr_imm_u),
    .imm_j(instr_imm_j),
    .rs1(instr_rs1),
    .rs1_rd(reg_rd1),
    .rs2_rd(reg_rd2),
    .csr_rd1(csr_rd1),
    .csr_rd2(csr_rd2),
    .csr_rd3(csr_rd3),
    .alu_out(alu_out),
    .mem_out(ram_rd),
    .pc(pc),

    // Outputs
    .alu_op(alu_op),
    .alu_src_a(alu_src_a),
    .alu_src_b(alu_src_b),
    .mem_addr(ram_addr),
    .mem_we(ram_we),
    .mem_wd(ram_wd),
    .rd_we(reg_we3),
    .rd_wd(reg_wd3),
    .csr_addr1(csr_addr1),
    .csr_addr2(csr_addr2),
    .csr_addr3(csr_addr3),
    .csr_we1(csr_we1),
    .csr_we2(csr_we2),
    .csr_we3(csr_we3),
    .csr_wd1(csr_wd1),
    .csr_wd2(csr_wd2),
    .csr_wd3(csr_wd3),
    .pc_next(pc_next)
  );
endmodule
