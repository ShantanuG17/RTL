`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.11.2026 20:53:09
// Design Name: 
// Module Name: spi_tx_register
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


module spi_tx_register(
    input clk,
    input reset,
    input load_tx,
    input shift_tx,
    output mosi,
    output [7:0] tx_data
    );
    logic [7:0] tx_shift_reg;

    always_ff @(posedge clk) begin
        if (reset)
            tx_shift_reg <= 8'b0;
        else if (load_tx)
            tx_shift_reg <= tx_data;
        else if (shift_tx)
            tx_shift_reg <= {tx_shift_reg[6:0], 1'b0};
    end

    assign mosi = tx_shift_reg[7];
endmodule
