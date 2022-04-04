
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
# aurora_8b10b_reset, axis_distibutor, axis_sig_ext, axis_sig_ext, frame_alignment, frame_alignment, gt_common_wrapper, ins_tlast, ins_tlast, reduce_fps, reduce_fps

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
xilinx.com:ip:axis_data_fifo:2.0\
xilinx.com:ip:axis_dwidth_converter:1.1\
xilinx.com:ip:clk_wiz:6.0\
xilinx.com:ip:proc_sys_reset:5.0\
xilinx.com:ip:util_ds_buf:2.2\
xilinx.com:ip:util_vector_logic:2.0\
xilinx.com:ip:vio:3.0\
xilinx.com:ip:xdma:4.1\
xilinx.com:ip:xlconstant:1.1\
xilinx.com:ip:xpm_cdc_gen:1.0\
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
axis_distibutor\
axis_sig_ext\
axis_sig_ext\
frame_alignment\
frame_alignment\
gt_common_wrapper\
ins_tlast\
ins_tlast\
reduce_fps\
reduce_fps\
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
  set MGT_REFCLK [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 MGT_REFCLK ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {125000000} \
   ] $MGT_REFCLK

  set MGT_SERIAL_RX [ create_bd_intf_port -mode Slave -vlnv xilinx.com:display_aurora:GT_Serial_Transceiver_Pins_RX_rtl:1.0 MGT_SERIAL_RX ]

  set PCIe_REFCLK [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 PCIe_REFCLK ]

  set PCIe_SERIAL [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:pcie_7x_mgt_rtl:1.0 PCIe_SERIAL ]


  # Create ports
  set EN_GTPWR [ create_bd_port -dir O -from 0 -to 0 EN_GTPWR ]
  set GPIO_O [ create_bd_port -dir O GPIO_O ]
  set KEY0 [ create_bd_port -dir I -type rst KEY0 ]
  set KEY1 [ create_bd_port -dir I KEY1 ]
  set LED_GREEN [ create_bd_port -dir O -from 0 -to 0 LED_GREEN ]
  set LED_MOD [ create_bd_port -dir O -from 0 -to 0 LED_MOD ]
  set LED_YELLOW [ create_bd_port -dir O -from 0 -to 0 LED_YELLOW ]
  set PCIe_CLK_nREQ [ create_bd_port -dir O -from 0 -to 0 -type rst PCIe_CLK_nREQ ]
  set PCIe_nRST [ create_bd_port -dir I -type rst PCIe_nRST ]
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
   CONFIG.Dataflow_Config {RX-only_Simplex} \
   CONFIG.Interface_Mode {Framing} \
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
  
  # Create instance: axis_data_fifo_00, and set properties
  set axis_data_fifo_00 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_data_fifo:2.0 axis_data_fifo_00 ]
  set_property -dict [ list \
   CONFIG.FIFO_DEPTH {8192} \
   CONFIG.FIFO_MEMORY_TYPE {block} \
   CONFIG.HAS_AEMPTY {0} \
   CONFIG.HAS_AFULL {1} \
   CONFIG.HAS_RD_DATA_COUNT {0} \
   CONFIG.HAS_WR_DATA_COUNT {0} \
   CONFIG.IS_ACLK_ASYNC {1} \
 ] $axis_data_fifo_00

  # Create instance: axis_data_fifo_01, and set properties
  set axis_data_fifo_01 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_data_fifo:2.0 axis_data_fifo_01 ]
  set_property -dict [ list \
   CONFIG.FIFO_DEPTH {8192} \
   CONFIG.FIFO_MEMORY_TYPE {block} \
   CONFIG.HAS_AEMPTY {0} \
   CONFIG.HAS_AFULL {0} \
   CONFIG.HAS_RD_DATA_COUNT {0} \
   CONFIG.HAS_WR_DATA_COUNT {0} \
   CONFIG.IS_ACLK_ASYNC {0} \
 ] $axis_data_fifo_01

  # Create instance: axis_data_fifo_10, and set properties
  set axis_data_fifo_10 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_data_fifo:2.0 axis_data_fifo_10 ]
  set_property -dict [ list \
   CONFIG.FIFO_DEPTH {8192} \
   CONFIG.FIFO_MEMORY_TYPE {block} \
   CONFIG.HAS_AEMPTY {0} \
   CONFIG.HAS_AFULL {1} \
   CONFIG.HAS_RD_DATA_COUNT {0} \
   CONFIG.HAS_WR_DATA_COUNT {0} \
   CONFIG.IS_ACLK_ASYNC {1} \
 ] $axis_data_fifo_10

  # Create instance: axis_data_fifo_11, and set properties
  set axis_data_fifo_11 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_data_fifo:2.0 axis_data_fifo_11 ]
  set_property -dict [ list \
   CONFIG.FIFO_DEPTH {8192} \
   CONFIG.FIFO_MEMORY_TYPE {block} \
   CONFIG.HAS_AEMPTY {0} \
   CONFIG.HAS_AFULL {0} \
   CONFIG.HAS_RD_DATA_COUNT {0} \
   CONFIG.HAS_WR_DATA_COUNT {0} \
   CONFIG.IS_ACLK_ASYNC {0} \
 ] $axis_data_fifo_11

  # Create instance: axis_distibutor_0, and set properties
  set block_name axis_distibutor
  set block_cell_name axis_distibutor_0
  if { [catch {set axis_distibutor_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $axis_distibutor_0 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: axis_dwidth_converter_0, and set properties
  set axis_dwidth_converter_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_dwidth_converter:1.1 axis_dwidth_converter_0 ]
  set_property -dict [ list \
   CONFIG.HAS_MI_TKEEP {1} \
   CONFIG.M_TDATA_NUM_BYTES {8} \
 ] $axis_dwidth_converter_0

  # Create instance: axis_dwidth_converter_1, and set properties
  set axis_dwidth_converter_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_dwidth_converter:1.1 axis_dwidth_converter_1 ]
  set_property -dict [ list \
   CONFIG.HAS_MI_TKEEP {1} \
   CONFIG.M_TDATA_NUM_BYTES {8} \
 ] $axis_dwidth_converter_1

  # Create instance: axis_sig_ext_0, and set properties
  set block_name axis_sig_ext
  set block_cell_name axis_sig_ext_0
  if { [catch {set axis_sig_ext_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $axis_sig_ext_0 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: axis_sig_ext_1, and set properties
  set block_name axis_sig_ext
  set block_cell_name axis_sig_ext_1
  if { [catch {set axis_sig_ext_1 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $axis_sig_ext_1 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: clk_wiz_0, and set properties
  set clk_wiz_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz:6.0 clk_wiz_0 ]
  set_property -dict [ list \
   CONFIG.CLKIN1_JITTER_PS {400.0} \
   CONFIG.CLKOUT1_JITTER {226.965} \
   CONFIG.CLKOUT1_PHASE_ERROR {237.727} \
   CONFIG.CLK_IN1_BOARD_INTERFACE {sys_clock} \
   CONFIG.MMCM_CLKFBOUT_MULT_F {40.000} \
   CONFIG.MMCM_CLKIN1_PERIOD {40.000} \
   CONFIG.MMCM_CLKIN2_PERIOD {10.0} \
   CONFIG.USE_BOARD_FLOW {true} \
   CONFIG.USE_RESET {false} \
 ] $clk_wiz_0

  # Create instance: frame_alignment_0, and set properties
  set block_name frame_alignment
  set block_cell_name frame_alignment_0
  if { [catch {set frame_alignment_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $frame_alignment_0 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: frame_alignment_1, and set properties
  set block_name frame_alignment
  set block_cell_name frame_alignment_1
  if { [catch {set frame_alignment_1 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $frame_alignment_1 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: gt_common_wrapper_0, and set properties
  set block_name gt_common_wrapper
  set block_cell_name gt_common_wrapper_0
  if { [catch {set gt_common_wrapper_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $gt_common_wrapper_0 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: ins_tlast_0, and set properties
  set block_name ins_tlast
  set block_cell_name ins_tlast_0
  if { [catch {set ins_tlast_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $ins_tlast_0 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: ins_tlast_1, and set properties
  set block_name ins_tlast
  set block_cell_name ins_tlast_1
  if { [catch {set ins_tlast_1 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $ins_tlast_1 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: proc_sys_reset_0, and set properties
  set proc_sys_reset_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_0 ]

  # Create instance: proc_sys_reset_1, and set properties
  set proc_sys_reset_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_1 ]
  set_property -dict [ list \
   CONFIG.C_AUX_RESET_HIGH {0} \
 ] $proc_sys_reset_1

  # Create instance: reduce_fps_0, and set properties
  set block_name reduce_fps
  set block_cell_name reduce_fps_0
  if { [catch {set reduce_fps_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $reduce_fps_0 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: reduce_fps_1, and set properties
  set block_name reduce_fps
  set block_cell_name reduce_fps_1
  if { [catch {set reduce_fps_1 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $reduce_fps_1 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: util_ds_buf_0, and set properties
  set util_ds_buf_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_ds_buf:2.2 util_ds_buf_0 ]
  set_property -dict [ list \
   CONFIG.C_BUF_TYPE {IBUFDSGTE} \
 ] $util_ds_buf_0

  # Create instance: util_ds_buf_1, and set properties
  set util_ds_buf_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_ds_buf:2.2 util_ds_buf_1 ]
  set_property -dict [ list \
   CONFIG.C_BUF_TYPE {IBUFDSGTE} \
 ] $util_ds_buf_1

  # Create instance: util_ds_buf_2, and set properties
  set util_ds_buf_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_ds_buf:2.2 util_ds_buf_2 ]
  set_property -dict [ list \
   CONFIG.C_BUF_TYPE {BUFG} \
 ] $util_ds_buf_2

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

  # Create instance: util_vector_logic_3, and set properties
  set util_vector_logic_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 util_vector_logic_3 ]
  set_property -dict [ list \
   CONFIG.C_OPERATION {not} \
   CONFIG.C_SIZE {1} \
   CONFIG.LOGO_FILE {data/sym_notgate.png} \
 ] $util_vector_logic_3

  # Create instance: util_vector_logic_4, and set properties
  set util_vector_logic_4 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 util_vector_logic_4 ]
  set_property -dict [ list \
   CONFIG.C_OPERATION {or} \
   CONFIG.C_SIZE {1} \
   CONFIG.LOGO_FILE {data/sym_orgate.png} \
 ] $util_vector_logic_4

  # Create instance: vio_0, and set properties
  set vio_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:vio:3.0 vio_0 ]
  set_property -dict [ list \
   CONFIG.C_EN_PROBE_IN_ACTIVITY {0} \
   CONFIG.C_NUM_PROBE_IN {0} \
   CONFIG.C_NUM_PROBE_OUT {1} \
   CONFIG.C_PROBE_OUT0_INIT_VAL {0x15} \
   CONFIG.C_PROBE_OUT0_WIDTH {6} \
   CONFIG.C_PROBE_OUT1_INIT_VAL {0x} \
   CONFIG.C_PROBE_OUT1_WIDTH {6} \
 ] $vio_0

  # Create instance: xdma_0, and set properties
  set xdma_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xdma:4.1 xdma_0 ]
  set_property -dict [ list \
   CONFIG.PF0_DEVICE_ID_mqdma {9021} \
   CONFIG.PF2_DEVICE_ID_mqdma {9221} \
   CONFIG.PF3_DEVICE_ID_mqdma {9321} \
   CONFIG.Shared_Logic_Gtc_7xG2 {true} \
   CONFIG.axisten_freq {125} \
   CONFIG.mode_selection {Advanced} \
   CONFIG.pf0_device_id {7021} \
   CONFIG.pf0_interrupt_pin {INTA} \
   CONFIG.pf0_link_status_slot_clock_config {true} \
   CONFIG.pf0_msi_enabled {false} \
   CONFIG.pf0_msix_cap_pba_bir {BAR_1:0} \
   CONFIG.pf0_msix_cap_pba_offset {00008FE0} \
   CONFIG.pf0_msix_cap_table_bir {BAR_1:0} \
   CONFIG.pf0_msix_cap_table_offset {00008000} \
   CONFIG.pf0_msix_cap_table_size {01F} \
   CONFIG.pf0_msix_enabled {true} \
   CONFIG.pl_link_cap_max_link_speed {5.0_GT/s} \
   CONFIG.plltype {QPLL1} \
   CONFIG.xdma_axi_intf_mm {AXI_Stream} \
   CONFIG.xdma_num_usr_irq {16} \
   CONFIG.xdma_pcie_64bit_en {true} \
   CONFIG.xdma_pcie_prefetchable {true} \
   CONFIG.xdma_sts_ports {false} \
   CONFIG.xdma_wnum_chnl {2} \
   CONFIG.xlnx_ref_board {None} \
 ] $xdma_0

  # Create instance: xlconstant_0, and set properties
  set xlconstant_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_0 ]

  # Create instance: xpm_cdc_gen_0, and set properties
  set xpm_cdc_gen_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xpm_cdc_gen:1.0 xpm_cdc_gen_0 ]
  set_property -dict [ list \
   CONFIG.CDC_TYPE {xpm_cdc_single} \
   CONFIG.WIDTH {1} \
 ] $xpm_cdc_gen_0

  # Create instance: xpm_cdc_gen_1, and set properties
  set xpm_cdc_gen_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xpm_cdc_gen:1.0 xpm_cdc_gen_1 ]
  set_property -dict [ list \
   CONFIG.CDC_TYPE {xpm_cdc_single} \
   CONFIG.WIDTH {1} \
 ] $xpm_cdc_gen_1

  # Create instance: xpm_cdc_gen_2, and set properties
  set xpm_cdc_gen_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xpm_cdc_gen:1.0 xpm_cdc_gen_2 ]
  set_property -dict [ list \
   CONFIG.CDC_TYPE {xpm_cdc_async_rst} \
 ] $xpm_cdc_gen_2

  # Create instance: xpm_cdc_gen_3, and set properties
  set xpm_cdc_gen_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xpm_cdc_gen:1.0 xpm_cdc_gen_3 ]
  set_property -dict [ list \
   CONFIG.CDC_TYPE {xpm_cdc_async_rst} \
 ] $xpm_cdc_gen_3

  # Create interface connections
  connect_bd_intf_net -intf_net GT_SERIALM_RX_1 [get_bd_intf_ports MGT_SERIAL_RX] [get_bd_intf_pins aurora_8b10b_0/GT_SERIAL_RX]
  connect_bd_intf_net -intf_net MGT_REFCLK_1 [get_bd_intf_ports MGT_REFCLK] [get_bd_intf_pins util_ds_buf_1/CLK_IN_D]
  connect_bd_intf_net -intf_net PCIe_REFCLK_1 [get_bd_intf_ports PCIe_REFCLK] [get_bd_intf_pins util_ds_buf_0/CLK_IN_D]
  connect_bd_intf_net -intf_net aurora_8b10b_0_USER_DATA_M_AXI_RX [get_bd_intf_pins aurora_8b10b_0/USER_DATA_M_AXI_RX] [get_bd_intf_pins axis_distibutor_0/S_AXIS]
  connect_bd_intf_net -intf_net axis_data_fifo_01_M_AXIS [get_bd_intf_pins axis_data_fifo_01/M_AXIS] [get_bd_intf_pins axis_sig_ext_0/S_AXIS]
  connect_bd_intf_net -intf_net axis_data_fifo_0_M_AXIS [get_bd_intf_pins axis_data_fifo_00/M_AXIS] [get_bd_intf_pins axis_dwidth_converter_0/S_AXIS]
  connect_bd_intf_net -intf_net axis_data_fifo_11_M_AXIS [get_bd_intf_pins axis_data_fifo_11/M_AXIS] [get_bd_intf_pins axis_sig_ext_1/S_AXIS]
  connect_bd_intf_net -intf_net axis_data_fifo_1_M_AXIS [get_bd_intf_pins axis_data_fifo_10/M_AXIS] [get_bd_intf_pins axis_dwidth_converter_1/S_AXIS]
  connect_bd_intf_net -intf_net axis_distibutor_0_M00_AXIS [get_bd_intf_pins axis_distibutor_0/M00_AXIS] [get_bd_intf_pins ins_tlast_0/S_AXIS]
  connect_bd_intf_net -intf_net axis_distibutor_0_M01_AXIS [get_bd_intf_pins axis_distibutor_0/M01_AXIS] [get_bd_intf_pins ins_tlast_1/S_AXIS]
  connect_bd_intf_net -intf_net axis_dwidth_converter_0_M_AXIS [get_bd_intf_pins axis_data_fifo_01/S_AXIS] [get_bd_intf_pins axis_dwidth_converter_0/M_AXIS]
  connect_bd_intf_net -intf_net axis_dwidth_converter_1_M_AXIS [get_bd_intf_pins axis_data_fifo_11/S_AXIS] [get_bd_intf_pins axis_dwidth_converter_1/M_AXIS]
  connect_bd_intf_net -intf_net axis_sig_ext_1_M_AXIS [get_bd_intf_pins axis_sig_ext_1/M_AXIS] [get_bd_intf_pins xdma_0/S_AXIS_C2H_1]
  connect_bd_intf_net -intf_net frame_alignment_0_M_AXIS [get_bd_intf_pins axis_data_fifo_00/S_AXIS] [get_bd_intf_pins frame_alignment_0/M_AXIS]
  connect_bd_intf_net -intf_net frame_alignment_1_M_AXIS [get_bd_intf_pins axis_data_fifo_10/S_AXIS] [get_bd_intf_pins frame_alignment_1/M_AXIS]
  connect_bd_intf_net -intf_net ins_tlast_0_M_AXIS [get_bd_intf_pins axis_sig_ext_0/M_AXIS] [get_bd_intf_pins xdma_0/S_AXIS_C2H_0]
  connect_bd_intf_net -intf_net ins_tlast_0_M_AXIS1 [get_bd_intf_pins ins_tlast_0/M_AXIS] [get_bd_intf_pins reduce_fps_0/S_AXIS]
  connect_bd_intf_net -intf_net ins_tlast_1_M_AXIS [get_bd_intf_pins ins_tlast_1/M_AXIS] [get_bd_intf_pins reduce_fps_1/S_AXIS]
  connect_bd_intf_net -intf_net reduce_fps_0_M_AXIS [get_bd_intf_pins frame_alignment_0/S_AXIS] [get_bd_intf_pins reduce_fps_0/M_AXIS]
  connect_bd_intf_net -intf_net reduce_fps_1_M_AXIS [get_bd_intf_pins frame_alignment_1/S_AXIS] [get_bd_intf_pins reduce_fps_1/M_AXIS]
  connect_bd_intf_net -intf_net xdma_0_pcie_mgt [get_bd_intf_ports PCIe_SERIAL] [get_bd_intf_pins xdma_0/pcie_mgt]

  # Create port connections
  connect_bd_net -net KEY0_1 [get_bd_ports KEY0] [get_bd_pins proc_sys_reset_0/ext_reset_in]
  connect_bd_net -net KEY1_1 [get_bd_ports KEY1] [get_bd_pins proc_sys_reset_1/ext_reset_in]
  connect_bd_net -net Net1 [get_bd_pins axis_data_fifo_00/m_axis_aclk] [get_bd_pins axis_data_fifo_01/s_axis_aclk] [get_bd_pins axis_data_fifo_10/m_axis_aclk] [get_bd_pins axis_data_fifo_11/s_axis_aclk] [get_bd_pins axis_dwidth_converter_0/aclk] [get_bd_pins axis_dwidth_converter_1/aclk] [get_bd_pins axis_sig_ext_0/axis_aclk] [get_bd_pins axis_sig_ext_1/axis_aclk] [get_bd_pins xdma_0/axi_aclk] [get_bd_pins xpm_cdc_gen_0/src_clk] [get_bd_pins xpm_cdc_gen_1/src_clk] [get_bd_pins xpm_cdc_gen_2/dest_clk] [get_bd_pins xpm_cdc_gen_3/dest_clk]
  connect_bd_net -net PCIe_nRST_1 [get_bd_ports PCIe_nRST] [get_bd_pins xdma_0/sys_rst_n]
  connect_bd_net -net aurora_8b10b_0_gt_common_reset_out [get_bd_pins aurora_8b10b_0/gt_common_reset_out] [get_bd_pins gt_common_wrapper_0/gt0_pll1reset_in]
  connect_bd_net -net aurora_8b10b_0_rx_channel_up [get_bd_pins aurora_8b10b_0/rx_channel_up] [get_bd_pins util_vector_logic_1/Op1]
  connect_bd_net -net aurora_8b10b_0_rx_lane_up [get_bd_pins aurora_8b10b_0/rx_lane_up] [get_bd_pins util_vector_logic_1/Op2]
  connect_bd_net -net aurora_8b10b_0_sys_reset_out [get_bd_pins aurora_8b10b_0/sys_reset_out] [get_bd_pins util_vector_logic_3/Op1]
  connect_bd_net -net aurora_8b10b_0_tx_out_clk [get_bd_pins aurora_8b10b_0/tx_out_clk] [get_bd_pins util_ds_buf_2/BUFG_I]
  connect_bd_net -net aurora_8b10b_clock_m_0_USER_CLK [get_bd_pins aurora_8b10b_0/sync_clk] [get_bd_pins aurora_8b10b_0/user_clk] [get_bd_pins axis_data_fifo_00/s_axis_aclk] [get_bd_pins axis_data_fifo_10/s_axis_aclk] [get_bd_pins axis_distibutor_0/axis_aclk] [get_bd_pins frame_alignment_0/axis_aclk] [get_bd_pins frame_alignment_1/axis_aclk] [get_bd_pins ins_tlast_0/axis_aclk] [get_bd_pins ins_tlast_1/axis_aclk] [get_bd_pins proc_sys_reset_1/slowest_sync_clk] [get_bd_pins reduce_fps_0/axis_aclk] [get_bd_pins reduce_fps_1/axis_aclk] [get_bd_pins util_ds_buf_2/BUFG_O] [get_bd_pins vio_0/clk] [get_bd_pins xpm_cdc_gen_0/dest_clk] [get_bd_pins xpm_cdc_gen_1/dest_clk]
  connect_bd_net -net aurora_8b10b_reset_0_gt_reset [get_bd_pins aurora_8b10b_0/gt_reset] [get_bd_pins aurora_8b10b_reset_0/gt_reset]
  connect_bd_net -net aurora_8b10b_reset_0_system_reset [get_bd_pins aurora_8b10b_0/rx_system_reset] [get_bd_pins aurora_8b10b_reset_0/system_reset]
  connect_bd_net -net axis_data_fifo_0_almost_full [get_bd_pins axis_data_fifo_00/almost_full] [get_bd_pins util_vector_logic_4/Op1]
  connect_bd_net -net axis_data_fifo_1_almost_full [get_bd_pins axis_data_fifo_10/almost_full] [get_bd_pins util_vector_logic_4/Op2]
  connect_bd_net -net axis_sig_ext_0_m_axis_tready_ext [get_bd_pins axis_sig_ext_0/m_axis_tready_ext] [get_bd_pins xpm_cdc_gen_0/src_in]
  connect_bd_net -net axis_sig_ext_1_m_axis_tready_ext [get_bd_pins axis_sig_ext_1/m_axis_tready_ext] [get_bd_pins xpm_cdc_gen_1/src_in]
  connect_bd_net -net clk_wiz_0_clk_out1 [get_bd_pins aurora_8b10b_0/drpclk_in] [get_bd_pins aurora_8b10b_0/init_clk_in] [get_bd_pins aurora_8b10b_reset_0/clock] [get_bd_pins clk_wiz_0/clk_out1] [get_bd_pins gt_common_wrapper_0/gt0_pll0lockdetclk_in] [get_bd_pins gt_common_wrapper_0/gt0_pll1lockdetclk_in] [get_bd_pins proc_sys_reset_0/slowest_sync_clk]
  connect_bd_net -net clk_wiz_0_locked [get_bd_pins clk_wiz_0/locked] [get_bd_pins proc_sys_reset_0/dcm_locked] [get_bd_pins proc_sys_reset_1/dcm_locked]
  connect_bd_net -net frame_alignment_0_axis_aresetn_out [get_bd_pins axis_data_fifo_00/s_axis_aresetn] [get_bd_pins frame_alignment_0/axis_aresetn_out] [get_bd_pins xpm_cdc_gen_2/src_arst]
  connect_bd_net -net frame_alignment_1_axis_aresetn_out [get_bd_pins axis_data_fifo_10/s_axis_aresetn] [get_bd_pins frame_alignment_1/axis_aresetn_out] [get_bd_pins xpm_cdc_gen_3/src_arst]
  connect_bd_net -net gt_common_wrapper_0_gt0_pll0lock_out [get_bd_pins gt_common_wrapper_0/gt0_pll0lock_out] [get_bd_pins xdma_0/qpll_qplllock]
  connect_bd_net -net gt_common_wrapper_0_gt0_pll0outclk_i [get_bd_pins gt_common_wrapper_0/gt0_pll0outclk_i] [get_bd_pins xdma_0/qpll_qplloutclk]
  connect_bd_net -net gt_common_wrapper_0_gt0_pll0outrefclk_i [get_bd_pins gt_common_wrapper_0/gt0_pll0outrefclk_i] [get_bd_pins xdma_0/qpll_qplloutrefclk]
  connect_bd_net -net gt_common_wrapper_0_gt0_pll1lock_out [get_bd_pins aurora_8b10b_0/quad1_common_lock_in] [get_bd_pins gt_common_wrapper_0/gt0_pll1lock_out]
  connect_bd_net -net gt_common_wrapper_0_gt0_pll1outclk_i [get_bd_pins aurora_8b10b_0/gt0_pll1outclk_in] [get_bd_pins gt_common_wrapper_0/gt0_pll1outclk_i]
  connect_bd_net -net gt_common_wrapper_0_gt0_pll1outrefclk_i [get_bd_pins aurora_8b10b_0/gt0_pll1outrefclk_in] [get_bd_pins gt_common_wrapper_0/gt0_pll1outrefclk_i]
  connect_bd_net -net gt_common_wrapper_0_gt0_pll1refclklost_out [get_bd_pins aurora_8b10b_0/gt0_pll0refclklost_in] [get_bd_pins gt_common_wrapper_0/gt0_pll1refclklost_out]
  connect_bd_net -net proc_sys_reset_0_bus_struct_reset [get_bd_ports PCIe_CLK_nREQ] [get_bd_pins proc_sys_reset_0/bus_struct_reset]
  connect_bd_net -net proc_sys_reset_0_peripheral_reset [get_bd_pins aurora_8b10b_reset_0/peri_reset] [get_bd_pins proc_sys_reset_0/peripheral_reset]
  connect_bd_net -net proc_sys_reset_1_peripheral_aresetn [get_bd_pins frame_alignment_0/peripheral_aresetn] [get_bd_pins frame_alignment_1/peripheral_aresetn] [get_bd_pins proc_sys_reset_1/peripheral_aresetn]
  connect_bd_net -net sys_clock_1 [get_bd_ports sys_clock] [get_bd_pins clk_wiz_0/clk_in1]
  connect_bd_net -net util_ds_buf_0_IBUF_OUT [get_bd_pins gt_common_wrapper_0/gt0_gtrefclk0_in] [get_bd_pins util_ds_buf_0/IBUF_OUT] [get_bd_pins xdma_0/sys_clk]
  connect_bd_net -net util_ds_buf_1_IBUF_OUT [get_bd_pins aurora_8b10b_0/gt_refclk1] [get_bd_pins gt_common_wrapper_0/gt0_gtrefclk1_in] [get_bd_pins util_ds_buf_1/IBUF_OUT]
  connect_bd_net -net util_vector_logic_0_Res [get_bd_ports LED_YELLOW] [get_bd_pins util_vector_logic_0/Res]
  connect_bd_net -net util_vector_logic_1_Res [get_bd_pins util_vector_logic_0/Op1] [get_bd_pins util_vector_logic_1/Res]
  connect_bd_net -net util_vector_logic_2_Res [get_bd_ports LED_GREEN] [get_bd_pins util_vector_logic_2/Res]
  connect_bd_net -net util_vector_logic_3_Res [get_bd_pins frame_alignment_0/axis_aresetn] [get_bd_pins frame_alignment_1/axis_aresetn] [get_bd_pins ins_tlast_0/axis_aresetn] [get_bd_pins ins_tlast_1/axis_aresetn] [get_bd_pins reduce_fps_0/axis_aresetn] [get_bd_pins reduce_fps_1/axis_aresetn] [get_bd_pins util_vector_logic_3/Res]
  connect_bd_net -net util_vector_logic_4_Res [get_bd_ports LED_MOD] [get_bd_pins util_vector_logic_4/Res]
  connect_bd_net -net vio_0_probe_out0 [get_bd_pins reduce_fps_0/reduce_ratio] [get_bd_pins reduce_fps_1/reduce_ratio] [get_bd_pins vio_0/probe_out0]
  connect_bd_net -net xdma_0_qpll_qpllreset [get_bd_pins gt_common_wrapper_0/gt0_pll0reset_in] [get_bd_pins xdma_0/qpll_qpllreset]
  connect_bd_net -net xdma_0_user_lnk_up [get_bd_pins util_vector_logic_2/Op1] [get_bd_pins xdma_0/user_lnk_up]
  connect_bd_net -net xlconstant_3_dout [get_bd_ports EN_GTPWR] [get_bd_pins xlconstant_0/dout]
  connect_bd_net -net xpm_cdc_gen_0_dest_out [get_bd_pins frame_alignment_0/rcv_ready] [get_bd_pins xpm_cdc_gen_0/dest_out]
  connect_bd_net -net xpm_cdc_gen_1_dest_out [get_bd_pins frame_alignment_1/rcv_ready] [get_bd_pins xpm_cdc_gen_1/dest_out]
  connect_bd_net -net xpm_cdc_gen_2_dest_arst [get_bd_pins axis_data_fifo_01/s_axis_aresetn] [get_bd_pins axis_dwidth_converter_0/aresetn] [get_bd_pins xpm_cdc_gen_2/dest_arst]
  connect_bd_net -net xpm_cdc_gen_3_dest_arst [get_bd_pins axis_data_fifo_11/s_axis_aresetn] [get_bd_pins axis_dwidth_converter_1/aresetn] [get_bd_pins xpm_cdc_gen_3/dest_arst]

  # Create address segments


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


