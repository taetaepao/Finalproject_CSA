`timescale 1ns / 1ps

module debounce(
    input clk,            // System clock
    input reset,          // Reset signal
    input btn_in,         // Raw button input
    output reg btn_out    // Debounced button output
    );

    // Parameters
    parameter DEBOUNCE_TIME = 500_000; // Adjust for debounce period (e.g., 10ms @ 50MHz)

    // Signal declarations
    reg [19:0] counter;    // Counter for debounce period
    reg btn_sync_0;        // First flip-flop for input synchronization
    reg btn_sync_1;        // Second flip-flop for input synchronization
    reg btn_stable;        // Stable debounced output

    always @(posedge clk or posedge reset)
    begin
        if (reset)
        begin
            counter <= 0;
            btn_sync_0 <= 0;
            btn_sync_1 <= 0;
            btn_stable <= 0;
            btn_out <= 0;
        end
        else
        begin
            // Synchronize raw button signal
            btn_sync_0 <= btn_in;
            btn_sync_1 <= btn_sync_0;

            // Increment counter if input is stable
            if (btn_sync_1 == btn_stable)
                counter <= 0;
            else if (counter < DEBOUNCE_TIME)
                counter <= counter + 1;

            // Update stable output after debounce period
            if (counter == DEBOUNCE_TIME)
            begin
                btn_stable <= btn_sync_1;
                btn_out <= btn_sync_1; // Debounced output
            end
        end
    end
endmodule 
