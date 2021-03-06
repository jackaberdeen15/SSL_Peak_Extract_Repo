# 
# Synthesis run script generated by Vivado
# 

namespace eval rt {
    variable rc
}
set rt::rc [catch {
  uplevel #0 {
    set ::env(BUILTIN_SYNTH) true
    source $::env(HRT_TCL_PATH)/rtSynthPrep.tcl
    rt::HARTNDb_startJobStats
    set rt::cmdEcho 0
    rt::set_parameter writeXmsg true
    rt::set_parameter enableParallelHelperSpawn true
    set ::env(RT_TMP) "C:/Users/u39jm15/AppData/Roaming/Xilinx/Vivado/Projects/SSL_Peak_Extract_Repo/project_1/project_1.runs/synth_1/.Xil/Vivado-10680-DESKTOP-1GSCE32/realtime/tmp"
    if { [ info exists ::env(RT_TMP) ] } {
      file mkdir $::env(RT_TMP)
    }

    rt::delete_design

    rt::set_parameter datapathDensePacking false
    set rt::partid xc7k160tffg676-3
     file delete -force synth_hints.os

    set rt::multiChipSynthesisFlow false
    source $::env(SYNTH_COMMON)/common.tcl
    set rt::defaultWorkLibName xil_defaultlib

    # Skipping read_* RTL commands because this is post-elab optimize flow
    set rt::useElabCache true
    if {$rt::useElabCache == false} {
      rt::read_verilog {
      C:/Users/u39jm15/AppData/Roaming/Xilinx/Vivado/Projects/SSL_Peak_Extract_Repo/project_1/project_1.runs/synth_1/.Xil/Vivado-10680-DESKTOP-1GSCE32/realtime/cordic_0_stub.v
      C:/Users/u39jm15/AppData/Roaming/Xilinx/Vivado/Projects/SSL_Peak_Extract_Repo/project_1/project_1.runs/synth_1/.Xil/Vivado-10680-DESKTOP-1GSCE32/realtime/div_gen_0_stub.v
      C:/Users/u39jm15/AppData/Roaming/Xilinx/Vivado/Projects/SSL_Peak_Extract_Repo/project_1/project_1.srcs/sources_1/new/ambient_calc.v
      C:/Users/u39jm15/AppData/Roaming/Xilinx/Vivado/Projects/SSL_Peak_Extract_Repo/project_1/project_1.srcs/sources_1/new/depth_calc.v
      C:/Users/u39jm15/AppData/Roaming/Xilinx/Vivado/Projects/SSL_Peak_Extract_Repo/project_1/project_1.srcs/sources_1/new/full_compare.v
      C:/Users/u39jm15/AppData/Roaming/Xilinx/Vivado/Projects/SSL_Peak_Extract_Repo/project_1/project_1.srcs/sources_1/new/peak_removal.v
      C:/Users/u39jm15/AppData/Roaming/Xilinx/Vivado/Projects/SSL_Peak_Extract_Repo/project_1/project_1.srcs/sources_1/new/single_compare.v
      C:/Users/u39jm15/AppData/Roaming/Xilinx/Vivado/Projects/SSL_Peak_Extract_Repo/project_1/project_1.srcs/sources_1/new/top.v
    }
      rt::filesetChecksum
    }
    rt::set_parameter usePostFindUniquification true
    set rt::SDCFileList C:/Users/u39jm15/AppData/Roaming/Xilinx/Vivado/Projects/SSL_Peak_Extract_Repo/project_1/project_1.runs/synth_1/.Xil/Vivado-10680-DESKTOP-1GSCE32/realtime/top_synth.xdc
    rt::sdcChecksum
    set rt::top top
    rt::set_parameter enableIncremental true
    rt::set_parameter markDebugPreservationLevel "enable"
    set rt::reportTiming false
    rt::set_parameter elaborateOnly false
    rt::set_parameter elaborateRtl false
    rt::set_parameter eliminateRedundantBitOperator true
    rt::set_parameter elaborateRtlOnlyFlow false
    rt::set_parameter writeBlackboxInterface true
    rt::set_parameter ramStyle auto
    rt::set_parameter merge_flipflops true
# MODE: 
    rt::set_parameter webTalkPath {C:/Users/u39jm15/AppData/Roaming/Xilinx/Vivado/Projects/SSL_Peak_Extract_Repo/project_1/project_1.cache/wt}
    rt::set_parameter synthDebugLog false
    rt::set_parameter printModuleName false
    rt::set_parameter enableSplitFlowPath "C:/Users/u39jm15/AppData/Roaming/Xilinx/Vivado/Projects/SSL_Peak_Extract_Repo/project_1/project_1.runs/synth_1/.Xil/Vivado-10680-DESKTOP-1GSCE32/"
    set ok_to_delete_rt_tmp true 
    if { [rt::get_parameter parallelDebug] } { 
       set ok_to_delete_rt_tmp false 
    } 
    if {$rt::useElabCache == false} {
        set oldMIITMVal [rt::get_parameter maxInputIncreaseToMerge]; rt::set_parameter maxInputIncreaseToMerge 1000
        set oldCDPCRL [rt::get_parameter createDfgPartConstrRecurLimit]; rt::set_parameter createDfgPartConstrRecurLimit 1
        $rt::db readXRFFile
      rt::run_synthesis -module $rt::top
        rt::set_parameter maxInputIncreaseToMerge $oldMIITMVal
        rt::set_parameter createDfgPartConstrRecurLimit $oldCDPCRL
    }

    set rt::flowresult [ source $::env(SYNTH_COMMON)/flow.tcl ]
    rt::HARTNDb_stopJobStats
    rt::HARTNDb_reportJobStats "Synthesis Optimization Runtime"
    rt::HARTNDb_stopSystemStats
    if { $rt::flowresult == 1 } { return -code error }


  set hsKey [rt::get_parameter helper_shm_key] 
  if { $hsKey != "" && [info exists ::env(BUILTIN_SYNTH)] && [rt::get_parameter enableParallelHelperSpawn] } { 
     $rt::db killSynthHelper $hsKey
  } 
  rt::set_parameter helper_shm_key "" 
    if { [ info exists ::env(RT_TMP) ] } {
      if { [info exists ok_to_delete_rt_tmp] && $ok_to_delete_rt_tmp } { 
        file delete -force $::env(RT_TMP)
      }
    }

    source $::env(HRT_TCL_PATH)/rtSynthCleanup.tcl
  } ; #end uplevel
} rt::result]

if { $rt::rc } {
  $rt::db resetHdlParse
  set hsKey [rt::get_parameter helper_shm_key] 
  if { $hsKey != "" && [info exists ::env(BUILTIN_SYNTH)] && [rt::get_parameter enableParallelHelperSpawn] } { 
     $rt::db killSynthHelper $hsKey
  } 
  source $::env(HRT_TCL_PATH)/rtSynthCleanup.tcl
  return -code "error" $rt::result
}
