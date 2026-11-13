`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.11.2026 21:05:23
// Design Name: 
// Module Name: spi_master_top
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


module spi_master_top(
    input clk,
    input reset,
    input start,
    input [7:0] tx_data,
    input miso,
    output mosi,
    output sclk,
    output cs_n,
    output [7:0] rx_data,
    output done
    );
     // Internal control signals
    logic load_tx;
    logic shift_tx;
    logic sample_rx;
    logic clear_count;
    logic count_en;
    logic divider_enable;

    // Internal status signals
    logic count_done;
    logic clock_tick;

    // Internal counter
    logic [3:0] bit_count;
  
  // Transmit register
spi_tx_register tx_reg (
    .clk      (clk),
    .reset    (reset),
    .load_tx  (load_tx),
    .shift_tx (shift_tx),
    .tx_data  (tx_data),
    .mosi     (mosi)
);
  
  // Receive register
spi_rx_register rx_reg (
    .clk       (clk),
    .reset     (reset),
    .miso      (miso),
    .sample_rx (sample_rx),
    .rx_data   (rx_data)
);
  
  // Bit counter
spi_bit_counter bit_counter (
    .clk        (clk),
    .reset      (reset),
    .clear_count(clear_count),
    .count_en   (count_en),
    .count_done (count_done),
    .bit_count  (bit_count)
);
  
  // Clock divider
spi_clock_divider clk_div (
    .clk        (clk),
    .reset      (reset),
    .enable     (divider_enable),
    .sclk       (sclk),
    .clock_tick (clock_tick)
);
  
  // SPI Controller
spi_controller controller (
    .clk             (clk),
    .reset           (reset),
    .start           (start),
    .clock_tick      (clock_tick),
    .sclk            (sclk),
    .count_done      (count_done),

    .load_tx         (load_tx),
    .sample_rx       (sample_rx),
    .shift_tx        (shift_tx),
    .clear_count     (clear_count),
    .count_en        (count_en),
    .divider_enable  (divider_enable),
    .cs_n            (cs_n),
    .done            (done)
);
endmodule
