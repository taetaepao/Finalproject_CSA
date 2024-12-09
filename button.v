`timescale 1ns / 1ps

module button(
    input clk,            // System clock
    input reset,          // Reset signal
    input btn_in,         // Raw button input
    output reg btn_out    // Cleaned pulse output
    );

    // Signal declarations
    reg btn_state;        // Stores the current button state
    reg btn_last_state;   // Tracks the last button state

    always @(posedge clk or posedge reset)
    begin
        if (reset)
        begin
            btn_state <= 1'b0;
            btn_last_state <= 1'b0;
            btn_out <= 1'b0;
        end
        else
        begin
            btn_last_state <= btn_state;   // Store last state
            btn_state <= btn_in;          // Update current state

            // Generate pulse on rising edge of button press
            btn_out <= (btn_state == 1'b1 && btn_last_state == 1'b0) ? 1'b1 : 1'b0;
        end
    end
endmodule 