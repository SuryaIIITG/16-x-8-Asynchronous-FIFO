`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.12.2024 11:26:27
// Design Name: 
// Module Name: fifo_16x8_tb
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


module fifo_16x8_tb;

    // Parameters
    parameter D_width = 8;
    parameter D_depth = 16;

    // Testbench signals
    reg clk;
    reg reset;
    reg [D_width-1:0] d_in;
    reg read;
    reg write;
    wire [D_width-1:0] d_out;
    wire empty;
    wire full;

    // Instantiate the FIFO module
    fifo_16x8 #(
        .D_width(D_width),
        .D_depth(D_depth)
    ) fifo_inst (
        .clk(clk),
        .reset(reset),
        .d_in(d_in),
        .read(read),
        .write(write),
        .d_out(d_out),
        .empty(empty),
        .full(full)
    );

    // Clock generation
    initial clk = 0;
    always #5 clk = ~clk; // 10 ns clock period

    // Testbench logic
    initial begin
        // Initialize signals
        reset = 1;
        d_in = 0;
        read = 0;
        write = 0;

        // Apply reset
        #10 reset = 0;

        // Write data into FIFO
        $display("Starting Write Test");
        repeat (D_depth) begin
            @(posedge clk);
            if (!full) begin
                d_in = $random % 256; // Random 8-bit data
                write = 1;
                $display("Write: Data = %h, Full = %b", d_in, full);
            end
            else begin
                $display("FIFO Full. Cannot write further.");
            end
        end
        @(posedge clk);
        write = 0;

        // Read data from FIFO
        $display("Starting Read Test");
        repeat (D_depth) begin
            @(posedge clk);
            if (!empty) begin
                read = 1;
                $display("Read: Data = %h, Empty = %b", d_out, empty);
            end
            else begin
                $display("FIFO Empty. Cannot read further.");
            end
        end
        @(posedge clk);
        read = 0;

        // Test simultaneous read and write
        $display("Starting Simultaneous Read/Write Test");
        reset = 1; @(posedge clk); reset = 0; // Reset FIFO
        repeat (D_depth / 2) begin
            @(posedge clk);
            if (!full) begin
                d_in = $random % 256;
                write = 1;
            end
            if (!empty) begin
                read = 1;
            end
            $display("Simultaneous Operation: Write = %h, Read = %h", d_in, d_out);
        end
        @(posedge clk);
        write = 0;
        read = 0;

        // Reset the FIFO and verify behavior
        $display("Applying Reset");
        reset = 1; @(posedge clk); reset = 0;
        if (empty && !full) begin
            $display("Reset Successful. FIFO is empty.");
        end else begin
            $display("Reset Failed. Check logic.");
        end

        $stop;
    end

endmodule
