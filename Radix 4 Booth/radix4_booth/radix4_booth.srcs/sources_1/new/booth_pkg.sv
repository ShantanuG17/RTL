`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 15.11.2026 12:56:40
// Design Name: 
// Module Name: booth_pkg
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

package booth_pkg;
    typedef enum logic [2:0] {
        ZERO,
        ONE,
        TWO,
        NEG_ONE,
        NEG_TWO
    } booth_op_t;
endpackage
