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
// two_in_array
// Indicates if any row or column or diagonal in the array has two pieces of
// type a and no pieces of type b. (a and b can be x and o or o and x)
// Inputs:
//   ain, bin - (9 bits) array of types a and b
// Output:
//   cout - (9 bits) location of space to play in to complete row, column
//          or diagonal of a.
// If more than one space meets the criteria the output may have more than
// one bit set.
// If no spaces meet the criteria, the output will be all zeros.
//-----------------------------------------------------------------------------
module two_in_array(
    input [8:0] ain,
    input [8:0] bin,
    output wire [8:0] cout
);

    wire [8:0] rows, cols;
    wire [2:0] ddiag, udiag;

    // check each row
    two_in_row topr(
        .ain(ain[2:0]),
        .bin(bin[2:0]),
        .cout(rows[2:0])
    );
    two_in_row midr(
        .ain(ain[5:3]),
        .bin(bin[5:3]),
        .cout(rows[5:3])
    );
    two_in_row botr(
        .ain(ain[8:6]),
        .bin(bin[8:6]),
        .cout(rows[8:6])
    );

    // check each column
    two_in_row leftc(
        .ain({ain[6], ain[3], ain[0]}),
        .bin({bin[6], bin[3], bin[0]}),
        .cout({cols[6], cols[3], cols[0]})
    );
    two_in_row midc(
        .ain({ain[7], ain[4], ain[1]}),
        .bin({bin[7], bin[4], bin[1]}),
        .cout({cols[7], cols[4], cols[1]})
    );
    two_in_row rightc(
        .ain({ain[8], ain[5], ain[2]}),
        .bin({bin[8], bin[5], bin[2]}),
        .cout({cols[8], cols[5], cols[2]})
    );

    // Check both diagonals
    two_in_row dndiagx(
        .ain({ain[8], ain[4], ain[0]}),
        .bin({bin[8], bin[4], bin[0]}),
        .cout(ddiag)
    );
    two_in_row updiagx(
        .ain({ain[6], ain[4], ain[2]}),
        .bin({bin[6], bin[4], bin[2]}),
        .cout(udiag)
    );

    //OR together the outputs
    assign cout = rows | cols
                  | {ddiag[2], 3'b000, ddiag[1], 3'b000, ddiag[0]}
                  | {2'b00, udiag[2], 1'b0, udiag[1], 1'b0, udiag[0], 2'b00};

endmodule
