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
// Tic-tac-toe
//-----------------------------------------------------------------------------
// TicTacToe
// Generates a move for X in the game of tic-tac-toe
// Inputs:
//   xin, oin - (9-bit) current positions of X and O.
// Out:
//   xout - (9-bit) one hot position of next X.
//
// Inputs and outputs use a board mapping of:
//
//   0 | 1 | 2 
//  ---+---+---
//   3 | 4 | 5 
//  ---+---+---
//   6 | 7 | 8 
//
// The top-level circuit instantiates strategy modules that each generate
// a move according to their strategy and a selector module that selects
// the highest-priority strategy module with a move.
//
// The win strategy module picks a space that will win the game if any exists.
//
// The block strategy module picks a space that will block the opponent
// from winning.
//
// The empty strategy module picks the first open space - using a particular
// ordering of the board.
//-----------------------------------------------------------------------------
module tictactoe(
    input [8:0] xin,
    input [8:0] oin,
    output wire [8:0] xout
);
    wire [8:0] win, block, empty;

    // List of strategy modules

    // Win if we can
    two_in_array winx(
        .ain(xin),
        .bin(oin),
        .cout(win)
    );
    // Try to block o from winning
    two_in_array blockx(
        .ain(oin),
        .bin(xin),
        .cout(block)
    );       

    //------------------------------------------------------------------------
    // TO DO:
    // Add a module implementing the strategy as described in
    // Problem 9.5 (c) of notes here.
    //
    // play_adjacent_edge adjacentx(
    //     .ain(xin),
    //     .bin(oin),
    //     .cout(adjacent)
    // );

    // Otherwise pick empty space
    empty emptyx(
        .in(~(oin | xin)),
        .out(empty)
    );   

    //------------------------------------------------------------------------
    // TO DO:
    // Change this priority encoder into a select4

    // Pick highest priority
    select3 comb(
        .a(win),
        .b(block),
        .c(empty),
        .out(xout)
    );

endmodule

