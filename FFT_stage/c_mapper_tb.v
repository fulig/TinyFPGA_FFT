`define DUMPSTR(x) `"x.vcd`"
`timescale 100 ns / 10 ns

module tb_c_mapper;

parameter DURATION = 1000;

reg [5:0] count = 0;
reg start = 1'b0;
reg [1:0] stage = 0;

reg clk;

c_mapper cmap 
(
	.clk(clk),
	.start(start),
	.stage(stage)
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
	count <= count + 1'b1;
	if(count==2)
	begin
		start <= 1'b1;
		stage <= stage +1'b1;
	end
	else start <= 1'b0;
end

endmodule // tb_c_mapper