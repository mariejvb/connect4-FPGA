// HEX Display Module
module HEXDisplay (clk, reset, game_over, winner, player_turn, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5);
	input logic clk;
	input logic reset;
	input logic game_over;
	input logic [1:0] winner;
	input logic player_turn;
	output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	
	// HEX patterns
	localparam P = 7'b0001100;     // P
	localparam ONE = 7'b1111001;   // 1
	localparam TWO = 7'b0100100;   // 2
	localparam BLANK = 7'b1111111; // Blank
	
	// Display logic
	always_comb begin
		if (game_over) begin
			case (winner)
				2'b01: begin  // Player 1 wins
					HEX5 = P;
					HEX4 = ONE;
					HEX3 = P;
					HEX2 = ONE;
					HEX1 = P;
					HEX0 = ONE;
				end
				2'b10: begin  // Player 2 wins
					HEX5 = P;
					HEX4 = TWO;
					HEX3 = P;
					HEX2 = TWO;
					HEX1 = P;
					HEX0 = TWO;
				end
				2'b11: begin  // Draw
					HEX5 = BLANK;
					HEX4 = BLANK;
					HEX3 = BLANK;
					HEX2 = BLANK;
					HEX1 = BLANK;
					HEX0 = BLANK;
				end
				default: begin
					HEX5 = BLANK;
					HEX4 = BLANK;
					HEX3 = BLANK;
					HEX2 = BLANK;
					HEX1 = BLANK;
					HEX0 = BLANK;
				end
			endcase
		end else begin
			// Normal game display
			HEX5 = P;
			HEX4 = player_turn ? TWO : ONE;
			HEX3 = BLANK;
			HEX2 = BLANK;
			HEX1 = BLANK;
			HEX0 = BLANK;
		end
	end
endmodule

// HEX Display Testbench
module HEXDisplay_tb();
	// Test signals
	logic clk;
	logic reset;
	logic game_over;
	logic [1:0] winner;
	logic player_turn;
	logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	
	// HEX patterns for verification
	localparam P = 7'b0001100;     // P
	localparam ONE = 7'b1111001;   // 1
	localparam TWO = 7'b0100100;   // 2
	localparam BLANK = 7'b1111111; // Blank
	
	// Instantiate HEXDisplay module
	HEXDisplay dut (.*);
	
	// Clock setup
	initial begin
		clk = 0;
		forever #5 clk = ~clk;
	end
	
	// Test sequence
	initial begin
      // Initialize signals
      reset = 0;
      game_over = 0;
      winner = 2'b00;
      player_turn = 0;
      @(posedge clk);
      
      // Test reset
      reset = 1; @(posedge clk);
      reset = 0; @(posedge clk);
      
      // Test Player 1's turn display
      player_turn = 0; @(posedge clk);
      
      // Test Player 2's turn display
      player_turn = 1; @(posedge clk);
      
      // Test Player 1 win display
      game_over = 1;
      winner = 2'b01; @(posedge clk);
      
      // Test Player 2 win display
      winner = 2'b10; @(posedge clk);
      
      // Test draw display
      winner = 2'b11; @(posedge clk);
      
      $stop;
	end

endmodule