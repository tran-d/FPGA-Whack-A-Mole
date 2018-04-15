`timescale 1 ns / 100 ps

/*--------------------
  Processor Test Bench
  --------------------*/
  
module processor_tb_auto(
	// Instruction Memory
	address_imem, 
	dut_q_imem,
    // Data Memory
    address_dmem,
    d_dmem,
    wren_dmem,
    dut_q_dmem,
    // Regfile
    ctrl_writeEnable, 
    ctrl_writeReg, 
    ctrl_readRegA, 
    ctrl_readRegB, 
    data_writeReg, 
    data_readRegA, 
    data_readRegB,
    led_pins,
    capacitive_sensors_in,
	capacitive_sensors_out);

	integer CYCLE_LIMIT = CYCLE_LIMIT_AUTO_GENERATE; // Modify this to change number of cycles run during test

	reg clock = 0, reset = 0;
	integer cycle_count = 0, error_count = 0;

	// LEDS
	wire [143:0] led_commands = dut.led_commands; 

	// Instruction Memory
    output wire [11:0]  address_imem;
    output wire [31:0]  dut_q_imem;

    // Data Memory
    output wire [11:0]  address_dmem;
    output wire [31:0]  d_dmem;
    output wire         wren_dmem;
    output wire [31:0]  dut_q_dmem;

    // Regfile
    output wire         ctrl_writeEnable;
    output wire [4:0]   ctrl_writeReg;
    output wire [4:0]   ctrl_readRegA;
    output wire [4:0]   ctrl_readRegB;
    output wire [31:0]  data_writeReg;
    output wire [31:0]  data_readRegA;
    output wire [31:0]  data_readRegB;

    // New
    output wire [17:0] 	led_pins;
	input wire [8:0] 	capacitive_sensors_in;
	output wire 		capacitive_sensors_out;

	
	// Probes
	// wire [31:0] instruction = dut.my_processor.fetch.instruction_out;
	// wire [31:0] r0 = dut.my_regfile.register_output[0];
	// wire [31:0] r1 = dut.my_regfile.register_output[1];
	// wire [31:0] r2 = dut.my_regfile.register_output[2];
	// wire [4:0] alu_op = dut.my_processor.execute.ctrl_alu_op;
	// wire [31:0] alu_a = dut.my_processor.execute.operand_A;
	// wire [31:0] alu_b = dut.my_processor.execute.operand_B;
	// wire [31:0] rd_data = dut.my_processor.writeback.rf_write_data;
	// wire rd_enable = dut.my_processor.writeback.rf_write_enable;
	// wire [4:0] rd_ctrl = dut.my_processor.writeback.rf_write_ctrl;
	// wire [4:0] alu_shift = dut.my_processor.execute.math_unit.ctrl_shiftamt;
	wire [4:0] regfile_ctrlA = dut.my_processor.ctrl_readRegA;
	wire [4:0] regfile_ctrlB = dut.my_processor.ctrl_readRegB;
	wire [4:0] regfile_ctrlWrite = dut.my_processor.ctrl_writeReg;
	// wire [4:0] decode_ctrl_b = dut.my_processor.ctrl_readRegB;
	// wire [31:0] q_dmem = dut.my_processor.q_dmem;

	wire 	branched_jumped	= dut.my_processor.branched_jumped;

	// Hazards
	//wire fd_dx_dhaz_rs_rt		= dut.my_processor.dhc.fd_dx_dhaz_rs_rt;
	//wire fd_xm_dhaz_rs_rt		= dut.my_processor.dhc.fd_xm_dhaz_rs_rt;
	//wire fd_dx_dhaz_rs			= dut.my_processor.dhc.fd_dx_dhaz_rs;
	//wire fd_xm_dhaz_rs			= dut.my_processor.dhc.fd_xm_dhaz_rs;
	//wire fd_dx_dhaz_rd			= dut.my_processor.dhc.fd_dx_dhaz_rd;
	//wire fd_xm_dhaz_rd			= dut.my_processor.dhc.fd_xm_dhaz_rd;

	// Bypass
	wire mx_bypass_A			= dut.my_processor.mx_bypass_A;
	wire mx_bypass_B			= dut.my_processor.mx_bypass_B;
	wire wx_bypass_A			= dut.my_processor.wx_bypass_A;
	wire wx_bypass_B			= dut.my_processor.wx_bypass_B;
	wire wm_bypass				= dut.my_processor.wm_bypass;
	
	wire [31:0] insn_fd		= dut.my_processor.lfd.insn_in;
	wire [31:0] insn_dx		= dut.my_processor.ldx.insn_in;
	wire [31:0] insn_xm		= dut.my_processor.lxm.insn_in;
	wire [31:0] insn_mw		= dut.my_processor.lmw.insn_in;

	wire [31:0] pc_in_execute	= dut.my_processor.pc_in;
	wire [31:0] insn_execute	= dut.my_processor.execute.insn_in;
	wire [31:0] opcode_execute	= dut.my_processor.execute.insn_in[31:27];
	wire [31:0] ALU_operandA_execute = dut.my_processor.execute.ALU_operandA;
	wire [31:0] ALU_operandB_execute = dut.my_processor.execute.ALU_operandB;

	wire [4:0] opcode		= dut.my_processor.q_imem[31:27];
	wire [4:0] ALU_op 	     = dut.my_processor.execute.ALU_op;
	wire [31:0] alu_operandA = dut.my_processor.execute.ALU_operandA;
	wire [31:0] alu_operandB = dut.my_processor.execute.ALU_operandB;
	wire [31:0] alu_result 	= dut.my_processor.execute.o_out;
	wire [31:0] exec_alu_operandB = dut.my_processor.execute.ALU_operandB;
	wire 		isNotEqual 	= dut.my_processor.execute.isNotEqual;
	wire [31:0] immediate 	= dut.my_processor.execute.immediate;
	wire [31:0] immediate_extended = dut.my_processor.execute.immediate_extended;
	wire [31:0] pc_dx_out = dut.my_processor.pc_dx_out;
	wire [31:0] pc_plus_1_plus_immediate = dut.my_processor.execute.pc_plus_1_plus_immediate;
 
	wire [31:0] pc_in = dut.my_processor.pc_in;
	wire [31:0] pc_out = dut.my_processor.pc_out;
	wire [31:0] q_dmem = dut.my_processor.q_dmem;
	// wire [31:0] decode_a_out = dut.my_processor.decode.a_out;
	// wire [31:0] decode_b_out = dut.my_processor.decode.b_out;
	// wire [31:0] execute_a_in = dut.my_processor.execute.a_in;
	// wire [31:0] execute_b_in = dut.my_processor.execute.b_in;
	wire [31:0] execute_o_out = dut.my_processor.execute.o_out;
	wire [31:0] execute_b_out = dut.my_processor.execute.b_out;
	wire [31:0] memory_o_in = dut.my_processor.memory.o_in;
	wire [31:0] memory_b_in = dut.my_processor.memory.b_in;
	wire [11:0] memory_address = dut.my_processor.memory.address_dmem;
	wire [31:0] memory_q_dmem = dut.my_processor.memory.q_dmem;
	wire [31:0] memory_o_out = dut.my_processor.memory.o_out;
	wire [31:0] memory_d_out = dut.my_processor.memory.d_out;
	wire [31:0] writeback_o_in = dut.my_processor.writeback.o_in;
	wire [31:0] writeback_d_in = dut.my_processor.writeback.d_in;

	wire exec_write_exception = dut.my_processor.execute.ALU_exception;

	// BYPASS-STALL

	wire [31:0] is_bypass_hazard = dut.my_processor.is_bypass_hazard;
	wire wait_multdiv_RDY = dut.my_processor.my_bypass_stall.wait_multdiv_RDY;
	wire [31:0] insn_dx_out = dut.my_processor.insn_dx_out;
	wire multdiv_act_RDY = dut.my_processor.multdiv_RDY;
	wire ctrl_MULT = dut.my_processor.execute.my_multdiv_controller.ctrl_MULT;
	wire waiting_for_multdiv = dut.my_processor.execute.my_multdiv_controller.waiting_for_multdiv;
	wire latch_ctrl_MULT = dut.my_processor.execute.my_multdiv_controller.latch_ctrl_MULT;

	wire data_resultRDY_latch = dut.my_processor.execute.my_multdiv_controller.my_multdiv.data_resultRDY_latch;
	wire data_resultRDY_actually = dut.my_processor.execute.my_multdiv_controller.my_multdiv.data_resultRDY_actually;
	wire currently_solving = dut.my_processor.execute.my_multdiv_controller.my_multdiv.currently_solving;


	// DUT 
	skeleton dut(
	clock, 
	reset, 
	// Instruction Memory
	address_imem, 
	dut_q_imem,
    // Data Memory
    address_dmem,
    d_dmem,
    wren_dmem,
    dut_q_dmem,
    // Regfile
    ctrl_writeEnable, 
    ctrl_writeReg, 
    ctrl_readRegA, 
    ctrl_readRegB, 
    data_writeReg, 
    data_readRegA, 
    data_readRegB,
    led_pins,
    capacitive_sensors_in,
    capacitive_sensors_out);
	
	// Main: wait specified cycles, then perform tests
	initial begin
		$display($time, ":  << Starting Test >>\n");	


		//$monitor("clock %d, opcode: %b, pc_curr(out): %d, pc_next(in) %d\ninsn_fd: %d, insn_dx: %d, insn_xm: %d insn_mw: %d\nALU_op: %b, alu_opA: %d, alu_opB: %d alu_result: %d\n\n", clock, opcode, pc_out, pc_in, insn_fd, insn_dx, insn_xm, insn_mw, ALU_op, alu_operandA, alu_operandB, alu_operandB, exec_alu_operandB, alu_result);
		
		//$monitor("ALU_op: %b, alu_opA: %d, alu_opB: %d alu_result: %d", ALU_op, alu_operandA, alu_operandB, alu_operandB, exec_alu_operandB, alu_result);
		
		//$monitor("clock: %d, opcode: %b, pc_curr(out): %d, pc_next(in) %d", clock, opcode, pc_out, pc_in);

		// HAZARDS
		//$monitor("clock: %d, opcode: %b, fd_dx_dhaz_rs_rt: %b, fd_xm_dhaz_rs_rt: %b", clock, opcode, fd_dx_dhaz_rs_rt, fd_xm_dhaz_rs_rt);

		//$monitor("pc_out: %d, clock: %d, opcode: %b, fd_dx_haz_r: %b, fd_xm_haz_r: %b, fd_dx_haz_addi: %b, fd_xm_haz_addi: %b", pc_out, clock, opcode, fd_dx_dhaz_rs_rt, fd_xm_dhaz_rs_rt, fd_dx_dhaz_rs, fd_xm_dhaz_rs);

		//$monitor("pc_out: %d, clock: %d, opcode: %b, fd_dx_haz_rd: %b, fd_xm_haz_rd: %b", pc_out, clock, opcode, fd_dx_dhaz_rd, fd_xm_dhaz_rd);

		//$monitor("pc_out: %d, clock: %d, opcode: %b, fd_dx_haz_r: %b, fd_xm_haz_r: %b, alu_opA: %d, alu_opB: %d ctrl_writeReg: %d", pc_out, clock, opcode, fd_dx_dhaz_rs, fd_xm_dhaz_rs, alu_operandA, alu_operandB, regfile_ctrlWrite);

		//$monitor("clock: %d, opcode: %d, exec_write_exception: %d", clock, opcode, exec_write_exception);

		//$monitor("clock: %d, opcode: %d, mx_bypass_A: %d, wx_bypass_A: %d, mx_bypass_B: %d, wx_bypass_B: %d, wm_bypass: %d", clock, opcode, mx_bypass_A, wx_bypass_A, mx_bypass_B, wx_bypass_B, wm_bypass);

		//$monitor("clock: %d, ex_opcode: %d, isNotEqual %d, immediate: %d, pc_dx_out: %d, pc_plus_1_plus_immediate: %d, address_imem: %d, branched_jumped: %d, \n insn_execute: %b", clock, execute_opcode, isNotEqual, immediate, pc_dx_out, pc_plus_1_plus_immediate, address_imem, branched_jumped, insn_execute);

		//$monitor("clock: %d, insn_execute: %b, ex_opcode: %d, alu_operandA_ex: %d, alu_operandB_ex: %d, isNotEqual %d, branched_jumped: %d, immediate: %d, pc_plus_1_plus_immediate: %d", clock, insn_execute, opcode_execute, ALU_operandA_execute, ALU_operandB_execute, isNotEqual, branched_jumped, immediate, pc_plus_1_plus_immediate);

		$monitor("clock: %d, insn_dx_out: %b, hazard: %d, ctrl_MULT: %d, latch_ctrl_MULT: %d, curr_solving: %d, multdiv_RDY_latch: %d, multdiv_RDY: %b", clock, insn_dx_out, is_bypass_hazard, ctrl_MULT, latch_ctrl_MULT, currently_solving, data_resultRDY_latch, data_resultRDY_actually);



		#(20*(CYCLE_LIMIT+1.5))


		performTests();		
		$display($time, ":  << Test Complete >>");
		$display("Errors: %d" , error_count);
		$stop;
	end
	
	// Clock generator
	always begin
		#10	clock = ~clock; // toggle every half-cycles
	end
	
	always begin
		#20   cycle_count = cycle_count + 1;
	end
	
	task checkRegister; // Note: this assumes regfile works properly and has a 2D array "register_output" that  holds all register values
		input [4:0] reg_num;
		input [31:0] expected_value;
		begin
			if(dut.my_regfile.register_output[reg_num] !== expected_value) begin
				$display("ERROR: register $%d (expected: %d, read: %d)", reg_num, expected_value, dut.my_regfile.register_output[reg_num]);
				//$display("\t\t\t\tExecute_o_out: %d, Execute_b_out: %d", execute_o_out, execute_b_out);
				//$display("\t\t\t\tMemory_o_in: %d, Memory_b_in: %d", memory_o_in, memory_b_in);
				//$display("\t\t\t\tMemory_address: %d, q_dmem: %d", memory_address, memory_q_dmem);
				//$display("\t\t\t\tMemory_o_out: %d, Memory_d_out: %d", memory_o_out, memory_d_out);
				//$display("\t\t\t\tWrite_o_in: %d, Write_d_in: %d", writeback_o_in, writeback_d_in);
				//$display("Write register: %d", regfile_ctrlWrite);
				//$display("\t\t\t\ReadRegA: %d, ReadRegB: %d", regfile_ctrlA, regfile_ctrlA);
				//$display("ALU_op: %b, alu_opA: %d, alu_opB: %d alu_result: %d", ALU_op, alu_operandA, alu_operandB, alu_operandB, exec_alu_operandB, alu_result);
				error_count = error_count + 1;
			end
			else
				$display("\t\t\t\t\t\t\t\t\t Success! register $%d (expected: %h, read: %h)", reg_num, expected_value, dut.my_regfile.register_output[reg_num]);
		end
	endtask
