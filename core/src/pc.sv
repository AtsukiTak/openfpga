`ifndef __PC_SV
`define __PC_SV

module pc #(
  parameter int PC_INIT = 32'h8000_0000
) (
  input logic clk,
  input logic rst_n,
  input logic [31:0] pc_next,
  output logic [31:0] pc
);
  always_ff @(posedge clk or negedge rst_n)
  begin
    if (!rst_n)
      pc <= PC_INIT;
    else
      pc <= pc_next;
  end
endmodule

`endif
