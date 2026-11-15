`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 15.11.2026 12:56:40
// Design Name: 
// Module Name: booth_multiplier
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



module booth_multiplier (
    input logic clk,
    input logic reset,
    input logic start,

    input logic signed [7:0] multiplicand,
    input logic signed [7:0] multiplier,

    output logic signed [15:0] product,
    output logic done
);

    // Internal control signals
    logic load_M;
    logic load_AQ;
    logic load_count;
    logic accumulate;
    logic shift;
    logic decrement;

    // Datapath status signals
    logic [2:0] booth_bits;
    logic [2:0] count;
    logic count_done;

    // Shared datapath input bus
    logic [7:0] data_in;

    // Select multiplicand or multiplier
    always_comb begin
        if (load_M)
            data_in = multiplicand;
        else
            data_in = multiplier;
    end

    // Controller instantiation
    booth_controller BC (
        .clk(clk),
        .reset(reset),
        .start(start),
        .count(count),

        .load_M(load_M),
        .load_AQ(load_AQ),
        .load_count(load_count),
        .accumulate(accumulate),
        .shift(shift),
        .decrement(decrement),
        .done(done)
    );

    // Datapath instantiation
    booth_datapath DP (
        .clk(clk),
        .reset(reset),
        .data_in(data_in),

        .load_M(load_M),
        .load_AQ(load_AQ),
        .accumulate(accumulate),
        .shift(shift),
        .load_count(load_count),
        .decrement(decrement),

        .booth_bits(booth_bits),
        .count_done(count_done),
        .count(count),
        .product(product)
    );

endmodule

