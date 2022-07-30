`define DUMPSTR(x) `"x.vcd`"
`timescale 100 ns / 10 ns

module tb_idx;

parameter DURATION = 1000;

reg [7:0] count;

reg clk;
reg [1:0] stage = 0;

reg [$clog2(8)-1:0]addr  = 0;


reg start = 1'b0;

index_mapper #(.MSB(3)) idx_map
(
	.index_in(addr),
	.stage(stage)
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
		addr = addr + 1'b1;
		if(addr == 0)stage = stage + 1'b1;
	end

endmodule // tb_adder