`timescale 1ns / 1ps
// date: 2020/12/01
// by: kun
// module name: uart
// description: uart interface, but only
//              supports tx for now

module uart#(
    parameter FREQ_CLKIN    = 100_000_000,
    parameter BAUD_RATE     = 9600
)
(
    input           clk,
    input   [7:0]   data_in,
    input           wr_en,
    output          tx,
    output          tx_busy
);

wire tx_clk;

baud_clk#(
    .FREQ_CLKIN(FREQ_CLKIN),
    .BAUD_RATE(BAUD_RATE)
)
U_baud_clk(
    .clk(clk),
    .tx_clk(tx_clk)
);

tx U_tx(
    .data_in(data_in),
    .wr_en(wr_en),
    .clk(clk),
    .tx_clk(tx_clk),
    .tx(tx),
    .tx_busy(tx_busy)
);

endmodule
