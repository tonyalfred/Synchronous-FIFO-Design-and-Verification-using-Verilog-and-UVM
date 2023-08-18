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
      logic                     RST; 

      logic [`FIFO_WIDTH-1:0]   DATA_IN; 
      logic                     WR_EN;

      logic                     RD_EN; 
      logic [`FIFO_WIDTH-1:0]   DATA_OUT; 
      logic [`FIFO_PTR_WIDTH:0] CNTR;

      logic                     EMPTY;
      logic                     FULL;

      // Assertions
      // Active Low Asynchronous Reset
      property p_1;
        @(posedge CLK)
          (!RST -> (EMPTY == 1 && FULL == 0 && CNTR == 0));
      endproperty 
      a_1: assert property (p_1);

      // FIFO Full Conditions
      property p_2;
        @(posedge CLK) disable iff (!RST)
        (CNTR > (`FIFO_DEPTH - 1)) |-> FULL;
      endproperty 
      a_2: assert property (p_2);

      property p_3;
        @(posedge CLK) disable iff (!RST)
        (CNTR < `FIFO_DEPTH) |-> !FULL;
      endproperty 
      a_3: assert property (p_3);

      property p_4;
        @(posedge CLK) disable iff (!RST)
        ((CNTR == (`FIFO_DEPTH - 1) && WR_EN && !RD_EN) |=> FULL);
      endproperty 
      a_4: assert property (p_4);

      // FIFO Empty Conditions
      property p_5;
        @(posedge CLK) disable iff (!RST)
        ((CNTR == 0) |-> EMPTY);
      endproperty 
      a_5: assert property (p_5);

      property p_6;
        @(posedge CLK) disable iff (!RST)
        ((CNTR > 0) |-> !EMPTY);
      endproperty 
      a_6: assert property (p_6);

      property p_7;
        @(posedge CLK) disable iff (!RST)
        ((CNTR == 1 && !WR_EN && RD_EN) |=> EMPTY);
      endproperty 
      a_7: assert property (p_7);

      // Modports
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