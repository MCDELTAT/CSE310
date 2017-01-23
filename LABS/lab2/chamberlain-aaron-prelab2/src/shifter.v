`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:04:22 02/09/2016 
// Design Name: 
// Module Name:    shifter 
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
module shifter(
	input [4:0] in,
	input [2:0] distance,
	input direction,
	output reg [4:0] out
    );
	 
	always @* begin
		case(direction)
			1'b1 : out = in >> distance;
			1'b0 : out = in << distance;
		endcase	
	end

endmodule