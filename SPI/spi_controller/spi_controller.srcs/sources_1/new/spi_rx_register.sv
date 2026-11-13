`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.11.2026 20:53:09
// Design Name: 
// Module Name: spi_rx_register
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


module spi_rx_register(
    input clk,
    input reset,
    input miso,
    input sample_rx,
    output logic [7:0] rx_data
    );
     always_ff @(posedge clk) begin
        if (reset)
            rx_data <= 8'b0;
        else if (sample_rx)
            rx_data <= {rx_data[6:0], miso};
    end
endmodule
