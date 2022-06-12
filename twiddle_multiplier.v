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

localparam IDLE = 2'b00;
localparam CALC_E = 2'b01;
localparam CALC_Z = 2'b10;
localparam CALC_R = 2'b11;

reg [1:0]state = IDLE;
reg [7:0]add_1;
reg [7:0]add_2;
reg [8:0]add_answer;
reg carry;

wire [7:0] w_add_1;
wire [7:0] w_add_2;
wire [7:0] w_add_answer;
wire carry;

N_bit_adder
#(.N(8))
adder(
	.input1(w_add_1),
	.input2(w_add_2),
	.answer()
	);



always @ (posedge clk)
begin

end

assign w_add_1[7:0] = add_1[7:0];
assign w_add_2[7:0] = add_2[7:0];
assign w_add_answer[7:0] = add_answer[7:0];
assign carry = add_answer[8];


endmodule // twiddle_mult