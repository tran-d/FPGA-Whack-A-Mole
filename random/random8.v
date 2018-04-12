module random8(clock, seed0, seed1, seed2, seed3, seed4, seed5, seed6, seed7, data);

	input clock;
	input [7:0] seed0, seed1, seed2, seed3, seed4, seed5, seed6, seed7;
	
	output [7:0] data;
	
	wire [7:0] cell_data [7:0];
	
	random8_cell rc1(clock, seed0, cell_data[0]);
	random8_cell rc2(clock, seed1, cell_data[1]);
	random8_cell rc3(clock, seed2, cell_data[2]);
	random8_cell rc4(clock, seed3, cell_data[3]);
	random8_cell rc5(clock, seed4, cell_data[4]);
	random8_cell rc6(clock, seed5, cell_data[5]);
	random8_cell rc7(clock, seed6, cell_data[6]);
	random8_cell rc8(clock, seed7, cell_data[7]);
	
	generate
		genvar i;
		for(i = 0; i < 8; i = i + 1) begin: loop
			assign data[i] = cell_data[i][0];
		end
	endgenerate


endmodule
