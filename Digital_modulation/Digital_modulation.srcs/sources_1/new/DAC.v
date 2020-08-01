`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/07/26 19:58:32
// Design Name: 
// Module Name: DAC
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


module digital_modulation(
    input clk_100MHz,
    input [2:0]Key,     //7:2ASK; 6:2FSK; 5:2PSK; 3:2DPSK;
    output clk_DAC,
    output DAC_Din,
    output DAC_Sync,
    output [1:0]LED
    );
   //Defining clock
   wire clk_100MHz_System;
   //Frequency divider
   clk_wiz_0 clk_division(.clk_out1(clk_DAC),.clk_out2(clk_100MHz_System),.clk_in1(clk_100MHz));
   //DAC driver instantiation
   Driver_DAC Driver_DAC1(
        .clk_100MHz(clk_100MHz_System),
        .clk_DAC(clk_DAC),
        .DAC_En(1),
        .Key(Key),
        .DAC_Din(DAC_Din),
        .DAC_Sync(DAC_Sync),
        .LED(LED)
        );
       
endmodule
