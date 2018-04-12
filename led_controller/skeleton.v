module skeleton(clock, r_pin, g_pin);

	input clock;
	output r_pin, g_pin;
	
	wire[7:0] r = 8'd120;
	wire[7:0] g = 8'd120;
	
	led led0(clock, {r, g}, r_pin, g_pin);

endmodule
