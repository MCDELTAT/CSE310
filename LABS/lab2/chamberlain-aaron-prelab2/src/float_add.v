`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:51:05 02/15/2016 
// Design Name: 
// Module Name:    float_add 
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
module float_add(
	input [7:0] aIn,
	input [7:0] bIn,
	output reg[7:0] result
    );
	 wire [7:0] aOut,bOut;
	 wire [2:0] a_b_differ, a_expo, b_expo;
	 wire [4:0] shifter;
	 wire [4:0] sum;
	 wire cout;
	big_number_first big_number_first_1(
		.aIn(aIn),
		.bIn(bIn),
		.aOut(aOut),
		.bOut(bOut)
	);
	assign a_expo = aOut[7:5];
	assign b_expo = bOut[7:5];
	assign a_b_differ = a_expo - b_expo;
	shifter shifter_1(
		.in(bOut[4:0]),
		.distance(a_b_differ),
		.direction(1'b1),
		.out(shifter)
    );
	adder adder_1(
	.a(aOut[4:0]),
	.b(shifter),
	.sum(sum),
	.cout(cout)
    );
	 always @* begin
		if(a_expo == 3'b111 & cout == 1)
			assign result = {a_expo, 5'b11111};
		else
			assign result = {a_expo, sum};
		end
endmodule
