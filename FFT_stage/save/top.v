module top
    (
    input CLK,    // 16MHz clock
    output PIN_24,
    output PIN_23,
    output PIN_22, 
    output PIN_21,
    output PIN_20,
    output PIN_19,
    output PIN_18,
    output PIN_17
);

wire [15:0] w_read_data;
wire dv;
reg [8:0] count = 0;
reg start = 1'b0;
reg [2:0] stage = 0;

c_mapper cmap 
(
    .clk(CLK),
    .start(start),
    .dv(dv),
    .stage(stage), 
    .o_we(PIN_18)
    );


always @(posedge CLK)
begin
count = count +1'b1;
if(count == 1) 
begin
    start <= 1'b1;
    stage = stage + 1'b1;
end
else start <= 1'b0;
end

assign PIN_24 = w_read_data[0]; //start;
assign PIN_23 = w_read_data[1];
assign PIN_22 = w_read_data[2];
assign PIN_21 = w_read_data[3];
assign PIN_20 = w_read_data[4];
assign PIN_19 = w_read_data[5];
//assign PIN_18 = w_read_data[6]; // CLK;
assign PIN_17 = CLK; //w_read_data[7]; // dv;

endmodule // top