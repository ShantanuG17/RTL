`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.11.2026 20:53:09
// Design Name: 
// Module Name: spi_bit_counter
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


module spi_bit_counter(
    input clk,
    input reset,
    input clear_count,
    input count_en,
    output count_done,
    output logic [3:0] bit_count
    );
    always_ff @(posedge clk) begin
        if (reset || clear_count)
            bit_count <= 4'd0;
        else if (count_en)
            bit_count <= bit_count + 1'b1;
    end

    assign count_done = (bit_count == 4'd8);

endmodule
