module COUNTER(
	input clk,
	input reset,
	input count_up,
	output [7:0] out
	);

reg r_out = 8'b0000000;
always @(posedge clk)
if(count_up)
	begin
	r_out <= r_out +1;
	end
assign out = r_out;
endmodule // counter