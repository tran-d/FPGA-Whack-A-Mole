module divctrl(sR_out, alu_out, divisor, dividend, 
					clock, ctrl_reset, perform_subtraction, 
					sR_in, alu_in0, alu_in1, alu_op, data_result, 
					sR_in_ena, sR_aclr, data_exception, data_resultRDY);

	input [63:0] sR_out;
	input [31:0] alu_out, divisor, dividend;
	input clock, ctrl_reset, perform_subtraction; 
	
	output [63:0] sR_in;
	output [31:0] alu_in0, alu_in1, data_result;
	output [4:0] alu_op;
	output sR_in_ena, sR_aclr, data_exception, data_resultRDY;
	
	// Solution Register
	assign sR_aclr = 1'b0;
	
	// Negate inputs if needed
	wire [31:0] divisor_u, dividend_u;
	wire [4:0] divisor_negator_op, dividend_negator_op;
	wire dne1, dlt1, dovf1, dne2, dlt2, dovf2, dne3, dlt3, dovf3;
	
	assign divisor_negator_op[4:1] = 4'b0;
	assign divisor_negator_op[0] = divisor[31];
	assign dividend_negator_op[4:1] = 4'b0;
	assign dividend_negator_op[0] = dividend[31];
	
	alu_md divisor_negator(.data_operandA(32'b0), .data_operandB(divisor), .ctrl_ALUopcode(divisor_negator_op), 
							  .ctrl_shiftamt(5'b0), .data_result(divisor_u), .isNotEqual(dne1), .isLessThan(dlt1), .overflow(dovf1));
	alu_md dividend_negator(.data_operandA(32'b0), .data_operandB(dividend), .ctrl_ALUopcode(dividend_negator_op), 
							   .ctrl_shiftamt(5'b0), .data_result(dividend_u), .isNotEqual(dne2), .isLessThan(dlt2), .overflow(dovf2));
							
	// ALU
	wire [31:0] remainder;
	wire perform_subtraction;
	assign alu_op = 5'b1;
	assign alu_in0 = sR_out[63:32];
	assign alu_in1 = divisor_u;
	assign remainder = alu_out;
	
	// Operation counter
	wire [31:0] oC_in, oC_out;
	wire oC_in_ena, oC_aclr;
	reg32 operationCounter_oC(oC_in, clock, oC_aclr, oC_in_ena, oC_out); 
	assign oC_in = ctrl_reset? 32'hFFFFFFFF : oC_out << 1;
	assign oC_in_ena = 1'b1;
	assign oC_aclr = 1'b0;
	
	
	// Solution Register Input
	wire [63:0] sR_in_preShift, sR_in_postShift;
	
	// Solution before and after shift
	assign sR_in_preShift[63:32] = perform_subtraction? remainder : sR_out[63:32];
	assign sR_in_preShift[31:1] = sR_out[31:1];
	assign sR_in_preShift[0] = perform_subtraction;
	assign sR_in_postShift = sR_in_preShift << 1;
	
	// Solution after checking reset control
	assign sR_in[63:32] = ctrl_reset? 32'b0 : sR_in_postShift[63:32];
	assign sR_in[31:0] = ctrl_reset? dividend_u : sR_in_postShift[31:0];
	
	// Solution Register Input Enable
	assign sR_in_ena = oC_out[31] | ctrl_reset; // ctrl_reset...need to write dividend when reset enabled
	
	// Negate output if needed
	wire [31:0] quotient, quotient_u;
	wire [4:0] quotient_negator_op;
	
	assign quotient_negator_op[4:1] = 4'b0;
	assign quotient_negator_op[0] = divisor[31] ^ dividend[31];
	
	assign quotient_u[31:1] = sR_out[31:1];
	assign quotient_u[0] = perform_subtraction; // Show result on same clock cycle as calculation
	
	alu_md quotient_negator(.data_operandA(32'b0), .data_operandB(quotient_u), .ctrl_ALUopcode(quotient_negator_op),
							   .ctrl_shiftamt(5'b0), .data_result(quotient), .isNotEqual(dne3), .isLessThan(dlt3), .overflow(dovf3));  // Negate if input signs disagree
	
	// Add one cycle delay for result Flag to allow output negation to propogate (worst case)
	wire data_ready;
	dflipflop ready_delay(!oC_out[31], clock, 1'b0, 1'b1, data_ready);
	
	// Results
	assign data_result = quotient;
	assign data_resultRDY = data_ready;
	assign data_exception = !(|divisor);
	
endmodule
