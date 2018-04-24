/**
 * NOTE: you should not need to change this file! This file will be swapped out for a grading
 * "skeleton" for testing. We will also remove your imem and dmem file.
 *
 * NOTE: skeleton should be your top-level module!
 *
 * This skeleton file serves as a wrapper around the processor to provide certain control signals
 * and interfaces to memory elements. This structure allows for easier testing, as it is easier to
 * inspect which signals the processor tries to assert when.
 */

module skeleton(
    // Inputs
    input  wire         clock,
    input  wire         reset,
    // Instruction Memory
    output wire [11:0]  address_imem,
    output wire [31:0]  q_imem,
    // Data Memory
    output wire [11:0]  address_dmem,
    output wire [31:0]  d_dmem,
    output wire         wren_dmem, 
    output wire [31:0]  q_dmem,
    // Regfile
    output wire         ctrl_writeEnable,
    output wire [4:0]   ctrl_writeReg,
    output wire [4:0]   ctrl_readRegA,
    output wire [4:0]   ctrl_readRegB,
    output wire [31:0]  data_writeReg,
    output wire [31:0]  data_readRegA,
    output wire [31:0]  data_readRegB,
	 // LED Array
	 output wire [17:0] 	led_pins,
	 // Capacitive Sensor Array
	 input wire [8:0] 	capacitive_sensors_in,
	 output wire 			capacitive_sensors_out,
	 // Score display
	 output wire [6:0]   sev_seg_ones, sev_seg_tens, sev_seg_hundreds
);
	
	 /** Testing **/
	 wire [31:0] p1, p2, p3, p4, p5, p6, p7, t11;
	 
	 /** LED ARRAY **/
	 wire [143:0] led_commands;
	 led_array leds(clock, led_pins, led_commands);
	 
	 /** Capacitive Sensor Array **/
	 wire [287:0] capacitive_sensor_readings;
	 capacitive_sensor_array sensors(clock, capacitive_sensors_in, capacitive_sensors_out, capacitive_sensor_readings);

	 /** Random **/
	 wire [63:0] seeds = {capacitive_sensor_readings[7:0], 	  capacitive_sensor_readings[39:32],    capacitive_sensor_readings[71:64],
								 capacitive_sensor_readings[103:96],  capacitive_sensor_readings[135:128],  capacitive_sensor_readings[167:160],
								 capacitive_sensor_readings[199:192], capacitive_sensor_readings[231:224]};
	 wire [7:0] random_data;
	 random8 rng(~clock, seeds, random_data); 

    /** IMEM **/
    imem my_imem(
        .address    (address_imem),    // address of data
        .clock      (~clock),          // you may need to invert the clock
        .q          (q_imem)           // the raw instruction
    );

    /** DMEM **/
    dmem my_dmem(
        .address    (address_dmem),    // address of data
        .clock      (~clock),          // may need to invert the clock
        .data	     (d_dmem),    		// data you want to write
        .wren	     (wren_dmem),     	// write enable
        .q          (q_dmem)    			// data from dmem
    );

    /** REGFILE **/
    regfile my_regfile(
        clock,
        ctrl_writeEnable,
        reset,
        ctrl_writeReg,
        ctrl_readRegA,
        ctrl_readRegB,
        data_writeReg,
        data_readRegA,
        data_readRegB, 
		  random_data,
		  p1, p2, p3, p4, p5, p6, p7, t11
    );
	 
    /** PROCESSOR **/
    processor my_processor(
        // Control signals
        clock,                          // I: The master clock
        reset,                          // I: A reset signal

        // Imem
        address_imem,                   // O: The address of the data to get from imem
        q_imem,                         // I: The data from imem

        // Dmem
        address_dmem,                   // O: The address of the data to get or put from/to dmem
        d_dmem,                         // O: The data to write to dmem
        wren_dmem,                      // O: Write enable for dmem
        q_dmem,                         // I: The data from dmem

        // Regfile
        ctrl_writeEnable,               // O: Write enable for regfile
        ctrl_writeReg,                  // O: Register to write to in regfile
        ctrl_readRegA,                  // O: Register to read from port A of regfile
        ctrl_readRegB,                  // O: Register to read from port B of regfile
        data_writeReg,                  // O: Data to write to for regfile
        data_readRegA,                  // I: Data from port A of regfile
        data_readRegB,                  // I: Data from port B of regfile
		  
		  // LED Array
		  led_commands, 
		  
		  // Capacitive Sensor Array
		  capacitive_sensor_readings
    );
	 
	 
	 reg [3:0] ones, tens, hundreds;
	 reg [31:0] score;
	 reg [31:0] score_latch_counter;
	 reg [3:0] hex_ones, hex_tens, hex_hundreds;
	 

	 /** Score **/
	 wire [3:0] score_ones, score_tens, score_hundreds;
//	 output [6:0] sev_seg_ones, sev_seg_tens, sev_seg_hundreds;
	 hex_converter hc0(in, score_ones, score_tens, score_hundreds);
	 Hexadecimal_To_Seven_Segment hs0(score_ones, sev_seg_ones);
	 Hexadecimal_To_Seven_Segment hs1(score_tens, sev_seg_tens);
	 Hexadecimal_To_Seven_Segment hs2(score_hundreds, sev_seg_hundreds);
	 
	 initial begin
		score_latch_counter = 32'b0;
		score = 32'b0;
	 end
	 always @(negedge clock) begin
		if(score_latch_counter > 32'd8) begin
			score_latch_counter = 32'd0;
			
			hex_ones = score_ones;
			hex_tens = score_tens;
			hex_hundreds = score_hundreds;
			
			score = t11;
		end	
		else begin
			score_latch_counter = score_latch_counter + 32'b1;
		end
	 
	 end
	 
	 
	 /** Debugger **/
	 debugger d0(.probe(capacitive_sensor_readings[31:0]));
	 //debugger d1(.probe(capacitive_sensor_readings[63:32]));
	 debugger d2(.probe(capacitive_sensor_readings[95:64]));
	 debugger d3(.probe(capacitive_sensor_readings[127:96]));
	 debugger d4(.probe(capacitive_sensor_readings[159:128]));
	 debugger d5(.probe(capacitive_sensor_readings[191:160]));
	 debugger d6(.probe(capacitive_sensor_readings[223:192]));
	 debugger d7(.probe(capacitive_sensor_readings[255:224]));
	 debugger d8(.probe(capacitive_sensor_readings[287:256]));
	 //debugger d4(.probe(capacitive_sensor_readings[159:128]));
	 //debugger d8(.probe(capacitive_sensor_readings[287:256]));	 
	 //debugger d10(.probe({16'b0, led_commands[15:0]}));
	 
	 //debugger d20(.probe({20'd0 , address_imem[11:0]}));		// PC
	 
//	 debugger d12(.probe(p1));
//	 debugger d13(.probe(p2));
//	 debugger d14(.probe(p3));
//     
//     debugger d11(.probe(p4));
//     
//	 debugger d15(.probe(p5));
//	 debugger d16(.probe(p6));
//	 debugger d17(.probe(p7));
endmodule
