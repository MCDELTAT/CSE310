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
// Lab 1
//
// Top level module. Integrates the various system components.
//=============================================================================

module lab1_top (
    /* clock in */
    input clk,

    /* dvi signals out */
    output chip_hsync,
    output chip_vsync,
    output [11:0] chip_data,
    output chip_reset,
    output chip_data_enable,
    output xclk,
    output xclk_n,

    /* tactile inputs -> switches */
    input [8:1] sw,
    input btn1,
    input pushbuttonLEFT,
    input pushbuttonRIGHT,
    input reset_button,
    input debug_select,

    /* leds out */
    output [3:0] leds,

    /* I2C */
    inout  scl,
    inout  sda
);

    //==========================================================================
    // The Tic Tac Toe game itself
    //==========================================================================
    wire [8:0]  current_x_q, current_o_q;
    wire [8:0]  next_x_d, next_x_q;
 
    // Instantiate the Tic Tac Toe game module
    tictactoe tictactoe_instance (
        .xin (current_x_q), 
        .oin (current_o_q), 
        .xout (next_x_d)
    );
 
    // Register the outputs so we break up the long critical path through the
    // VGA.  Since this game is played by humans we don't care if we delay the
    // result by 10ns.
    dff #(.WIDTH(9)) current_next_x (
        .clk (clk), 
        .d (next_x_d), 
        .q (next_x_q)
    );
    
    //=============================================================================
    // Input controls
    //=============================================================================
    wire       reset = reset_button;
    wire [8:0] new_input;
 
    // We don't have 9 switches, so concatenate the 8 we have and 1 button
    assign new_input = {btn1, sw[8:1]};

    // Storage for the values.
    dffre #(.WIDTH(9)) current_x_reg (
        .clk (clk), 
        .r   (reset),
        .en  (pushbuttonLEFT),
        .d   (new_input), 
        .q   (current_x_q)
    );
    dffre #(.WIDTH(9)) current_o_reg (
        .clk (clk), 
        .r   (reset),
        .en  (pushbuttonRIGHT),
        .d   (new_input), 
        .q   (current_o_q)
    );
    
    //==========================================================================
    // Display management -> do not touch!
    //==========================================================================
    /* blinking leds to show life */
    wire [26:0] led_counter;

    dff #(.WIDTH (27)) led_div (
        .clk (clk),
        .d (led_counter + 27'd1),
        .q (led_counter)
    );
    assign leds = led_counter[26:23];

    // These signals come from and go to the modules for generating the 
    // VGA timing (sync) signals
    wire [10:0] x;  // [0..1279]
    wire [9:0]  y;  // [0..1023]     

    // Create composite RGB signal
    wire [5:0]  vga_rgb;
         
    // VGA Colors
    wire [7:0]  r, g, b, v_r, v_g, v_b, r_cb, g_cb, b_cb;
 
    // DVI test pattern selection
    assign {r,g,b} = debug_select ? {r_cb,g_cb,b_cb} : {v_r,v_g,v_b};
 
    assign v_r = {4{vga_rgb [5:4]}};
    assign v_g = {4{vga_rgb [3:2]}};
    assign v_b = {4{vga_rgb [1:0]}};
 
    dvi_controller_top ctrl(
        .clk    (clk),
        .enable (1'b1),
        .reset  (reset),
        .r      (r),
        .g      (g),
        .b      (b),

        .chip_data_enable (chip_data_enable),
        .chip_hsync       (chip_hsync),
        .chip_vsync       (chip_vsync),
        .chip_reset       (chip_reset),
        .chip_data        (chip_data),
        .xclk             (xclk),
        .xclk_n           (xclk_n),
        .x                (x),
        .y                (y)
    );
 
    // Display Driver
    tictactoe_vga_driver fps_vga (
        .clk       (clk),
        .XPos      (x),
        .YPos      (y),
        .current_x (current_x_q),
        .current_o (current_o_q),
        .next_x    (next_x_q),
        .Valid     (1'b1),

        .vga_rgb (vga_rgb)
    );
 
    // I2C controller to configure dvi interface
    i2c_emulator i2c_controller(
        .clk (clk),
        .rst (reset),

        .scl (scl),
        .sda (sda)
    );

    // Color bars for testing the display
    color_bars tp (
        .x (x),
        .y (y),

        .r (r_cb[7:0]),
        .g (g_cb[7:0]),
        .b (b_cb[7:0])
    );
    
endmodule

