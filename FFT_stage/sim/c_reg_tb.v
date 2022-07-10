`define DUMPSTR(x) `"x.vcd`"
`timescale 100 ns / 10 ns

module tb_reg_stage;

parameter DURATION = 1000;

reg [7:0] count;

reg [3:0]addr_count= 0;

wire [3:0] w_addr_count;
assign w_addr_count = addr_count;
reg clk;
reg start = 1'b0;
reg start_calc=1'b0;
reg run = 1'b0;
reg sel_in = 1'b0;

wire [15:0] w_rom_data;
wire [15:0] w_mux_out;
wire [15:0] w_fft_in;
wire [16*16-1:0] fft_out;

fft_reg_stage reg_stage(
	.clk(clk),
	.fill_regs(start),
	.start_calc(start_calc),
	.we_regs(1'b1),
	.data_in(w_fft_in),
	.addr_counter(w_addr_count),
	.data_out(fft_out),
	.stage(2'b00)
	);

mux mux_0
(
	.sel(w_addr_count),
	.data_bus(fft_out),
	.data_out(w_mux_out)
	);

mux #(.N(2))
mux_1 
(
	.sel(sel_in),
	.data_bus({w_mux_out,w_rom_data}),
	.data_out(w_fft_in)
	);

ROM_sinus sinus
(
	.out(w_rom_data),
	.addr(w_addr_count)
	);

always #1 clk <= ~clk;



initial begin
	clk <= 1;
	count <= 0;
	start_calc <= 0;


$dumpfile(`DUMPSTR(`VCD_OUTPUT));
  $dumpvars(0, tb_reg_stage);

   #(DURATION) $display("End of simulation");
  $finish;

end

always @ (posedge clk)
begin
	count <= count + 1'b1;
	if(count == 4) 
	begin
		start <= 1'b1;
		run <= 1'b1;
	end
	else start <= 1'b0;
	if(run)addr_count <= addr_count + 1'b1;
	else addr_count <= 0;
	if(addr_count==15)
	begin
		run <= 1'b0;
		start_calc<=1'b1;
	end
	else start_calc <= 1'b0;
end

endmodule // tb_adder