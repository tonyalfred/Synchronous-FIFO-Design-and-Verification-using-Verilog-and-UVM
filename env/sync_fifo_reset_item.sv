/**********************************************************************************************************************
 *  FILE DESCRIPTION
 *  -------------------------------------------------------------------------------------------------------------------
 *  File:         sync_fifo_reset_item.sv
 *
 *  Description:  
 * 
 *********************************************************************************************************************/

  `ifndef SYNC_FIFO_RESET_ITEM
    `define SYNC_FIFO_RESET_ITEM

    class sync_fifo_reset_item extends uvm_sequence_item;
      `uvm_object_utils(sync_fifo_reset_item)

      rand logic [7:0] cycles;

      constraint c_clock_cycles {cycles inside {[2:5]};}

      function new(string name = "sync_fifo_reset_item");
        super.new(name);
      endfunction
    endclass 
  `endif

/**********************************************************************************************************************
*  END OF FILE: sync_fifo_reset_item.sv
*********************************************************************************************************************/