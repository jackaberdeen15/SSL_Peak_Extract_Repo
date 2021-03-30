`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.03.2021 14:56:29
// Design Name: 
// Module Name: single_compare
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


module single_compare#(parameter bin_size=16, index_width=6)(
    input wire [bin_size-1:0] bin1_value, 
    input wire [index_width-1:0] bin1_index,
    input wire [bin_size-1:0] bin2_value,
    input wire [index_width-1:0] bin2_index,
    //input wire clk, //clock
    output wire [bin_size-1:0] max_bin_value,
    output wire [index_width-1:0] max_bin_index
    );
        
    assign max_bin_value=(bin1_value>bin2_value)? bin1_value:bin2_value;
    assign max_bin_index=(bin1_value>bin2_value)? bin1_index:bin2_index;
    
endmodule
