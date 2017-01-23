`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   11:36:46 02/16/2016
// Design Name:   float_add
// Module Name:   C:/Users/Luc/Desktop/lab2/lab2/float_add_tb.v
// Project Name:  lab2
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: float_add
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module float_add_tb;

	// Inputs
	reg [7:0] aIn;
	reg [7:0] bIn;

	// Outputs
	wire [7:0] result;

	// Instantiate the Unit Under Test (UUT)
	float_add uut (
		.aIn(aIn), 
		.bIn(bIn), 
		.result(result)
	);

	initial begin
		// Initialize Inputs
		aIn = 0;
		bIn = 0;
		// Wait 100 ns for global reset to finish
		#5;
		aIn = 8'b00001000;
		bIn = 8'b00000011;
		#100;
       $display("aIn is %b, bIn is %b,the result is %b", aIn, bIn, result);
		#5;
		aIn = 8'b00110001;
		bIn = 8'b00001100;
		#100;
       $display("aIn is %b, bIn is %b,the result is %b", aIn, bIn, result);
		// Add stimulus here
		#5;
		aIn = 8'b10010010;
		bIn = 8'b01011111;
		#100;
       $display("aIn is %b, bIn is %b,the result is %b", aIn, bIn, result);
		#5;
		aIn = 8'b11111110;
		bIn = 8'b11111000;
		#100;
       $display("aIn is %b, bIn is %b,the result is %b", aIn, bIn, result);
		
		$stop;
	end
      
endmodule

