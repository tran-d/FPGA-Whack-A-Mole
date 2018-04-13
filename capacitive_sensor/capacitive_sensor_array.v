module capacitive_sensor_array(clock, sensors_in, sensors_out, readings);

	parameter CHARGE_CONFIDENCE_CYCLES = 15'd20000;

	input clock;
	input [8:0] sensors_in;
	
	output reg sensors_out;
	output [287:0] readings;

	wire start;
	wire [31:0] final_counts [8:0];
	
	
	reg capacitors_charged, sensor_trigger;
	reg [15:0] capacitors_charge_count;
   reg [16:0] div_count;

	
	initial begin
		sensors_out <= 1'b0;
		capacitors_charged <= 1'b0;
		capacitors_charge_count <= 16'b0;
	end
	
	always @(posedge clock) begin
	
		if(start) begin
		 
			if(capacitors_charged) begin  // when capacitors full, ensure output pin low
				sensors_out <= 1'b0;
			end 
			
			else if(&sensors_in)	begin  // when capacitors not full, but all past threshold, count cycles until capacitors are definitely full
				sensors_out <= 1'b1;
				capacitors_charge_count = capacitors_charge_count + 16'b1;
				capacitors_charged = capacitors_charge_count > CHARGE_CONFIDENCE_CYCLES;
			end
			
			else begin  // when capacitor is not full yet and sensors not all high, ensure that sensor out is high
				sensors_out <= 1'b1;
			end
				
		end
		
		else begin
			sensors_out <= 1'b0;
			capacitors_charged <= 1'b0;
			capacitors_charge_count <= 16'b0;
		end
		
		// start trigger
		div_count <= div_count + 17'b1;
		if(div_count == 17'd50000) begin
			div_count <= 17'b0;
			sensor_trigger <= !sensor_trigger;
		end
	end		
			
	generate
		genvar i;		
		for(i = 0; i < 9; i = i + 1) begin: sensor_loop
			capacitive_sensor  sensor_i(clock, start, capacitors_charged, sensors_in[i], final_counts[i]);
		end
	endgenerate
	
	assign readings[31:0]     = final_counts[0];
	assign readings[63:32]    = final_counts[1];
	assign readings[95:64]    = final_counts[2];
	assign readings[127:96]   = final_counts[3];
	assign readings[159:128]  = final_counts[4];
	assign readings[191:160]  = final_counts[5];
	assign readings[223:192]  = final_counts[6];
	assign readings[255:224]  = final_counts[7];
	assign readings[287:256]  = final_counts[8];
	
	assign start = sensor_trigger;

endmodule

