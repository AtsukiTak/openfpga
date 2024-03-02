module ram_tb();
  logic clk, we;
  logic [31:0] addr, data_in, data_out;

  ram #(.MEM_SIZE(128)) ram0(
    // input
    .clk      (clk),
    .addr     (addr),
    .we       (we),
    .data_in  (data_in),
    // output
    .data_out (data_out)
  );

  initial begin
    // initialize
    clk = 0; we = 0; addr = 0; data_in = 0;

    // write data
    we = 1; addr = 0; data_in = 32'h12345678; clk = 1;
    #10;

    // read data
    we = 0; addr = 0; clk = 0;
    #10;
    assert(data_out == 32'h12345678);
  end
endmodule
