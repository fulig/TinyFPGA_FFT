module top
	(
		input CLK,
		output PIN_24,
    	output PIN_23,
    	output PIN_22, 
    	output PIN_21,
    	output PIN_20,
    	output PIN_19,
    	output PIN_18,
    	output PIN_17
		);

localparam INIT = 1'b0;
localparam MULT = 1'b1;


reg [9:0] count_0 = 10'h000;
reg [7:0] count_1 = 8'h00;
reg [8:0] count_2 = 9'h000;
reg state = INIT;
reg start;

wire w_dv;
wire [16:0] w_out;

wire [7:0] w_count_1;
wire [8:0] w_count_2;


multiplier_8_9Bit mult
(	
	.clk(CLK),
	.start(start),
	.input_0(w_count_1),
	.input_1(w_count_2),
	.data_valid(w_dv),
	.out(w_out)
	);

always @(posedge CLK)
begin
case (state)
	INIT:
	begin
		if(count_0 == 0)
		begin
			start <= 1'b1;
			state = MULT;
		end
		else
		begin
			start <= 1'b0;
		end
	end
	MULT:
	begin
		if(w_dv)
		begin
			count_1 <= count_1 + 1'b1;
			count_2 <= count_2 + 2'b10;
			state <= INIT;
		end
		start <= 1'b0;
	end
endcase // state
count_0 = count_0 + 1'b1;
end

assign w_count_1[7:0] = count_1[7:0];
assign w_count_2[8:0] = count_2[8:0];

assign PIN_24 = CLK;
assign PIN_23 = start;
assign PIN_22 = w_dv;
assign PIN_21 = w_out[4];
assign PIN_20 = w_out[3];
assign PIN_19 = w_out[2];
assign PIN_18 = w_out[1];
assign PIN_17 = w_out[0];


endmodule // top