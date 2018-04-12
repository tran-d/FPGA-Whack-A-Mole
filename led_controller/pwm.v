module pwm (
	clk,	
	pwm_codeword,
	pwm_out
);

	input clk;
	input [7:0] pwm_codeword;
	
	output reg pwm_out;
	
	wire [7:0] c_out; 

	always @(posedge clk) begin
	
		if(pwm_codeword > c_out)
			pwm_out <= 1;
		else	
			pwm_out <= 0;
	
	end
	
	counter count_mod(.clk(clk), .c_out(c_out));

endmodule

module counter (
	
	clk,
	c_out
		
);

	input clk;
	output reg [7:0] c_out;
	
	always @(posedge clk) begin
	
		c_out <= c_out + 1'b1;
	
	end

endmodule
