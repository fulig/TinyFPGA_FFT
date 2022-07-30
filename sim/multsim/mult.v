module multiplier_8_9Bit
(
	input clk, 
	input start,
	input [7:0] in_0, 
	input [8:0] in_1,
	output reg [16:0] out,
	output reg data_valid
	);

reg o_busy = 0;
reg [16:0] t = 0;
reg [16:0] p = 0;
reg [16:0] in_0_exp;
reg [$clog2(16)-1:0]count = 0;

wire [16:0] w_o;


N_bit_adder #(.N(17)) adder
(
	.input1(p),
	.input2(t),
	.answer(w_o)
	);

always @(posedge clk)
begin
	if(!o_busy)
	begin
		count <= 0;
		in_0_exp <= {in_0[7], in_0[7], in_0[7], in_0[7],in_0[7], in_0[7],in_0[7],in_0[7],in_0[7], in_0[7:0]};
		t <= {in_1[8],in_1[8],in_1[8],in_1[8],in_1[8],in_1[8],in_1[8],in_1[8],in_1[8:0]};
		p <= 0;
		o_busy <= start;
	end
	else
	begin
		if(in_0[count] == 1'b1)p[15:0] <= w_o[15:0];
		t <= t * 2;
		o_busy <= (count < 16);
		count <= count + 1'b1;
	end
end


always @(posedge clk)
begin
	data_valid <= (count == 16);
	out <= p;
end

endmodule // multiplier