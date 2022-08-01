module demux #(parameter MSB=16,
	N=16)
(
	input wire [$clog2(N)-1:0]sel,
	output reg [N*MSB-1:0]data_out,
	input [MSB-1:0]data_in
	);

integer i;
inital begin
	data_out = 0;
end

reg [MSB-1:0] tmp;
always @(*)
begin
	for(i=0;i<MSB;i=i+1)
	 	data_out[i+sel*MSB] = data_in[i];
end
endmodule // mux