module input_regs #(parameter N=16, parameter MSB=16)
	(
      input clk,
		input we,
		input [$clog2(N)-1:0] addr,
		input [MSB-1:0] data,
      output [N-1:0] [MSB-1:0]  data_out 
		);

reg [N-1:0] [MSB-1:0]  data_regs = 0;

always @(posedge clk)
begin
   if(we)
   begin
      data_regs[addr]  <= data;
   end
end
assign data_out = data_regs;

endmodule // input_regs