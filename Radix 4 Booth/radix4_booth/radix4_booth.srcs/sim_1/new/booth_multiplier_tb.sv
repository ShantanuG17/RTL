`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 15.11.2026 13:24:36
// Design Name: 
// Module Name: booth_multiplier_tb
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



`timescale 1ns / 1ps

module booth_multiplier_tb;

    logic clk;
    logic reset;
    logic start;

    logic signed [7:0] multiplicand;
    logic signed [7:0] multiplier;

    logic signed [15:0] product;
    logic done;

    integer tests_passed = 0;

    // DUT instantiation
    booth_multiplier DUT (
        .clk(clk),
        .reset(reset),
        .start(start),
        .multiplicand(multiplicand),
        .multiplier(multiplier),
        .product(product),
        .done(done)
    );

    // Clock generation: 10 ns period
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Task to perform one multiplication
    task automatic run_test(
        input logic signed [7:0] M,
        input logic signed [7:0] Q,
        input logic signed [15:0] expected
    );
        begin
            // Apply operands
            @(negedge clk);
            multiplicand = M;
            multiplier = Q;
            start = 1;

            @(negedge clk);
            start = 0;

            // Wait for completion, with timeout
            fork
                begin
                    wait(done === 1'b1);
                end

                begin
                    repeat (20) @(posedge clk);
                    $fatal(1, "Timeout waiting for multiplication");
                end
            join_any

            disable fork;
            #1;

            // Display results
            $display("------------------------------------");
            $display("M = %0d, Q = %0d", M, Q);
            $display("Expected product = %0d", expected);
            $display("Actual product   = %0d", product);

            if (product === expected) begin
                $display("RESULT: PASS");
                tests_passed = tests_passed + 1;
            end
            else begin
                $fatal(1, "RESULT: FAIL");
            end

            // Reset between transactions
            @(negedge clk);
            reset = 1;

            @(negedge clk);
            reset = 0;
        end
    endtask

    // Main test sequence
    initial begin

        // Initialize signals
        reset = 1;
        start = 0;
        multiplicand = 0;
        multiplier = 0;

        repeat (2) @(negedge clk);
        reset = 0;

        // Test 1: Positive x Positive
        run_test(8'sd13, 8'sd11, 16'sd143);

        // Test 2: Negative x Positive
        run_test(-8'sd13, 8'sd11, -16'sd143);

        // Test 3: Most-negative x Most-negative
        run_test(-8'sd128, -8'sd128, 16'sd16384);

        // Test 4: Zero x Positive
        run_test(8'sd0, 8'sd25, 16'sd0);

        // Test 5: Maximum positive x Maximum positive
        run_test(8'sd127, 8'sd127, 16'sd16129);

        // Final summary
        $display("\n====================================");
        $display("RADIX-4 BOOTH MULTIPLIER TEST SUMMARY");
        $display("Tests passed: %0d / 5", tests_passed);
        $display("====================================");

        if (tests_passed == 5)
            $display("ALL TESTS PASSED");
        else
            $fatal(1, "SOME TESTS FAILED");

        $finish;
    end

endmodule

