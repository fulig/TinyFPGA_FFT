module twiddle_mult
(
	input clk,
	input start,
	input [7:0]i_x,
	input [7:0]i_y,
	input [7:0]i_c,
	input [7:0]i_c_plus_s,
	input [7:0]i_c_minus_s,
	output [7:0]o_Re_out,
	output [7:0]o_Im_out,
	output reg data_valid
	);

localparam IDLE = 2'b00;
localparam CALC_E = 2'b01;
localparam CALC_Z = 2'b10;
localparam CALC_R = 2'b11;


reg start_mult;
reg [1:0]state = IDLE;
reg [15:0]reg_z;
reg [7:0]reg_e;
reg [7:0]add_1;
reg [7:0]add_2;
reg [7:0]add_answer;
reg [7:0]mult_1;
reg [7:0]mult_2;
reg [15:0]mult_answer;


wire [7:0] w_add_answer;
wire [15:0] w_mult_z;
wire [15:0] w_mult_r;
wire [15:0] w_mult_i;

wire [15:0] w_r_out;
wire [15:0] w_i_out;
wire [7:0] w_neg_y;

wire w_start_mult;
wire w_mult_dv;

N_bit_adder
#(.N(8))
adder_1(
	.input1(i_x),
	.input2(w_neg_y),
	.answer(w_add_answer)
	);

N_bit_adder
#(.N(16))
adder_R
(
	.input1(w_mult_r[15:0]),
	.input2(w_mult_z[15:0]),
	.answer(w_r_out)
	);

N_bit_adder
#(.N(16))
adder_I
(
	.input1(w_mult_i),
	.input2(w_mult_z),
	.answer(w_i_out)
	);


multiplier_8Bit multiplier_R
(
	.clk(clk),
	.start(start),
	.input_0(i_c_minus_s[7:0]),
	.input_1(i_y[7:0]),
	.out(w_mult_r[15:0])
	);

multiplier_8Bit multiplier_I
(
	.clk(clk),
	.start(start),
	.input_0(i_c_plus_s[7:0]),
	.input_1(i_x[7:0]),
	.out(w_mult_i[15:0])
	);


multiplier_8Bit multiplier_Z
(
	.clk(clk),
	.start(start),
	.input_0(i_c[7:0]),
	.input_1(w_add_answer[7:0]),
	.data_valid(w_mult_dv),
	.out(w_mult_z[15:0])
	);
pos_2_neg #(.N(8))
y_neg
(
	.pos(i_y),
	.neg(w_neg_y)
	);


always @ (posedge clk)
begin
case (state)
	IDLE:
	begin
		if(w_mult_dv)
		begin
			state <= IDLE;
		end
	end
endcase // state
end

//assign w_add_1[7:0] = add_1[7:0];
//assign w_add_2[7:0] = add_2[7:0];
//assign w_add_answer[7:0] = add_answer[7:0];
//assign w_start_mult = start_mult;
//assign w_mult_1[7:0] = i_c[7:0];
//assign w_mult_2[7:0] = w_add_answer[7:0];
//assign w_mult_answer[15:0] = reg_z[15:0];
endmodule // twiddle_mult