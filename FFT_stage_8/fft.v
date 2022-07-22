module fft #(parameter N=16,
	parameter MSB=16)
(
	input clk,
	input [MSB-1:0] data_in,
	input [$clog2(N)-1:0] addr,
	input insert_data, // 1 => addr for input, 0 => addr for output
	output [MSB*N-1:0] data_out,
	output reg fft_finish
);

wire [MSB-1:0] w_rom_data;
wire [MSB-1:0] w_mux_out;
wire [MSB-1:0] w_fft_in;
wire [MSB*N-1:0] w_fft_out;
wire w_calc_finish; 
wire [$clog2(N)-1:0]w_addr;
//wire [MSB*N-1:0] w_output_reg;

reg fill_regs = 1'b0;
reg start_calc =1'b0;
reg we_regs = 1'b0;
reg [$clog2(N/2)-1:0]stage = 0;
reg [$clog2(N)-1:0]counter_N = 0;
reg [N*MSB-1:0] output_reg = 0;

fft_reg_stage #(.N(N)) reg_stage 
(
	.clk(clk),
	.fill_regs(fill_regs), //get values for c, cps and cms.
	.start_calc(start_calc),
	.we_regs(we_regs),
	.data_in(w_fft_in),
	.addr_counter(w_addr[$clog2(N)-1:0]),
	.stage(stage),
	.fft_data_out(w_fft_out),
	.calc_finish(w_calc_finish)
	);

mux #(.N(N)) mux_fft_out 
(
	.sel(counter_N),
	.data_bus(w_fft_out),
	.data_out(w_mux_out)
	);

reg sel_in = 1'b0;

mux #(.N(2)) mux_data_in 
(
	.sel(sel_in),
	.data_bus({w_mux_out,data_in}),
	.data_out(w_fft_in)
	);

mux #(.N(2), .MSB($clog2(N))) mux_addr_sel 
(
	.sel(insert_data),
	.data_bus({addr,counter_N}),
	.data_out(w_addr)
	);


localparam IDLE = 2'b00;
localparam DATA_IN = 2'b01;
localparam CALC_FFT = 2'b10;
localparam DATA_OUT = 2'b11;

reg [1:0] state = IDLE;

always @(posedge clk) 
begin
case (state)
	IDLE:
	begin
		if(insert_data)
			begin
				we_regs <= 1'b1;
				fill_regs <= 1'b1;
				counter_N <= 0;
				state <= DATA_IN;
			end
		else
		begin
			fft_finish <= 1'b0;
			stage <= 0;
			counter_N <= 0;
			sel_in <= 0;
		end
	end
	DATA_IN : 
	begin
		if(addr == N-1 | counter_N == N-1)
		begin
			start_calc <= 1'b1;
			state <= CALC_FFT;
		end
		else
		begin
			fill_regs <= 1'b0;
			if(~insert_data)counter_N <= counter_N + 1'b1;
		end
	end
	CALC_FFT:
	begin
		if(w_calc_finish)
		begin
			if(stage==$clog2(N/2))
			begin
				fft_finish <= 1'b1;
				//data_out <= w_fft_out;
				state <= IDLE;
			end
			else begin
				sel_in <= 1'b1;
				stage <= stage + 1'b1;
				counter_N <= 0;
				fill_regs <= 1'b1;
				state <= DATA_IN;
			end
		end
		else
		begin
			
			start_calc <= 1'b0;
		end
	end
endcase
end


assign data_out = w_fft_out;

endmodule // fft