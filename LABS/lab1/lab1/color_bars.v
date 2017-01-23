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
/*******************************************************************************
* Module: color_bars.v
* Project: DVI
* Description: Generates test color bars for the DVI output
* 
* Updated: 2012/01/24
*******************************************************************************/

`include "dvi_defines.v"

module color_bars(
    input [`log2NUM_COLS-1:0] x,
    input [`log2NUM_ROWS-1:0] y,
    output reg [7:0] r,
    output reg [7:0] g,
    output reg [7:0] b
);

    /* Generate display */
    always @(*) begin
        r = 255;
        g = 255;
        b = 255;
        if ((y >= 0) && (y < 120)) begin
            if ((x >= 0) && (x < 160)) begin
                r = 255;
                g = 0;
                b = 0;
            end
            if ((x >= 160) && (x < 320)) begin
                r = 0;
                g = 255;
                b = 0;
            end
            if ((x >= 320) && (x < 480)) begin
                r = 0;
                g = 0;
                b = 255;
            end
            if ((x >= 480) && (x < 640)) begin
                r = 255;
                g = 255;
                b = 0;
            end
        end

        if ((y >= 120) && (y <240)) begin
            if ((x >= 0) && (x < 160)) begin
                r = 0;
                g = 255;
                b = 255;
            end
            if ((x >= 160) && (x < 320)) begin
                r = 0;
                g = 0;
                b = 255;
            end
            if ((x >= 320) && (x < 480)) begin
                r = 255;
                g = 0;
                b = 0;
            end
            if ((x >= 480) && (x < 640)) begin
                r = 0;
                g = 255;
                b = 0;
            end
        end

        if ((y >=240) && (y < 360)) begin
            r = 0;
            g = 0;
            b = 0;
        end

        if (y > 512) begin
            r = x[7:0];
            g = x[8:1];
            b = x[9:2];
        end

        /* Corners */
        if ((x==0 || x==`NUM_COLS-1) && (y==0 || y==`NUM_ROWS-1)) begin
            r = {8{x==0}};
            g = {8{x==0}};
            b = {8{x==0}};
        end
    end
endmodule
