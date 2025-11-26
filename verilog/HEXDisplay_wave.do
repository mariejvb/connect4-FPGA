onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /HEXDisplay_tb/P
add wave -noupdate /HEXDisplay_tb/ONE
add wave -noupdate /HEXDisplay_tb/TWO
add wave -noupdate /HEXDisplay_tb/BLANK
add wave -noupdate /HEXDisplay_tb/clk
add wave -noupdate /HEXDisplay_tb/reset
add wave -noupdate /HEXDisplay_tb/game_over
add wave -noupdate /HEXDisplay_tb/winner
add wave -noupdate /HEXDisplay_tb/player_turn
add wave -noupdate /HEXDisplay_tb/HEX0
add wave -noupdate /HEXDisplay_tb/HEX1
add wave -noupdate /HEXDisplay_tb/HEX2
add wave -noupdate /HEXDisplay_tb/HEX3
add wave -noupdate /HEXDisplay_tb/HEX4
add wave -noupdate /HEXDisplay_tb/HEX5
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
