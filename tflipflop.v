module tflipflop(t, clk, preset, li, load, q);
input t, clk, li, load, preset;
output reg q;

always @(posedge clk or negedge preset) begin

	if (preset == 0) begin
		q <= 1; 
	end else if(li == 1 ) begin
		q <= load; 
	end else if (t == 1) begin
		q <= ~q; 
	end else begin
		q <= q;
	end
	
end

endmodule