`timescale 1ns / 1ps

module tb_tick_gen;

    reg  clk;
    reg  rst_n;
    wire tick_1s;

    // Instantiate your tick_gen module and override CLK_FREQ_HZ for fast simulation
    tick_gen #(
        .CLK_FREQ_HZ(5)
    ) uut (
        .clk(clk),
        .rst_n(rst_n),
        .tick_1s(tick_1s)
    );

    // 100 MHz clock (10 ns period: toggles every 5 ns)
    always #5 clk = ~clk;

    initial begin
        clk   = 1'b0;
        rst_n = 1'b0; // Active-low reset asserted (count = 0, tick_1s = 0)

        #20;
        rst_n = 1'b1; // Release reset

        // Let it run through multiple tick_1s pulses
        #250;

        // Test active-low reset mid-operation
        rst_n = 1'b0;
        #20;
        rst_n = 1'b1;

        #100;
        $finish;
    end

    initial begin
        $monitor("Time=%0t ns | clk=%b | rst_n=%b | count=%0d | tick_1s=%b",
                 $time, clk, rst_n, uut.count, tick_1s);
    end

endmodule