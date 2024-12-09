module uart_tx(
    input clk,
    input reset,
    input [7:0] data_in,  // 8-bit data to send
    input send_data,       // Trigger to send data (button press)
    output reg tx          // UART transmit pin
    );

    reg [3:0] state;
    reg [7:0] tx_data;
    reg [3:0] bit_count;
    reg [7:0] shift_reg;

    // UART baud rate control (9600bps)
    parameter baud_rate_divisor = 104; // Assume 100MHz clock, for 9600bps
    reg [15:0] baud_counter;

    // State machine for UART TX
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= 0;
            tx <= 1; // Idle state for UART is high
            baud_counter <= 0;
        end else begin
            baud_counter <= baud_counter + 1;
            if (baud_counter == baud_rate_divisor) begin
                baud_counter <= 0;

                case(state)
                    0: begin
                        if (send_data) begin
                            tx_data <= data_in;  // Load data to transmit
                            state <= 1;           // Move to start bit state
                            bit_count <= 0;       // Reset bit counter
                        end
                    end
                    1: begin
                        tx <= 0; // Start bit (low)
                        state <= 2;
                    end
                    2: begin
                        shift_reg <= tx_data;
                        state <= 3;
                    end
                    3: begin
                        tx <= shift_reg[0]; // Send LSB first
                        shift_reg <= shift_reg >> 1;
                        bit_count <= bit_count + 1;
                        if (bit_count == 8) begin
                            state <= 4; // End transmission (8 data bits)
                        end
                    end
                    4: begin
                        tx <= 1; // Stop bit (high)
                        state <= 0; // Back to idle
                    end
                endcase
            end
        end
    end
endmodule
