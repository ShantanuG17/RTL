`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 15.11.2026 12:56:40
// Design Name: 
// Module Name: design
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



module booth_encoder(
    input logic [2:0] booth_bits,
    output booth_pkg::booth_op_t operation
    );
    
  import booth_pkg::*;

    always_comb begin
      case(booth_bits)
        3'b000: operation = ZERO;
        3'b001: operation = ONE;
        3'b010: operation = ONE;
        3'b011: operation = TWO;
        3'b100: operation = NEG_TWO;
        3'b101: operation = NEG_ONE;
        3'b110: operation = NEG_ONE;
        3'b111: operation = ZERO;
        default: operation = ZERO;
      endcase
    end
endmodule
