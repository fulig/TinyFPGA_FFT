`define DUMPSTR(x) `"x.vcd`"
`timescale 100 ns / 10 ns

module tb_mult;

parameter DURATION = 1000;

reg [7:0] count;

reg clk;
wire [7:0] data_1 = 8'b11111011;
wire [7:0] data_0 = 8'b00000110;
wire [15:0] out;


reg start = 1'b0;


multiplier_8Bit Bit_mult(
	.clk(clk),
	.start(start),
	.input_0(data_0[7:0]),
	.input_1(data_1[7:0]),
	.out(out[15:0])
	);

always #1 clk <= ~clk;



initial begin
	clk <= 0;
	count <= 0;


$dumpfile(`DUMPSTR(`VCD_OUTPUT));
  $dumpvars(0, tb_mult);

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