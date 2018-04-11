module skeleton(CLOCK_50,					// 50 MHz clock
					 sensor_in, sensor_out	// Capacitive Sensor
					 
);  													
	
	input CLOCK_50;
	input [8:0] sensor_in;
	
	output sensor_out;
	
	
	// 50 MHz Clock
	wire clock = CLOCK_50;
	
	// Trigger for Capacitive Sensor
	reg sensor_trigger;	
	
	reg [16:0] div_count;
	always @(posedge clock) begin
		div_count <= div_count + 17'b1;
		if(div_count == 17'd50000) begin
			div_count <= 17'b0;
			sensor_trigger <= !sensor_trigger;
		end
	end

	
	// Capacitive Sensor Array
	wire [31:0] f0, f1, f2, f3, f4, f5, f6, f7, f8; // Each is a 32-bit register holding most recent sensor value
	capacitive_sensor_array sensors(clock, sensor_trigger, sensor_in, sensor_out,
											  f0, f1, f2, f3, f4, f5, f6, f7, f8);

	
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
//	debugger d1(.probe(input_probe));
	
endmodule
