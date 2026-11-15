`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 15.11.2026 12:56:40
// Design Name: 
// Module Name: partial_prod_gen
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

module partial_prod_gen(
  input logic signed [7:0] M,
  input booth_pkg::booth_op_t operation,
  output logic signed [9:0] partial_prod);
  
  logic signed [9:0]M10;
  import booth_pkg::*;
  assign M10 ={{2{M[7]}},M[7:0]};
  
  
  always_comb begin
    case(operation)
      ZERO: partial_prod = 0;
      ONE: partial_prod = M10;
      TWO:  partial_prod = M10<<1;
      NEG_ONE: partial_prod = -M10;
      NEG_TWO: partial_prod= -(M10<<1);
      default: partial_prod = 10'sd0;
    endcase
  end
endmodule
