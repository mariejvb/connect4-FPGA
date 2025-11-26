onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /Connect4_tb/CLOCK_50
add wave -noupdate {/Connect4_tb/KEY[0]}
add wave -noupdate -expand /Connect4_tb/SW
add wave -noupdate /Connect4_tb/HEX5
add wave -noupdate /Connect4_tb/HEX4
add wave -noupdate /Connect4_tb/HEX3
add wave -noupdate /Connect4_tb/HEX2
add wave -noupdate /Connect4_tb/HEX1
add wave -noupdate /Connect4_tb/HEX0
add wave -noupdate {/Connect4_tb/LEDR[0]}
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 1
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
WaveRestoreZoom {0 ps} {143852993 ps}
