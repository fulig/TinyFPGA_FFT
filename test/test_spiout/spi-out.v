module SPI_OUT
	(
	input CLK,
	output reg SCLK,
	output reg CS,
	output reg DATA_OUT
	);

reg [15:0] test_0 = 16'b0101011101010101;
reg [15:0] test_1 = 16'b0000111100001111;
reg [15:0] test_2 = 16'b0011001101011010;

reg [7:0] count = 8'b00000000; 
reg [7:0] count_bit = 8'b00000000;
reg [7:0] count_pos = 8'b00000000;

initial begin
	SCLK <= 1'b1;
	CS <= 1'b1;
end // initial

always @ (posedge CLK)
	begin
		count = count + 1'b1;
		if(count <= 2*2 || count >= 28*2) CS <= 1;
		else CS <= 0;
		if((count >= 4*2 && count < 12*2) || (count >= 16 && count <24) )
		begin
			SCLK <= ~SCLK;
			count_pos <= count_pos + 1'b1;
        	
        end
        else SCLK <= 0;
        
        if(count == 28*2)
        	CS <= 1;
        if(count == 31*2)
        begin
        	count <= 0;
        	count_pos <= 0;
        end
	end
always @ (negedge CLK)
	begin
		DATA_OUT <= test_0[count_pos];
	end
endmodule // SPI_OUT
