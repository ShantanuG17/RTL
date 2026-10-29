`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 29.10.2026 20:09:41
// Design Name: 
// Module Name: tb_synch_fifo
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

module tb_sync_fifo;

    reg clk;
    reg reset;
    reg write_en;
    reg read_en;
    reg [7:0] data_in;

    wire [7:0] data_out;
    wire full;
    wire empty;

    sync_fifo dut (
        .clk(clk),
        .reset(reset),
        .write_en(write_en),
        .read_en(read_en),
        .data_in(data_in),
        .data_out(data_out),
        .full(full),
        .empty(empty)
    );

    initial begin
        clk = 1'b0;
        forever #5 clk = ~clk;
    end

    initial begin
        reset = 1'b1;
        write_en = 1'b0;
        read_en = 1'b0;
        data_in = 8'h00;
        repeat (2) @(negedge clk);
        reset = 1'b0;

        @(negedge clk);
        if (empty !== 1'b1)
            $display("FAIL: FIFO should be empty after reset");
        else
            $display("PASS: FIFO is empty after reset");

        write_en = 1'b1;
        data_in = 8'hA5;
        @(negedge clk);
        write_en = 1'b0;

        read_en = 1'b1;
        @(negedge clk);

        if (data_out !== 8'hA5)
            $display("FAIL: Expected A5, got %h", data_out);
        else
            $display("PASS: Read data A5 correctly");

        read_en = 1'b0;

        write_en = 1'b1;
        for (integer i = 0; i < 8; i = i + 1) begin
            data_in = i;
            @(negedge clk);
        end
        write_en = 1'b0;

        if (full !== 1'b1)
            $display("FAIL: FIFO should be full");
        else
            $display("PASS: FIFO is full");

        write_en = 1'b1;
        data_in = 8'hFF;
        @(negedge clk);
        write_en = 1'b0;

        if (full !== 1'b1)
            $display("FAIL: FIFO full flag changed unexpectedly");
        else
            $display("PASS: Write while full was rejected");

        read_en = 1'b1;
        repeat (8) @(negedge clk);
        read_en = 1'b0;

        if (empty !== 1'b1)
            $display("FAIL: FIFO should be empty after draining");
        else
            $display("PASS: FIFO is empty after draining");

        read_en = 1'b1;
        @(negedge clk);
        read_en = 1'b0;

        if (empty !== 1'b1)
            $display("FAIL: FIFO empty flag changed unexpectedly");
        else
            $display("PASS: Read while empty was rejected");

        write_en = 1'b1;
        data_in = 8'h11;
        @(negedge clk);

        data_in = 8'h22;
        read_en = 1'b1;
        @(negedge clk);

        write_en = 1'b0;
        read_en = 1'b0;

        if (data_out !== 8'h11)
            $display("FAIL: Simultaneous operation returned %h, expected 11", data_out);
        else
            $display("PASS: Simultaneous operation read the old item");

        if (empty !== 1'b0)
            $display("FAIL: FIFO should contain the new item");
        else
            $display("PASS: FIFO retained the newly written item");

        $display("Simulation tests completed.");
        $finish;
    end

endmodule
