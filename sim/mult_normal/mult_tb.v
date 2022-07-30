`define DUMPSTR(x) `"x.vcd`"
`timescale 100 ns / 10 ns

module tb_mult;

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

twiddle_mult twiddle
(
	.clk(clk),
	.start(en),
	.i_x(8'h37),
	.i_y(8'h59),
	.i_c(8'h6E),
	.i_c_plus_s(9'h0AE),
	.i_c_minus_s(8'h02E)
	);
initial begin
	clk <= 0;

$dumpfile(`DUMPSTR(`VCD_OUTPUT));
  $dumpvars(0, tb_mult);

   #(DURATION) $display("End of simulation");
  $finish;
end // initial

always @(posedge clk)
begin
en <= (cnt == 1);
cnt = cnt + 1'b1;
end

endmodule // tb_shift