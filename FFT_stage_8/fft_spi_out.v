module fft_spi_out 
	#(parameter N=32,parameter MSB_2 = 8, parameter WAIT_TIL_NEXT = 64)
(
	input clk,
	input [N*2*MSB_2-1:0] data_bus,
	input start_spi,
	output sclk,
	output mosi,
	output cs,
	output w_tx_ready
);

localparam IDLE = 2'b00;
localparam SET_TX = 2'b01;
localparam SENDING = 2'b10;
localparam WAIT = 2'b11;
reg [1:0] state = IDLE;

reg [MSB_2-1:0] send_data = 0;
reg start_tx = 0;
wire w_tx_ready;

SPI_Master_With_Single_CS spi_master
(
    .i_Rst_L(1'b1),
    .i_Clk(clk),

    .i_TX_Byte(send_data),
    .i_TX_DV(start_tx),
    .o_TX_Ready(w_tx_ready),

    .o_SPI_Clk(sclk),
    .o_SPI_MOSI(mosi),
    .o_SPI_CS_n(cs)
    );

reg [4:0] addr = 0;
genvar i;

wire [MSB_2-1:0] data_out [15:0];

generate
	for(i=0;i<16;i=i+1)
	begin
		assign data_out[i] = data_bus[(i+1)*MSB_2-1:i*MSB_2];
	end
endgenerate

reg [$clog2(WAIT_TIL_NEXT)-1:0] count_spi =0;



always @ (posedge clk)
begin
	case (state)
		IDLE: 
		begin
			if(start_spi)
			begin
				addr <= 0;
				state <= SET_TX;
			end
			else
			begin
				start_tx <= 1'b0;
			end
		end
		SET_TX:
		begin
			start_tx <= 1'b1;
			state <= SENDING;
		end
		SENDING : 
		begin
			if(w_tx_ready)
			begin
				count_spi = 0;
				state <= WAIT;
			end
			else start_tx <= 1'b0;
		end
		WAIT :
		begin
			if(count_spi == WAIT_TIL_NEXT - 1)
			begin
				if(addr == 2*N-1) 
				begin
					state <= IDLE;
				end
				else
				begin
					addr = addr + 1'b1;
					state <= SET_TX;
				end
			end
			else 
				count_spi <= count_spi +1'b1;
		end
	endcase
end

always @(negedge clk)
begin
send_data <= data_out[addr];
end

endmodule 