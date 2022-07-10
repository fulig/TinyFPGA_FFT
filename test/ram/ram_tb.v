`define DUMPSTR(x) `"x.vcd`"
`timescale 100 ns / 10 ns

module tb_ram;

parameter DURATION = 1000000;

reg [7:0] count;

reg clk;


reg start = 1'b0;


test_ram t_ram(
	.CLK(clk)
	);

always #1 clk <= ~clk;



initial begin
	clk <= 0;
	count <= 0;


$dumpfile(`DUMPSTR(`VCD_OUTPUT));
  $dumpvars(0, tb_ram);

   #(DURATION) $display("End of simulation");
  $finish;

end

endmodule // tb_adder