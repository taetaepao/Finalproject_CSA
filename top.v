`timescale 1ns / 1ps

module top(
    input clk,          // 100MHz on Basys 3
    input reset,        // btnC on Basys 3
    input btn_u18,       // Button U18 input for triggering
    input btn_W19,      // Button W19 input for transmitting data
    input [7:0] switches, // 8-bit switch input for ASCII value
    output hsync,       // to VGA connector
    output vsync,       // to VGA connector
    output [11:0] rgb,   // to DAC, to VGA connector
    output tx,          // UART TX
    input rx            // UART RX
    );
    
    // signals
    wire [9:0] w_x, w_y;
    wire w_video_on, w_p_tick;
    reg [11:0] rgb_reg;
    wire [11:0] rgb_next;
    
    wire btn_debounced_u18, btn_debounced_W19; // Debounced button signal
    wire btn_latched_u18, btn_latched_W19;     // Clean pulse output from button
    reg [7:0] latched_value; // ASCII value based on switches
    reg [7:0] tx_data;       // Data to send via UART (when btn_W19 is pressed)
    
    // UART Transmit Controller
    uart_tx uart_tx_inst(
        .clk(clk),
        .reset(reset),
        .data_in(tx_data),   // Send the current switch value
        .send_data(btn_latched_W19),  // Trigger to send data when btn_W19 is pressed
        .tx(tx)
    );
    
    // UART Receive Controller
    wire [7:0] received_data;
    wire data_ready;
    
    uart_rx uart_rx_inst(
        .clk(clk),
        .reset(reset),
        .rx(rx),
        .data_out(received_data),
        .data_ready(data_ready)
    );
    
    // VGA Controller
    vga_controller vga(
        .clk_100MHz(clk), 
        .reset(reset), 
        .hsync(hsync), 
        .vsync(vsync),
        .video_on(w_video_on), 
        .p_tick(w_p_tick), 
        .x(w_x), 
        .y(w_y)
        );
        
    // Text Generation Circuit
    ascii_test at(
        .clk(clk), 
        .video_on(w_video_on), 
        .x(w_x), 
        .y(w_y), 
        .rgb(rgb_next),
        .latched_value (latched_value), 
        .btn_pressed(btn_or_uart)
        );  // Pass switch value and button press
    
     // Button debounce
    debounce debounce_inst_u18(
        .clk(clk),
        .reset(reset),
        .btn_in(btn_u18),
        .btn_out(btn_debounced_u18)
    );
    
    debounce debounce_inst_W19(
        .clk(clk),
        .reset(reset),
        .btn_in(btn_W19),
        .btn_out(btn_debounced_W19)
    );
    
     // Button pulse generation
    button button_u18(
        .clk(clk),
        .reset(reset),
        .btn_in(btn_debounced_u18),
        .btn_out(btn_latched_u18)
    );
    
    button button_W19(
        .clk(clk),
        .reset(reset),
        .btn_in(btn_debounced_W19),
        .btn_out(btn_latched_W19)
    );
    
     // Store the current switch data into tx_data when btn_W19 is pressed
    always @(posedge clk or posedge reset)
    begin
        if (reset)
            tx_data <= 8'b0;   // Reset transmission data
        else if (btn_latched_W19)
            tx_data <= switches;  // Send the current switch value when btn_W19 is pressed
    end

       // Signal to select data to store in latched_value
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            latched_value <= 8'b0;  // Reset latched_value
        end else if (data_ready) begin
            latched_value <= received_data;  // Store received data when ready
        end else if (btn_latched_u18) begin
            latched_value <= switches;  // Store switch data when button is pressed
        end
    end

 // Mux to combine btn_latched_u18 or data_ready (automatically trigger btn_latched_u18)
    assign btn_or_uart = (data_ready) ? 1'b1 : btn_latched_u18; // btn_latched_u18 or UART data ready
    
    // rgb buffer
    always @(posedge clk)
        if(w_p_tick)
            rgb_reg <= rgb_next;
            
    // output
    assign rgb = rgb_reg;
      
endmodule
