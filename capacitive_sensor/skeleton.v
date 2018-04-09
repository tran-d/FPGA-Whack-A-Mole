module skeleton(
	lcd_data, lcd_rw, lcd_en, lcd_rs, lcd_on, lcd_blon,// LCD info
	CLOCK_50);  													// 50 MHz clock
	
	// 50 MHz Clock
	input CLOCK_50;

	////////////////////////	LCD and Seven Segment	////////////////////////////
	output 			   lcd_rw, lcd_en, lcd_rs, lcd_on, lcd_blon;
	output 	[7:0] 	lcd_data;

	wire			 clock;
	reg			 lcd_write_en, lcd_reset;
	reg 	[7:0] lcd_write_data;
	
	assign clock = CLOCK_50;

	// lcd controller
	lcd mylcd(clock, lcd_reset, lcd_write_en, lcd_write_data, lcd_data, lcd_rw, lcd_en, lcd_rs, lcd_on, lcd_blon);
	
	// capacitive_sensor
//	module capacitive_sensor(clock, start, sensor_in, sensor_out, final_count, count, temp_charge_count, temp_capacitor_charged);

	
	wire [31:0] value = 31'd56876;

	probes debugger(


	
endmodule
