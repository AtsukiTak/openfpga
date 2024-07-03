`ifndef __RAM_SV
`define __RAM_SV

module ram #(
  parameter int unsigned MEM_SIZE, // RAM size in bytes
  parameter int unsigned START_ADDR // Start address
) (
  input logic clk, // Clock
  // port 1
  input logic [31:0] addr1, // Address
  output logic [31:0] rd1, // Read data 1
  // port 2
  input logic [31:0] addr2, // Address
  output wire [31:0] rd2, // Read data 2
  input logic we2, // Write enable
  input logic [31:0] wd2 // Write data
);
  // Memory array
  logic [7:0] mem[START_ADDR:MEM_SIZE+START_ADDR-1];

  // Read operation
  assign rd1 = {mem[addr1+3], mem[addr1+2], mem[addr1+1], mem[addr1]};
  assign rd2 = {mem[addr2+3], mem[addr2+2], mem[addr2+1], mem[addr2]};

  // Write operation
  always_ff @(posedge clk) begin
    if (we2) begin
      mem[addr2] <= wd2[7:0];
      mem[addr2+1] <= wd2[15:8];
      mem[addr2+2] <= wd2[23:16];
      mem[addr2+3] <= wd2[31:24];
    end
  end
endmodule

`endif
