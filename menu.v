module menu(CLOCK_50, LEDG, LEDR, KEY, SW, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7);

input [3:0] KEY;
input [17:0] SW;
input CLOCK_50;
output reg [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7;
output reg [7:0] LEDG;
output reg [17:0] LEDR;
parameter JUMP = 0, ZAPS = 1, BEAT = 2, TIME = 3; //states
integer jumpEN = 0, zapsEN = 0, beatEN = 0, timeEN = 0; //enable bits
integer forset = 0, backset = 0;
integer state = 0;
reg menuon = 1;
reg press1, press2;
//wires for jump game
wire [7:0]ledgj;
wire [17:0]ledrj;
wire [6:0] hex0j, hex1j, hex2j, hex3j, hex4j, hex5j, hex6j, hex7j;
//wires for zaps game
wire [7:0]ledgz;
wire [17:0]ledrz;
wire [6:0] hex0z, hex1z, hex2z, hex3z, hex4z, hex5z, hex6z, hex7z;
//wires for beat game
wire [7:0]ledgb;
wire [17:0]ledrb;
wire [6:0] hex0b, hex1b, hex2b, hex3b, hex4b, hex5b, hex6b, hex7b;
//wires for time game
wire [7:0]ledgt;
wire [17:0]ledrt;
wire [6:0] hex0t, hex1t, hex2t, hex3t, hex4t, hex5t, hex6t, hex7t;
//highscores
wire [10:0]highscorej;
wire [10:0]highscorez;
wire [10:0]highscoreb;
wire [10:0]highscoret;

always @(posedge CLOCK_50) begin
	
	if(~KEY[3] && ~KEY[2] && ~KEY[1] && ~menuon) begin
		forset <= 1;
		backset <= 1;
		menuon <= 1;
		jumpEN <= 0;
		zapsEN <= 0;
		beatEN <= 0;
		timeEN <= 0;
	end
	
	if(KEY[1]) begin //reset forward press
		forset <= 0;
	end
	
	if(KEY[2]) begin //reset backward press
		backset <= 0;
	end
	
	if(menuon) begin

//-----------------------------STATE MACHINE-----------------------------//
		case(state)
			JUMP: begin
				LEDR <= 18'b00000000000000000;
				LEDG <= 8'b00001000;
				HEX3 <= 7'b1110001;
				HEX2 <= 7'b1000001;
				HEX1 <= 7'b1001000;
				HEX0 <= 7'b0001100;
				
				//HIGHSCORE
				HEX7 <= 7'b0001001;
				HEX6 <= 7'b0110111;
				
				case(highscorej/10)
					0: HEX5 <= 7'b1000000;
					1: HEX5 <= 7'b1111001;
					2: HEX5 <= 7'b0100100;
					3: HEX5 <= 7'b0110000;
					4: HEX5 <= 7'b0011001;
					5: HEX4 <= 7'b0010010;
					6: HEX4 <= 7'b0000010;
					7: HEX4 <= 7'b1111000;
					8: HEX4 <= 7'b0000000;
					9: HEX4 <= 7'b0010000;
				endcase
				
				case(highscorej%10)
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
				
				if(~KEY[2] && forset == 0 && backset == 0) begin //backward
					state <= TIME;
					backset <= 1;
				end
				
				if(~KEY[1] && forset == 0 && backset == 0) begin //forward
					state <= ZAPS;
					forset <= 1;
				end
				
				if(~KEY[0]) begin //select game
					menuon <= 0;
					jumpEN <= 1;
				end

			end
			
			ZAPS: begin
				LEDR <= 18'b00000000000000000;
				LEDG <= 8'b00000100;
				
				HEX3 <= 7'b0100100;
				HEX2 <= 7'b0001000;
				HEX1 <= 7'b0001100;
				HEX0 <= 7'b0010010;
				
				//HIGHSCORE
				HEX7 <= 7'b0001001;
				HEX6 <= 7'b0110111;
				
				case(highscorez/10)
					0: HEX5 <= 7'b1000000;
					1: HEX5 <= 7'b1111001;
					2: HEX5 <= 7'b0100100;
					3: HEX5 <= 7'b0110000;
					4: HEX5 <= 7'b0011001;
					5: HEX4 <= 7'b0010010;
					6: HEX4 <= 7'b0000010;
					7: HEX4 <= 7'b1111000;
					8: HEX4 <= 7'b0000000;
					9: HEX4 <= 7'b0010000;
				endcase
				
				case(highscorez%10)
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
				
				if(~KEY[2] && forset == 0 && backset == 0) begin //backward
					state <= JUMP;
					backset <= 1;
				end
				
				if(~KEY[1] && forset == 0 && backset == 0) begin //forward
					state <= BEAT;
					forset <= 1;
				end
				
				if(~KEY[0]) begin //select game
					menuon <= 0;
					zapsEN <= 1;
				end

			end
			
			BEAT: begin
				LEDR <= 18'b00000000000000000;
				LEDG <= 8'b00000010;
				HEX3 <= 7'b0000000;
				HEX2 <= 7'b0000110;
				HEX1 <= 7'b0001000;
				HEX0 <= 7'b1111000;
				
				//HIGHSCORE
				HEX7 <= 7'b0001001;
				HEX6 <= 7'b0110111;
				
				case(highscoreb/10)
					0: HEX5 <= 7'b1000000;
					1: HEX5 <= 7'b1111001;
					2: HEX5 <= 7'b0100100;
					3: HEX5 <= 7'b0110000;
					4: HEX5 <= 7'b0011001;
					5: HEX4 <= 7'b0010010;
					6: HEX4 <= 7'b0000010;
					7: HEX4 <= 7'b1111000;
					8: HEX4 <= 7'b0000000;
					9: HEX4 <= 7'b0010000;
				endcase
				
				case(highscoreb%10)
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
				
				if(~KEY[2] && forset == 0 && backset == 0) begin //backward
					state <= ZAPS;
					backset <= 1;
				end
				
				if(~KEY[1] && forset == 0 && backset == 0) begin //forward
					state <= TIME;
					forset <= 1;
				end
				
				if(~KEY[0]) begin //select game
					menuon <= 0;
					beatEN <= 1;
				end

			end
			
			TIME: begin
				LEDR <= 18'b00000000000000000;
				LEDG <= 8'b00000001;
				HEX3 <= 7'b1111000;
				HEX2 <= 7'b1111001;
				HEX1 <= 7'b1001000;
				HEX0 <= 7'b0000110;
				
				//HIGHSCORE
				HEX7 <= 7'b0001001;
				HEX6 <= 7'b0110111;
				
				case(highscoret/10)
					0: HEX5 <= 7'b1000000;
					1: HEX5 <= 7'b1111001;
					2: HEX5 <= 7'b0100100;
					3: HEX5 <= 7'b0110000;
					4: HEX5 <= 7'b0011001;
					5: HEX4 <= 7'b0010010;
					6: HEX4 <= 7'b0000010;
					7: HEX4 <= 7'b1111000;
					8: HEX4 <= 7'b0000000;
					9: HEX4 <= 7'b0010000;
				endcase
				
				case(highscoret%10)
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
				
				if(~KEY[2] && forset == 0 && backset == 0) begin //backward
					state <= BEAT;
					backset <= 1;
				end
				
				if(~KEY[1] && forset == 0 && backset == 0) begin //forward
					state <= JUMP;
					forset <= 1;
				end
				
				if(~KEY[0]) begin //select game
					menuon <= 0;
					timeEN <= 1;
				end

			end
		endcase
		
	end

//-----------------------------SET DISPLAYS-----------------------------//
	if(jumpEN) begin
		LEDG <= ledgj;
		LEDR <= ledrj;
		HEX0 <= hex0j;
		HEX1 <= hex1j;
		HEX2 <= hex2j;
		HEX3 <= hex3j;
		HEX4 <= hex4j;
		HEX5 <= hex5j;
		HEX6 <= hex6j;
		HEX7 <= hex7j;
	end else if(zapsEN) begin
		LEDG <= ledgz;
		LEDR <= ledrz;
		HEX0 <= hex0z;
		HEX1 <= hex1z;
		HEX2 <= hex2z;
		HEX3 <= hex3z;
		HEX4 <= hex4z;
		HEX5 <= hex5z;
		HEX6 <= hex6z;
		HEX7 <= hex7z;
	end else if (beatEN) begin
		LEDG <= ledgb;
		LEDR <= ledrb;
		HEX0 <= hex0b;
		HEX1 <= hex1b;
		HEX2 <= hex2b;
		HEX3 <= hex3b;
		HEX4 <= hex4b;
		HEX5 <= hex5b;
		HEX6 <= hex6b;
		HEX7 <= hex7b;
	end else if (timeEN) begin
		LEDG <= ledgt;
		LEDR <= ledrt;
		HEX0 <= hex0t;
		HEX1 <= hex1t;
		HEX2 <= hex2t;
		HEX3 <= hex3t;
		HEX4 <= hex4t;
		HEX5 <= hex5t;
		HEX6 <= hex6t;
		HEX7 <= hex7t;
	end
	
end

//--------------------------------RUN GAMES--------------------------------//
jumpgame runjump(CLOCK_50, SW, ledrj, ledgj, KEY, hex0j, hex1j, hex2j, hex3j, hex4j, hex5j, hex6j, hex7j, jumpEN, highscorej);
zapsgame runzaps(CLOCK_50, SW, ledrz, ledgz, KEY, hex0z, hex1z, hex2z, hex3z, hex4z, hex5z, hex6z, hex7z, zapsEN, highscorez);
beat runbeat(CLOCK_50, SW, ledrb, ledgb, KEY, hex0b, hex1b, hex2b, hex3b, hex4b, hex5b, hex6b, hex7b, beatEN, highscoreb);
timegame runtime(CLOCK_50, SW, ledrt, ledgt, KEY, hex0t, hex1t, hex2t, hex3t, hex4t, hex5t, hex6t, hex7t, timeEN, highscoret);

endmodule