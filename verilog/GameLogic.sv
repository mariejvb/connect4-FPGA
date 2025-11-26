// Game Logic Module
module GameLogic	(clk, reset, SW, token_ready, final_row, final_column, board_red, board_grn, player_turn, 
						player_move, move_ready, valid_move, column_index, waiting_for_switch, game_over);
	input logic clk;
	input logic reset;
	input logic [9:0] SW;
	input logic token_ready;
	input logic [2:0] final_row;
	input logic [2:0] final_column;
	output logic [5:0][15:0] board_red;
	output logic [5:0][15:0] board_grn;
	output logic player_turn;
	output logic player_move;
	output logic move_ready;
	output logic valid_move;
	output logic [2:0] column_index;
	output logic waiting_for_switch;
	input logic game_over;
	
	logic [6:0] prev_switch_state;
	
	// Column selection logic
	always_comb begin
		case (SW[9:3])
			7'b1000000: column_index = 3'd0;  // SW9 -> Column 15
			7'b0100000: column_index = 3'd1;  // SW8 -> Column 14
			7'b0010000: column_index = 3'd2;  // SW7 -> Column 13
			7'b0001000: column_index = 3'd3;  // SW6 -> Column 12
			7'b0000100: column_index = 3'd4;  // SW5 -> Column 11
			7'b0000010: column_index = 3'd5;  // SW4 -> Column 10
			7'b0000001: column_index = 3'd6;  // SW3 -> Column 9
			default: column_index = 3'dx;     // Invalid selection
		endcase
	end
	
	// Function to check if column is full
	function automatic logic is_column_full(logic [2:0] col);
		return board_red[0][15-col] || board_grn[0][15-col];  // Check top row
	endfunction
	
	// Game state control
	always_ff @(posedge clk) begin
		if (reset) begin
			player_move <= 1'b0;
			move_ready <= 1'b1;
			prev_switch_state <= 7'b0;
			player_turn <= 1'b0;  // Player 1 starts
			valid_move <= 1'b0;
			board_red <= '{default: 0};
			board_grn <= '{default: 0};
			waiting_for_switch <= 0;
		end 
		else begin
			// Default states
			player_move <= 1'b0;
			valid_move <= 1'b0;
			
			// Update board when token lands
			if (token_ready) begin
				if (player_turn == 0)
					board_red[final_row][15-final_column] <= 1;
				else
					board_grn[final_row][15-final_column] <= 1;
				
				// Wait one clock cycle for game_over to update
				if (!game_over) begin
					if (SW[9:3] != 0)
						waiting_for_switch <= 1;
					else if (!move_ready) begin
						player_turn <= ~player_turn;
						move_ready <= 1'b1;
						waiting_for_switch <= 0;
					end
				end
			end
			
			// Check for new switch activation
			if (SW[9:3] != prev_switch_state) begin
				if (SW[9:3] == 0) begin
					// Switch turned off - change turn if we were waiting and game isn't over
					if (waiting_for_switch && !game_over) begin
						player_turn <= ~player_turn;
						move_ready <= 1'b1;
						waiting_for_switch <= 0;
					end
				end
				else if (move_ready && column_index != 3'd7 && !game_over) begin
					// Check if column is not full before allowing move
					if (!is_column_full(column_index)) begin
						// Valid new move detected
						player_move <= 1'b1;
						valid_move <= 1'b1;
						move_ready <= 1'b0;
					end
					// If column is full, keep move_ready high to await valid move
				end
			end
			
			prev_switch_state <= SW[9:3];
			
		end
		
end

endmodule

// Game Logic Testbench
module GameLogic_tb();
	// Test signals
	logic clk;
	logic reset;
	logic [9:0] SW;
	logic token_ready;
	logic [2:0] final_row, final_column;
	logic [5:0][15:0] board_red, board_grn;
	logic player_turn;
	logic player_move;
	logic move_ready;
	logic valid_move;
	logic [2:0] column_index;
	logic waiting_for_switch;
	logic game_over;
	
	// Instantiate Game Logic module
	GameLogic dut (.*);
	
	// Clock setup
	initial begin
		clk = 0;
		forever #5 clk = ~clk;
	end
	
	// Test sequence
	initial begin
		// Initialize signals
		reset = 0;
		SW = '0;
		token_ready = 0;
		final_row = '0;
		final_column = '0;
		game_over = 0;
		@(posedge clk);
		
		// Reset game
      reset = 1; @(posedge clk);
      reset = 0; @(posedge clk);
		
      // Test valid move sequence
      SW[3] = 1; @(posedge clk);  // Select column 3
      #20;  // Wait for move processing
		
      // Simulate token landing
      token_ready = 1;
      final_row = 3'd5;  // Bottom row
      final_column = 3'd3;
      @(posedge clk);
      token_ready = 0;
      @(posedge clk);
		
      // Test player turn change
      SW[3] = 0; @(posedge clk);  // Release switch
      #20;
      
      // Test invalid move (column full)
      repeat(6) begin  // Fill column 3
         SW[3] = 1; @(posedge clk);
         #20;
         token_ready = 1; @(posedge clk);
         token_ready = 0; @(posedge clk);
         SW[3] = 0; @(posedge clk);
         #20;
      end
      
      SW[3] = 1; @(posedge clk);  // Try one more move
      #20;
		
		$stop;
		
	end
	 
endmodule