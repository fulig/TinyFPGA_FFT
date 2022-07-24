module twiddle_mult
(
	input clk,
	input start,
	input [7:0]i_x,
	input [7:0]i_y,
	input [7:0]i_c,
	input [8:0]i_c_plus_s,
	input [8:0]i_c_minus_s,
	output reg [7:0]o_Re_out,
	output reg [7:0]o_Im_out,
	output reg data_valid
	);

wire [8:0] w_add_answer;
wire [16:0] w_z;
wire [16:0] w_mult;
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
	.input2(w_neg_y),
	.answer(w_add_answer)
	);

N_bit_adder
#(.N(8))
adder_R
(
	.input1(w_mult[14:7]),
	.input2(w_z[14:7]),
	.answer(w_r_out)
	);

N_bit_adder
#(.N(8))
adder_I
(
	.input1(w_mult[14:7]),
	.input2(w_neg_z[14:7]),
	.answer(w_i_out)
	);
reg [1:0] sel=0;
reg [16:0] reg_z = 0;
wire [7:0] w_8Bit_mux;
wire [8:0] w_9Bit_mux;

mux #(.N(2), .MSB(8)) mux_8bit
(
	.sel(sel[1]|sel[0]),
	.data_bus({i_y,i_c}),
	.data_out(w_8Bit_mux)
	);

mux #(.N(3), .MSB(9)) mux_9bit
(
	.sel(sel),
	.data_bus({ i_c_plus_s, i_c_minus_s, w_add_answer}),
	.data_out(w_9Bit_mux)
	);

reg start_mult = 1'b0;

multiplier_8_9Bit multplier
(
	.clk(clk),
	.start(start_mult),
	.input_0(w_8Bit_mux),
	.input_1(w_9Bit_mux),
	.data_valid(w_mult_dv),
	.out(w_mult)
	);
/*
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
*/
pos_2_neg #(.N(9))
y_neg
(
	.pos({i_y[7],i_y[7:0]}),
	.neg(w_neg_y)
	);

pos_2_neg #(.N(17))
z_neg
(
	.pos(w_z),
	.neg(w_neg_z)
	);

assign w_z = reg_z;
//assign data_valid = w_mult_dv;
//assign o_Re_out[7:0] = w_r_out;
//assign o_Im_out[7:0] = w_i_out;
localparam IDLE = 2'b00;
localparam CALC_Z = 2'b01;
localparam CALC_R = 2'b10;
localparam CALC_I = 2'b11;

reg [1:0] state = IDLE;

always @(posedge clk)
begin
	case (state)
	IDLE:
	begin
		if(start)
		begin
			start_mult <= 1'b1;
			state = CALC_Z;
		end
		else
		begin
			start_mult <= 1'b0;
			sel <= 1'b0;
			data_valid <= 1'b0;
		end
	end
	CALC_Z:
	begin
		if(w_mult_dv)
		begin
			reg_z <= w_mult;
			sel <= sel + 1'b1;
			start_mult <= 1'b1;
			state <= CALC_R;
		end
		else
			begin
				start_mult <= 1'b0;
			end
	end
	CALC_R :
	begin
		if(w_mult_dv)
		begin
			o_Re_out <= w_r_out;
			sel <= sel + 1'b1;
			start_mult <= 1'b1;
			state <= CALC_I;
		end
		else
			begin
				start_mult <= 1'b0;
			end
	end
	CALC_I :
	begin
		if(w_mult_dv)
		begin
			o_Im_out <= w_i_out;
			data_valid <= 1'b1;
			state <= IDLE;
		end
		else
			begin
				start_mult <= 1'b0;
			end
	end
	endcase
end

endmodule // twiddle_mult