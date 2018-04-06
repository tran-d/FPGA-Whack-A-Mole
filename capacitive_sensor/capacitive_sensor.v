module capacitive_sensor(clock, start, sensor_in, sensor_out, final_count_out, count_out);

	input clock, start, sensor_in;
	
	output sensor_out;
	output [31:0] count_out, final_count_out;
	
	reg [31:0] count, final_count;
	
	reg capacitor_charged;
	reg [13:0] capacitor_charge_count;

	always @(posedge start) begin
		
		count = 0;	
		capacitor_charge_count = 13'd0;
		
	end
	
	always @(posedge clock) begin
	
		if(sensor_in & !capacitor_charged) begin // when sensor reads high, count 100us to ensure capacitor fully charged
			if(capacitor_charge_count < 13'd5000)
				capacitor_charge_count = capacitor_charge_count + 1;
			else 
				capacitor_charged = 1;				
		end
	
	end


endmodule
