`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.03.2021 14:56:48
// Design Name: 
// Module Name: top
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


module top #(parameter bin_width=16, bin_num=64, histogram_size=bin_num*bin_width, index_width=6)(
    input [histogram_size-1:0] histogram,
    input clk,
    input reset,
    output wire [31:0] depth_integer,
    output wire [7:0] depth_fraction,
    output wire [index_width-1:0] peak_bin,
    output wire [bin_width-1:0] ambient,
    //output wire [histogram_size-1:0] upd_histogram,
    output wire NaN_flag
    );
    
    wire [bin_width-1:0] ambient_level;
    //wire [histogram_size-1:0] updated_histogram;
    //wire [index_width-1:0] peak_bin;
    
    ambient_calc calc_ambient(
        .histogram(histogram),
        .clk(clk),
        .ambient(ambient_level)
        );
    
    //module to subtract the ambient level from the histogram
    /*ambient_sub sub_ambient(
        .in_hist(histogram),
        .median(ambient_level),
        .clk(clk),
        .out_hist(updated_histogram)
        );*/
    
    //finds the bin with the highest photon count
    full_compare extract_peak(
        .histogram(histogram),
        .median(ambient_level),
        .clk(clk),
        .max_bin_index(peak_bin),
        .NaN_flag(NaN_flag)
        );
    
    //calculates the depth bin and outputs it as a float    
    depth_calc depth_extraction(
        .histogram(histogram),
        .bin_index(peak_bin),
        .clk(clk),
        .depth_bin_integer(depth_integer),
        .depth_bin_fraction(depth_fraction)
        );   
    
    //assign bin=peak_bin;
    assign ambient=ambient_level;
    //assign upd_histogram=updated_histogram;
    
endmodule
