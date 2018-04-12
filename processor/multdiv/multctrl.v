module multctrl(sR_out, alu_out, multiplier, multiplicand, 
					 clock, ctrl_reset,
					 sR_in, alu_in0, alu_in1, alu_overflow, alu_op, data_result, 
					 sR_in_ena, sR_aclr, data_exception, data_resultRDY);
					 
	input signed [63:0] sR_out;
	input signed [31:0] alu_out, multiplier, multiplicand;
	input clock, ctrl_reset, alu_overflow; 
	
	output signed [63:0] sR_in;
	output signed [31:0] alu_in0, alu_in1, data_result;
	output [4:0] alu_op;
	output sR_in_ena, sR_aclr, data_exception, data_resultRDY;

	// Solution Register
	assign sR_aclr = 1'b0;
	
	// ALU
	wire alu_add_sub; // (0: add, 1: sub)
	wire alu_record_sum;
	assign alu_op[4:1] = 4'b0;
	assign alu_op[0] = alu_add_sub;
	assign alu_in0 = sR_out[63:32];
	assign alu_in1 = multiplicand;
		
	// Operation counter
	wire [31:0] oC_in, oC_out;
	wire oC_in_ena, oC_aclr;
	reg32 operationCounter_oC(oC_in, clock, oC_aclr, oC_in_ena, oC_out); 
	assign oC_in = ctrl_reset? 32'hFFFFFFFF : oC_out << 1;
	assign oC_in_ena = 1'b1;
	assign oC_aclr = 1'b0;
	
	// Multiplier bits
	wire multiplier_dff_out;
	wire [1:0] multiplier_bits;
	assign multiplier_bits[1] = ctrl_reset? multiplier_bits[0] : sR_out[0];
	assign multiplier_bits[0] = ctrl_reset? 1'b0 : multiplier_dff_out;
	dflipflop multiplier_bit0(multiplier_bits[1], clock, 1'b0, 1'b1, multiplier_dff_out);
	
	// Control signals from Multiplier bits
	assign alu_add_sub = multiplier_bits[1];
	assign alu_record_sum = multiplier_bits[1] ^ multiplier_bits[0];
	
	// Solution Register Input
	wire signed [63:0] sR_in_preShift, sR_in_postShift;
	
		// Solution before and after shift
		assign sR_in_preShift[63:32] = alu_record_sum? alu_out : sR_out[63:32];
		assign sR_in_preShift[31:0] = sR_out[31:0];
		assign sR_in_postShift = sR_in_preShift >>> 1;
		
		// Solution after checking reset control
		assign sR_in[63:32] = ctrl_reset? 32'b0 : sR_in_postShift[63:32];
		assign sR_in[31:0] = ctrl_reset? multiplier : sR_in_postShift[31:0];
		
		// Solution Register Input Enable
		assign sR_in_ena = oC_out[31] | ctrl_reset; // ctrl_reset...need to write multiplier when reset enabled
		
	// Data Exception edge case
//	wire alu_overflow_latch, alu_prn;
//	dflipflop alu_overflow_detector(alu_overflow_latch | alu_overflow, clock, !ctrl_reset, alu_prn, 1'b1, alu_overflow_latch);
		
	// Results
	assign data_result 	 = sR_out[31:0];
	assign data_resultRDY =  !oC_out[31];
	assign data_exception = (|sR_out[63:31]) & !(&sR_out[63:31]);
//	assign data_exception = (sR_out[31] ^ (|sR_out[63:32])) | (sR_out[31] ^ (&sR_out[63:32]));


endmodule
