`include "src/pc.sv"

module pc_tb();
  logic clk, rst_n;
  logic [31:0] pc_next, pc;

  pc pc0(clk, rst_n, pc_next, pc);

  initial begin
    $dumpfile("dist/pc_tb.vcd");
    $dumpvars(0, pc_tb);

    // reset
    clk = 0; rst_n = 1;
    #10
    rst_n = 0;
    #10
    assert(pc === 32'h8000_0000);

    rst_n = 1; pc_next = 1000; clk = 1;
    #10
    assert(pc === 1000);
  end
endmodule
