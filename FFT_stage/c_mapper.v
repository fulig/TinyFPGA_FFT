module c_mapper #(parameter N=16,
	parameter MSB=16)
(
	input clk,
	input start,
	input [$clog2(N)-1:0]stage,
	output dv,
	output [MSB-1:0] data,
	output [1:0] select_c
	); 

localparam IDLE = 1'b0;
localparam DATA_OUT = 1'b1;

reg [2:0] count_c = 0;
reg [$clog2(N)-1:0] count_data = 0;
reg [$clog2(N)-1:0] stage_data = 0;
reg state = IDLE;
reg data_valid = 0;


SB_RAM40_4K #(.WRITE_MODE(0),
	.READ_MODE(0),
	.INIT_0(256'h008b00a700d00000003000590075007f),
	.INIT_1(256'h015b014e015b018101bb00000045007f),
	.INIT_2(256'h01bb00000045007f00a500b200a5007f)
	)

ram40_4kinst_physical (
.RDATA(data),
.RADDR({4'b0000,count_c, count_data}),
.RCLK(clk),
.RE(1'b1),
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
			state = DATA_OUT;
		end
		else 
			data_valid <= 1'b0;
	end
	DATA_OUT :
	begin
		if(count_data == N/2)
		begin
			data_valid <= 1'b1;
			state = IDLE;
		end
		if(count_c == 2)
		begin
		count_data = count_data + 1'b1;
		count_c = 0;
		end
		else
			begin
				count_c = count_c + 1'b1;
			end
	end
endcase // state
end
assign select_c = count_c;
assign dv = data_valid;

endmodule // c_mapper