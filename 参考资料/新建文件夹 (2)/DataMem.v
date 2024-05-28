`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/05/18 21:53:23
// Design Name: 
// Module Name: DataMem
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


module DataMem(
  input clk, mem_wen,mem_ren,
  input[31:0] mem_addr,
  input[31:0] mem_data_i,
  output [31:0] mem_data_o
    );
    reg[7:0] data_mem0[0:66535];
    reg[7:0] data_mem1[0:66535];
    reg[7:0] data_mem2[0:66535];
    reg[7:0] data_mem3[0:66535];
    always@(negedge clk)begin
      if(mem_wen)begin
        data_mem0[mem_addr[31:2]]<= mem_data_i[7:0];
        data_mem1[mem_addr[31:2]]<= mem_data_i[15:8];
        data_mem2[mem_addr[31:2]]<= mem_data_i[23:16];
        data_mem3[mem_addr[31:2]]<= mem_data_i[31:24];
    end
    end
    //always@(*)
       assign mem_data_o[7:0] = (mem_ren==1)?data_mem0[mem_addr[31:2]]:8'b0;
        assign mem_data_o[15:8] = (mem_ren==1)?data_mem1[mem_addr[31:2]]:8'b0;
       assign mem_data_o[23:16] =(mem_ren==1)?data_mem2[mem_addr[31:2]]:8'b0;
        assign mem_data_o[31:24] = (mem_ren==1)?data_mem3[mem_addr[31:2]]:8'b0;

endmodule
