module fft_reg_stage #(parameter N=16,
	parameter MSB=16)
(
	input clk,
	input fill_regs,
	input start_calc,
	input [MSB-1:0] data_in,
	input [$clog2(N)-1:0] addr_counter,
	input [$clog2(N/4)-1:0]stage,
	output [N*MSB-1:0]fft_data_out,
	output calc_finish
	);

wire w_dv_mapper;
wire w_we_c_map;
wire [MSB-1:0]w_c_in;
wire [MSB-1:0]w_cps_in;
wire [MSB-1:0]w_cms_in;
wire [$clog2(N/2)-1:0] w_c_map_addr;

wire [N/2*8-1:0]w_c_reg;
wire [N/2*9-1:0]w_cps_reg;
wire [N/2*9-1:0]w_cms_reg;

fft_stage #(.N(N))
 test_fft_stage
(
	.clk(clk),
	.start_calc(start_calc),
	.input_regs(w_input_regs),
	.c_regs(w_c_reg),
	.cps_regs(w_cps_reg),
	.cms_regs(w_cms_reg),
	.output_data(fft_data_out),
	.data_valid(calc_finish)
	);


c_rom_bank #(.N(N)) c_data
(
	.clk(clk),
	.we(w_we_c_map),
	.c_in(w_c_in[MSB/2-1:0]),
	.cps_in (w_cps_in[MSB/2:0]),
	.cms_in(w_cms_in[MSB/2:0]),
	.addr(w_c_map_addr),
	.c_out(w_c_reg),
	.cps_out(w_cps_reg),
	.cms_out(w_cms_reg)
	);


c_mapper #(.N(N)) c_map
(
	.clk(clk),
	.start(fill_regs),
	.stage(stage),
	.data_valid(w_dv_mapper),
	.we(w_we_c_map),
	.c_out(w_c_in),
	.cps_out(w_cps_in),
	.cms_out(w_cms_in),
	.addr_out(w_c_map_addr)
	);

wire [N*MSB-1:0]  w_input_regs;

reg_array #(.N(N)) input_regs
(
	.clk(clk),
	.we(1'b1),
	.addr(w_index_out),
	.data(data_in),
	.data_out(w_input_regs)
	);
wire [$clog2(N)-1:0]w_index_out;

index_mapper #(.MSB($clog2(N)))
idx_map 
(
	.index_in(addr_counter),
	.stage(stage),
	.index_out(w_index_out)
	);

endmodule // fft_reg_stage