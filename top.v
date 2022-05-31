// look in pins.pcf for all the pin names on the TinyFPGA BX board
module top
    (
    input CLK,    // 16MHz clock
    input PIN_9,  // DATA_IN from ADC
    input LED,
    output PIN_1, // DV test
    output PIN_7,   // CS
    output PIN_2,   // SCLK
    output PIN_14, // test data_0
    output PIN_15, // test data_1
    output PIN_16, 
    output PIN_17
    
);

reg [13:0] data_test;

ADC_SPI adc_spi 
    (
        .CLOCK(CLK),
        .CS(PIN_7),
        .SCLK(PIN_2),
        .DATA_IN(PIN_9),
        .DV(PIN_1),
        .DATA_OUT(data_test[13:0])
        );

begin 
end
assign PIN_14 = data_test[0];
assign PIN_15 = data_test[1];
assign PIN_16 = data_test[12];
assign PIN_17 = data_test[13];
endmodule
