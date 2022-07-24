module twiddle_mult #(parameter MSB=8)
(
	input clk,
	input start,
	input [MSB-1:0]i_x,
	input [MSB-1:0]i_y,
	input [MSB-1:0]i_c,
	input [MSB:0]i_c_plus_s,
	input [MSB:0]i_c_minus_s,
	output [MSB-1:0]o_Re_out,
	output [MSB-1:0]o_Im_out,
	output data_valid
	);

wire [8:0] w_add_answer;
wire [16:0] w_mult_z;
wire [16:0] w_mult_r;
wire [16:0] w_mult_i;

wire [16:0] w_r_out;
wire [16:0] w_i_out;
wire [16:0] w_add_z;
wire [16:0] w_neg_z;
wire [8:0] w_i_x;
wire [8:0] w_neg_y;

wire w_start_mult;
wire w_mult_dv;

N_bit_adder
#(.N(MSB+1))
adder_E(
	.input1({i_x[MSB-1],i_x[MSB-1:0]}),
	.input2(w_neg_y),
	.answer(w_add_answer[MSB:0])
	);

N_bit_adder
#(.N(17))
adder_R
(
	.input1(w_mult_r),
	.input2(w_mult_z),
	.answer(w_r_out)
	);

N_bit_adder
#(.N(17))
adder_I
(
	.input1(w_mult_i),
	.input2(w_neg_z),
	.answer(w_i_out)
	);


slowmpy multiplier_R
(
	.i_clk(clk),
	.i_reset(1'b0),
	.i_stb(start),
	.i_a({i_y[MSB-1],i_y[MSB-1:0]}),
	.i_b(i_c_minus_s),
	.o_p(w_mult_r)
	);

slowmpy multiplier_I
(
	.i_clk(clk),
	.i_reset(1'b0),
	.i_stb(start),
	.i_a({i_x[MSB-1], i_x[MSB-1:0]}),
	.i_b(i_c_plus_s),
	.o_p(w_mult_i)
	);


slowmpy multiplier_Z
(
	.i_clk(clk),
	.i_stb(start),
	.i_reset(1'b0),
	.i_a({i_c[MSB-1],i_c[MSB-1:0]}),
	.i_b(w_add_answer),
	.o_done(w_mult_dv),
	.o_p(w_mult_z)
	);

pos_2_neg #(.N(MSB+1))
y_neg
(
	.pos({i_y[MSB-1],i_y[MSB-1:0]}),
	.neg(w_neg_y)
	);

pos_2_neg #(.N(17))
z_neg
(
	.pos(w_mult_z),
	.neg(w_neg_z)
	);

assign data_valid = w_mult_dv;
assign o_Re_out[7:0] = w_r_out[14:7];
assign o_Im_out[7:0] = w_i_out[14:7];

endmodule // twiddle_mult