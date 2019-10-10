module zapsgame(CLOCK_50, SW, LEDR, LEDG, KEY, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7, toggle, highscoreoutput);

input [17:0] SW;
input [3:0] KEY;
input toggle;
output reg [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7;
input CLOCK_50;
output reg [17:0] LEDR;
output reg [7:0] LEDG;
integer timer = 4000000;
integer timer2 = 2500000;
reg[27:0] Q = 0;
reg[27:0] R = 0;
integer S = 0;
integer on = 0;	
integer next = 0;
integer win = 0;
integer winnum = 0;
integer winnum2 = 0;
integer highscore = 0;
integer highscore2 = 0;
integer newhighscore = 0;
integer T = 18;
integer N = 0;
output reg [10:0]highscoreoutput;

always @ (posedge CLOCK_50) begin

	highscoreoutput <= highscore;
	
	if(toggle) begin //check toggle
	
	//CLOCK 1, controls the red LEDs
	//timer variable changes depending on how many wins the player has (found below)
	Q = Q + 1;
	if(Q >= timer && T > 0) begin
		if (on == 0) begin
			T <= T - 1;
		end
		Q <= 0;
	end
	              
	//changes the timer variable based off win number
	//subtracts 100000 per win, maximum speed is 2000000
	//based off CLOCK 1
	if(timer > 2000000) begin
		timer <= 4000000 - (win * 100000);
	end
	
	//win counter, displays the HEX display of the win (HEX5 and HEX4)
	//winnum represents the 1's digits, winnum2 represents the 10's digits
	//winnum calculation happens in sync with win calculation (farther below)
	//winnum based off win, winnum2 based off winnum
	//resets if win streak broken (also farther below)
	if(winnum > 9) begin
		winnum <= 0;
		winnum2 <= winnum2 + 1;
	end
	case(winnum)
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
		default: HEX4 <= 7'b0010000;
	endcase
	case(winnum2)
		0: HEX5 <= 7'b1000000;
		1: HEX5 <= 7'b1111001;
		2: HEX5 <= 7'b0100100;
		3: HEX5 <= 7'b0110000;
		4: HEX5 <= 7'b0011001;
		5: HEX5 <= 7'b0010010;
		6: HEX5 <= 7'b0000010;
		7: HEX5 <= 7'b1111000;
		8: HEX5 <= 7'b0000000;
		9: HEX5 <= 7'b0010000;
		default: HEX5 <= 7'b0010000;
	endcase
	
	//highscore HEX display (HEX7 and HEX6)
	//highscore 1's digit, highscore2 10's digit
	//compares values to winnum and winnum2
	//since no actual value, checks digits individually
	//newhighscore set to 1 for the next feature
	if(winnum2 > highscore2) begin
		highscore <= winnum;
		highscore2 <= winnum2;
		newhighscore <= 1;
	end else if (winnum2 == highscore2) begin
		if(winnum > highscore && win > 0) begin
			highscore <= winnum;
			highscore2 <= winnum2;
			newhighscore <= 1;
		end
	end
		case(highscore)
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
		default: HEX0 <= 7'b0010000;
	endcase
	case(highscore2)
		0: HEX1 <= 7'b1000000;
		1: HEX1 <= 7'b1111001;
		2: HEX1 <= 7'b0100100;
		3: HEX1 <= 7'b0110000;
		4: HEX1 <= 7'b0011001;
		5: HEX1 <= 7'b0010010;
		6: HEX1 <= 7'b0000010;
		7: HEX1 <= 7'b1111000;
		8: HEX1 <= 7'b0000000;
		9: HEX1 <= 7'b0010000;
		default: HEX1 <= 7'b0010000;
	endcase
	
//	//newhighscore HEX display (HEX3-0)
//	//if winnum > highscore, newhighscore is set in previous method
//	//CLOCK2, displays "COOL" that flashes based off new clock (variable N)
//	if(newhighscore == 1) begin
//		N <= N + 1;
//		if(N > 50000000) begin
//			N <= 0;
//		end
//	end
//	if(newhighscore == 1 && N < 30000000) begin
//		HEX0 <= 7'b1000111;
//		HEX3 <= 7'b1000110;
//		HEX1 <= 7'b1000000;
//		HEX2 <= 7'b1000000;
//	end 
//	
//	if(newhighscore == 1 && N >= 30000000) begin
//		HEX0 <= 7'b1111111;
//		HEX3 <= 7'b1111111;
//		HEX1 <= 7'b1111111;
//		HEX2 <= 7'b1111111;
//	end
//	if(newhighscore == 0) begin
//		HEX0 <= 7'b1000000;
//		HEX3 <= 7'b1000000;
//		HEX1 <= 7'b1000000;
//		HEX2 <= 7'b1000000;
//	end

	//CLOCK3, green light display (LEDG7-0)
	//a single green light turns on for each win up to 7
	//after 8 consecutive wins, green light "wipes" across
	//after 20 wins, lights go faster
	R = R + 1;
	if(R >= timer2 && S < 100) begin
		if (win > 7) begin
			S <= S + 1;
		end else begin
			S <= 0;
		end
		R <= 0;
	end
	if (win > 20) begin
		timer2 <= 1250000;
	end else begin
		timer2 <= 2250000;
	end
	if (win > 0 && win < 8) begin
		case(win)
		1: LEDG <= 8'b10000000;
		2:	LEDG <= 8'b11000000;
		3:	LEDG <= 8'b11100000;
		4:	LEDG <= 8'b11110000;
		5:	LEDG <= 8'b11111000;
		6:	LEDG <= 8'b11111100;
		7:	LEDG <= 8'b11111110;
		endcase
	end
	if (win > 7) begin
		case(S)
		1:	LEDG <= 8'b00000000;
		2: LEDG <= 8'b10000000;
		3:	LEDG <= 8'b11000000;
		4:	LEDG <= 8'b11100000;
		5:	LEDG <= 8'b11110000;
		6:	LEDG <= 8'b11111000;
		7:	LEDG <= 8'b11111100;
		8:	LEDG <= 8'b11111110;
		9:	LEDG <= 8'b11111111;
		10:LEDG <= 8'b01111111;
		11:LEDG <= 8'b00111111;
		12:LEDG <= 8'b00011111;
		13:LEDG <= 8'b00001111;
		14:LEDG <= 8'b00000111;
		15:LEDG <= 8'b00000011;
		16:LEDG <= 8'b00000001;
		endcase
	end
	
	//sets "on" to 1 if KEY is clicked, used for tracking button presses
	//when on = 1, red LEDs stop moving
	if (~KEY[1]) begin
		on <= 1; 
	end
	
	
	//resumes game after press
	//initially resets all green LEDs to 0 again
	//sets next back to 0, used for tracking button presses
	if (~KEY[0] && KEY[1]) begin
		on <= 0;
		next <= 0;
	end
	
	//T represents which red LED is on, 18 LEDs, works backward (from first clock)
	//also used for SW activation
	if (T < 1) begin
		T <= 18;
	end
	
	if (S > 17) begin
		S <= 1;
	end

	//initially set red LEDs to 0
	LEDR <= 18'b000000000000000000;
	LEDR[T] <= 1;
	
	//if the SW at LED T is switched on and "on" is activate (meaning KEY1 was just pressed)
	//increment win counter and set next to 1 (can't keep pressing the button to get wins, LED must be moving) -> KEY0
	//else missed, reset all counters
	if (SW[T] == 1 && on == 1) begin
		if (next == 0)begin
			win <= win + 1;
			winnum <= winnum + 1;
			next <= 1;
		end
	end else if (on == 1) begin
		win <= 0;
		winnum <= 0;
		winnum2 <= 0;
		newhighscore <= 0;
		timer <= 4000000;
		LEDG <= 8'b00000000;
	end
	
	HEX6 <= 7'b0111111;
	HEX7 <= 7'b0111111;
	HEX3 <= 7'b0001001;
	HEX2 <= 7'b0110111;
	end //end toggle
end

endmodule
