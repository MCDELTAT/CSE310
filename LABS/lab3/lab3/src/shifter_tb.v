`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   12:34:13 02/23/2016
// Design Name:   shifter
// Module Name:   C:/Users/CSE310/Desktop/310lab2/lab3/shifter_tb.v
// Project Name:  lab3
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: shifter
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module shifter_tb;

	// Inputs
	reg shift_left;
	reg shift_right;

	// Outputs
	wire [3:0]out;

	// Instantiate the Unit Under Test (UUT)
	shifter uut (
		.shift_left(shift_left), 
		.shift_right(shift_right), 
		.out(out)
	);

	initial begin
		// Initialize Inputs
		shift_left = 1'b0;
		shift_right = 1'b0;
		shift_left = 1'b1;
		shift_right = 1'b0;
		// Wait 100 ns for global reset to finish
		#100;
        $display("out is %b", out);
		#100
		  $display("out is %b", out);
		#100
			$display("out is %b", out);
		// Add stimulus here
		$stop;
	end
      
endmodule

