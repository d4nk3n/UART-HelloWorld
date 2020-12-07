`timescale 1ns / 1ps
// date: 2020/12/01
// by: kun 
// module name: tx
// description: uart transmitter

module tx(
    input       [7:0]   data_in,
    input               wr_en,
    input               clk,
    input               tx_clk,
    output  reg         tx,
    output              tx_busy
);

initial tx = 1'b1;

localparam STATE_IDLE   = 2'b00;
localparam STATE_START  = 2'b01;
localparam STATE_DATA   = 2'b11;
localparam STATE_STOP   = 2'b10;

reg [7:0] data      = 8'h00;
reg [2:0] bitpos    = 3'h0;
reg [1:0] state     = STATE_IDLE;

always @(posedge clk) begin
    case (state)
    STATE_IDLE: begin
        if (wr_en) begin
            state   <= STATE_START;
            data    <= data_in;
            bitpos  <= 3'h0;
        end
    end
    STATE_START: begin
        if (tx_clk) begin
            tx      <= 1'b0;
            state   <= STATE_DATA;
        end
    end
    STATE_DATA: begin
        if (tx_clk) begin
            if (bitpos == 3'h7)
                state   <= STATE_STOP;
            else
                bitpos  <= bitpos + 3'h1;
            tx <= data[bitpos];
        end
    end
    STATE_STOP: begin
        if (tx_clk) begin
            tx      <= 1'b1;
            state   <= STATE_IDLE;
        end
    end
    default: begin
        tx      <= 1'b1;
        state   <= STATE_IDLE;
    end
    endcase
end

assign tx_busy = (state == STATE_START || state == STATE_DATA);

endmodule
