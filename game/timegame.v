module timegame(CLOCK_50, SW, LEDR, LEDG, KEY, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7, toggle, highscoreoutput);
input[3:0] KEY;
input[17:0] SW;
input toggle;
input CLOCK_50;
output reg [7:0] LEDG;
output reg [17:0] LEDR;
output reg[6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7;
wire [4:0] rng;
integer pattern = 0;
output reg [10:0] highscoreoutput;
integer next = 0;
integer highscore = 0;
reg [29:0] value, psec, pmsec, ptotal;
reg [29:0] rngclk = 5, clk, clks, clkms, clktotal;
reg start = 1;
reg run;
integer win = 0;
reg [5:0] timer = 0;
reg game;
integer loss = 0;
reg [2:0] state = 0;
parameter IDLE = 0, START = 1, TIMING = 2, END = 3; 

always @ (posedge CLOCK_50) begin

	highscoreoutput <= highscore;
	
	if(toggle) begin
	
	//"RANDOMIZER" CLOCK
	rngclk <= rngclk + 1;
		
	if(rngclk > 16) begin
		rngclk <= 5;
	end
	//	

	case(state)
	
		IDLE: begin
			LEDR <= 0;
			HEX7 <= 7'b1000000;
			HEX6 <= 7'b1000000;
			HEX5 <= 7'b1000000;
			HEX4 <= 7'b1000000;
			HEX3 <= 7'b1000000;
			HEX2 <= 7'b1000000;
			HEX1 <= 7'b1000000;
			HEX0 <= 7'b1000000;
			game <= 0;
			
			if(~KEY[2]) begin
				clk <= 0;
				
				if(rngclk < 6) begin
					value <= 5;
				end else if(rngclk < 7) begin
					value <= 6;
				end else if(rngclk < 8) begin
					value <= 7;
				end else if(rngclk < 9) begin
					value <= 8;
				end else if(rngclk < 10) begin
					value <= 9;
				end else if(rngclk < 11) begin
					value <= 10;
				end else if(rngclk < 12) begin
					value <= 11;
				end else if(rngclk < 13) begin
					value <= 12;
				end else if(rngclk < 14) begin
					value <= 13;
				end else if(rngclk < 15) begin
					value <= 14;
				end else if(rngclk < 16) begin
					value <= 15;
				end else begin
					value <= 5;
				end
				
				state <= START;
				
			end
		end
		
		START: begin
			//START CLOCK
			clk <= clk + 1;
			
			//COUNTDOWN
			if(clk < 50000000) begin
				LEDG <= 8'b11111111;
			end else if (clk < 100000000) begin
				LEDG <= 8'b11111100;
			end else if (clk < 150000000) begin
				LEDG <= 8'b11110000;
			end else if(clk < 200000000) begin
				LEDG <= 8'b11000000;
			end else begin
				LEDG <= 8'b00000000;
				state <= TIMING;
				clk <= 0;
				clks <= 0;
				clkms <= 0;
				clktotal <= 0;
				psec <= 0;
				pmsec <= 0;
				ptotal <= 0;
			end
			
			//Display Number
			HEX5 <= 7'b1000000;
			HEX4 <= 7'b1000000;
			case(value)
				5: begin
					HEX7 <= 7'b1000000;
					HEX6 <= 7'b0010010;
				end
				6: begin
					HEX7 <= 7'b1000000;
					HEX6 <= 7'b0000010;
				end
				7: begin
					HEX7 <= 7'b1000000;
					HEX6 <= 7'b1111000;
				end
				8: begin
					HEX7 <= 7'b1000000;
					HEX6 <= 7'b0000000;
				end
				9: begin
					HEX7 <= 7'b1000000;
					HEX6 <= 7'b0010000;	
				end
				10: begin
					HEX7 <= 7'b1111001;
					HEX6 <= 7'b1000000;
				end
				11: begin
					HEX7 <= 7'b1111001;
					HEX6 <= 7'b1111001;
				end
				12: begin
					HEX7 <= 7'b1111001;
					HEX6 <= 7'b0100100;
				end
				13: begin
					HEX7 <= 7'b1111001;
					HEX6 <= 7'b0110000;
				end
				14: begin
					HEX7 <= 7'b1111001;
					HEX6 <= 7'b0011001;
				end
				15: begin
					HEX7 <= 7'b1111001;
					HEX6 <= 7'b0010010;
				end
			endcase
			
		end
		
		TIMING: begin
			
			clk <= clk + 1;
			
			if(clk >= 5000000 && clkms < 10) begin
				clkms <= clkms + 1;
				clk <= 0;
			end
			
			//begin second counter (first digit)
			if(clkms > 9) begin
				clks <= clks + 1;
				clkms <= 0;
			end
			
			if(clks > 19) begin
				state <= END;
				psec <= 0;
				pmsec <= 0;
			end
			
			if(~KEY[1]) begin
				state <= END;
				psec <= clks;
				pmsec <= clkms;
			end
		end
		
		END: begin
			
			if(psec < 10)begin
				HEX3 <= 7'b1000000;
			end else begin
				HEX3 <= 7'b1111001;
			end
			
			case(psec%10) 
				0: HEX2 <= 7'b1000000;
				1: HEX2 <= 7'b1111001;
				2: HEX2 <= 7'b0100100;
				3: HEX2 <= 7'b0110000;
				4: HEX2 <= 7'b0011001;
				5: HEX2 <= 7'b0010010;
				6: HEX2 <= 7'b0000010;
				7: HEX2 <= 7'b1111000;
				8: HEX2 <= 7'b0000000;
				9: HEX2 <= 7'b0010000;
			endcase
			
			HEX1 <= 7'b1111011;
			
			case(pmsec)
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
			
			if(((psec == value && pmsec < 5) || (psec == value - 1 && pmsec >= 5)) && game == 0) begin
				game <= 1;
				win <= win + 1;
			end else if (game == 0) begin 
				win <= 0;
				game <= 1;
			end	
				
			if(~KEY[2]) begin
				state <= IDLE;
			end
		end
		
	endcase
	
	case(win)
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
	
	if(win >= highscore) begin
		highscore <= win;
	end
	
	end //END TOGGLE
end


endmodule
