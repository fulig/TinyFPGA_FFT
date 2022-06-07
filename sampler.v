module SAMPLER
	#(parameter COUNT_TO=382)
	(
	input clk,
	output reg sample
	);

reg [8:0] count = 9'b000000000;

initial begin
	count <= 1'b0;
end
always @(posedge clk)
begin 
	count <= count + 1'b1;
	if(count == COUNT_TO)
	begin
		sample <= 1'b1;
		count <= 0;
	end
	else
	begin
		sample <= 1'b0;
	end
end

endmodule // sampler