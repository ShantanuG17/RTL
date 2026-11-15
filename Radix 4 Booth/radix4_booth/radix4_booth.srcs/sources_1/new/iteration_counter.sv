`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 15.11.2026 12:56:40
// Design Name: 
// Module Name: iteration_counter
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


module iteration_counter(
  input logic clk,reset,load,decr,
  output logic [2:0] count,
  output logic done);
  
  always_ff @(posedge clk) begin
    if(reset)
      count<= 3'b0;
    else if(load)
      count <= 3'd4;
    else if (decr && count !=0) 
      count <= count-3'd1;
  end
  
  assign done = (count==0);
endmodule
