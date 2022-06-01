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
wire [15:0]adc_data;
wire [7:0]addr_count;

SB_RAM40_4K ram_inst (
.RDATA(),
.RADDR(),
.RCLK(),
.RCLKE(),
.RE(),
.WADDR(addr_count[7:0]),
.WCLK(CLK),
.WCLKE(dv2count),
.WDATA(adc_data[15:0]),
.WE(dv2count),
.MASK()
);


ADC_SPI adc_spi 
    (
        .CLOCK(CLK),
        .CS(PIN_7),
        .SCLK(PIN_2),
        .DATA_IN(PIN_9),
        .DV(dv2count),
        .DATA_OUT(adc_data[15:0])
        );

COUNTER counter
(
    .clk(CLK),
    .count_up(dv2count), 
    .out(addr_count[7:0])
    );
begin 
end
assign PIN_1 = dv2count;
assign PIN_14 = addr_count[0];
assign PIN_15 = addr_count[1];
assign PIN_16 = addr_count[2];
assign PIN_17 = addr_count[3];
endmodule
