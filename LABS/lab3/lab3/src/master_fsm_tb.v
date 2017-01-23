`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   12:43:38 03/01/2016
// Design Name:   master_fsm
// Module Name:   C:/Users/Luc/Desktop/lab3/lab3/master_fsm_tb.v
// Project Name:  lab3
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: master_fsm
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module master_fsm_tb;

	// Inputs
	reg up_button;
	reg down_button;
	reg next;

	// Outputs
	wire shift_left;
	wire shift_right;
	reg [5:0] bike_state;

	// Instantiate the Unit Under Test (UUT)
	master_fsm uut (
		.up_button(up_button), 
		.down_button(down_button), 
		.next(next), 
		.shift_left(shift_left), 
		.shift_right(shift_right), 
		.bike_state(bike_state)
	);

	initial begin
		// Initialize Inputs
		up_button = 0;
		down_button = 0;
		next = 0;
		up_button = 1;
		down_button = 0;
		bike_state = 6'b001000;
		// Wait 100 ns for global reset to finish
		#100;
        $display("up_button = %b, down_button = %b, bike_state = %b", up_button, down_button, bike_state);
		// Add stimulus here
		up_button = 0;
		down_button =1;
		// Wait 100 ns for global reset to finish
		#100;
        $display("up_button = %b, down_button = %b, bike_state = %b", up_button, down_button, bike_state);
	end
      
endmodule

