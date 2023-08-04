/**********************************************************************************************************************
 *  FILE DESCRIPTION
 *  -------------------------------------------------------------------------------------------------------------------
 *  File:         sync_fifo_if.sv
 *
 *  Description:  
 * 
 *********************************************************************************************************************/

  `ifndef SYNC_FIFO_IF 
    `define SYNC_FIFO_IF

    interface sync_fifo_if (input CLK);
      logic                   RST; 

      logic [`FIFO_WIDTH-1:0] DATA_IN; 
      logic                   WR_EN;

      logic                   RD_EN; 
      logic [`FIFO_WIDTH-1:0] DATA_OUT; 

      logic                   EMPTY;
      logic                   FULL;

      modport tb (
        input DATA_OUT, EMPTY, FULL,
        output DATA_IN, WR_EN, RD_EN 
      );

      modport dut (
        input DATA_IN, WR_EN, RD_EN, 
        output DATA_OUT, EMPTY, FULL
      );
    endinterface 
  `endif

/**********************************************************************************************************************
*  END OF FILE: sync_fifo_if.sv
*********************************************************************************************************************/