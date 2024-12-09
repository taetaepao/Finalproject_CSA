`timescale 1ns / 1ps
module ascii_test(
    input clk,
    input video_on,
    input [7:0] latched_value, // Latched value from the switches
    input [9:0] x, y,
    input btn_pressed,
    output reg [11:0] rgb
    );
    
    // signal declarations
    wire [10:0] rom_addr;           // 11-bit text ROM address
    reg [6:0] ascii_char;          // 7-bit ASCII character code
    wire [3:0] char_row;            // 4-bit row of ASCII character
    wire [2:0] bit_addr;            // column number of ROM data
    wire [7:0] rom_data;            // 8-bit row data from text ROM
    reg ascii_bit;     // ROM bit and status signal
    
    // instantiate ASCII ROM
    ascii_rom rom(.clk(clk), .addr(rom_addr), .data(rom_data));
    
     // Define a buffer to store last few inputted characters
    reg [7:0] char_buffer[0:3][0:15]; // 4 lines, each with 16 characters
    reg [2:0] color_buffer[0:3][0:15]; //
    reg [3:0] line_pos;                // Track the current line (0 to 3)
    reg [3:0] char_pos;           // Keeps track of current position in buffer
    
    // Add color cycling counter
    reg [2:0] color_index = 0;
    
    // Rainbow color palette (12-bit RGB colors)
    wire [11:0] rainbow_colors [0:7];
    assign rainbow_colors[0] = 12'hF00;  // Red
    assign rainbow_colors[1] = 12'hF80;  // Orange
    assign rainbow_colors[2] = 12'hFF0;  // Yellow
    assign rainbow_colors[3] = 12'h0F0;  // Green
    assign rainbow_colors[4] = 12'h0FF;  // Cyan
    assign rainbow_colors[5] = 12'h00F;  // Blue
    assign rainbow_colors[6] = 12'h80F;  // Purple
    assign rainbow_colors[7] = 12'hF0F;  // Pink

     
    // ASCII ROM interface
    assign rom_addr = {ascii_char, char_row};   // ROM address is ascii code + row

    //assign ascii_char = char_buffer[line_index][char_index];
    assign char_row = y[3:0];               // row number of ascii character rom
    assign bit_addr = x[2:0];               // column number of ascii character rom
    
    initial begin
        line_pos <= 0;
        char_pos <= 0;
    end
    
    // Update buffer and character position when button is pressed
    always @(posedge clk)
    begin
        if (btn_pressed) begin
            // Only update buffer if we're within bounds for a character
            if (latched_value <= 8'h7a) begin
                // Store valid character in the buffer at the current line and position
                char_buffer[line_pos][char_pos] <= latched_value;
                color_buffer[line_pos][char_pos] <= color_index;
                color_index = (color_index + 1)%7;
            end else begin
                // Store '-' for invalid character
                char_buffer[line_pos][char_pos] <= 8'h2D; 
            end

        // Debug: Monitor char_buffer content
        $display("char_buffer[%0d][%0d] = %h", line_pos, char_pos, char_buffer[line_pos][char_pos]);
        
            // Move to the next position in the current line
            if (char_pos < 15)
                char_pos <= char_pos + 1;
            else begin
                // If the current line is full, move to the next line
                char_pos <= 0;
                if (line_pos < 3)
                    line_pos <= line_pos + 1;
                else
                    line_pos <= 0;  // Reset to first line if all 4 lines are full
            end
        end
    end
    
    integer row_idx;  // Declare integer variables outside the always block
    integer char_idx;
    
   // ASCII ROM interface: Get the corresponding bit from ROM data
    always @* begin
        if (~video_on) begin
            rgb = 12'h000; // Blank screen if video is off
        end else begin
            // Get the row and column for the character
            row_idx = (y - 208) / 16;  // Row within the character block (0-3)
            char_idx = (x - 192) / 8;  // Character index within the line (0-15)

            if (row_idx < 4 && char_idx < 16) begin
                // Fetch the character from the buffer at (row_idx, char_idx)
                ascii_bit = rom_data[~bit_addr]; // Reverse bit order to match pixel position
              
            // Debug: Monitor bit_addr and ascii_bit
            $display("bit_addr = %b, ascii_bit = %b", bit_addr, ascii_bit);
                ascii_char = char_buffer[row_idx][char_idx];
            
                // Compare the current character from the buffer with the ROM data
                if (char_buffer[row_idx][char_idx] != 8'h2D) begin
                    // If the character is not '-'
                    if (ascii_bit) begin
                        rgb = rainbow_colors[color_buffer[row_idx][char_idx]];  // Blue for character pixel
                    end else
                        rgb = 12'hFFF;  // White background
                end else begin
                    // If character is '-'
                    rgb = 12'hFFF;  // White background
                end
            end else begin
                rgb = 12'h000;  // White background for out-of-bound areas
            end
        end
    end
   
endmodule