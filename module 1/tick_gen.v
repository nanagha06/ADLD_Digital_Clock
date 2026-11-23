`timescale 1ns / 1ps

module tick_gen #(
    parameter integer CLK_FREQ_HZ = 50000000
)(
    input wire clk,
    input wire rst_n,
    output reg tick_1s
);

    reg [31:0] count;

    always @(posedge clk or negedge rst_n)
    begin
        if (!rst_n)
        begin
            count   <= 0;
            tick_1s <= 0;
        end
        else
        begin
            tick_1s <= 0;

            if (count == CLK_FREQ_HZ - 1)
            begin
                count   <= 0;
                tick_1s <= 1;
            end
            else
            begin
                count <= count + 1;
            end
        end
    end

endmodule