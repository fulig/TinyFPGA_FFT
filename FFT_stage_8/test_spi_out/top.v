module top #(parameter N=8)
    (
    input CLK,    // 16MHz clock
    input PIN_9,  //  DATA_IN from ADC
    output PIN_2,   // SCLK
    output PIN_7,   // CS,
    output PIN_1, // DV
    output PIN_14, //SCLK_arduino
    output PIN_15, //MOSI_arduino
    output PIN_16 // CS_arduino
);

fft_spi_out #(.N(N))
spi_out 
(
	.clk(CLK),
	.data_bus(data_bus),
	.start_spi(start),
	.sclk(PIN_14),
	.mosi(PIN_15),
	.cs(PIN_16)
	);
reg [10:0] count = 0;
reg start = 0;
reg [16*8-1:0] data_bus = 128'h0807060504030201;


always @(posedge CLK)
begin
count <= count + 1'b1;
if(count == 1)start <= 1'b1;
else start <= 1'b0;
end

endmodule // top