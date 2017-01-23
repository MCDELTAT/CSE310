`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:45:06 02/09/2016 
// Design Name: 
// Module Name:    big_number_first 
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
module big_number_first(
	input [7:0] aIn,
	input [7:0] bIn,
	output reg [7:0] aOut,
	output reg [7:0] bOut
    );

	always @* begin
		if(aIn[7:5] > bIn[7:5])
			begin
				aOut = aIn;
				bOut = bIn;
			end
		else
			begin
				aOut = bIn;
				bOut = aIn;
			end
	end
endmodule
