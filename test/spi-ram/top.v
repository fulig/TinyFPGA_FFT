module top
	(
		input CLK,
		output PIN_14, //SCLK
		output PIN_15, //MOSI
		output PIN_16 //CS
		);

reg [7:0] end_addr = 8'h40;
wire sample;

SAMPLER #(.COUNT_TO(1000))
start_tx
(
	.clk(CLK),
	.sample(sample)
	);


spi_ram test_ram
(
	.clk(CLK),
	.end_addr(end_addr),
	.start(sample),
	.mosi(PIN_15),
	.sclk(PIN_14),
	.cs(PIN_16)
	);

endmodule // top