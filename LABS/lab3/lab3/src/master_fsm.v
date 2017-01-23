`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:16:50 03/01/2016 
// Design Name: 
// Module Name:    master_fsm 
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
module master_fsm(
	input up_button,
	input down_button,
	input next,
	output reg shift_left,
	output reg shift_right,
	output reg [5:0] bike_state
    );
	initial
	begin
	shift_left=0;
	shift_right=0;
	bike_state = 6'b000001;
	end
	always @* begin
		if(next == 1)
			if(bike_state == 6'b100000)
				bike_state = 6'b000001;
			else
				bike_state = bike_state << 1;
	end
	always @* begin
		if(bike_state == 6'b100000)
			begin
			case({up_button, down_button})
				2'b01: shift_right = 1;
				2'b10: shift_left = 1;
				2'b11: shift_left= 1;
				
			endcase
			end
	end
	
	

endmodule
