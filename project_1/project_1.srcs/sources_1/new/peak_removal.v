`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 30.03.2021 15:21:29
// Design Name: 
// Module Name: peak_removal
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


module peak_removal#(parameter bin_width=16, bin_num=1024, histogram_width=bin_num*bin_width, index_width=10)(
    input wire [histogram_width-1:0] histogram, // uint_16 bin values
    input wire [index_width-1:0] peak_index,
    input wire clk, //clock
    output wire [histogram_width-1:0] new_histogram
    );
    wire [index_width-1:0] pr,pl;
    reg [histogram_width-1:0] histogram_buffer;
    
    assign pr=(peak_index>(bin_num-3))?bin_num:peak_index+2;
    assign pl=(peak_index<3)?0:peak_index-2;
    
    always @* begin
        histogram_buffer<=histogram;
        histogram_buffer[pl*bin_width+:5*bin_width]<=0;
    end
    
    assign new_histogram=histogram_buffer;
    
endmodule
