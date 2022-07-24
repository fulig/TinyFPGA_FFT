module multiplier_8_9Bit
	(
		output 		[16:0]	out,
		input			clk,
		input 	signed	[7:0] 	input_0,
		input 	signed	[8:0] 	input_1,
		input 	start,
		output 	data_valid
		);

reg	signed	[8:0] 	a_reg;
reg	signed	[8:0] 	b_reg;
reg	signed	[16:0]	out;
wire w_data_valid;

slowmpy mult
(	
	.i_clk  (clk),
	.i_reset (1'b0),
	.i_stb(start),
	.i_a(a_reg),
	.i_b(b_reg),
	.o_done(w_data_valid)
	);

	wire 	signed	[16:0]	mult_out;

	assign mult_out = a_reg * b_reg;

	always@(posedge clk)
	begin
		a_reg <= {input_0[7], input_0};
		b_reg <= input_1;
	end 

assign data_valid = w_data_valid;
endmodule // N_bit_multiplier
