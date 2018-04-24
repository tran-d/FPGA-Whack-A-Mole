module sll(in, shift, out);
	
	input [31:0] in; 
	input [4:0] shift;
	output [31:0] out;
	
	wire [31:0] mid [3:0];
	
	sll1 s1(in,  mid[0], shift[0]);
	sll2 s2(mid[0], mid[1], shift[1]);
	sll4 s4(mid[1], mid[2], shift[2]);
	sll8 s8(mid[2], mid[3], shift[3]);
	sll16 s16(mid[3], out, shift[4]);
	
endmodule


module sll1(in, out, en);

	input en;
	input[31:0] in;
	output[31:0] out;
	wire[31:0] shifted;
	
	assign shifted[31:1] = in[30:0];
	assign shifted[0] = 1'b0;
	
	generate
		genvar i;
		for(i=0; i<32; i=i+1) begin: loop1
			assign out[i] = en? shifted[i] : in[i];
		end
	endgenerate

endmodule


module sll2(in, out, en);

	input en;
	input[31:0] in;
	output[31:0] out;
	wire[31:0] shifted;
	
	assign shifted[31:2] = in[29:0];
	assign shifted[1:0] = 2'b0;
	
	generate
		genvar i;
		for(i=0; i<32; i=i+1) begin: loop1
			assign out[i] = en? shifted[i] : in[i];
		end
	endgenerate

endmodule


module sll4(in, out, en);

	input en;
	input[31:0] in;
	output[31:0] out;
	wire[31:0] shifted;
	
	assign shifted[31:4] = in[27:0];
	assign shifted[3:0] = 4'b0;
	
	generate
		genvar i;
		for(i=0; i<32; i=i+1) begin: loop1
			assign out[i] = en? shifted[i] : in[i];
		end
	endgenerate

endmodule


module sll8(in, out, en);

	input en;
	input[31:0] in;
	output[31:0] out;
	wire[31:0] shifted;
	
	assign shifted[31:8] = in[23:0];
	assign shifted[7:0] = 8'b0;
	
	generate
		genvar i;
		for(i=0; i<32; i=i+1) begin: loop1
			assign out[i] = en? shifted[i] : in[i];
		end
	endgenerate

endmodule


module sll16(in, out, en);

	input en;
	input[31:0] in;
	output[31:0] out;
	wire[31:0] shifted;
	
	assign shifted[31:16] = in[15:0];
	assign shifted[15:0] = 16'b0;
	
	generate
		genvar i;
		for(i=0; i<32; i=i+1) begin: loop1
			assign out[i] = en? shifted[i] : in[i];
		end
	endgenerate

endmodule

