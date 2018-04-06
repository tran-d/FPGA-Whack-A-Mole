module capacitive_sensor(clock, start, sensor_in, sensor_out, final_count, count, temp_charge_count, temp_capacitor_charged);

	parameter CHARGE_CONFIDENCE_CYCLES = 13'd10;//13'd5000;

	input clock, start, sensor_in;
	
	output sensor_out;
	output [31:0] count, final_count;
	
	
	reg [31:0] count_reg, final_count_reg;
	reg [12:0] capacitor_charge_count;
	reg capacitor_charged, sensor_out_reg, sensing_complete;

	assign sensor_out = sensor_out_reg;
	assign count = count_reg;
	assign final_count = final_count_reg;
	
	
	output [12:0] temp_charge_count = capacitor_charge_count;
	output temp_capacitor_charged = capacitor_charged;
	
	initial begin
		final_count_reg <= 1'b0;
		sensing_complete <= 1'b0;
		sensor_out_reg <= 1'b0;
	end
	
	always @(posedge clock or negedge start) begin
	
		if(!start) begin
			sensor_out_reg <= 1'b0;
			sensing_complete <= 1'b0;
			count_reg <= 32'b0;	
			capacitor_charged <= 1'b0;
			capacitor_charge_count <= 13'b0;
		end
	
		else if(!sensing_complete) begin
					
			if(!sensor_in & !capacitor_charged) begin // when capacitor is not full yet and sensor reads low, ensure that sensor out is high
					sensor_out_reg <= 1'b1;
			end
		
			if(sensor_in & !capacitor_charged) begin // when sensor reads high, count 100us to ensure capacitor fully charged
				if(capacitor_charge_count < CHARGE_CONFIDENCE_CYCLES)
					capacitor_charge_count <= capacitor_charge_count + 1'b1;
				else begin	// when capacitor charged, turn sensor_out off
					capacitor_charged <= 1'b1;
					sensor_out_reg <= 1'b0;
				end
			end
			
			if(sensor_in & capacitor_charged) begin // when sensor reads high and capacitor is charged, increment counter until capactor drains
				count_reg <= count_reg + 32'b1;
			end
			
			if(!sensor_in & capacitor_charged) begin // when sensor drains, latch count into final count, sensing complete.
				final_count_reg <= count_reg;
				sensing_complete <= 1'b1;
			end
			
		end
	
	end


endmodule
