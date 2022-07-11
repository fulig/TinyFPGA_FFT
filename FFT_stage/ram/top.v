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
    output PIN_21 //DV test
);
wire [15:0] send_data;
reg[$clog2(32)-1:0] reg_addr = 0;
reg start_tx = 1'b0;
reg we = 1'b1;
reg [7:0]count=0;

SPI_Master_With_Single_CS spi_master
(
    .i_Rst_L(1'b1),
    .i_Clk(CLK),

    .i_TX_Byte(send_data[7:0]),
    .i_TX_DV(start_tx),
    .o_TX_Ready(),

    .o_RX_DV(),
    .o_SPI_Clk(PIN_14),
    .o_SPI_MOSI(PIN_15),
    .o_SPI_CS_n(PIN_16)
    );

SB_RAM40_4K #(.WRITE_MODE(1),
	.READ_MODE(0),
	.INIT_0 (256'h001800300046005900690075007c007f),
	.INIT_1 (256'h007c0075006900590046003000180000),
	.INIT_2 (256'h000000e800d000ba00a70097008b0084),
	.INIT_3 (256'h00810084008b009700a700ba00d000e8)
	)
sinus
(
.RDATA(send_data),
.RADDR({6'h00,reg_addr}),
.RCLK(CLK),
.RE(1'b1),
.RCLKE(1'b1),
.WE(1'b0)
);



always @(posedge CLK)
begin
count = count <= count +1'b1;
if(count == 1)
begin
start_tx <= 1'b1;
reg_addr <= reg_addr + 1'b1;
end
else
begin
	start_tx <= 1'b0;
end
end

endmodule // top