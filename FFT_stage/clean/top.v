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
    output PIN_24,
    output PIN_23,
    output PIN_22, 
    output PIN_21,
    output PIN_20,
    output PIN_19,
    output PIN_18,
    output PIN_17
);

fft fft_module
(
    .clk(CLK),
    .insert_data(1'b1)
    );

endmodule // top