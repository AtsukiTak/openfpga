`include "pc.sv"

module fetch_stage #(
  parameter int PC_INIT = 32'h8000_0000
) (
  input wire clk,
  input wire rst_n,
  input wire pc_next,
  input wire [31:0] mem_rd,
  output wire [31:0] mem_addr,
  output logic [31:0] pc_prev,
  output logic [31:0] instr_prev
);
  logic [31:0] expected_pc_next;

  always_ff @(posedge clk or negedge rst_n)
  begin
    if (!rst_n) begin
      mem_addr <= PC_INIT;
      pc_prev <= PC_INIT;
      instr_prev <= 32'h0;
      expected_pc_next <= PC_INIT + 4;
    end else begin
      pc_prev <= mem_addr;
      mem_addr <= pc_next;
      instr_prev <= mem_rd;
    end
  end


endmodule
