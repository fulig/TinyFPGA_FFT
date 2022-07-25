module c_rom_bank #(parameter N=16,
	 parameter MSB=8)
	(
		input clk,
		input we, 
		input [MSB-1:0] c_in,
		input [MSB:0] cps_in,
		input [MSB:0] cms_in,
		input [$clog2(N/2)-1:0] addr,
		output [N/2*8-1:0] c_out,
		output [N/2*9-1:0] cps_out,
		output [N/2*9-1:0] cms_out
		);

reg [MSB-1:0] cosinus  [N/2-1:0];
reg [MSB:0] cos_plus_sin [N/2-1:0];
reg [MSB:0] cos_minus_sin [N/2-1:0];


genvar i;

always @(negedge clk)
begin
if(we)
begin
	cosinus[addr] <= c_in;
	cos_plus_sin[addr] <= cps_in;
	cos_minus_sin[addr] <= cms_in;
end
end
generate
	for(i=1;i<N/2;i=i+1)
	begin
	assign c_out[(i+1)*MSB-1:MSB*i] = cosinus[i];
	assign cps_out[(i+1)*(MSB+1)-1:(MSB+1)*i] = cos_plus_sin[i];
	assign cms_out[(i+1)*(MSB+1)-1:(MSB+1)*i] = cos_minus_sin[i];
	end
endgenerate

assign c_out[7:0] = 8'h7f;
assign cps_out[8:0] = 9'h07f;
assign cms_out[8:0] = 9'h07f;

endmodule // c_rom_bank