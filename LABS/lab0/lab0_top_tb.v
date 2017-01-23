`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:53:42 01/12/2016 
// Design Name: 
// Module Name:    lab0_top_tb 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module lab0_top_tb(
    );

	reg sim_left_pushbutton;
	reg sim_right_pushbutton;
	reg [3:0] sim_A;
	reg [3:0] sim_B;

	wire [3:0] sim_result;
	
	lab0_top dut (
		.left_pushbutton(sim_left_pushbutton),
		.right_pushbutton(sim_right_pushbutton),
		.A(sim_A),
		.B(sim_B),
		.result(sim_result) 
	);

	initial begin
		//set all buttons to 'unpushed'
		sim_left_pushbutton = 1'b0;
		sim_right_pushbutton = 1'b0;
		
		//start with all our outputs as zeroes
		sim_A = 4'b0;
		sim_B = 4'b0;
		
		//wait 5 simulation timestamps to allow those changes to happen
		#5;
		
		//our first test, try ANDing
		sim_left_pushbutton = 1'b1;
		sim_A = 4'b1100;
		sim_B = 4'b1010;
		
		//again, wait 5 simulation timestamps to allow those changes to happen
		#5;
		
		//print the current values to the log
		$display("Output is %b, we expect %b", sim_result, (4'b1100 & 4'b1010));
		
		//stop simulating
		$stop;
		
		
	end

endmodule
