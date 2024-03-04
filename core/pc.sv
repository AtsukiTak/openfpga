module PC
(
  input logic clk,
  input logic rst_n,
  input logic [31:0] pc_next,
  output logic [31:0] pc
);
  always_ff @(posedge clk or negedge rst_n)
  begin
    if (!rst_n)
      pc <= 32'h8000_0000;
    else
      pc <= pc_next;
  end
endmodule
