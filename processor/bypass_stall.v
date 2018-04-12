module bypass_stall(fd_insn, dx_insn, multdiv_ready, is_bypass_hazard);

	input [31:0] fd_insn, dx_insn, multdiv_ready;
	output is_bypass_hazard;
	
	wire [4:0] fd_rs1, fd_rs2, dx_rd, dx_opcode, fd_rs1_equals_dx_rd, fd_rs2_equals_dx_rd;
	wire dx_lw_insn, lw_hazard, multdiv_hazard;
	
	assign fd_rs1 	 		= fd_insn[21:17];
	assign fd_rs2			= fd_insn[16:12];
	assign dx_rd 			= dx_insn[26:22];
	assign dx_opcode 		= dx_insn[31:27];
	assign dx_ALU_op 		= dx_insn[6:2];
	assign dx_r_insn 		= ~dx_opcode[4] & ~dx_opcode[3] & ~dx_opcode[2] & ~dx_opcode[1] & ~dx_opcode[0];
	assign dx_lw_insn		= ~dx_opcode[4] &&  dx_opcode[3] && ~dx_opcode[2] && ~dx_opcode[1] && ~dx_opcode[0];					//01000 lw only check fd_rs1					
	assign dx_mul_insn 	= r_insn && (~dx_ALU_op[4] && ~dx_ALU_op[3] &&  dx_ALU_op[2] &&  dx_ALU_op[1] && ~dx_ALU_op[1]);	// 00000 & 00110
	assign dx_div_insn 	= r_insn && (~dx_ALU_op[4] && ~dx_ALU_op[3] &&  dx_ALU_op[2] &&  dx_ALU_op[1] &&  dx_ALU_op[1]);	// 00000 & 00111
										
	assign lw_hazard 			= dx_lw_insn && (&fd_rs1_equals_dx_rd || &fd_rs2_equals_dx_rd;
	assign is_bypass_hazard = lw_hazard || multdiv_hazard; 							// && !fd_sw_insn;
	
	
	/* MULTIPLIER */
	
	reg wait_multdiv_ready;
	
	always @(posedge dx_mul_insn or posedge dx_div_insn or posedge multdiv_ready)
	begin
	if (dx_mul_insn or dx_div_insn)
		wait_multdiv_ready <= 1'b1;
	else if (wait_multdiv_ready and multdiv_ready)
		wait_multdiv_ready <= 1'b0;
	end
	
	assign multdiv_hazard = wait_multdiv_ready && ~multdiv_ready;
	
	s
	genvar i;
	generate
	for(i=0; i<5; i=i+1) begin: loop1
		
		xnor x1(fd_rs1_equals_dx_rd[i], fd_rs1[i], dx_rd[i]);
		xnor x2(fd_rs2_equals_dx_rd[i], fd_rs2[i], dx_rd[i]);
	
	end
	endgenerate
	
endmodule