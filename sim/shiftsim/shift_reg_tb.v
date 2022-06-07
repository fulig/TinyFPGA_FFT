`define DUMPSTR(x) `"x.vcd`"
`timescale 100 ns / 10 ns

module tb_shift;

parameter MSB = 16;
parameter DURATION = 1000;

	reg [15:0]data;
	reg clk;
	reg en;
	wire[MSB-1:0][7:0] out;

shift_16Bit  shift_reg_1(
	.data(data),
	.clk(clk),
	.en(en)
	);

always #1 clk <= ~clk;
always #1 data <= data + 4'b0111;


initial begin
	clk <= 0;
	en <= 0;
	data <= 1;
	#20 en <= 1;

$dumpfile(`DUMPSTR(`VCD_OUTPUT));
  $dumpvars(0, shift_reg_1);

   #(DURATION) $display("End of simulation");
  $finish;
end // initial

endmodule // tb_shift