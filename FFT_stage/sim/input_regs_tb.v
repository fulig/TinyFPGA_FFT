`define DUMPSTR(x) `"x.vcd`"
`timescale 100 ns / 10 ns

module tb_input_regs;

parameter DURATION = 1000;

reg [5:0] count = 0;
reg [15:0] data = 16'hffff;
reg [3:0] addr = 0;
reg we = 1'b1;

reg clk;

input_regs in_regs 
(
	.clk(clk),
	.we(we),
	.addr(addr),
	.data(data)
		);

always #1 clk <= ~clk;
always #4 addr <= addr + 1'b1;
always #4 data <= data - 2'b10;


initial begin
	clk <= 0;
count <= 0;

$dumpfile(`DUMPSTR(`VCD_OUTPUT));
  $dumpvars(0, tb_input_regs);

   #(DURATION) $display("End of simulation");
  $finish;

end

always @ (posedge clk)

begin
  count <= count + 1'b1;
	addr <= addr + 1'b1;
	data <= data -2'b10;
end

endmodule // tb_c_mapper