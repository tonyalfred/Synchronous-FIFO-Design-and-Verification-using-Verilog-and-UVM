/**********************************************************************************************************************
 *  FILE DESCRIPTION
 *  -------------------------------------------------------------------------------------------------------------------
 *  File:         sync_fifo_types.sv
 *
 *  Description:  
 * 
 *********************************************************************************************************************/

  `ifndef SYNC_FIFO_TYPES
    `define SYNC_FIFO_TYPES
      
    typedef enum bit [1:0] {WRITE = 0, READ = 1, WRITE_READ = 2, EMPTY = 3} sync_fifo_transaction_type_t;

  `endif

/**********************************************************************************************************************
*  END OF FILE: sync_fifo_types.sv
*********************************************************************************************************************/