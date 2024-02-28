module NAND_tb();
  logic a, b, y;

  // Instantiate the DUT
  NAND dut(a, b, y);

  // Stimulus
  initial begin
    $dumpfile("NAND_tb.vcd");
    $dumpvars(0, NAND_tb);

    a = 0; b = 0;
    #5;
    assert(y === 1);

    a = 0; b = 1;
    #5;
    assert(y === 1);

    a = 1; b = 0;
    #5;
    assert(y === 1);

    a = 1; b = 1;
    #5;
    assert(y === 0);

    $finish;
  end
endmodule
