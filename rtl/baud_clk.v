`timescale 1ns / 1ps
// date: 2020/12/01
// by: kun
// module name: baud_clk
// description: generate clock signal at specified baud rate


module baud_clk#(
    parameter FREQ_CLKIN    =   100_000_000,
    parameter BAUD_RATE     =   9600
)(
    input   clk,
    output  tx_clk
);

    // notice there's a bug when assigning a localparam using clog2 in ISE
    parameter TX_ACC_MAX   = FREQ_CLKIN / BAUD_RATE;
    parameter TX_ACC_WIDTH = $clog2(TX_ACC_MAX);

    reg [TX_ACC_WIDTH - 1:0] tx_acc = 0;

    assign tx_clk = (tx_acc == {TX_ACC_WIDTH{1'b0}});

    always @(posedge clk) begin
        if (tx_acc == TX_ACC_MAX[TX_ACC_WIDTH - 1:0])
            tx_acc <= 0;
        else
            tx_acc <= tx_acc + 1'b1;
    end

endmodule
