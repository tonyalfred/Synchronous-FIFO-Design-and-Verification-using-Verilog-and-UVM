/**********************************************************************************************************************
 *  FILE DESCRIPTION
 *  -------------------------------------------------------------------------------------------------------------------
 *  File:         sync_fifo_monitor.sv
 *
 *  Description:  
 * 
 *********************************************************************************************************************/

  `ifndef SYNC_FIFO_MONITOR
    `define SYNC_FIFO_MONITOR
    
    class sync_fifo_monitor extends uvm_monitor;
      `uvm_component_utils(sync_fifo_monitor)

      sync_fifo_seq_item m_in_item;
      sync_fifo_seq_item m_out_item_1, m_out_item_2;

      sync_fifo_seq_item m_in_cloned_item;
      sync_fifo_seq_item m_out_cloned_item_1, m_out_cloned_item_2;

      int enable = 0;

      sync_fifo_agent_config m_cfg;
      virtual sync_fifo_if m_vif;

      uvm_analysis_port #(sync_fifo_seq_item) m_in_port; 
      uvm_analysis_port #(sync_fifo_seq_item) m_out_port; 
      
      function new(string name = "sync_fifo_monitor", uvm_component parent = null);
        super.new(name,parent);
      endfunction

      function void build_phase (uvm_phase phase);
        super.build_phase(phase);

        if(!(uvm_config_db#(sync_fifo_agent_config)::get(this,"","sync_fifo_agent_cfg",m_cfg)))
          `uvm_fatal(get_full_name(),"Error! sync_fifo_monitor failed to receive m_cfg.")

        m_in_port  = new("m_in_port",this);
        m_out_port = new("m_out_port",this);

        `uvm_info("BUILD_PHASE", "sync_fifo_monitor.", UVM_HIGH)
      endfunction
      
      function void connect_phase (uvm_phase phase);
        super.connect_phase(phase);

        m_vif = m_cfg.m_vif;

        `uvm_info("CONNECT_PHASE", "sync_fifo_monitor.", UVM_HIGH)
      endfunction

      task run_phase (uvm_phase phase);
        super.run_phase(phase);
        `uvm_info("RUN_PHASE", "sync_fifo_monitor.", UVM_HIGH)

        forever begin
          fork 
            collect_input  ();
            collect_output ();
            collect_output_overlapping ();
          join
        end
      endtask

      task collect_input ();
        forever begin
          m_in_item  = sync_fifo_seq_item::type_id::create("m_in_item");
          @ (posedge m_vif.CLK)
          case ({m_vif.WR_EN, m_vif.RD_EN})
            2'b01  : 
              begin
                m_in_item.m_txn_type = READ;
              end
            2'b10  : 
              begin
                m_in_item.m_txn_type = WRITE;
                m_in_item.m_data_in  = m_vif.DATA_IN;
              end
            2'b11  :
              begin
                m_in_item.m_txn_type = WRITE_READ;
                m_in_item.m_data_in  = m_vif.DATA_IN;
              end
            default: begin continue; end
          endcase
          $cast(m_in_cloned_item, m_in_item.clone());
          m_in_port.write(m_in_cloned_item);
        end
      endtask

      task collect_output ();
        forever begin
          m_out_item_1 = sync_fifo_seq_item::type_id::create("m_out_item_1");

          @ (posedge m_vif.CLK)

          enable = 1;

          case ({m_vif.WR_EN, m_vif.RD_EN})
            2'b01  : m_out_item_1.m_txn_type = READ;
            2'b10  : m_out_item_1.m_txn_type = WRITE;
            2'b11  : m_out_item_1.m_txn_type = WRITE_READ;
            default: begin  @ (posedge m_vif.CLK) continue; end
          endcase

          @ (posedge m_vif.CLK)
            m_out_item_1.m_empty    = m_vif.EMPTY;
            m_out_item_1.m_data_out = m_vif.DATA_OUT;
            m_out_item_1.m_full     = m_vif.FULL;

          $cast(m_out_cloned_item_1, m_out_item_1.clone());
          m_out_port.write (m_out_cloned_item_1);
        end
      endtask

      task collect_output_overlapping ();
        forever begin
          wait (enable == 1);

          enable = 0;

          m_out_item_2 = sync_fifo_seq_item::type_id::create("m_out_item_2");
          @ (posedge m_vif.CLK)
          
          case ({m_vif.WR_EN, m_vif.RD_EN})
            2'b01  : m_out_item_2.m_txn_type = READ;
            2'b10  : m_out_item_2.m_txn_type = WRITE;
            2'b11  : m_out_item_2.m_txn_type = WRITE_READ;
            default: begin  @ (posedge m_vif.CLK) continue; end
          endcase

          @ (posedge m_vif.CLK)
            m_out_item_2.m_empty    = m_vif.EMPTY;
            m_out_item_2.m_data_out = m_vif.DATA_OUT;
            m_out_item_2.m_full     = m_vif.FULL;

          $cast(m_out_cloned_item_2, m_out_item_2.clone());
          m_out_port.write (m_out_cloned_item_2);     
        end
      endtask
    endclass 
  `endif

/**********************************************************************************************************************
*  END OF FILE: sync_fifo_monitor.sv
*********************************************************************************************************************/