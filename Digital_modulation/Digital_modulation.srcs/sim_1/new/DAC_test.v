`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/07/26 20:00:24
// Design Name: 
// Module Name: DAC_test
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


module DAC_test();
    reg clk_100MHz=0;
    reg [2:0]Key=3;         //2ASK:7; 2FSK:6; 2PSK:5; 2DPSK:3;
    wire DAC_Out;

    digital_modulation test(
    .clk_100MHz(clk_100MHz),
    .Key(Key),
    .clk_DAC(),
    .DAC_Din(DAC_Out),
    .DAC_Sync()
    );
    
    initial
        begin
            #20
            Key=7;
        end

    
    always #5 clk_100MHz=~clk_100MHz;

endmodule
