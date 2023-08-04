/**********************************************************************************************************************
 *  FILE DESCRIPTION
 *  -------------------------------------------------------------------------------------------------------------------
 *  File:         sync_fifo_seq_item.sv
 *
 *  Description:  
 * 
 *********************************************************************************************************************/

  `ifndef SYNC_FIFO_SEQ_ITEM
    `define SYNC_FIFO_SEQ_ITEM

    class sync_fifo_seq_item extends uvm_sequence_item;
      `uvm_object_utils(sync_fifo_seq_item)

      rand sync_fifo_transaction_type_t m_txn_type;
      rand logic [`FIFO_WIDTH-1:0]      m_data_in;

      logic                   m_full;
      logic                   m_empty;
      logic [`FIFO_WIDTH-1:0] m_data_out;
          
      function new(string name = "");
        super.new(name);
      endfunction

      function void do_copy(uvm_object rhs);
        sync_fifo_seq_item lhs;
        $cast(lhs, rhs);
        super.do_copy(rhs);
        m_txn_type = lhs.m_txn_type;
        m_data_in  = lhs.m_data_in;
        m_full     = lhs.m_full;
        m_empty    = lhs.m_empty;
        m_data_out = lhs.m_data_out;
      endfunction
    endclass 
  `endif

/**********************************************************************************************************************
*  END OF FILE: sync_fifo_seq_item.sv
*********************************************************************************************************************/