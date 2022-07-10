`define DUMPSTR(x) `"x.vcd`"
`timescale 100 ns / 10 ns

module tb_index;

parameter DURATION = 1000;

reg [3:0] index_in = 8'b11010011;
reg [1:0] stage = 2'b00;
reg [3:0] count = 0;
reg clk;

index_mapper #(.MSB(4))
 index_test
(
.index_in (count),
.stage(stage),
.index_out()
	);

always #1 clk <= ~clk;

initial begin
	clk <= 0;


$dumpfile(`DUMPSTR(`VCD_OUTPUT));
  $dumpvars(0, tb_index);

   #(DURATION) $display("End of simulation");
  $finish;
end

always @ (posedge clk)
	begin
		if (count == 15)stage = stage + 1'b1;
		count <= count + 1'b1;
	end

endmodule // tb_index