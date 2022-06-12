module multiplier_8Bit
	(
		input clk,
		input start,
		input [7:0] input_0,
		input [7:0] input_1,
		output reg data_valid,
		output reg [15:0] out
		);

reg [3:0]count = 4'h0;
reg [1:0] state;
reg [15:0] p;
reg [15:0] t;
reg [15:0] input_0_exp;
wire [15:0] w_p;
wire [15:0] w_t;
wire [15:0] w_o;

integer i;

N_bit_adder 
#(.N(16)) Bit_16_adder
(	.input1(w_p[15:0]),
	.input2(w_t[15:0]),
	.answer(w_o)
	);

localparam INIT = 2'b00;
localparam MULT = 2'b01;
localparam END = 2'b10;

initial begin
	data_valid <= 1'b0;
	count <= 0;
	state <= INIT;
	p <= 0;
	t <= 0;
end


always @ (posedge clk)
begin
	case (state)
		INIT : 
		begin
			if(start)
			begin
				count <= 4'h0;
				p <= 16'b0000000000000000;
				if(input_0[7] == 1'b1)
				begin
					input_0_exp[15:0] <= {8'b11111111,input_0[7:0]};
				end
				if(input_0[7] == 1'b0)
				begin
					input_0_exp[15:0] <= {8'b00000000,input_0[7:0]};
				end
				if (input_1[7] == 1'b1)
				begin
					t[15:0] <= {8'b11111111,input_1[7:0]};
				end
				if(input_1[7] == 1'b0)
				begin
					t[15:0] <= {8'b00000000,input_1[7:0]};
				end
				state <= MULT;
			end
			else
				data_valid <= 1'b0;
		end

		MULT :
		begin
			if (count == 4'hF)
			begin
				out <= p;
				data_valid <= 1'b1;
				state <= INIT;
			end
			else if (input_0_exp[count] == 1'b1)
			begin
				p[15:0] <= w_o[15:0];
			end
			t <= t * 2;
			count <= count + 1'b1;
		end

	endcase // state
end

assign w_p = p;
assign w_t = t;

endmodule // N_bit_multiplier