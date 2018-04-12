module led_array(clock, pins, 
					  code0, code1, code2, code3, code4, code5, code6, code7, code8);

	input clock;
	input [15:0] code0, code1, code2, code3, code4, code5, code6, code7, code8;
	
	output [17:0] pins; // 0 -> 17: (0b, 0r, 1b, 1r, ... , 8b, 8r)
	
	led led0(~clock, code0, pins[1],  pins[0]);
	led led1(~clock, code1, pins[3],  pins[2]);
	led led2(~clock, code2, pins[5],  pins[4]);
	led led3(~clock, code3, pins[7],  pins[6]);
	led led4(~clock, code4, pins[9],  pins[8]);
	led led5(~clock, code5, pins[11], pins[10]);
	led led6(~clock, code6, pins[13], pins[12]);
	led led7(~clock, code7, pins[15], pins[14]);
	led led8(~clock, code8, pins[17], pins[16]);

endmodule
