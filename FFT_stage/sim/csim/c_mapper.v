module c_mapper #(parameter N=16,
	parameter MSB=16)
(
	input clk,
	input start,
	input [$clog2(N/4)-1:0]stage,
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