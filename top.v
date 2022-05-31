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

reg [7:0] data_test;
wire dv2count;

ADC_SPI adc_spi 
    (
        .CLOCK(CLK),
        .CS(PIN_7),
        .SCLK(PIN_2),
        .DATA_IN(PIN_9),
        .DV(dv2count),
        .DATA_OUT()
        );

COUNTER counter
(
    .clk(PIN_2),
    .count_up(dv2count), 
    .out(data_test[7:0])
    );
begin 
end
assign PIN_14 = data_test[0];
assign PIN_15 = data_test[1];
assign PIN_16 = data_test[2];
assign PIN_17 = data_test[3];
endmodule
