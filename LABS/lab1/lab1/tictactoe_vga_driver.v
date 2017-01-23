/*******************************************************************************
Copyright (c) 2012, Stanford University
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:
1. Redistributions of source code must retain the above copyright
   notice, this list of conditions and the following disclaimer.
2. Redistributions in binary form must reproduce the above copyright
   notice, this list of conditions and the following disclaimer in the
   documentation and/or other materials provided with the distribution.
3. All advertising materials mentioning features or use of this software
   must display the following acknowledgement:
   This product includes software developed at Stanford University.
4. Neither the name of Stanford Univerity nor the
   names of its contributors may be used to endorse or promote products
   derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY STANFORD UNIVERSITY ''AS IS'' AND ANY
EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL STANFORD UNIVERSITY BE LIABLE FOR ANY
DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*******************************************************************************/
//=============================================================================
// VGA display driver for Tic-Tac-Toe
//
// Uses TCGROM to display characters based on current screen location
//
//=============================================================================

`include "dvi_defines.v"

module tictactoe_vga_driver(
    input clk, 

    input [8:0] current_x,
    input [8:0] current_o,
    input [8:0] next_x,

    input [`log2NUM_COLS-1:0] XPos, 
    input [`log2NUM_ROWS-1:0] YPos, 
    input Valid, 

    output wire [5:0] vga_rgb
);

    wire [7:0] tcgrom_d, tcgrom_q;
    wire [5:0] char_selection_d, char_selection_q;
    reg        color;
    reg  [5:0] char_selection;
    reg  [5:0] char_color;
    wire [5:0] char_color_d, char_color_q;
    wire [5:0] char_color_2_d, char_color_2_q;
    wire [4:0] lineValid;
    wire       gridValid;
    wire [8:0] currentConflict;
    wire [8:0] nextConflict;
     
//=============================================================================
//  Hook up the VGA modules and define the output colors
//=============================================================================
    // Detect conflict in the placement of x and o
    assign currentConflict = current_x & current_o;
    assign nextConflict = (current_x & current_o) | (current_x & next_x)
                          | (current_o & next_x);

    // Display the correct characters
    always @* begin
        char_selection = 6'b100000;
        char_color = 6'b111111;  // RRBBGG

        case (YPos[`log2NUM_ROWS-1:6])
            // Dummy line to silence ISE warnings; doesn't display anything
            0: char_color = {XPos[2:0], YPos[2:0]};

            // First row of text
            1: begin
                char_color = 6'b110000;
                case (XPos[`log2NUM_COLS-1:6])
                    5:  char_selection = 6'd20; //T
                    6:  char_selection = 6'd09; //I
                    7:  char_selection = 6'd03; //C
                    9:  char_selection = 6'd20; //T
                    10: char_selection = 6'd01; //A
                    11: char_selection = 6'd03; //C
                    13: char_selection = 6'd20; //T
                    14: char_selection = 6'd15; //O
                    15: char_selection = 6'd05; //E        
                    default: char_selection = 6'b100000;
                endcase
            end

            // Second row of text
            3: begin
                char_color = 6'b001100;
                case (XPos[`log2NUM_COLS-1:6])
                    2:  char_selection = 6'd03; //C
                    3:  char_selection = 6'd21; //U
                    4:  char_selection = 6'd18; //R
                    5:  char_selection = 6'd18; //R
                    6:  char_selection = 6'd05; //E
                    7:  char_selection = 6'd14; //N
                    8:  char_selection = 6'd20; //T
                    13: char_selection = 6'd14; //N
                    14: char_selection = 6'd05; //E 
                    15: char_selection = 6'd24; //X
                    16: char_selection = 6'd20; //T
                    default: char_selection = 6'b100000;
                endcase
            end

            // Put crosses or naughts in the grid. See the grid as a 3 x 3 matrix
            // Row 1
            5: begin
                case (XPos[`log2NUM_COLS-1:6])
                    3: begin
                        // Current grid (1, 1)
                        char_selection = currentConflict[0] ? 6'd3 : (current_x[0] ? 6'd24 : (current_o[0] ? 6'd15 : 6'b100000));
                        char_color = currentConflict[0] ? 6'b110000 : 6'b111111;
                    end
                    5: begin
                        // Current grid (1, 2)
                        char_selection = currentConflict[1] ? 6'd3 : (current_x[1] ? 6'd24 : (current_o[1] ? 6'd15 : 6'b100000));
                        char_color = currentConflict[1] ? 6'b110000 : 6'b111111;
                    end
                    7: begin
                        // Current grid (1, 3)
                        char_selection = currentConflict[2] ? 6'd3 : (current_x[2] ? 6'd24 : (current_o[2] ? 6'd15 : 6'b100000));
                        char_color = currentConflict[2] ? 6'b110000 : 6'b111111;
                    end
                    12: begin
                        // Next grid (1, 1)
                        char_selection = nextConflict[0] ? 6'd3 : (next_x[0] ? 6'd24 : (current_x[0] ? 6'd24 : (current_o[0] ? 6'd15 : 6'b100000)));
                        char_color = nextConflict[0] ? 6'b110000 : (next_x[0] ? 6'b000011 : 6'b111111);
                    end
                    14: begin
                        // Next grid (1, 2)
                        char_selection = nextConflict[1] ? 6'd3 : (next_x[1] ? 6'd24 : (current_x[1] ? 6'd24 : (current_o[1] ? 6'd15 : 6'b100000)));
                        char_color = nextConflict[1] ? 6'b110000 : (next_x[1] ? 6'b000011 : 6'b111111);
                    end
                    16: begin
                        // Next grid (1, 3)
                        char_selection = nextConflict[2] ? 6'd3 : (next_x[2] ? 6'd24 : (current_x[2] ? 6'd24 : (current_o[2] ? 6'd15 : 6'b100000)));
                        char_color = nextConflict[2] ? 6'b110000 : (next_x[2] ? 6'b000011 : 6'b111111);
                    end
                    default: char_selection = 6'b100000;
                endcase
            end

            // Row 2
            7: begin
                case (XPos[`log2NUM_COLS-1:6])
                    3: begin
                        // Current grid (2, 1)
                        char_selection = currentConflict[3] ? 6'd3 : (current_x[3] ? 6'd24 : (current_o[3] ? 6'd15 : 6'b100000));
                        char_color = currentConflict[3] ? 6'b110000 : 6'b111111;
                    end
                    5: begin
                        // Current grid (2, 2)
                        char_selection = currentConflict[4] ? 6'd3 : (current_x[4] ? 6'd24 : (current_o[4] ? 6'd15 : 6'b100000));
                        char_color = currentConflict[4] ? 6'b110000 : 6'b111111;
                    end
                    7: begin
                        // Current grid (2, 3)
                        char_selection = currentConflict[5] ? 6'd3 : (current_x[5] ? 6'd24 : (current_o[5] ? 6'd15 : 6'b100000));
                        char_color = currentConflict[5] ? 6'b110000 : 6'b111111;
                    end
                    12: begin
                        // Next grid (2, 1)
                        char_selection = nextConflict[3] ? 6'd3 : (next_x[3] ? 6'd24 : (current_x[3] ? 6'd24 : (current_o[3] ? 6'd15 : 6'b100000)));
                        char_color = nextConflict[3] ? 6'b110000 : (next_x[3] ? 6'b000011 : 6'b111111);
                    end
                    14: begin
                        // Next grid (2, 2)
                        char_selection = nextConflict[4] ? 6'd3 : (next_x[4] ? 6'd24 : (current_x[4] ? 6'd24 : (current_o[4] ? 6'd15 : 6'b100000)));
                        char_color = nextConflict[4] ? 6'b110000 : (next_x[4] ? 6'b000011 : 6'b111111);
                    end
                    16: begin
                        // Next grid (2, 3)
                        char_selection = nextConflict[5] ? 6'd3 : (next_x[5] ? 6'd24 : (current_x[5] ? 6'd24 : (current_o[5] ? 6'd15 : 6'b100000)));
                        char_color = nextConflict[5] ? 6'b110000 : (next_x[5] ? 6'b000011 : 6'b111111);
                    end
                    default: char_selection = 6'b100000;
                endcase
            end

            // Row 3
            9: begin
                case (XPos[`log2NUM_COLS-1:6])
                    3: begin
                        // Current grid (3, 1)
                        char_selection = currentConflict[6] ? 6'd3 : (current_x[6] ? 6'd24 : (current_o[6] ? 6'd15 : 6'b100000));
                        char_color = currentConflict[6] ? 6'b110000 : 6'b111111;
                    end
                    5: begin
                        // Current grid (3, 2)
                        char_selection = currentConflict[7] ? 6'd3 : (current_x[7] ? 6'd24 : (current_o[7] ? 6'd15 : 6'b100000));
                        char_color = currentConflict[7] ? 6'b110000 : 6'b111111;
                    end
                    7: begin
                        // Current grid (3, 3)
                        char_selection = currentConflict[8] ? 6'd3 : (current_x[8] ? 6'd24 : (current_o[8] ? 6'd15 : 6'b100000));
                        char_color = currentConflict[8] ? 6'b110000 : 6'b111111;
                    end
                    12: begin
                        // Next grid (3, 1)
                        char_selection = nextConflict[6] ? 6'd3 : (next_x[6] ? 6'd24 : (current_x[6] ? 6'd24 : (current_o[6] ? 6'd15 : 6'b100000)));
                        char_color = nextConflict[6] ? 6'b110000 : (next_x[6] ? 6'b000011 : 6'b111111);
                    end
                    14: begin
                        // Next grid (3, 2)
                        char_selection = nextConflict[7] ? 6'd3 : (next_x[7] ? 6'd24 : (current_x[7] ? 6'd24 : (current_o[7] ? 6'd15 : 6'b100000)));
                        char_color = nextConflict[7] ? 6'b110000 : (next_x[7] ? 6'b000011 : 6'b111111);
                    end
                    16: begin
                        // Next grid (3, 3)
                        char_selection = nextConflict[8] ? 6'd3 : (next_x[8] ? 6'd24 : (current_x[8] ? 6'd24 : (current_o[8] ? 6'd15 : 6'b100000)));
                        char_color = nextConflict[8] ? 6'b110000 : (next_x[8] ? 6'b000011 : 6'b111111);
                    end
                    default: char_selection = 6'b100000;
                endcase
            end

            // First row of text beneath the grids
            11: begin
                char_color = 6'b000011;
                case (XPos[`log2NUM_COLS-1:6])
                    1: char_selection = 6'd24; //X
                    2: char_selection = 6'd09; //I
                    3: char_selection = 6'd14; //N
                    11: char_selection = 6'd24; //X
                    12: char_selection = 6'd15; //O
                    13: char_selection = 6'd21; //U
                    14: char_selection = 6'd20; //T
                    default: char_selection = 6'b100000;
                endcase
            end

            // Second row of text beneath the grids
            12: begin
                char_color = 6'b111111;
                // Xin
                case (XPos[`log2NUM_COLS-1:6])
                    1: char_selection = current_x[8] ? 6'd49 : 6'd48; // Bit 8
                    2: char_selection = current_x[7] ? 6'd49 : 6'd48; // Bit 7
                    3: char_selection = current_x[6] ? 6'd49 : 6'd48; // Bit 6
                    4: char_selection = current_x[5] ? 6'd49 : 6'd48; // Bit 5
                    5: char_selection = current_x[4] ? 6'd49 : 6'd48; // Bit 4
                    6: char_selection = current_x[3] ? 6'd49 : 6'd48; // Bit 3
                    7: char_selection = current_x[2] ? 6'd49 : 6'd48; // Bit 2
                    8: char_selection = current_x[1] ? 6'd49 : 6'd48; // Bit 1
                    9: char_selection = current_x[0] ? 6'd49 : 6'd48; // Bit 0
                    // Xout
                    11: char_selection = next_x[8] ? 6'd49 : 6'd48; // Bit 8
                    12: char_selection = next_x[7] ? 6'd49 : 6'd48; // Bit 7
                    13: char_selection = next_x[6] ? 6'd49 : 6'd48; // Bit 6
                    14: char_selection = next_x[5] ? 6'd49 : 6'd48; // Bit 5
                    15: char_selection = next_x[4] ? 6'd49 : 6'd48; // Bit 4
                    16: char_selection = next_x[3] ? 6'd49 : 6'd48; // Bit 3
                    17: char_selection = next_x[2] ? 6'd49 : 6'd48; // Bit 2
                    18: char_selection = next_x[1] ? 6'd49 : 6'd48; // Bit 1
                    19: char_selection = next_x[0] ? 6'd49 : 6'd48; // Bit 0
                    default: char_selection = 6'b100000;
                endcase
            end

            // Third row of text beneath the grids
            13: begin
                char_color = 6'b000011;
                case (XPos[`log2NUM_COLS-1:6])
                    1: char_selection = 6'd15; //O
                    2: char_selection = 6'd09; //I
                    3: char_selection = 6'd14; //N
                    default: char_selection = 6'b100000;
                endcase
            end

            // Forth row of text beneath the grids
            14: begin
                char_color = 6'b111111;
                case (XPos[`log2NUM_COLS-1:6])
                    // Oin
                    1: char_selection = current_o[8] ? 6'd49 : 6'd48; // Bit 8
                    2: char_selection = current_o[7] ? 6'd49 : 6'd48; // Bit 7
                    3: char_selection = current_o[6] ? 6'd49 : 6'd48; // Bit 6
                    4: char_selection = current_o[5] ? 6'd49 : 6'd48; // Bit 5
                    5: char_selection = current_o[4] ? 6'd49 : 6'd48; // Bit 4
                    6: char_selection = current_o[3] ? 6'd49 : 6'd48; // Bit 3
                    7: char_selection = current_o[2] ? 6'd49 : 6'd48; // Bit 2
                    8: char_selection = current_o[1] ? 6'd49 : 6'd48; // Bit 1
                    9: char_selection = current_o[0] ? 6'd49 : 6'd48; // Bit 0
                    default: char_selection = 6'b100000;
                endcase
            end
        endcase
    end

    // Add the lines that make up the game's grid lines
    wire left_grid_x  = (XPos[`log2NUM_COLS-1:6] >=  3)
                     && (XPos[`log2NUM_COLS-1:6] <=  7);
    wire right_grid_x = (XPos[`log2NUM_COLS-1:6] >= 12)
                     && (XPos[`log2NUM_COLS-1:6] <= 16);
    wire upper_horizontal_y = (YPos[`log2NUM_ROWS-1:4] == 26);
    wire lower_horizontal_y = (YPos[`log2NUM_ROWS-1:4] == 33);
    wire vertical_y   = (YPos[`log2NUM_ROWS-1:6] >=  5)
                     && (YPos[`log2NUM_ROWS-1:6] <=  9);
    // Upper and lower horizontal lined of the left and right grids
    assign lineValid[0] = (upper_horizontal_y || lower_horizontal_y)
                          && (left_grid_x || right_grid_x);
    // Left vertical line of the left grid
    assign lineValid[1] = vertical_y && (XPos[`log2NUM_COLS-1:4] == 18);
    // Right vertical line fo the left grid
    assign lineValid[2] = vertical_y && (XPos[`log2NUM_COLS-1:4] == 25);
    // Left vertical line of the right grid
    assign lineValid[3] = vertical_y && (XPos[`log2NUM_COLS-1:4] == 54);
    // Right vertical line of the right grid
    assign lineValid[4] = vertical_y && (XPos[`log2NUM_COLS-1:4] == 61);
    assign gridValid = |lineValid;

    // Register the output of the character generator and the color value
    assign char_selection_d = char_selection;
    assign char_color_d = char_color;

    // Register the output of the tcgrom
    tcgrom tcgrom(.addr({char_selection_q, YPos[5:3]}), .data(tcgrom_d));
    assign char_color_2_d = char_color_q;

    always @* begin     
        case (XPos[5:3])
            3'h0 : color = tcgrom_q[7];
            3'h1 : color = tcgrom_q[6];
            3'h2 : color = tcgrom_q[5];
            3'h3 : color = tcgrom_q[4];
            3'h4 : color = tcgrom_q[3];
            3'h5 : color = tcgrom_q[2];
            3'h6 : color = tcgrom_q[1];
            3'h7 : color = tcgrom_q[0];                            
        endcase 
    end  

    // Generates the RGB signals based on raster position
    // Note: try playing around here to see if you can change the colors of the display.
    // The way this works is that color is true when we want to display part of a letter,
    // so, if you only turned on the blue when color was true you would just see blue.
    assign vga_rgb = gridValid ? {6{1'b1}} : ((Valid & color) ? char_color_2_q : {6{1'b0}});

    //For character display
    dff #(8) tcgrom_reg (.clk(clk), .d(tcgrom_d), .q(tcgrom_q));
    dff #(6) char_selection_reg (.clk(clk), .d(char_selection_d), .q(char_selection_q));
    dff #(6) char_color_reg (.clk(clk), .d(char_color_d), .q(char_color_q));
    dff #(6) char_color_2_reg (.clk(clk), .d(char_color_2_d), .q(char_color_2_q));

endmodule
