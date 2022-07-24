`define DUMPSTR(x) `"x.vcd`"
`timescale 100 ns / 10 ns

module tb_mult;

parameter DURATION = 1000;

reg [7:0] count;

reg clk;
wire [7:0] data_1 = 8'b11111011;
wire [7:0] data_0 = 8'b00000110;
wire [15:0] out;

reg reset = 1'b0;
reg start = 1'b0;

reg [7:0] a = 8'hFC;
reg [8:0] b = 9'h004;

slowmpy ugly
(
	.i_clk(clk),
	.i_stb(start),
	.i_reset(1'b0),
	.i_a({a[7],a[1:0]}),
	.i_b(b)
	);

multiplier_8_9Bit mult89
(
	.clk       (clk),
	.input_0 (a),
	.input_1(b),
	.start(start)
	);

always #1 clk <= ~clk;



initial begin
	clk <= 0;
	count <= 0;


$dumpfile(`DUMPSTR(`VCD_OUTPUT));
  $dumpvars(0, tb_mult);

   #(DURATION) $display("End of simulation");
  $finish;

end

always @ (posedge clk)
	begin
		if (count == 3)start <= 1'b1;
		else start <= 1'b0;
		if (count == 1)reset <= 1'b1;
		else reset <= 1'b0;
		count <= count + 1'b1;	
	end

endmodule // tb_adder