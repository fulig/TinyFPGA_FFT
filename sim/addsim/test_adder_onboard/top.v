module top(
	input CLK,
	output PIN_24,
	output PIN_23,
	output PIN_22,
	output PIN_21,
	output PIN_20,
	output PIN_19,
	output PIN_18,
	output PIN_17
	);

wire [7:0] w_data_0 ;
wire [7:0] w_data_1 ;
wire [7:0] w_out;


reg [7:0]r_data_0 = 8'b00110101;
reg [7:0]r_data_1 = 8'b01010011;
reg [7:0]r_out;

N_bit_adder BitAdder(
	.input1(w_data_0[7:0]),
	.input2(w_data_1[7:0]),
	.answer(w_out[7:0]),
	);


always @(posedge CLK)
begin
	r_data_0 <= ~r_data_0;
end


assign w_data_0[7:0] = r_data_0;
assign w_data_1[7:0] = r_data_1;
assign w_out[7:0] = r_out;

assign PIN_24 = w_out[7];
assign PIN_23 = w_out[6];
assign PIN_22 = w_out[5];
assign PIN_21 = w_out[4];
assign PIN_20 = w_out[3];
assign PIN_19 = w_out[2];
assign PIN_18 = w_out[1];
assign PIN_17 = w_out[0];

endmodule