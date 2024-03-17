module registers(
  input logic clk,
  input logic we,
  input logic [4:0] a1,
  input logic [4:0] a2,
  input logic [4:0] a3,
  input logic [31:0] wd3,
  output logic [31:0] rd1,
  output logic [31:0] rd2
);
  logic [31:0] regs [31:0];

  always_ff @(posedge clk) begin
    if (we) begin
      regs[a3] <= wd3;
    end
  end

  assign rd1 = a1 == 0 ? 0 : regs[a1];
  assign rd2 = a2 == 0 ? 0 : regs[a2];
endmodule
