
module multiplier_8_9Bit
	#(parameter N=8, 
	  parameter M=9	)
	(
		input clk,
		input start,
		input [7:0] in_0,
		input [8:0] in_1,
		output reg data_valid,
		output reg [16:0] out
		);

reg [4:0]count = 5'h00;
reg [16:0] p;
reg [16:0] t;
reg [16:0] input_0_exp;
wire [16:0] w_p;
wire [16:0] w_t;
wire [16:0] w_o;

N_bit_adder 
#(.N(17)) Bit_adder
(	.input1(w_p[16:0]),
	.input2(w_t[16:0]),
	.answer(w_o)
	);


initial begin
	data_valid <= 1'b0;
	count <= 0;
	state <= INIT;
	p[16:0] <= 17'h00000;
	t [16:0] <= 17'h00000;
end

reg o_busy = 0;

always @ (posedge clk)
begin
	if(!o_busy)
		begin
				input_0_exp[16:0] <= {in_0[7], in_0[7], in_0[7], in_0[7],in_0[7], in_0[7],in_0[7],in_0[7],in_0[7], in_0[7:0]};
				t[16:0] <= {in_1[8],in_1[8],in_1[8],in_1[8],in_1[8],in_1[8],in_1[8],in_1[8],in_1[8:0]};
				count <= 5'h00;
				p[16:0] <= 17'h00000;
				data_valid <= 1'b0;
				o_busy <= start;
		end

	else begin
			if (count == 5'h10)
			begin
				out <= p;
				data_valid <= 1'b1;
			end
			else if (input_0_exp[count] == 1'b1)
			begin
				p[16:0] <= w_o[16:0];
			end
			t <= t * 2;
			o_busy <= (count < 5'h10);
			count <= count + 1'b1;
		end

end

assign w_p[16:0] = p[16:0];
assign w_t[16:0] = t[16:0];

endmodule // N_bit_multiplier

