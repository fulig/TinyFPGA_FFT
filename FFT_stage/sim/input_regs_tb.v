`define DUMPSTR(x) `"x.vcd`"
`timescale 100 ns / 10 ns

module tb_regs;

parameter DURATION = 1000;

reg [15:0] count;
reg [3:0] addr;

reg clk;

input_regs regs(
.clk(clk),
.we(1'b1),
.addr(addr),
.data(count)
	);

always #1 clk <= ~clk;

initial begin
	clk <= 0;
	count <= 0;
	addr <= 0;
$dumpfile(`DUMPSTR(`VCD_OUTPUT));
  $dumpvars(0, tb_regs);

   #(DURATION) $display("End of simulation");
  $finish;

end

always @ (posedge clk)
	begin
		count <= count + 1'b1;	
		addr <= addr + 1'b1;
	end

endmodule // tb_adder