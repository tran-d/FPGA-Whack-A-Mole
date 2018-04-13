module skeleton(CLOCK_50,					// 50 MHz clock
					 sensor_in, sensor_out,	// Capacitive Sensor
					 f0, f1, f2, f3, f4, f5, f6, f7, f8
);  													
	
	input CLOCK_50;
	input [8:0] sensor_in;
	output sensor_out;
	output [31:0] f0, f1, f2, f3, f4, f5, f6, f7, f8;
	
	
	// 50 MHz Clock
	wire clock = CLOCK_50;
	
	wire [287:0] sensor_readings;

	
	// Capacitive Sensor Array
	capacitive_sensor_array sensors(clock, sensor_in, sensor_out, sensor_readings);


	assign f0 = sensor_readings[31:0];
	assign f1 = sensor_readings[63:32];
	assign f2 = sensor_readings[95:64];
	assign f3 = sensor_readings[127:96];
	assign f4 = sensor_readings[159:128];
	assign f5 = sensor_readings[191:160];
	assign f6 = sensor_readings[223:192];
	assign f7 = sensor_readings[255:224];
	assign f8 = sensor_readings[287:256];
	
	// Debugging Probe
//	debugger d0(.probe(f0));
//	debugger d1(.probe(f1));
//	debugger d2(.probe(f2));
//	debugger d3(.probe(f3));
//	debugger d4(.probe(f4));
//	debugger d5(.probe(f5));
//	debugger d6(.probe(f6));
//	debugger d7(.probe(f7));
//	debugger d8(.probe(f8));

	
//	wire [31:0] input_probe;
//	assign input_probe[8:0] = sensor_in[8:0];
//	debugger d9(.probe(input_probe));
	
endmodule
