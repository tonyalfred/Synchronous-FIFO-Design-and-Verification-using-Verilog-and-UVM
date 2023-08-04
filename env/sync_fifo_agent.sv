/**********************************************************************************************************************
 *  FILE DESCRIPTION
 *  -------------------------------------------------------------------------------------------------------------------
 *  File:         sync_fifo_agent.sv
 *
 *  Description:  
 * 
 *********************************************************************************************************************/

  `ifndef SYNC_FIFO_AGENT
    `define SYNC_FIFO_AGENT

    class sync_fifo_agent extends uvm_agent;
      `uvm_component_utils (sync_fifo_agent)
      
      sync_fifo_sequencer m_sequencer;
      sync_fifo_driver    m_driver;
      sync_fifo_monitor   m_monitor;
      
      sync_fifo_agent_config m_cfg;

      uvm_analysis_port #(sync_fifo_seq_item) m_in_port;
      uvm_analysis_port #(sync_fifo_seq_item) m_out_port; 
      
      function new(string name = "sync_fifo_agent", uvm_component parent = null);
        super.new(name, parent);
      endfunction
      
      function void build_phase (uvm_phase phase);
        super.build_phase (phase);

        if(!(uvm_config_db#(sync_fifo_agent_config)::get(this,"","sync_fifo_agent_cfg",m_cfg)))
          `uvm_fatal(get_full_name(),"Error! sync_fifo_agent failed to receive m_cfg.")

        m_monitor   = sync_fifo_monitor::type_id::create("m_monitor",this);

        if (m_cfg.get_is_active() == UVM_ACTIVE) begin
          m_sequencer = sync_fifo_sequencer::type_id::create("m_sequencer",this);
          m_driver = sync_fifo_driver::type_id::create("m_driver",this);
        end

        uvm_config_db #(sync_fifo_agent_config)::set(this,"m_driver","sync_fifo_agent_cfg",m_cfg);
        uvm_config_db #(sync_fifo_agent_config)::set(this,"m_monitor","sync_fifo_agent_cfg",m_cfg);
            
        m_in_port = new ("m_in_port",this);
        m_out_port = new ("m_out_port",this);

        `uvm_info("BUILD_PHASE", "sync_fifo_agent.", UVM_HIGH)
      endfunction
        
      function void connect_phase (uvm_phase phase);
        super.connect_phase(phase);
        
        m_monitor.m_in_port.connect(m_in_port);
        m_monitor.m_out_port.connect(m_out_port);

        if (m_cfg.get_is_active() == UVM_ACTIVE) begin
          m_driver.seq_item_port.connect(m_sequencer.seq_item_export);
        end

        `uvm_info("CONNECT_PHASE", "sync_fifo_agent.", UVM_HIGH)
      endfunction

      task run_phase (uvm_phase phase);
        super.run_phase(phase);
        `uvm_info("RUN_PHASE", "sync_fifo_agent.", UVM_HIGH)
      endtask
    endclass 
  `endif

/**********************************************************************************************************************
*  END OF FILE: sync_fifo_agent.sv
*********************************************************************************************************************/