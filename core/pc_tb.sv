module PC_tb();
  logic clk, rst_n;
  logic [31:0] pc_next, pc;

  PC pc0(clk, rst_n, pc_next, pc);

  initial begin
    $dumpfile("dist/PC_tb.vcd");
    $dumpvars(0, PC_tb);

    // reset
    clk = 0; rst_n = 1;
    #10
    rst_n = 0;
    #10
    assert(pc === 0);

    rst_n = 1; pc_next = 1000; clk = 1;
    #10
    assert(pc === 1000);
  end
endmodule
