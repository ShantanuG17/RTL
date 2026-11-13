`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.11.2026 20:53:09
// Design Name: 
// Module Name: spi_controller
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


module spi_controller(
    input logic clk,
    input logic reset,
    input logic start,
    input logic clock_tick,
    input logic sclk,
    input logic count_done,
    output logic load_tx,
    output logic sample_rx,
    output logic shift_tx,
    output logic clear_count,
    output logic count_en,
    output logic divider_enable,
    output logic cs_n,
    output logic done
    );
    
    typedef enum logic [2:0] {
        IDLE,
        LOAD,
        TRANSFER,
        FINISH,
        DONE
    } state_t;

    state_t current_state, next_state;

    // State register
    always_ff @(posedge clk) begin
        if (reset)
            current_state <= IDLE;
        else
            current_state <= next_state;
    end

    // Next-state logic
    always_comb begin
        next_state = current_state;

        case (current_state)

            IDLE: begin
                if (!start)
                    next_state = IDLE;
                else
                    next_state = LOAD;
            end

            LOAD: begin
                next_state = TRANSFER;
            end

            TRANSFER: begin
                if (count_done && sclk && clock_tick)
                    next_state = FINISH;
                else
                    next_state = TRANSFER;
            end

            FINISH: begin
                next_state = DONE;
            end

            DONE: begin
                next_state = IDLE;
            end

            default: begin
                next_state = IDLE;
            end

        endcase
    end

    // Output logic
    always_comb begin

        // Default assignments
        load_tx        = 1'b0;
        sample_rx      = 1'b0;
        shift_tx       = 1'b0;
        clear_count    = 1'b0;
        count_en       = 1'b0;
        divider_enable = 1'b0;
        cs_n           = 1'b1;
        done           = 1'b0;

        case (current_state)

            IDLE: begin
                // Default outputs are sufficient
            end

            LOAD: begin
                load_tx        = 1'b1;
                clear_count    = 1'b1;
                cs_n           = 1'b0;
            end

            TRANSFER: begin
                divider_enable = 1'b1;
                cs_n           = 1'b0;

                if (clock_tick) begin
                    if (!sclk) begin
                        sample_rx = 1'b1;
                        count_en  = 1'b1;
                    end
                    else if (!count_done) begin
                        shift_tx = 1'b1;
                    end
                end
            end

            FINISH: begin
                // Default outputs are sufficient
            end

            DONE: begin
                done = 1'b1;
            end

            default: begin
                // Default outputs are sufficient
            end

        endcase
    end
endmodule
