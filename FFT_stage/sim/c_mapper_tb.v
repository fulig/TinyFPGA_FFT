`define DUMPSTR(x) `"x.vcd`"
`timescale 100 ns / 10 ns

module tb_c_mapper;

parameter DURATION = 1000;

reg [15:0] count;
reg start = 1'b0;

reg clk;

c_mapper cmap 
(
	.clk(clk),
	.start(start)
	);

always #1 clk <= ~clk;


initial begin
	clk <= 0;
	start <= 1;
$dumpfile(`DUMPSTR(`VCD_OUTPUT));
  $dumpvars(0, tb_c_mapper);

   #(DURATION) $display("End of simulation");
  $finish;

end

always @ (posedge clk)
begin
	count = count + 1'b1;
	if(count==2)start <= 1'b1;
	else start <= 1'b0;
end

endmodule // tb_c_mapper