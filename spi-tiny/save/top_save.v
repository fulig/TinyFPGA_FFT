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
reg [7:0] r_TX_Byte = 8'b11001010;
reg r_DV = 1'b0;
reg [7:0] r_RX_Byte; 

SPI_Master test
(
	.i_Rst_L(r_Rst),
	.i_Clk(CLK),

	.i_TX_Byte(r_TX_Byte),
	.i_TX_DV(r_DV),
	.o_TX_Ready(PIN_3),

	.o_RX_DV(PIN_4),
	.o_RX_Byte(r_RX_Byte),

	.o_SPI_Clk(PIN_5),
	.i_SPI_MISO(PIN_1),
	.o_SPI_MOSI(PIN_6)
	);


always @ (posedge CLK)

begin
	if(count == 0)
		r_DV <= 1'b1;
	else
		r_DV <= 1'b0;
	count <= count + 1'b1;
end

endmodule // top