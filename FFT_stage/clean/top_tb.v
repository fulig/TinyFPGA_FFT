`define DUMPSTR(x) `"x.vcd`"
`timescale 100 ns / 10 ns

module tb_fft_16;

parameter DURATION = 100000;

top #(.N(16))
test_top(
.CLK(clk)
	);
reg [7:0] count;
reg clk;
reg [3:0]addr_count= 0;
reg insert_data = 0;
reg output_data = 0;
wire [3:0] w_addr_count;
wire [15:0]w_rom_data;
wire w_fft_finish;

always #1 clk <= ~clk;

initial begin
	clk <= 0;
	count <= 0;
	output_data <= 0;


$dumpfile(`DUMPSTR(`VCD_OUTPUT));
  $dumpvars(0, tb_fft_16);

   #(DURATION) $display("End of simulation");
  $finish;

end

always @ (posedge clk)
begin
	count <= count + 1'b1;
	if(count == 4) 
	begin
		insert_data <= 1'b1;
	end
	if(insert_data)
	begin
		if(addr_count == 15)
		begin
			addr_count <= 0;
			insert_data <= 1'b0;
		end
		addr_count <= addr_count +1'b1;
	end
end

endmodule // tb_adder