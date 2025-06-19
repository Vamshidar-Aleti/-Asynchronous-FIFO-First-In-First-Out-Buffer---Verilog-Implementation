`timescale 1ns/1ps

module async_fifo_tb;

    // Parameters
    parameter DATA_WIDTH = 8;
    parameter ADDR_WIDTH = 4;
    parameter DEPTH = 1 << ADDR_WIDTH;

    // DUT signals
    reg  wr_clk, rd_clk, rst_n;
    reg  wr_en, rd_en;
    reg  [DATA_WIDTH-1:0] din;
    wire [DATA_WIDTH-1:0] dout;
    wire full, empty;

    // Instantiate DUT
    async_fifo #(
        .DATA_WIDTH(DATA_WIDTH),
        .ADDR_WIDTH(ADDR_WIDTH)
    ) dut (
        .wr_clk(wr_clk),
        .rd_clk(rd_clk),
        .rst_n(rst_n),
        .wr_en(wr_en),
        .rd_en(rd_en),
        .din(din),
        .dout(dout),
        .full(full),
        .empty(empty)
    );

    //-------------------------------------------//
    // Clock Generation (asynchronous clocks)
    //-------------------------------------------//
    initial wr_clk = 0;
    always #3 wr_clk = ~wr_clk; // ~166.6 MHz

    initial rd_clk = 0;
    always #5 rd_clk = ~rd_clk; // ~100 MHz

    //-------------------------------------------//
    // Test sequence
    //-------------------------------------------//
  initial begin
    $dumpfile("async_fifo_tb.vcd");
    $dumpvars(0, async_fifo_tb);
end
    initial begin
        $display("Starting Async FIFO Testbench...");
        rst_n = 0;
        wr_en = 0;
        rd_en = 0;
        din   = 0;
        #20;

        // Release reset
        rst_n = 1;
        #10;

        // Write till FIFO is full
        $display("\n--- Writing to FIFO ---");
        repeat (DEPTH + 4) begin
            @(posedge wr_clk);
            if (!full) begin
                wr_en = 1;
                din = $random;
                $display("Write: %0h", din);
            end else begin
                wr_en = 0;
                $display("FIFO Full! Write blocked.");
            end
        end
        wr_en = 0;

        // Wait a bit
        #50;

        // Read till FIFO is empty
        $display("\n--- Reading from FIFO ---");
        repeat (DEPTH + 4) begin
            @(posedge rd_clk);
            if (!empty) begin
                rd_en = 1;
                $display("Read: %0h", dout);
            end else begin
                rd_en = 0;
                $display("FIFO Empty! Read blocked.");
            end
        end
        rd_en = 0;

        // Simultaneous Read and Write
        $display("\n--- Simultaneous Write and Read ---");
        repeat (10) begin
            @(posedge wr_clk);
            if (!full) begin
                wr_en = 1;
                din = $random;
                $display("Write: %0h", din);
            end
            @(posedge rd_clk);
            if (!empty) begin
                rd_en = 1;
                $display("Read: %0h", dout);
            end
        end
        wr_en = 0;
        rd_en = 0;

        // Final delay and finish
        #100;
        $display("\nTestbench Finished.");
        $finish;
    end

endmodule
