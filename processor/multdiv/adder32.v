module adder32_md(x, y, cin, sum, cout);
	
	input [31:0] x, y;
	input cin;
	
	output [31:0] sum;
	output cout;

	wire[3:0] G, P, c;
	
	
	// Connect Adder Blocks
	cla8 block0(x[7:0], y[7:0], cin, G[0], P[0], sum[7:0]);
	cla8 block1(x[15:8], y[15:8], c[0], G[1], P[1], sum[15:8]);
	cla8 block2(x[23:16], y[23:16], c[1], G[2], P[2], sum[23:16]);
	cla8 block3(x[31:24], y[31:24], c[2], G[3], P[3], sum[31:24]);
	
	
	// Connect Internal Carry-Signals
		// c8
		wire c8;
		and and_c8_0(c8, P[0], cin);
		or  or_c8(c[0], G[0], c8);
		
		// c16
		wire c16 [1:0];
		and and_c16_0(c16[0], P[1], P[0], cin);
		and and_c16_1(c16[1], P[1], G[0]);
		or  or_c16(c[1], G[1], c16[1], c16[0]);
		
		// c24
		wire c24 [2:0];
		and and_c24_0(c24[0], P[2], P[1], P[0], cin);
		and and_c24_1(c24[1], P[2], P[1], G[0]);
		and and_c24_2(c24[2], P[2], G[1]);
		or  or_c24(c[2], G[2], c24[2], c24[1], c24[0]);
		
		// c32
		wire c32 [3:0];
		and and_c32_0(c32[0], P[3], P[2], P[1], P[0], cin);
		and and_c32_1(c32[1], P[3], P[2], P[1], G[0]);
		and and_c32_2(c32[2], P[3], P[2], G[1]);
		and and_c32_3(c32[3], P[3], G[2]);
		or  or_c32(c[3], G[3], c32[3], c32[2], c32[1], c32[0]);
	
	// Connect Carry-out Signal
	assign cout = c[3];
endmodule
