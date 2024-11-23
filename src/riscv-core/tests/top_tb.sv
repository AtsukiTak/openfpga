`include "riscv/top.sv"
`include "riscv/ram.sv"

module top_tb();
  parameter MEM_SIZE = 'h4048;
  parameter PC_INIT = 'h8000_0000;

  logic clk, rst_n;
  logic [7:0] mem_data ['h8000_0000:'h8000_0000 + MEM_SIZE-1];

  top #(.PC_INIT(PC_INIT), .MEM_SIZE(MEM_SIZE)) top0(
    .clk(clk),
    .rst_n(rst_n)
  );

  string memfile;

  initial begin
    // 波形ファイルのdump
    // $dumpfile("top_tb.vcd");
    // $dumpvars(0, top0);

    // メモリファイルの読み込み
    if (!$value$plusargs("memfile=%s", memfile))
      $fatal(1, "memfile is not specified");

    $readmemh(memfile, top0.ram0.mem);

    // initialize
    clk = 0; rst_n = 1;

    // reset
    #1 rst_n = 0;
    #1 rst_n = 1;

    // clockを進める
    repeat(5000) begin
      #5 clk = ~clk;
      #5 clk = ~clk;
    end
    #1;

    // 3番レジスタに1が格納されているか確認
    assert(top0.regs0.regs[3] === 1)
      else $display("reg[3] error. expected: 32'h00000001, actual: %h", top0.regs0.regs[3]);
  end
endmodule
