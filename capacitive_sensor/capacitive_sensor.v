module capacitive_sensor(clock, start, capacitor_charged, sensor_in, final_count);


	input clock, start, capacitor_charged, sensor_in;
	
	output reg [31:0] final_count;
	
	reg [31:0] count;
	reg sensing_complete;
	

	initial begin
		final_count <= 32'b0;
		sensing_complete <= 1'b0;
	end
	
	always @(posedge clock or negedge start) begin
	
		if(!start) begin
			sensing_complete <= 1'b0;
			count <= 32'b0;	
		end
	
		else if(!sensing_complete) begin

			if(sensor_in & capacitor_charged) begin // when sensor reads high and capacitor is charged, increment counter until capactor drains
				count <= count + 32'b1;
			end
			
			if(!sensor_in & capacitor_charged) begin // when sensor drains, latch count into final count, sensing complete.
				final_count <= |count? count : final_count; // from empirical analysis, final count is 0 randomly sometimes -- we will ignore those
				sensing_complete <= 1'b1;
			end
			
		end
	
	end


endmodule
