`define DUMPSTR(x) `"x.vcd`"
`timescale 100 ns / 10 ns

module top_tb;

parameter DURATION = 100000;



reg clk;
reg data;

reg [15:0] out_0;
reg [15:0] out_1;
reg [15:0] out_2;
reg [15:0] out_3;
reg [15:0] out_4;
reg [15:0] out_5;
reg [15:0] out_6;
reg [15:0] out_7;

top topmodule(
	.CLK(clk), 
	.PIN_9(data) 
	);
always #1 clk <= ~clk;
always #3 data <= ~data;

initial begin
	clk <= 1;
	data <= 0;
$dumpfile(`DUMPSTR(`VCD_OUTPUT));
 $dumpvars(0, top_tb);

#(DURATION) $display("End of simulation");
$finish;
end

endmodule // top_tb