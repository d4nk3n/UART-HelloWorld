`timescale 1ns / 1ps
// date: 2020/12/01
// by: kun
// moudule name: send_signal
// description: generate send signal
//              let pause = 1 to stop


module send_signal#(
    parameter FREQ_CLKIN = 100_000_000
)(
    input       clk,
    input       pause,
    output      send
);

parameter SEND_RATE         = 1;                        // send once every 1s
parameter SEND_CNT_MAX      = FREQ_CLKIN / SEND_RATE;
parameter SEND_CNT_WIDTH    = $clog2(SEND_CNT_MAX);

reg [SEND_CNT_WIDTH - 1:0] cnt = 0;

always@(posedge clk) begin
    cnt = cnt + 1'b1;
    if (cnt == SEND_CNT_MAX) begin
        cnt = 0;
    end
end

assign send = (~pause) ? (cnt == 1) : 1'b0;

endmodule
