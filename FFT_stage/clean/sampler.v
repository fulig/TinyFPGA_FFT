module sampler
	#(parameter COUNT_TO=4*4*382, //10
		parameter N=16)
	(
	input clk,
	input start,
	output reg imag,
	output reg sample,
	output reg run,
	output [$clog2(N)-1:0]addr
	);

reg [$clog2(COUNT_TO):0] count = 0;
reg [$clog2(N)-1:0] count_puls = 0;

initial begin
	count <= 1'b0;
	count_puls <= 1'b0;
	run <= 1'b0;
end
always @(posedge clk)
begin 
	if(start)
		begin
			run <= 1'b1;
			sample <= 1'b1;
			count_puls <= 0;
			count <= 0;
			imag <= 0;
		end
	if(run)
	begin
	if(count == COUNT_TO)
	begin
		sample <= 1'b1;
		imag <= ~imag;
		count <= 0;
		if(imag == 1)count_puls <= count_puls + 1'b1;
	end
	else
	begin
		if(count_puls == N-1 & count == COUNT_TO-1 & imag == 1)
		begin 
			count_puls <= 0;

			run <= 1'b0;
		end
		sample <= 1'b0;
		count <= count + 1'b1;
	end
end
end
assign addr = count_puls;


endmodule // sampler