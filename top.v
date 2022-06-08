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
    output PIN_16 // CS_arduino
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


reg r_Rst = 1'b1;
wire w_Master_RX_Count;
reg [1:0] r_Master_TX_Count = 2'b11;
reg [7:0] r_RX_Byte; 

wire w_sample;
wire data_valid;
wire tx_ready;
wire [15:0]adc_data;
wire [15:0]test_out;
wire [15:0]pos2neg;



ADC_SPI adc_spi 
    (
        .CLOCK(CLK),
        .CS(PIN_7),
        .SCLK(PIN_2),
        .DATA_IN(PIN_9),
        .DV(data_valid),
        .SAMPLE  (w_sample),
        .DATA_OUT(adc_data[15:0])
        );

SAMPLER sample(
    .clk(CLK),
    .sample(w_sample)
    );

/*shift_16Bit shift_1
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
*/

SPI_Master_With_Single_CS test
(
    .i_Rst_L(r_Rst),
    .i_Clk(CLK),

    .i_TX_Count(r_Master_TX_Count),
    .i_TX_Byte(adc_data[15:0]),
    .i_TX_DV(data_valid),
    .o_TX_Ready(tx_ready),

    .o_RX_Count(),
    .o_RX_DV(),
    .o_RX_Byte(r_RX_Byte),
    .master_ready(PIN_1),
    .o_SPI_Clk(PIN_14),
    .i_SPI_MISO(PIN_1),
    .o_SPI_MOSI(PIN_15),
    .o_SPI_CS_n(PIN_16)
    );

/*pos_2_neg pos_0
(
    .pos(out_4),
    .neg(pos2neg)
    );

N_bit_adder adder_0
(
    .input1(out_0), 
    .input2(pos2neg), 
    .answer(test_out)
    );*/

//assign PIN_1 = data_valid;
//assign PIN_1 = tx_ready;
endmodule
