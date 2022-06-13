`define DUMPSTR(x) `"x.vcd`"
`timescale 100 ns / 10 ns

module tb_bfp;

parameter DURATION = 1000;

reg [7:0] count;

reg clk;




reg [7:0] a_re = 8'h0C;
reg [7:0] a_im = 8'h1E;
reg [7:0] b_re = 8'h0F;
reg [7:0] b_im = 8'h0A;
reg [7:0] c = 8'h1E;
reg [8:0] c_plus_s = 9'h029; //c+s
reg [8:0] c_minus_s = 9'h013; // c-s
wire [15:0] out;


reg start = 1'b0;


bfprocessor bf_test
(
	.clk(clk),
	.start_calc(start),
	.A_re(a_re),
	.A_im(a_im),
	.B_re(b_re),
	.B_im(b_im),
	.i_C(c),
	.C_plus_S(c_plus_s),
	.C_minus_S(c_minus_s)
	);

always #1 clk <= ~clk;



initial begin
	clk <= 0;
	count <= 0;


$dumpfile(`DUMPSTR(`VCD_OUTPUT));
  $dumpvars(0, tb_bfp);

   #(DURATION) $display("End of simulation");
  $finish;

end

always @ (posedge clk)
	begin
		if (count == 0)
		begin
			start <= 1'b1;
		end
		else 
			begin
				start <= 1'b0;
			end
		count <= count + 1'b1;	
	end

endmodule // tb_adder