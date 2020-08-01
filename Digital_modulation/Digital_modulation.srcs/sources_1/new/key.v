`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/07/29 11:35:41
// Design Name: 
// Module Name: key
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


module key(
    input clk,
    /*
    input Key1,
    input Key2,
    input Key3,
    */
    input [2:0]Key,
    output reg [1:0]Mode,
    output reg [1:0]LED
    );
    wire All_Key=Key[0]&&Key[1]&&Key[2];
    reg [2:0]State_Next=0;
    reg [2:0]State_Current=0;
    parameter s0=3'b000;
    parameter s1=3'b001;
    parameter s2=3'b010;
    parameter s3=3'b100;
    always@(posedge clk)     State_Current<=State_Next;
    always@(negedge All_Key)
        begin
            case(State_Current)
                s0: 
                    begin
                        if (!Key[0]&&Key[1]&&Key[2])
                            State_Next=s1;
                        else if(Key[0]&&!Key[1]&&Key[2])
                            State_Next=s2;
                        else    State_Next=s3;
                    end
                s1: 
                    begin
                        if (Key[0]&&!Key[1]&&Key[2])
                            State_Next=s2;
                        else if(Key[0]&&Key[1]&&!Key[2])
                            State_Next=s3;
                        else    State_Next=s0;
                    end
                s2: 
                    begin
                        if (!Key[0]&&Key[1]&&Key[2])
                            State_Next=s1;
                        else if(Key[0]&&Key[1]&&!Key[2])
                            State_Next=s3;
                        else    State_Next=s0;
                    end 
                s3:
                    begin
                        if (Key[0]&&!Key[1]&&Key[2])
                            State_Next=s2;
                        else if(!Key[0]&&Key[1]&&Key[2])
                            State_Next=s1;
                        else    State_Next=s0;
                    end 
                default State_Next=s0;
            endcase
        end
        always@(State_Current)
            case(State_Current)
                s0: 
                    begin
                        Mode[0]<=0;
                        Mode[1]<=0;
                        LED[0]<=0;
                        LED[1]<=0;
                    end
                s1:
                    begin
                        Mode[0]<=1;
                        Mode[1]<=0;
                        LED[0]<=1;
                        LED[1]<=0;
                    end
                s2:
                    begin
                        Mode[0]<=0;
                        Mode[1]<=1;
                        LED[0]<=0;
                        LED[1]<=1;
                    end
                s3:
                    begin
                        Mode[0]<=1;
                        Mode[1]<=1;
                        LED[0]<=1;
                        LED[1]<=1;
                    end
                default 
                    begin
                        Mode[0]<=0;
                        Mode[1]<=0;
                        LED[0]<=0;
                        LED[1]<=0;
                    end
            endcase
endmodule
