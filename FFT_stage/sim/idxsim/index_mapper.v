module index_mapper #(parameter MSB = 8, parameter N = 8)
	(
		input [MSB-1:0] index_in,
		input [$clog2(MSB)-1:0] stage,
		output [MSB-1:0]  index_out
		);

integer i;
reg [MSB-1:0] tmp;
reg [$clog2(MSB)-1:0]stage_plus; 

always @(*)
begin
	stage_plus <= stage +1'b1;
	if (stage <= MSB/2)
	begin
		for(i=0;i<MSB;i=i+1)
		begin
			if(i>=MSB-stage_plus)
			begin
				tmp[i] <= index_in[MSB-1-stage_plus+(MSB-i)];
			end
			else if(i<MSB-stage_plus)
			begin
				tmp[i] <= index_in[i];
			end
		end
	end
	else
		begin
			tmp[MSB-1:1] <= index_in[MSB-1:1];
			tmp[0] <= index_in[MSB-1];
			tmp[MSB-1] <= index_in[0];
		end
end
assign index_out = tmp;
endmodule // index_mapper