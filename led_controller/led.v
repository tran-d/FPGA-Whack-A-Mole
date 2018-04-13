module led(clock, code, pin_r, pin_b);

	input clock;
	input [15:0] code;
	output pin_r, pin_b;
	
	reg [7:0] red, blue;
	
	initial begin
		red <= 8'b0;
		blue <= 8'b0;
	end
	
	always @(posedge clock) begin
		red <= code[15:8];
		blue <= code[7:0];	
	end
	
	pwm red_signal(.clk(clock), .pwm_codeword(red), .pwm_out(pin_r));
	pwm blue_signal(.clk(clock), .pwm_codeword(blue), .pwm_out(pin_b));
	
endmodule

