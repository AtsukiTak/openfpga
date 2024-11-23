`include "src/registers.sv"

module register_tb();
  logic clk, rst_n, we3;
  logic [4:0] a1, a2, a3;
  logic [31:0] wd3;

  registers regs(
    .clk,
    .rst_n,
    .a1,
    .a2,
    .a3,
    .we3(we3),
    .wd3
  );

  initial begin
    $dumpfile("dist/registers_tb.vcd");
    $dumpvars(0, register_tb);

    // register 0 is always 0
    a1 = 0; a2 = 0;
    #1;
    assert(regs.rd1 === 0);
    assert(regs.rd2 === 0);

    // reset
    clk = 0; rst_n = 1;
    #1 rst_n = 0;
    #1 rst_n = 1;

    // when reset, all registers should be 0
    for (int i = 0; i < 32; i++) begin
      a1 = i;
      #1;
      assert(regs.rd1 === 0);
    end

    // write to register 1
    we3 = 1;
    clk = 1;
    a3 = 1;
    wd3 = 42;
    #10;

    // read from register 1
    we3 = 0;
    clk = 0;
    a1 = 1;
    #1;
    assert(regs.rd1 === 42) else $error("invalid register 1 data");
    #10;

    // write to register 0
    we3 = 1;
    clk = 1;
    a3 = 0;
    wd3 = 122;
    #10;

    // read from register 0 (should still be 0)
    we3 = 0;
    clk = 0;
    a1 = 0;
    #1
    assert(regs.rd1 === 0);
    $finish;
  end

endmodule
