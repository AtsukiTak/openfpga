`include "top.sv"
`include "ram.sv"

module top_tb();
  parameter MEM_SIZE = 'h2024;
  parameter PC_INIT = 'h8000_0000;

  logic clk, rst_n;
  logic [7:0] mem_data ['h8000_0000:'h8000_0000 + MEM_SIZE-1];
  logic [31:0] dbg_addr;

  top #(.PC_INIT(PC_INIT), .MEM_SIZE(MEM_SIZE)) top0(
    .clk(clk),
    .rst_n(rst_n)
  );

  assign top0.ram0.dbg_addr = dbg_addr;

  initial begin
    $dumpfile("dist/top_tb.vcd");
    $dumpvars(0, top_tb);

    $readmemh("../tests/isa/rv32ui-p-add.hex", mem_data, 'h80000000);

    // initialize
    clk = 0; rst_n = 1;

    // reset
    #1 rst_n = 0;
    #1 rst_n = 1;

    // 2clock進める
    repeat(5) begin
      #1 clk = ~clk;
    end

    // 1028番地に0x1234_5678がstoreされていることを確認
    dbg_addr <= 1028;
    #1;
    assert(top0.ram0.dbg_rd === 32'h12345678)
      else $display("store error. expected: 32'h12345678, actual: %h", top0.ram0.dbg_rd);
  end
endmodule
