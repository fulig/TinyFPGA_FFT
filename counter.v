module COUNTER(
	input clk,
	input reset,
	input count_up,
	output reg [7:0] out
	);

always @(posedge clk)
if(count_up)
	begin
	out <= out + 1'b1;
	end
endmodule // counter