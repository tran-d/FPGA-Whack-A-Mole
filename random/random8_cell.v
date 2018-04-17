module random8_cell(clock, seed, data);
	
	input clock;
	input [7:0] seed;
	
	output reg [7:0] data;	
	
	wire feedback = data[7] ^ data[1];
	wire feedback_seed = data[5] ^ data[3];
	
	initial begin
		data <= 8'hFF;
	end
	
	
	always @(posedge clock) begin
	
		if(feedback_seed) 
			data <= {data[6:0], feedback};
		else if (data == 6'b0)
			data <= 8'hFF;
		else
			data <= {data[6:0], feedback} + seed;
		
	end
	

endmodule
