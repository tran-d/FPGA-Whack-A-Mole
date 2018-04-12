module or32(out, in1, in2);

	input [31:0] in1, in2;
	output [31:0] out;
	
	generate
		genvar i;
		for(i=0; i<32; i=i+1) begin: bit_loop
			or or1(out[i], in1[i], in2[i]);
		end
	endgenerate
	
endmodule
