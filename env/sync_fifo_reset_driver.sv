/**********************************************************************************************************************
 *  FILE DESCRIPTION
 *  -------------------------------------------------------------------------------------------------------------------
 *  File:         sync_fifo_reset_driver.sv
 *
 *  Description:  
 * 
 *********************************************************************************************************************/

  `ifndef SYNC_FIFO_RESET_DRIVER
    `define SYNC_FIFO_RESET_DRIVER

    class sync_fifo_reset_driver extends uvm_driver #(sync_fifo_reset_item);
      `uvm_component_utils(sync_fifo_reset_driver)

      sync_fifo_reset_item m_item;

      sync_fifo_agent_config m_cfg;
      virtual sync_fifo_if m_vif;

      function new(string name = "sync_fifo_reset_driver", uvm_component parent = null);
        super.new(name,parent);
      endfunction

      function void build_phase (uvm_phase phase);
        super.build_phase(phase);

        if(!(uvm_config_db#(sync_fifo_agent_config)::get(this,"","sync_fifo_agent_cfg",m_cfg)))
          `uvm_fatal(get_full_name(),"Error! sync_fifo_reset_driver failed to receive m_cfg.")
        
        `uvm_info("BUILD_PHASE", "sync_fifo_reset_driver.", UVM_HIGH)
      endfunction

      function void connect_phase (uvm_phase phase);
        super.connect_phase(phase);

        m_vif = m_cfg.m_vif;

        `uvm_info("CONNECT_PHASE", "sync_fifo_reset_driver.", UVM_HIGH)
      endfunction

      task run_phase (uvm_phase phase);
        super.run_phase(phase);
        `uvm_info("RUN_PHASE", "sync_fifo_reset_driver.", UVM_HIGH)

        forever begin
          seq_item_port.get_next_item(m_item);
          reset (m_item);
          seq_item_port.item_done();
        end
      endtask

      task reset(sync_fifo_reset_item item);
        m_vif.RST <= 1'b1;
        @ (posedge m_vif.CLK);
        m_vif.RST <= 1'b0;
        repeat (item.cycles) @ (posedge m_vif.CLK);
        m_vif.RST <= 1'b1;
      endtask
    endclass 
  `endif

/**********************************************************************************************************************
*  END OF FILE: sync_fifo_reset_driver.sv
*********************************************************************************************************************/