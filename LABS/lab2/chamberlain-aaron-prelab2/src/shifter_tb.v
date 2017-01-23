`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   12:23:52 02/09/2016
// Design Name:   shifter
// Module Name:   C:/Users/CSE310/Desktop/310lab2/lab2/shifter_tb.v
// Project Name:  lab2
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
	reg [4:0] in;
	reg [2:0] distance;
	reg direction;

	// Outputs
	wire [4:0] out;

	// Instantiate the Unit Under Test (UUT)
	shifter dut (
		.in(in), 
		.distance(distance), 
		.direction(direction), 
		.out(out)
	);

	initial begin
		// Initialize Inputs
		in = 5'b0;
		distance = 3'b0;
		direction = 1'b0;
      
		// Wait 100 ns for global reset to finish
		#100;
      in = 5'b00100;
		distance = 3'b010;
		#5;
		$display("result is %b",out);
		#100;
		
		direction = 1'b1;
		#5;
		$display("result is %b",out);
		#100;
      in = 5'b10000;
		distance = 3'b100;
		#5;
		$display("result is %b",out);
		#100;
      in = 5'b10000;
		distance = 3'b100;
		direction = 1'b0;
		#5;
		$display("result is %b",out);
		// Add stimulus here

	end
      
endmodule
