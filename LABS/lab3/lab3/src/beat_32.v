`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:27:45 02/23/2016 
// Design Name: 
// Module Name:    beat_32 
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
module beat_32(
	input clk,
	output reg clk32
    );
	reg counter32;
	assign counter32 = 22'd0;
	always @ (posedge clk)
		begin
		clk32 = 0;
			if(counter32 == 3125000)
				begin
					counter32 = 0;
					clk32 = 1;
				end
			assign counter32 = counter32 + 1;
		end
		
endmodule
