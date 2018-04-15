module multdiv(data_operandA, data_operandB, ctrl_MULT, ctrl_DIV, clock, data_result, data_exception, data_resultRDY_actually);
   
	input signed [31:0] data_operandA, data_operandB;
   input ctrl_MULT, ctrl_DIV, clock;

   output signed [31:0] data_result;
	output data_exception, data_resultRDY_actually;
	 
	// Solution Register
	wire signed [63:0] sR_in, sR_out;
	wire sR_in_ena, sR_aclr, data_resultRDY;
	reg64 solutionReg_sR(sR_in, clock, sR_aclr, sR_in_ena, sR_out);
	 
	// ALU
	wire signed [31:0] alu_in0, alu_in1, alu_out;
	wire [4:0] alu_op;
	wire alu_negativeResult, alu_notEqual, alu_overflow;
	alu_md adder_alu(alu_in0, alu_in1, alu_op, 5'b0, alu_out, alu_notEqual, alu_negativeResult, alu_overflow);
	
	// Multiplier-Divider control (0: MULT, 1: DIV)
	wire ctrl_MULT_DIV, d_MULT_DIV, q_MULT_DIV;
	assign ctrl_MULT_DIV = (!ctrl_MULT) & (ctrl_DIV | q_MULT_DIV);
	assign d_MULT_DIV = ctrl_MULT_DIV;
	dflipflop mult_div_dff(d_MULT_DIV, clock, 1'b0, 1'b1, q_MULT_DIV);
	
	// Divider
	wire signed [63:0] DIV_sR_in;
	wire signed [31:0] DIV_alu_in0, DIV_alu_in1, DIV_data_result;
	wire [4:0] DIV_alu_op;
	wire DIV_sR_in_ena, DIV_sR_aclr, DIV_data_exception, DIV_data_resultRDY;

	divctrl divider(
					.sR_out					(sR_out), 
					.alu_out					(alu_out), 
					.divisor					(data_operandB), 
					.dividend				(data_operandA), 
					.clock					(clock), 
					.ctrl_reset				(ctrl_DIV), 
					.perform_subtraction	(!alu_negativeResult), 
					.sR_in					(DIV_sR_in), 
					.alu_in0					(DIV_alu_in0), 
					.alu_in1					(DIV_alu_in1), 
					.alu_op					(DIV_alu_op), 
					.data_result			(DIV_data_result), 
					.sR_in_ena				(DIV_sR_in_ena), 
					.sR_aclr					(DIV_sR_aclr), 
					.data_exception		(DIV_data_exception), 
					.data_resultRDY		(DIV_data_resultRDY)
	);
	
	// Multiplier
	wire signed [63:0] MULT_sR_in;
	wire signed [31:0] MULT_alu_in0, MULT_alu_in1, MULT_data_result;
	wire [4:0] MULT_alu_op;
	wire MULT_sR_in_ena, MULT_sR_aclr, MULT_data_exception, MULT_data_resultRDY;

	multctrl multiplier(
					.sR_out					(sR_out), 
					.alu_out					(alu_out), 
					.alu_overflow			(alu_overflow),
					.multiplier				(data_operandB), 
					.multiplicand			(data_operandA), 
					.clock					(clock), 
					.ctrl_reset				(ctrl_MULT), 
					.sR_in					(MULT_sR_in), 
					.alu_in0					(MULT_alu_in0), 
					.alu_in1					(MULT_alu_in1), 
					.alu_op					(MULT_alu_op), 
					.data_result			(MULT_data_result), 
					.sR_in_ena				(MULT_sR_in_ena), 
					.sR_aclr					(MULT_sR_aclr), 
					.data_exception		(MULT_data_exception), 
					.data_resultRDY		(MULT_data_resultRDY)
	);
	
	// Multiplex Multiplier-Divider outputs
	assign sR_in = ctrl_MULT_DIV? DIV_sR_in : MULT_sR_in;
	assign sR_in_ena = ctrl_MULT_DIV? DIV_sR_in_ena : MULT_sR_in_ena;
	assign sR_aclr = ctrl_MULT_DIV? DIV_sR_aclr : MULT_sR_aclr;
	assign alu_in0 = ctrl_MULT_DIV? DIV_alu_in0 : MULT_alu_in0;
	assign alu_in1 = ctrl_MULT_DIV? DIV_alu_in1 : MULT_alu_in1;
	assign alu_op = ctrl_MULT_DIV? DIV_alu_op : MULT_alu_op;
	assign data_exception = ctrl_MULT_DIV? DIV_data_exception : MULT_data_exception;
	assign data_resultRDY = ctrl_MULT_DIV? DIV_data_resultRDY : MULT_data_resultRDY;
	assign data_result = ctrl_MULT_DIV? DIV_data_result : MULT_data_result;
	
	
	/* processor integration */
	wire data_resultRDY_latch;
	reg currently_solving;
	
	initial begin
		currently_solving <= 1'b0;
	
	always @(negedge clock)
	begin
		if(ctrl_MULT | ctrl_DIV)
			currently_solving <= 1'b1;
		else if(data_resultRDY_latch)  // need to latch
			currently_solving <= 1'b0;
	end
	
	dflipflop my_dff(data_resultRDY, clock, 1'b0, 1'b1, data_resultRDY_latch);
	
	assign data_resultRDY_actually = currently_solving && data_resultRDY;
	
endmodule
