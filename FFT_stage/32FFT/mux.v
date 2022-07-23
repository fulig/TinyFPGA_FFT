module mux #(parameter MSB=16,
	N=16)
(
	input wire [$clog2(N)-1:0]sel,
	input wire [N*MSB-1:0]data_bus,
	output reg [MSB-1:0]data_out
	);

integer i;

reg [MSB-1:0] tmp;
always @(*)
begin
	for(i=0;i<MSB;i=i+1)data_out[i] = data_bus[i+sel*MSB];
end
endmodule // mux