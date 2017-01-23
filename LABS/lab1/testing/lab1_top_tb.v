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
`timescale 1ns / 1ps

module lab1_top_tb;

    // Inputs
    reg clk;
    reg [8:1] sw;
    reg btn1;
    reg pushbuttonLEFT;
    reg pushbuttonRIGHT;
    reg reset_button;
    reg debug_select;

    // Outputs
    wire chip_hsync;
    wire chip_vsync;
    wire [11:0] chip_data;
    wire chip_reset;
    wire chip_data_enable;
    wire xclk;
    wire xclk_n;
    wire [3:0] leds;

    // Bidirs
    tri1 scl;
    tri1 sda;

    // Instantiate the Unit Under Test (UUT)
    lab1_top uut (
        .clk(clk), 
        .chip_hsync(chip_hsync), 
        .chip_vsync(chip_vsync), 
        .chip_data(chip_data), 
        .chip_reset(chip_reset), 
        .chip_data_enable(chip_data_enable), 
        .xclk(xclk), 
        .xclk_n(xclk_n), 
        .sw(sw), 
        .btn1(btn1), 
        .pushbuttonLEFT(pushbuttonLEFT), 
        .pushbuttonRIGHT(pushbuttonRIGHT), 
        .reset_button(reset_button), 
        .debug_select(debug_select), 
        .leds(leds), 
        .scl(scl), 
        .sda(sda)
    );

    initial forever #5 clk = ~clk;

    initial begin
        // Initialize Inputs
        clk = 0;
        sw = 0;
        btn1 = 0;
        pushbuttonLEFT = 0;
        pushbuttonRIGHT = 0;
        reset_button = 1;
        debug_select = 0;

        // Wait 100 ns for global reset to finish
        #100;
        reset_button = 0;
        
        // Only render one frame.
        @(negedge chip_vsync);
        $finish;
    end
      
endmodule

