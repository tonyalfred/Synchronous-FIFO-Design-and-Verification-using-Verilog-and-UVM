/**********************************************************************************************************************
 *  FILE DESCRIPTION
 *  -------------------------------------------------------------------------------------------------------------------
 *  File:         sync_fifo_reset_sequencer.sv
 *
 *  Description:  
 * 
 *********************************************************************************************************************/

  `ifndef SYNC_FIFO_RESET_SEQUENCER
    `define SYNC_FIFO_RESET_SEQUENCER

    class sync_fifo_reset_sequencer extends uvm_sequencer #(sync_fifo_reset_item);
      `uvm_component_utils(sync_fifo_reset_sequencer)

      function new(string name = "sync_fifo_reset_sequencer", uvm_component parent = null);
        super.new(name,parent);
      endfunction
      
      function void build_phase (uvm_phase phase);
        super.build_phase(phase);
        `uvm_info("BUILD_PHASE", "sync_fifo_reset_sequencer.", UVM_HIGH)
      endfunction

      function void connect_phase (uvm_phase phase);
        super.connect_phase(phase);
        `uvm_info("CONNECT_PHASE", "sync_fifo_reset_sequencer.", UVM_HIGH)
      endfunction

      task run_phase (uvm_phase phase);
        super.run_phase(phase);
        `uvm_info("RUN_PHASE", "sync_fifo_reset_sequencer.", UVM_HIGH)
      endtask
    endclass 
  `endif

/**********************************************************************************************************************
*  END OF FILE: sync_fifo_reset_sequencer.sv
*********************************************************************************************************************/