/**********************************************************************************************************************
 *  FILE DESCRIPTION
 *  -------------------------------------------------------------------------------------------------------------------
 *  File:         sync_fifo_env.sv
 *
 *  Description:  
 * 
 *********************************************************************************************************************/

  `ifndef SYNC_FIFO_ENV
    `define SYNC_FIFO_ENV

    class sync_fifo_env extends uvm_env;
      `uvm_component_utils(sync_fifo_env)

      sync_fifo_agent       m_agent0;
      sync_fifo_reset_agent m_reset_agent0;
      sync_fifo_scoreboard  m_scb;
      sync_fifo_subscriber  m_sub;

      virtual sync_fifo_if m_vif;

      function new(string name = "sync_fifo_env", uvm_component parent = null);
        super.new(name,parent);
      endfunction

      function void build_phase (uvm_phase phase);
        super.build_phase(phase);

        m_agent0 = sync_fifo_agent::type_id::create("m_agent0",this);
        m_reset_agent0 = sync_fifo_reset_agent::type_id::create("m_reset_agent0",this);
        m_scb = sync_fifo_scoreboard::type_id::create("m_scb",this);
        m_sub = sync_fifo_subscriber::type_id::create("m_sub",this);

        `uvm_info("BUILD_PHASE", "sync_fifo_env.", UVM_HIGH)
      endfunction
      
      function void connect_phase (uvm_phase phase);
        super.connect_phase(phase);

        m_agent0.m_in_port.connect(m_scb.m_in_export);
        m_agent0.m_out_port.connect(m_scb.m_out_export);
        m_agent0.m_in_port.connect(m_sub.analysis_export);

        `uvm_info("CONNECT_PHASE", "sync_fifo_env.", UVM_HIGH)
      endfunction
    endclass 
  `endif

/**********************************************************************************************************************
*  END OF FILE: sync_fifo_env.sv
*********************************************************************************************************************/