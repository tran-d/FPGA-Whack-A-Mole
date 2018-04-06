module skeleton(
	lcd_data, lcd_rw, lcd_en, lcd_rs, lcd_on, lcd_blon,// LCD info
	CLOCK_50);  													// 50 MHz clock
	
	// 50 MHz Clock
	input CLOCK_50;

	////////////////////////	LCD and Seven Segment	////////////////////////////
	output 			   lcd_rw, lcd_en, lcd_rs, lcd_on, lcd_blon;
	output 	[7:0] 	lcd_data;

	wire			 clock;
	wire			 lcd_write_en;
	wire 	[31:0] lcd_write_data;
	
	assign clock = CLOCK_50;

	// lcd controller
	lcd mylcd(clock, ~resetn, 1'b1, ps2_out, lcd_data, lcd_rw, lcd_en, lcd_rs, lcd_on, lcd_blon);
	
	// capacitive_sensor
//	module capacitive_sensor(clock, start, sensor_in, sensor_out, final_count, count, temp_charge_count, temp_capacitor_charged);

	assign lcd_write_en = 1'b1;
	assign lcd_write_data = 32'd5;

	
endmodule
