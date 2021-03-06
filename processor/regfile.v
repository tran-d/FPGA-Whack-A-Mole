module regfile (
    clock,
    ctrl_writeEnable,
    ctrl_reset, ctrl_writeReg,
    ctrl_readRegA, ctrl_readRegB, data_writeReg,
    data_readRegA, data_readRegB, 
	 random_data,
	 p1, p2, p3, p4, p5, p6, p7
);

   input clock, ctrl_writeEnable, ctrl_reset;
   input [4:0] ctrl_writeReg, ctrl_readRegA, ctrl_readRegB;
   input [31:0] data_writeReg;
	input [7:0] random_data;

   output [31:0] data_readRegA, data_readRegB;	
		
	wire [31:0] selectedRegisterBits;
	wire [31:0] register_output[31:0];
	wire [31:0] sortedBits[31:0];
	wire [31:0] reg_writeEnable;
	
	genvar i;
	genvar j; 

	/* Probes for testing */
	output [31:0] p1, p2, p3, p4, p5, p6, p7;

	assign p1 = register_output[1];
	
	assign p2 = register_output[20]; 
	assign p3 = register_output[27];  // s7
    
    assign p4 = register_output[17];		// t10
	
	assign p5 = register_output[12];		// t5
	assign p6 = register_output[13];		// t6
	assign p7 = register_output[11];		// t4
	
	/***** create decoder for write_reg *****/						
	decoder5to32 my_decoder(ctrl_writeReg, selectedRegisterBits);

	generate
	
		for(i=0; i<32; i=i+1) begin: loop1
		
			/***** create writeEnable for selected write_reg *****/
			and my_and(reg_writeEnable[i], selectedRegisterBits[i], ctrl_writeEnable);
			
			/***** create 32-bit register *****/
			if(i==0)
				reg32_neg 	  myregisterZero(32'b0, clock, ctrl_reset, 1'b0, register_output[i]);
			else if (i==29) // random
				assign register_output[i] = {24'b0, random_data};
			else
				reg32_neg     myregister(data_writeReg, clock, ctrl_reset, reg_writeEnable[i], register_output[i]);
			
			for(j=0; j<32; j=j+1) begin: transpose
			
				assign sortedBits[i][j] = register_output[j][i];
				
			end
			
			/***** generate 32 muxes (ith mux selects ith bit from all registers) *****/
			mux32_tristate displayRegA(sortedBits[i], ctrl_readRegA, data_readRegA[i]);
			mux32_tristate displayRegB(sortedBits[i], ctrl_readRegB, data_readRegB[i]);
			
		end
		
	endgenerate
	
	
	
endmodule

		
