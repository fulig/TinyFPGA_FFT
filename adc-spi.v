// look in pins.pcf for all the pin names on the TinyFPGA BX board
module ADC_SPI #(parameter CLKS_PER_HALF_BIT = 8)
    (
    input CLOCK,        // FPGA Clock
    input DATA_IN,         // Data input
    output reg CS,          // CS
    output reg SCLK,        // SCLK
    output reg [15:0] DATA_OUT, // data output
    output reg DV           // data valid output
);

    //reg data_valid = 1'b0;
    reg r_SPI_CLK = 1'b1;
    reg r_Data_in = 1'b0;
    reg r_DV = 1'b0;
    reg r_CS = 1'b1;
    reg init = 1'b1;
    reg [8:0]count = 9'b0000000;
    reg [$clog2(CLKS_PER_HALF_BIT*2)-1:0] r_SPI_count_clk;
    reg [4:0] r_SPI_count_pulse = 5'b00000;

    always @(posedge CLOCK)
    begin
        if (r_SPI_count_clk == CLKS_PER_HALF_BIT*2-1)
            begin
            r_SPI_CLK = ~r_SPI_CLK;        
        end
        else if ( r_SPI_count_clk == CLKS_PER_HALF_BIT-1)
            begin
            r_SPI_CLK = ~r_SPI_CLK;
            if( r_SPI_count_pulse >= 3)
            begin
                DATA_OUT[r_SPI_count_pulse - 3] <= DATA_IN;
            end
            r_SPI_count_pulse = r_SPI_count_pulse + 1'b1;
            end
        if(r_SPI_count_pulse > 0 && r_SPI_count_pulse < 16)
            begin
            r_CS <= 1'b0;
            end   
        if(r_SPI_count_pulse > 16)
            begin
            r_CS <= 1'b1;
            end
        if(r_SPI_count_pulse == 18)
            begin
            r_SPI_count_pulse = 4'b0000;
            end
        r_SPI_count_clk <= r_SPI_count_clk + 1'b1;
        if(r_CS == 1)
        begin
            if(count == 0)
            begin
                r_DV <= 1'b1;
            end
            else
            begin
                r_DV <= 1'b0;
            end
            count <= count + 1'b1;
        end
        else 
        begin
            count <= 0;
        end
    end

    always @(posedge CLOCK) 
    begin
        SCLK <= r_SPI_CLK;
        CS <= r_CS;
        DV <= r_DV;
        r_Data_in <= DATA_IN;
    end
endmodule
