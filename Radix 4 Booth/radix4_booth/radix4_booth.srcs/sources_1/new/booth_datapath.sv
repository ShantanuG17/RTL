`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 15.11.2026 12:56:40
// Design Name: 
// Module Name: booth_datapath
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



module booth_datapath (
    input logic clk,
    input logic reset,
    input logic [7:0] data_in,

    input logic load_M,
    input logic load_AQ,
    input logic accumulate,
    input logic shift,
    input logic load_count,
    input logic decrement,

    output logic [2:0] booth_bits,
    output logic count_done,
 	output logic signed [15:0] product,
  	output logic [2:0] count
);

    // Internal signals
    logic signed [7:0] M;
    logic signed [18:0] AQ;

    logic signed [9:0] A;
    logic [7:0] Q;
    logic qm1;

    logic signed [9:0] partial_prod;
    logic signed [9:0] A_sum;

    booth_pkg::booth_op_t operation;
   
    // Extract A, Q and Q-1 from AQ
    assign A = AQ[18:9];
    assign Q = AQ[8:1];
    assign qm1 = AQ[0];

    // Booth encoder input
    assign booth_bits = {Q[1:0], qm1};

    // Accumulator adder
    assign A_sum = A + partial_prod;


    // 1. Multiplicand register
    m_register MR (
        .clk(clk),
        .reset(reset),
        .load(load_M),
        .data_in(data_in),
        .M(M)
    );


    // 2. Booth encoder
    booth_encoder BE (
        .booth_bits(booth_bits),
        .operation(operation)
    );


    // 3. Partial product generator
    partial_prod_gen PPG (
        .M(M),
        .operation(operation),
        .partial_prod(partial_prod)
    );


    // 4. Combined AQ register
    aq_register AQR (
        .clk(clk),
        .reset(reset),
        .load(load_AQ),
        .accumulate(accumulate),
        .shift(shift),
        .A_in(10'sd0),
        .A_sum(A_sum),
        .Q_in(data_in),
        .AQ(AQ)
    );


    // 5. Iteration counter
    iteration_counter IC (
        .clk(clk),
        .reset(reset),
        .load(load_count),
        .decr(decrement),
        .count(count),
        .done(count_done)
    );


    // Product extraction to be finalized
    // after verifying the final Radix-4 arithmetic alignment
  assign product = AQ[16:1];

endmodule

