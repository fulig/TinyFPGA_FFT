module shift_8Bit
	(
		input [7:0] data,
		input clk,
		input en,
		output reg  [7:0] out_0 ,
		output reg  [7:0] out_1 ,
		output reg  [7:0] out_2 ,
		output reg  [7:0] out_3 ,
		output reg  [7:0] out_4 ,
		output reg  [7:0] out_5 ,
		output reg  [7:0] out_6 ,
		output reg  [7:0] out_7 
		);

always @(posedge clk)
begin
	if(en)
	begin
		out_7 <= out_6;
		out_6 <= out_5;
		out_5 <= out_4;
		out_4 <= out_3;
		out_3 <= out_2;
		out_2 <= out_1;
		out_1 <= out_0;
		out_0 <= data;
	end
	else begin
		out_0 <= out_0;
		out_1 <= out_1;
		out_2 <= out_2;
		out_3 <= out_3;
		out_4 <= out_4;
		out_5 <= out_5;
		out_6 <= out_6;
		out_7 <= out_7;
	end
end
endmodule // shift_16Bit