`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   11:39:27 02/09/2016
// Design Name:   adder
// Module Name:   C:/Users/CSE310/Desktop/310lab2/lab2/adder_tb.v
// Project Name:  lab2
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: adder
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module adder_tb;

	// Outputs
	reg [4:0] sim_a;
	reg [4:0] sim_b;
	wire [4:0] sim_sum;
	wire sim_cout;
	

	// Instantiate the Unit Under Test (UUT)
	adder dut (
		.a(sim_a),
		.b(sim_b),
		.sum(sim_sum),
		.cout(sim_cout)
	);

	initial begin
		// Initialize Inputs
		sim_a = 5'b00001;
		sim_b = 5'b00000;
		// Wait 100 ns for global reset to finish
		#100;
        $display("cout is %b, sum is %b",  sim_cout, sim_sum);
		 #5;
		 sim_a = 5'b10001;
		 sim_b = 5'b10000;
		 #100;
        $display("cout is %b, sum is %b",  sim_cout, sim_sum);
		   #5;
		 sim_a = 5'b11111;
		 sim_b = 5'b11111;
		 #100;
        $display("cout is %b, sum is %b",  sim_cout, sim_sum);
		// Add stimulus here
			$stop;
	end
      
endmodule
