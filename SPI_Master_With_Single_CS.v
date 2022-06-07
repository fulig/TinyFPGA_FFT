///////////////////////////////////////////////////////////////////////////////
// Description: SPI (Serial Peripheral Interface) Master
//              With single chip-select (AKA Slave Select) capability
//
//              Supports arbitrary length byte transfers.
// 
//              Instantiates a SPI Master and adds single CS.
//              If multiple CS signals are needed, will need to use different
//              module, OR multiplex the CS from this at a higher level.
//
// Note:        i_Clk must be at least 2x faster than i_SPI_Clk
//
// Parameters:  SPI_MODE, can be 0, 1, 2, or 3.  See above.
//              Can be configured in one of 4 modes:
//              Mode | Clock Polarity (CPOL/CKP) | Clock Phase (CPHA)
//               0   |             0             |        0
//               1   |             0             |        1
//               2   |             1             |        0
//               3   |             1             |        1
//
//              CLKS_PER_HALF_BIT - Sets frequency of o_SPI_Clk.  o_SPI_Clk is
//              derived from i_Clk.  Set to integer number of clocks for each
//              half-bit of SPI data.  E.g. 100 MHz i_Clk, CLKS_PER_HALF_BIT = 2
//              would create o_SPI_CLK of 25 MHz.  Must be >= 2
//
//              MAX_BYTES_PER_CS - Set to the maximum number of bytes that
//              will be sent during a single CS-low pulse.
// 
//              CS_INACTIVE_CLKS - Sets the amount of time in clock cycles to
//              hold the state of Chip-Selct high (inactive) before next 
//              command is allowed on the line.  Useful if chip requires some
//              time when CS is high between trasnfers.
///////////////////////////////////////////////////////////////////////////////

module SPI_Master_With_Single_CS
  #(parameter SPI_MODE = 0,
    parameter CLKS_PER_HALF_BIT = 2,
    parameter MAX_BYTES_PER_CS = 2,
    parameter CS_INACTIVE_CLKS = 1)
  (
   // Control/Data Signals,
   input        i_Rst_L,     // FPGA Reset
   input        i_Clk,       // FPGA Clock
   
   // TX (MOSI) Signals
   input [$clog2(MAX_BYTES_PER_CS+1)-1:0] i_TX_Count,  // # bytes per CS low
   input [15:0]  i_TX_Byte,       // Byte to transmit on MOSI
   input        i_TX_DV,         // Data Valid Pulse with i_TX_Byte
   output       o_TX_Ready,      // Transmit Ready for next byte
   
   // RX (MISO) Signals
   output reg [$clog2(MAX_BYTES_PER_CS+1)-1:0] o_RX_Count,  // Index RX byte
   output       o_RX_DV,     // Data Valid pulse (1 clock cycle)
   output [7:0] o_RX_Byte,   // Byte received on MISO

   // SPI Interface
   output o_SPI_Clk,
   input  i_SPI_MISO,
   output o_SPI_MOSI,
   output o_SPI_CS_n
   );

  localparam IDLE        = 2'b00;
  localparam START_TRANSFER    = 2'b01;
  localparam TRANSFER = 2'b10;
  localparam CS_INACTIVE = 2'b11;



  reg count = 1'b0;
  reg [7:0] data_0 = i_TX_Byte[15:8];
  reg [7:0] data_1 = i_TX_Byte[7:0];
  reg [1:0] r_SM_CS = IDLE;
  reg [7:0] internal_data;
  reg r_CS_n = 1'b1;
  reg [3:0] wait_idle = 4'b1000;
  reg [3:0] r_CS_Inactive_Count = 4'b0000;
  reg [1:0] r_TX_Count;
  wire w_Master_Ready;
  reg internal_DV = 1'b0;

  // Instantiate Master
  SPI_Master 
    #(.SPI_MODE(SPI_MODE),
      .CLKS_PER_HALF_BIT(CLKS_PER_HALF_BIT)
      ) SPI_Master_Inst
   (
   // Control/Data Signals,
   .i_Rst_L(i_Rst_L),     // FPGA Reset
   .i_Clk(i_Clk),         // FPGA Clock
   
   // TX (MOSI) Signals
   .i_TX_Byte(internal_data),         // Byte to transmit
   .i_TX_DV(internal_DV),             // Data Valid Pulse 
   .o_TX_Ready(w_Master_Ready),   // Transmit Ready for Byte
   
   // RX (MISO) Signals
   .o_RX_DV(),       // Data Valid pulse (1 clock cycle)
   .o_RX_Byte(o_RX_Byte),   // Byte received on MISO

   // SPI Interface
   .o_SPI_Clk(o_SPI_Clk),
   .i_SPI_MISO(i_SPI_MISO),
   .o_SPI_MOSI(o_SPI_MOSI)
   );


always @(posedge i_Clk)
begin
  case (r_SM_CS)
    IDLE:
        begin
          if (r_CS_n & i_TX_DV) // Start of transmission
          begin
            r_TX_Count <= 2'b11; // Register TX Count
            r_CS_n     <= 1'b0;       // Drive CS low
            internal_data <= data_0;
            internal_DV <= 1'b1;
            r_SM_CS    <= TRANSFER;   // Transfer bytes
          end
        end
    TRANSFER:
        begin
          // Wait until SPI is done transferring do next thing
          if (w_Master_Ready)
          begin
            if (r_TX_Count > 0)
            begin   
                internal_data <= data_1;
                internal_DV <= 1'b1;
                r_TX_Count <= r_TX_Count - 1'b1;
            end
            else
            begin
              r_CS_Inactive_Count <= CS_INACTIVE_CLKS;
              r_SM_CS             <= CS_INACTIVE;
            end // else: !if(r_TX_Count > 0)
          end // if (w_Master_Ready)
          internal_data <= i_TX_Byte[(r_TX_Count*8)-1:(r_TX_Count-1)*8];
          internal_DV <= 1'b0;
        end // case: TRANSFER
        CS_INACTIVE:
        begin
          if (r_CS_Inactive_Count > 0)
          begin
            r_CS_Inactive_Count <= r_CS_Inactive_Count - 1'b1;
          end
          else
          begin
            r_CS_n  <= 1'b1; // we done, so set CS high
            r_SM_CS <= IDLE;
          end
        end
  endcase
  /*case (r_SM_CS)
    IDLE : 
      begin
        if(i_TX_DV == 1)
        begin
          r_SM_CS <= START_TRANSFER;
        end
        r_CS_n <= 1'b1;
        internal_DV <= 1'b0;
        count <= 2'b10; 
      end
    START_TRANSFER : 
      begin
        if(count > 0)
        begin
          r_CS_n <= 1'b0;   
          internal_data = i_TX_Byte[(count*8)-1:(count-1)*8];
          internal_DV <= 1'b1;
          count <= count - 1'b1;
          r_SM_CS <= TRANSFER;
        end
        else
        begin
          r_SM_CS <= IDLE;
        end
      end
    TRANSFER : 
      begin
        if(w_Master_Ready)
        begin
          r_SM_CS <= START_TRANSFER;
        end
        else
        begin
          r_SM_CS <= IDLE;
        end
      end
      default : 
      begin 
        internal_DV <= 1'b0;
        count <= 2'b10; 
        r_CS_n <= 1'b1;
        r_SM_CS <= IDLE;
      end
  endcase // r_SM_CS*/
end


assign o_SPI_CS_n = r_CS_n ;
  

endmodule // SPI_Master_With_Single_CS

