module multdiv_controller(
	data_operandA, 
	data_operandB, 
	mul, 
	div, 
	clock, 
	latch_multdiv3_out, 
	multdiv_exception, 
	multdiv_RDY
);
   input [31:0] data_operandA, data_operandB; 
	input mul, div, clock;
	
	output [31:0] latch_multdiv3_out;
	output multdiv_exception, multdiv_RDY;
	
	wire [31:0] latch_data_operandA, latch_data_operandB, multdiv_result, latch_multdiv1_out, latch_multdiv2_out;
	wire latch_ctrl_MULT, latch_ctrl_DIV;
	reg ctrl_MULT, ctrl_DIV; 
	
	initial begin
		ctrl_MULT <= 1'b0;
		ctrl_DIV <= 1'b0;
	end
	
	always @(posedge clock)
	begin
	if(mul)
		ctrl_MULT = 1'b1;
	else if(div)
		ctrl_DIV = 1'b1;
	else if(latch_ctrl_MULT)
		ctrl_MULT = 1'b0;
	else if(latch_ctrl_DIV)
		ctrl_DIV = 1'b0;
	end
	
	
	
	latch_ctrl ctrl_mult(ctrl_MULT, clock, 1'b0, 1'b1, latch_ctrl_MULT);
	latch_ctrl ctrl_div(ctrl_DIV, clock, 1'b0, 1'b1, latch_ctrl_DIV);
	
	multdiv my_multdiv(data_operandA, data_operandB, ctrl_MULT, ctrl_DIV, clock, multdiv_result, multdiv_exception, multdiv_RDY);
	
	wire latch_operand_ena = ctrl_MULT || ctrl_DIV;
	
	latch_multdiv latch_operandA(data_operandA, clock, 1'b0, latch_operand_ena, latch_data_operandA);
	latch_multdiv latch_operandB(data_operandB, clock, 1'b0, latch_operand_ena, latch_data_operandB);
	latch_multdiv latch_multdiv1(multdiv_result, clock, 1'b0, multdiv_RDY, latch_multdiv1_out);
	latch_multdiv latch_multdiv2(latch_multdiv1_out, clock, 1'b0, 1'b1, latch_multdiv2_out);
	latch_multdiv latch_multdiv3(latch_multdiv2_out, clock, 1'b0, 1'b1, latch_multdiv3_out);
	
endmodule


module latch_multdiv(in, clock, reset, enable, out);
	
	input [31:0] in;
	input clock, reset, enable;
	output [31:0] out;
	
	reg32 my_reg32(in, clock, reset, enable, out);

endmodule

module latch_ctrl(in, clock, reset, enable, out);
	
	input in;
	input clock, reset, enable;
	output out;
	
	dflipflop my_dff(in, clock, reset, enable, out);

endmodule

