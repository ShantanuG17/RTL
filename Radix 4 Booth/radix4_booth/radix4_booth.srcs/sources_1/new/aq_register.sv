`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 15.11.2026 12:56:40
// Design Name: 
// Module Name: aq_register
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


module aq_register(
    input logic clk,reset,load,shift,
  input logic signed [9:0] A_in,
  input logic [7:0] Q_in,
  input logic accumulate,
  input logic signed [9:0] A_sum,
  output logic signed [18:0] AQ
    );
    
    always_ff @(posedge clk) begin
    if(reset)begin
      AQ<=19'b0;
    end
    else if (load) begin
      AQ<= {A_in,Q_in,1'b0};
    end
    else if (accumulate) begin
      AQ <= {A_sum, AQ[8:0]};
    end
    else if(shift)begin
      AQ<= {{2{AQ[18]}},AQ[18:2]};
     end
  end
endmodule
