`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.11.2026 21:00:17
// Design Name: 
// Module Name: spi_clock_divider
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


module spi_clock_divider(
    input clk,
    input reset,
    input enable,
    output logic sclk,
    output clock_tick
    );
    
    logic [3:0] div_count;

    always_ff @(posedge clk) begin
        if (reset) begin
            div_count <= 4'd0;
            sclk <= 1'b0;
        end
        else if (!enable) begin
            div_count <= 4'd0;
            sclk <= 1'b0;
        end
        else if (div_count == 4'd9) begin
            div_count <= 4'd0;
            sclk <= ~sclk;
        end
        else begin
            div_count <= div_count + 1'b1;
        end
    end

    assign clock_tick = enable && (div_count == 4'd9);
endmodule
