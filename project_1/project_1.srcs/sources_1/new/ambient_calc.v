`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.03.2021 14:56:29
// Design Name: 
// Module Name: ambient_calc
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


module ambient_calc #(parameter bin_width=16, bin_num=64, ambient_bin_num=64, histogram_width=bin_num*bin_width, count_width=24)(
    input wire [histogram_width-1:0] histogram,
    input wire clk, //clock
    output wire [bin_width-1:0] ambient  
    );
    
    reg [bin_width-1:0] ambient_value;
    wire [count_width-1:0] total_photons;
    wire [12:0] bin_number;
    wire dividend_tvalid;
    wire dividend_tready, divisor_tready;
    wire [39:0] divider_output;
    wire divider_output_valid;
    wire [ambient_bin_num*bin_width-1:0]ambient_histogram;
    
    initial ambient_value=0;
    
    assign ambient_histogram[ambient_bin_num*bin_width-1:0]=histogram[ambient_bin_num*bin_width-1:0];
    wire [bin_width:0] added_bins_32[(ambient_bin_num>>1)-1:0];
    
   //32 additions
    genvar i;
    generate
        for(i=0; i<ambient_bin_num;i=i+2) begin : gen_compare_32
            assign added_bins_32[i>>1]=ambient_histogram[i*bin_width+:bin_width]+ambient_histogram[(i+1)*bin_width+:bin_width];        
        end 
    endgenerate
    
    wire [bin_width+1:0] added_bins_16[(bin_num>>2)-1:0];
    
    //16 additions
    generate
        for(i=0; i<ambient_bin_num>>1;i=i+2) begin : gen_compare_16
            assign added_bins_16[i>>1]=added_bins_32[i]+added_bins_32[i+1];        
        end 
    endgenerate
    
    wire [bin_width+2:0] added_bins_8[(bin_num>>3)-1:0];
    
    //8 additions
    generate
        for(i=0; i<ambient_bin_num>>2;i=i+2) begin : gen_compare_8
            assign added_bins_8[i>>1]=added_bins_16[i]+added_bins_16[i+1];        
        end 
    endgenerate
    
    wire [bin_width+3:0] added_bins_4[(bin_num>>4)-1:0];
    
    //4 additions
    generate
        for(i=0; i<ambient_bin_num>>3;i=i+2) begin : gen_compare_4
            assign added_bins_4[i>>1]=added_bins_8[i]+added_bins_8[i+1];        
        end 
    endgenerate
    
    wire [bin_width+4:0] added_bins_2[(bin_num>>5)-1:0];
    
    //2 additions
    generate
        for(i=0; i<ambient_bin_num>>4;i=i+2) begin : gen_compare_2
            assign added_bins_2[i>>1]=added_bins_4[i]+added_bins_4[i+1];        
        end 
    endgenerate
    
    assign total_photons=added_bins_2[0]+added_bins_2[1];
    assign dividend_tvalid=total_photons>0?1:0;
    
    /*div_gen_1 ambient_divide (
      .aclk(clk),                                      // input wire aclk
      .s_axis_divisor_tvalid(1'd1),    // input wire s_axis_divisor_tvalid
      .s_axis_divisor_tready(divisor_tready),    // output wire s_axis_divisor_tready
      .s_axis_divisor_tdata(16'd64),      // input wire [15 : 0] s_axis_divisor_tdata
      .s_axis_dividend_tvalid(dividend_tvalid),  // input wire s_axis_dividend_tvalid
      .s_axis_dividend_tready(dividend_tready),  // output wire s_axis_dividend_tready
      .s_axis_dividend_tdata(total_photons),    // input wire [21 : 0] s_axis_dividend_tdata
      .m_axis_dout_tvalid(divider_output_valid),          // output wire m_axis_dout_tvalid
      .m_axis_dout_tdata(divider_output)            // output wire [39 : 0] m_axis_dout_tdata
    );*/
    
    always @(total_photons)
        if(dividend_tvalid)
            ambient_value=total_photons>>6;
        /*if(divider_output_valid)
             ambient_value=divider_output[31:16];*/
             
    assign ambient=ambient_value;     
  
endmodule
