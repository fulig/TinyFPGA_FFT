// look in pins.pcf for all the pin names on the TinyFPGA BX board
module top
    (
    input CLK,    // 16MHz clock // DV
    output PIN_14,
    output PIN_15,
    output PIN_16,
    output PIN_17
);

SPI_OUT spiout(
.CLK(CLK), 
.SCLK(PIN_14),
.CS(PIN_15),
.DATA_OUT(PIN_16)
    );

endmodule
