// look in pins.pcf for all the pin names on the TinyFPGA BX board
module top
    (
    input CLK,    // 16MHz clock
    input PIN_9,  //  DATA_IN from ADC
    output PIN_2,   // SCLK
    output PIN_7   // CS
);

reg [7:0] data_test;
wire data_valid;
wire [15:0]adc_data;
wire [15:0]test_out;

ADC_SPI adc_spi 
    (
        .CLOCK(CLK),
        .CS(PIN_7),
        .SCLK(PIN_2),
        .DATA_IN(PIN_9),
        .DV(data_valid),
        .DATA_OUT(adc_data[15:0])
        );

shift_16Bit shift_1
(
    .data(adc_data[15:0]),
    .clk(CLK),
    .en(data_valid),
    .out_1(test_out[15:0])
    );

endmodule
