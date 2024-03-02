module ram #(
  parameter int MEM_SIZE // RAM size in bytes
) (
  input logic clk, // Clock
  input logic [31:0] addr, // Address
  input logic we, // Write enable
  input logic [31:0] data_in, // Write data
  output logic [31:0] data_out // Read data
);
  // Memory array
  logic [7:0] mem[0:MEM_SIZE-1];

  // Read operation
  assign data_out = {mem[addr+3], mem[addr+2], mem[addr+1], mem[addr]};

  // Write operation
  always_ff @(posedge clk) begin
    if (we) begin
      mem[addr] <= data_in[7:0];
      mem[addr+1] <= data_in[15:8];
      mem[addr+2] <= data_in[23:16];
      mem[addr+3] <= data_in[31:24];
    end
  end
endmodule
