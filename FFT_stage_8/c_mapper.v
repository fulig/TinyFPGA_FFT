module c_mapper #(parameter N=16,
	parameter MSB=16)
(
	input clk,
	input start,
	input [$clog2(N/2)-1:0]stage,
	output reg data_valid,
	output reg we,
	output [MSB-1:0] c_out,
	output [MSB-1:0] cps_out,
	output [MSB-1:0] cms_out,
	output reg [$clog2(N/2)-1:0] count_data
	); 

reg [$clog2(N/2)-1:0] stage_data = 0;



// change this when use on real FPGA
SB_RAM40_4K #(.WRITE_MODE(1), //war das nicht 1? anderer branch!
	.READ_MODE(0),
	.INIT_0(256'h008b00a700d00000003000590075007f)
	)
c_rom (
.RDATA(c_out),
.RADDR({8'h00,stage_data, 1'b0}),
.RCLK(clk),
.RE(we),
.RCLKE(1'b1),
.WE(1'b0)
);
SB_RAM40_4K #(.WRITE_MODE(1),
	.READ_MODE(0),
	.INIT_0(256'h015b014e015b018101bb00000045007f)
	)
cps_rom (
.RDATA(cps_out),
.RADDR({8'h00,stage_data, 1'b0}),
.RCLK(clk),
.RE(we),
.RCLKE(1'b1),
.WE(1'b0)
);
SB_RAM40_4K #(.WRITE_MODE(1),
	.READ_MODE(0),
	.INIT_0(256'h01bb00000045007f00a500b200a5007f)
	)
cms_rom(
.RDATA(cms_out),
.RADDR({8'h00,stage_data, 1'b0}),
.RCLK(clk),
.RE(we),
.RCLKE(1'b1),
.WE(1'b0)
);


/*

ROM_c c_rom
(
	.out(c_out),
	.addr({stage_data,1'b0})
	);

ROM_cps cps_rom
(
	.out(cps_out),
	.addr({stage_data,1'b0})
	);

ROM_cms cms_rom
(
	.out(cms_out),
	.addr({stage_data,1'b0})
	);
*/
reg o_busy = 1'b0;

always @(posedge clk)
begin
	if(!o_busy)
		begin
			count_data = 0;
			stage_data = 0;
			data_valid <= 1'b0;
			we <= 1'b0;
			o_busy <= start;
		end
	else begin
		we <= 1'b1;
		data_valid <= count_data == N/2-1;
		o_busy <= (count_data < N/2-1);
		count_data = count_data + 1'b1;
		stage_data = count_data << stage;

		end
end



endmodule // c_mapper