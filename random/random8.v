module random8(clock, seeds, data);

	input clock;
	input [63:0] seeds;
	
	output [7:0] data;
	
	wire [7:0] cell_data [7:0];
	
	random8_cell rc1(clock, seeds[7:0], cell_data[0]);
	random8_cell rc2(clock, seeds[15:8], cell_data[1]);
	random8_cell rc3(clock, seeds[23:16], cell_data[2]);
	random8_cell rc4(clock, seeds[31:24], cell_data[3]);
	random8_cell rc5(clock, seeds[39:32], cell_data[4]);
	random8_cell rc6(clock, seeds[47:40], cell_data[5]);
	random8_cell rc7(clock, seeds[55:48], cell_data[6]);
	random8_cell rc8(clock, seeds[63:56], cell_data[7]);
	
	generate
		genvar i;
		for(i = 0; i < 8; i = i + 1) begin: loop
			assign data[i] = cell_data[i][0];
		end
	endgenerate


endmodule
