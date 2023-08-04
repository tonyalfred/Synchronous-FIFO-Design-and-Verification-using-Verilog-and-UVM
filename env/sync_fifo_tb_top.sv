/**********************************************************************************************************************
 *  FILE DESCRIPTION
 *  -------------------------------------------------------------------------------------------------------------------
 *  File:         tb_top.sv
 *
 *  Description:  
 * 
 *********************************************************************************************************************/
 
  `include "uvm_macros.svh"
  `include "sync_fifo_pkg.sv"

  module tb_top;
    import uvm_pkg::*;
    import sync_fifo_pkg::*;

    localparam CLK_PERIOD = 5;
    bit        CLK;

    sync_fifo_if if0 (CLK);

    sync_fifo #
    (
      .WIDTH    (`FIFO_WIDTH),
      .DEPTH    (`FIFO_DEPTH)
    ) fifo
    (
      .CLK      (CLK),
      .RST      (if0.RST),
      .WR_EN    (if0.WR_EN),
      .DATA_IN  (if0.DATA_IN),

      .RD_EN    (if0.RD_EN), 
      .DATA_OUT (if0.DATA_OUT),
      
      .FULL     (if0.FULL),
      .EMPTY    (if0.EMPTY)
    );

    initial begin
        CLK = 1;
        forever #(CLK_PERIOD/2) CLK = ~ CLK;
    end

    initial begin
        if0.RST = 1'b1;
        # (CLK_PERIOD/8) if0.RST = 1'b0;
        # (CLK_PERIOD/8) if0.RST = 1'b1;
    end

    initial begin 
      uvm_config_db #(virtual sync_fifo_if)::set(null,"uvm_test_top","sync_fifo_if",if0);
      run_test("sync_fifo_test");
    end 
  endmodule 

/**********************************************************************************************************************
*  END OF FILE: tb_top.sv
*********************************************************************************************************************/