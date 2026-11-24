`timescale 1ns / 1ps

module tb_digital_clock_top;
    reg        clk;
    reg        rst_n;
    wire [3:0] hour_tens;
    wire [3:0] hour_ones;
    wire [3:0] min_tens;
    wire [3:0] min_ones;
    wire [3:0] sec_tens;
    wire [3:0] sec_ones;

    // Small CLK_FREQ_HZ for fast simulation verification
    digital_clock_top #(
        .CLK_FREQ_HZ(2)
    ) uut (
        .clk(clk),
        .rst_n(rst_n),
        .hour_tens(hour_tens),
        .hour_ones(hour_ones),
        .min_tens(min_tens),
        .min_ones(min_ones),
        .sec_tens(sec_tens),
        .sec_ones(sec_ones)
    );

    always #5 clk = ~clk; // 100 MHz simulation clock (10 ns period)

    initial begin
        clk   = 1'b0;
        rst_n = 1'b0; // Assert active-low reset

        #20;
        rst_n = 1'b1; // Release reset

        // Run long enough to see seconds and minute rollovers
        #3000;
        $finish;
    end

    initial begin
        $monitor("Time=%0t ns | rst_n=%b | %0d%0d:%0d%0d:%0d%0d",
                 $time, rst_n,
                 hour_tens, hour_ones,
                 min_tens, min_ones,
                 sec_tens, sec_ones);
    end
endmodule
