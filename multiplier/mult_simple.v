module signed_mult (out, clk, a, b);

	output 		[16:0]	out;
	input			clk;
	input 	signed	[7:0] 	a;
	input 	signed	[8:0] 	b;

	reg	signed	[7:0] 	a_reg;
	reg	signed	[8:0] 	b_reg;
	reg	signed	[16:0]	out;

	wire 	signed	[16:0]	mult_out;

	assign mult_out = a_reg * b_reg;

	always@(posedge clk)
	begin
		a_reg <= a;
		b_reg <= b;
		out <= mult_out;
	end

endmodule