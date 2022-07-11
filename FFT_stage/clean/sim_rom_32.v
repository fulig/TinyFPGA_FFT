module ROM_c_32
(
	output[15:0] out,
	input[3:0] addr
);
reg [15:0] out;
reg [15:0] data[15:0];
always @(*)
begin
data[0]=16'h007f ; data[1]=16'h007c ;
data[2]=16'h0075 ; data[3]=16'h0069 ;
data[4]=16'h0059 ; data[5]=16'h0046 ;
data[6]=16'h0030 ; data[7]=16'h0018 ;
data[8]=16'h0000 ; data[9]=16'h00e8 ;
data[10]=16'h00d0 ; data[11]=16'h00ba ;
data[12]=16'h00a7 ; data[13]=16'h0097 ;
data[14]=16'h008b ; data[15]=16'h0084 ;



out=data[addr];
end
endmodule


module ROM_cps_32
(
	output[15:0] out,
	input[3:0] addr
);
reg [15:0] out;
reg [15:0] data[15:0]; 
always @(*)
begin
data[0]=16'h007f; data[1]=16'h0064;
data[2]=16'h0045; data[3]=16'h0023;
data[4]=16'h0000; data[5]=16'h01dd;
data[6]=16'h01bb; data[7]=16'h019c;
data[8]=16'h0181; data[9]=16'h016c;
data[10]=16'h015b; data[11]=16'h0151;
data[12]=16'h014e; data[13]=16'h0151;
data[14]=16'h015b; data[15]=16'h016c;


out=data[addr];
end
endmodule




module ROM_cms_32
(
	output[15:0] out,
	input[3:0] addr
);
reg [15:0] out;
reg [15:0] data[15:0]; 
always @(*)
begin
data[0]=16'h007f; data[1]=16'h0094;
data[2]=16'h00a5; data[3]=16'h00af;
data[4]=16'h00b2; data[5]=16'h00af;
data[6]=16'h00a5; data[7]=16'h0094;
data[8]=16'h007f; data[9]=16'h0064;
data[10]=16'h0045; data[11]=16'h0023;
data[12]=16'h0000; data[13]=16'h01dd;
data[14]=16'h01bb; data[15]=16'h019c;
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
