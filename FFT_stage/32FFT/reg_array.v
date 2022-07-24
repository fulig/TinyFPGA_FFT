module reg_array #(parameter N=16, parameter MSB=16)
	(
      	input clk,
		input [$clog2(N)-1:0] addr,
		input [MSB-1:0] data,
      	output [N*MSB-1:0]  data_out 
	);

reg [MSB-1:0] regs [N-1:0];

genvar i;

always @(negedge clk)
begin
	regs[addr] <= data;
end

generate
	for(i=0;i<N;i=i+1)
	begin
	assign data_out[(i+1)*MSB-1:MSB*i] = regs[i];
	end
endgenerate





endmodule // input_regs