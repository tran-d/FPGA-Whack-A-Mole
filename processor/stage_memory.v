module stage_memory(

	// inputs
	clock,
	insn_in, 
	q_dmem, 
	o_in, 
	b_in, 
	wm_bypass,
	data_writeReg,
	sensor_readings,
	
	// outputs
	o_out, 
	d_out, 
	d_dmem, 
	address_dmem, 
	wren
);

	input [31:0] insn_in, q_dmem;					//	q_mem: output of dmem (lw)
	input [31:0] o_in, b_in;						//	ALU_result is used to address into dmem
	input clock, wm_bypass;									// WM BYPASSING
	input [31:0] data_writeReg;
	input [287:0] sensor_readings;				// Capacitive Sensor data
	
	output [31:0] o_out, d_out, d_dmem;			//	d_dmem: data to write to dmem ($rd for sw)
	output [11:0] address_dmem;
	output wren;

	wire [4:0] opcode;
	wire cap;
	reg [31:0] selected_sensor_reading;
	
	assign opcode 			= insn_in[31:27];
	assign cap				= ~opcode[4] &  opcode[3] &  opcode[2] & ~opcode[1] & ~opcode[0];	//01100
	assign wren 			= ~opcode[4] && ~opcode[3] && opcode[2] && opcode[1] && opcode[0]; 		//sw
	assign o_out 			= cap ? selected_sensor_reading : o_in;
	assign d_out 			= q_dmem;
	assign address_dmem 	= o_in[11:0];
	
	/* WM BYPASSING */
	assign d_dmem 			= wm_bypass ? data_writeReg : b_in;
	
	
	// rs = o_out
	// data = selected_sensor_reading
	
	always @(negedge clock) begin
		if(cap) begin
			case(o_in[3:0])
				4'd0: selected_sensor_reading = sensor_readings[31:0];
				4'd1: selected_sensor_reading = sensor_readings[63:32];
				4'd2: selected_sensor_reading = sensor_readings[95:64];
				4'd3: selected_sensor_reading = sensor_readings[127:96];
				4'd4: selected_sensor_reading = sensor_readings[159:128];
				4'd5: selected_sensor_reading = sensor_readings[191:160];
				4'd6: selected_sensor_reading = sensor_readings[223:192];
				4'd7: selected_sensor_reading = sensor_readings[255:224];
				4'd8: selected_sensor_reading = sensor_readings[287:256];
			endcase
		end
	end
	
endmodule
