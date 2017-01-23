`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:19:01 02/23/2016 
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
	input shift_left,shift_right,
	output reg [3:0]out
    );
	assign out = 4'b0001;
	always @* begin
			case(shift_left & out != 4'b1000)
				1'b1 : out = out << 1;
			endcase
			case(shift_right & out != 4'b0001)
				1'b1 : out = out >> 1;
			endcase
	end
	
	//always @* begin
	//	if(shift_left == 1)
		//	begin
		//		if (out != 1000)
		//			assign out = out << 1;
		//	end
		//if(shift_right == 1)
		//	begin
		//		if(out != 0001)
		//			assign out = out >> 1;
		//	end
	//end

endmodule
