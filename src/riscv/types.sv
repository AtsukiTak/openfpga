`ifndef __TYPES_SV
`define __TYPES_SV

typedef enum logic [4:0] {
  ALU_ADD,
  ALU_SUB,
  ALU_AND,
  ALU_OR,
  ALU_XOR,
  ALU_SLL,
  ALU_SLT,
  ALU_SLTU,
  ALU_SRL,
  ALU_SRA
} alu_op_e;

typedef enum logic {
  ALU_SRC_RD2,
  ALU_SRC_IMM
} alu_src_e;

typedef enum logic {
  REG_WD_SRC_ALU,
  REG_WD_SRC_MEM
} reg_wd_src_e;

`endif
