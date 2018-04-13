module led_array(clock, pins, commands);

	input clock;
	input [143:0] commands;
	
	output [17:0] pins; // 0 -> 17: (0b, 0r, 1b, 1r, ... , 8b, 8r)
	
	led led0(~clock, commands[15:0], 	pins[1],  pins[0]);
	led led1(~clock, commands[31:16], 	pins[3],  pins[2]);
	led led2(~clock, commands[47:32], 	pins[5],  pins[4]);
	led led3(~clock, commands[63:48], 	pins[7],  pins[6]);
	led led4(~clock, commands[79:64],	pins[9],  pins[8]);
	led led5(~clock, commands[95:80],   pins[11], pins[10]);
	led led6(~clock, commands[111:96],  pins[13], pins[12]);
	led led7(~clock, commands[127:112], pins[15], pins[14]);
	led led8(~clock, commands[143:128], pins[17], pins[16]);

endmodule
