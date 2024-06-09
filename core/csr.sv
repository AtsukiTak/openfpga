`ifndef __CSR_SV
`define __CSR_SV

module csr(
  input wire clk,
  input wire [11:0] csr_addr,
  input wire csr_we,
  input wire [31:0] csr_wd,
  output wire [31:0] csr_rd
);
  logic [31:0] csr [0:4095];

  always_ff @(posedge clk) begin
    if (csr_we) begin
      csr[csr_addr] <= csr_wd;
    end
  end

  assign csr_rd = csr[csr_addr];
endmodule

`endif
