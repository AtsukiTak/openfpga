`include "ram.sv"

module ram_tb();
  logic clk, we;
  logic [31:0] addr, mem_wd, mem_rd;

  logic rst_n;
  logic [7:0] rst_data [0:127];

  ram #(.MEM_SIZE(128)) ram0(
    .clk      (clk),
    // port 2
    .addr2    (addr),
    .we2      (we),
    .rd2      (mem_rd),
    .wd2      (mem_wd),
    // for reset
    .rst_n  (rst_n),
    .rst_data (rst_data)
  );

  initial begin
    $dumpfile("dist/ram_tb.vcd");
    $dumpvars(0, ram_tb);

    // initialize signals
    clk = 0; we = 0; addr = 0; mem_wd = 0;

    // initialize memory
    rst_n = 1;
    rst_data[0] <= 8'h10;
    rst_data[1] <= 8'h32;
    rst_data[2] <= 8'h54;
    rst_data[3] <= 8'h76;
    #1 rst_n = 0;

    // read data
    we = 0; addr = 0;
    #10;
    assert(mem_rd == 32'h76543210);

    // write data
    we = 1; addr = 0; mem_wd = 32'h12345678; clk = 1;
    #10;

    // read data
    we = 0; addr = 0; clk = 0;
    #10;
    assert(mem_rd == 32'h12345678);
  end
endmodule
