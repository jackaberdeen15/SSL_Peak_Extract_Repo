`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.03.2021 14:56:29
// Design Name: 
// Module Name: depth_calc
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


module depth_calc#(parameter bin_size=16, bin_num=1024, index_width=10, count_width=32, histogram_width=bin_num*bin_size, uint32=32, ufix8_8=8, bin_peak_width=5)(
    input wire [histogram_width-1:0] histogram, //[15:0] refers to min bin and [79:64] would be max depending on peak width
    input wire [index_width-1:0] bin_index,
    input wire clk,
    output wire [uint32-1:0] depth_bin_integer, //unsigned 32 bit integer as output
    output wire [ufix8_8-1:0] depth_bin_fraction //ufix8_8 8 bit container for fraction
    /*output wire output__valid,
    output wire [1:0] inputs_valid,
    output wire [31:0] numerator,
    output wire [31:0] denominator
    output wire [7:0] peak_range,
    output wire [1:0] tvalids,
    output wire [5*bin_size:0] peak_histogram,
    output wire is_output_valid,
    output wire [23:0] numerator,
    output wire [23:0] denominator*/
    );
    reg [count_width-1:0] depth_bin_numerator, depth_bin_denominator;
    reg [bin_peak_width*bin_size-1:0] peak_histo;
    wire [count_width-1:0] depth_bin_numerator_wire, depth_bin_denominator_wire;
    reg [3:0] peak_width;
    wire [39:0] divider_output;
    reg [uint32-1:0] integer_output_buffer;
    reg [ufix8_8-1:0] fraction_output_buffer;
    wire output_valid;
    wire divisor_tvalid, dividend_tvalid;
    wire dividend_tready, divisor_tready;
    wire [index_width-1:0] pr,pl;
    //reg [count_width-1:0] add_buffer1,add_buffer2,add_buffer3,add_buffer4;
    
    
    initial begin
        integer_output_buffer=0;
        fraction_output_buffer=0;
        depth_bin_numerator=0;
        depth_bin_denominator=0;
        peak_width=0;
    end
    
    assign pr=(bin_index>(bin_num-3))?bin_num:bin_index+2;
    assign pl=(bin_index<3)?0:bin_index-2;
    
    always @(posedge clk) begin
         peak_width[2:0]=pr[index_width-1:0]-pl[index_width-1:0]+1;
         peak_histo[0*bin_size+:bin_size]=histogram[pl*bin_size+:bin_size];
         peak_histo[1*bin_size+:bin_size]=histogram[(pl+4'd1)*bin_size+:bin_size];
         peak_histo[2*bin_size+:bin_size]=histogram[(pl+4'd2)*bin_size+:bin_size];
         case (peak_width)
            6'd4: peak_histo[3*bin_size+:bin_size]=histogram[(pl+4'd3)*bin_size+:bin_size];
            6'd5: begin
                peak_histo[3*bin_size+:bin_size]=histogram[(pl+4'd3)*bin_size+:bin_size];
                peak_histo[4*bin_size+:bin_size]=histogram[(pr)*bin_size+:bin_size];
                end
            default: peak_histo[3*bin_size+:2*bin_size]=0;
        endcase
            
        
    end
    
    always @(posedge clk) begin
                
        depth_bin_numerator=peak_histo[0+:bin_size]*(pl+1)+peak_histo[1*bin_size+:bin_size]*(pl+1+1)+peak_histo[2*bin_size+:bin_size]*(pl+2+1)+peak_histo[3*bin_size+:bin_size]*(pl+3+1)+peak_histo[4*bin_size+:bin_size]*(pl+4+1);
        depth_bin_denominator=peak_histo[0+:bin_size]+peak_histo[1*bin_size+:bin_size]+peak_histo[2*bin_size+:bin_size]+peak_histo[3*bin_size+:bin_size]+peak_histo[4*bin_size+:bin_size];
    end
    
     
    
    assign depth_bin_numerator_wire=depth_bin_numerator;
    assign depth_bin_denominator_wire=depth_bin_denominator;
    
    assign numerator=depth_bin_numerator;
    assign denominator=depth_bin_denominator;
    
    assign divisor_tvalid=(depth_bin_denominator>0)?1:0;
    assign dividend_tvalid=(depth_bin_numerator>0)?1:0;
    //assign divisor_tready=(depth_bin_denominator>24'd0)?1:0;
    //assign dividend_tready=(depth_bin_numerator>24'd0)?1:0;
    
     
    div_gen_0 divide (
      .aclk(clk),                                      // input wire aclk
      .s_axis_divisor_tvalid(divisor_tvalid),    // input wire s_axis_divisor_tvalid
      .s_axis_divisor_tready(divisor_tready),    // output wire s_axis_divisor_tready
      .s_axis_divisor_tdata(depth_bin_denominator_wire),      // input wire [31 : 0] s_axis_divisor_tdata
      .s_axis_dividend_tvalid(dividend_tvalid),  // input wire s_axis_dividend_tvalid
      .s_axis_dividend_tready(dividend_tready),  // output wire s_axis_dividend_tready
      .s_axis_dividend_tdata(depth_bin_numerator_wire),    // input wire [31 : 0] s_axis_dividend_tdata
      .m_axis_dout_tvalid(output_valid),          // output wire m_axis_dout_tvalid
      .m_axis_dout_tdata(divider_output)            // output wire [39 : 0] m_axis_dout_tdata
    );
    
    always @(posedge clk) begin
        if(output_valid) begin
            integer_output_buffer[31:0]=divider_output[39:8];//[39:8] is exponent, [7:0] is fraction
            fraction_output_buffer[7:0]=divider_output[7:0];//[39:8] is exponent, [7:0] is fraction
        end
    end        
    
    assign depth_bin_integer=integer_output_buffer;
    assign depth_bin_fraction=fraction_output_buffer;
    /*assign output__valid=output_valid;
    assign inputs_valid={divisor_tvalid, dividend_tvalid};*/
   
endmodule
