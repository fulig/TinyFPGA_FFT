// look in pins.pcf for all the pin names on the TinyFPGA BX board
module ADC_SPI #(parameter CLKS_PER_HALF_BIT = 2,
                 parameter NUMBER_OF_BITS = 8)
    (
    input clk,        // FPGA Clock
    input data_in,         // Data input
    input sample,           // Start getting data
    output reg CS,          // CS
    output reg SCLK,        // SCLK
    output reg [NUMBER_OF_BITS-1:0] DATA_OUT, // data output
    output reg DV           // data valid output
);


    localparam IDLE = 1'b0;
    localparam GET_DATA= 1'b1;

    reg r_case = IDLE;

    reg [8:0]count = 9'b0000000; // an parameter anpassen
    wire [NUMBER_OF_BITS-1:0] w_data_o;

    shift_reg shift_out
    (   .d(data_in),
        .en(CS),
        .clk(SCLK),
        .out(w_data_o[NUMBER_OF_BITS-1:0])
        );

    initial begin
    SCLK <= 1'b1;
    CS <= 1'b1;
    end

    always @(posedge clk)
    begin
    case (r_case)    
        IDLE :
        begin
            if(sample == 1)
            begin
                r_case <= GET_DATA;
            end
            else
            begin
                DV <= 1'b0;  
                count <= 1'b0;
                SCLK <= 1'b0;
                CS <= 1'b1;
            end
        end
        GET_DATA : 
            begin  
                if(count > 1)
                    begin
                    if(count % CLKS_PER_HALF_BIT == 0)
                        SCLK <= ~SCLK;
                    end
                if(count == CLKS_PER_HALF_BIT*NUMBER_OF_BITS*2 + CLKS_PER_HALF_BIT*2*2)
                    begin
                        DV <= 1'b1;
                        CS <= 1'b1;
                        SCLK <= 1'b0;
                        r_case <= IDLE;        
                    end
                CS <= 1'b0;        
                count <= count + 1'b1;
                DATA_OUT <= w_data_o;
            end
        default :
            begin
                CS <= 1'b1;
                SCLK <= 0;
                r_case <= IDLE;
            end
    endcase
    end
endmodule
