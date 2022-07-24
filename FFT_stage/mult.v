module multiplier_8_9Bit
	(
		output 		[16:0]	out,
		input			clk,
		input 	signed	[7:0] 	input_0,
		input 	signed	[8:0] 	input_1

		);

reg	signed	[7:0] 	a_reg;
	reg	signed	[8:0] 	b_reg;
	reg	signed	[16:0]	out;

	wire 	signed	[16:0]	mult_out;

	assign mult_out = a_reg * b_reg;

	always@(posedge clk)
	begin
		a_reg <= input_0;
		b_reg <= input_1;
		out <= mult_out;
	end 
endmodule // N_bit_multiplier

