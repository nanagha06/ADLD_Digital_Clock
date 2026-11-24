`timescale 1ns / 1ps

module tb_seconds_counter;
    reg        clk;
    reg        rst_n;
    reg        tick_1s;
    wire [5:0] sec_count;
    wire       min_tick;

    seconds_counter uut (
        .clk(clk),
        .rst_n(rst_n),
        .tick_1s(tick_1s),
        .sec_count(sec_count),
        .min_tick(min_tick)
    );

    // 100 MHz simulation clock (10 ns period)
    always #5 clk = ~clk;

    // Helper task to assert tick_1s for one clock cycle
    task pulse_tick_1s;
        begin
            @(posedge clk);
            tick_1s <= 1'b1;
            @(posedge clk);
            tick_1s <= 1'b0;
        end
    endtask

    initial begin
        clk     = 1'b0;
        rst_n   = 1'b0;
        tick_1s = 1'b0;

        #20;
        rst_n = 1'b1; // Release reset (sec_count should be 0)

        // Pulse tick_1s 62 times to verify 0..59 and rollover to 0 with min_tick
        repeat (62) begin
            pulse_tick_1s();
            repeat (3) @(posedge clk);
        end

        #50;
        $finish;
    end

    initial begin
        $monitor("Time=%0t ns | rst_n=%b | tick_1s=%b | sec_count=%0d | min_tick=%b",
                 $time, rst_n, tick_1s, sec_count, min_tick);
    end
endmodule
