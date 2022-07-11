module fft_spi_out #(parameter N=32,
	parameter MSB = 16)
(
	input clk,    // Clock
	input [N*MSB-1:0] data_bus,
	input start_spi,
	output sclk,
	output mosi,
	output cs
);

localparam IDLE = 2'b00;
localparam SET_TX = 2'b01;
localparam SENDING = 2'b10;
reg [1:0] state = IDLE;

reg [MSB/2-1:0] send_data;
reg start_tx = 0;
wire w_tx_ready;

SPI_Master_With_Single_CS spi_master
(
    .i_Rst_L(1'b1),
    .i_Clk(clk),

    .i_TX_Byte(send_data),
    .i_TX_DV(start_tx),
    .o_TX_Ready(w_tx_ready),

    .o_RX_DV(dv_test),
    .o_SPI_Clk(sclk),
    .o_SPI_MOSI(mosi),
    .o_SPI_CS_n(cs)
    );

reg [$clog2(N)-1:0] addr = 0;
genvar i;
wire [MSB-1:0] data_out [N-1:0];

generate
	for(i=0;i<N;i=i+1)
	begin
		assign data_out[i] = data_bus[(i+1)*MSB-1:i*MSB];
	end
endgenerate

reg [6:0] count_spi=0;



always @ (posedge clk)
begin
	case (state)
		IDLE: 
		begin
			if(start_spi)
			begin
				count_spi <= 0;
				addr <= 0;
				state <= SET_TX;
			end
			else
			begin
				addr <= 0;
				start_tx <= 1'b0;
				count_spi <= 0;
			end
		end
		SET_TX: 
		begin
			start_tx <= 1'b1;
			count_spi <= count_spi + 1'b1;
			state = SENDING;
		end
		SENDING :
		begin
			if(count_spi == 0)
			begin
				if(addr == N-1)
				begin
					state = IDLE;
				end
				else
				begin
				addr <= addr + 1'b1;
				state <= SET_TX;
				end
			end
			else 
				begin
					start_tx <= 1'b0;
					count_spi = count_spi + 1;
				end
		end
	endcase
end

always @(negedge clk)
begin
send_data = data_out[addr];
end

endmodule 