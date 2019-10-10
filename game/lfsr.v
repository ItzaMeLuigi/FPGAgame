module lfsr(clk, preset, load, li, s);
input clk, preset, li;
input[4:0] load;
output[4:0] s;
wire uzi;
wire[4:0] z;

xor(uzi, s[4], s[2]);

tflipflop ff1(uzi, clk, preset,  li, load[0], s[0]);  
tflipflop ff2(s[0], clk, preset,  li, load[1], s[1]); 
tflipflop ff3(s[1], clk, preset,  li, load[2], s[2]); 
tflipflop ff4(s[2], clk, preset,  li, load[3], s[3]); 
tflipflop ff5(s[3], clk, preset,  li, load[4], s[4]); 

endmodule
