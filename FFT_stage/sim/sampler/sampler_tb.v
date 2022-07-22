`define DUMPSTR(x) `"x.vcd`"
`timescale 100 ns / 10 ns

module tb_c_mapper;

parameter DURATION = 100000;

reg [12:0] count = 0;
reg start = 1'b0;
reg [1:0] stage = 0;

reg clk;
wire [3:0] w_addr;
wire [15:0] data;

sampler sampler_tb(
.clk(clk),
.start(start),
.sample(w_sample),
.addr(w_addr)
	);
wire w_sample;
wire w_dv;

ADC_SPI adc_spi
(
.clk(clk),
.sample(w_sample),
.DV(w_dv),
.data_in(data[0])
	);

ROM_sinus sinus(
	.addr(w_addr),
	.out(data)
	);

always #1 clk <= ~clk;


initial begin
	clk <= 0;
	start <= 0;
$dumpfile(`DUMPSTR(`VCD_OUTPUT));
  $dumpvars(0, tb_c_mapper);

   #(DURATION) $display("End of simulation");
  $finish;

end

always @ (posedge clk)
begin
	count <= count + 1'b1;
	if(count==1)start <= 1'b1;
	else start <= 1'b0;
end


endmodule // tb_c_mapper