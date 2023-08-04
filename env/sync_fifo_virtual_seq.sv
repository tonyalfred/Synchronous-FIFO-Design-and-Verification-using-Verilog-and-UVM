/**********************************************************************************************************************
 *  FILE DESCRIPTION
 *  -------------------------------------------------------------------------------------------------------------------
 *  File:         sync_fifo_virtual_seq.sv
 *
 *  Description:  
 * 
 *********************************************************************************************************************/

  `ifndef SYNC_FIFO_VIRTUAL_SEQ
    `define SYNC_FIFO_VIRTUAL_SEQ

    class sync_fifo_base_vseq extends uvm_sequence #(uvm_sequence_item);
      `uvm_object_utils(sync_fifo_base_vseq)

      uvm_sequencer #(sync_fifo_seq_item)   m_sync_fifo_data_seqr;
      uvm_sequencer #(sync_fifo_reset_item) m_sync_fifo_reset_seqr;

      function new (string name = "sync_fifo_base_vseq");
        super.new(name);
      endfunction
    endclass

    class sync_fifo_vseq extends sync_fifo_base_vseq;
      `uvm_object_utils(sync_fifo_vseq)

      function new (string name = "sync_fifo_vseq");
        super.new(name);
      endfunction
      
      task body ();
        sync_fifo_reset_seq m_reset_seq = sync_fifo_reset_seq::type_id::create("m_reset_seq");
        sync_fifo_full_empty_seq m_full_empty_seq  = sync_fifo_full_empty_seq::type_id::create("m_full_empty_seq");
        sync_fifo_half_full_rw_seq m_half_full_rw_seq = sync_fifo_half_full_rw_seq::type_id::create("m_half_full_rw_seq");
        sync_fifo_random_seq m_rand_seq = sync_fifo_random_seq::type_id::create("m_rand_seq");

        m_reset_seq.start(m_sync_fifo_reset_seqr); 
        m_full_empty_seq.start(m_sync_fifo_data_seqr);
        m_half_full_rw_seq.start(m_sync_fifo_data_seqr);
      endtask
    endclass
  `endif

/**********************************************************************************************************************
*  END OF FILE: sync_fifo_virtual_seq.sv
*********************************************************************************************************************/