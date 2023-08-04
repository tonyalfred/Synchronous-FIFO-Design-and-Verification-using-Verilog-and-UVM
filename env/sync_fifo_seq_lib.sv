/**********************************************************************************************************************
 *  FILE DESCRIPTION
 *  -------------------------------------------------------------------------------------------------------------------
 *  File:         sync_fifo_seq_lib.sv
 *
 *  Description:  
 * 
 *********************************************************************************************************************/

  `ifndef SYNC_FIFO_SEQUENCE_LIB
    `define SYNC_FIFO_SEQUENCE_LIB

    ///////////////////////////////////////////////////////////////
    ////////////////// RESET AGENT SEQUENCES //////////////////////
    ///////////////////////////////////////////////////////////////

      class sync_fifo_reset_seq extends uvm_sequence;
        `uvm_object_utils(sync_fifo_reset_seq)

        sync_fifo_reset_item m_item;

        function new (string name = "sync_fifo_reset_seq");
          super.new(name);
        endfunction

        task body;
          m_item = sync_fifo_reset_item::type_id::create("m_item");
          start_item(m_item);

          assert (m_item.randomize())
          else `uvm_fatal("RESET SEQUENCE", "randomization failed.");

          finish_item(m_item);
        endtask

        task post_body;
          `uvm_info("RESET SEQUENCE", "sequence finished.", UVM_HIGH)
        endtask
      endclass    

    ///////////////////////////////////////////////////////////////
    /////////////////// DATA AGENT SEQUENCES //////////////////////
    ///////////////////////////////////////////////////////////////
      
    class sync_fifo_base_seq extends uvm_sequence;
      `uvm_object_utils(sync_fifo_base_seq)

      sync_fifo_seq_item m_item;

      function new (string name = "");
        super.new(name);
      endfunction

      task post_body;
        `uvm_info("SEQUENCE", "sequence finished.", UVM_HIGH)
      endtask
    endclass

    // write FIFO from empty to full -> read FIFO from full to empty
    class sync_fifo_full_empty_seq extends sync_fifo_base_seq;
      `uvm_object_utils(sync_fifo_full_empty_seq)

      task body; 
        for (int i = 0; i < (`FIFO_DEPTH * 2); i++) begin
          m_item = sync_fifo_seq_item::type_id::create("m_item");
          start_item(m_item);

          if (i < `FIFO_DEPTH) begin
            assert (m_item.randomize() with { 
                    m_item.m_txn_type == WRITE; 
                    }) 
            else `uvm_fatal("SEQUENCE", "randomization failed.");
          end 
          else begin
            assert (m_item.randomize() with { 
                    m_item.m_txn_type == READ; 
                    }) 
            else `uvm_fatal("SEQUENCE", "randomization failed.");
          end

          finish_item(m_item);
        end 
      endtask
    endclass

    // Write FIFO from empty to half-full, and then read/write at the same time
    class sync_fifo_half_full_rw_seq extends sync_fifo_base_seq;
      `uvm_object_utils(sync_fifo_half_full_rw_seq)

      task body; 
        for (int i = 0; i < (`FIFO_DEPTH); i++) begin
          m_item = sync_fifo_seq_item::type_id::create("m_item");
          start_item(m_item);

          if (i < (`FIFO_DEPTH / 2)) begin
            assert (m_item.randomize() with { 
                    m_item.m_txn_type == WRITE; 
                    }) 
            else `uvm_fatal("SEQUENCE", "randomization failed.");
          end 
          else begin
            assert (m_item.randomize() with { 
                    m_item.m_txn_type == WRITE_READ; 
                    }) 
            else `uvm_fatal("SEQUENCE", "randomization failed.");
          end

          finish_item(m_item);
        end 
      endtask
    endclass

    // random sequence
    class sync_fifo_random_seq extends sync_fifo_base_seq;
      `uvm_object_utils(sync_fifo_random_seq)

      task body; 
        m_item = sync_fifo_seq_item::type_id::create("m_item");
        for (int i = 0; i < (`FIFO_DEPTH * 4); i++) begin
          start_item(m_item);

          assert (m_item.randomize() with { 
                  m_item.m_txn_type == WRITE; 
                  }) 
          else `uvm_fatal("SEQUENCE", "randomization failed.");

          finish_item(m_item);
        end 
      endtask
    endclass       
  `endif

/**********************************************************************************************************************
*  END OF FILE: sync_fifo_seq_lib.sv
*********************************************************************************************************************/