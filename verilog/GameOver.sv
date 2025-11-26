// Game Over Module
module GameOver (clk, reset, board_red, board_grn, token_ready, game_over, winner);
	input logic clk;
	input logic reset;
	input logic [5:0][15:0] board_red;
	input logic [5:0][15:0] board_grn;
	input logic token_ready;
	output logic game_over;
	output logic [1:0] winner;  // 00: in progress, 01: P1 wins, 10: P2 wins, 11: draw
	
	int row, col, filled_cells;
	logic win_detected;
	
	always_ff @(posedge clk) begin
		if (reset) begin
			game_over <= 0;
			winner <= 2'b00;
			win_detected <= 0;
		end 
		else begin
			// Keep previous game_over and winner if game is already over
			if (!game_over) begin
				win_detected = 0;
				filled_cells = 0;
				
				// Check horizontal wins
				for (row = 0; row < 6 && !win_detected; row++) begin
					for (col = 9; col < 13 && !win_detected; col++) begin
						if (board_red[row][col] && board_red[row][col+1] && 
							board_red[row][col+2] && board_red[row][col+3]) begin
							win_detected = 1;
							game_over <= 1;
							winner <= 2'b01;
						end
						if (board_grn[row][col] && board_grn[row][col+1] && 
							board_grn[row][col+2] && board_grn[row][col+3]) begin
							win_detected = 1;
							game_over <= 1;
							winner <= 2'b10;
						end
					end
				end
                
				// Check vertical wins
				for (row = 0; row < 3 && !win_detected; row++) begin
					for (col = 9; col < 16 && !win_detected; col++) begin
						if (board_red[row][col] && board_red[row+1][col] && 
							board_red[row+2][col] && board_red[row+3][col]) begin
							win_detected = 1;
							game_over <= 1;
							winner <= 2'b01;
						end
						if (board_grn[row][col] && board_grn[row+1][col] && 
							board_grn[row+2][col] && board_grn[row+3][col]) begin
							win_detected = 1;
							game_over <= 1;
							winner <= 2'b10;
						end
					end
				end
				
				// Check diagonal wins (bottom-left to top-right)
				for (row = 0; row < 3 && !win_detected; row++) begin
					for (col = 9; col < 13 && !win_detected; col++) begin
						if (board_red[row][col] && board_red[row+1][col+1] && 
							board_red[row+2][col+2] && board_red[row+3][col+3]) begin
							win_detected = 1;
							game_over <= 1;
							winner <= 2'b01;
						end
						if (board_grn[row][col] && board_grn[row+1][col+1] && 
							board_grn[row+2][col+2] && board_grn[row+3][col+3]) begin
							win_detected = 1;
							game_over <= 1;
							winner <= 2'b10;
						end
					end
				end
				
				// Check diagonal wins (top-left to bottom-right)
				for (row = 3; row < 6 && !win_detected; row++) begin
					for (col = 9; col < 13 && !win_detected; col++) begin
						if (board_red[row][col] && board_red[row-1][col+1] && 
							board_red[row-2][col+2] && board_red[row-3][col+3]) begin
							win_detected = 1;
							game_over <= 1;
							winner <= 2'b01;
						end
						if (board_grn[row][col] && board_grn[row-1][col+1] && 
							board_grn[row-2][col+2] && board_grn[row-3][col+3]) begin
							win_detected = 1;
							game_over <= 1;
							winner <= 2'b10;
						end
					end
				end
				
				// Only check for draw if no win detected
				if (!win_detected) begin
					for (row = 0; row < 6; row++) begin
						for (col = 9; col < 16; col++) begin
							if (board_red[row][col] || board_grn[row][col]) begin
								filled_cells++;
							end
						end
					end
					if (filled_cells == 42) begin
						game_over <= 1;
						winner <= 2'b11;
					end
				end
			end
		end
	end
endmodule

// Game Over Testbench
module GameOver_tb();
	// Test signals
	logic clk;
	logic reset;
	logic [5:0][15:0] board_red, board_grn;
	logic token_ready;
	logic game_over;
	logic [1:0] winner;
	
	// Instantiate Game Over module
	GameOver dut (.*);
	
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
      token_ready = 0;
      @(posedge clk);
      
      // Reset game
      reset = 1; @(posedge clk);
      reset = 0; @(posedge clk);
      
      // Test horizontal win (Red)
      board_red[5][12:9] = 4'b1111;  // Four in a row
      token_ready = 1; @(posedge clk);
      token_ready = 0; @(posedge clk);
      
      // Reset and test vertical win (Green)
      reset = 1; @(posedge clk);
      reset = 0; @(posedge clk);
      board_red = '{default: '0};
      board_grn = '{default: '0};
      
      for(int i = 2; i < 6; i++) begin
         board_grn[i][9] = 1'b1;  // Four in a column
      end
      token_ready = 1; @(posedge clk);
      token_ready = 0; @(posedge clk);
      
      // Test diagonal win
      reset = 1; @(posedge clk);
      reset = 0; @(posedge clk);
      board_red = '{default: '0};
      board_grn = '{default: '0};
      
      for(int i = 0; i < 4; i++) begin
         board_red[i+2][i+9] = 1'b1;  // Diagonal win
      end
      token_ready = 1; @(posedge clk);
      token_ready = 0; @(posedge clk);
      
		$stop;
		
	end

endmodule