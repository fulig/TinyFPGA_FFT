`define DUMPSTR(x) `"x.vcd`"
`timescale 100 ns / 10 ns

module tb_mult;

parameter MSB = 16;
parameter DURATION = 1000;

reg [8:0] cnt = 0;

reg clk = 0;
reg en = 0;
reg[7:0] data = 8'hAB;

always #1 clk <= ~clk;

demux #(.MSB(8), .N(2))
dmux(
	.sel(en),
	.data_in(data)
	);

initial begin
	clk <= 0;

$dumpfile(`DUMPSTR(`VCD_OUTPUT));
  $dumpvars(0, tb_mult);

   #(DURATION) $display("End of simulation");
  $finish;
end // initial

always @(posedge clk)
begin
if(cnt == 8)begin
 data = ~data;
 en = ~en;
end
cnt = cnt + 1'b1;
end

endmodule // tb_shift