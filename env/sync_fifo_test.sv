/**********************************************************************************************************************
 *  FILE DESCRIPTION
 *  -------------------------------------------------------------------------------------------------------------------
 *  File:         sync_fifo_test.sv
 *
 *  Description:  
 * 
 *********************************************************************************************************************/

  `ifndef SYNC_FIFO_TEST
    `define SYNC_FIFO_TEST

    class sync_fifo_base_test extends uvm_test;
      `uvm_component_utils(sync_fifo_base_test)

      sync_fifo_env m_env;
      sync_fifo_agent_config m_agt0_cfg;

      function new(string name = "sync_fifo_base_test", uvm_component parent = null);
        super.new(name,parent);
      endfunction

      function void build_phase (uvm_phase phase);
        super.build_phase(phase);

        m_env = sync_fifo_env::type_id::create("m_env",this);
        m_agt0_cfg = sync_fifo_agent_config::type_id::create("m_agt0_cfg");

        if(!(uvm_config_db #(virtual sync_fifo_if)::get(this,"","sync_fifo_if",m_agt0_cfg.m_vif)))
          `uvm_fatal(get_full_name(),"Error! sync_fifo_base_test failed to receive sync_fifo_if.")

        m_agt0_cfg.set_is_active(UVM_ACTIVE);

        uvm_config_db #(sync_fifo_agent_config)::set(this, "m_env.m_agent0*", "sync_fifo_agent_cfg", m_agt0_cfg);
        uvm_config_db #(sync_fifo_agent_config)::set(this, "m_env.m_reset_agent0*", "sync_fifo_agent_cfg", m_agt0_cfg);

        `uvm_info("BUILD_PHASE", "sync_fifo_base_test.", UVM_HIGH)
      endfunction

      function void connect_phase (uvm_phase phase);
        super.connect_phase(phase);
        `uvm_info("CONNECT_PHASE", "sync_fifo_base_test.", UVM_HIGH)
      endfunction

      function void init_vseq (sync_fifo_base_vseq vseq);
        vseq.m_sync_fifo_reset_seqr = m_env.m_reset_agent0.m_sequencer;
        vseq.m_sync_fifo_data_seqr  = m_env.m_agent0.m_sequencer;
      endfunction
    endclass
      
    class sync_fifo_test extends sync_fifo_base_test;
      `uvm_component_utils(sync_fifo_test)

      sync_fifo_vseq m_vseq;

      function new(string name = "sync_fifo_test", uvm_component parent = null);
        super.new(name,parent);
      endfunction

      function void build_phase (uvm_phase phase);
        super.build_phase(phase);
        `uvm_info("BUILD_PHASE", "sync_fifo_test.", UVM_HIGH)
      endfunction

      function void connect_phase (uvm_phase phase);
        super.connect_phase(phase);
        `uvm_info("CONNECT_PHASE", "sync_fifo_test.", UVM_HIGH)
      endfunction    

      task run_phase (uvm_phase phase);
        super.run_phase(phase);
        `uvm_info("RUN_PHASE", "sync_fifo_test.", UVM_HIGH)

        m_vseq = sync_fifo_vseq::type_id::create("m_vseq");
      
        phase.raise_objection(this);
        init_vseq(m_vseq);
        m_vseq.start(null);
        phase.drop_objection(this);
      endtask
    endclass 
  `endif

/**********************************************************************************************************************
*  END OF FILE: sync_fifo_test.sv
*********************************************************************************************************************/