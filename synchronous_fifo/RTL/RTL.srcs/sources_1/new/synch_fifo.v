`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 29.10.2026 18:06:41
// Design Name: 
// Module Name: synch_fifo
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

module sync_fifo (
    input clk,
    input reset,
    input write_en,
    input read_en,
    input [7:0] data_in,
    output reg [7:0] data_out,
    output full,
    output empty
);

    // Internal registers
    reg [7:0] mem [0:7];
    reg [2:0] write_ptr;
    reg [2:0] read_ptr;
    reg [3:0] count;
    wire do_write,do_read;
  
    always@(posedge clk) begin
        if (reset) begin
            write_ptr <= 0;
            read_ptr <= 0;
            count <=0;
            data_out <=0;
           end
         else begin
          case({do_write,do_read})
            2'b00: begin
                  end
            2'b10: begin
                    mem[write_ptr] <= data_in;
                    count <= count + 1;
                    write_ptr <= write_ptr + 1;
                  end
            2'b01: begin
                    data_out <= mem[read_ptr];
                    count <= count -1;
                    read_ptr <= read_ptr+1;
                   end
             2'b11: begin
                      mem[write_ptr] <= data_in;
                      data_out <= mem[read_ptr];
                      count <= count;
                      write_ptr <= write_ptr + 1;
                      read_ptr <= read_ptr + 1;
                    end
                 endcase
              end
           end
     assign do_write = (write_en==1'b1 && full==1'b0);
     assign do_read = (read_en==1'b1 && empty==1'b0);     
     assign empty = (count==0);
     assign full = (count==8);
endmodule