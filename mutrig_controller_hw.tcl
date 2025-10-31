
# 
# mutrig_controller "MuTRiG Controller" 
# Yifeng Wang 2024.08.16.16:25:06
# 
# 24.0.1028 - stable version of MuTRiG controller supporting both MCC and TTH scan
# 25.0.1021 - add ETH scan

###########################################################
# request TCL package from ACDS 16.1
###########################################################
package require qsys 16.1


###########################################################
# module mutrig_controller
###########################################################
set_module_property DESCRIPTION \
"<html>
Performs SPI-configuration and threshold-scan of the MuTRiG ASIC. <br>
<br>
<b>MuTRiG Configuration Controller (MCC)</b>
<ul>
	<li> Handles MuTRiG configuration scheme. </li>
	<li> Data must be loaded to the external scratch-pad RAM.</li>
	<li> External master writes to CSR to initiate the configuration routine. </li> 
	<li><b>Work Flow</b>:</li> 
	<ol>
		<li><i>data mover</i> performs DMA from <b>scratch-pad RAM</b> to asic dedicated <b>cfg-mem</b> </li>
		<li><i>cfg writer</i> performs SPI write to MuTRiG from <b>cfg-mem</b></li>
		<li><i>cfg writer</i> checks the SPI MISO as validation </li>
	</ol>
</ul>
<br>
<b>MuTRiG Threshold Scan Automation(TSA)</b>
<ul>
	<li> Performs T(cmd=0x0140_0000)/E(cmd=0170_0000)-Threshold scan of the selected MuTRiG(s). </li>
	<li> External master writes to CSR to initiate the scan routine. </li>
	<li> <b>Note!!!</b> The TTH scan uses the last configuration as a template when incrementing the TTH value. </li>
	<li><b>Work Flow</b>:</li> 
	<ol>
		<li><i>pattern modifier</i> modifies the content in the cfg-mem </li>
		<li><i>cfg writer</i> performs SPI write to MuTRiG from <b>cfg-mem</b></li>
		<li><i>rate monitor</i> collects the rate from the external counters and stores result into result RAM </li>
	</ol>
</ul>
</html>"
set_module_property NAME mutrig_controller2
set_module_property VERSION 25.0.1021
set_module_property INTERNAL false
set_module_property OPAQUE_ADDRESS_MAP true
set_module_property GROUP "Mu3e Control Plane/Modules"
set_module_property AUTHOR "Yifeng Wang"
set_module_property ICON_PATH ../figures/mu3e_logo.png
set_module_property DISPLAY_NAME "MuTRiG Controller 2"
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
set_parameter_property N_MUTRIG DISPLAY_NAME "Number of MuTRiG"
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
set_parameter_property MUTRIG_CFG_LENGTH_BIT WIDTH ""
set_parameter_property MUTRIG_CFG_LENGTH_BIT TYPE NATURAL
set_parameter_property MUTRIG_CFG_LENGTH_BIT ENABLED true
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
set_parameter_property CLK_FREQUENCY DISPLAY_NAME "Reference clock rate"
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
set_parameter_property COUNTER_MM_ADDR_OFFSET_WORD DEFAULT_VALUE 0x0
set_parameter_property COUNTER_MM_ADDR_OFFSET_WORD DISPLAY_NAME "Base address of the performance counter"
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
set_parameter_property EN_MCC HDL_PARAMETER true
set_parameter_property EN_MCC DERIVED true

#######################################################
# display items
#######################################################
# ----
add_display_item "" "IP Setting" GROUP ""
add_display_item "IP Setting" CLK_FREQUENCY PARAMETER 
add_display_item "IP Setting" CLK_FREQUENCY_SPI PARAMETER 
add_display_item "IP Setting" N_MUTRIG PARAMETER 
add_display_item "IP Setting" COUNTER_MM_ADDR_OFFSET_WORD PARAMETER 
add_display_item "IP Setting" DEBUG PARAMETER 
add_display_item "IP Setting" SEL_SUBROUTINES PARAMETER
# ----
add_display_item "" "MuTRiG Setting" GROUP ""
add_display_item "MuTRiG Setting" INTENDED_MUTRIG_VERSION PARAMETER 
add_display_item "MuTRiG Setting" MUTRIG_CFG_LENGTH_BIT PARAMETER 
add_display_item "MuTRiG Setting" "SPI Setting" GROUP ""
# --
add_display_item "SPI Setting" CPOL PARAMETER 
add_display_item "SPI Setting" CPHA PARAMETER 



########################################################### 
# connection point spi
###########################################################
add_interface spi conduit start
set_interface_property spi associatedClock "spi_clock"
set_interface_property spi associatedReset "spi_reset"
set_interface_property spi ENABLED true
set_interface_property spi EXPORT_OF ""
set_interface_property spi PORT_NAME_MAP ""
set_interface_property spi CMSIS_SVD_VARIABLES ""
set_interface_property spi SVD_ADDRESS_GROUP ""

add_interface_port spi spi_miso miso Input 1
add_interface_port spi spi_mosi mosi Output 1
add_interface_port spi spi_sclk sclk Output 1
add_interface_port spi spi_ssn ssn Output 8


########################################################### 
# connection point schpad
###########################################################  
add_interface schpad avalon start
set_interface_property schpad addressUnits WORDS
set_interface_property schpad associatedClock controller_clock
set_interface_property schpad associatedReset controller_reset
set_interface_property schpad bitsPerSymbol 8
set_interface_property schpad burstOnBurstBoundariesOnly false
set_interface_property schpad burstcountUnits WORDS
set_interface_property schpad doStreamReads false
set_interface_property schpad doStreamWrites false
set_interface_property schpad holdTime 0
set_interface_property schpad linewrapBursts false
set_interface_property schpad maximumPendingReadTransactions 1
set_interface_property schpad maximumPendingWriteTransactions 0
set_interface_property schpad readLatency 0
set_interface_property schpad readWaitTime 1
set_interface_property schpad setupTime 0
set_interface_property schpad timingUnits Cycles
set_interface_property schpad writeWaitTime 0
set_interface_property schpad ENABLED true
set_interface_property schpad EXPORT_OF ""
set_interface_property schpad PORT_NAME_MAP ""
set_interface_property schpad CMSIS_SVD_VARIABLES ""
set_interface_property schpad SVD_ADDRESS_GROUP ""

add_interface_port schpad avm_schpad_address address Output 16
add_interface_port schpad avm_schpad_read read Output 1
add_interface_port schpad avm_schpad_readdata readdata Input 32
add_interface_port schpad avm_schpad_response response Input 2
add_interface_port schpad avm_schpad_waitrequest waitrequest Input 1
add_interface_port schpad avm_schpad_readdatavalid readdatavalid Input 1
add_interface_port schpad avm_schpad_burstcount burstcount Output 8


########################################################### 
# connection point csr
###########################################################  
add_interface csr avalon end
set_interface_property csr addressUnits WORDS
set_interface_property csr associatedClock controller_clock
set_interface_property csr associatedReset controller_reset
set_interface_property csr bitsPerSymbol 8
set_interface_property csr burstOnBurstBoundariesOnly false
set_interface_property csr burstcountUnits WORDS
set_interface_property csr explicitAddressSpan 0
set_interface_property csr holdTime 0
set_interface_property csr linewrapBursts false
set_interface_property csr maximumPendingReadTransactions 0
set_interface_property csr maximumPendingWriteTransactions 0
set_interface_property csr readLatency 0
set_interface_property csr readWaitTime 1
set_interface_property csr setupTime 0
set_interface_property csr timingUnits Cycles
set_interface_property csr writeWaitTime 0
set_interface_property csr ENABLED true
set_interface_property csr EXPORT_OF ""
set_interface_property csr PORT_NAME_MAP ""
set_interface_property csr CMSIS_SVD_VARIABLES ""
set_interface_property csr SVD_ADDRESS_GROUP ""

add_interface_port csr avs_csr_address address Input 2
add_interface_port csr avs_csr_read read Input 1
add_interface_port csr avs_csr_readdata readdata Output 32
add_interface_port csr avs_csr_write write Input 1
add_interface_port csr avs_csr_writedata writedata Input 32
add_interface_port csr avs_csr_waitrequest waitrequest Output 1
add_interface_port csr avs_csr_response response Output 2
set_interface_assignment csr embeddedsw.configuration.isFlash 0
set_interface_assignment csr embeddedsw.configuration.isMemoryDevice 0
set_interface_assignment csr embeddedsw.configuration.isNonVolatileStorage 0
set_interface_assignment csr embeddedsw.configuration.isPrintableDevice 0


########################################################### 
# connection point counter
###########################################################  
add_interface counter avalon start
set_interface_property counter addressUnits WORDS
set_interface_property counter associatedClock controller_clock
set_interface_property counter associatedReset controller_reset
set_interface_property counter bitsPerSymbol 8
set_interface_property counter burstOnBurstBoundariesOnly false
set_interface_property counter burstcountUnits WORDS
set_interface_property counter doStreamReads false
set_interface_property counter doStreamWrites false
set_interface_property counter holdTime 0
set_interface_property counter linewrapBursts false
set_interface_property counter maximumPendingReadTransactions 0
set_interface_property counter maximumPendingWriteTransactions 0
set_interface_property counter readLatency 0
set_interface_property counter readWaitTime 1
set_interface_property counter setupTime 0
set_interface_property counter timingUnits Cycles
set_interface_property counter writeWaitTime 0
set_interface_property counter ENABLED true
set_interface_property counter EXPORT_OF ""
set_interface_property counter PORT_NAME_MAP ""
set_interface_property counter CMSIS_SVD_VARIABLES ""
set_interface_property counter SVD_ADDRESS_GROUP ""

add_interface_port counter avm_cnt_address address Output 16
add_interface_port counter avm_cnt_read read Output 1
add_interface_port counter avm_cnt_waitrequest waitrequest Input 1
add_interface_port counter avm_cnt_burstcount burstcount Output 9
add_interface_port counter avm_cnt_readdatavalid readdatavalid Input 1
add_interface_port counter avm_cnt_response response Input 2
add_interface_port counter avm_cnt_readdata readdata Input 32
add_interface_port counter avm_cnt_flush flush Output 1


########################################################### 
# connection point scan_result
###########################################################  
add_interface scan_result avalon end
set_interface_property scan_result addressUnits WORDS
set_interface_property scan_result associatedClock controller_clock
set_interface_property scan_result associatedReset controller_reset
set_interface_property scan_result bitsPerSymbol 8
set_interface_property scan_result burstOnBurstBoundariesOnly false
set_interface_property scan_result burstcountUnits WORDS
set_interface_property scan_result explicitAddressSpan 0
set_interface_property scan_result holdTime 0
set_interface_property scan_result linewrapBursts false
set_interface_property scan_result maximumPendingReadTransactions 0
set_interface_property scan_result maximumPendingWriteTransactions 0
set_interface_property scan_result readLatency 0
set_interface_property scan_result readWaitTime 1
set_interface_property scan_result setupTime 0
set_interface_property scan_result timingUnits Cycles
set_interface_property scan_result writeWaitTime 0
set_interface_property scan_result ENABLED true
set_interface_property scan_result EXPORT_OF ""
set_interface_property scan_result PORT_NAME_MAP ""
set_interface_property scan_result CMSIS_SVD_VARIABLES ""
set_interface_property scan_result SVD_ADDRESS_GROUP ""

add_interface_port scan_result avs_scanresult_address address Input 14
add_interface_port scan_result avs_scanresult_read read Input 1
add_interface_port scan_result avs_scanresult_readdata readdata Output 32
add_interface_port scan_result avs_scanresult_waitrequest waitrequest Output 1
set_interface_assignment scan_result embeddedsw.configuration.isFlash 0
set_interface_assignment scan_result embeddedsw.configuration.isMemoryDevice 0
set_interface_assignment scan_result embeddedsw.configuration.isNonVolatileStorage 0
set_interface_assignment scan_result embeddedsw.configuration.isPrintableDevice 0


###########################################################  
# connection point sclr_counter
########################################################### 
add_interface sclr_counter reset start
set_interface_property sclr_counter associatedClock controller_clock
set_interface_property sclr_counter associatedDirectReset ""
set_interface_property sclr_counter associatedResetSinks ""
set_interface_property sclr_counter synchronousEdges BOTH
set_interface_property sclr_counter ENABLED true
set_interface_property sclr_counter EXPORT_OF ""
set_interface_property sclr_counter PORT_NAME_MAP ""
set_interface_property sclr_counter CMSIS_SVD_VARIABLES ""
set_interface_property sclr_counter SVD_ADDRESS_GROUP ""

add_interface_port sclr_counter rso_sclr_counter_reset reset Output 1

########################################################### 
# connection point controller_clock
########################################################### 
add_interface controller_clock clock end
set_interface_property controller_clock clockRate 156250000
set_interface_property controller_clock ENABLED true
set_interface_property controller_clock EXPORT_OF ""
set_interface_property controller_clock PORT_NAME_MAP ""
set_interface_property controller_clock CMSIS_SVD_VARIABLES ""
set_interface_property controller_clock SVD_ADDRESS_GROUP ""

add_interface_port controller_clock csi_controller_clock_clk clk Input 1


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

add_interface_port spi_clock csi_spi_clock_clk clk Input 1

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
			set_interface_property spi ENABLED true
			set_interface_property schpad ENABLED true
			set_interface_property counter ENABLED true
			set_interface_property scan_result ENABLED true
			set_interface_property sclr_counter ENABLED true
			set_parameter_value "EN_MCC" true
			set_parameter_property COUNTER_MM_ADDR_OFFSET_WORD ENABLED true
		}
		"1" {
			set_interface_property spi ENABLED true
			set_interface_property schpad ENABLED true
			# mask counter, scan_result, sclr_counter ports
			helper_terminate_avmm_interface counter
			helper_terminate_avmm_interface scan_result
			set_interface_property sclr_counter ENABLED false
			set_parameter_value "EN_MCC" true
			set_parameter_property COUNTER_MM_ADDR_OFFSET_WORD ENABLED false
		}
		"0" {
			set_interface_property spi ENABLED true
			set_interface_property schpad ENABLED true
			set_interface_property counter ENABLED true
			set_interface_property scan_result ENABLED true
			set_interface_property sclr_counter ENABLED true
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

