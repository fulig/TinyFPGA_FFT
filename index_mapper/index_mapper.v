module index_mapper #(parameter MSB = 8)
	(
		input [MSB-1:0] index_in,
		input [MSB/2 - 1:0] stage,
		output [MSB-1:0]  index_out
		);

integer i;
reg [MSB-1:0] tmp;
reg [MSB-1:0] in;

always @(*)
begin
	//tmp <= index_in;
	/*for(i=0;i<stage;i=i+1)
	begin
		tmp[i+MSB-stage] <= index_in[MSB-1-i];
	end*/
	for(i=0;i<MSB;i=i+1)
	begin
		if(i>=MSB-stage)
		begin
			tmp[i] <= index_in[MSB-1-stage+(MSB-i)];
		end
		else if(i<MSB-stage)
		begin
			tmp[i] <= index_in[i];
		end
	end
end
assign index_out = tmp;
endmodule // index_mapper