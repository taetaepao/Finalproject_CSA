module uart_rx(
    input clk,
    input reset,
    input rx,           // UART receive pin
    output reg [7:0] data_out,  // Received data
    output reg data_ready // Flag to indicate data received
    );

    reg [3:0] state;
    reg [7:0] shift_reg;
    reg [3:0] bit_count;

    // Baud rate control for 9600bps (same as TX)
    parameter baud_rate_divisor = 104;
    reg [15:0] baud_counter;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= 0;
            data_ready <= 0;
            baud_counter <= 0;
            shift_reg <= 0;
            bit_count <= 0;
        end else begin
            baud_counter <= baud_counter + 1;
            if (baud_counter == baud_rate_divisor) begin
                baud_counter <= 0;

                case(state)
                    0: begin
                        if (~rx) state <= 1; // Wait for start bit (low)
                    end
                    1: begin
                        shift_reg <= {rx, shift_reg[7:1]}; // Shift in bits
                        bit_count <= bit_count + 1;
                        if (bit_count == 7) begin
                            state <= 2; // End of data
                        end
                    end
                    2: begin
                        data_out <= shift_reg;  // Store received data
                        data_ready <= 1;        // Indicate that data is ready
                        state <= 0;             // Return to idle state
                    end
                endcase
            end
        end
    end
endmodule
