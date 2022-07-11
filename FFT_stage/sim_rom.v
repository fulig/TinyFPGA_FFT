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
reg [15:0] ROM[15:0]; 
always @(*)
begin
ROM[0]=16'h0000; ROM[1]=16'h0030;
ROM[2]=16'h0059; ROM[3]=16'h0075;
ROM[4]=16'h007F; ROM[5]=16'h0075;
ROM[6]=16'h0059; ROM[7]=16'h0030;
ROM[8]=16'h0000; ROM[9]=16'h00D0;
ROM[10]=16'h00A7; ROM[11]=16'h008B;
ROM[12]=16'h0081; ROM[13]=16'h008B;
ROM[14]=16'h00A7; ROM[15]=16'h00D0;
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


module ROM_sinus_32
(
	output[15:0] out,
	input[4:0] addr
);
reg [15:0] out;
reg [15:0] data[31:0]; 
always @(*)
begin
data[0 ] = 8'h00;data[1 ] = 8'h18;
data[2 ] = 8'h30;data[3 ] = 8'h46;
data[4 ] = 8'h59;data[5 ] = 8'h69;
data[6 ] = 8'h75;data[7 ] = 8'h7c;
data[8 ] = 8'h7f;data[9 ] = 8'h7c;
data[10] = 8'h75;data[11] = 8'h69;
data[12] = 8'h59;data[13] = 8'h46;
data[14] = 8'h30;data[15] = 8'h18;

data[16] = 8'h00;data[17] = 8'he8;
data[18] = 8'hd0;data[19] = 8'hba;
data[20] = 8'ha7;data[21] = 8'h97;
data[22] = 8'h8b;data[23] = 8'h84;
data[24] = 8'h81;data[25] = 8'h84;
data[26] = 8'h8b;data[27] = 8'h97;
data[28] = 8'ha7;data[29] = 8'hba;
data[30] = 8'hd0;data[31] = 8'he8;

out=data[addr];
end
endmodule
