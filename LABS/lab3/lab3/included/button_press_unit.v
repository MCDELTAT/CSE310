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
// button_press_unit
// This module synchronizes, debounces, and one-pulses a button input.
//
module button_press_unit(
    input clk, 
    input reset, 	// Standard system clock and reset
    input in, 	// The async, bouncy input
    output out	// The synchronous, clean, one-pulsed output
);
    // WIDTH determines how long to wait for the bouncing to stop.
    parameter WIDTH = 20;

    // Synchronize our input to safely avoid metastability
    wire button_sync;
    brute_force_synchronizer sync(
        .clk(clk),
        .in(in),
        .out(button_sync)
    );

    // Debounce our synchronized input
    wire button_debounced;
    debouncer #(WIDTH) debounce(
        .clk(clk),
        .reset(reset),
        .in(button_sync),
        .out(button_debounced)
    );

    // One-pulse our debounced input
    one_pulse one_pulse(
        .clk(clk),
        .reset(reset),
        .in(button_debounced),
        .out(out)
    );

endmodule
   
