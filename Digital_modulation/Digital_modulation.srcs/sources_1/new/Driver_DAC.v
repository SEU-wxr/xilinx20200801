`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/07/26 19:57:02
// Design Name: 
// Module Name: Driver_DAC
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


module Driver_DAC(
    input clk_100MHz,
    input clk_DAC,
    input [2:0]Key,
    input DAC_En,
    output reg DAC_Din,
    output reg DAC_Sync,
    output [1:0]LED
    );
    //m seq
    wire m_seq;
    //8-bit address, corresponding to the data in the ROM  
    wire [7:0]Addr_Out;
    //ROM DAC data output
    wire [7:0]DAC_Data_Sin;
    //DAC data
    reg [7:0]DAC_Data=0;
    wire [1:0]Mode;
   
    always @(*) 
        case(Mode)
            //2ASK
            0:
                begin
                     if(m_seq==0)  DAC_Data=0;
                     else    DAC_Data=DAC_Data_Sin;
                end

            default     DAC_Data=DAC_Data_Sin;                     
        endcase
    
    //DAC cycle state machine count
    reg [4:0] DAC_Cnt = 5'd0;
  
    //DAC state machine task execution
    always@(posedge clk_DAC)
        begin
            if(DAC_Cnt == 16)
                DAC_Cnt <= 5'd0;
            else
                DAC_Cnt <= DAC_Cnt + 5'd1;
            case(DAC_Cnt)
                5'd0: DAC_Din <= 1'b0;
                5'd1: DAC_Din <= DAC_Data[7];
                5'd2: DAC_Din <= DAC_Data[6];
                5'd3: DAC_Din <= DAC_Data[5];
                5'd4: DAC_Din <= DAC_Data[4];
                5'd5: DAC_Din <= DAC_Data[3];
                5'd6: DAC_Din <= DAC_Data[2];
                5'd7: DAC_Din <= DAC_Data[1];
                5'd8: DAC_Din <= DAC_Data[0];
                5'd9: DAC_Din <= 1'b0;
                5'd10: DAC_Din <= 1'b0;
                5'd11: DAC_Din <= 1'b0;
                5'd12: DAC_Din <= 1'b0;
                5'd13: DAC_Din <= 1'b0;
                5'd14: DAC_Din <= 1'b0;
                5'd15: begin
                        DAC_Din <= 1'b0;
                        DAC_Sync <= 1'b1;
                       end
                5'd16: begin 
                        DAC_Din <= 1'b0;
                        DAC_Sync <= 1'b0;
                       end
            endcase    
        end
        
    //Phase accumulator module
    DDS_Addr_Generator DDS_Addr_Generator (         
        .clk_DDS(clk_100MHz),
        .Key(Key),        
        .Rst(DAC_En),        
        .Addr_Out(Addr_Out),
        .m_seq(m_seq),
        .Mode(Mode),
        .LED(LED)
     );     
     
    //Sine wave waveform data module        
    Sin_Rom Rom_Sin (       
        .clka(clk_DAC),                 // input wire clka        
        .ena(DAC_En),                   // input wire ena          
        .addra(Addr_Out),               // input wire [7 : 0] addra        
        .douta(DAC_Data_Sin)            // output wire [7 : 0] douta     
    );

endmodule
