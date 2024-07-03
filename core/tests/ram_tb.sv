`include "src/ram.sv"

module ram_tb();
  logic clk, we;
  logic [31:0] addr, mem_wd, mem_rd;
  logic [31:0] addr1, mem_rd1;

  ram #(.MEM_SIZE(16384), .START_ADDR(32'h8000_0000)) ram0(
    .clk      (clk),
    // port 2
    .addr2    (addr),
    .we2      (we),
    .rd2      (mem_rd),
    .wd2      (mem_wd)
  );

  initial begin
    $dumpfile("dist/ram_tb.vcd");
    $dumpvars(0, ram_tb);

    $readmemh("tests/isa/rv32ui-p-add.hex", ram0.mem);

    // initialize signals
    clk = 0; we = 0; addr = 0; mem_wd = 0;
    #10

    // read data
    we = 0; addr = 32'h8000_0000;
    #10;
    assert(mem_rd == 32'h0500_006F) else $fatal(1, "mem_rd = %h", mem_rd);

    // write data
    we = 1; mem_wd = 32'h1234_5678; clk = 1;
    for (int i = 0; i < 10; i++) begin
      #10;
      clk = ~clk;
    end

    // read data
    we = 0; clk = 0;
    #10;
    assert(mem_rd == 32'h1234_5678) else $fatal(1, "mem_rd = %h", mem_rd);
  end
endmodule
