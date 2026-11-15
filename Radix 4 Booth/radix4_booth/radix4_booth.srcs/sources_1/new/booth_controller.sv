`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 15.11.2026 12:56:40
// Design Name: 
// Module Name: booth_controller
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


module booth_controller (
    input logic clk,
    input logic reset,
    input logic start,
    input logic [2:0] count,

    output logic load_M,
    output logic load_AQ,
    output logic load_count,
    output logic accumulate,
    output logic shift,
    output logic decrement,
    output logic done
);

    typedef enum logic [2:0] {
        IDLE,
        LOAD_M,
        LOAD_Q,
        EXECUTE,
        SHIFT,
        DONE
    } state_t;

    state_t current_state, next_state;

    // Sequential state register
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
            if (start)
                next_state = LOAD_M;
            else
                next_state = IDLE;
        end

        LOAD_M: begin
            next_state = LOAD_Q;
        end

        LOAD_Q: begin
            next_state = EXECUTE;
        end

        EXECUTE: begin
            next_state = SHIFT;
        end

        SHIFT: begin
            if (count == 3'd1)
                next_state = DONE;
            else
                next_state = EXECUTE;
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
    load_M =0;
    load_AQ =0;
    load_count = 0;
    accumulate = 0;
    shift = 0;
    decrement = 0;
    done = 0;
    case(current_state) 
      IDLE: begin
                // Wait for start
            end

      LOAD_M: begin
                load_M = 1'b1;
            end

      LOAD_Q: begin
                load_AQ    = 1'b1;
                load_count = 1'b1;
            end

      EXECUTE: begin
                accumulate = 1'b1;
            end

      SHIFT: begin
                shift     = 1'b1;
                decrement = 1'b1;
            end

      DONE: begin
                done = 1'b1;
            end

            default: begin
                // All outputs remain zero
            end

        endcase
    end

endmodule