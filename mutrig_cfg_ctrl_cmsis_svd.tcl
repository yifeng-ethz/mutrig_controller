package require Tcl 8.5

set script_dir [file dirname [info script]]
set helper_file [file normalize [file join $script_dir .. dashboard_infra cmsis_svd lib mu3e_cmsis_svd.tcl]]
source $helper_file

namespace eval ::mu3e::cmsis::spec {}

proc ::mu3e::cmsis::spec::build_device {} {
    set registers [list \
        [::mu3e::cmsis::svd::register OPCODE_STATUS 0x00 \
            -description {MuTRiG command/status word. Writes latch a 32-bit opcode. Reads return zero while idle; while busy, bits [31:16] echo opcode[31:16] and bits [15:0] return the controller status word.} \
            -access read-write \
            -fields [list [::mu3e::cmsis::svd::field value 0 32 -description {Raw mixed read/write command and status word.} -access read-write]]] \
        [::mu3e::cmsis::svd::register OFFSET 0x04 \
            -description {Scratchpad/configuration memory offset word used by the MuTRiG controller RPC engine.} \
            -access read-write \
            -fields [list [::mu3e::cmsis::svd::field value 0 32 -description {Raw 32-bit offset word.} -access read-write]]] \
        [::mu3e::cmsis::svd::register MONITOR_SECONDS 0x08 \
            -description {Monitor integration interval in seconds for the MuTRiG controller counter logic.} \
            -access read-write \
            -fields [list \
                [::mu3e::cmsis::svd::field seconds 0 16 -description {Monitor interval in seconds.} -access read-write] \
                [::mu3e::cmsis::svd::field reserved 16 16 -description {Reserved, read as zero.} -access read-only]]] \
        [::mu3e::cmsis::svd::register RESERVED3 0x0C \
            -description {Reserved fourth CSR word. Reads return zero. Writes are ignored.} \
            -access read-write \
            -fields [list [::mu3e::cmsis::svd::field value 0 32 -description {Reserved raw word.} -access read-write]]]]

    return [::mu3e::cmsis::svd::device MU3E_MUTRIG_CFG_CTRL \
        -version 24.0.817 \
        -description {CMSIS-SVD description of the MuTRiG controller CSR aperture. BaseAddress is 0 because this file describes the relative CSR aperture of the IP; system integration supplies the live slave base address.} \
        -peripherals [list \
            [::mu3e::cmsis::svd::peripheral MUTRIG_CFG_CTRL_CSR 0x0 \
                -description {Relative 4-word command/status aperture for the MuTRiG controller.} \
                -groupName MU3E_MUTRIG \
                -addressBlockSize 0x10 \
                -registers $registers]]]
}

if {[info exists ::argv0] &&
    [file normalize $::argv0] eq [file normalize [info script]]} {
    set out_path [file join $script_dir mutrig_cfg_ctrl.svd]
    if {[llength $::argv] >= 1} {
        set out_path [lindex $::argv 0]
    }
    ::mu3e::cmsis::svd::write_device_file \
        [::mu3e::cmsis::spec::build_device] $out_path
}
