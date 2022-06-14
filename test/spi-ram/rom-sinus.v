module ROM_sinus
(
	input clk,
	input [7:0] addr,
	output reg [7:0]out
	);

SB_RAM40_4K #(.READ_MODE(1), .WRITE_MODE(0),
.INIT_0(256'h0205080B0E1114171A1D202326292C2F3236393C3E404346484B4D5052545759),
.INIT_1(256'h5B5D5F62646567696B6D6E7071737475767779797A7B7C7D7D7E7E7F7F7F7F7F))
ram40_4kinst_physical (
.RDATA(w_out),
.RADDR({3'b000, addr[7:0]}),
.RCLKE(1'b1),
.RCLK(clk),
.RE(1'b1)
);

wire [7:0] w_out;

/*initial begin
	mem[0]<=8'h02; 	 mem[1]<=8'h05;   mem[2]<=8'h08;   mem[3]<=8'h0b;   mem[4]<=8'h0e; 	 mem[5]<=8'h11;   mem[6]<=8'h14;   mem[7]<=8'h17;
    mem[8]<=8'h1a; 	 mem[9]<=8'h1d;   mem[10]<=8'h20;  mem[11]<=8'h23;  mem[12]<=8'h26;  mem[13]<=8'h29;  mem[14]<=8'h2c;  mem[15]<=8'h2f;
    mem[16]<=8'h32;  mem[17]<=8'h36;  mem[18]<=8'h39;  mem[19]<=8'h3c;  mem[20]<=8'h3e;  mem[21]<=8'h40;  mem[22]<=8'h43;  mem[23]<=8'h46;
    mem[24]<=8'h48;  mem[25]<=8'h4b;  mem[26]<=8'h4d;  mem[27]<=8'h50;  mem[28]<=8'h52;  mem[29]<=8'h54;  mem[30]<=8'h57;  mem[31]<=8'h59;
    mem[32]<=8'h5b;  mem[33]<=8'h5d;  mem[34]<=8'h5f;  mem[35]<=8'h62;  mem[36]<=8'h64;  mem[37]<=8'h65;  mem[38]<=8'h67;  mem[39]<=8'h69;
    mem[40]<=8'h6b;  mem[41]<=8'h6d;  mem[42]<=8'h6e;  mem[43]<=8'h70;  mem[44]<=8'h71;  mem[45]<=8'h73;  mem[46]<=8'h74;  mem[47]<=8'h75;
    mem[48]<=8'h76;  mem[49]<=8'h77;  mem[50]<=8'h79;  mem[51]<=8'h79;  mem[52]<=8'h7a;  mem[53]<=8'h7b;  mem[54]<=8'h7c;  mem[55]<=8'h7d;
    mem[56]<=8'h7d;  mem[57]<=8'h7e;  mem[58]<=8'h7e;  mem[59]<=8'h7f;  mem[60]<=8'h7f;  mem[61]<=8'h7f;  mem[62]<=8'h7f;  mem[63]<=8'h7f;
end
always @(posedge clk)
begin
	out<=mem[addr];
end*/
assign w_out = out;

endmodule