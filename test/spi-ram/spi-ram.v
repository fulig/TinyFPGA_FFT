

module spi_ram
#(parameter WAIT_TIL_NEXT_TX=100)
(
	input clk,
	input [7:0] end_addr,
	input start,
	output mosi,
	output sclk,
	output cs
	);
localparam IDLE = 2'b00;
localparam SET_TRANSMIT = 2'b01;
localparam TRANSMIT = 2'b10;
localparam WAIT = 2'b11;

reg [1:0] state = IDLE;
reg [7:0] data_tx = 8'h00;
reg [7:0] count = 8'h00;
reg [7:0] count_wait = 16'h0000;
reg [7:0] read_data = 16'h0000;
reg start_tx = 1'b0;
reg nr_byte = 1'b0;

wire [7:0]w_read_data ;
wire w_tx_ready;

/*SB_RAM40_4K #(.READ_MODE(1), .WRITE_MODE(0),
.INIT_0(256'h000000000000000001FA000000A6018101810081000000B4005A007F007F007F))
ram40_4kinst_physical (
.RDATA(w_read_data),
.RADDR({3'b000, count[7:0]}),
.RCLKE(1'b1),
.RCLK(clk),
.RE(1'b1)
);*/

SB_RAM40_4K #(.READ_MODE(1), .WRITE_MODE(0),
.INIT_0(256'h002f002c0029002600230020001d001a001700140011000e000b000800050002),
.INIT_1(256'h00590057005400530050004d004b0048004600430040003e003c003900360032),
.INIT_3(256'h007F007F007F007F007F007E007E007D007D007C007B007A0079007900770076),
.INIT_2(256'h00750074007300710070006E006D006B00690067006500640062005F005D005B))
ram40_4kinst_physical (
.RDATA(w_read_data),
.RADDR({3'b000, count[7:0]}),
.RCLKE(1'b1),
.RCLK(clk),
.RE(1'b1)
);

/*
SB_RAM40_4K #(.READ_MODE(1), .WRITE_MODE(0),
.INIT_1(256'h59575453504d4b484643403e3c3936322f2c292623201d1a1714110e0b080502),)
ram40_4kinst_physical (
.RDATA(w_read_data),
.RADDR({3'b000, count[7:0]}),
.RCLKE(1'b1),
.RCLK(clk),
.RE(1'b1)
);*/

//0205080B0E1114171A1D202326292C2F3236393C3E404346484B4D5052545759
//59575453504d4b484643403e3c3936322f2c292623201d1a1714110e0b080502
//000000000000000001FA000000A6018101810081000000B4005A007F007F007F
//007F007F007F005A00B4000000810181018100a6000001FA0000000000000000
//
/*ROM_sinus sinus
(
	.clk(clk),
	.addr(count[7:0]),
	.out(w_read_data[7:0])
	);

*/
SPI_Master_With_Single_CS spi_master
(
	.i_Rst_L(1'b1),
	.i_Clk(clk),

	.i_TX_Byte(w_read_data),
	.i_TX_DV(start_tx),
	.o_TX_Ready(w_tx_ready),

	.o_SPI_Clk(sclk),
    .o_SPI_MOSI(mosi),
    .o_SPI_CS_n(cs)
	);



always @(posedge clk)
begin
	case(state)
		IDLE:
		begin
			if(start)
			begin
				count <= 8'h00;
				start_tx <= 1'b0;
				state <= SET_TRANSMIT;
			end
		end

		SET_TRANSMIT:
		begin
			data_tx[7:0] <= read_data[7:0];
			start_tx <= 1'b1;
			state <= TRANSMIT;
		end

		TRANSMIT:
		begin
			if(cs)
			begin
				count_wait <= WAIT_TIL_NEXT_TX;
				state <= WAIT;
			end
			start_tx <= 1'b0;
		end

		WAIT:
		begin
			if(count_wait>0)
			begin
				count_wait <= count_wait - 1'b1;
			end
			else
				begin
					if(count == end_addr - 1'b1)
					begin
						state <= IDLE;
					end
					else
					begin
						count = count +1'b1;
						state <= SET_TRANSMIT;
					end
				end
		end
	endcase // state
end

always @(*)
begin
read_data[7:0] = w_read_data[7:0];
end

endmodule // spi_ram