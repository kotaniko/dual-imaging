
################################################################
# This is a generated script based on design: design_1
#
# Though there are limitations about the generated script,
# the main purpose of this utility is to make learning
# IP Integrator Tcl commands easier.
################################################################

namespace eval _tcl {
proc get_script_folder {} {
   set script_path [file normalize [info script]]
   set script_folder [file dirname $script_path]
   return $script_folder
}
}
variable script_folder
set script_folder [_tcl::get_script_folder]

################################################################
# Check if script is running in correct Vivado version.
################################################################
set scripts_vivado_version 2021.2
set current_vivado_version [version -short]

if { [string first $scripts_vivado_version $current_vivado_version] == -1 } {
   puts ""
   catch {common::send_gid_msg -ssname BD::TCL -id 2041 -severity "ERROR" "This script was generated using Vivado <$scripts_vivado_version> and is being run in <$current_vivado_version> of Vivado. Please run the script in Vivado <$scripts_vivado_version> then open the design in Vivado <$current_vivado_version>. Upgrade the design by running \"Tools => Report => Report IP Status...\", then run write_bd_tcl to create an updated script."}

   return 1
}

################################################################
# START
################################################################

# To test this script, run the following commands from Vivado Tcl console:
# source design_1_script.tcl


# The design that will be created by this Tcl script contains the following 
# module references:
# aurora_8b10b_reset, blink, stream_mod, stream_mod

# Please add the sources of those modules before sourcing this Tcl script.

# If there is no project opened, this script will create a
# project, but make sure you do not have an existing project
# <./myproj/project_1.xpr> in the current working folder.

set list_projs [get_projects -quiet]
if { $list_projs eq "" } {
   create_project project_1 myproj -part xc7a50tcsg325-2
}


# CHANGE DESIGN NAME HERE
variable design_name
set design_name design_1

# If you do not already have an existing IP Integrator design open,
# you can create a design using the following command:
#    create_bd_design $design_name

# Creating design if needed
set errMsg ""
set nRet 0

set cur_design [current_bd_design -quiet]
set list_cells [get_bd_cells -quiet]

if { ${design_name} eq "" } {
   # USE CASES:
   #    1) Design_name not set

   set errMsg "Please set the variable <design_name> to a non-empty value."
   set nRet 1

} elseif { ${cur_design} ne "" && ${list_cells} eq "" } {
   # USE CASES:
   #    2): Current design opened AND is empty AND names same.
   #    3): Current design opened AND is empty AND names diff; design_name NOT in project.
   #    4): Current design opened AND is empty AND names diff; design_name exists in project.

   if { $cur_design ne $design_name } {
      common::send_gid_msg -ssname BD::TCL -id 2001 -severity "INFO" "Changing value of <design_name> from <$design_name> to <$cur_design> since current design is empty."
      set design_name [get_property NAME $cur_design]
   }
   common::send_gid_msg -ssname BD::TCL -id 2002 -severity "INFO" "Constructing design in IPI design <$cur_design>..."

} elseif { ${cur_design} ne "" && $list_cells ne "" && $cur_design eq $design_name } {
   # USE CASES:
   #    5) Current design opened AND has components AND same names.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 1
} elseif { [get_files -quiet ${design_name}.bd] ne "" } {
   # USE CASES: 
   #    6) Current opened design, has components, but diff names, design_name exists in project.
   #    7) No opened design, design_name exists in project.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 2

} else {
   # USE CASES:
   #    8) No opened design, design_name not in project.
   #    9) Current opened design, has components, but diff names, design_name not in project.

   common::send_gid_msg -ssname BD::TCL -id 2003 -severity "INFO" "Currently there is no design <$design_name> in project, so creating one..."

   create_bd_design $design_name

   common::send_gid_msg -ssname BD::TCL -id 2004 -severity "INFO" "Making design <$design_name> as current_bd_design."
   current_bd_design $design_name

}

common::send_gid_msg -ssname BD::TCL -id 2005 -severity "INFO" "Currently the variable <design_name> is equal to \"$design_name\"."

if { $nRet != 0 } {
   catch {common::send_gid_msg -ssname BD::TCL -id 2006 -severity "ERROR" $errMsg}
   return $nRet
}

set bCheckIPsPassed 1
##################################################################
# CHECK IPs
##################################################################
set bCheckIPs 1
if { $bCheckIPs == 1 } {
   set list_check_ips "\ 
xilinx.com:ip:aurora_8b10b:11.1\
xilinx.com:ip:axi_gpio:2.0\
xilinx.com:ip:axi_iic:2.1\
xilinx.com:ip:axi_timer:2.0\
xilinx.com:ip:axi_uartlite:2.0\
xilinx.com:ip:axis_subset_converter:1.1\
xilinx.com:ip:clk_wiz:6.0\
xilinx.com:ip:ila:6.2\
xilinx.com:ip:mdm:3.2\
xilinx.com:ip:microblaze:11.0\
xilinx.com:ip:mipi_csi2_rx_subsystem:5.1\
xilinx.com:ip:proc_sys_reset:5.0\
xilinx.com:ip:system_ila:1.1\
xilinx.com:ip:util_vector_logic:2.0\
xilinx.com:ip:v_demosaic:1.1\
xilinx.com:ip:v_gamma_lut:1.1\
xilinx.com:ip:vio:3.0\
xilinx.com:ip:xlconstant:1.1\
xilinx.com:ip:xlslice:1.0\
xilinx.com:ip:lmb_bram_if_cntlr:4.0\
xilinx.com:ip:lmb_v10:3.0\
xilinx.com:ip:blk_mem_gen:8.4\
"

   set list_ips_missing ""
   common::send_gid_msg -ssname BD::TCL -id 2011 -severity "INFO" "Checking if the following IPs exist in the project's IP catalog: $list_check_ips ."

   foreach ip_vlnv $list_check_ips {
      set ip_obj [get_ipdefs -all $ip_vlnv]
      if { $ip_obj eq "" } {
         lappend list_ips_missing $ip_vlnv
      }
   }

   if { $list_ips_missing ne "" } {
      catch {common::send_gid_msg -ssname BD::TCL -id 2012 -severity "ERROR" "The following IPs are not found in the IP Catalog:\n  $list_ips_missing\n\nResolution: Please add the repository containing the IP(s) to the project." }
      set bCheckIPsPassed 0
   }

}

##################################################################
# CHECK Modules
##################################################################
set bCheckModules 1
if { $bCheckModules == 1 } {
   set list_check_mods "\ 
aurora_8b10b_reset\
blink\
stream_mod\
stream_mod\
"

   set list_mods_missing ""
   common::send_gid_msg -ssname BD::TCL -id 2020 -severity "INFO" "Checking if the following modules exist in the project's sources: $list_check_mods ."

   foreach mod_vlnv $list_check_mods {
      if { [can_resolve_reference $mod_vlnv] == 0 } {
         lappend list_mods_missing $mod_vlnv
      }
   }

   if { $list_mods_missing ne "" } {
      catch {common::send_gid_msg -ssname BD::TCL -id 2021 -severity "ERROR" "The following module(s) are not found in the project: $list_mods_missing" }
      common::send_gid_msg -ssname BD::TCL -id 2022 -severity "INFO" "Please add source files for the missing module(s) above."
      set bCheckIPsPassed 0
   }
}

if { $bCheckIPsPassed != 1 } {
  common::send_gid_msg -ssname BD::TCL -id 2023 -severity "WARNING" "Will not continue with creation of design due to the error(s) above."
  return 3
}

##################################################################
# DESIGN PROCs
##################################################################


# Hierarchical cell: microblaze_0_local_memory
proc create_hier_cell_microblaze_0_local_memory { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_microblaze_0_local_memory() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode MirroredMaster -vlnv xilinx.com:interface:lmb_rtl:1.0 DLMB

  create_bd_intf_pin -mode MirroredMaster -vlnv xilinx.com:interface:lmb_rtl:1.0 ILMB


  # Create pins
  create_bd_pin -dir I -type clk LMB_Clk
  create_bd_pin -dir I -type rst SYS_Rst

  # Create instance: dlmb_bram_if_cntlr, and set properties
  set dlmb_bram_if_cntlr [ create_bd_cell -type ip -vlnv xilinx.com:ip:lmb_bram_if_cntlr:4.0 dlmb_bram_if_cntlr ]
  set_property -dict [ list \
   CONFIG.C_ECC {0} \
 ] $dlmb_bram_if_cntlr

  # Create instance: dlmb_v10, and set properties
  set dlmb_v10 [ create_bd_cell -type ip -vlnv xilinx.com:ip:lmb_v10:3.0 dlmb_v10 ]

  # Create instance: ilmb_bram_if_cntlr, and set properties
  set ilmb_bram_if_cntlr [ create_bd_cell -type ip -vlnv xilinx.com:ip:lmb_bram_if_cntlr:4.0 ilmb_bram_if_cntlr ]
  set_property -dict [ list \
   CONFIG.C_ECC {0} \
 ] $ilmb_bram_if_cntlr

  # Create instance: ilmb_v10, and set properties
  set ilmb_v10 [ create_bd_cell -type ip -vlnv xilinx.com:ip:lmb_v10:3.0 ilmb_v10 ]

  # Create instance: lmb_bram, and set properties
  set lmb_bram [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.4 lmb_bram ]
  set_property -dict [ list \
   CONFIG.Memory_Type {True_Dual_Port_RAM} \
   CONFIG.use_bram_block {BRAM_Controller} \
 ] $lmb_bram

  # Create interface connections
  connect_bd_intf_net -intf_net microblaze_1_dlmb [get_bd_intf_pins DLMB] [get_bd_intf_pins dlmb_v10/LMB_M]
  connect_bd_intf_net -intf_net microblaze_1_dlmb_bus [get_bd_intf_pins dlmb_bram_if_cntlr/SLMB] [get_bd_intf_pins dlmb_v10/LMB_Sl_0]
  connect_bd_intf_net -intf_net microblaze_1_dlmb_cntlr [get_bd_intf_pins dlmb_bram_if_cntlr/BRAM_PORT] [get_bd_intf_pins lmb_bram/BRAM_PORTA]
  connect_bd_intf_net -intf_net microblaze_1_ilmb [get_bd_intf_pins ILMB] [get_bd_intf_pins ilmb_v10/LMB_M]
  connect_bd_intf_net -intf_net microblaze_1_ilmb_bus [get_bd_intf_pins ilmb_bram_if_cntlr/SLMB] [get_bd_intf_pins ilmb_v10/LMB_Sl_0]
  connect_bd_intf_net -intf_net microblaze_1_ilmb_cntlr [get_bd_intf_pins ilmb_bram_if_cntlr/BRAM_PORT] [get_bd_intf_pins lmb_bram/BRAM_PORTB]

  # Create port connections
  connect_bd_net -net SYS_Rst_1 [get_bd_pins SYS_Rst] [get_bd_pins dlmb_bram_if_cntlr/LMB_Rst] [get_bd_pins dlmb_v10/SYS_Rst] [get_bd_pins ilmb_bram_if_cntlr/LMB_Rst] [get_bd_pins ilmb_v10/SYS_Rst]
  connect_bd_net -net microblaze_1_Clk [get_bd_pins LMB_Clk] [get_bd_pins dlmb_bram_if_cntlr/LMB_Clk] [get_bd_pins dlmb_v10/LMB_Clk] [get_bd_pins ilmb_bram_if_cntlr/LMB_Clk] [get_bd_pins ilmb_v10/LMB_Clk]

  # Restore current instance
  current_bd_instance $oldCurInst
}


# Procedure to create entire design; Provide argument to make
# procedure reusable. If parentCell is "", will use root.
proc create_root_design { parentCell } {

  variable script_folder
  variable design_name

  if { $parentCell eq "" } {
     set parentCell [get_bd_cells /]
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj


  # Create interface ports
  set CAM1_I2C [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:iic_rtl:1.0 CAM1_I2C ]

  set CAM2_I2C [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:iic_rtl:1.0 CAM2_I2C ]

  set GT_REFCLK [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 GT_REFCLK ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {125000000} \
   ] $GT_REFCLK

  set GT_SERIAL_TX [ create_bd_intf_port -mode Master -vlnv xilinx.com:display_aurora:GT_Serial_Transceiver_Pins_TX_rtl:1.0 GT_SERIAL_TX ]

  set MIPI_CSI_CAM1 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:mipi_phy_rtl:1.0 MIPI_CSI_CAM1 ]

  set MIPI_CSI_CAM2 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:mipi_phy_rtl:1.0 MIPI_CSI_CAM2 ]

  set UART [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:uart_rtl:1.0 UART ]


  # Create ports
  set BF4M_EN [ create_bd_port -dir O -from 0 -to 0 BF4M_EN ]
  set CAM1_PWUP [ create_bd_port -dir O -from 0 -to 0 -type rst CAM1_PWUP ]
  set CAM2_PWUP [ create_bd_port -dir O -from 0 -to 0 -type rst CAM2_PWUP ]
  set EN_GTPWR [ create_bd_port -dir O -from 0 -to 0 EN_GTPWR ]
  set KEY0 [ create_bd_port -dir I -type rst KEY0 ]
  set KEY1 [ create_bd_port -dir I -type rst KEY1 ]
  set LED_GREEN [ create_bd_port -dir O -from 0 -to 0 LED_GREEN ]
  set LED_MOD [ create_bd_port -dir O LED_MOD ]
  set LED_YELLOW [ create_bd_port -dir O -from 0 -to 0 LED_YELLOW ]
  set sys_clock [ create_bd_port -dir I -type clk -freq_hz 25000000 sys_clock ]
  set_property -dict [ list \
   CONFIG.PHASE {0.0} \
 ] $sys_clock

  # Create instance: aurora_8b10b_0, and set properties
  set aurora_8b10b_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:aurora_8b10b:11.1 aurora_8b10b_0 ]
  set_property -dict [ list \
   CONFIG.Backchannel_mode {Timer} \
   CONFIG.C_DRP_IF {true} \
   CONFIG.C_LANE_WIDTH {2} \
   CONFIG.C_LINE_RATE {3.125} \
   CONFIG.C_REFCLK_FREQUENCY {125.000} \
   CONFIG.Dataflow_Config {TX-only_Simplex} \
   CONFIG.Interface_Mode {Framing} \
   CONFIG.RX_PPM_OFFSET {0} \
   CONFIG.SINGLEEND_INITCLK {true} \
   CONFIG.SupportLevel {1} \
   CONFIG.TransceiverControl {false} \
 ] $aurora_8b10b_0

  # Create instance: aurora_8b10b_reset_0, and set properties
  set block_name aurora_8b10b_reset
  set block_cell_name aurora_8b10b_reset_0
  if { [catch {set aurora_8b10b_reset_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $aurora_8b10b_reset_0 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: axi_gpio_0, and set properties
  set axi_gpio_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_gpio_0 ]
  set_property -dict [ list \
   CONFIG.C_ALL_INPUTS {0} \
   CONFIG.C_ALL_OUTPUTS {1} \
   CONFIG.C_GPIO_WIDTH {32} \
 ] $axi_gpio_0

  # Create instance: axi_iic_0, and set properties
  set axi_iic_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_iic:2.1 axi_iic_0 ]

  # Create instance: axi_iic_1, and set properties
  set axi_iic_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_iic:2.1 axi_iic_1 ]

  # Create instance: axi_interconnect_0, and set properties
  set axi_interconnect_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_interconnect_0 ]
  set_property -dict [ list \
   CONFIG.NUM_MI {9} \
   CONFIG.S00_HAS_DATA_FIFO {0} \
   CONFIG.S00_HAS_REGSLICE {0} \
   CONFIG.STRATEGY {1} \
 ] $axi_interconnect_0

  # Create instance: axi_timer_0, and set properties
  set axi_timer_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_timer:2.0 axi_timer_0 ]
  set_property -dict [ list \
   CONFIG.enable_timer2 {0} \
 ] $axi_timer_0

  # Create instance: axi_uartlite_0, and set properties
  set axi_uartlite_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_uartlite:2.0 axi_uartlite_0 ]
  set_property -dict [ list \
   CONFIG.C_BAUDRATE {115200} \
 ] $axi_uartlite_0

  # Create instance: axis_interconnect_0, and set properties
  set axis_interconnect_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_interconnect:2.1 axis_interconnect_0 ]
  set_property -dict [ list \
   CONFIG.M00_FIFO_DEPTH {64} \
   CONFIG.NUM_MI {1} \
   CONFIG.NUM_SI {2} \
   CONFIG.S00_FIFO_DEPTH {2048} \
   CONFIG.S01_FIFO_DEPTH {2048} \
 ] $axis_interconnect_0

  # Create instance: axis_subset_converter_0, and set properties
  set axis_subset_converter_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_subset_converter:1.1 axis_subset_converter_0 ]
  set_property -dict [ list \
   CONFIG.M_HAS_TKEEP {1} \
   CONFIG.M_HAS_TLAST {1} \
   CONFIG.M_HAS_TREADY {1} \
   CONFIG.M_HAS_TSTRB {0} \
   CONFIG.M_TDATA_NUM_BYTES {2} \
   CONFIG.M_TDEST_WIDTH {0} \
   CONFIG.M_TID_WIDTH {0} \
   CONFIG.M_TUSER_WIDTH {1} \
   CONFIG.S_HAS_TKEEP {1} \
   CONFIG.S_HAS_TLAST {1} \
   CONFIG.S_TDATA_NUM_BYTES {4} \
   CONFIG.S_TUSER_WIDTH {1} \
   CONFIG.TDATA_REMAP {tdata[19:15],tdata[9:4],tdata[29:25]} \
   CONFIG.TDEST_REMAP {1'b0} \
   CONFIG.TID_REMAP {1'b0} \
   CONFIG.TKEEP_REMAP {tkeep[1:0]} \
   CONFIG.TLAST_REMAP {tlast[0]} \
   CONFIG.TSTRB_REMAP {1'b0} \
   CONFIG.TUSER_REMAP {tuser[0:0]} \
 ] $axis_subset_converter_0

  # Create instance: axis_subset_converter_1, and set properties
  set axis_subset_converter_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_subset_converter:1.1 axis_subset_converter_1 ]
  set_property -dict [ list \
   CONFIG.M_HAS_TKEEP {1} \
   CONFIG.M_HAS_TLAST {1} \
   CONFIG.M_HAS_TREADY {1} \
   CONFIG.M_HAS_TSTRB {0} \
   CONFIG.M_TDATA_NUM_BYTES {2} \
   CONFIG.M_TDEST_WIDTH {0} \
   CONFIG.M_TID_WIDTH {0} \
   CONFIG.M_TUSER_WIDTH {1} \
   CONFIG.S_HAS_TKEEP {1} \
   CONFIG.S_HAS_TLAST {1} \
   CONFIG.S_TDATA_NUM_BYTES {4} \
   CONFIG.S_TUSER_WIDTH {1} \
   CONFIG.TDATA_REMAP {tdata[19:15],tdata[9:4],tdata[29:25]} \
   CONFIG.TDEST_REMAP {1'b0} \
   CONFIG.TID_REMAP {1'b0} \
   CONFIG.TKEEP_REMAP {tkeep[1:0]} \
   CONFIG.TLAST_REMAP {tlast[0]} \
   CONFIG.TSTRB_REMAP {1'b0} \
   CONFIG.TUSER_REMAP {tuser[0:0]} \
 ] $axis_subset_converter_1

  # Create instance: blink_0, and set properties
  set block_name blink
  set block_cell_name blink_0
  if { [catch {set blink_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $blink_0 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: clk_wiz, and set properties
  set clk_wiz [ create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz:6.0 clk_wiz ]
  set_property -dict [ list \
   CONFIG.CLKIN1_JITTER_PS {400.0} \
   CONFIG.CLKOUT1_JITTER {226.965} \
   CONFIG.CLKOUT1_PHASE_ERROR {237.727} \
   CONFIG.CLKOUT2_JITTER {206.578} \
   CONFIG.CLKOUT2_PHASE_ERROR {237.727} \
   CONFIG.CLKOUT2_REQUESTED_OUT_FREQ {200} \
   CONFIG.CLKOUT2_USED {true} \
   CONFIG.CLK_IN1_BOARD_INTERFACE {sys_clock} \
   CONFIG.MMCM_CLKFBOUT_MULT_F {40.000} \
   CONFIG.MMCM_CLKIN1_PERIOD {40.000} \
   CONFIG.MMCM_CLKIN2_PERIOD {10.0} \
   CONFIG.MMCM_CLKOUT1_DIVIDE {5} \
   CONFIG.NUM_OUT_CLKS {2} \
   CONFIG.USE_BOARD_FLOW {true} \
   CONFIG.USE_LOCKED {true} \
   CONFIG.USE_RESET {false} \
 ] $clk_wiz

  # Create instance: ila_0, and set properties
  set ila_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:ila:6.2 ila_0 ]
  set_property -dict [ list \
   CONFIG.C_ENABLE_ILA_AXI_MON {false} \
   CONFIG.C_MONITOR_TYPE {Native} \
   CONFIG.C_NUM_OF_PROBES {10} \
   CONFIG.C_PROBE7_WIDTH {2} \
   CONFIG.C_SLOT_0_AXI_PROTOCOL {AXI4S} \
 ] $ila_0

  # Create instance: ila_1, and set properties
  set ila_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:ila:6.2 ila_1 ]
  set_property -dict [ list \
   CONFIG.C_ENABLE_ILA_AXI_MON {false} \
   CONFIG.C_MONITOR_TYPE {Native} \
   CONFIG.C_NUM_OF_PROBES {10} \
   CONFIG.C_PROBE7_WIDTH {2} \
   CONFIG.C_SLOT_0_AXI_PROTOCOL {AXI4S} \
 ] $ila_1

  # Create instance: mdm_0, and set properties
  set mdm_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:mdm:3.2 mdm_0 ]
  set_property -dict [ list \
   CONFIG.C_ADDR_SIZE {32} \
   CONFIG.C_MB_DBG_PORTS {1} \
   CONFIG.C_M_AXI_ADDR_WIDTH {32} \
 ] $mdm_0

  # Create instance: microblaze_0, and set properties
  set microblaze_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:microblaze:11.0 microblaze_0 ]
  set_property -dict [ list \
   CONFIG.C_ADDR_TAG_BITS {0} \
   CONFIG.C_AREA_OPTIMIZED {1} \
   CONFIG.C_CACHE_BYTE_SIZE {4096} \
   CONFIG.C_DCACHE_ADDR_TAG {0} \
   CONFIG.C_DCACHE_BYTE_SIZE {4096} \
   CONFIG.C_DCACHE_HIGHADDR {0x000000003fffffff} \
   CONFIG.C_DCACHE_USE_WRITEBACK {0} \
   CONFIG.C_DCACHE_VICTIMS {0} \
   CONFIG.C_DEBUG_ENABLED {1} \
   CONFIG.C_DIV_ZERO_EXCEPTION {0} \
   CONFIG.C_D_AXI {1} \
   CONFIG.C_D_LMB {1} \
   CONFIG.C_ICACHE_HIGHADDR {0x000000003fffffff} \
   CONFIG.C_ICACHE_LINE_LEN {4} \
   CONFIG.C_ICACHE_STREAMS {0} \
   CONFIG.C_ICACHE_VICTIMS {0} \
   CONFIG.C_ILL_OPCODE_EXCEPTION {0} \
   CONFIG.C_I_LMB {1} \
   CONFIG.C_MMU_DTLB_SIZE {2} \
   CONFIG.C_MMU_ITLB_SIZE {1} \
   CONFIG.C_MMU_ZONES {2} \
   CONFIG.C_M_AXI_D_BUS_EXCEPTION {0} \
   CONFIG.C_M_AXI_I_BUS_EXCEPTION {0} \
   CONFIG.C_NUMBER_OF_PC_BRK {0} \
   CONFIG.C_OPCODE_0x0_ILLEGAL {0} \
   CONFIG.C_PVR {0} \
   CONFIG.C_UNALIGNED_EXCEPTIONS {0} \
   CONFIG.C_USE_BARREL {0} \
   CONFIG.C_USE_DCACHE {0} \
   CONFIG.C_USE_DIV {0} \
   CONFIG.C_USE_HW_MUL {0} \
   CONFIG.C_USE_ICACHE {0} \
   CONFIG.C_USE_INTERRUPT {0} \
   CONFIG.C_USE_MMU {0} \
   CONFIG.C_USE_MSR_INSTR {0} \
   CONFIG.C_USE_PCMP_INSTR {0} \
   CONFIG.C_USE_REORDER_INSTR {0} \
   CONFIG.C_USE_STACK_PROTECTION {1} \
   CONFIG.G_TEMPLATE_LIST {1} \
   CONFIG.G_USE_EXCEPTIONS {0} \
 ] $microblaze_0

  # Create instance: microblaze_0_local_memory
  create_hier_cell_microblaze_0_local_memory [current_bd_instance .] microblaze_0_local_memory

  # Create instance: mipi_csi2_rx_subsyst_0, and set properties
  set mipi_csi2_rx_subsyst_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:mipi_csi2_rx_subsystem:5.1 mipi_csi2_rx_subsyst_0 ]
  set_property -dict [ list \
   CONFIG.CMN_INC_VFB {true} \
   CONFIG.CMN_NUM_LANES {2} \
   CONFIG.CMN_NUM_PIXELS {1} \
   CONFIG.CMN_PXL_FORMAT {RAW10} \
   CONFIG.CMN_VC {0} \
   CONFIG.CSI_CONTROLLER_REG_IF {false} \
   CONFIG.CSI_EMB_NON_IMG {false} \
   CONFIG.C_CAL_MODE {FIXED} \
   CONFIG.C_CSI_EN_CRC {false} \
   CONFIG.C_DPHY_LANES {2} \
   CONFIG.C_EN_CLK300M {false} \
   CONFIG.C_EN_EXT_TAP {true} \
   CONFIG.C_HS_LINE_RATE {800} \
   CONFIG.C_HS_SETTLE_NS {147} \
   CONFIG.C_SHARE_IDLYCTRL {false} \
   CONFIG.DPY_EN_REG_IF {false} \
   CONFIG.DPY_LINE_RATE {800} \
   CONFIG.VFB_TU_WIDTH {1} \
 ] $mipi_csi2_rx_subsyst_0

  # Create instance: mipi_csi2_rx_subsyst_1, and set properties
  set mipi_csi2_rx_subsyst_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:mipi_csi2_rx_subsystem:5.1 mipi_csi2_rx_subsyst_1 ]
  set_property -dict [ list \
   CONFIG.CMN_INC_VFB {true} \
   CONFIG.CMN_NUM_LANES {2} \
   CONFIG.CMN_NUM_PIXELS {1} \
   CONFIG.CMN_PXL_FORMAT {RAW10} \
   CONFIG.CMN_VC {0} \
   CONFIG.CSI_CONTROLLER_REG_IF {false} \
   CONFIG.CSI_EMB_NON_IMG {false} \
   CONFIG.C_CAL_MODE {FIXED} \
   CONFIG.C_CSI_EN_CRC {false} \
   CONFIG.C_DPHY_LANES {2} \
   CONFIG.C_EN_CLK300M {false} \
   CONFIG.C_EN_EXT_TAP {true} \
   CONFIG.C_HS_LINE_RATE {800} \
   CONFIG.C_HS_SETTLE_NS {147} \
   CONFIG.C_IDLY_TAP {1} \
   CONFIG.C_SHARE_IDLYCTRL {true} \
   CONFIG.DPY_EN_REG_IF {false} \
   CONFIG.DPY_LINE_RATE {800} \
   CONFIG.VFB_TU_WIDTH {1} \
 ] $mipi_csi2_rx_subsyst_1

  # Create instance: proc_sys_reset_0, and set properties
  set proc_sys_reset_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_0 ]

  # Create instance: proc_sys_reset_1, and set properties
  set proc_sys_reset_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_1 ]

  # Create instance: stream_mod_0, and set properties
  set block_name stream_mod
  set block_cell_name stream_mod_0
  if { [catch {set stream_mod_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $stream_mod_0 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: stream_mod_1, and set properties
  set block_name stream_mod
  set block_cell_name stream_mod_1
  if { [catch {set stream_mod_1 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $stream_mod_1 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
   CONFIG.BIT5 {"1"} \
 ] $stream_mod_1

  # Create instance: system_ila_0, and set properties
  set system_ila_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:system_ila:1.1 system_ila_0 ]
  set_property -dict [ list \
   CONFIG.C_NUM_MONITOR_SLOTS {2} \
   CONFIG.C_SLOT {1} \
   CONFIG.C_SLOT_0_INTF_TYPE {xilinx.com:interface:axis_rtl:1.0} \
   CONFIG.C_SLOT_1_INTF_TYPE {xilinx.com:interface:axis_rtl:1.0} \
 ] $system_ila_0

  # Create instance: util_vector_logic_0, and set properties
  set util_vector_logic_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 util_vector_logic_0 ]
  set_property -dict [ list \
   CONFIG.C_OPERATION {not} \
   CONFIG.C_SIZE {1} \
   CONFIG.LOGO_FILE {data/sym_notgate.png} \
 ] $util_vector_logic_0

  # Create instance: util_vector_logic_1, and set properties
  set util_vector_logic_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 util_vector_logic_1 ]
  set_property -dict [ list \
   CONFIG.C_OPERATION {and} \
   CONFIG.C_SIZE {1} \
   CONFIG.LOGO_FILE {data/sym_andgate.png} \
 ] $util_vector_logic_1

  # Create instance: util_vector_logic_2, and set properties
  set util_vector_logic_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 util_vector_logic_2 ]
  set_property -dict [ list \
   CONFIG.C_OPERATION {not} \
   CONFIG.C_SIZE {1} \
   CONFIG.LOGO_FILE {data/sym_notgate.png} \
 ] $util_vector_logic_2

  # Create instance: v_demosaic_0, and set properties
  set v_demosaic_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:v_demosaic:1.1 v_demosaic_0 ]
  set_property -dict [ list \
   CONFIG.ALGORITHM {0} \
   CONFIG.MAX_COLS {1920} \
   CONFIG.MAX_DATA_WIDTH {10} \
   CONFIG.MAX_ROWS {1080} \
 ] $v_demosaic_0

  # Create instance: v_demosaic_1, and set properties
  set v_demosaic_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:v_demosaic:1.1 v_demosaic_1 ]
  set_property -dict [ list \
   CONFIG.ALGORITHM {0} \
   CONFIG.MAX_COLS {1920} \
   CONFIG.MAX_DATA_WIDTH {10} \
   CONFIG.MAX_ROWS {1080} \
 ] $v_demosaic_1

  # Create instance: v_gamma_lut_0, and set properties
  set v_gamma_lut_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:v_gamma_lut:1.1 v_gamma_lut_0 ]
  set_property -dict [ list \
   CONFIG.MAX_COLS {1920} \
   CONFIG.MAX_DATA_WIDTH {10} \
   CONFIG.MAX_ROWS {1080} \
 ] $v_gamma_lut_0

  # Create instance: v_gamma_lut_1, and set properties
  set v_gamma_lut_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:v_gamma_lut:1.1 v_gamma_lut_1 ]
  set_property -dict [ list \
   CONFIG.MAX_COLS {1920} \
   CONFIG.MAX_DATA_WIDTH {10} \
   CONFIG.MAX_ROWS {1080} \
 ] $v_gamma_lut_1

  # Create instance: vio_0, and set properties
  set vio_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:vio:3.0 vio_0 ]
  set_property -dict [ list \
   CONFIG.C_EN_PROBE_IN_ACTIVITY {0} \
   CONFIG.C_NUM_PROBE_IN {0} \
   CONFIG.C_NUM_PROBE_OUT {4} \
   CONFIG.C_PROBE_OUT0_INIT_VAL {0x01} \
   CONFIG.C_PROBE_OUT0_WIDTH {5} \
   CONFIG.C_PROBE_OUT1_INIT_VAL {0x01} \
   CONFIG.C_PROBE_OUT1_WIDTH {5} \
   CONFIG.C_PROBE_OUT2_INIT_VAL {0x10} \
   CONFIG.C_PROBE_OUT2_WIDTH {5} \
   CONFIG.C_PROBE_OUT3_INIT_VAL {0x01} \
   CONFIG.C_PROBE_OUT3_WIDTH {5} \
 ] $vio_0

  # Create instance: xlconstant_0, and set properties
  set xlconstant_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_0 ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {1} \
 ] $xlconstant_0

  # Create instance: xlslice_0, and set properties
  set xlslice_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_0 ]
  set_property -dict [ list \
   CONFIG.DIN_WIDTH {32} \
 ] $xlslice_0

  # Create instance: xlslice_1, and set properties
  set xlslice_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_1 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {1} \
   CONFIG.DIN_TO {1} \
   CONFIG.DIN_WIDTH {32} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_1

  # Create instance: xlslice_2, and set properties
  set xlslice_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_2 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {2} \
   CONFIG.DIN_TO {2} \
   CONFIG.DIN_WIDTH {32} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_2

  # Create instance: xlslice_3, and set properties
  set xlslice_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_3 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {3} \
   CONFIG.DIN_TO {3} \
   CONFIG.DIN_WIDTH {32} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_3

  # Create interface connections
  connect_bd_intf_net -intf_net GT_DIFF_REFCLK1_1 [get_bd_intf_ports GT_REFCLK] [get_bd_intf_pins aurora_8b10b_0/GT_DIFF_REFCLK1]
  connect_bd_intf_net -intf_net MIPI_CSI_CAM1_1 [get_bd_intf_ports MIPI_CSI_CAM1] [get_bd_intf_pins mipi_csi2_rx_subsyst_0/mipi_phy_if]
  connect_bd_intf_net -intf_net MIPI_CSI_CAM2_1 [get_bd_intf_ports MIPI_CSI_CAM2] [get_bd_intf_pins mipi_csi2_rx_subsyst_1/mipi_phy_if]
  connect_bd_intf_net -intf_net aurora_8b10b_0_GT_SERIAL_TX [get_bd_intf_ports GT_SERIAL_TX] [get_bd_intf_pins aurora_8b10b_0/GT_SERIAL_TX]
  connect_bd_intf_net -intf_net axi_iic_0_IIC [get_bd_intf_ports CAM1_I2C] [get_bd_intf_pins axi_iic_0/IIC]
  connect_bd_intf_net -intf_net axi_iic_1_IIC [get_bd_intf_ports CAM2_I2C] [get_bd_intf_pins axi_iic_1/IIC]
  connect_bd_intf_net -intf_net axi_interconnect_0_M00_AXI [get_bd_intf_pins axi_iic_0/S_AXI] [get_bd_intf_pins axi_interconnect_0/M00_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_0_M01_AXI [get_bd_intf_pins axi_iic_1/S_AXI] [get_bd_intf_pins axi_interconnect_0/M01_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_0_M02_AXI [get_bd_intf_pins axi_interconnect_0/M02_AXI] [get_bd_intf_pins v_demosaic_0/s_axi_CTRL]
  connect_bd_intf_net -intf_net axi_interconnect_0_M03_AXI [get_bd_intf_pins axi_interconnect_0/M03_AXI] [get_bd_intf_pins v_demosaic_1/s_axi_CTRL]
  connect_bd_intf_net -intf_net axi_interconnect_0_M04_AXI [get_bd_intf_pins axi_interconnect_0/M04_AXI] [get_bd_intf_pins v_gamma_lut_0/s_axi_CTRL]
  connect_bd_intf_net -intf_net axi_interconnect_0_M05_AXI [get_bd_intf_pins axi_interconnect_0/M05_AXI] [get_bd_intf_pins v_gamma_lut_1/s_axi_CTRL]
  connect_bd_intf_net -intf_net axi_interconnect_0_M06_AXI [get_bd_intf_pins axi_interconnect_0/M06_AXI] [get_bd_intf_pins axi_uartlite_0/S_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_0_M07_AXI [get_bd_intf_pins axi_gpio_0/S_AXI] [get_bd_intf_pins axi_interconnect_0/M07_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_0_M08_AXI [get_bd_intf_pins axi_interconnect_0/M08_AXI] [get_bd_intf_pins axi_timer_0/S_AXI]
  connect_bd_intf_net -intf_net axi_uartlite_0_UART [get_bd_intf_ports UART] [get_bd_intf_pins axi_uartlite_0/UART]
  connect_bd_intf_net -intf_net axis_broadcaster_0_M00_AXIS [get_bd_intf_pins axis_interconnect_0/S00_AXIS] [get_bd_intf_pins stream_mod_0/M_AXIS]
connect_bd_intf_net -intf_net [get_bd_intf_nets axis_broadcaster_0_M00_AXIS] [get_bd_intf_pins stream_mod_0/M_AXIS] [get_bd_intf_pins system_ila_0/SLOT_0_AXIS]
  connect_bd_intf_net -intf_net axis_broadcaster_0_M01_AXIS [get_bd_intf_pins axis_interconnect_0/S01_AXIS] [get_bd_intf_pins stream_mod_1/M_AXIS]
connect_bd_intf_net -intf_net [get_bd_intf_nets axis_broadcaster_0_M01_AXIS] [get_bd_intf_pins stream_mod_1/M_AXIS] [get_bd_intf_pins system_ila_0/SLOT_1_AXIS]
  connect_bd_intf_net -intf_net axis_interconnect_0_M00_AXIS [get_bd_intf_pins aurora_8b10b_0/USER_DATA_S_AXI_TX] [get_bd_intf_pins axis_interconnect_0/M00_AXIS]
  connect_bd_intf_net -intf_net axis_subset_converter_0_M_AXIS [get_bd_intf_pins axis_subset_converter_0/M_AXIS] [get_bd_intf_pins stream_mod_0/S_AXIS]
  connect_bd_intf_net -intf_net axis_subset_converter_1_M_AXIS [get_bd_intf_pins axis_subset_converter_1/M_AXIS] [get_bd_intf_pins stream_mod_1/S_AXIS]
  connect_bd_intf_net -intf_net mdm_0_MBDEBUG_0 [get_bd_intf_pins mdm_0/MBDEBUG_0] [get_bd_intf_pins microblaze_0/DEBUG]
  connect_bd_intf_net -intf_net microblaze_1_M_AXI_DP [get_bd_intf_pins axi_interconnect_0/S00_AXI] [get_bd_intf_pins microblaze_0/M_AXI_DP]
  connect_bd_intf_net -intf_net microblaze_1_dlmb_1 [get_bd_intf_pins microblaze_0/DLMB] [get_bd_intf_pins microblaze_0_local_memory/DLMB]
  connect_bd_intf_net -intf_net microblaze_1_ilmb_1 [get_bd_intf_pins microblaze_0/ILMB] [get_bd_intf_pins microblaze_0_local_memory/ILMB]
  connect_bd_intf_net -intf_net mipi_csi2_rx_subsyst_0_video_out [get_bd_intf_pins mipi_csi2_rx_subsyst_0/video_out] [get_bd_intf_pins v_demosaic_0/s_axis_video]
  connect_bd_intf_net -intf_net mipi_csi2_rx_subsyst_1_video_out [get_bd_intf_pins mipi_csi2_rx_subsyst_1/video_out] [get_bd_intf_pins v_demosaic_1/s_axis_video]
  connect_bd_intf_net -intf_net v_demosaic_0_m_axis_video [get_bd_intf_pins v_demosaic_0/m_axis_video] [get_bd_intf_pins v_gamma_lut_0/s_axis_video]
  connect_bd_intf_net -intf_net v_demosaic_1_m_axis_video [get_bd_intf_pins v_demosaic_1/m_axis_video] [get_bd_intf_pins v_gamma_lut_1/s_axis_video]
  connect_bd_intf_net -intf_net v_gamma_lut_0_m_axis_video [get_bd_intf_pins axis_subset_converter_0/S_AXIS] [get_bd_intf_pins v_gamma_lut_0/m_axis_video]
  connect_bd_intf_net -intf_net v_gamma_lut_1_m_axis_video [get_bd_intf_pins axis_subset_converter_1/S_AXIS] [get_bd_intf_pins v_gamma_lut_1/m_axis_video]

  # Create port connections
  connect_bd_net -net ACLK_1 [get_bd_pins aurora_8b10b_0/user_clk_out] [get_bd_pins axis_interconnect_0/ACLK] [get_bd_pins axis_interconnect_0/M00_AXIS_ACLK]
  connect_bd_net -net ARESETN_1 [get_bd_ports BF4M_EN] [get_bd_pins axi_interconnect_0/ARESETN] [get_bd_pins axi_interconnect_0/S00_ARESETN] [get_bd_pins axis_subset_converter_0/aresetn] [get_bd_pins axis_subset_converter_1/aresetn] [get_bd_pins proc_sys_reset_0/interconnect_aresetn]
  connect_bd_net -net KEY0_1 [get_bd_ports KEY0] [get_bd_pins proc_sys_reset_0/ext_reset_in]
  connect_bd_net -net KEY1_1 [get_bd_ports KEY1] [get_bd_pins proc_sys_reset_1/ext_reset_in]
  connect_bd_net -net M00_AXIS_ARESETN_1 [get_bd_pins axis_interconnect_0/ARESETN] [get_bd_pins axis_interconnect_0/M00_AXIS_ARESETN] [get_bd_pins util_vector_logic_0/Res]
  connect_bd_net -net aurora_8b10b_0_sys_reset_out [get_bd_pins aurora_8b10b_0/sys_reset_out] [get_bd_pins util_vector_logic_0/Op1]
  connect_bd_net -net aurora_8b10b_0_tx_channel_up [get_bd_pins aurora_8b10b_0/tx_channel_up] [get_bd_pins util_vector_logic_1/Op1]
  connect_bd_net -net aurora_8b10b_0_tx_lane_up [get_bd_pins aurora_8b10b_0/tx_lane_up] [get_bd_pins util_vector_logic_1/Op2]
  connect_bd_net -net aurora_8b10b_reset_0_gt_reset [get_bd_pins aurora_8b10b_0/gt_reset] [get_bd_pins aurora_8b10b_reset_0/gt_reset]
  connect_bd_net -net aurora_8b10b_reset_0_system_reset [get_bd_pins aurora_8b10b_0/tx_system_reset] [get_bd_pins aurora_8b10b_reset_0/system_reset]
  connect_bd_net -net axi_gpio_0_gpio_io_o [get_bd_pins axi_gpio_0/gpio_io_o] [get_bd_pins xlslice_0/Din] [get_bd_pins xlslice_1/Din] [get_bd_pins xlslice_2/Din] [get_bd_pins xlslice_3/Din]
  connect_bd_net -net blink_0_LED [get_bd_ports LED_MOD] [get_bd_pins blink_0/LED]
  connect_bd_net -net clk_wiz_clk_out2 [get_bd_pins clk_wiz/clk_out2] [get_bd_pins mipi_csi2_rx_subsyst_0/dphy_clk_200M] [get_bd_pins mipi_csi2_rx_subsyst_1/dphy_clk_200M]
  connect_bd_net -net clk_wiz_locked [get_bd_pins clk_wiz/locked] [get_bd_pins proc_sys_reset_0/dcm_locked] [get_bd_pins proc_sys_reset_1/dcm_locked]
  connect_bd_net -net mdm_1_debug_sys_rst [get_bd_pins mdm_0/Debug_SYS_Rst] [get_bd_pins proc_sys_reset_0/mb_debug_sys_rst] [get_bd_pins proc_sys_reset_1/mb_debug_sys_rst]
  connect_bd_net -net microblaze_1_Clk [get_bd_pins aurora_8b10b_0/drpclk_in] [get_bd_pins aurora_8b10b_0/init_clk_in] [get_bd_pins aurora_8b10b_reset_0/clock] [get_bd_pins axi_gpio_0/s_axi_aclk] [get_bd_pins axi_iic_0/s_axi_aclk] [get_bd_pins axi_iic_1/s_axi_aclk] [get_bd_pins axi_interconnect_0/ACLK] [get_bd_pins axi_interconnect_0/M00_ACLK] [get_bd_pins axi_interconnect_0/M01_ACLK] [get_bd_pins axi_interconnect_0/M02_ACLK] [get_bd_pins axi_interconnect_0/M03_ACLK] [get_bd_pins axi_interconnect_0/M04_ACLK] [get_bd_pins axi_interconnect_0/M05_ACLK] [get_bd_pins axi_interconnect_0/M06_ACLK] [get_bd_pins axi_interconnect_0/M07_ACLK] [get_bd_pins axi_interconnect_0/M08_ACLK] [get_bd_pins axi_interconnect_0/S00_ACLK] [get_bd_pins axi_timer_0/s_axi_aclk] [get_bd_pins axi_uartlite_0/s_axi_aclk] [get_bd_pins axis_interconnect_0/S00_AXIS_ACLK] [get_bd_pins axis_interconnect_0/S01_AXIS_ACLK] [get_bd_pins axis_subset_converter_0/aclk] [get_bd_pins axis_subset_converter_1/aclk] [get_bd_pins blink_0/CLK] [get_bd_pins clk_wiz/clk_out1] [get_bd_pins ila_0/clk] [get_bd_pins ila_1/clk] [get_bd_pins microblaze_0/Clk] [get_bd_pins microblaze_0_local_memory/LMB_Clk] [get_bd_pins mipi_csi2_rx_subsyst_0/video_aclk] [get_bd_pins mipi_csi2_rx_subsyst_1/video_aclk] [get_bd_pins proc_sys_reset_0/slowest_sync_clk] [get_bd_pins proc_sys_reset_1/slowest_sync_clk] [get_bd_pins stream_mod_0/axis_aclk] [get_bd_pins stream_mod_1/axis_aclk] [get_bd_pins system_ila_0/clk] [get_bd_pins v_demosaic_0/ap_clk] [get_bd_pins v_demosaic_1/ap_clk] [get_bd_pins v_gamma_lut_0/ap_clk] [get_bd_pins v_gamma_lut_1/ap_clk] [get_bd_pins vio_0/clk]
  connect_bd_net -net mipi_csi2_rx_subsyst_0_cl_stopstate_intr [get_bd_pins ila_0/probe3] [get_bd_pins mipi_csi2_rx_subsyst_0/cl_stopstate_intr]
  connect_bd_net -net mipi_csi2_rx_subsyst_0_crc_status_intr [get_bd_pins ila_0/probe6] [get_bd_pins mipi_csi2_rx_subsyst_0/crc_status_intr]
  connect_bd_net -net mipi_csi2_rx_subsyst_0_ctrl_dis_in_prgs [get_bd_pins ila_0/probe0] [get_bd_pins mipi_csi2_rx_subsyst_0/ctrl_dis_in_prgs]
  connect_bd_net -net mipi_csi2_rx_subsyst_0_dl0_stopstate_intr [get_bd_pins ila_0/probe4] [get_bd_pins mipi_csi2_rx_subsyst_0/dl0_stopstate_intr]
  connect_bd_net -net mipi_csi2_rx_subsyst_0_dl1_stopstate_intr [get_bd_pins ila_0/probe5] [get_bd_pins mipi_csi2_rx_subsyst_0/dl1_stopstate_intr]
  connect_bd_net -net mipi_csi2_rx_subsyst_0_ecc_status_intr [get_bd_pins ila_0/probe7] [get_bd_pins mipi_csi2_rx_subsyst_0/ecc_status_intr]
  connect_bd_net -net mipi_csi2_rx_subsyst_0_errsoths_intr [get_bd_pins ila_0/probe2] [get_bd_pins mipi_csi2_rx_subsyst_0/errsoths_intr]
  connect_bd_net -net mipi_csi2_rx_subsyst_0_errsotsynchs_intr [get_bd_pins ila_0/probe1] [get_bd_pins mipi_csi2_rx_subsyst_0/errsotsynchs_intr]
  connect_bd_net -net mipi_csi2_rx_subsyst_0_frame_rcvd_pulse_out [get_bd_pins ila_0/probe9] [get_bd_pins mipi_csi2_rx_subsyst_0/frame_rcvd_pulse_out]
  connect_bd_net -net mipi_csi2_rx_subsyst_0_linebuffer_full [get_bd_pins ila_0/probe8] [get_bd_pins mipi_csi2_rx_subsyst_0/linebuffer_full]
  connect_bd_net -net mipi_csi2_rx_subsyst_1_cl_stopstate_intr [get_bd_pins ila_1/probe3] [get_bd_pins mipi_csi2_rx_subsyst_1/cl_stopstate_intr]
  connect_bd_net -net mipi_csi2_rx_subsyst_1_crc_status_intr [get_bd_pins ila_1/probe6] [get_bd_pins mipi_csi2_rx_subsyst_1/crc_status_intr]
  connect_bd_net -net mipi_csi2_rx_subsyst_1_ctrl_dis_in_prgs [get_bd_pins ila_1/probe0] [get_bd_pins mipi_csi2_rx_subsyst_1/ctrl_dis_in_prgs]
  connect_bd_net -net mipi_csi2_rx_subsyst_1_dl0_stopstate_intr [get_bd_pins ila_1/probe4] [get_bd_pins mipi_csi2_rx_subsyst_1/dl0_stopstate_intr]
  connect_bd_net -net mipi_csi2_rx_subsyst_1_dl1_stopstate_intr [get_bd_pins ila_1/probe5] [get_bd_pins mipi_csi2_rx_subsyst_1/dl1_stopstate_intr]
  connect_bd_net -net mipi_csi2_rx_subsyst_1_dlyctrl_rdy_out [get_bd_pins mipi_csi2_rx_subsyst_0/dlyctrl_rdy_in] [get_bd_pins mipi_csi2_rx_subsyst_1/dlyctrl_rdy_out]
  connect_bd_net -net mipi_csi2_rx_subsyst_1_ecc_status_intr [get_bd_pins ila_1/probe7] [get_bd_pins mipi_csi2_rx_subsyst_1/ecc_status_intr]
  connect_bd_net -net mipi_csi2_rx_subsyst_1_errsoths_intr [get_bd_pins ila_1/probe2] [get_bd_pins mipi_csi2_rx_subsyst_1/errsoths_intr]
  connect_bd_net -net mipi_csi2_rx_subsyst_1_errsotsynchs_intr [get_bd_pins ila_1/probe1] [get_bd_pins mipi_csi2_rx_subsyst_1/errsotsynchs_intr]
  connect_bd_net -net mipi_csi2_rx_subsyst_1_frame_rcvd_pulse_out [get_bd_pins ila_1/probe9] [get_bd_pins mipi_csi2_rx_subsyst_1/frame_rcvd_pulse_out]
  connect_bd_net -net mipi_csi2_rx_subsyst_1_linebuffer_full [get_bd_pins ila_1/probe8] [get_bd_pins mipi_csi2_rx_subsyst_1/linebuffer_full]
  connect_bd_net -net proc_sys_reset_0_bus_struct_reset [get_bd_pins microblaze_0_local_memory/SYS_Rst] [get_bd_pins proc_sys_reset_0/bus_struct_reset]
  connect_bd_net -net proc_sys_reset_0_mb_reset [get_bd_pins microblaze_0/Reset] [get_bd_pins proc_sys_reset_0/mb_reset]
  connect_bd_net -net proc_sys_reset_0_peripheral_aresetn [get_bd_pins axi_gpio_0/s_axi_aresetn] [get_bd_pins axi_iic_0/s_axi_aresetn] [get_bd_pins axi_iic_1/s_axi_aresetn] [get_bd_pins axi_interconnect_0/M00_ARESETN] [get_bd_pins axi_interconnect_0/M01_ARESETN] [get_bd_pins axi_interconnect_0/M02_ARESETN] [get_bd_pins axi_interconnect_0/M03_ARESETN] [get_bd_pins axi_interconnect_0/M04_ARESETN] [get_bd_pins axi_interconnect_0/M05_ARESETN] [get_bd_pins axi_interconnect_0/M06_ARESETN] [get_bd_pins axi_interconnect_0/M07_ARESETN] [get_bd_pins axi_interconnect_0/M08_ARESETN] [get_bd_pins axi_timer_0/s_axi_aresetn] [get_bd_pins axi_uartlite_0/s_axi_aresetn] [get_bd_pins axis_interconnect_0/S00_AXIS_ARESETN] [get_bd_pins axis_interconnect_0/S01_AXIS_ARESETN] [get_bd_pins mipi_csi2_rx_subsyst_0/ctrl_core_en] [get_bd_pins mipi_csi2_rx_subsyst_0/video_aresetn] [get_bd_pins mipi_csi2_rx_subsyst_1/ctrl_core_en] [get_bd_pins mipi_csi2_rx_subsyst_1/video_aresetn] [get_bd_pins proc_sys_reset_0/peripheral_aresetn] [get_bd_pins stream_mod_0/axis_aresetn] [get_bd_pins stream_mod_1/axis_aresetn] [get_bd_pins system_ila_0/resetn] [get_bd_pins v_demosaic_0/ap_rst_n] [get_bd_pins v_demosaic_1/ap_rst_n] [get_bd_pins v_gamma_lut_0/ap_rst_n] [get_bd_pins v_gamma_lut_1/ap_rst_n]
  connect_bd_net -net proc_sys_reset_0_peripheral_reset [get_bd_pins aurora_8b10b_reset_0/peri_reset] [get_bd_pins blink_0/RST] [get_bd_pins proc_sys_reset_1/peripheral_reset]
  connect_bd_net -net sys_clock_1 [get_bd_ports sys_clock] [get_bd_pins clk_wiz/clk_in1]
  connect_bd_net -net util_vector_logic_1_Res [get_bd_pins util_vector_logic_1/Res] [get_bd_pins util_vector_logic_2/Op1]
  connect_bd_net -net util_vector_logic_2_Res [get_bd_ports LED_YELLOW] [get_bd_pins util_vector_logic_2/Res]
  connect_bd_net -net vio_0_probe_out0 [get_bd_pins mipi_csi2_rx_subsyst_0/lane0_tap] [get_bd_pins vio_0/probe_out0]
  connect_bd_net -net vio_0_probe_out1 [get_bd_pins mipi_csi2_rx_subsyst_0/lane1_tap] [get_bd_pins vio_0/probe_out1]
  connect_bd_net -net vio_0_probe_out2 [get_bd_pins mipi_csi2_rx_subsyst_1/lane0_tap] [get_bd_pins vio_0/probe_out2]
  connect_bd_net -net vio_0_probe_out3 [get_bd_pins mipi_csi2_rx_subsyst_1/lane1_tap] [get_bd_pins vio_0/probe_out3]
  connect_bd_net -net xlconstant_0_dout [get_bd_ports EN_GTPWR] [get_bd_pins xlconstant_0/dout]
  connect_bd_net -net xlconstant_1_dout [get_bd_ports CAM1_PWUP] [get_bd_pins xlslice_0/Dout]
  connect_bd_net -net xlslice_1_Dout [get_bd_ports CAM2_PWUP] [get_bd_pins xlslice_1/Dout]
  connect_bd_net -net xlslice_2_Dout [get_bd_ports LED_GREEN] [get_bd_pins xlslice_2/Dout]

  # Create address segments
  assign_bd_address -offset 0x40000000 -range 0x00010000 -target_address_space [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs axi_gpio_0/S_AXI/Reg] -force
  assign_bd_address -offset 0x40800000 -range 0x00010000 -target_address_space [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs axi_iic_0/S_AXI/Reg] -force
  assign_bd_address -offset 0x40810000 -range 0x00010000 -target_address_space [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs axi_iic_1/S_AXI/Reg] -force
  assign_bd_address -offset 0x41C00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs axi_timer_0/S_AXI/Reg] -force
  assign_bd_address -offset 0x40600000 -range 0x00010000 -target_address_space [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs axi_uartlite_0/S_AXI/Reg] -force
  assign_bd_address -offset 0x00000000 -range 0x00010000 -target_address_space [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs microblaze_0_local_memory/dlmb_bram_if_cntlr/SLMB/Mem] -force
  assign_bd_address -offset 0x00000000 -range 0x00010000 -target_address_space [get_bd_addr_spaces microblaze_0/Instruction] [get_bd_addr_segs microblaze_0_local_memory/ilmb_bram_if_cntlr/SLMB/Mem] -force
  assign_bd_address -offset 0x44A00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs v_demosaic_0/s_axi_CTRL/Reg] -force
  assign_bd_address -offset 0x44A10000 -range 0x00010000 -target_address_space [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs v_demosaic_1/s_axi_CTRL/Reg] -force
  assign_bd_address -offset 0x44A20000 -range 0x00010000 -target_address_space [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs v_gamma_lut_0/s_axi_CTRL/Reg] -force
  assign_bd_address -offset 0x44A30000 -range 0x00010000 -target_address_space [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs v_gamma_lut_1/s_axi_CTRL/Reg] -force


  # Restore current instance
  current_bd_instance $oldCurInst

  validate_bd_design
  save_bd_design
}
# End of create_root_design()


##################################################################
# MAIN FLOW
##################################################################

create_root_design ""


