set_property BITSTREAM.GENERAL.COMPRESS TRUE [current_design]
set_property BITSTREAM.CONFIG.CONFIGRATE 66 [current_design]
set_property BITSTREAM.CONFIG.SPI_32BIT_ADDR NO [current_design]
set_property BITSTREAM.CONFIG.SPI_BUSWIDTH 4 [current_design]
set_property BITSTREAM.CONFIG.M1PIN PULLNONE [current_design]
set_property BITSTREAM.CONFIG.M2PIN PULLNONE [current_design]
set_property BITSTREAM.CONFIG.M0PIN PULLNONE [current_design]
set_property BITSTREAM.CONFIG.USR_ACCESS TIMESTAMP [current_design]
set_property BITSTREAM.CONFIG.UNUSEDPIN PULLNONE [current_design]
set_property CONFIG_VOLTAGE 1.8 [current_design]
set_property CFGBVS GND [current_design]


set_property -dict {PACKAGE_PIN T14 IOSTANDARD LVCMOS18} [get_ports sys_clock]
set_property -dict {PACKAGE_PIN N18 IOSTANDARD LVCMOS18} [get_ports KEY0]
set_property -dict {PACKAGE_PIN P18 IOSTANDARD LVCMOS18} [get_ports KEY1]
set_property -dict {PACKAGE_PIN K18 IOSTANDARD LVCMOS18} [get_ports LED_MOD]
set_property -dict {PACKAGE_PIN U17 IOSTANDARD LVCMOS18} [get_ports {LED_GREEN[0]}]
set_property -dict {PACKAGE_PIN T17 IOSTANDARD LVCMOS18} [get_ports {LED_YELLOW[0]}]
set_property -dict {PACKAGE_PIN V9 IOSTANDARD LVCMOS18} [get_ports UART_txd]
set_property -dict {PACKAGE_PIN U9 IOSTANDARD LVCMOS18} [get_ports UART_rxd]
set_property -dict {PACKAGE_PIN U6 IOSTANDARD LVCMOS33} [get_ports {BF4M_EN[0]}]
set_property -dict {PACKAGE_PIN M15 IOSTANDARD LVCMOS18} [get_ports {EN_GTPWR[0]}]
set_property -dict {PACKAGE_PIN L4 IOSTANDARD LVCMOS33} [get_ports CAM1_I2C_scl_io]
set_property -dict {PACKAGE_PIN L3 IOSTANDARD LVCMOS33} [get_ports CAM1_I2C_sda_io]
set_property -dict {PACKAGE_PIN K6 IOSTANDARD LVCMOS33} [get_ports CAM2_I2C_scl_io]
set_property -dict {PACKAGE_PIN K5 IOSTANDARD LVCMOS33} [get_ports CAM2_I2C_sda_io]
set_property -dict {PACKAGE_PIN K3 IOSTANDARD LVCMOS33} [get_ports {CAM1_PWUP[0]}]
set_property -dict {PACKAGE_PIN J5 IOSTANDARD LVCMOS33} [get_ports {CAM2_PWUP[0]}]

set_property INTERNAL_VREF 0.6 [get_iobanks 15]

set_property -dict {PACKAGE_PIN E16 IOSTANDARD LVDS_25} [get_ports MIPI_CSI_CAM1_clk_hs_p]
set_property -dict {PACKAGE_PIN F18 IOSTANDARD HSUL_12} [get_ports MIPI_CSI_CAM1_clk_lp_p]
set_property -dict {PACKAGE_PIN E17 IOSTANDARD HSUL_12} [get_ports MIPI_CSI_CAM1_clk_lp_n]
set_property -dict {PACKAGE_PIN B16 IOSTANDARD LVDS_25} [get_ports {MIPI_CSI_CAM1_data_hs_p[0]}]
set_property -dict {PACKAGE_PIN C17 IOSTANDARD LVDS_25} [get_ports {MIPI_CSI_CAM1_data_hs_p[1]}]
set_property -dict {PACKAGE_PIN B17 IOSTANDARD HSUL_12} [get_ports {MIPI_CSI_CAM1_data_lp_p[0]}]
set_property -dict {PACKAGE_PIN B15 IOSTANDARD HSUL_12} [get_ports {MIPI_CSI_CAM1_data_lp_n[0]}]
set_property -dict {PACKAGE_PIN D18 IOSTANDARD HSUL_12} [get_ports {MIPI_CSI_CAM1_data_lp_p[1]}]
set_property -dict {PACKAGE_PIN C16 IOSTANDARD HSUL_12} [get_ports {MIPI_CSI_CAM1_data_lp_n[1]}]

set_property -dict {PACKAGE_PIN E13 IOSTANDARD LVDS_25} [get_ports MIPI_CSI_CAM2_clk_hs_p]
set_property -dict {PACKAGE_PIN A9 IOSTANDARD HSUL_12} [get_ports MIPI_CSI_CAM2_clk_lp_p]
set_property -dict {PACKAGE_PIN B11 IOSTANDARD HSUL_12} [get_ports MIPI_CSI_CAM2_clk_lp_n]
set_property -dict {PACKAGE_PIN D11 IOSTANDARD LVDS_25} [get_ports {MIPI_CSI_CAM2_data_hs_p[0]}]
set_property -dict {PACKAGE_PIN D8 IOSTANDARD LVDS_25} [get_ports {MIPI_CSI_CAM2_data_hs_p[1]}]
set_property -dict {PACKAGE_PIN D9 IOSTANDARD HSUL_12} [get_ports {MIPI_CSI_CAM2_data_lp_p[0]}]
set_property -dict {PACKAGE_PIN G16 IOSTANDARD HSUL_12} [get_ports {MIPI_CSI_CAM2_data_lp_n[0]}]
set_property -dict {PACKAGE_PIN C9 IOSTANDARD HSUL_12} [get_ports {MIPI_CSI_CAM2_data_lp_p[1]}]
set_property -dict {PACKAGE_PIN C11 IOSTANDARD HSUL_12} [get_ports {MIPI_CSI_CAM2_data_lp_n[1]}]
set_property PACKAGE_PIN B6 [get_ports GT_REFCLK_clk_p]
set_property PACKAGE_PIN H2 [get_ports {GT_SERIAL_TX_txp[0]}]



set_property C_CLK_INPUT_FREQ_HZ 300000000 [get_debug_cores dbg_hub]
set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
connect_debug_port dbg_hub/clk [get_nets clk]