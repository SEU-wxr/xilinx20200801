`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/07/26 19:53:21
// Design Name: 
// Module Name: DDS_Addr_Generator
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


module DDS_Addr_Generator(
    input clk_DDS,              //System clock
    input Rst,                  //Low level reset
    input [2:0]Key,
    output [7:0]Addr_Out,        //Output address, corresponding to the data in the ROM
    output wire m_seq,
    output [1:0]Mode,
    output [1:0]LED
    );
    parameter NWORD=256;
    parameter Baseband_Freq=100000;
    //baseband clock
    wire clk_1kHz;
   // wire [1:0]Mode;
    
    key mode(
    .clk(clk_DDS),
    .Key(Key),
    .Mode(Mode),
    .LED(LED)
    );


    //random sequence generator
    m_ser m1(
    .clk_1kHz(clk_1kHz),
    .m_seq(m_seq)
    );
    //2DPSK code translation
    wire m_seq_trans;
    trans_coding trans1(
    .clk_1kHz(clk_1kHz),
    .clk_in(m_seq), 
    .clk_now(m_seq_trans)
    );
  
    reg [30:0]FWORD;
    reg [7:0]PWORD;     //Phase control word (x/360)*256
    always@(*)
        case(Mode)
            //2FSK
            1:
                begin
                    if(m_seq==0)
                        begin  
                            FWORD= 100000000/(5000*256);           //f2
                            PWORD=(90*NWORD)/360;
                        end
                    else    
                        begin
                            FWORD= 100000000/(2500*256);            //f1
                            PWORD=(90*NWORD)/360;
                        end                       
                end
             //2PSK
             2:
                begin
                    if(m_seq==0)
                        begin  
                            FWORD= 100000000/(2500*256);
                            PWORD=0;//0                                
                        end
                    else    
                        begin
                            FWORD= 100000000/(2500*256);
                            PWORD=(180*NWORD)/360;
                        end  
                end
              //2DPSK
              3:
                    begin
                        if(m_seq_trans==0)
                        begin  
                            FWORD= 100000000/(2500*256);
                            PWORD=0;
                        end
                    else    
                        begin
                            FWORD= 100000000/(2500*256);
                            PWORD=(180*NWORD)/360;
                        end  
                    end
                 //2ASK  
            default      
                 begin
                    FWORD= 100000000/(2500*256);
                    PWORD=(90*NWORD)/360;
                 end
         endcase
    
    wire clk_out;
    reg [7:0]Addr_Cnt=0; 
   
    //Frequency divider
    Clk_Division Clk_Division_0 (
      .clk_100MHz(clk_DDS),  // input wire clk_100MHz
      .clk_mode(FWORD),      // input wire [30 : 0] clk_mode
      .clk_out(clk_out)      // output wire clk_out
    );
    
    Clk_Division Clk_Division_1 (
      .clk_100MHz(clk_DDS),  // input wire clk_100MHz
      .clk_mode(Baseband_Freq),      // input wire [30 : 0] clk_mode
      .clk_out(clk_1kHz)      // output wire clk_out
    );
    
    //Count
    always @ (posedge clk_out or negedge Rst)
        begin
            if (!Rst)
                Addr_Cnt <= 0;  
            else
                Addr_Cnt <= Addr_Cnt + 1;   
        end 
   
    //Assign the upper eight bits of the accumulator's address to the output address (the address of the ROM)
    assign Addr_Out = Addr_Cnt + PWORD;
endmodule
