// Connect 4 Top-level module
module Connect4 (CLOCK_50, KEY, SW, HEX5, HEX4, HEX3, HEX2, HEX1, HEX0, LEDR, GPIO_1);
	input logic CLOCK_50;
	input logic [3:0] KEY;
	input logic [9:0] SW;
	output logic [6:0] HEX5, HEX4, HEX3, HEX2, HEX1, HEX0;
	output logic [9:0] LEDR;
	output logic [35:0] GPIO_1;
	
	// Internal signals
	logic [31:0] divided_clocks;
	logic system_clk;
	logic player_turn;
	logic valid_move;
	logic [15:0][15:0] red_pixels, grn_pixels;
	logic player_move;
	logic game_over;
	logic [1:0] winner;
	logic [5:0][15:0] board_red, board_grn;
	logic drop_in_progress;
	logic [2:0] column_index;
	logic move_ready;
	logic token_ready;
	logic [2:0] final_row, final_column;
	logic waiting_for_switch;
	logic reset;
	logic [15:0][15:0] animation_red, animation_grn;
	
	// Clock divider
	ClockDivider clock_divider (.clock(CLOCK_50), .divided_clocks(divided_clocks));
	
	// Select clock
	assign system_clk = divided_clocks[13]; // Slower clock for FPGA
	// assign system_clk = CLOCK_50; // 50 MHz clock for simulation
	
	// Check for reset signal at every positive clock edge
	always_ff @(posedge system_clk) begin
		reset <= ~KEY[0];
	end
	
	// Instantiate Game Logic module
	GameLogic game_logic	(.clk(system_clk), .reset, .SW, .token_ready, .final_row, .final_column, .board_red,
								.board_grn, .player_turn, .player_move, .move_ready, .valid_move, .column_index,
								.waiting_for_switch, .game_over);
	
	// Instantiate Token Animation module
	TokenAnimation token_animation	(.clk(system_clk), .reset, .board_red, .board_grn, .player_move, .player_turn,
												.column_index, .valid_move, .animation_red, .animation_grn, .drop_in_progress,
												.token_ready, .final_row, .final_column);

	// Instantiate Game Over module (win detection)
	GameOver game_over_module (.clk(system_clk), .reset, .board_red, .board_grn, .token_ready, .game_over, .winner);

	// Instantiate HEX Display module
	HEXDisplay hex_display (.clk(system_clk), .reset, .game_over, .winner, .player_turn, .HEX0, .HEX1, .HEX2, .HEX3, .HEX4, .HEX5);
	
	// Instantiate LED Driver module
	LEDDriver #(.FREQDIV(0)) driver_module	(.CLK(system_clk), .RST(1'b0), .EnableCount(1'b1),
														.RedPixels(red_pixels), .GrnPixels(grn_pixels), .GPIO_1);
														
	// Combine board state and animation for LED display
	always_comb begin
		// Start with board state
		red_pixels = board_red;
		grn_pixels = board_grn;
		
		// Add animation overlay
		if (drop_in_progress) begin
			red_pixels = red_pixels | animation_red;
			grn_pixels = grn_pixels | animation_grn;
		end
	end
	
	// LEDR0 output (on when awaiting move)
	assign LEDR[0] = move_ready;
	
endmodule


// Connect 4 Testbench
module Connect4_tb();
	// Test signals
	logic CLOCK_50;
	logic [3:0] KEY;
	logic [9:0] SW;
	logic [6:0] HEX5, HEX4, HEX3, HEX2, HEX1, HEX0;
	logic [9:0] LEDR;
	logic [35:0] GPIO_1;
	
	// Instantiate Connect4 module
	Connect4 dut (.*);
	
	// Clock setup
	parameter CLOCK_PERIOD = 100;
	initial begin
		CLOCK_50 <= 0;
		forever #(CLOCK_PERIOD/2) CLOCK_50 <= ~CLOCK_50;
	end
	
	// Test sequence
	initial begin;
		// Initialize signals
		KEY <= 4'b1111; SW[9:0] <= 10'b0000000000;	@(posedge CLOCK_50);
		
		// Reset game
		KEY[0] <= 0;	@(posedge CLOCK_50);
		repeat(5000)	@(posedge CLOCK_50);
		KEY[0] <= 1;	@(posedge CLOCK_50);
		
		// Play a game of Connect 4
		SW[3] <= 1;		@(posedge CLOCK_50); // P1 turn
		repeat(5000)	@(posedge CLOCK_50);
		SW[3] <= 0;		@(posedge CLOCK_50);
		repeat(100000) @(posedge CLOCK_50); // allow animation to complete
		
		SW[6] <= 1;		@(posedge CLOCK_50); // P2 turn
		repeat(5000)	@(posedge CLOCK_50);
		SW[6] <= 0;		@(posedge CLOCK_50);
		repeat(100000) @(posedge CLOCK_50); // allow animation to complete
		
		SW[4] <= 1;		@(posedge CLOCK_50); // P1 turn
		repeat(5000)	@(posedge CLOCK_50);
		SW[4] <= 0;		@(posedge CLOCK_50);
		repeat(100000) @(posedge CLOCK_50); // allow animation to complete
		
		SW[6] <= 1;		@(posedge CLOCK_50); // P2 turn
		repeat(5000)	@(posedge CLOCK_50);
		SW[6] <= 0;		@(posedge CLOCK_50);
		repeat(100000) @(posedge CLOCK_50); // allow animation to complete
		
		SW[6] <= 1;		@(posedge CLOCK_50); // P1 turn
		repeat(5000)	@(posedge CLOCK_50);
		SW[6] <= 0;		@(posedge CLOCK_50);
		repeat(100000) @(posedge CLOCK_50); // allow animation to complete
		
		SW[5] <= 1;		@(posedge CLOCK_50); // P2 turn
		repeat(5000)	@(posedge CLOCK_50);
		SW[5] <= 0;		@(posedge CLOCK_50);
		repeat(100000) @(posedge CLOCK_50); // allow animation to complete
		
		SW[5] <= 1;		@(posedge CLOCK_50); // P1 turn
		repeat(5000)	@(posedge CLOCK_50);
		SW[5] <= 0;		@(posedge CLOCK_50);
		repeat(100000) @(posedge CLOCK_50); // allow animation to complete
		
		SW[7] <= 1;		@(posedge CLOCK_50); // P2 turn
		repeat(5000)	@(posedge CLOCK_50);
		SW[7] <= 0;		@(posedge CLOCK_50);
		repeat(100000) @(posedge CLOCK_50); // allow animation to complete
		
		SW[8] <= 1;		@(posedge CLOCK_50); // P1 turn
		repeat(5000)	@(posedge CLOCK_50);
		SW[8] <= 0;		@(posedge CLOCK_50);
		repeat(100000) @(posedge CLOCK_50); // allow animation to complete
		
		SW[5] <= 1;		@(posedge CLOCK_50); // P2 turn
		repeat(5000)	@(posedge CLOCK_50);
		SW[5] <= 0;		@(posedge CLOCK_50);
		repeat(100000) @(posedge CLOCK_50); // allow animation to complete
		
		SW[5] <= 1;		@(posedge CLOCK_50); // P1 turn
		repeat(5000)	@(posedge CLOCK_50);
		SW[5] <= 0;		@(posedge CLOCK_50);
		repeat(100000) @(posedge CLOCK_50); // allow animation to complete
		
		SW[4] <= 1;		@(posedge CLOCK_50); // P2 turn
		repeat(5000)	@(posedge CLOCK_50);
		SW[4] <= 0;		@(posedge CLOCK_50);
		repeat(100000) @(posedge CLOCK_50); // allow animation to complete
		
		SW[7] <= 1;		@(posedge CLOCK_50); // P1 turn
		repeat(5000)	@(posedge CLOCK_50);
		SW[7] <= 0;		@(posedge CLOCK_50);
		repeat(100000) @(posedge CLOCK_50); // allow animation to complete
		// 4 in a row! P1 has won.
		// Check that HEX display shows P1 win sequence.
		
		$stop;
	
	end

endmodule