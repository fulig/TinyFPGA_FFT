// look in pins.pcf for all the pin names on the TinyFPGA BX board
module top #(parameter N=16, parameter MSB=16)
    (
    input CLK,    // 16MHz clock
    input PIN_9,  //  DATA_IN from ADC
    output PIN_2,   // SCLK
    output PIN_7,   // CS,
    output PIN_1, // DV
    output PIN_14, //SCLK_arduino
    output PIN_15, //MOSI_arduino
    output PIN_16, // CS_arduino
    output PIN_21 //DV test
);


ROM_sinus sinus_test
(
    .out(w_data_in),
    .addr(w_addr_count)
);

reg we = 1'b1;

reg [15:0] count = 0;
wire w_start_spi;

reg [$clog2(N)-1:0] addr_count = 0;
wire [$clog2(N)-1:0] w_addr_count;
assign w_addr_count = addr_count;

reg insert_data = 0;
wire [15:0] w_data_in;

wire [N*MSB-1:0] w_spi_data;

fft #(.N(N))
fft_module
(
    .clk(CLK),
    .insert_data(insert_data),
    .data_in(w_data_in),
    .addr(w_addr_count),
    .fft_finish(w_start_spi),
    .data_out(w_spi_data)
    );


fft_spi_out #(.N(N))spi_out
(
    .clk(CLK),
    .data_bus(w_spi_data),
    .start_spi(w_start_spi),
    .sclk(PIN_14),
    .mosi(PIN_15),
    .cs(PIN_16)
    );


always @ (posedge CLK)
begin
    count <= count + 1'b1;
    if(count == 4) 
    begin
        insert_data <= 1'b1;
    end
    if(insert_data)
    begin
        if(addr_count == N-1)
        begin
            addr_count <= 0;
            insert_data <= 1'b0;
        end
        else addr_count <= addr_count +1'b1;
    end
end

endmodule // top