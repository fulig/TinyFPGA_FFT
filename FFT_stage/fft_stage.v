module fft_stage #(parameter N=16,
	parameter MSB_IN=16,
	parameter MSB = 8 )
(
	input clk,
	input start_calc,
	input [N*MSB_IN-1:0] input_regs,
	input [N/2*8-1:0] c_regs,
	input [N/2*9-1:0] cps_regs,
	input [N/2*9-1:0] cms_regs,
	output [N*MSB_IN-1:0]	output_data,
	output data_valid 
	);

wire [N/2-1:0] w_dv;

genvar i;

generate
	for(i=0;i<N/2;i=i+1)
	begin :bfs
		bfprocessor butterfly
		(
			.clk(clk),
			.A_re(input_regs[i*MSB_IN+MSB-1:i*MSB_IN]),
			.A_im(input_regs[i*MSB_IN+MSB_IN-1:i*MSB_IN+MSB]),
			.B_re(input_regs[i*MSB_IN+MSB-1+N/2*MSB_IN:i*MSB_IN+N/2*MSB_IN]),
			.B_im(input_regs[i*MSB_IN+MSB_IN-1+N/2*MSB_IN:i*MSB_IN+MSB+N/2*MSB_IN]),
			.i_C(c_regs[(i+1)*MSB-1:i*MSB]),
			.C_plus_S(cps_regs[(i+1)*(MSB+1)-1:i*(MSB+1)]), 
			.C_minus_S(cms_regs[(i+1)*(MSB+1)-1:i*(MSB+1)]), 
			.data_valid(w_dv[i]),
			.start_calc(start_calc),
			.D_re(output_data[i*MSB_IN+MSB-1:i*MSB_IN]),
			.D_im(output_data[i*MSB_IN+MSB_IN-1:i*MSB_IN+MSB]),
			.E_re(output_data[i*MSB_IN+MSB-1+N/2*MSB_IN:i*MSB_IN+N/2*MSB_IN]),
			.E_im(output_data[i*MSB_IN+MSB_IN-1+N/2*MSB_IN:i*MSB_IN+MSB+N/2*MSB_IN])
			);
	end
endgenerate

assign data_valid = w_dv[0];

endmodule // fft_stage