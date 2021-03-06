module shift_reg #(parameter MSB = 16)
	(
		input d, 
		input clk,
		input en,
		input rst,
		output reg [MSB-1:0] out
		);

always @(posedge clk)
begin
	if (~en)
		out <= {out[MSB-2:0], d};
	else
		out <= out;
end
endmodule // shift_reg