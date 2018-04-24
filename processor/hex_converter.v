module hex_converter(in, ones, tens, hundreds);

	input [31:0] in;
	output [3:0] ones, tens, hundreds;
	
	
	assign ones = (in % 32'd10);
	assign tens = (in % 32'd100)/32'd10;
	assign hundreds = (in % 32'd1000)/32'd100;


endmodule

