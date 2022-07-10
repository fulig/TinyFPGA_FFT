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

reg [7:0] data_test;
reg [7:0] out_0;
reg [7:0] out_1;
reg [7:0] out_2;
reg [7:0] out_3;
reg [7:0] out_4;
reg [7:0] out_5;
reg [7:0] out_6;
reg [7:0] out_7;

reg [7:0] a_re = 8'h0C;
reg [7:0] a_im = 8'h1E;
reg [7:0] b_re = 8'h0F;
reg [7:0] b_im = 8'h0A;
reg [7:0] c = 8'h1E;
reg [8:0] c_plus_s = 9'h029; //c+s
reg [8:0] c_minus_s = 9'h013; // c-s

reg [7:0] r_RX_Byte; 
reg [7:0] count;

wire [7:0] w_count;

wire w_sample;
wire data_valid;
wire tx_ready;
wire [7:0]adc_data;
wire [7:0]test_out;
wire [7:0]pos2neg;
wire [7:0]Re_out;
wire [7:0]Im_out;
wire w_bf_valid;


ADC_SPI adc_spi 
    (
        .CLOCK(CLK),
        .CS(PIN_7),
        .SCLK(PIN_2),
        .DATA_IN(PIN_9),
        .DV(data_valid),
        .SAMPLE  (w_sample),
        .DATA_OUT(adc_data[7:0])
        );

SAMPLER #(.COUNT_TO(382)) // default: 382
sample
(
    .clk(CLK),
    .sample(w_sample)
    );

shift_16Bit shift_1
(
    .data(adc_data[7:0]),
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


SPI_Master_With_Single_CS test
(
    .i_Rst_L(1'b1),
    .i_Clk(CLK),

    .i_TX_Byte(adc_data[7:0]),
    .i_TX_DV(data_valid),
    .o_TX_Ready(tx_ready),

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

always @(posedge CLK)
begin
    if(w_sample)
    begin
        count <= count +1'b1;
    end
end

//assign PIN_1 = data_valid;
//assign PIN_1 = tx_ready;
assign w_count[7:0] = count[7:0];
assign PIN_24 = w_sample;
assign PIN_23 = w_bf_valid;//CLK;
assign PIN_22 = CLK;
assign PIN_21 = Re_out[4];
assign PIN_20 = Re_out[3];
assign PIN_19 = Re_out[2];
assign PIN_18 = Re_out[1];
assign PIN_17 = Re_out[0];
endmodule
