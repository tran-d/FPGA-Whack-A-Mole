module random32(
	clock,
	reset,
	data
);

	input clock, reset;
	output reg [31:0] data; // [0, 2^32 - 1]

	wire feedback = data[31] ^ data[1] ;

	always @(posedge clock or posedge reset)
	  if (reset) 
		 data <= 32'hFFFFFF;
	  else
		 data <= {data[30:0], feedback} ;

endmodule

//module fibonacci_lfsr(
//	clk,
//	rst_n,
//	data
//);
//
//	input clk, rst_n;
//	output reg [4:0] data;
//
//	wire feedback = data[4] ^ data[1] ;
//
//	always @(posedge clk or negedge rst_n)
//	  if (~rst_n) 
//		 data <= 4'hf;
//	  else
//		 data <= {data[3:0], feedback} ;
//
//endmodule