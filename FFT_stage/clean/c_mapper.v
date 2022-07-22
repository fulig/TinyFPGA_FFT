module c_mapper #(parameter N=16,
	parameter MSB=16)
(
	input clk,
	input start,
	input [$clog2(N/2)-1:0]stage,
	output dv,
	output o_we,
	output [MSB-1:0] c_out,
	output [MSB-1:0] cps_out,
	output [MSB-1:0] cms_out,
	output [$clog2(N/2)-1:0] addr_out
	); 

localparam IDLE = 1'b0;
localparam DATA_OUT = 1'b1;


reg [$clog2(N/2)-1:0] count_data = 0;
reg [$clog2(N/2)-1:0] stage_data = 0;
reg [1:0]state = IDLE;
reg data_valid = 0;
reg we = 1'b0;
integer i;

/*
// change this when use on real FPGA
SB_RAM40_4K #(.WRITE_MODE(0), //war das nicht 1?
	.READ_MODE(0),
	.INIT_0(256'h008b00a700d00000003000590075007f)
	)
c_rom (
.RDATA(c_out),
.RADDR({8'h00,stage_data}),
.RCLK(clk),
.RE(we),
.RCLKE(1'b1),
.WE(1'b0)
);
SB_RAM40_4K #(.WRITE_MODE(0),
	.READ_MODE(0),
	.INIT_0(256'h015b014e015b018101bb00000045007f)
	)
cps_rom (
.RDATA(cps_out),
.RADDR({8'h00,stage_data}),
.RCLK(clk),
.RE(we),
.RCLKE(1'b1),
.WE(1'b0)
);
SB_RAM40_4K #(.WRITE_MODE(0),
	.READ_MODE(0),
	.INIT_0(256'h01bb00000045007f00a500b200a5007f)
	)
cms_rom(
.RDATA(cms_out),
.RADDR({8'h00,stage_data}),
.RCLK(clk),
.RE(we),
.RCLKE(1'b1),
.WE(1'b0)
);

*/


ROM_c c_rom
(
	.out(c_out),
	.addr(stage_data)
	);

ROM_cps cps_rom
(
	.out(cps_out),
	.addr(stage_data)
	);

ROM_cms cms_rom
(
	.out(cms_out),
	.addr(stage_data)
	);



always @(posedge clk)
begin
case(state)
	IDLE:
	begin
		if(start)
		begin
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
		if(count_data == N/2-1)
		begin
			data_valid <= 1'b1;
			state <= IDLE;
		end
		else
		begin
		count_data = count_data + 1'b1;
		stage_data = count_data << stage;
		end
	end

endcase // state
end

assign dv = data_valid;
assign o_we = we;
assign addr_out = count_data;

endmodule // c_mapper