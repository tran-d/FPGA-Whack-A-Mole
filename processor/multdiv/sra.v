module sra(in, shift, out);
	
	input [31:0] in; 
	input [4:0] shift;
	output [31:0] out;
	
	wire [31:0] mid [3:0];
	
	sra1 s1(in,  mid[0], shift[0]);
	sra2 s2(mid[0], mid[1], shift[1]);
	sra4 s4(mid[1], mid[2], shift[2]);
	sra8 s8(mid[2], mid[3], shift[3]);
	sra16 s16(mid[3], out, shift[4]);
	
endmodule


module sra1(in, out, en);

	input en;
	input[31:0] in;
	output[31:0] out;
	wire[31:0] shifted;
	
	assign shifted[30:0] = in[31:1];
	
	generate
		genvar i;
		for(i=31; i>=31; i=i-1) begin: loop2
			assign shifted[i] = en? in[31] : in[i];
		end
	endgenerate
	
	generate
		genvar j;
		for(j=0; j<32; j=j+1) begin: loop1
			assign out[j] = en? shifted[j] : in[j];
		end
	endgenerate

endmodule


module sra2(in, out, en);

	input en;
	input[31:0] in;
	output[31:0] out;
	wire[31:0] shifted;
	
	assign shifted[29:0] = in[31:2];
	
	generate
		genvar i;
		for(i=31; i>=30; i=i-1) begin: loop2
			assign shifted[i] = en? in[31] : in[i];
		end
	endgenerate
	
	generate
		genvar j;
		for(j=0; j<32; j=j+1) begin: loop1
			assign out[j] = en? shifted[j] : in[j];
		end
	endgenerate

endmodule


module sra4(in, out, en);

	input en;
	input[31:0] in;
	output[31:0] out;
	wire[31:0] shifted;
	
	assign shifted[27:0] = in[31:4];
	
	generate
		genvar i;
		for(i=31; i>=28; i=i-1) begin: loop2
			assign shifted[i] = en? in[31] : in[i];
		end
	endgenerate
	
	generate
		genvar j;
		for(j=0; j<32; j=j+1) begin: loop1
			assign out[j] = en? shifted[j] : in[j];
		end
	endgenerate

endmodule


module sra8(in, out, en);

	input en;
	input[31:0] in;
	output[31:0] out;
	wire[31:0] shifted;
	
	assign shifted[23:0] = in[31:8];
	
	generate
		genvar i;
		for(i=31; i>=24; i=i-1) begin: loop2
			assign shifted[i] = en? in[31] : in[i];
		end
	endgenerate
	
	generate
		genvar j;
		for(j=0; j<32; j=j+1) begin: loop1
			assign out[j] = en? shifted[j] : in[j];
		end
	endgenerate

endmodule


module sra16(in, out, en);

	input en;
	input[31:0] in;
	output[31:0] out;
	wire[31:0] shifted;
	
	assign shifted[15:0] = in[31:16];
	
	generate
		genvar i;
		for(i=31; i>=16; i=i-1) begin: loop2
			assign shifted[i] = en? in[31] : in[i];
		end
	endgenerate
	
	generate
		genvar j;
		for(j=0; j<32; j=j+1) begin: loop1
			assign out[j] = en? shifted[j] : in[j];
		end
	endgenerate

endmodule
