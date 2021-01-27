`timescale 1ns / 1ps
// date: 2020/12/01
// by: kun
// module name: uart_hello
// description: send "Hello world!\n" every 1 second,
//              hold "pause" to stop sending.
//              tx_debug == tx, only for making it easy 
//              to use a logic analyzer.

module uart_hello#(
    parameter FREQ_CLKIN    = 100_000_000,
    parameter BAUD_RATE     = 9600
)
(
    input   clk,
    input   pause,
    output  tx,
    output  tx_debug
);

    localparam STRING_SEND  = "Hello World!\n";
    localparam STRING_LEN   = 13;
    localparam STATE_IDLE   = 1'b0;
    localparam STATE_SEND   = 1'b1;

    parameter BYTE_INDEX_WIDTH  = $clog2(STRING_LEN);
    parameter BIT_INDEX_WIDTH   = 3 + BYTE_INDEX_WIDTH;

    reg [BYTE_INDEX_WIDTH - 1:0]    bytepos;
    reg [BIT_INDEX_WIDTH - 1 :0]    bitpos;
    reg [7                   :0]    tx_data;
    reg                             state       = STATE_IDLE;
    reg                             wr_en       = 0;

    wire [8 * STRING_LEN - 1 :0]    tx_str_bit  = STRING_SEND;
    wire                            tx_busy;

    always@(posedge send or negedge tx_busy) begin
        if (send) begin
            bytepos = STRING_LEN;
            bitpos  = bytepos * 8 - 1;
            tx_data = tx_str_bit[bitpos-:8];
            wr_en   = 1;
            bytepos = bytepos - 1;
            state   = STATE_SEND;
        end
        else begin
            case (state)
                STATE_IDLE: begin
                    wr_en   = 0;
                    tx_data = 0;
                end
                STATE_SEND: begin
                    bitpos  = bytepos * 8 - 1;
                    tx_data = tx_str_bit[bitpos-:8];
                    wr_en   = 1;
                    bytepos = bytepos - 1;
                    if (bytepos == 0) begin
                        state = STATE_IDLE;
                    end
                    else begin
                        state = STATE_SEND;
                    end
                end
                default: state = STATE_IDLE;
            endcase
        end
    end

    assign tx_debug = tx;

    uart#(
        .FREQ_CLKIN(FREQ_CLKIN),
        .BAUD_RATE(BAUD_RATE)
    )
    U_uart(
        .clk(clk),
        .data_in(tx_data),
        .wr_en(wr_en),
        .tx(tx),
        .tx_busy(tx_busy)
    );

    send_signal#(
        .FREQ_CLKIN(FREQ_CLKIN)
    )
    U_send_signal(
        .clk(clk),
        .pause(pause),
        .send(send)
    );

endmodule
