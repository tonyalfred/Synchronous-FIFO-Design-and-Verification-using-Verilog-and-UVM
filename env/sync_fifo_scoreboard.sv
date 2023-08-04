/**********************************************************************************************************************
 *  FILE DESCRIPTION
 *  -------------------------------------------------------------------------------------------------------------------
 *  File:         sync_fifo_scoreboard.sv
 *
 *  Description:  
 * 
 *********************************************************************************************************************/

  `ifndef SYNC_FIFO_SCOREBOARD
    `define SYNC_FIFO_SCOREBOARD

    class sync_fifo_scoreboard extends uvm_scoreboard;
      `uvm_component_utils(sync_fifo_scoreboard)

      sync_fifo_seq_item m_in_item;
      sync_fifo_seq_item m_out_item;

      uvm_analysis_export #(sync_fifo_seq_item) m_in_export;
      uvm_analysis_export #(sync_fifo_seq_item) m_out_export;

      uvm_tlm_analysis_fifo #(sync_fifo_seq_item) m_in_fifo; 
      uvm_tlm_analysis_fifo #(sync_fifo_seq_item) m_out_fifo; 

      logic [`FIFO_WIDTH-1:0] fifo_reg [$:`FIFO_DEPTH-1];

      function new(string name = "sync_fifo_scoreboard", uvm_component parent = null);
        super.new(name,parent);
      endfunction

      function void build_phase (uvm_phase phase);
        super.build_phase(phase);

        m_in_export = new ("m_in_export",this);
        m_out_export = new ("m_out_export",this);
        
        m_in_fifo   = new ("m_in_fifo",this);
        m_out_fifo   = new ("m_out_fifo",this);

        `uvm_info("BUILD_PHASE", "sync_fifo_scoreboard.", UVM_HIGH)
      endfunction

      function void connect_phase (uvm_phase phase);
        super.connect_phase(phase);

        m_in_export.connect(m_in_fifo.analysis_export);
        m_out_export.connect(m_out_fifo.analysis_export);

        `uvm_info("CONNECT_PHASE", "sync_fifo_scoreboard.", UVM_HIGH)
      endfunction

      task run_phase (uvm_phase phase);
        super.run_phase(phase);
        `uvm_info("RUN_PHASE", "sync_fifo_scoreboard.", UVM_HIGH)

        forever begin         
          m_in_fifo.get(m_in_item);
          m_out_fifo.get(m_out_item);
          ref_model ();
        end
      endtask

      function void ref_model ();
        case (m_in_item.m_txn_type)
          WRITE     : ref_model_write_cmd      ();
          READ      : ref_model_read_cmd       ();
          WRITE_READ: ref_model_write_read_cmd ();
          default   : begin end
        endcase      
      endfunction

      function void ref_model_write_cmd ();
        if (fifo_reg.size() == `FIFO_DEPTH) begin
          if (m_out_item.m_full == 0) begin
            `uvm_error ("SCB_ERR", "Error! Full Flag not raised.") 
          end         
        end else begin
          fifo_reg.push_back (m_in_item.m_data_in);
        end
      endfunction

      function void ref_model_read_cmd ();
        if (fifo_reg.size() == 0) begin
          if (m_out_item.m_empty == 0) begin
            `uvm_error ("SCB_ERR", "Error! Empty Flag not raised.") 
          end         
        end else begin
          if (fifo_reg.pop_front() != m_out_item.m_data_out)
            `uvm_error ("SCB_ERR", "Error! Poped Data not valid.") 
        end
      endfunction

      function void ref_model_write_read_cmd ();
        ref_model_read_cmd  ();
        ref_model_write_cmd ();
      endfunction
    endclass 
  `endif

/**********************************************************************************************************************
*  END OF FILE: sync_fifo_scoreboard.sv
*********************************************************************************************************************/