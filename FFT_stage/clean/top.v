// look in pins.pcf for all the pin names on the TinyFPGA BX board
module top
    (
    input CLK,    // 16MHz clock
    input PIN_9,  //  DATA_IN from ADC
    output PIN_2,   // SCLK
    output PIN_7,   // CS,
    output PIN_1, // DV
    output PIN_14, //SCLK_arduino
    output PIN_15, //MOSI_arduino
    output PIN_16, // CS_arduino
    output PIN_21 //DV test
);


wire w_sample;
wire [3:0] w_addr;
wire start_spi_in;
reg [15:0] count = 0;
wire w_start_spi;

wire [7:0] w_data_in;
wire [15:0] w_data_in_fft;

wire [255:0] w_spi_data;
wire w_insert_data;
wire w_imag;

fft fft_module
(
    .clk(CLK),
    .insert_data(w_insert_data),
    .data_in(w_data_in_fft),
    .addr(w_addr),
    .fft_finish(w_start_spi),
    .data_out(w_spi_data)
    );


fft_spi_out spi_out
(
    .clk(CLK),
    .data_bus(w_spi_data),
    .start_spi(w_start_spi),
    .sclk(PIN_14),
    .mosi(PIN_15),
    .cs(PIN_16)
    );

sampler sampler_tb(
.clk(CLK),
.start(start_spi_in),
.imag(w_imag),
.sample(w_sample),
.addr(w_addr),
.run(w_insert_data)
    );


ADC_SPI adc_spi
(
.clk(CLK),
.sample(w_sample),
.data_in(PIN_9),
.DATA_OUT(w_data_in),
.CS(PIN_7),
.SCLK(PIN_2)
    );
/*
ROM_sinus sinus
(
    .out(w_data_in),
    .addr(w_addr)
);*/

reg [17:0]cnt = 0;
reg  start_all = 0;

initial begin 
cnt = 0;
start_all = 0;
end


always @(posedge CLK)
begin
cnt = cnt + 1'b1;
if (cnt == 1)start_all <= 1'b1;
else start_all <= 1'b0;
end
//start puls und dann als eingang für

assign w_data_in_fft = w_data_in << 8*w_imag;
assign PIN_21 = start_spi_in;
assign start_spi_in = start_all;
endmodule // top