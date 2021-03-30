`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 27.03.2021 15:18:21
// Design Name: 
// Module Name: depth_calc_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module depth_calc_tb(
    );
    
    //inputs
    reg [64*16-1:0] histogram; //[15:0] refers to min bin and [79:64] would be max depending on peak width
    reg [6-1:0] bin_index;
    reg clk;
    parameter CLOCK_PERIOD=10;
    
    //outputs
    wire output_valid;
    wire [1:0] inputs_valid;
    wire [32-1:0] depth_bin_integer; //unsigned 32 bit integer as output
    wire [8-1:0] depth_bin_fraction; //ufix8_8 8 bit container for fraction
    wire [31:0] numerator, denominator;
    
    //unit under test
    depth_calc uut(
        .histogram(histogram),
        .bin_index(bin_index),
        .clk(clk),
        .depth_bin_integer(depth_bin_integer),
        .depth_bin_fraction(depth_bin_fraction),
        .output__valid(output_valid),
        .inputs_valid(inputs_valid),
        .numerator(numerator),
        .denominator(denominator)
        );
    
    initial begin
        clk=0;
        forever #(CLOCK_PERIOD/2) clk=~clk;
    end
    
    initial begin
        histogram=0;
        bin_index=0;
        #1000 histogram[16*16-1:0] = {16'd15, 16'd10, 16'd23, 16'd190, 16'd56, 16'd2000, 16'd700, 16'd900, 16'd56, 16'd789, 16'd9900, 16'd16, 16'd415, 16'd158, 16'd165, 16'd175};
        //median = 16'd973;
        //median = d973 or h3CD
        bin_index = 5;
        //first peak photon count = d8927 or h22df
        //second peak photon count = d1027 or h0403
        #1000 histogram[16*16-1:0] = {16'd60, 16'd110, 16'd30, 16'd0, 16'd0, 16'd0, 16'd0, 16'd0, 16'd0, 16'd54, 16'd82, 16'd102, 16'd63, 16'd27, 16'd0, 16'd0};
        //median = 16'd33;
        //median = d33 or h21
        bin_index = 14;
        //depth bin = 5.22 or 15 if not dual peak
        //first peak photon count = d104 or h0068
        //second peak photon count = d169 or h00a9
        #1000 histogram[16*16-1:0] = {16'd28, 16'd126, 16'd300, 16'd89, 16'd0, 16'd0, 16'd0, 16'd0, 16'd0, 16'd0, 16'd0, 16'd30, 16'd400, 16'd134, 16'd45, 16'd500};
        //median = 16'd103;
        //median = d103 or h67
        bin_index = 0;
        //depth bin = 1 
        //first peak photon count = d428 or h01ac
        //second peak photon count = d297 or h0129
        #1000 histogram[16*16-1:0] = {16'd0, 16'd0, 16'd0, 16'd0, 16'd1700, 16'd1500, 16'd3600, 16'd2750, 16'd3240, 16'd0, 16'd0, 16'd0, 16'd0, 16'd0, 16'd0, 16'd0};
        //median = 16'd799;
        //median = 799 or h31F
        bin_index = 9;
        //depth bin = 9.66
        //first peak photon count = d8795 or h225b
        //second peak photon count = d0 or h0000
        #1000 histogram[16*16-1:0] = {16'd0, 16'd0, 16'd0, 16'd0, 16'd0, 16'd0, 16'd0, 16'd0, 16'd0, 16'd1000, 16'd0, 16'd0, 16'd0, 16'd0, 16'd0, 16'd0};
        //median = 16'd799;
        //median = 62 or 3E
        bin_index = 6;
        //depth bin = 7 (6)
        //first peak photon count = d938 or h3AA
        //second peak photon count = NaN
        #1000 histogram[16*16-1:0] = {16'd0, 16'd0, 16'd0, 16'd0, 16'd0, 16'd0, 16'd0, 16'd0, 16'd0, 16'd0, 16'd0, 16'd0, 16'd0, 16'd0, 16'd0, 16'd0};
        //median = 0;
        //median = 0
        bin_index = 0;
        //depth bin = 0
        //first peak photon count = NaN
        //second peak photon count = NaN
        #1000 $finish;
    
    end
endmodule