module capacitive_sensor_array(clock, start, sensors_out, sensors_in, final_counts);

	parameter CHARGE_CONFIDENCE_CYCLES = 15'd20000;


	input clock, start;
	input [8:0] sensors_in;
	
	output sensors_out;
	output [31:0] final_counts [8:0];
	
	reg capacitors_charged;
	reg [15:0] capacitors_charge_count;
	
	
	initial begin
		capacitors_charged <= 1'b0;
		capacitors_charged_count <= 16'b0;
	end
	
	always @(negedge start) begin
		capacitors_charged <= 1'b0;
		capacitors_charge_count <= 16'b0;
	end
	
	always @(posedge clock or posedge start) begin
	
		if(start) begin
		 
			if(capacitors_charged) begin  // when capacitors full, ensure output pin low
				sensors_out <= 1'b0;
			end 
			
			else if(&sensors_in)	begin  // when capacitors not full, but all past threshold, count cycles until capacitors are definitely full
				sensors_out <= 1'b1;
				capacitors_charge_count = capacitors_charge_count + 16'b1;
				capacitors_charged = capacitors_charged_count > CHARGE_CONFIDENCE_CYCLES;
			end
			
			else begin  // when capacitor is not full yet and sensors not all high, ensure that sensor out is high
				sensors_out <= 1'b1;
			end
				
		end
		
		else
			sensors_out <= 1'b0;
	end		
			
	generate
		genvar i;
		
		for(i = 0; i < 9; i = i + 1) begin: sensor_loop
			capacitive_sensor  sensor_i(clock, start, capacitors_charged, sensors_in[i], final_counts[i]);
		end
	endgenerate

endmodule

