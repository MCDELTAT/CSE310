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
//******************************************************************************
//
// debouncer.v 
//
// debounces the input 
//
//******************************************************************************

module debouncer(
    input clk,
    input reset,
    input in,
    output reg out
); 
    // WIDTH determines how long to wait for the bouncing to stop.
    parameter WIDTH = 20;

    reg counter_reset;

    wire [WIDTH-1:0] counter_out;

    dffr #(WIDTH) counter(
        .clk(clk),
        .d(counter_out+1'b1),
        .q(counter_out),
        .r(counter_reset || reset)
    );

    // *** DEBOUNCING FSM ***
    `define LOW 2'b00
    `define WAIT_HIGH 2'b01
    `define HIGH 2'b11
    `define WAIT_LOW 2'b10

    // State register
    reg [1:0] next_state_d;
    wire [1:0] current_state_q;

    dffr #(2) state(
        .clk(clk),
        .d(next_state_d),
        .q(current_state_q),
        .r(reset)
    );

    // Next state logic
    always @(*)
        case (current_state_q)

            // LOW: We are currently low and are outputing a 0 unless the in
            //  goes high. Then we want to go and output a high ignoring any
            //  changes until the counter resets.
            //  Notice that we are keeping the counter reset.

            `LOW: begin
                out = 1'b0;
                counter_reset = 1'b1;
                if (in)
                    next_state_d = `WAIT_HIGH;
                else
                    next_state_d = `LOW;
            end

            // WAIT_HIGH: We are waiting to go high after a low-to-high
            //  transition. Here we are ignoring the input (and keeping the
            //  output high) until the timer expires. Then we will go and wait
            //  for a high-to-low transition.

            `WAIT_HIGH : begin
                out = 1'b1;
                counter_reset = in;
                if (&counter_out)
                    next_state_d = `HIGH;
                else
                    next_state_d = `WAIT_HIGH;
            end

            // HIGH: This is the same as LOW but with the output being high.
            //  I.e., we are waiting for a high-to-low transition.

            `HIGH : begin
                out = 1'b1;
                counter_reset = 1'b1;
                if (~in)
                    next_state_d = `WAIT_LOW;
                else
                    next_state_d = `HIGH;
            end

            // WAIT_LOW: Here we got a high-to-low transition so we output a 0
            //  and ignore the input until the counter expires, then we go back
            //  to waiting for a low-to-high transition.

            `WAIT_LOW : begin
                out = 1'b0;
                counter_reset = ~in;
                if (counter_out)
                    next_state_d = `LOW;
                else
                    next_state_d = `WAIT_LOW;
            end

            // We have the default case in here because we will start up with
            //  all FFs being 0, so we need to get into our initial LOW (0001)
            //  state.

            default : begin
                out = 1'b0;
                counter_reset = 1'b1;
                next_state_d = `LOW;
            end
        endcase

endmodule
