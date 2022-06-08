module SAMPLER
	#(parameter COUNT_TO=382)
	(
	input clk,
	output reg sample
	);

reg [$clog2(COUNT_TO):0] count = 0;

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