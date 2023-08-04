/**********************************************************************************************************************
 *  FILE DESCRIPTION
 *  -------------------------------------------------------------------------------------------------------------------
 *  File:         sync_fifo_agent_config.sv
 *
 *  Description:  
 * 
 *********************************************************************************************************************/

  `ifndef SYNC_FIFO_AGENT_CONFIG
    `define SYNC_FIFO_AGENT_CONFIG

    class sync_fifo_agent_config extends uvm_object;
      `uvm_object_utils(sync_fifo_agent_config)
      
      virtual sync_fifo_if m_vif;
    
      uvm_active_passive_enum is_active = UVM_ACTIVE;

      function new(string name = "sync_fifo_agent_config");
        super.new(name);
      endfunction

      virtual function uvm_active_passive_enum get_is_active();
        return is_active;
      endfunction

      virtual function void set_is_active(uvm_active_passive_enum is_active);
        this.is_active = is_active;
      endfunction
    endclass 
  `endif

/**********************************************************************************************************************
*  END OF FILE: sync_fifo_agent_config.sv
*********************************************************************************************************************/