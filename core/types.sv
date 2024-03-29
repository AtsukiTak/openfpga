`ifndef __TYPES_SV
`define __TYPES_SV

typedef enum logic [2:0] {
  ALU_ADD,
  ALU_SUB,
  ALU_AND,
  ALU_OR,
  ALU_XOR
} alu_op_e;

typedef enum logic {
  ALU_SRC_RD2,
  ALU_SRC_IMM
} alu_src_e;

`endif
