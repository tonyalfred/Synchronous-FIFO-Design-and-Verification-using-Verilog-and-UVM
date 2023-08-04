/**********************************************************************************************************************
 *  FILE DESCRIPTION
 *  -------------------------------------------------------------------------------------------------------------------
 *  File:         sync_fifo_driver.sv
 *
 *  Description:  
 * 
 *********************************************************************************************************************/

  `ifndef SYNC_FIFO_DRIVER
    `define SYNC_FIFO_DRIVER

    class sync_fifo_driver extends uvm_driver #(sync_fifo_seq_item);
      `uvm_component_utils(sync_fifo_driver)

      sync_fifo_seq_item m_item;

      sync_fifo_agent_config m_cfg;
      virtual sync_fifo_if m_vif;

      function new(string name = "sync_fifo_driver", uvm_component parent = null);
        super.new(name,parent);
      endfunction

      function void build_phase (uvm_phase phase);
        super.build_phase(phase);

        if(!(uvm_config_db#(sync_fifo_agent_config)::get(this,"","sync_fifo_agent_cfg",m_cfg)))
          `uvm_fatal(get_full_name(),"Error! sync_fifo_driver failed to receive m_cfg.")
        
        `uvm_info("BUILD_PHASE", "sync_fifo_driver.", UVM_HIGH)
      endfunction

      function void connect_phase (uvm_phase phase);
        super.connect_phase(phase);

        m_vif = m_cfg.m_vif;

        `uvm_info("CONNECT_PHASE", "sync_fifo_driver.", UVM_HIGH)
      endfunction

      task run_phase (uvm_phase phase);
        super.run_phase(phase);
        `uvm_info("RUN_PHASE", "sync_fifo_driver.", UVM_HIGH)

        reset_inputs ();

        forever begin
          seq_item_port.get_next_item(m_item);
          drive_transaction(m_item);
          seq_item_port.item_done();
        end
      endtask

      task drive_transaction(sync_fifo_seq_item item);
        @(posedge m_vif.CLK)
        case (item.m_txn_type)
          WRITE     : drive_write_cmd      (item);
          READ      : drive_read_cmd       ();
          WRITE_READ: drive_write_read_cmd (item);
          EMPTY     : reset_inputs         ();
          default   : reset_inputs         ();
        endcase
      endtask

      task drive_write_cmd (sync_fifo_seq_item item);
        m_vif.RD_EN   <= 1'b0;
        m_vif.WR_EN   <= 1'b1;
        m_vif.DATA_IN <= item.m_data_in;
      endtask

      task drive_read_cmd ();
        m_vif.RD_EN   <= 1'b1;
        m_vif.WR_EN   <= 1'b0;
        m_vif.DATA_IN <= `FIFO_WIDTH'd0;
      endtask

      task drive_write_read_cmd (sync_fifo_seq_item item);
        m_vif.RD_EN   <= 1'b1;
        m_vif.WR_EN   <= 1'b1;
        m_vif.DATA_IN <= item.m_data_in;
      endtask

      task reset_inputs ();
        m_vif.RD_EN   <= 1'b0;
        m_vif.WR_EN   <= 1'b0;
        m_vif.DATA_IN <= `FIFO_WIDTH'd0;
      endtask
    endclass 
  `endif

/**********************************************************************************************************************
*  END OF FILE: sync_fifo_driver.sv
*********************************************************************************************************************/