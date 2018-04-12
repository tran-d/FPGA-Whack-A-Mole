module register32(in, in_ena, clk, aclr, out);

	input [31:0] in;
	input in_ena, clk, aclr;
	
	output [31:0] out;
	
	wire prn;
	
	genvar i;
	generate
		for (i=0; i<32; i=i+1) begin: loop1
			dflipflop my_dff(in[i], clk, ~aclr, prn, in_ena, out[i]);	// attach d-flip-flops
		end		
	endgenerate
	
endmodule
	