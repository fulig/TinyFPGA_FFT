module top(
	input CLK,
	input PIN_1, 
	input PIN_2,
	output PIN_3, 
	output PIN_4,
	output PIN_5,
	output PIN_6,
	output PIN_7,
	output PIN_8
	);


reg [7:0] count = 8'b00000000;
reg r_Rst = 1'b1;
reg [15:0] r_TX_Byte = 16'b1010101111001101;
reg r_DV = 1'b0;
reg [7:0] r_RX_Byte; 
reg [1:0] w_Master_RX_Count = 2'b01;
reg [1:0] r_Master_TX_Count = 2'b10;

 SPI_Master_With_Single_CS test
(
	.i_Rst_L(r_Rst),
	.i_Clk(CLK),

	.i_TX_Count(r_Master_TX_Count),
	.i_TX_Byte(r_TX_Byte),
	.i_TX_DV(r_DV),
	.o_TX_Ready(PIN_3),

	//.o_RX_Count(w_Master_RX_Count),
	.o_RX_DV(PIN_4),
	.o_RX_Byte(r_RX_Byte),

	.o_SPI_Clk(PIN_5),
	.i_SPI_MISO(PIN_1),
	.o_SPI_MOSI(PIN_6),
	.o_SPI_CS_n(PIN_7)
	);


always @ (posedge CLK)

begin
	if(count <= 1)
		r_DV <= 1'b1;
	else
		r_DV <= 1'b0;
	count <= count + 1'b1;
end

assign PIN_8 = r_DV;
endmodule // top