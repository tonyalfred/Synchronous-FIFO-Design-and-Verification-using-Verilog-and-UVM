/**********************************************************************************************************************
 *  FILE DESCRIPTION
 *  -------------------------------------------------------------------------------------------------------------------
 *  File:         sync_fifo_subscriber.sv
 *
 *  Description:  
 * 
 *********************************************************************************************************************/

  `ifndef SYNC_FIFO_SUBSCRIBER
    `define SYNC_FIFO_SUBSCRIBER

    class sync_fifo_subscriber extends uvm_subscriber #(sync_fifo_seq_item);
      `uvm_component_utils(sync_fifo_subscriber)

      sync_fifo_seq_item m_item;

      covergroup sync_fifo_cov_grp;
        cp_txn     : coverpoint m_item.m_txn_type;
        cp_txn_trns: coverpoint m_item.m_txn_type 
                    {bins b1[] = (READ, WRITE, WRITE_READ => 
                                  READ, WRITE, WRITE_READ);}
      endgroup 

      function new(string name = "sync_fifo_subscriber", uvm_component parent = null);
        super.new(name,parent);
        sync_fifo_cov_grp = new();
      endfunction

      function void build_phase (uvm_phase phase);
        super.build_phase(phase);
        `uvm_info("BUILD_PHASE", "sync_fifo_subscriber.", UVM_HIGH)
      endfunction

      function void write (sync_fifo_seq_item t);
        m_item = t; 
        sync_fifo_cov_grp.sample();
      endfunction
    endclass 
  `endif

/**********************************************************************************************************************
*  END OF FILE: sync_fifo_subscriber.sv
*********************************************************************************************************************/