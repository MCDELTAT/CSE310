`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   11:51:29 02/23/2016
// Design Name:   beat_32
// Module Name:   C:/Users/CSE310/Desktop/310lab2/lab3/beat_32_tb.v
// Project Name:  lab3
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: beat_32
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module beat_32_tb;

	// Inputs
	reg clk;

	// Outputs
	wire clk32;

	// Instantiate the Unit Under Test (UUT)
	beat_32 uut (
		.clk(clk), 
		.clk32(clk32)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		clk = 500;
		// Wait 100 ns for global reset to finish
		#100;
		forever begin
		
		clk=~clk;
		#100;
		end
        $display("clk32 = %d", clk32);
		// Add stimulus here
		$stop;
	end
      
endmodule

