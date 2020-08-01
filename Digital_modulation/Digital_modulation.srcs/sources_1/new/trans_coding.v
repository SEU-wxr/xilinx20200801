`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/07/27 18:40:18
// Design Name: 
// Module Name: trans_coding
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


module trans_coding(
    input clk_1kHz,
    input clk_in,
    output clk_now
    );    
    
	reg dpsk_code_reg=0;
    always@(negedge clk_1kHz)  
        dpsk_code_reg<=dpsk_code_reg^ clk_in;
    assign clk_now=dpsk_code_reg;
            
endmodule

