module led(clock, code, pin_r, pin_g);

	input clock;
	input [15:0] code;
	output pin_r, pin_g;
	
	reg [7:0] red, green;
	
	initial begin
		red <= 8'b0;
		green <= 8'b0;
	end
	
	always @(posedge clock) begin
		red <= code[15:8];
		green <= code[7:0];	
	end
	
	pwm red_signal(.clk(clock), .pwm_codeword(red), .pwm_out(pin_r));
	pwm green_signal(.clk(clock), .pwm_codeword(green), .pwm_out(pin_g));
	
endmodule

