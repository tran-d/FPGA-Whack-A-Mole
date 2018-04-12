module alu_md(data_operandA, data_operandB, ctrl_ALUopcode, ctrl_shiftamt, data_result, isNotEqual, isLessThan, overflow);

   input [31:0] data_operandA, data_operandB;
   input [4:0] ctrl_ALUopcode, ctrl_shiftamt;

   output [31:0] data_result;
   output isNotEqual, isLessThan, overflow;
	
	wire [7:0] submodule_choice;
	wire [31:0] submodule_results [5:0];
	
	wire [31:0] data_operandB_subtraction;
	wire [31:0] math_operandB;
	
	wire adder_cout;
	
	genvar i, j;	

   // Initialize Sub-Modules
	/*[000]*/ adder32_md adder(data_operandA, math_operandB, ctrl_ALUopcode[0], submodule_results[0], adder_cout);
	/*[001]*  subtraction uses adder */
	/*[010]*/ and32 bitwise_and(data_operandA, data_operandB, submodule_results[2]);
	/*[011]*/ or32   bitwise_or(data_operandA, data_operandB, submodule_results[3]);
	/*[100]*/ sll shift_left_logical(data_operandA, ctrl_shiftamt, submodule_results[4]);
	/*[101]*/ sra shift_right_arithmetic(data_operandA, ctrl_shiftamt, submodule_results[5]);
	
	
	// Coordinate Sub-Module Outputs
	decoder3to8 submodule_chooser(ctrl_ALUopcode[2:0], submodule_choice);
	generate
		for(i=0; i<6; i=i+1) begin: module_loop
			for(j=0; j<32; j=j+1) begin: bit_loop
				tristate_buffer tbuf(submodule_results[i][j], submodule_choice[i], data_result[j]);
			end
		end
	endgenerate
	
	
	// Coordinate subtraction/addition through adder module
	assign submodule_results[1] = submodule_results[0];
	generate
		for(i=0; i<32; i=i+1) begin: inverter_loop
			not sub_not(data_operandB_subtraction[i], data_operandB[i]);
			assign math_operandB[i] = ctrl_ALUopcode[0]? data_operandB_subtraction[i] : data_operandB[i];
		end
	endgenerate
	
	
	// Connect Information Signals	
	// Zero
	or is_neq(isNotEqual, data_result[31], data_result[30], data_result[29], data_result[28], data_result[27], data_result[26], data_result[25], data_result[24], data_result[23], data_result[22], data_result[21], data_result[20], data_result[19], data_result[18], data_result[17], data_result[16], data_result[15], data_result[14], data_result[13], data_result[12], data_result[11], data_result[10], data_result[9], data_result[8], data_result[7], data_result[6], data_result[5], data_result[4], data_result[3], data_result[2], data_result[1], data_result[0]);

	
	// Overflow
	wire ovf_0, ovf_1, ovf_2, ovf_3, ovf_4;
	not not_a(ovf_0, data_operandA[31]);
	not not_b(ovf_1, math_operandB[31]);
	not not_out(ovf_2, data_result[31]);
	and and_ovf_0(ovf_3, ovf_0, ovf_1, data_result[31]);
	and and_ovf_1(ovf_4, data_operandA[31], math_operandB[31], ovf_2);
	or  or_ovf(overflow, ovf_3, ovf_4);
	
	
	// A < B
	xor lt(isLessThan, overflow, data_result[31]);
	
endmodule
