`include "pc.sv"
`include "registers.sv"
`include "alu.sv"
`include "decoder.sv"
`include "ram.sv"
`include "controller.sv"
`include "types.sv"
`include "csr.sv"

module top #(
  parameter PC_INIT = 32'h8000_0000,
  parameter int MEM_SIZE
) (
  input wire clk,
  input wire rst_n
);
  pc #(.PC_INIT(PC_INIT)) pc0(
    .clk(clk),
    .rst_n(rst_n)
  );

  // Instantiate RAM
  ram #(
    .MEM_SIZE(MEM_SIZE),
    .START_ADDR(32'h8000_0000)
  ) ram0(
    .clk(clk)
  );

  // RAMから命令を読み出し
  assign ram0.addr1 = pc0.pc;

  // Instantiate decoder
  decoder dec0(.instr(ram0.rd1));

  // Instantiate registers module
  registers regs0(
    .clk(clk),
    .rst_n(rst_n),
    .a1(dec0.rs1),
    .a2(dec0.rs2),
    .a3(dec0.rd)
  );

  // Instantiate CSR module
  csr csr0(
    .clk(clk)
  );

  // Instantiate ALU module
  alu alu0();

  // Instantiate controller module
  controller controller0(
    .opcode(dec0.opcode),
    .funct3(dec0.funct3),
    .funct7(dec0.funct7),
    .imm_i(dec0.imm_i),
    .imm_s(dec0.imm_s),
    .imm_b(dec0.imm_b),
    .imm_u(dec0.imm_u),
    .imm_j(dec0.imm_j),
    .rs1_rd(regs0.rd1),
    .rs2_rd(regs0.rd2),
    .pc(pc0.pc)
  );

  // PCの更新
  assign pc0.pc_next = controller0.pc_next;

  // ALUとcontrollerの繋ぎこみ
  assign alu0.src_a = controller0.alu_src_a;
  assign alu0.src_b = controller0.alu_src_b;
  assign alu0.alu_op = controller0.alu_op;
  assign controller0.alu_out = alu0.result;

  // メモリとcontrollerの繋ぎこみ
  assign ram0.addr2 = controller0.mem_addr;
  assign ram0.we2 = controller0.mem_we;
  assign ram0.wd2 = controller0.mem_wd;
  assign controller0.mem_out = ram0.rd2;

  // rdレジスタとcontrollerの繋ぎこみ
  assign regs0.we3 = controller0.rd_we;
  assign regs0.wd3 = controller0.rd_wd;

  // CSRとcontrollerの繋ぎこみ
  assign csr0.csr_addr1 = controller0.csr_addr1;
  assign csr0.csr_addr2 = controller0.csr_addr2;
  assign csr0.csr_addr3 = controller0.csr_addr3;
  assign csr0.csr_we1 = controller0.csr_we1;
  assign csr0.csr_we2 = controller0.csr_we2;
  assign csr0.csr_we3 = controller0.csr_we3;
  assign csr0.csr_wd1 = controller0.csr_wd1;
  assign csr0.csr_wd2 = controller0.csr_wd2;
  assign csr0.csr_wd3 = controller0.csr_wd3;
  assign controller0.csr_rd1 = csr0.csr_rd1;
  assign controller0.csr_rd2 = csr0.csr_rd2;
  assign controller0.csr_rd3 = csr0.csr_rd3;
endmodule
