module cla8(x, y, cin, G, P, sum);

	input [7:0] x, y;
	input cin;
	
	output [7:0] sum;
	output G, P;
	
	wire [7:0] g, p, c;
	wire [6:0] g_mid;
	
	// Calculate Generate/Propogate: g, p, G, P, Sums: sum
	generate 
		genvar i;

		for(i=0; i<8; i=i+1) begin: loop1
			and and0(g[i], x[i], y[i]);
			xor or0(p[i], x[i], y[i]);
			xor or1(sum[i], p[i], c[i]); // sum
		end
		
		
	endgenerate
	
	and and_propogate(P, p[7], p[6], p[5], p[4], p[3], p[2], p[1], p[0]);
	
	and and_generate_0(g_mid[0], p[7], p[6], p[5], p[4], p[3], p[2], p[1], g[0]);
	and and_generate_1(g_mid[1], p[7], p[6], p[5], p[4], p[3], p[2], g[1]);
	and and_generate_2(g_mid[2], p[7], p[6], p[5], p[4], p[3], g[2]);
	and and_generate_3(g_mid[3], p[7], p[6], p[5], p[4], g[3]);
	and and_generate_4(g_mid[4], p[7], p[6], p[5], g[4]);
	and and_generate_5(g_mid[5], p[7], p[6], g[5]);
	and and_generate_6(g_mid[6], p[7], g[6]);
	or or_generate(G, g[7], g_mid[6], g_mid[5], g_mid[4], g_mid[3], g_mid[2], g_mid[1], g_mid[0]);
	
	
	// Calculate Carry Signals: c
		
		// c0
		assign c[0] = cin;
	
		// c1
		wire c1;
		and and_c1_0(c1, p[0], c[0]);
		or  or_c1(c[1], g[0], c1);
		
		// c2
		wire [1:0] c2;
		and and_c2_0(c2[0], p[1], p[0], c[0]);
		and and_c2_1(c2[1], p[1], g[0]);
		or  or_c2(c[2], g[1], c2[1], c2[0]);
		
		// c3
		wire [2:0] c3;
		and and_c3_0(c3[0], p[2], p[1], p[0], c[0]);
		and and_c3_1(c3[1], p[2], p[1], g[0]);
		and and_c3_2(c3[2], p[2], g[1]);
		or  or_c3(c[3], g[2], c3[2], c3[1], c3[0]);
		
		// c4
		wire [3:0] c4;
		and and_c4_0(c4[0], p[3], p[2], p[1], p[0], c[0]);
		and and_c4_1(c4[1], p[3], p[2], p[1], g[0]);
		and and_c4_2(c4[2], p[3], p[2], g[1]);
		and and_c4_3(c4[3], p[3], g[2]);
		or  or_c4(c[4], g[3], c4[3], c4[2], c4[1], c4[0]);
		
		// c5
		wire [4:0] c5;
		and and_c5_0(c5[0], p[4], p[3], p[2], p[1], p[0], c[0]);
		and and_c5_1(c5[1], p[4], p[3], p[2], p[1], g[0]);
		and and_c5_2(c5[2], p[4], p[3], p[2], g[1]);
		and and_c5_3(c5[3], p[4], p[3], g[2]);
		and and_c5_4(c5[4], p[4], g[3]);
		or  or_c5(c[5], g[4], c5[4], c5[3], c5[2], c5[1], c5[0]);
		
		// c6
		wire [5:0] c6;
		and and_c6_0(c6[0], p[5], p[4], p[3], p[2], p[1], p[0], c[0]);
		and and_c6_1(c6[1], p[5], p[4], p[3], p[2], p[1], g[0]);
		and and_c6_2(c6[2], p[5], p[4], p[3], p[2], g[1]);
		and and_c6_3(c6[3], p[5], p[4], p[3], g[2]);
		and and_c6_4(c6[4], p[5], p[4], g[3]);
		and and_c6_5(c6[5], p[5], g[4]);
		or  or_c6(c[6], g[5], c6[5], c6[4], c6[3], c6[2], c6[1], c6[0]);
		
		// c7 
		wire [6:0] c7;
		and and_c7_0(c7[0], p[6], p[5], p[4], p[3], p[2], p[1], p[0], c[0]);
		and and_c7_1(c7[1], p[6], p[5], p[4], p[3], p[2], p[1], g[0]);
		and and_c7_2(c7[2], p[6], p[5], p[4], p[3], p[2], g[1]);
		and and_c7_3(c7[3], p[6], p[5], p[4], p[3], g[2]);
		and and_c7_4(c7[4], p[6], p[5], p[4], g[3]);
		and and_c7_5(c7[5], p[6], p[5], g[4]);
		and and_c7_6(c7[6], p[6], g[5]);
		or  or_c7(c[7], g[6], c7[6], c7[5], c7[4], c7[3], c7[2], c7[1], c7[0]);

		

endmodule
