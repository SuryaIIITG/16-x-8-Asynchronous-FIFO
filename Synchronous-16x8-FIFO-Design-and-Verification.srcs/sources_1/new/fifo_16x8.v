`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.12.2024 11:19:43
// Design Name: 
// Module Name: fifo_16x8
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


module fifo_16x8 #(
    parameter D_width = 8,  // Data width
    parameter D_depth = 16, // Depth of FIFO
    parameter D_addr = 4    // Address width
) (
    input clk, 
    input reset, 
    input [D_width-1:0] d_in, 
    input read, 
    input write, 
    output reg [D_width-1:0] d_out, 
    output reg empty, 
    output reg full
);

    localparam MAX_COUNT = D_depth - 1; // Maximum count

    reg [D_width-1:0] fifo_mem[0:D_depth-1]; // FIFO memory array
    reg [D_addr-1:0] rd_pntr, wr_pntr; // Read and write pointers
    reg [D_addr:0] count; // Counter with an extra bit for overflow

    // Reset Logic
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            rd_pntr <= 0;
            wr_pntr <= 0;
            count <= 0;
            empty <= 1;
            full <= 0;
            d_out <= 0;
        end else begin
            // Write Operation
            if (write && !full) begin
                fifo_mem[wr_pntr] <= d_in;
                wr_pntr <= wr_pntr + 1;
                count <= count + 1;
            end

            // Read Operation
            if (read && !empty) begin
                d_out <= fifo_mem[rd_pntr];
                rd_pntr <= rd_pntr + 1;
                count <= count - 1;
            end

            // Update flags
            empty <= (count == 0);
            full <= (count == MAX_COUNT);
        end
    end
endmodule
