`include "registers.sv"

module register_tb();
  logic clk, we;
  logic [4:0] a1, a2, a3;
  logic [31:0] rd1, rd2, wd3;

  registers regs(clk, we, a1, a2, a3, wd3, rd1, rd2);

  initial begin
    $dumpfile("dist/registers_tb.vcd");
    $dumpvars(0, register_tb);

    clk = 0;
    we = 0;
    a1 = 0;
    a2 = 0;
    a3 = 0;
    wd3 = 0;
    #10;

    // register 0 is always 0
    assert(rd1 == 0);
    assert(rd2 == 0);
    #10;

    // write to register 1
    we = 1;
    clk = 1;
    a3 = 1;
    wd3 = 42;
    #10;

    // read from register 1
    we = 0;
    clk = 0;
    a1 = 1;
    #1;
    assert(rd1 == 42) else $error("invalid register 1 data");
    #10;

    // write to register 0
    we = 1;
    clk = 1;
    a3 = 0;
    wd3 = 122;
    #10;

    // read from register 0 (should still be 0)
    we = 0;
    clk = 0;
    a1 = 0;
    #1
    assert(rd1 == 0);
    $finish;
  end

endmodule
