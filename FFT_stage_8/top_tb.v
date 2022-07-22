`define DUMPSTR(x) `"x.vcd`"
`timescale 100 ns / 10 ns

module tb_top;

parameter DURATION = 100000;

reg clk;

top top_tb
(
	.CLK(clk)
	);

always #1 clk <= ~clk;


initial begin
	clk <= 0;
$dumpfile(`DUMPSTR(`VCD_OUTPUT));
  $dumpvars(0, tb_top);

   #(DURATION) $display("End of simulation");
  $finish;

end

endmodule // tb_c_mapper