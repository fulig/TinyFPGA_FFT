module twiddle_mult
(
	input clk,
	input start,
	input [7:0]i_x,
	input [7:0]i_y,
	input [7:0]i_c,
	input [8:0]i_c_plus_s,
	input [8:0]i_c_minus_s,
	output [7:0]o_Re_out,
	output [7:0]o_Im_out,
	output data_valid
	);

wire [8:0] w_add_answer;
wire [16:0] w_mult_z;
wire [16:0] w_mult_r;
wire [16:0] w_mult_i;

wire [7:0] w_r_out;
wire [7:0] w_i_out;
wire [16:0] w_add_z;
wire [16:0] w_neg_z;
wire [8:0] w_i_x;
wire [8:0] w_neg_y;

wire w_start_mult;
wire w_mult_dv;

N_bit_adder
#(.N(9))
adder_E(
	.input1({i_x[7],i_x[7:0]}),
	.input2(~{i_y[7],i_y[7:0]}+1'b1),
	.answer(w_add_answer[8:0])
	);

N_bit_adder
#(.N(8))
adder_R
(
	.input1(w_mult_r[14:7]),
	.input2(w_mult_z[14:7]),
	.answer(w_r_out)
	);

N_bit_adder
#(.N(8))
adder_I
(
	.input1(w_mult_i[14:7]),
	.input2(~w_mult_z[14:7]+1'b1),
	.answer(w_i_out)
	);


multiplier_8_9Bit multiplier_R
(
	.clk(clk),
	.start(start),
	.in_0(i_y),
	.in_1(i_c_minus_s),
	.out(w_mult_r)
	);

multiplier_8_9Bit multiplier_I
(
	.clk(clk),
	.start(start),
	.in_0(i_x),
	.in_1(i_c_plus_s),
	.out(w_mult_i)
	);


multiplier_8_9Bit multiplier_Z
(
	.clk(clk),
	.start(start),
	.in_0(i_c),
	.in_1(w_add_answer),
	.data_valid(w_mult_dv),
	.out(w_mult_z)
	);

assign data_valid = w_mult_dv;
assign o_Re_out[7:0] = w_r_out;
assign o_Im_out[7:0] = w_i_out;

endmodule // twiddle_mult