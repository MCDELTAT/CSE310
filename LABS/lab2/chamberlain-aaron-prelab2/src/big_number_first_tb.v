`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   09:14:26 03/01/2016
// Design Name:   big_number_first
// Module Name:   /home/aaron/Documents/CSE310 Labs/lab2/big_number_first_tb.v
// Project Name:  lab2
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: big_number_first
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module big_number_first_tb;

	// Inputs
	reg [7:0] aIn;
	reg [7:0] bIn;

	// Outputs
	wire [7:0] aOut;
	wire [7:0] bOut;

	// Instantiate the Unit Under Test (UUT)
	big_number_first uut (
		.aIn(aIn), 
		.bIn(bIn), 
		.aOut(aOut), 
		.bOut(bOut)
	);

	initial begin
		// Initialize Inputs
		aIn = 8'b00100000;
		bIn = 8'b01000001;

		// Wait 100 ns for global reset to finish
		#100;
		$display("The Bigger number is %b, the smaller one is %b", aOut, bOut);
		// Add stimulus here
		#5;
		aIn = 8'b00100011;
		bIn = 8'b11100001;
		#5;
		$display("The Bigger number is %b, the smaller one is %b", aOut, bOut);
		$stop;
	end
      
endmodule

