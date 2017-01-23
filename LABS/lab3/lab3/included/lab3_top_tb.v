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
//----------------------------------------------------
// Test bench for Lab 3 (Bicycle Light)
//----------------------------------------------------

/* For this lab, you need to include additional test cases in the testbench that
 * will show the correct implementation of the adjustable fast and slow states 
 * 
 * To make this easier, it is suggested that you run the simulations run the
 * flashing at a much faster speed for debugging.  It is possible to simulate
 * for the full seconds that the light should flash, but this would take a very
 * long time.  Instead simulate the lights flashing at a much faster speed and
 * just make sure that you can identify the doubling and halving of this speed.
 * Then slow down to the desired speed when implementing you program on the
 * chip.
 */

module lab3_top_tb();

    reg clk, rst, button, up_select, down_select;
    wire [7:0] leds;
    wire light = leds[0];

    lab3_top dut (
        .clk(clk),
        .left_button(rst), 
        .right_button(button),
        .up_button(up_select),
        .down_button(down_select),
        .leds(leds)
    );

    // Clock with period of 10 units
    initial forever begin
        #5 clk = 1;
        #2 $display("%b %b %b %b", rst, button, dut.bicycle_fsm.mux_sel, light);
        #3 clk = 0;
    end

    // Input stimuli
    initial begin
        #10 rst = 0; // start w/o reset to show x state
        #10 rst = 1; button = 0; up_select = 0; down_select = 0; // reset
        #10 rst = 0; // remove reset
        #20 button = 1; // Constant on
        #10 button = 0;
        #30 button = 1; // OFF
        #10 button = 0;
        #40 button = 1; // Fast flash
        // TODO: Add in code here to show response to up/down buttons
        #10 button = 0;
        #50 button = 1; // OFF
        #10 button = 0;
        #30 button = 1; // Slow flash
        // TODO: Add in code here to show response to up/down buttons
        #10 button = 0;
        #120 button = 1; // OFF
        #10 button = 0;
        #40;
        $stop;
    end

endmodule
