// Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2020.2 (win64) Build 3064766 Wed Nov 18 09:12:45 MST 2020
// Date        : Tue Mar 23 10:38:24 2021
// Host        : DESKTOP-1GSCE32 running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub -rename_top decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix -prefix
//               decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_ div_gen_1_stub.v
// Design      : div_gen_1
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7k160tffg676-3
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "div_gen_v5_1_17,Vivado 2020.2" *)
module decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix(aclk, s_axis_divisor_tvalid, 
  s_axis_divisor_tready, s_axis_divisor_tdata, s_axis_dividend_tvalid, 
  s_axis_dividend_tready, s_axis_dividend_tdata, m_axis_dout_tvalid, m_axis_dout_tdata)
/* synthesis syn_black_box black_box_pad_pin="aclk,s_axis_divisor_tvalid,s_axis_divisor_tready,s_axis_divisor_tdata[15:0],s_axis_dividend_tvalid,s_axis_dividend_tready,s_axis_dividend_tdata[23:0],m_axis_dout_tvalid,m_axis_dout_tdata[39:0]" */;
  input aclk;
  input s_axis_divisor_tvalid;
  output s_axis_divisor_tready;
  input [15:0]s_axis_divisor_tdata;
  input s_axis_dividend_tvalid;
  output s_axis_dividend_tready;
  input [23:0]s_axis_dividend_tdata;
  output m_axis_dout_tvalid;
  output [39:0]m_axis_dout_tdata;
endmodule
