// look in pins.pcf for all the pin names on the TinyFPGA BX board
module top
    (
    input CLK,    // 16MHz clock
    input PIN_9,  //  DATA_IN from ADC
    output PIN_2,   // SCLK
    output PIN_7,   // CS,
    output PIN_1, // DV
    output PIN_14,
    output PIN_15,
    output PIN_16,
    output PIN_17
);

reg [7:0] data_test;
reg [15:0] out_0;
reg [15:0] out_1;
reg [15:0] out_2;
reg [15:0] out_3;
reg [15:0] out_4;
reg [15:0] out_5;
reg [15:0] out_6;
reg [15:0] out_7;

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
    .out_0(out_0),
    .out_1(out_1),
    .out_2(out_2),
    .out_3(out_3),
    .out_4(out_4),
    .out_5(out_5),
    .out_6(out_6),
    .out_7(out_7)
    );


assign PIN_1 = data_valid;
assign PIN_14 = adc_data[15];
assign PIN_15 = adc_data[14];
assign PIN_16 = adc_data[13];
assign PIN_17 = adc_data[12];

endmodule
