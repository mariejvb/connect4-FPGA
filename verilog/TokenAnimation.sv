// Token Animation Module
module TokenAnimation	(clk, reset, board_red, board_grn, player_move, player_turn, column_index, valid_move, 
								animation_red, animation_grn, drop_in_progress, token_ready, final_row, final_column);
	input logic clk;
	input logic reset;
	input logic [5:0][15:0] board_red;
	input logic [5:0][15:0] board_grn;
	input logic player_move;
	input logic player_turn;
	input logic [2:0] column_index;
	input logic valid_move;
	output logic [15:0][15:0] animation_red;
	output logic [15:0][15:0] animation_grn;
	output logic drop_in_progress;
	output logic token_ready;
	output logic [2:0] final_row;
	output logic [2:0] final_column;
	
	// Animation control
	logic [2:0] current_row;
	logic [23:0] drop_timer;
	localparam [23:0] DROP_SPEED = 24'd2000;  // Animation speed
	logic current_player;  // Store player color for animation
	logic [2:0] stored_column;  // Store column for animation
	
	// Animation state machine
	always_ff @(posedge clk) begin
		if (reset) begin
			drop_in_progress <= 0;
			current_row <= 3'd0;
			drop_timer <= 24'd0;
			animation_red <= '{default: 0};
			animation_grn <= '{default: 0};
			current_player <= 0;
			stored_column <= 3'd0;
			token_ready <= 0;
			final_row <= 3'd0;
			final_column <= 3'd0;
		end 
		else begin
			// Clear animation by default
			animation_red <= '{default: 0};
			animation_grn <= '{default: 0};
			token_ready <= 0;
			
			if (player_move && valid_move) begin
				// Start new animation
				drop_in_progress <= 1;
				current_row <= 3'd0;
				drop_timer <= DROP_SPEED;
				current_player <= player_turn;
				stored_column <= column_index;
				if (player_turn == 0)
					animation_red[0][15-column_index] <= 1;
				else
					animation_grn[0][15-column_index] <= 1;
			end 
			else if (drop_in_progress) begin
				if (drop_timer > 24'd0) begin
					drop_timer <= drop_timer - 24'd1;
					// Keep showing current position
					if (current_player == 0)
						animation_red[current_row][15-stored_column] <= 1;
					else
						animation_grn[current_row][15-stored_column] <= 1;
				end 
				else begin
					if (current_row < 3'd5 && 
						!board_red[current_row+3'd1][15-stored_column] && 
						!board_grn[current_row+3'd1][15-stored_column]) begin
						// Move down one row
						current_row <= current_row + 3'd1;
						drop_timer <= DROP_SPEED;
						// Show token in new position
						if (current_player == 0)
							animation_red[current_row+3'd1][15-stored_column] <= 1;
						else
							animation_grn[current_row+3'd1][15-stored_column] <= 1;
					end 
					else begin
						// Signal token placement
						token_ready <= 1;
						final_row <= current_row;
						final_column <= stored_column;
						drop_in_progress <= 0;
					end
				end
			end
		end
	end
endmodule

// Token Animation Testbench
module TokenAnimation_tb();
	// Test signals
	logic clk;
	logic reset;
	logic [5:0][15:0] board_red, board_grn;
	logic player_move;
	logic player_turn;
	logic [2:0] column_index;
	logic valid_move;
	logic [15:0][15:0] animation_red, animation_grn;
	logic drop_in_progress;
	logic token_ready;
	logic [2:0] final_row, final_column;
	
	// Test variable
	int animation_cycles = 0;
	
	// Instantiate Token Animation module
	TokenAnimation dut (.*);
	
	// Clock setup
	initial begin
		clk = 0;
		forever #5 clk = ~clk;
	end
	
	// Test sequence
	initial begin
     // Initialize signals
      reset = 0;
      board_red = '{default: '0};
      board_grn = '{default: '0};
      player_move = 0;
      player_turn = 0;
      column_index = 0;
      valid_move = 0;
      @(posedge clk);
      
      // Test reset
      reset = 1; @(posedge clk);
      reset = 0; @(posedge clk);
      
      // Test dropping animation for Player 1
      player_turn = 0;
      column_index = 3'd3;  // Column 3
      player_move = 1;
      valid_move = 1;
      @(posedge clk);
      player_move = 0;
      
      // Wait for animation to complete
      while (!token_ready) begin
         @(posedge clk);
      end
      
      // Test dropping animation for Player 2
      player_turn = 1;
      column_index = 3'd3;  // Same column
      player_move = 1;
      valid_move = 1;
      @(posedge clk);
      player_move = 0;
      
      // Wait for animation to complete
      while (!token_ready) begin
         @(posedge clk);
      end
      
      $stop;
	end

endmodule