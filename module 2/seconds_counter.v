`timescale 1ns / 1ps

module seconds_counter(
    input wire clk,
    input wire rst_n,
    input wire tick_1s,

    output reg [5:0] sec_count,
    output reg min_tick
);

    always @(posedge clk or negedge rst_n)
    begin
        if (!rst_n)
        begin
            sec_count <= 6'd0;
            min_tick  <= 1'b0;
        end
        else
        begin
            min_tick <= 1'b0;

            if (tick_1s)
            begin
                if (sec_count == 6'd59)
                begin
                    sec_count <= 6'd0;
                    min_tick  <= 1'b1;
                end
                else
                begin
                    sec_count <= sec_count + 1'b1;
                end
            end
        end
    end

endmodule