module multiplier
(
	input clk, 
	input start,
	input [7:0] in_0, in_1,
	output reg [15:0] out,
	output reg data_valid
	);

reg o_busy = 0;
reg [15:0] t = 0;
reg [15:0] p = 0;
reg [$clog2(16)-1:0]count = 0;

wire [15:0] w_o;


N_bit_adder #(.N(16)) adder
(
	.input1(t),
	.input2(p),
	.answer(w_o)
	);

always @(posedge clk)
begin
	if(!o_busy)
	begin
		count <= 0;
		t <= in_1;
		p <= 0;
		o_busy <= start;
	end
	else
	begin
		if(in_0[count] == 1'b1)p[15:0] <= w_o[15:0];
		t <= t * 2;
		o_busy <= (count < 7);
		count <= count + 1'b1;
	end
end


always @(posedge clk)
begin
	data_valid <= (count == 7);
	out <= p;
end

endmodule // multiplier