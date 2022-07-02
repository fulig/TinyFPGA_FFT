`define DUMPSTR(x) `"x.vcd`"
`timescale 100 ns / 10 ns

module tb_twid;

parameter DURATION = 1000;

reg [7:0] count;

reg clk;


// beispiel x=70,y=50,c=121, s=39

reg [7:0] data_0 = 8'h46; //x
reg [7:0] data_1 = 8'h32; //y
reg [7:0] data_2 = 8'h79; //c
reg [8:0] data_3 = 9'h0a0; //c+s
reg [8:0] data_4 = 9'h052; // c-s
wire [15:0] out;


reg start = 1'b0;


twiddle_mult twid_mult_test
(
	.clk(clk),
	.start(start),
	.i_x(data_0),
	.i_y(data_1),
	.i_c(data_2),
	.i_c_plus_s(data_3),
	.i_c_minus_s(data_4)
	);

always #1 clk <= ~clk;



initial begin
	clk <= 0;
	count <= 0;


$dumpfile(`DUMPSTR(`VCD_OUTPUT));
  $dumpvars(0, tb_twid);

   #(DURATION) $display("End of simulation");
  $finish;

end

always @ (posedge clk)
	begin
		if (count == 0)
		begin
			start <= 1'b1;
		end
		else 
			begin
				start <= 1'b0;
			end
		count <= count + 1'b1;	
	end

endmodule // tb_adder