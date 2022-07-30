`define DUMPSTR(x) `"x.vcd`"
`timescale 100 ns / 10 ns

module tb_shift;

parameter MSB = 16;
parameter DURATION = 1000;

reg [7:0] dat = 8'hAB;
reg [7:0] addr = 0;
reg data = 0;
reg clk = 0;
reg en = 1;

always #1 clk <= ~clk;
always #1 data <= data + 4'b0111;

shift_reg #(.MSB(8))shift
(
	.d(data),
	.clk(clk),
	.en(en)
	);

initial begin
	clk <= 0;

$dumpfile(`DUMPSTR(`VCD_OUTPUT));
  $dumpvars(0, tb_shift);

   #(DURATION) $display("End of simulation");
  $finish;
end // initial

always @(posedge clk)
begin
data <= dat[addr];
addr <= addr +1'b1;
end

endmodule // tb_shift