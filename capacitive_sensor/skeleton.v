module skeleton(CLOCK_50,					// 50 MHz clock
					 sensor_in, sensor_out	// Capacitive Sensor
);  													
	
	
	// 50 MHz Clock
	input CLOCK_50;
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
	input [8:0] sensor_in;
	output sensor_out;
	wire [31:0] final_count_i;
	capacitive_sensor_array sensors(clock, sensor_trigger, sensor_in, sensor_out, final_count_i);

	
	// Debugging Probe
	debugger d1(.probe(final_counts[i]));

	
endmodule
