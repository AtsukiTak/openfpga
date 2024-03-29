`ifndef __REGISTERS_SV
`define __REGISTERS_SV

module registers(
  input logic clk,
  input logic rst_n, // reset at negative edge
  // port 1
  input logic [4:0] a1,
  output logic [31:0] rd1,
  // port 2
  input logic [4:0] a2,
  output logic [31:0] rd2,
  // port 3
  input logic [4:0] a3,
  input logic we3,
  input logic [31:0] wd3
);
  logic [31:0] regs [31:0];


  always_ff @(posedge clk) begin
    if (we3) begin
      regs[a3] <= wd3;
    end
  end

  always_ff @(negedge rst_n) begin
    for (int i = 0; i < 32; i++) begin
      regs[i] <= 32'h0;
    end
  end

  assign rd1 = a1 == 0 ? 0 : regs[a1];
  assign rd2 = a2 == 0 ? 0 : regs[a2];
endmodule

`endif
