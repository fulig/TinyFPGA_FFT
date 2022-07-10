module c_reg #(parameter MSB=16)
	(
		input clk,
		input we,
		input [MSB-1:0] i_C,
		input [MSB-1:0] i_CpS,
		input [MSB-1:0] i_CmS,
		output [MSB-1:0] o_C,
		output [MSB-1:0] o_CpS,
		output [MSB-1:0] o_CmS
		);

reg [MSB-1:0] cosinus = 0;
reg [MSB-1:0] cos_plus_sin = 0;
reg [MSB-1:0] cos_minus_sin = 0;

always @(posedge clk)
begin
	if(we)
	begin
		cosinus <= i_C;
		cos_plus_sin <= i_CpS;
		cos_minus_sin <= i_CmS;
	end
end

assign o_C = cosinus;
assign o_CpS = cos_plus_sin;
assign o_CmS = cos_minus_sin;

endmodule // c_regs