
# 
# mutrig_cfg_ctrl "MuTRiG Controller"
# Yifeng Wang 2024.08.16.16:25:06
# 
# 24.0.1028 - stable version of MuTRiG controller supporting both MCC and TTH scan
# 25.0.1021 - add ETH scan

###########################################################
# request TCL package from ACDS 16.1
###########################################################
package require -exact qsys 16.1


###########################################################
# module mutrig_controller
###########################################################
set_module_property DESCRIPTION ""
set_module_property NAME mutrig_cfg_ctrl
set_module_property VERSION 24.0.816
set_module_property INTERNAL false
set_module_property OPAQUE_ADDRESS_MAP true
set_module_property GROUP "Mu3e Control Plane/Modules"
set_module_property AUTHOR "Yifeng Wang"
set_module_property ICON_PATH ""
set_module_property DISPLAY_NAME "MuTRiG Controller"
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE false
set_module_property REPORT_TO_TALKBACK false
set_module_property ALLOW_GREYBOX_GENERATION false
set_module_property REPORT_HIERARCHY false
set_module_property ELABORATION_CALLBACK my_elaborate


##########################################################
# file sets
##########################################################
add_fileset QUARTUS_SYNTH QUARTUS_SYNTH "" ""
set_fileset_property QUARTUS_SYNTH TOP_LEVEL mutrig_ctrl
set_fileset_property QUARTUS_SYNTH ENABLE_RELATIVE_INCLUDE_PATHS false
set_fileset_property QUARTUS_SYNTH ENABLE_FILE_OVERWRITE_MODE false
add_fileset_file alt_dpram.vhd VHDL PATH alt_dpram/alt_dpram.vhd
add_fileset_file alt_dcfifo_cdc.vhd VHDL PATH alt_dcfifo/alt_dcfifo_cdc.vhd
add_fileset_file simple_dual_port_ram_single_clock.vhd VHDL PATH alt_template_simple_dual_port_ram_single_clock/simple_dual_port_ram_single_clock.vhd
add_fileset_file mutrig_ctrl.vhd VHDL PATH mutrig_ctrl.vhd TOP_LEVEL_FILE
add_fileset_file write_mask_gen.vhd VHDL PATH write_mask_gen.vhd


##########################################################
# parameters
########################################################## 
# Reference for html codes used in this section
 # ----------------------------------------------
 # &lt = less than (<)
 # &gt = greater than (>)
 # <b></b> = bold text
 # <ul></ul> = defines an unordered list
 # <li></li> = bullet list
 # <br> = line break
add_parameter N_MUTRIG NATURAL 
set_parameter_property N_MUTRIG DEFAULT_VALUE 8
set_parameter_property N_MUTRIG DISPLAY_NAME N_MUTRIG
set_parameter_property N_MUTRIG TYPE NATURAL
set_parameter_property N_MUTRIG UNITS None
set_parameter_property N_MUTRIG ALLOWED_RANGES 1:128
set_parameter_property N_MUTRIG HDL_PARAMETER true
set dscpt \
"<html>
Set the number of MuTRiG(s) that is controlled by this IP through SPI.
</html>"
set_parameter_property N_MUTRIG DESCRIPTION $dscpt
set_parameter_property N_MUTRIG LONG_DESCRIPTION $dscpt


add_parameter INTENDED_MUTRIG_VERSION STRING
set_parameter_property INTENDED_MUTRIG_VERSION DEFAULT_VALUE "MuTRiG 3"
set_parameter_property INTENDED_MUTRIG_VERSION DISPLAY_NAME "Intended MuTRiG variant"
set_parameter_property INTENDED_MUTRIG_VERSION ENABLED false
set_parameter_property INTENDED_MUTRIG_VERSION VISIBLE false
set_parameter_property INTENDED_MUTRIG_VERSION TYPE STRING
set_parameter_property INTENDED_MUTRIG_VERSION ALLOWED_RANGES {"MuTRiG 1" "MuTRiG 2" "MuTRiG 3"}
set_parameter_property INTENDED_MUTRIG_VERSION UNITS None
set_parameter_property INTENDED_MUTRIG_VERSION HDL_PARAMETER true
set dscpt \
"<html>
Select the intented MuTRiG variant. <br>
This parameter affects the configuration length and bit location of the MuTRiG parameters. <br>
<b>NOTE</b>: only MuTRiG 3 is available, please contact Yifeng Wang (yifenwan@phys.ethz.ch) for technical support.
</html>"
set_parameter_property INTENDED_MUTRIG_VERSION DESCRIPTION $dscpt
set_parameter_property INTENDED_MUTRIG_VERSION LONG_DESCRIPTION $dscpt

add_parameter MUTRIG_CFG_LENGTH_BIT NATURAL 2662 
set_parameter_property MUTRIG_CFG_LENGTH_BIT DEFAULT_VALUE 2662
set_parameter_property MUTRIG_CFG_LENGTH_BIT DISPLAY_NAME "MuTRiG configuration bitstream length"
set_parameter_property MUTRIG_CFG_LENGTH_BIT VISIBLE false
set_parameter_property MUTRIG_CFG_LENGTH_BIT WIDTH ""
set_parameter_property MUTRIG_CFG_LENGTH_BIT TYPE NATURAL
set_parameter_property MUTRIG_CFG_LENGTH_BIT ENABLED false
set_parameter_property MUTRIG_CFG_LENGTH_BIT UNITS Bits
set_parameter_property MUTRIG_CFG_LENGTH_BIT ALLOWED_RANGES 0:1_000_000
set_parameter_property MUTRIG_CFG_LENGTH_BIT HDL_PARAMETER true
set dscpt \
"<html>
Set the configuration bitstream length of one MuTRiG. <br>
This parameters affects the instantiation of the RAMs and SPI configurations. <br>
</html>"
set_parameter_property MUTRIG_CFG_LENGTH_BIT DESCRIPTION $dscpt
set_parameter_property MUTRIG_CFG_LENGTH_BIT LONG_DESCRIPTION $dscpt
set_parameter_property MUTRIG_CFG_LENGTH_BIT DERIVED 1


add_parameter CPOL NATURAL 0 ""
set_parameter_property CPOL DEFAULT_VALUE 0
set_parameter_property CPOL DISPLAY_NAME CPOL
set_parameter_property CPOL TYPE NATURAL
set_parameter_property CPOL ENABLED false
set_parameter_property CPOL UNITS None
set_parameter_property CPOL ALLOWED_RANGES 0:1
set_parameter_property CPOL HDL_PARAMETER true
set dscpt \
"<html>
Sets the <b><i>Clock Polarity</i></b> of the SPI configuration.<br>
This parameter is the polarity of the clock signal during the idle state.
</html>"
set_parameter_property CPOL DESCRIPTION $dscpt
set_parameter_property CPOL LONG_DESCRIPTION $dscpt

add_parameter CPHA NATURAL 0
set_parameter_property CPHA DEFAULT_VALUE 0
set_parameter_property CPHA DISPLAY_NAME CPHA
set_parameter_property CPHA TYPE NATURAL
set_parameter_property CPHA ENABLED false
set_parameter_property CPHA UNITS None
set_parameter_property CPHA ALLOWED_RANGES 0:1
set_parameter_property CPHA HDL_PARAMETER true
set dscpt \
"<html>
Sets the <b><i>Clock Phase</i></b> of the SPI configuration.<br>
This parameter select the clock phase. Depending on the CPHA bit, the rising or falling clock edge is used to sample and/or shift the data.
</html>"
set_parameter_property CPHA DESCRIPTION $dscpt
set_parameter_property CPHA LONG_DESCRIPTION $dscpt

add_parameter CLK_FREQUENCY NATURAL 156250000
set_parameter_property CLK_FREQUENCY DEFAULT_VALUE 156250000
set_parameter_property CLK_FREQUENCY DISPLAY_NAME CLK_FREQUENCY
set_parameter_property CLK_FREQUENCY TYPE NATURAL
set_parameter_property CLK_FREQUENCY UNITS Hertz
set_parameter_property CLK_FREQUENCY ALLOWED_RANGES 0:1_000_000_000
set_parameter_property CLK_FREQUENCY HDL_PARAMETER true
set dscpt \
"<html>
Sets the interface and internal control logic operation frequency. <br>
<br>
<b>Note</b>: SPI clock is regarded as a different clock domain.
</html>"
set_parameter_property CLK_FREQUENCY DESCRIPTION $dscpt
set_parameter_property CLK_FREQUENCY LONG_DESCRIPTION $dscpt

add_parameter CLK_FREQUENCY_SPI NATURAL 
set_parameter_property CLK_FREQUENCY_SPI DEFAULT_VALUE 40_000_000
set_parameter_property CLK_FREQUENCY_SPI DISPLAY_NAME "SPI clock rate"
set_parameter_property CLK_FREQUENCY_SPI ENABLED false
set_parameter_property CLK_FREQUENCY_SPI VISIBLE false
set_parameter_property CLK_FREQUENCY_SPI TYPE NATURAL
set_parameter_property CLK_FREQUENCY_SPI UNITS Hertz
set_parameter_property CLK_FREQUENCY_SPI ALLOWED_RANGES 0:80_000_000
set_parameter_property CLK_FREQUENCY_SPI HDL_PARAMETER false
set dscpt \
"<html>
Sets SPI module clock rate. <br>
MuTRiG's SPI clock domain is constrained under a clock of 40 MHz. <br>
<br>
<b>Note</b>: SPI <i>sclk</i> clock rate is half of this parameter. <br>
</html>"
set_parameter_property CLK_FREQUENCY_SPI DESCRIPTION $dscpt
set_parameter_property CLK_FREQUENCY_SPI LONG_DESCRIPTION $dscpt

add_parameter COUNTER_MM_ADDR_OFFSET_WORD NATURAL
set_parameter_property COUNTER_MM_ADDR_OFFSET_WORD DEFAULT_VALUE 0x8000
set_parameter_property COUNTER_MM_ADDR_OFFSET_WORD DISPLAY_NAME COUNTER_MM_ADDR_OFFSET_WORD
set_parameter_property COUNTER_MM_ADDR_OFFSET_WORD TYPE NATURAL
set_parameter_property COUNTER_MM_ADDR_OFFSET_WORD UNITS None
set_parameter_property COUNTER_MM_ADDR_OFFSET_WORD ALLOWED_RANGES 0:2147483647
set_parameter_property COUNTER_MM_ADDR_OFFSET_WORD DESCRIPTION "Sets the pointer (byte-addressing) to access the rate counter"
set_parameter_property COUNTER_MM_ADDR_OFFSET_WORD LONG_DESCRIPTION "Sets the pointer (byte-addressing) to access the rate counter"
set_parameter_property COUNTER_MM_ADDR_OFFSET_WORD HDL_PARAMETER true
set_parameter_property COUNTER_MM_ADDR_OFFSET_WORD DISPLAY_HINT hexadecimal

add_parameter DEBUG NATURAL 1
set_parameter_property DEBUG DEFAULT_VALUE 1
set_parameter_property DEBUG DISPLAY_NAME "Debug level"
set_parameter_property DEBUG TYPE NATURAL 
set_parameter_property DEBUG ENABLED false
set_parameter_property DEBUG UNITS None
set_parameter_property DEBUG ALLOWED_RANGES {0 1 2}
set dscpt \
"<html>
Select the debug level of the IP (affects generation).<br>
<ul>
	<li><b>0</b> : off <br> </li>
	<li><b>1</b> : on, synthesizble <br> </li>
	<li><b>2</b> : on, non-synthesizble, simulation-only <br> </li>
</ul>
</html>"
set_parameter_property DEBUG LONG_DESCRIPTION $dscpt
set_parameter_property DEBUG DESCRIPTION $dscpt
set_parameter_property DEBUG HDL_PARAMETER true

add_parameter SEL_SUBROUTINES natural 
set_parameter_property SEL_SUBROUTINES DEFAULT_VALUE 2
set_parameter_property SEL_SUBROUTINES DISPLAY_NAME "Select the supported sub-routine"
set_parameter_property SEL_SUBROUTINES ENABLED false
set_parameter_property SEL_SUBROUTINES VISIBLE false
set_parameter_property SEL_SUBROUTINES UNITS None
set_parameter_property SEL_SUBROUTINES ALLOWED_RANGES {"2:Use MCC and TSA" "1:Use MCC only" "0:Use TSA only"}
set_parameter_property SEL_SUBROUTINES DISPLAY_HINT "RADIO"
set_parameter_property SEL_SUBROUTINES HDL_PARAMETER false
set dscpt \
"<html>
Select the sub-routine you wish to use for controlling/calibrating the MuTRiG.<br>
<ul>
	<li><b>2</b> : Use both <b>MCC</b> (MuTRiG Configuration Controller) and <b>TSA</b> (Threshold Scan Automation)<br> </li>
	<li><b>1</b> : Use only <b>MCC</b> (MuTRiG Configuration Controller)<br> </li>
	<li><b>0</b> : Use only <b>TSA</b> (Threshold Scan Automation) <br> </li>
</ul>
<br>
<b>Note</b>: Use only <b>TSA</b> (Threshold Scan Automation) will not disable the spi interface, for its necessarity in tth scan. <br>
Instead, the command for configure the MuTRiG is masked. This mode should only be used in speical debugging scenario. 
</html>"
set_parameter_property SEL_SUBROUTINES LONG_DESCRIPTION $dscpt
set_parameter_property SEL_SUBROUTINES DESCRIPTION $dscpt

add_parameter EN_MCC boolean
set_parameter_property EN_MCC VISIBLE false
set_parameter_property EN_MCC DEFAULT_VALUE true
set_parameter_property EN_MCC DISPLAY_NAME "Use MCC sub-routine"
set_parameter_property EN_MCC ENABLED false
set_parameter_property EN_MCC HDL_PARAMETER false
set_parameter_property EN_MCC DERIVED true

#######################################################
# display items
#######################################################
# ----
add_display_item "" "IP Setting" GROUP ""
add_display_item "IP Setting" CLK_FREQUENCY PARAMETER 
add_display_item "IP Setting" N_MUTRIG PARAMETER 
add_display_item "IP Setting" COUNTER_MM_ADDR_OFFSET_WORD PARAMETER 
add_display_item "IP Setting" DEBUG PARAMETER 
# ----
add_display_item "" "MuTRiG Setting" GROUP ""
add_display_item "MuTRiG Setting" "SPI Setting" GROUP ""
# --
add_display_item "SPI Setting" CPOL PARAMETER 
add_display_item "SPI Setting" CPHA PARAMETER 



########################################################### 
# connection point spi
###########################################################
add_interface controller_clock clock end
set_interface_property controller_clock clockRate 156250000
set_interface_property controller_clock ENABLED true
set_interface_property controller_clock EXPORT_OF ""
set_interface_property controller_clock PORT_NAME_MAP ""
set_interface_property controller_clock CMSIS_SVD_VARIABLES ""
set_interface_property controller_clock SVD_ADDRESS_GROUP ""

add_interface_port controller_clock i_clk clk Input 1


########################################################### 
# connection point controller_reset
########################################################### 
add_interface controller_reset reset end
set_interface_property controller_reset associatedClock controller_clock
set_interface_property controller_reset synchronousEdges DEASSERT
set_interface_property controller_reset ENABLED true
set_interface_property controller_reset EXPORT_OF ""
set_interface_property controller_reset PORT_NAME_MAP ""
set_interface_property controller_reset CMSIS_SVD_VARIABLES ""
set_interface_property controller_reset SVD_ADDRESS_GROUP ""

add_interface_port controller_reset i_rst reset Input 1

add_interface spi_export2top conduit end
set_interface_property spi_export2top associatedClock ""
set_interface_property spi_export2top associatedReset ""
set_interface_property spi_export2top ENABLED true
set_interface_property spi_export2top EXPORT_OF ""
set_interface_property spi_export2top PORT_NAME_MAP ""
set_interface_property spi_export2top CMSIS_SVD_VARIABLES ""
set_interface_property spi_export2top SVD_ADDRESS_GROUP ""

add_interface_port spi_export2top spi_miso miso Input 1
add_interface_port spi_export2top spi_mosi mosi Output 1
add_interface_port spi_export2top spi_sclk sclk Output 1
add_interface_port spi_export2top spi_ssn ssn Output 8


########################################################### 
# connection point schpad
###########################################################  
add_interface avmm_schpad avalon start
set_interface_property avmm_schpad addressUnits WORDS
set_interface_property avmm_schpad associatedClock controller_clock
set_interface_property avmm_schpad associatedReset controller_reset
set_interface_property avmm_schpad bitsPerSymbol 8
set_interface_property avmm_schpad burstOnBurstBoundariesOnly false
set_interface_property avmm_schpad burstcountUnits WORDS
set_interface_property avmm_schpad doStreamReads false
set_interface_property avmm_schpad doStreamWrites false
set_interface_property avmm_schpad holdTime 0
set_interface_property avmm_schpad linewrapBursts false
set_interface_property avmm_schpad maximumPendingReadTransactions 1
set_interface_property avmm_schpad maximumPendingWriteTransactions 0
set_interface_property avmm_schpad readLatency 0
set_interface_property avmm_schpad readWaitTime 1
set_interface_property avmm_schpad setupTime 0
set_interface_property avmm_schpad timingUnits Cycles
set_interface_property avmm_schpad writeWaitTime 0
set_interface_property avmm_schpad ENABLED true
set_interface_property avmm_schpad EXPORT_OF ""
set_interface_property avmm_schpad PORT_NAME_MAP ""
set_interface_property avmm_schpad CMSIS_SVD_VARIABLES ""
set_interface_property avmm_schpad SVD_ADDRESS_GROUP ""

add_interface_port avmm_schpad avm_schpad_address address Output 10
add_interface_port avmm_schpad avm_schpad_read read Output 1
add_interface_port avmm_schpad avm_schpad_readdata readdata Input 32
add_interface_port avmm_schpad avm_schpad_response response Input 2
add_interface_port avmm_schpad avm_schpad_waitrequest waitrequest Input 1
add_interface_port avmm_schpad avm_schpad_readdatavalid readdatavalid Input 1
add_interface_port avmm_schpad avm_schpad_burstcount burstcount Output 8


########################################################### 
# connection point csr
###########################################################  
add_interface avmm_csr avalon end
set_interface_property avmm_csr addressUnits WORDS
set_interface_property avmm_csr associatedClock controller_clock
set_interface_property avmm_csr associatedReset controller_reset
set_interface_property avmm_csr bitsPerSymbol 8
set_interface_property avmm_csr burstOnBurstBoundariesOnly false
set_interface_property avmm_csr burstcountUnits WORDS
set_interface_property avmm_csr explicitAddressSpan 0
set_interface_property avmm_csr holdTime 0
set_interface_property avmm_csr linewrapBursts false
set_interface_property avmm_csr maximumPendingReadTransactions 0
set_interface_property avmm_csr maximumPendingWriteTransactions 0
set_interface_property avmm_csr readLatency 0
set_interface_property avmm_csr readWaitTime 1
set_interface_property avmm_csr setupTime 0
set_interface_property avmm_csr timingUnits Cycles
set_interface_property avmm_csr writeWaitTime 0
set_interface_property avmm_csr ENABLED true
set_interface_property avmm_csr EXPORT_OF ""
set_interface_property avmm_csr PORT_NAME_MAP ""
set_interface_property avmm_csr CMSIS_SVD_VARIABLES ""
set_interface_property avmm_csr SVD_ADDRESS_GROUP ""

add_interface_port avmm_csr avs_csr_address address Input 2
add_interface_port avmm_csr avs_csr_read read Input 1
add_interface_port avmm_csr avs_csr_readdata readdata Output 32
add_interface_port avmm_csr avs_csr_write write Input 1
add_interface_port avmm_csr avs_csr_writedata writedata Input 32
add_interface_port avmm_csr avs_csr_waitrequest waitrequest Output 1
add_interface_port avmm_csr avs_csr_response response Output 2
set_interface_assignment avmm_csr embeddedsw.configuration.isFlash 0
set_interface_assignment avmm_csr embeddedsw.configuration.isMemoryDevice 0
set_interface_assignment avmm_csr embeddedsw.configuration.isNonVolatileStorage 0
set_interface_assignment avmm_csr embeddedsw.configuration.isPrintableDevice 0


########################################################### 
# connection point spi_clock
########################################################### 
add_interface spi_clock clock end
set_interface_property spi_clock clockRate 40000000
set_interface_property spi_clock ENABLED true
set_interface_property spi_clock EXPORT_OF ""
set_interface_property spi_clock PORT_NAME_MAP ""
set_interface_property spi_clock CMSIS_SVD_VARIABLES ""
set_interface_property spi_clock SVD_ADDRESS_GROUP ""

add_interface_port spi_clock i_clk_spi clk Input 1


########################################################### 
# connection point counter
###########################################################  
add_interface avmm_cnt avalon start
set_interface_property avmm_cnt addressUnits WORDS
set_interface_property avmm_cnt associatedClock controller_clock
set_interface_property avmm_cnt associatedReset controller_reset
set_interface_property avmm_cnt bitsPerSymbol 8
set_interface_property avmm_cnt burstOnBurstBoundariesOnly false
set_interface_property avmm_cnt burstcountUnits WORDS
set_interface_property avmm_cnt doStreamReads false
set_interface_property avmm_cnt doStreamWrites false
set_interface_property avmm_cnt holdTime 0
set_interface_property avmm_cnt linewrapBursts false
set_interface_property avmm_cnt maximumPendingReadTransactions 0
set_interface_property avmm_cnt maximumPendingWriteTransactions 0
set_interface_property avmm_cnt readLatency 0
set_interface_property avmm_cnt readWaitTime 1
set_interface_property avmm_cnt setupTime 0
set_interface_property avmm_cnt timingUnits Cycles
set_interface_property avmm_cnt writeWaitTime 0
set_interface_property avmm_cnt ENABLED true
set_interface_property avmm_cnt EXPORT_OF ""
set_interface_property avmm_cnt PORT_NAME_MAP ""
set_interface_property avmm_cnt CMSIS_SVD_VARIABLES ""
set_interface_property avmm_cnt SVD_ADDRESS_GROUP ""

add_interface_port avmm_cnt avm_cnt_address address Output 16
add_interface_port avmm_cnt avm_cnt_read read Output 1
add_interface_port avmm_cnt avm_cnt_waitrequest waitrequest Input 1
add_interface_port avmm_cnt avm_cnt_burstcount burstcount Output 9
add_interface_port avmm_cnt avm_cnt_readdatavalid readdatavalid Input 1
add_interface_port avmm_cnt avm_cnt_response response Input 2
add_interface_port avmm_cnt avm_cnt_readdata readdata Input 32
add_interface_port avmm_cnt avm_cnt_flush flush Output 1


########################################################### 
# connection point scan_result
###########################################################  
add_interface avmm_scanresult avalon end
set_interface_property avmm_scanresult addressUnits WORDS
set_interface_property avmm_scanresult associatedClock controller_clock
set_interface_property avmm_scanresult associatedReset controller_reset
set_interface_property avmm_scanresult bitsPerSymbol 8
set_interface_property avmm_scanresult burstOnBurstBoundariesOnly false
set_interface_property avmm_scanresult burstcountUnits WORDS
set_interface_property avmm_scanresult explicitAddressSpan 0
set_interface_property avmm_scanresult holdTime 0
set_interface_property avmm_scanresult linewrapBursts false
set_interface_property avmm_scanresult maximumPendingReadTransactions 0
set_interface_property avmm_scanresult maximumPendingWriteTransactions 0
set_interface_property avmm_scanresult readLatency 0
set_interface_property avmm_scanresult readWaitTime 1
set_interface_property avmm_scanresult setupTime 0
set_interface_property avmm_scanresult timingUnits Cycles
set_interface_property avmm_scanresult writeWaitTime 0
set_interface_property avmm_scanresult ENABLED true
set_interface_property avmm_scanresult EXPORT_OF ""
set_interface_property avmm_scanresult PORT_NAME_MAP ""
set_interface_property avmm_scanresult CMSIS_SVD_VARIABLES ""
set_interface_property avmm_scanresult SVD_ADDRESS_GROUP ""

add_interface_port avmm_scanresult avs_scanresult_address address Input 14
add_interface_port avmm_scanresult avs_scanresult_read read Input 1
add_interface_port avmm_scanresult avs_scanresult_readdata readdata Output 32
add_interface_port avmm_scanresult avs_scanresult_waitrequest waitrequest Output 1
set_interface_assignment avmm_scanresult embeddedsw.configuration.isFlash 0
set_interface_assignment avmm_scanresult embeddedsw.configuration.isMemoryDevice 0
set_interface_assignment avmm_scanresult embeddedsw.configuration.isNonVolatileStorage 0
set_interface_assignment avmm_scanresult embeddedsw.configuration.isPrintableDevice 0


###########################################################  
# connection point sclr_counter
########################################################### 
add_interface sclr_counter_req reset start
set_interface_property sclr_counter_req associatedClock controller_clock
set_interface_property sclr_counter_req associatedDirectReset ""
set_interface_property sclr_counter_req associatedResetSinks ""
set_interface_property sclr_counter_req synchronousEdges DEASSERT
set_interface_property sclr_counter_req ENABLED true
set_interface_property sclr_counter_req EXPORT_OF ""
set_interface_property sclr_counter_req PORT_NAME_MAP ""
set_interface_property sclr_counter_req CMSIS_SVD_VARIABLES ""
set_interface_property sclr_counter_req SVD_ADDRESS_GROUP ""

add_interface_port sclr_counter_req o_sclr_req reset Output 1

########################################################### 
# connection point spi_reset
########################################################### 
add_interface spi_reset reset end
set_interface_property spi_reset associatedClock spi_clock
set_interface_property spi_reset synchronousEdges DEASSERT
set_interface_property spi_reset ENABLED true
set_interface_property spi_reset EXPORT_OF ""
set_interface_property spi_reset PORT_NAME_MAP ""
set_interface_property spi_reset CMSIS_SVD_VARIABLES ""
set_interface_property spi_reset SVD_ADDRESS_GROUP ""

add_interface_port spi_reset i_rst_spi reset Input 1


################################################
# callbacks
################################################
proc my_elaborate {} {
	# ----
	# derive cfg length 
	switch [get_parameter_value INTENDED_MUTRIG_VERSION] {
		"MuTRiG 1" {
			set_parameter_value MUTRIG_CFG_LENGTH_BIT 2358
		}
		"MuTRiG 2" {
			set_parameter_value MUTRIG_CFG_LENGTH_BIT 2719
		}
		default {
			set_parameter_value MUTRIG_CFG_LENGTH_BIT 2662
		}
	}
	
	# ----
	# set spi clock rate
	set_interface_property spi_clock clockRate [get_parameter_value CLK_FREQUENCY_SPI]
	
	# ----
	# mask interface depending on the available sub-routines 
	# {"2:Use MCC and TSA" "1:Use MCC only" "0:Use TSA only"}
	switch [get_parameter_value SEL_SUBROUTINES] {
		"2" {
			set_interface_property spi_export2top ENABLED true
			set_interface_property avmm_schpad ENABLED true
			set_interface_property avmm_cnt ENABLED true
			set_interface_property avmm_scanresult ENABLED true
			set_interface_property sclr_counter_req ENABLED true
			set_parameter_value "EN_MCC" true
			set_parameter_property COUNTER_MM_ADDR_OFFSET_WORD ENABLED true
		}
		"1" {
			set_interface_property spi_export2top ENABLED true
			set_interface_property avmm_schpad ENABLED true
			# mask avmm_cnt, avmm_scanresult, sclr_counter_req ports
			helper_terminate_avmm_interface avmm_cnt
			helper_terminate_avmm_interface avmm_scanresult
			set_interface_property sclr_counter_req ENABLED false
			set_parameter_value "EN_MCC" true
			set_parameter_property COUNTER_MM_ADDR_OFFSET_WORD ENABLED false
		}
		"0" {
			set_interface_property spi_export2top ENABLED true
			set_interface_property avmm_schpad ENABLED true
			set_interface_property avmm_cnt ENABLED true
			set_interface_property avmm_scanresult ENABLED true
			set_interface_property sclr_counter_req ENABLED true
			set_parameter_value "EN_MCC" false
			set_parameter_property COUNTER_MM_ADDR_OFFSET_WORD ENABLED true
		}		
	}

}

###########################################################################################
#	@berief		Disable this interface and terminate the input ports assosiated
#	@param		name: interfaceName
#	@return		0 (success)
###########################################################################################
proc helper_terminate_avmm_interface {name} {
	set_interface_property $name ENABLED false
	# for its ports, pull-high waitrequest, pull-low other inputs, do not touch outputs
	foreach i [get_interface_ports $name] {
		set_port_property $i termination 1
		if {[string equal [get_port_property $i role] "waitrequest"]} {
			set_port_property $i termination_value "1"
		} elseif {[string equal [get_port_property $i direction] "input"]} {
			set_port_property $i termination_value "0"
		}
	}
	return 0
}
