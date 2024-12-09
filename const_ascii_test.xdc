# Clock signal
set_property PACKAGE_PIN W5 [get_ports clk]							
set_property IOSTANDARD LVCMOS33 [get_ports clk]
create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports clk]

# Reset Button
set_property PACKAGE_PIN R2 [get_ports reset]						
set_property IOSTANDARD LVCMOS33 [get_ports reset]

# Button Input (btn_u18)
set_property PACKAGE_PIN U18 [get_ports btn_u18]						
set_property IOSTANDARD LVCMOS33 [get_ports btn_u18]

# Button W19 Input (for transmitting data)
set_property PACKAGE_PIN W19 [get_ports btn_W19]						
set_property IOSTANDARD LVCMOS33 [get_ports btn_W19]

# UART
set_property PACKAGE_PIN J1 [get_ports tx]						
set_property IOSTANDARD LVCMOS33 [get_ports tx]
set_property PACKAGE_PIN J2 [get_ports rx]						
set_property IOSTANDARD LVCMOS33 [get_ports rx]


# Switches (8-bit input for ASCII value)
set_property PACKAGE_PIN V17 [get_ports {switches[0]}]				
set_property IOSTANDARD LVCMOS33 [get_ports {switches[0]}]
set_property PACKAGE_PIN V16 [get_ports {switches[1]}]				
set_property IOSTANDARD LVCMOS33 [get_ports {switches[1]}]
set_property PACKAGE_PIN W16 [get_ports {switches[2]}]				
set_property IOSTANDARD LVCMOS33 [get_ports {switches[2]}]
set_property PACKAGE_PIN W17 [get_ports {switches[3]}]				
set_property IOSTANDARD LVCMOS33 [get_ports {switches[3]}]
set_property PACKAGE_PIN W15 [get_ports {switches[4]}]				
set_property IOSTANDARD LVCMOS33 [get_ports {switches[4]}]
set_property PACKAGE_PIN V15 [get_ports {switches[5]}]				
set_property IOSTANDARD LVCMOS33 [get_ports {switches[5]}]
set_property PACKAGE_PIN W14 [get_ports {switches[6]}]				
set_property IOSTANDARD LVCMOS33 [get_ports {switches[6]}]
set_property PACKAGE_PIN W13 [get_ports {switches[7]}]				
set_property IOSTANDARD LVCMOS33 [get_ports {switches[7]}]

# VGA Connector
set_property PACKAGE_PIN G19 [get_ports {rgb[11]}]				
set_property IOSTANDARD LVCMOS33 [get_ports {rgb[11]}]
set_property PACKAGE_PIN H19 [get_ports {rgb[10]}]				
set_property IOSTANDARD LVCMOS33 [get_ports {rgb[10]}]
set_property PACKAGE_PIN J19 [get_ports {rgb[9]}]				
set_property IOSTANDARD LVCMOS33 [get_ports {rgb[9]}]
set_property PACKAGE_PIN N19 [get_ports {rgb[8]}]				
set_property IOSTANDARD LVCMOS33 [get_ports {rgb[8]}]
set_property PACKAGE_PIN J17 [get_ports {rgb[7]}]				
set_property IOSTANDARD LVCMOS33 [get_ports {rgb[7]}]
set_property PACKAGE_PIN H17 [get_ports {rgb[6]}]				
set_property IOSTANDARD LVCMOS33 [get_ports {rgb[6]}]
set_property PACKAGE_PIN G17 [get_ports {rgb[5]}]				
set_property IOSTANDARD LVCMOS33 [get_ports {rgb[5]}]
set_property PACKAGE_PIN D17 [get_ports {rgb[4]}]				
set_property IOSTANDARD LVCMOS33 [get_ports {rgb[4]}]
set_property PACKAGE_PIN N18 [get_ports {rgb[3]}]				
set_property IOSTANDARD LVCMOS33 [get_ports {rgb[3]}]
set_property PACKAGE_PIN L18 [get_ports {rgb[2]}]				
set_property IOSTANDARD LVCMOS33 [get_ports {rgb[2]}]
set_property PACKAGE_PIN K18 [get_ports {rgb[1]}]				
set_property IOSTANDARD LVCMOS33 [get_ports {rgb[1]}]
set_property PACKAGE_PIN J18 [get_ports {rgb[0]}]				
set_property IOSTANDARD LVCMOS33 [get_ports {rgb[0]}]
set_property PACKAGE_PIN P19 [get_ports hsync]						
set_property IOSTANDARD LVCMOS33 [get_ports hsync]
set_property PACKAGE_PIN R19 [get_ports vsync]						
set_property IOSTANDARD LVCMOS33 [get_ports vsync]
