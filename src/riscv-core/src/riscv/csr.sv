`ifndef __CSR_SV
`define __CSR_SV

module csr(
  input wire clk,
  input logic [11:0] csr_addr1,
  input logic [11:0] csr_addr2,
  input logic [11:0] csr_addr3,
  input logic csr_we1,
  input logic csr_we2,
  input logic csr_we3,
  input logic [31:0] csr_wd1,
  input logic [31:0] csr_wd2,
  input logic [31:0] csr_wd3,
  output logic [31:0] csr_rd1,
  output logic [31:0] csr_rd2,
  output logic [31:0] csr_rd3
);
  logic [31:0] csr [0:4];

  always_ff @(posedge clk) begin
    if (csr_we1) begin
      csr[csr_addr1] <= csr_wd1;
    end
    if (csr_we2) begin
      csr[csr_addr2] <= csr_wd2;
    end
    if (csr_we3) begin
      csr[csr_addr3] <= csr_wd3;
    end
  end

  assign csr_rd1 = csr[csr_addr1];
  assign csr_rd2 = csr[csr_addr2];
  assign csr_rd3 = csr[csr_addr3];
endmodule

`endif
