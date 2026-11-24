`timescale 1ns / 1ps

module digital_clock_top #(
    parameter integer CLK_FREQ_HZ = 50000000
)(
    input  wire       clk,
    input  wire       rst_n,
    output wire [3:0] hour_tens,
    output wire [3:0] hour_ones,
    output wire [3:0] min_tens,
    output wire [3:0] min_ones,
    output wire [3:0] sec_tens,
    output wire [3:0] sec_ones
);
    wire       tick_1s;
    wire       min_tick;
    wire       hour_tick;
    wire [5:0] sec_count;
    wire [5:0] min_count;
    wire [4:0] hour_count;

    tick_gen #(
        .CLK_FREQ_HZ(CLK_FREQ_HZ)
    ) u_tick_gen (
        .clk(clk),
        .rst_n(rst_n),
        .tick_1s(tick_1s)
    );

    seconds_counter u_seconds (
        .clk(clk),
        .rst_n(rst_n),
        .tick_1s(tick_1s),
        .sec_count(sec_count),
        .min_tick(min_tick)
    );

    minutes_counter u_minutes (
        .clk(clk),
        .rst_n(rst_n),
        .min_tick(min_tick),
        .min_count(min_count),
        .hour_tick(hour_tick)
    );

    hours_counter u_hours (
        .clk(clk),
        .rst_n(rst_n),
        .hour_tick(hour_tick),
        .hour_count(hour_count)
    );

    display_ctrl u_display (
        .hour_count(hour_count),
        .min_count(min_count),
        .sec_count(sec_count),
        .hour_tens(hour_tens),
        .hour_ones(hour_ones),
        .min_tens(min_tens),
        .min_ones(min_ones),
        .sec_tens(sec_tens),
        .sec_ones(sec_ones)
    );
endmodule
