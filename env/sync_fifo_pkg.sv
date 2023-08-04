/**********************************************************************************************************************
 *  FILE DESCRIPTION
 *  -------------------------------------------------------------------------------------------------------------------
 *  File:         sync_fifo_pkg.sv
 *
 *  Description:  
 * 
 *********************************************************************************************************************/

    `include "sync_fifo_defines.sv"
    `include "sync_fifo_if.sv"

    package sync_fifo_pkg;
        import uvm_pkg::*;
        `include "uvm_macros.svh"

        `include "sync_fifo_types.sv"
        `include "sync_fifo_seq_item.sv"
        `include "sync_fifo_reset_item.sv"
        `include "sync_fifo_seq_lib.sv"
        `include "sync_fifo_virtual_seq.sv"

        `include "sync_fifo_agent_config.sv"
        `include "sync_fifo_sequencer.sv"
        `include "sync_fifo_driver.sv"
        `include "sync_fifo_monitor.sv"
        `include "sync_fifo_agent.sv"

        `include "sync_fifo_reset_sequencer.sv"
        `include "sync_fifo_reset_driver.sv"
        `include "sync_fifo_reset_agent.sv"

        `include "sync_fifo_scoreboard.sv"
        `include "sync_fifo_subscriber.sv"
        `include "sync_fifo_env.sv"
        `include "sync_fifo_test.sv"
    endpackage

/**********************************************************************************************************************
*  END OF FILE: sync_fifo_pkg.sv
*********************************************************************************************************************/