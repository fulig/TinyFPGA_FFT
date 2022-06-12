module test_ram
(
	input CLK,
	output PIN_24,
	output PIN_23,
	output PIN_22,
	output PIN_21,
	output PIN_20,
	output PIN_19,
	output PIN_18,
	output PIN_17
	);

reg [15:0] read_data;
reg [15:0] write_data;
reg [7:0] read_addr;
reg [7:0] write_addr;

reg [7:0] count;


wire [15:0] w_read_data;
wire [15:0] w_write_data;
wire [7:0] w_read_addr;
wire [7:0] w_write_addr;

wire rclk_en;
wire wclk_en;
wire r_en;
wire w_en;



SB_RAM40_4K #(.WRITE_MODE(0),
	.READ_MODE(0),
	.INIT_0(256'h0102030405060708090A0B0C0D0E0F)
	)
ram40_4kinst_physical (
.RDATA(w_read_data),
.RADDR(w_read_addr),
.WADDR(w_write_addr),
.MASK(16'hFFFF),
.WDATA(w_write_data),
.RCLK(CLK),
.RE(1'b1),
.WCLK(CLK),
.WE(1'b1)
);

//defparam ram40_4kinst_physical.READ_MODE=0;
//defparam ram40_4kinst_physical.WRITE_MODE=0;
//defparam ram40_4kinst_physical.INIT_0 = 256'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0
//123456789ABCDFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEDCBA9876543210
//0102030405060708090FFFFFFFFFFFFFFFFFFFFFFFFFFFF90807060504030201
always @ (posedge CLK)
begin
	read_addr[7:0] <= count[7:0];
	//write_addr[7:0] <= count[7:0];
	//write_data[15:0] <= count[7:0];
	count = count +1'b1;
end

assign rclk_en = 1'b1;
assign wclk_en = 1'b1;
assign r_en = 1'b1;
assign w_en = 1'b1;

assign w_read_addr[7:0] = read_addr[7:0];
assign w_write_addr[7:0] = write_addr[7:0];
assign w_write_data[15:0] = write_data[15:0];

assign PIN_24 = w_read_data[0];
assign PIN_23 = w_read_data[1];
assign PIN_22 = w_read_data[2];
assign PIN_21 = w_read_data[3];
assign PIN_20 = w_read_data[4];
assign PIN_19 = w_read_data[5];
assign PIN_18 = w_read_data[6];
assign PIN_17 = w_read_data[7];

endmodule // twiddle_mult