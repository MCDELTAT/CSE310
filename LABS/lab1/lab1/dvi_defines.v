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
* Module: dvi_defines.v
* Project: DVI
* Description: Variables to drive 1280 x 1024 at 56 Hz
*******************************************************************************/

// Parameters
`define COLOR_WIDTH 8
`define NUM_COLS 1280
`define NUM_ROWS 1024
`define log2NUM_COLS 11
`define log2NUM_ROWS 10

// For quick simulation:
// synthesis translate_off
`define H_SYNC_PULSE 1
`define H_BACK_PORCH 1
`define H_FRONT_PORCH 1
`define V_SYNC_PULSE 1
`define V_BACK_PORCH 1
`define V_FRONT_PORCH 1

// For synthesis:
`ifdef SYNTHESIS
// synthesis translate_on
`define H_SYNC_PULSE 112
`define H_BACK_PORCH 248
`define H_FRONT_PORCH 48
`define V_SYNC_PULSE 3
`define V_BACK_PORCH 38
`define V_FRONT_PORCH 1
// synthesis translate_off
`endif
// synthesis translate_on

// For both:
`define NUM_XCLKS_IN_ROW `NUM_COLS + `H_SYNC_PULSE + `H_BACK_PORCH + `H_FRONT_PORCH
`define log2NUM_XCLKS_IN_ROW   11
`define NUM_LINES_IN_FRAME `NUM_ROWS + `V_FRONT_PORCH + `V_SYNC_PULSE + `V_BACK_PORCH
`define log2NUM_LINES_IN_FRAME 11

