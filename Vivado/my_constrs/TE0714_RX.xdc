set_property BITSTREAM.GENERAL.COMPRESS TRUE [current_design]
set_property BITSTREAM.CONFIG.CONFIGRATE 66 [current_design]
set_property BITSTREAM.CONFIG.SPI_32BIT_ADDR NO [current_design]
set_property BITSTREAM.CONFIG.SPI_BUSWIDTH 4 [current_design]
set_property BITSTREAM.CONFIG.M1PIN PULLNONE [current_design]
set_property BITSTREAM.CONFIG.M2PIN PULLNONE [current_design]
set_property BITSTREAM.CONFIG.M0PIN PULLNONE [current_design]
set_property BITSTREAM.CONFIG.USR_ACCESS TIMESTAMP [current_design]
set_property CONFIG_VOLTAGE 1.8 [current_design]
set_property CFGBVS GND [current_design]

set_property -dict {PACKAGE_PIN T14 IOSTANDARD LVCMOS18} [get_ports sys_clock]
set_property -dict {PACKAGE_PIN P18 IOSTANDARD LVCMOS18} [get_ports KEY0]
set_property -dict {PACKAGE_PIN T17 IOSTANDARD LVCMOS18} [get_ports KEY1]
set_property -dict {PACKAGE_PIN U10 IOSTANDARD LVCMOS18} [get_ports GPIO_O]
set_property -dict {PACKAGE_PIN V16 IOSTANDARD LVCMOS18} [get_ports {LED_YELLOW[0]}]
set_property -dict {PACKAGE_PIN V17 IOSTANDARD LVCMOS18} [get_ports {LED_GREEN[0]}]
set_property -dict {PACKAGE_PIN M15 IOSTANDARD LVCMOS18} [get_ports {EN_GTPWR[0]}]
set_property -dict {PACKAGE_PIN M6 IOSTANDARD LVCMOS33} [get_ports {PCIe_CLK_nREQ[0]}]
set_property -dict {PACKAGE_PIN R1 IOSTANDARD LVCMOS33} [get_ports PCIe_nRST]
set_property -dict {PACKAGE_PIN K18 IOSTANDARD LVCMOS18} [get_ports LED_MOD]
set_property PACKAGE_PIN B6 [get_ports {MGT_REFCLK_clk_p[0]}]
set_property PACKAGE_PIN E3 [get_ports {MGT_SERIAL_RX_rxn[0]}]
set_property PACKAGE_PIN D6 [get_ports {PCIe_REFCLK_clk_p[0]}]
set_property PACKAGE_PIN A3 [get_ports {PCIe_SERIAL_rxn[0]}]

set_false_path -from [get_ports KEY0]
set_input_delay 0.000 [get_ports KEY0]
set_false_path -from [get_ports KEY1]
set_input_delay 0 [get_ports KEY1]
set_false_path -from [get_ports PCIe_nRST]
set_input_delay 0 [get_ports PCIe_nRST]
set_false_path -to [get_ports {LED_YELLOW[0]}]
set_output_delay 0.000 [get_ports {LED_YELLOW[0]}]
set_false_path -to [get_ports {LED_GREEN[0]}]
set_output_delay 0.000 [get_ports {LED_GREEN[0]}]
set_false_path -to [get_ports LED_MOD]
set_output_delay 0 [get_ports LED_MOD]
set_false_path -to [get_ports {EN_GTPWR[0]}]
set_output_delay 0.000 [get_ports {EN_GTPWR[0]}]
set_false_path -to [get_ports {PCIe_CLK_nREQ[0]}]
set_output_delay 0 [get_ports {PCIe_CLK_nREQ[0]}]

