`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.03.2021 14:56:29
// Design Name: 
// Module Name: full_compare
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


module full_compare#(parameter bin_width=16, bin_num=64, histogram_width=bin_num*bin_width, index_width=6)(
    input wire [histogram_width-1:0] histogram, // uint_16 bin values
    input wire [bin_width-1:0] median, 
    input wire clk, //clock
    output wire [index_width-1:0] max_bin_index, //index of which bin has the max value
    output wire NaN_flag
    );
    
    wire [bin_width-1:0] winner_bins_values_1024[(bin_num>>1)-1:0];
    wire [index_width-1:0] winner_bins_indexs_1024[(bin_num>>1)-1:0];
    wire tvalid;
    wire tready;
    wire output_valid;
    wire [bin_width-1:0] square_root;
    reg [8:0] square_root_buffer;
    
    reg [bin_width-1:0] photon_count_buffer;
    //wire [bin_width-1:0] photon_count;
    reg [index_width-1:0] bin_buffer;
    //wire [index_width-1:0] bin;
    reg NaN1,NaN2;
    //reg aresetn;
    
    initial begin
        square_root_buffer=0;
        photon_count_buffer=0;
        bin_buffer=0;
        NaN1=0;
        NaN2=0;
        //aresetn=0;
    end
    
    always@(*) begin
        if(histogram==0) begin 
            NaN2=1;
        end
        else NaN2=0;
        
        //aresetn=1;
    end
    
    assign tvalid=(median>0)? 1:0;
    
    //get sqrt(b)
    cordic_0 square_root_photon_count (
      //.aclk(clk),                                        // input wire aclk
      .s_axis_cartesian_tvalid(tvalid),  // input wire s_axis_cartesian_tvalid
      .s_axis_cartesian_tdata(median),    // input wire [15 : 0] s_axis_cartesian_tdata
      .m_axis_dout_tvalid(output_valid),            // output wire m_axis_dout_tvalid
      .m_axis_dout_tdata(square_root)              // output wire [15 : 0] m_axis_dout_tdata
    );
    
    wire [bin_width-1:0] winner_bins_values_32[(bin_num>>1)-1:0];
    wire [index_width-1:0] winner_bins_indexs_32[(bin_num>>1)-1:0];
    
    genvar i;
    // 32 comparisons
    generate
        for(i=0; i<bin_num;i=i+2) begin : gen_compare_32
        
        single_compare c1(
                        histogram[i*bin_width +:bin_width],
                        i[index_width-1:0],
                        histogram[(i+1)*bin_width +:bin_width],
                        i[index_width-1:0]+1'd1,
                        winner_bins_values_32[i>>1],
                        winner_bins_indexs_32[i>>1]
                        );
        end 
    endgenerate
    
    wire [bin_width-1:0] winner_bins_values_16[(bin_num>>2)-1:0];
    wire [index_width-1:0] winner_bins_indexs_16[(bin_num>>2)-1:0];
    
    // 16 comparisons
    generate
        for(i=0; i<bin_num>>1;i=i+2) begin : gen_compare_16
        
        single_compare c1(
                        winner_bins_values_32[i],
                        winner_bins_indexs_32[i],
                        winner_bins_values_32[i+1],
                        winner_bins_indexs_32[i+1],
                        winner_bins_values_16[i>>1],
                        winner_bins_indexs_16[i>>1]
                        );
        end 
    endgenerate
    
    wire [bin_width-1:0] winner_bins_values_8[(bin_num>>3)-1:0];
    wire [index_width-1:0] winner_bins_indexs_8[(bin_num>>3)-1:0];
    
    // 8 comparisons
    generate
        for(i=0; i<bin_num>>2;i=i+2) begin : gen_compare_8
        
        single_compare c1(
                        winner_bins_values_16[i],
                        winner_bins_indexs_16[i],
                        winner_bins_values_16[i+1],
                        winner_bins_indexs_16[i+1],
                        winner_bins_values_8[i>>1],
                        winner_bins_indexs_8[i>>1]
                        );
        end 
    endgenerate
    
    wire [bin_width-1:0] winner_bins_values_4[(bin_num>>4)-1:0];
    wire [index_width-1:0] winner_bins_indexs_4[(bin_num>>4)-1:0];
    
    // 4 comparisons
    generate
        for(i=0; i<bin_num>>3;i=i+2) begin : gen_compare_4
        
        single_compare c1(
                        winner_bins_values_8[i],
                        winner_bins_indexs_8[i],
                        winner_bins_values_8[i+1],
                        winner_bins_indexs_8[i+1],
                        winner_bins_values_4[i>>1],
                        winner_bins_indexs_4[i>>1]
                        );
        end 
    endgenerate
    
    wire [bin_width-1:0] winner_bins_values_2[(bin_num>>5)-1:0];
    wire [index_width-1:0] winner_bins_indexs_2[(bin_num>>5)-1:0];
    
    // 2 comparisons
    generate
        for(i=0; i<bin_num>>4;i=i+2) begin : gen_compare_2
        
        single_compare c1(
                        winner_bins_values_4[i],
                        winner_bins_indexs_4[i],
                        winner_bins_values_4[i+1],
                        winner_bins_indexs_4[i+1],
                        winner_bins_values_2[i>>1],
                        winner_bins_indexs_2[i>>1]
                        );
        end 
    endgenerate
    
    wire [bin_width-1:0] winner_bins_values_1;
    wire [index_width-1:0] winner_bins_indexs_1;
    
    single_compare c1(
                        winner_bins_values_2[0],
                        winner_bins_indexs_2[0],
                        winner_bins_values_2[1],
                        winner_bins_indexs_2[1],
                        winner_bins_values_1,
                        winner_bins_indexs_1
                        );
    
    always @(*) begin
        square_root_buffer=square_root[8:0];
        photon_count_buffer=winner_bins_values_1;
        
        //check winning bin has value greater than threshold of b+4*sqrt(b)
        NaN1=(photon_count_buffer>=median+4*(square_root_buffer))?0:1;
        
        if(output_valid&~NaN_flag) begin
            
            bin_buffer=winner_bins_indexs_1;
            
        end
        //aresetn=0;
    end
    
    
    assign NaN_flag=NaN1|NaN2;
    assign max_bin_index=bin_buffer;
    
endmodule
