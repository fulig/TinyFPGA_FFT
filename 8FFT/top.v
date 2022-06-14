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

reg [7:0] W0_c = 8'h7F;
reg [8:0] W0_cps = 9'h07F;
reg [8:0] W0_cms = 9'h07F;

reg [7:0] W1_c = 8'h5A;
reg [8:0] W1_cps = 9'h0B4;
reg [8:0] W1_cms = 9'h000;

reg [7:0] W2_c = 8'h81;
reg [8:0] W2_cps = 9'h181;
reg [8:0] W2_cms = 9'h181;

reg [7:0] W3_c = 8'hA6;
reg [8:0] W3_cps = 9'h000;
reg [8:0] W3_cms = 9'h1FA;

reg [7:0] zero_im = 8'h00;


wire [7:0] out_0;
wire [7:0] out_1;
wire [7:0] out_2;
wire [7:0] out_3;
wire [7:0] out_4;
wire [7:0] out_5;
wire [7:0] out_6;
wire [7:0] out_7;

wire [7:0]w_zero_im;

reg [7:0] a_re = 8'h0C;
reg [7:0] a_im = 8'h1E;
reg [7:0] b_re = 8'h0F;
reg [7:0] b_im = 8'h0A;
reg [7:0] c = 8'h1E;
reg [8:0] c_plus_s = 9'h029; //c+s
reg [8:0] c_minus_s = 9'h013; // c-s

reg [7:0] out_0_re, out_0_im;
reg [7:0] out_1_re, out_1_im;
reg [7:0] out_2_re, out_2_im;
reg [7:0] out_3_re, out_3_im;
reg [7:0] out_4_re, out_4_im;
reg [7:0] out_5_re, out_5_im;
reg [7:0] out_6_re, out_6_im;
reg [7:0] out_7_re, out_7_im;

wire [7:0] w_out_0_re, w_out_0_im;
wire [7:0] w_out_1_re, w_out_1_im;
wire [7:0] w_out_2_re, w_out_2_im;
wire [7:0] w_out_3_re, w_out_3_im;
wire [7:0] w_out_4_re, w_out_4_im;
wire [7:0] w_out_5_re, w_out_5_im;
wire [7:0] w_out_6_re, w_out_6_im;
wire [7:0] w_out_7_re, w_out_7_im;


reg r_Rst = 1'b1;
wire w_Master_RX_Count;
reg [1:0] r_Master_TX_Count = 2'b11;
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
wire stage_1_valid, stage_2_valid, stage_3_valid;

wire [7:0] w_stage12_r0;
wire [7:0] w_stage12_r1;
wire [7:0] w_stage12_r2;
wire [7:0] w_stage12_r3;
wire [7:0] w_stage12_i0;
wire [7:0] w_stage12_i1;
wire [7:0] w_stage12_i2;
wire [7:0] w_stage12_i3;

wire [7:0] w_stage12_r4;
wire [7:0] w_stage12_r5;
wire [7:0] w_stage12_r6;
wire [7:0] w_stage12_r7;
wire [7:0] w_stage12_i4;
wire [7:0] w_stage12_i5;
wire [7:0] w_stage12_i6;
wire [7:0] w_stage12_i7;

//STAGE 1//////////////////////////////////

bfprocessor bf_stage1_0_4
(
    .clk(CLK),
    .start_calc(w_sample),
    .data_valid(stage_1_valid),
    .A_re(out_0),
    .A_im(w_zero_im),
    .B_re(out_4),
    .B_im(w_zero_im),
    .i_C(W0_c),
    .C_plus_S(W0_cps),
    .C_minus_S(W0_cms), 
    .D_re(w_stage12_r0),
    .D_im(w_stage12_i0),
    .E_re(w_stage12_r4),
    .E_im(w_stage12_i4)
    );

bfprocessor bf_stage1_1_5
(
    .clk(CLK),
    .start_calc(w_sample),
    .data_valid(),
    .A_re(out_1),
    .A_im(w_zero_im),
    .B_re(out_5),
    .B_im(w_zero_im),
    .i_C(W1_c),
    .C_plus_S(W1_cps),
    .C_minus_S(W1_cms), 
    .D_re(w_stage12_r1),
    .D_im(w_stage12_i1),
    .E_re(w_stage12_r5),
    .E_im(w_stage12_i5)
    );

bfprocessor bf_stage1_2_6
(
    .clk(CLK),
    .start_calc(w_sample),
    .data_valid(),
    .A_re(out_2),
    .A_im(w_zero_im),
    .B_re(out_6),
    .B_im(w_zero_im),
    .i_C(W2_c),
    .C_plus_S(W2_cps),
    .C_minus_S(W2_cms), 
    .D_re(w_stage12_r2),
    .D_im(w_stage12_i2),
    .E_re(w_stage12_r6),
    .E_im(w_stage12_i6)
    );
bfprocessor bf_stage1_3_7
(
    .clk(CLK),
    .start_calc(w_sample),
    .data_valid(),
    .A_re(out_3),
    .A_im(w_zero_im),
    .B_re(out_7),
    .B_im(w_zero_im),
    .i_C(W3_c),
    .C_plus_S(W3_cps),
    .C_minus_S(W3_cms), 
    .D_re(w_stage12_r3),
    .D_im(w_stage12_i3),
    .E_re(w_stage12_r7),
    .E_im(w_stage12_i7)
    );

//STAGE 2//////////////////////////////////

bfprocessor bf_stage2_0_2
(
    .clk(CLK),
    .start_calc(stage_1_valid),
    .data_valid(stage_2_valid),
    .A_re(w_stage12_r0),
    .A_im(w_stage12_i0),
    .B_re(w_stage12_r2),
    .B_im(w_stage12_i2),
    .i_C(W0_c),
    .C_plus_S(W0_cps),
    .C_minus_S(W0_cms), 
    .D_re(w_out_0_re),
    .D_im(w_out_0_im),
    .E_re(w_out_2_re),
    .E_im(w_out_2_im)
    );

bfprocessor bf_stage2_1_3
(
    .clk(CLK),
    .start_calc(stage_1_valid),
    .data_valid(),
    .A_re(w_stage12_r1),
    .A_im(w_stage12_i1),
    .B_re(w_stage12_r3),
    .B_im(w_stage12_i3),
    .i_C(W2_c),
    .C_plus_S(W2_cps),
    .C_minus_S(W2_cms), 
    .D_re(w_out_1_re),
    .D_im(w_out_1_im),
    .E_re(w_out_3_re),
    .E_im(w_out_3_im)
    );

bfprocessor bf_stage2_4_6
(
    .clk(CLK),
    .start_calc(stage_1_valid),
    .data_valid(),
    .A_re(w_stage12_r4),
    .A_im(w_stage12_i4),
    .B_re(w_stage12_r6),
    .B_im(w_stage12_i6),
    .i_C(W0_c),
    .C_plus_S(W0_cps),
    .C_minus_S(W0_cms), 
    .D_re(w_out_4_re),
    .D_im(w_out_4_im),
    .E_re(w_out_6_re),
    .E_im(w_out_6_im)
    );
bfprocessor bf_stage1_5_7
(
    .clk(CLK),
    .start_calc(stage_1_valid),
    .data_valid(),
    .A_re(w_stage12_r5),
    .A_im(w_stage12_i5),
    .B_re(w_stage12_r7),
    .B_im(w_stage12_i7),
    .i_C(W2_c),
    .C_plus_S(W2_cps),
    .C_minus_S(W2_cms), 
    .D_re(w_out_5_re),
    .D_im(w_out_5_im),
    .E_re(w_out_7_re),
    .E_im(w_out_7_im)
    );


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

shift_8Bit shift_1
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
    .i_Rst_L(r_Rst),
    .i_Clk(CLK),

    .i_TX_Count(r_Master_TX_Count),
    .i_TX_Byte(adc_data[7:0]),
    .i_TX_DV(data_valid),
    .o_TX_Ready(tx_ready),

    .o_RX_Count(),
    .o_RX_DV(),
    .o_RX_Byte(),
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
    if(stage_2_valid)
    begin
    out_0_re[7:0] = w_out_0_re[7:0];
    out_1_re[7:0] = w_out_1_re[7:0];
    out_2_re[7:0] = w_out_2_re[7:0];
    out_3_re[7:0] = w_out_3_re[7:0];
    out_4_re[7:0] = w_out_4_re[7:0];
    out_5_re[7:0] = w_out_5_re[7:0];
    out_6_re[7:0] = w_out_6_re[7:0];
    out_7_re[7:0] = w_out_7_re[7:0];

    out_0_im[7:0] = w_out_0_im[7:0];
    out_1_im[7:0] = w_out_1_im[7:0];
    out_2_im[7:0] = w_out_2_im[7:0];
    out_3_im[7:0] = w_out_3_im[7:0];
    out_4_im[7:0] = w_out_4_im[7:0];
    out_5_im[7:0] = w_out_5_im[7:0];
    out_6_im[7:0] = w_out_6_im[7:0];
    out_7_im[7:0] = w_out_7_im[7:0];
    end
end

assign w_zero_im[7:0] = zero_im[7:0];
//assign PIN_1 = data_valid;
//assign PIN_1 = tx_ready;
/*assign w_count[7:0] = count[7:0];*/
assign PIN_24 = w_out_0_re[7];
assign PIN_23 = w_out_0_re[6];
assign PIN_22 = w_out_0_re[5];
assign PIN_21 = w_out_0_re[4];
assign PIN_20 = w_out_0_re[3];
assign PIN_19 = w_out_0_re[2];
assign PIN_18 = w_out_0_re[1];
assign PIN_17 = w_out_0_re[0];
endmodule
