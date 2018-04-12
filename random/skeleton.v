module skeleton(clock, seed0, seed1, data0, data1);

	input clock;
	input [7:0] seed0, seed1;
	output [7:0] data0, data1;
	
	random8_cell cell0(clock, seed0, data0);
	random8_cell cell1(clock, seed1, data1);
	
endmodule
