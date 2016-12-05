module  slave_fifo (
    clk,
    rst_n,
    uplink_valid,
    downlink_valid,
    data_in,
    uplink_ready,
    downlink_ready,
    fifo_slack,
    data_out);  

    parameter FIFO_DEPTH = 4'b1000;    //d8
    parameter FIFO_WIDE = 6'b10_0000;    //d32
    parameter FIFO_PTR_WIDE = 2'b11;
    parameter MAX_CNT = 4'b1000;    //d8
    
    input clk;
    input rst_n;
    input uplink_valid;
    input downlink_valid;
    input [FIFO_WIDE - 1 : 0] data_in;
    output uplink_ready;
    output downlink_ready;
    output [FIFO_PTR_WIDE : 0] fifo_slack;
    output [FIFO_WIDE - 1 : 0] data_out;

    wire clk;
    wire rst_n;
    wire uplink_valid;
    wire downlink_valid;
    wire [FIFO_WIDE - 1 : 0] data_in;
    wire uplink_ready;
    wire downlink_ready;
    wire [FIFO_PTR_WIDE : 0] fifo_slack;
    wire [FIFO_WIDE - 1 : 0] data_out;

    wire [FIFO_PTR_WIDE - 1 : 0] wr_addr;
    wire [FIFO_PTR_WIDE - 1 : 0] rd_addr;
    wire full;
    wire empty;
    
    fifo  #( 
        .FIFO_DEPTH(FIFO_DEPTH),
        .FIFO_WIDE(FIFO_WIDE),
        .FIFO_PTR_WIDE(FIFO_PTR_WIDE),
        .MAX_CNT(MAX_CNT))
    fifo_u_slave (
        .clk(clk),
        .rst_n(rst_n),
        .wr_en(uplink_valid),    
        .rd_en(downlink_valid),  
        .data_in(data_in),
        .data_out(data_out),
        .full(full),    
        .empty(empty),  
        .fifo_slack(fifo_slack)); 
    //handshake signal
    assign uplink_ready = rst_n && (!full);
    assign downlink_ready = rst_n && (!empty);
endmodule // slave_fifo