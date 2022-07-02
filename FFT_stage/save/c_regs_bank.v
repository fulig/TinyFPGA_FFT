module c_rom_bank #(parameter N=16,
	 parameter MSB=16)
	(
		input clk,
		input we, 
		input [1:0] count,
		input [N/2-1:0] bf_id,
		input [MSB-1:0] data,
		output [N/2-1:0] [MSB-1:0] o_C,
		output [N/2-1:0] [MSB-1:0] o_CpS,
		output [N/2-1:0] [MSB-1:0] o_CmS
		);

reg [N/2-1:0] [MSB-1:0] cosinus = 0;
reg [N/2-1:0] [MSB-1:0] cos_plus_sin = 0;
reg [N/2-1:0] [MSB-1:0] cos_minus_sin = 0;

always @(posedge clk)
begin
if(we)
begin
	case(count)
		0: cosinus[bf_id] <= data;
		1: cos_plus_sin[bf_id] <= data;
		2: cos_minus_sin[bf_id] <= data;
	endcase // count
end
end

assign o_C = cosinus;
assign o_CpS = cos_plus_sin;
assign o_CmS = cos_minus_sin;

endmodule // c_rom_bank