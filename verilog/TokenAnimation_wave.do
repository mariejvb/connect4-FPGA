onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /TokenAnimation_tb/clk
add wave -noupdate /TokenAnimation_tb/reset
add wave -noupdate /TokenAnimation_tb/board_red
add wave -noupdate /TokenAnimation_tb/board_grn
add wave -noupdate /TokenAnimation_tb/player_move
add wave -noupdate /TokenAnimation_tb/player_turn
add wave -noupdate /TokenAnimation_tb/column_index
add wave -noupdate /TokenAnimation_tb/valid_move
add wave -noupdate /TokenAnimation_tb/animation_red
add wave -noupdate /TokenAnimation_tb/animation_grn
add wave -noupdate /TokenAnimation_tb/drop_in_progress
add wave -noupdate /TokenAnimation_tb/token_ready
add wave -noupdate /TokenAnimation_tb/final_row
add wave -noupdate /TokenAnimation_tb/final_column
add wave -noupdate /TokenAnimation_tb/animation_cycles
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 0
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 50
configure wave -gridperiod 100
configure wave -griddelta 2
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {1 ns}
