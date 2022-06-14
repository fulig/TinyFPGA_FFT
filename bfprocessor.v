module bfprocessor
	(
		input clk,
		input [7:0] A_re, A_im,
		input [7:0] B_re, B_im,
		input [7:0] i_C,
		input [8:0] C_plus_S, C_minus_S,
		input start_calc,
		output data_valid,
		output [7:0] D_re, D_im,
		output [7:0] E_re, E_im
		);

reg [7:0]r_D_re = 8'h00;


wire [7:0] w_twid_re;
wire [7:0] w_twid_im;

wire [7:0] w_neg_b_re;
wire [7:0] w_neg_b_im;

wire [8:0] w_d_re;
wire [8:0] w_d_im;
wire [8:0] w_e_re;
wire [8:0] w_e_im;

twiddle_mult twid_mult_test
(
	.clk(clk),
	.start(start_calc),
	.i_x(w_d_re[8:1]),
	.i_y(w_d_im[8:1]),
	.i_c(i_C),
	.i_c_plus_s(C_plus_S),
	.i_c_minus_s(C_minus_S),
	.o_Re_out(E_re),
	.o_Im_out(E_im),
	.data_valid(data_valid)
	);

N_bit_adder 
#(.N(9))
adder_D_re
(
	.input1({A_re[7],A_re[7:0]}),
	.input2({B_re[7],B_re[7:0]}),
	.answer(w_d_re)
	);

N_bit_adder 
#(.N(9))
adder_D_im
(
	.input1({A_im[7],A_im[7:0]}),
	.input2({B_im[7],B_im[7:0]}),
	.answer(w_d_im)
	);

N_bit_adder #(.N(9))
adder_E_im
(
	.input1({A_im[7],A_im[7:0]}),
	.input2({w_neg_b_im[7], w_neg_b_im[7:0]}),
	.answer(w_e_im)
	);

N_bit_adder #(.N(9))
adder_E_re
(
	.input1({A_re[7],A_re[7:0]}),
	.input2({w_neg_b_re[7], w_neg_b_re[7:0]}),
	.answer(w_e_re)
	);

pos_2_neg #(.N(8))
neg_b_re
(
	.pos(B_re),
	.neg(w_neg_b_re)
	);

pos_2_neg #(.N(8))
neg_b_im
(
	.pos(B_im),
	.neg(w_neg_b_im)
	);

assign D_im[7:0] = w_d_im[8:1];
assign D_re[7:0] = w_d_re[8:1];


endmodule // bfprocessor