# connect4-FPGA

A Connect 4 game implemented on FPGA using SystemVerilog, featuring a 6x7 LED board and interactive controls.

## Overview

This project implements the classic Connect 4 game on a 16x16 LED matrix using FPGA hardware and SystemVerilog. The game includes full sequential logic, player turn tracking, input validation, and visual feedback via LEDs and HEX displays.

The design demonstrates digital logic design, state machine implementation, and hardware-software interaction through switches and displays.

## Features

* 6x7 LED game board mapped on a 16x16 LED matrix

* Player input through switches (SW[9:3] for column selection)

* Reset functionality via KEY[0]

* LED indicator for valid move readiness (LED[0])

* Winner and turn displayed on HEX[5:0]

* Invalid move detection and handling (out-of-range switch or full column)

* Support for Player 1 and Player 2 with token drop animations

* Automatic detection of draw situations

## User Guide

* Game Board: 6x7 grid at LED[0:5][15:9]

* Column Selection: SW[9:3] (SW[9] → column 15, SW[3] → column 9)

* Reset: KEY[0]

* Move Indicator: LED[0] is on when waiting for a valid move

* HEX Display: Shows current player and winner

  * Player 1’s turn: [P][1][ ][ ][ ][ ]

  * Player 2’s turn: [P][2][ ][ ][ ][ ]

  * Player 1 wins: [P][1][P][1][P][1]

  * Player 2 wins: [P][2][P][2][P][2]

  * Draw: [ ][ ][ ][ ][ ][ ]

Note: A valid move requires turning the selected switch back off before the next turn. Invalid moves (SW[2:0] or full columns) are ignored.

## Technical Highlights

* Fully implemented in SystemVerilog for FPGA deployment

* Uses finite state machines to manage game logic and animations

* Demonstrates hardware-level input validation, sequential logic, and display control

* Modular design suitable for extension or adaptation to other LED matrix sizes

## Skills Demonstrated

* Digital design and FPGA programming

* SystemVerilog sequential logic and FSM implementation

* Hardware input/output management

* Display and LED matrix control

* Debugging and simulation of hardware behavior
