`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:19:09 03/15/2016 
// Design Name: 
// Module Name:    labpractical 
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
module labpractical(
	input btn1,
	input btn2,
	input btn3,
	input btn4,
	input [3:0] A,
	input [3:0] B,
	output reg [3:0] C
    );

	wire [3:0] added_result;
	wire [3:0] diff_result;
	wire [3:0] shiftR_result;
	wire [3:0] shiftL_result;
	
	assign added_result = A+B;
	assign diff_result = A-B;
	assign shiftR_result = A >> B;
	assign shiftL_result = A << B;
	
	//explicit statements are boring but hey......
	always @* begin
		case ({btn1, btn2, btn3, btn4})
			//cases for 1 high button
			4'b1000 : C = added_result;
			4'b0100 : C = diff_result;
			4'b0010 : C = shiftR_result;
			4'b0001 : C = shiftL_result;
			//cases for 2 high buttons
			4'b1100 : C = diff_result;
			4'b1010 : C = shiftR_result;
			4'b1001 : C = shiftL_result;
			4'b0110 : C = shiftR_result;
			4'b0101 : C = shiftL_result;
			4'b0011 : C = shiftL_result;
			//cases for 3 high buttons
			4'b1110 : C = shiftR_result;
			4'b1101 : C = shiftL_result;
			4'b1011 : C = shiftL_result;
			4'b0111 : C = shiftL_result;
			//cases for all or none
			4'b0000 : C = 4'b0;
			4'b1111 : C = shiftL_result;
			default : C = 4'b0;
		endcase
	end
endmodule
