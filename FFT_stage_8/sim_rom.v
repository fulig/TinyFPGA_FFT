module ROM_c
(
	output[15:0] out,
	input[2:0] addr
);
reg [15:0] out;
reg [15:0] data[7:0];
always @(*)
begin
data[0]=16'h007f; data[1]=16'h0075;
data[2]=16'h0059; data[3]=16'h0030;
data[4]=16'h0000; data[5]=16'h00d0;
data[6]=16'h00a7; data[7]=16'h008b;
out=data[addr];
end
endmodule

module sinus_8
(
	output[15:0] out,
	input[2:0] addr
	);
reg [15:0] out;
reg [15:0] data[7:0];
always @(*)
begin
data[0]=16'h0000; data[1]=16'h006B;
data[2]=16'h0074; data[3]=16'h0012;
data[4]=16'h00A0; data[5]=16'h0086;
data[6]=16'h00DD; data[7]=16'h0054;
out=data[addr];
end
endmodule


module ROM_cps
(
	output[15:0] out,
	input[2:0] addr
);
reg [15:0] out;
reg [15:0] data[7:0]; 
always @(*)
begin
data[0]=16'h007f; data[1]=16'h0045;
data[2]=16'h0000; data[3]=16'h01bb;
data[4]=16'h0181; data[5]=16'h015b;
data[6]=16'h014e; data[7]=16'h015b;
out=data[addr];
end
endmodule

module ROM_cms
(
	output[15:0] out,
	input[2:0] addr
);
reg [15:0] out;
reg [15:0] data[7:0]; 
always @(*)
begin
data[0]=16'h007f; data[1]=16'h00a5;
data[2]=16'h00b2; data[3]=16'h00a5;
data[4]=16'h007f; data[5]=16'h0045;
data[6]=16'h0000; data[7]=16'h01bb;
out=data[addr];
end
endmodule

module ROM_sinus
(
	output[15:0] out,
	input[3:0] addr
);
reg [15:0] out;
reg [15:0] data[15:0]; 
always @(*)
begin
data[0]=16'h0000; data[1]=16'h0030;
data[2]=16'h0059; data[3]=16'h0075;
data[4]=16'h007F; data[5]=16'h0075;
data[6]=16'h0059; data[7]=16'h0030;
data[8]=16'h0000; data[9]=16'h00D0;
data[10]=16'h00A7; data[11]=16'h008B;
data[12]=16'h0081; data[13]=16'h008B;
data[14]=16'h00A7; data[15]=16'h00D0;
out=data[addr];
end
endmodule

module ROM_double_sinus
(
	output[15:0] out,
	input[3:0] addr
);
reg [15:0] out;
reg [15:0] data[15:0]; 
always @(*)
begin
data[0]=16'h0000; data[1]=16'h0022;
data[2]=16'h0059; data[3]=16'h0052;
data[4]=16'h0000; data[5]=16'h00AE;
data[6]=16'h00A7; data[7]=16'h00DE;
data[8]=16'h0000; data[9]=16'h00DE;
data[10]=16'h00A7; data[11]=16'h00AE;
data[12]=16'h0000; data[13]=16'h0052;
data[14]=16'h0059; data[15]=16'h0022;
out=data[addr];
end
endmodule


