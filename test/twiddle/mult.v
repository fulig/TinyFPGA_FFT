module multiplier_8_9Bit
	#(parameter N=8, 
	  parameter M=9	)
	(
		input clk,
		input start,
		input [7:0] input_0,
		input [8:0] input_1,
		output reg data_valid,
		output reg [16:0] out
		);

reg [4:0]count = 5'h00;
reg [1:0] state;
reg [16:0] p = 17'b00000000000000000;
reg [16:0] t = 17'b00000000000000000;
reg [16:0] input_0_exp;
wire [16:0] w_p;
wire [16:0] w_t;
wire [16:0] w_o;

integer i;

N_bit_adder 
#(.N(17)) Bit_adder
(	.input1(w_p[16:0]),
	.input2(w_t[16:0]),
	.answer(w_o)
	);

localparam INIT = 2'b00;
localparam MULT = 2'b01;
localparam END = 2'b10;

initial begin
	data_valid <= 1'b0;
	count <= 0;
	state <= INIT;
	p <= 17'b00000000000000000;
	t <= 17'b00000000000000000;
end


always @ (posedge clk)
begin
	case (state)
		INIT : 
		begin
			if(start)
			begin
				count <= 5'h00;
				p <= 0;
				if(input_0[7] == 1'b1)
				begin
					input_0_exp[16:0] <= {9'b111111111,input_0[7:0]};
				end
				if(input_0[7] == 1'b0)
				begin
					input_0_exp[16:0] <= {9'b000000000,input_0[7:0]};
				end
				if (input_1[8] == 1'b1)
				begin
					t[16:0] <= {8'b11111111,input_1[8:0]};
				end
				if(input_1[8] == 1'b0)
				begin
					t[16:0] <= {8'b00000000,input_1[8:0]};
				end
				state <= MULT;
			end
			else
				data_valid <= 1'b0;
		end

		MULT :
		begin
			if (count == 5'h10)
			begin
				out <= p;
				data_valid <= 1'b1;
				state <= INIT;
			end
			else if (input_0_exp[count] == 1'b1)
			begin
				p[16:0] <= w_o[16:0];
			end
			t <= t * 2;
			count <= count + 1'b1;
		end

	endcase // state
end

assign w_p[16:0] = p[16:0];
assign w_t[16:0] = t[16:0];

endmodule // N_bit_multiplier

