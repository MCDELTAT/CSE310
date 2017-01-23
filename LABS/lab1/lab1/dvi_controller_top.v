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
* Module: dvi_controller_top.v
* Project: DVI
* Description: Top module for the DVI component
*******************************************************************************/

`include "dvi_defines.v"

module dvi_controller_top(
    input clk,
    input enable,
    input reset,
    input [`COLOR_WIDTH-1:0] r,
    input [`COLOR_WIDTH-1:0] g,
    input [`COLOR_WIDTH-1:0] b,
    output wire chip_data_enable,
    output wire chip_hsync,
    output wire chip_vsync,
    output wire chip_reset,
    output wire [11:0] chip_data,
    output wire [`log2NUM_COLS-1:0] x,
    output wire [`log2NUM_ROWS-1:0] y,
    output wire xclk,
    output wire xclk_n
);

    /* Keep DVI chip out of reset */
    assign chip_reset = 1;
 
    /* DVI clock; inverse of the main clock */
    assign xclk = ~clk;
    assign xclk_n = ~xclk;
 
    /* Sync Generator */
    wire valid_data;
    sync_generators gen_sync(
        .clk        (clk),
        .reset      (reset),
        .enable     (enable),
 
        .hsync      (chip_hsync),
        .vsync      (chip_vsync),
        .valid_data (valid_data),
        .x          (x),
        .y          (y)
    );
 
    /* Data Flops */
    chip_data_parser make_chip_data(
        .clk        (clk),
        .r          (r),
        .g          (g),
        .b          (b),
        .valid      (valid_data),

        .chip_data  (chip_data),
        .chip_data_enable (chip_data_enable)
    );

    /* Output to file */
    // synthesis translate_off
    integer file, naccum;
    reg [`COLOR_WIDTH*3-1:0] accum;
    initial begin
        // Open the output file. GENERATES_PPM (a viewer is auto-launched)
        file = $fopen("display.ppm", "wb");
        $display("DVI display: image display.ppm opened for output.");
        forever begin
            // Wait for vsync to deassert (it is active low)
            @(posedge chip_vsync);
            naccum = 0;
            // Write the header for this image
            $display("[%0t] DVI display: started new frame.", $time);
            $fwrite(file, "P6 %d %d 255\n", `NUM_COLS, `NUM_ROWS);
            // Grab pixels until the frame ends. Verilog only allows us to
            // output 32 bits at a time, so use accumulation to ensure it.
            while (chip_vsync) begin
                @(negedge clk);
                if (valid_data && x < `NUM_COLS) begin
                    if (naccum == 0) begin
                        accum = {b, g, r};
                    end else if (naccum == 1) begin
                        $fwrite(file, "%u",
                                {r, accum});
                        accum = {8'b0, b, g};
                    end else if (naccum == 2) begin
                        $fwrite(file, "%u",
                                {g, r, accum[`COLOR_WIDTH*2-1:0]});
                        accum = {16'b0, b};
                    end else if (naccum == 3) begin
                        $fwrite(file, "%u",
                                {b, g, r, accum[`COLOR_WIDTH-1:0]});
                        $fflush(file);
                        naccum = -1;
                    end
                    naccum = naccum + 1;
                end
                else if (x == `NUM_COLS) begin
                    // Flush the file buffer once per line
                    $fclose(file);
                    file = $fopen("display.ppm", "ab");
                end
            end
        end
    end
    // synthesis translate_on
 
endmodule
