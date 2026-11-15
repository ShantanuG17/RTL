`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 15.11.2026 12:56:40
// Design Name: 
// Module Name: m_register
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



module m_register (
    input logic clk,
    input logic reset,
    input logic load,
    input logic signed [7:0] data_in,
    output logic signed [7:0] M
);

    always_ff @(posedge clk) begin
        if (reset)
            M <= 8'b0;
        else if (load)
            M <= data_in;
    end

endmodule
