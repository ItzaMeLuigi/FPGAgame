module jumpgame(CLOCK_50, SW, LEDR, LEDG, KEY, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7, toggle, highscoreoutput);

input [17:0] SW;
input [3:0] KEY;
output reg [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7;
input CLOCK_50;
input toggle;
output reg [17:0] LEDR;
output reg [7:0] LEDG;
integer timer = 4000000;
reg[27:0] clk_wall = 0;
reg[27:0] clk_sjump = 0;
reg[27:0] clk_ljump = 0;
integer wall_move = 0;
integer wall_move2 = 0;
integer s_move = 0;
integer l_move = 0;
integer s_jump = 0;
integer l_jump = 0;
integer s_collision = 1;
integer l_collision = 1;
integer loss = 0;
integer win = 0;
integer win1 = 0;
integer highscore = 0;
integer visit = 0;
integer choose_jump = 0;
integer choose_wall = 0;
output reg [10:0]highscoreoutput;
reg [27:0] clkrng, difficulty;
reg newpress;

always @ (posedge CLOCK_50) begin

	highscoreoutput <= highscore;
	
	if(toggle) begin //if running
//---------------------reset---------------------//
	HEX0 <= 7'b1111111;
	HEX1 <= 7'b1111111;
	HEX2 <= 7'b1111111;
	HEX3 <= 7'b1111111;
	HEX4 <= 7'b1111111;
	HEX5 <= 7'b1111111;
	HEX6 <= 7'b1111111;
	HEX7 <= 7'b1111111;
	LEDR <= 18'b000000000000000000;
	LEDG <= 8'b00000000;

//-------------------main timer-------------------//
	//main counter, stop moving wall if loss
	if(loss == 0) begin
		clk_wall = clk_wall + 1;
	end
	
	//move wall every time clk_wall reaches "timer" value
	if(clk_wall >= timer) begin
		wall_move = wall_move + 1;
		clk_wall = 0;
	end
	
	//after wall moves 16 times (max amount), loop back to beginning
	if(wall_move > 15) begin
		wall_move = 0;
	end
	
//---------------control difficulty---------------//
	clkrng <= clkrng + 1;
	if(clkrng > difficulty) begin
		clkrng <= 0;
	end
	
	if(clkrng > 1000 && visit == 1) begin
		choose_wall = 1;
	end else if(visit == 1) begin
		choose_wall = 0;
	end
	
	if(win > 30) begin
		timer = 2750000;
		difficulty = 4000;
	end else if(win == 25) begin
		timer = 3000000;
		difficulty = 3500;
	end else if(win == 20) begin
		timer = 3250000;
		difficulty = 3000;
	end else if(win == 15) begin
		timer = 3500000;
		difficulty = 2500;
	end else if(win == 10) begin
		timer = 3750000;
		difficulty = 1750;
	end else if(win == 5) begin
		timer = 3900000;
		difficulty = 1500;
	end else if(win == 5) begin
		timer = 3900000;
		difficulty = 1250;
	end
	
	case(choose_wall)
//-------------------small wall-------------------//
	0: begin
		case(wall_move) 
			0: begin
				HEX0[2] <= 0;
				visit = 0;
			end
			1: HEX0[4] <= 0;
			2: HEX1[2] <= 0;
			3: HEX1[4] <= 0;
			4: HEX2[2] <= 0;
			5: HEX2[4] <= 0;
			6: HEX3[2] <= 0;
			7: HEX3[4] <= 0;
			8: HEX4[2] <= 0;
			9: HEX4[4] <= 0;
			10: HEX5[2] <= 0;
			11: HEX5[4] <= 0;
			12: HEX6[2] <= 0;
			13: HEX6[4] <= 0;
			14: HEX7[2] <= 0;
			// check if player collides with wall, decides win/lose condition
			15: begin
					HEX7[4] <= 0;
					if(visit == 0) begin
						if(s_collision == 1) begin
							loss = 1;
						end else begin
							win = win + 1;
						end
					end
					visit = 1;
				end
		endcase
	end
	
//-------------------large wall-------------------//
	1: begin
		case(wall_move) 
			0: begin
				HEX0[2] <= 0;
				HEX0[1] <= 0;
				visit = 0;
			end
			1: begin
				HEX0[4] <= 0;
				HEX0[5] <= 0;
			end
			2: begin
				HEX1[2] <= 0;
				HEX1[1] <= 0;
			end
			3: begin
				HEX1[4] <= 0;
				HEX1[5] <= 0;
			end
			4: begin
				HEX2[2] <= 0;
				HEX2[1] <= 0;
			end
			5: begin
				HEX2[4] <= 0;
				HEX2[5] <= 0;
			end
			6: begin
				HEX3[2] <= 0;
				HEX3[1] <= 0;
			end
			7: begin
				HEX3[4] <= 0;
				HEX3[5] <= 0;
			end
			8: begin
				HEX4[2] <= 0;
				HEX4[1] <= 0;
			end
			9: begin
				HEX4[4] <= 0;
				HEX4[5] <= 0;
			end
			10: begin
				HEX5[2] <= 0;
				HEX5[1] <= 0;
			end
			11: begin
				HEX5[4] <= 0;
				HEX5[5] <= 0;
			end
			12: begin
				HEX6[2] <= 0;
				HEX6[1] <= 0;
			end
			13: begin
				HEX6[4] <= 0;
				HEX6[5] <= 0;
			end
			14: begin
				HEX7[2] <= 0;
				HEX7[1] <= 0;
			end
			// check if player collides with wall, decides win/lose condition
			15: begin
					HEX7[4] <= 0;
					HEX7[5] <= 0;
					if(visit == 0) begin
						if(l_collision == 1 || s_collision == 1) begin
							loss = 1;
						end else begin
							win = win + 1;
						end
					end
					visit = 1;
				end
		endcase
	
	end
	endcase
//------------------jumps-------------------//
	//begin small jump
	if (~KEY[1] && s_jump == 0 && loss == 0 && l_jump == 0) begin
		s_jump = 1 ; 
	end
	
	//begin large jump
	if (~KEY[2] && l_jump == 0 && loss == 0 && s_jump == 0) begin
		l_jump = 1 ; 
	end
	
	if(s_jump > 0) begin
		choose_jump = 1;
	end else if (l_jump > 0) begin
		choose_jump = 2;
	end else begin
		HEX7[4] <= 0;
		s_collision = 1;
		l_collision = 1;
		choose_jump = 0;
	end
	
	case(choose_jump)
//------------------small jump-------------------//
		1: begin
		//start jump timer
		if(s_jump == 1) begin
			clk_sjump = clk_sjump + 1;
		end
		
		//speed of small jump "frames"
		if(clk_sjump > 5000000) begin
			s_move = s_move + 1;
			clk_sjump = 0;
		end
		
		//small jump has 6 steps
		if(s_move > 6) begin
			s_move = 0;
			s_jump = 2;
			
		end
		
		case(s_move) 
			//inactive frames, when collision is still active
			0,5,6: begin
				HEX7[4] <= 0;
				s_collision = 1;
				l_collision = 1;
			end
			//active frames, when player is in middle of jump
			1,2,3,4: begin
				if(loss == 0) begin
					HEX7[5] <= 0;
					s_collision = 0;
					l_collision = 1;
				end
			end
		endcase
		
		//reset jump when player lets go of button (cannot hold button)
		if (KEY[1] && s_jump == 2) begin
			s_jump = 0 ; 
			choose_jump = 0;
		end
		
	end
//-------------------large jump-------------------//
	
	2: begin
		//start jump timer
		if(l_jump == 1) begin
			clk_ljump = clk_ljump + 1;
		end
		
		//speed of large jump "frames"
		if(clk_ljump > 5000000) begin
			l_move = l_move + 1;
			clk_ljump = 0;
		end
		
		//large jump has 6 steps
		if(l_move > 9) begin
			l_move = 0;
			l_jump = 2;
			
		end
		
		case(l_move) 
			//inactive frames, when collision is still active
			0,6,7,8,9: begin
				HEX7[4] <= 0;
				s_collision = 1;
				l_collision = 1;
			end
			//active frames, when player is in middle of jump, can clear small wall
			1,5: begin
				if(loss == 0) begin
					HEX7[5] <= 0;
					s_collision = 0;
					l_collision = 1;
				end
			end
			2,3,4: begin
				if(loss == 0) begin
					HEX7[0] <= 0;
					l_collision = 0;
					s_collision = 0;
				end
			end
		endcase
		
		//reset jump when player lets go of button (cannot hold button)
		if (KEY[2] && l_jump == 2) begin
			l_jump = 0 ; 
			choose_jump = 0;
		end
	end
	
	endcase
//-------------------new game-------------------//

	if (~KEY[0]) begin
		wall_move = 0;
		s_move = 0;
		l_move = 0;
		s_jump = 0;
		l_jump = 0;
		s_collision = 1;
		l_collision = 1;
		loss = 0;
		win = 0;
		visit = 0;
		choose_jump = 0;
		choose_wall = 0;
		timer = 4000000;
		difficulty <= 0;
	end
	
//-------------------win score-------------------//
	win1 = win%10;
	
	 case(win1)
		0: LEDR <= 18'b000000000000000000;
		1: LEDR <= 18'b100000000000000000;
		2: LEDR <= 18'b110000000000000000;
		3: LEDR <= 18'b111000000000000000;
		4: LEDR <= 18'b111100000000000000;
		5: LEDR <= 18'b111110000000000000;
		6: LEDR <= 18'b111111000000000000;
		7: LEDR <= 18'b111111100000000000;
		8: LEDR <= 18'b111111110000000000;
		9: LEDR <= 18'b111111111000000000;
	 endcase
	 
	 case(win)
		0: LEDG <= 8'b00000000;
		10,11,12,13,14,15,16,17,18,19: LEDG <= 8'b10000000;
		20,21,22,23,24,25,26,27,28,29: LEDG <= 8'b11000000;
		30,31,32,33,34,35,36,37,38,39: LEDG <= 8'b11100000;
		40,41,42,43,44,45,46,47,48,49: LEDG <= 8'b11110000;
		50,51,52,53,54,55,56,57,58,59: LEDG <= 8'b11111000;
	 endcase

//-------------------highscore-------------------//
	if(win >= highscore && win > 0) begin
		highscore = win;
		case(wall_move)
			0,1,2,3,8,9,10,11: begin
				LEDG[0] <= 1;
				LEDG[1] <= 0;
				LEDG[2] <= 1;
			end
			
			4,5,6,7,12,13,14,15: begin
				LEDG[0] <= 0;
				LEDG[1] <= 1;
				LEDG[2] <= 0;
			end
		endcase
	end
	
//---------------------loss---------------------//
	
	if(loss == 1) begin
		LEDG <= 8'b11111111;
		//current score
		case(win1)
			0: HEX4 <= 7'b1000000;
			1: HEX4 <= 7'b1111001;
			2: HEX4 <= 7'b0100100;
			3: HEX4 <= 7'b0110000;
			4: HEX4 <= 7'b0011001;
			5: HEX4 <= 7'b0010010;
			6: HEX4 <= 7'b0000010;
			7: HEX4 <= 7'b1111000;
			8: HEX4 <= 7'b0000000;
			9: HEX4 <= 7'b0010000;
		endcase
			
		if(win >= 50) begin
			HEX5 <= 7'b0010010;
		end else if (win >= 40) begin
			HEX5 <= 7'b0011001;
		end else if (win >= 30) begin
			HEX5 <= 7'b0110000;
		end else if (win >= 20) begin
			HEX5 <= 7'b0100100;
		end else if (win >= 10) begin
			HEX5 <= 7'b1111001;
		end else if (win >= 0) begin
			HEX5 <= 7'b1000000;
		end
		//highscore
		HEX3 <= 7'b0001001; //highscore display
		HEX2 <= 7'b0110111;
		case(highscore%10)
			0: HEX0 <= 7'b1000000;
			1: HEX0 <= 7'b1111001;
			2: HEX0 <= 7'b0100100;
			3: HEX0 <= 7'b0110000;
			4: HEX0 <= 7'b0011001;
			5: HEX0 <= 7'b0010010;
			6: HEX0 <= 7'b0000010;
			7: HEX0 <= 7'b1111000;
			8: HEX0 <= 7'b0000000;
			9: HEX0 <= 7'b0010000;
		endcase
			
		if(highscore >= 50) begin
			HEX1 <= 7'b0010010;
		end else if (highscore >= 40) begin
			HEX1 <= 7'b0011001;
		end else if (highscore >= 30) begin
			HEX1 <= 7'b0110000;
		end else if (highscore >= 20) begin
			HEX1 <= 7'b0100100;
		end else if (highscore >= 10) begin
			HEX1 <= 7'b1111001;
		end else if (highscore >= 0) begin
			HEX1 <= 7'b1000000;
		end
	end
	
	end //end toggle
end

endmodule

