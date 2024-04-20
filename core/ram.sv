`ifndef __RAM_SV
`define __RAM_SV

module ram #(
  parameter int MEM_SIZE // RAM size in bytes
) (
  input logic clk, // Clock
  // port 1
  input logic [31:0] addr1, // Address
  output logic [31:0] rd1, // Read data 1
  // port 2
  input logic [31:0] addr2, // Address
  output logic [31:0] rd2, // Read data 2
  input logic we2, // Write enable
  input logic [31:0] wd2, // Write data
  // for simulation
  input logic rst_n, // reset at negative edge
  input logic [7:0] rst_data[0:MEM_SIZE-1], // initial data
  input logic [31:0] dbg_addr, // debug address
  output logic [31:0] dbg_rd // debug read data
);
  // Memory array
  logic [7:0] mem[0:MEM_SIZE-1];

  // Read operation
  assign rd1 = {mem[addr1+3], mem[addr1+2], mem[addr1+1], mem[addr1]};
  assign rd2 = {mem[addr2+3], mem[addr2+2], mem[addr2+1], mem[addr2]};
  assign dbg_rd = {mem[dbg_addr+3], mem[dbg_addr+2], mem[dbg_addr+1], mem[dbg_addr]};

  // Write operation
  always_ff @(posedge clk) begin
    if (we2) begin
      mem[addr2] <= wd2[7:0];
      mem[addr2+1] <= wd2[15:8];
      mem[addr2+2] <= wd2[23:16];
      mem[addr2+3] <= wd2[31:24];
    end
  end

  // Initialize data
  always_ff @(negedge rst_n) begin
    for (int i = 0; i < MEM_SIZE; i = i + 1) begin
      mem[i] <= rst_data[i];
    end
  end
endmodule

`endif
