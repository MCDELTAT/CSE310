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
//-----------------------------------------------------------------------------
// lab1_testbench
// Test bench
//-----------------------------------------------------------------------------
module lab1_testbench();
    reg [8:0] xin, oin;
    wire [8:0] xout, oout;

    tictactoe dut(
        .xin(xin),
        .oin(oin),
        .xout(xout)
    );
    tictactoe opponent(
        .xin(oin),
        .oin(xin),
        .xout(oout)
    );

    initial begin
        // all zeros, should pick middle
        xin = 0; oin = 0; 
        #100 $display("%b %b -> %b", xin, oin, xout);
        // can win across the top
        xin = 9'b101; oin = 0; 
        #100 $display("%b %b -> %b", xin, oin, xout);
        // can't win across the top due to block
        xin = 9'b101; oin = 9'b010; 
        #100 $display("%b %b -> %b", xin, oin, xout);
        // block in the first column
        xin = 0; oin = 9'b100100; 
        #100 $display("%b %b -> %b", xin, oin, xout);
        // block along a diagonal
        xin = 0; oin = 9'b010100; 
        #100 $display("%b %b -> %b", xin, oin, xout);
        // start a game - x goes first
        xin = 0; oin = 0; 
        repeat (6) begin
            #100
            $display("%h %h %h", {xin[0],oin[0]},{xin[1],oin[1]},{xin[2],oin[2]});
            $display("%h %h %h", {xin[3],oin[3]},{xin[4],oin[4]},{xin[5],oin[5]});
            $display("%h %h %h", {xin[6],oin[6]},{xin[7],oin[7]},{xin[8],oin[8]});
            $display(" ");
            xin = (xout | xin); 
            #100 
            $display("%h %h %h", {xin[0],oin[0]},{xin[1],oin[1]},{xin[2],oin[2]});
            $display("%h %h %h", {xin[3],oin[3]},{xin[4],oin[4]},{xin[5],oin[5]});
            $display("%h %h %h", {xin[6],oin[6]},{xin[7],oin[7]},{xin[8],oin[8]});
            $display(" ");
            oin = (oout | oin);
        end
    end
endmodule
//-----------------------------------------------------------------------------
