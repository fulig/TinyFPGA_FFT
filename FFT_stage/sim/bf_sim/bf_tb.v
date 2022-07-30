`define DUMPSTR(x) `"x.vcd`"
`timescale 100 ns / 10 ns

module tb_bf;

parameter MSB = 16;
parameter DURATION = 1000;

reg [8:0] cnt = 0;
reg data = 0;
reg clk = 0;
reg en = 0;
reg [7:0] data_0 = 8'b00000100;
reg [7:0] data_1 = 8'b00000101;

always #1 clk <= ~clk;
always #1 data <= data + 4'b0111;

bfprocessor bf_processor
(
	.clk(clk),
	.start_calc(en),
	.A_re(8'h62),
	.A_im(8'h52),
	.B_re(8'h46),
	.B_im(8'h32),
	.i_C(8'h6E),
	.C_plus_S(9'h0AE),
	.C_minus_S(9'h02E)
	);
initial begin
	clk <= 0;

$dumpfile(`DUMPSTR(`VCD_OUTPUT));
  $dumpvars(0, tb_bf);

   #(DURATION) $display("End of simulation");
  $finish;
end // initial

always @(posedge clk)
begin
en <= (cnt == 1);
cnt = cnt + 1'b1;
end

endmodule // tb_shift