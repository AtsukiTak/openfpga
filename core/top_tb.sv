`include "top.sv"
`include "ram.sv"

module top_tb();
  parameter MEM_SIZE = 'h2024;

  logic clk, rst_n;
  logic [7:0] mem_data[0:MEM_SIZE-1];
  logic [31:0] dbg_addr;

  top #(.PC_INIT(0), .MEM_SIZE(MEM_SIZE)) top0(
    .clk(clk),
    .rst_n(rst_n)
  );

  assign top0.ram0.rst_data = mem_data;
  assign top0.ram0.dbg_addr = dbg_addr;

  initial begin
    $dumpfile("dist/top_tb.vcd");
    $dumpvars(0, top_tb);

    // initialize
    clk = 0; rst_n = 1;
    // 0x0083_2303 (lw x6, 8(x0))
    // (x6レジスタに[x0+8]番地の値をload)
    mem_data[3] <= 8'h00;
    mem_data[2] <= 8'h83;
    mem_data[1] <= 8'h23;
    mem_data[0] <= 8'h03;
    // 0x0060_2623 (sw x6, 12(x0))
    // (x6レジスタの値を[x0+12]番地にstore)
    mem_data[4+3] <= 8'h00;
    mem_data[4+2] <= 8'h60;
    mem_data[4+1] <= 8'h26;
    mem_data[4+0] <= 8'h23;
    // 0x1234_5678 (swによってstoreされるdata)
    mem_data[8+3] <= 8'h12;
    mem_data[8+2] <= 8'h34;
    mem_data[8+1] <= 8'h56;
    mem_data[8] <= 8'h78;
    // reset
    #1 rst_n = 0;
    #1 rst_n = 1;

    // 1clock進める
    repeat(3) begin
      #1 clk = ~clk;
    end

    // 12番地に0x1234_5678がstoreされていることを確認
    dbg_addr <= 12;
    #1;
    assert(top0.ram0.dbg_rd === 32'h12345678)
      else $display("store error. expected: 32'h12345678, actual: %h", top0.ram0.dbg_rd);
  end
endmodule
