`define DUMPSTR(x) `"x.vcd`"
`timescale 100 ns / 10 ns

module tb_idx;

parameter DURATION = 1000;

reg [7:0] count;

reg clk;
reg [1:0] stage = 0;

reg [3:0]addr  = 0;


reg start = 1'b0;

wire w_dv;

c_mapper #(.MSB(3)) c_map
(
	.clk(clk),
	.start(start),
	.stage(stage),
	.dv(w_dv)
	);

always #1 clk <= ~clk;



initial begin
	clk <= 0;
	count <= 0;


$dumpfile(`DUMPSTR(`VCD_OUTPUT));
  $dumpvars(0, tb_idx);

   #(DURATION) $display("End of simulation");
  $finish;

end

always @ (posedge clk)
	begin
		if(addr == 9) addr = 0;
		start = (addr == 1);
		addr = addr + 1'b1;
		if(w_dv)stage = stage + 1'b1;
	end

endmodule // tb_adder