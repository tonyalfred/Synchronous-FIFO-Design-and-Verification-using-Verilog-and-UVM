vlog -cover bcest rtl/sync_fifo.v 
vsim +UVM_VERBOSITY=UVM_HIGH -voptargs=+acc work.sync_fifo_tb -logfile transcript.log

onerror {resume}
quietly WaveActivateNextPane {} 0

add wave -position end sim:/sync_fifo_tb/fifo/CLK 
add wave -position end sim:/sync_fifo_tb/fifo/RST 

add wave -position end sim:/sync_fifo_tb/fifo/WR_EN 
add wave -position end sim:/sync_fifo_tb/fifo/DATA_IN

add wave -position end sim:/sync_fifo_tb/fifo/RD_EN 
add wave -position end sim:/sync_fifo_tb/fifo/DATA_OUT

add wave -position end sim:/sync_fifo_tb/fifo/CNTR
add wave -position end sim:/sync_fifo_tb/fifo/RD_PTR
add wave -position end sim:/sync_fifo_tb/fifo/WR_PTR

add wave -position end sim:/sync_fifo_tb/fifo/EMPTY
add wave -position end sim:/sync_fifo_tb/fifo/FULL

TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {18884 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 152
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {61170 ps}

run -all