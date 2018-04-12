module decoder3_to_8(in, out);
	
	input [2:0] in;
	output [7:0] out;	
	wire [2:0] in_0;
	
	not not0(in_0[0], in[0]);
	not not1(in_0[1], in[1]);
	not not2(in_0[2], in[2]);
	
	and and0(out[0],	in_0[2],	in_0[1],	in_0[0]);
	and and1(out[1], 	in_0[2],	in_0[1], in[0]);
	and and2(out[2], 	in_0[2],	in[1], 	in_0[0]);
	and and3(out[3], 	in_0[2],	in[1], 	in[0]);
	and and4(out[4], 	in[2],	in_0[1], in_0[0]);
	and and5(out[5], 	in[2],	in_0[1], in[0]);
	and and6(out[6], 	in[2],	in[1], 	in_0[0]);
	and and7(out[7], 	in[2],	in[1], 	in[0]);

endmodule
