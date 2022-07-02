module c_mapper #(parameter N=16,
	parameter MSB=16)
(
	input clk,
	input start,
	input [$clog2(N/4)-1:0]stage,
	output dv,
	output o_we,
	output [MSB-1:0] data,
	output [1:0] select_c
	); 

localparam IDLE = 2'b00;
localparam DATA_OUT = 2'b01;
localparam DV = 2'b10;

reg [2:0] count_c = 0;
reg [$clog2(N/2)-1:0] count_data = 0;
reg [$clog2(N/2)-1:0] stage_data = 0;
reg [1:0]state = IDLE;
reg data_valid = 0;
reg we = 1'b0;
integer i;

SB_RAM40_4K #(.WRITE_MODE(0),
	.READ_MODE(0),
	.INIT_0(256'h008b00a700d00000003000590075007f),
	.INIT_1(256'h015b014e015b018101bb00000045007f),
	.INIT_2(256'h01bb00000045007f00a500b200a5007f)
	)

ram40_4kinst_physical (
.RDATA(data),
.RADDR({4'b0000,count_c,1'b0,stage_data}),
.RCLK(clk),
.RE(we),
.WE(1'b0)
);

always @(posedge clk)
begin
case(state)
	IDLE:
	begin
		if(start)
		begin
			count_c = 0;
			count_data = 0;
			stage_data = 0;
			we <= 1'b1;
			i = stage;
			state = DATA_OUT;
		end
		else 
		begin
			data_valid <= 1'b0;
			we <= 1'b0;
		end
	end
	DATA_OUT :
	begin
		if(count_c == 2)
		begin
		if(count_data == N/2-1)state <= DV;
		else
		begin
		count_data = count_data + 1'b1;
		stage_data = count_data << stage;
		count_c = 0;
		end
		end
		else
			begin
				count_c = count_c + 1'b1;
				
			end
	end
	DV :
	begin
		we <= 1'b0;
		data_valid <= 1'b1;
		state <= IDLE;
	end
endcase // state
end
assign select_c = count_c;
assign dv = data_valid;
assign o_we = we;

endmodule // c_mapper