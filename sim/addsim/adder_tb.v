`define DUMPSTR(x) `"x.vcd`"
`timescale 100 ns / 10 ns

module tb_adder;

parameter DURATION = 1000;

reg clk;
wire [7:0] data_0 = 8'b10110101;
wire [7:0] data_1 = 8'b11010011;
wire [7:0] out;
wire carry_out;

wire [7:0] w_dat_0;
wire [7:0] w_dat_1;
wire [7:0] w_out;

reg d0;
reg d1;
reg o;
reg c;

N_bit_adder Bit_adder(
	.input1(data_0[7:0]),
	.input2(data_1[7:0]),
	.answer(out[7:0]),
	.carry_out(carry_out)
	);

always #1 clk <= ~clk;
always #5 d0 <= ~d0;
always #7 d1 <= ~d1;



initial begin
	clk <= 0;
	d0 <= 0;
	d1 <= 0;



$dumpfile(`DUMPSTR(`VCD_OUTPUT));
  $dumpvars(0, tb_adder);

   #(DURATION) $display("End of simulation");
  $finish;

end

endmodule // tb_adder