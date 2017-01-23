`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:40:54 01/12/2016 
// Design Name: 
// Module Name:    lab0_top 
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
module lab0_top(
	input left_pushbutton,
	input right_pushbutton,
	input [3:0] A,
	input [3:0] B,
	output reg [3:0] result
   );
	
	wire [3:0] anded_result;
	wire [3:0] added_result;
	assign anded_result = A & B;
	assign added_result = A + B;
	
	always @* begin
		case ({left_pushbutton, right_pushbutton})
			2'b01 : result = added_result;
			2'b10 : result = anded_result;
			2'b11 : result = added_result;
		endcase
	end

endmodule
