module c_mapper #(parameter N=16,
	parameter MSB=16)
(
	input clk,
	input start,
	input [$clog2(N/4)-1:0]stage,
	output reg data_valid,
	output reg we,
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
integer i;


// change this when use on real FPGA

SB_RAM40_4K #(.WRITE_MODE(1),
	.READ_MODE(0),
	.INIT_0(256'h001800300046005900690075007c007f),
	.INIT_1(256'h0084008b009700a700ba00d000e80000)
	)
c_rom (
.RDATA(c_out),
.RADDR({7'h00,stage_data}),
.RCLK(clk),
.RE(we),
.RCLKE(1'b1),
.WE(1'b0)
);
SB_RAM40_4K #(.WRITE_MODE(1),
	.READ_MODE(0),
	.INIT_0(256'h019c01bb01dd0000002300450064007f),
	.INIT_1(256'h016c015b0151014e0151015b016c0181)
	)
cps_rom (
.RDATA(cps_out),
.RADDR({7'h00,stage_data}),
.RCLK(clk),
.RE(we),
.RCLKE(1'b1),
.WE(1'b0)
);
SB_RAM40_4K #(.WRITE_MODE(1),
	.READ_MODE(0),
	.INIT_0(256'h009400a500af00b200af00a50094007f),
	.INIT_1(256'h019c01bb01dd0000002300450064007f)
	)
cms_rom(
.RDATA(cms_out),
.RADDR({7'h00,stage_data}),
.RCLK(clk),
.RE(we),
.RCLKE(1'b1),
.WE(1'b0)
);



/*
ROM_c_32 c_rom
(
	.out(c_out),
	.addr(stage_data)
	);

ROM_cps_32 cps_rom
(
	.out(cps_out),
	.addr(stage_data)
	);

ROM_cms_32 cms_rom
(
	.out(cms_out),
	.addr(stage_data)
	);
*/

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
			//i = stage;
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

assign addr_out = count_data;

endmodule // c_mapper