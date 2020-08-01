`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/07/28 08:26:46
// Design Name: 
// Module Name: m_ser
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


module m_ser(
    input clk_1kHz,
    output wire m_seq
);
    integer i=0;//��������
    reg clk_m=0;//��ʼ��
    parameter POLY = 8'b10001110;
    reg [7:0] shift_reg= 8'b11111111;   
       
    always@(posedge clk_1kHz)
    begin
        if(i==99)//����100��ϵͳʱ������
        begin
            i<=0;//������������
            clk_m<=~clk_m;//���ȡ��
        end
        else
        begin i<=i+1; end
    end
       
    always@(posedge clk_1kHz)
        begin
            #500000 
            shift_reg[7] <= (shift_reg[0] & POLY[7])^
            (shift_reg[1] & POLY[6])^
            (shift_reg[2] & POLY[5])^
            (shift_reg[3] & POLY[4])^
            (shift_reg[4] & POLY[3])^
            (shift_reg[5] & POLY[2])^
            (shift_reg[6] & POLY[1])^
            (shift_reg[7] & POLY[0]);
            shift_reg [6:0] <= shift_reg[7:1];
        end
        
    assign m_seq = shift_reg[0]; 
    
endmodule
