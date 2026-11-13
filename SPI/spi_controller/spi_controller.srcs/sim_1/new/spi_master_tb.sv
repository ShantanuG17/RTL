`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.11.2026 20:57:10
// Design Name: 
// Module Name: spi_master_tb
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



module spi_master_tb;

    // Testbench signals
    logic clk;
    logic reset;
    logic start;
    logic [7:0] tx_data;
    logic miso;

    logic mosi;
    logic sclk;
    logic cs_n;
    logic [7:0] rx_data;
    logic done;

    // Expected data
    logic [7:0] expected_tx = 8'b10110100;
    logic [7:0] expected_rx = 8'b11001010;

    // Monitoring variables
    logic [7:0] tx_observed;
    integer tx_index;
    integer rx_index;

    // Instantiate SPI Master
    spi_master_top dut (
        .clk     (clk),
        .reset   (reset),
        .start   (start),
        .tx_data (tx_data),
        .miso    (miso),
        .mosi    (mosi),
        .sclk    (sclk),
        .cs_n    (cs_n),
        .rx_data (rx_data),
        .done    (done)
    );

    // 50 MHz system clock (20 ns period)
    initial begin
        clk = 0;
        forever #10 clk = ~clk;
    end

    // SPI slave model:
    // Present the next MISO bit on each falling SCLK edge.
    initial begin
        miso = expected_rx[7];
        rx_index = 0;

        forever begin
            @(negedge sclk);

            if (!cs_n && rx_index < 7) begin
                rx_index = rx_index + 1;
                miso = expected_rx[7-rx_index];
            end
        end
    end

    // Monitor MOSI on rising SCLK edges
    initial begin
        tx_observed = 8'b0;
        tx_index = 0;

        forever begin
            @(posedge sclk);

            if (!cs_n && tx_index < 8) begin
                tx_observed[7-tx_index] = mosi;
                tx_index = tx_index + 1;
            end
        end
    end

    // Main test sequence
    initial begin

        // Initial values
        reset   = 1;
        start   = 0;
        tx_data = expected_tx;

        // Apply reset
        #40;
        reset = 0;

        // Start SPI transaction
        #40;
        start = 1;

        @(posedge clk);
        #1;
        start = 0;

        // Wait for transaction completion
        wait(done == 1'b1);

        #1;

        // Display results
        $display("--------------------------------");
        $display("       SPI MASTER TEST");
        $display("--------------------------------");

        $display("Expected TX : %b", expected_tx);
        $display("Observed TX : %b", tx_observed);

        $display("Expected RX : %b", expected_rx);
        $display("Received RX : %b", rx_data);

        $display("TX bits     : %0d", tx_index);
        $display("RX bits     : %0d", rx_index + 1);

        // Check transmission
        if (tx_observed === expected_tx)
            $display("TX TEST: PASS");
        else
            $display("TX TEST: FAIL");

        // Check reception
        if (rx_data === expected_rx)
            $display("RX TEST: PASS");
        else
            $display("RX TEST: FAIL");

        // Check bit count
        if (tx_index == 8 && rx_index == 7)
            $display("BIT COUNT TEST: PASS");
        else
            $display("BIT COUNT TEST: FAIL");

        $display("--------------------------------");

        $finish;
    end

    // Timeout protection
    initial begin
        #100000;
        $display("ERROR: Simulation timeout!");
        $finish;
    end

endmodule
