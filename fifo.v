module fifo (
    clk,
    fifo_en,
    rst_n,
    fifo_wr_en,    //uplink control 
    fifo_rd_en,    //uplink control
    fifo_data_in,
    fifo_data_out,
    fifo_full,    
    fifo_empty,    
    fifo_slack,
    fifo_uplink_ready,
    fifo_downlink_ready);    
    
    parameter FIFO_DEPTH = 4'b1000;    //d8
    parameter FIFO_WIDE = 6'b10_0000;    //d32
    parameter FIFO_PTR_WIDE = 2'b11;
    parameter MAX_CNT = 4'b1000;    //d8
    
    input clk;
    input rst_n;
    input fifo_en;
    input fifo_wr_en;
    input fifo_rd_en;
    input [FIFO_WIDE - 1 : 0] fifo_data_in;
    output [FIFO_WIDE - 1 : 0] fifo_data_out;
    output fifo_full;
    output fifo_empty;
    output [FIFO_PTR_WIDE : 0] fifo_slack;
    output fifo_uplink_ready;
    output fifo_downlink_ready;
    
    wire clk;
    wire rst_n;
    wire fifo_en;
    wire fifo_wr_en;
    wire fifo_rd_en;
    wire [FIFO_WIDE - 1 : 0] fifo_data_in;
    wire [FIFO_WIDE - 1 : 0] fifo_data_out;
    wire fifo_full;
    wire fifo_empty;
    wire [FIFO_PTR_WIDE : 0] fifo_slack;
    wire [FIFO_PTR_WIDE - 1 : 0] wr_addr;
    wire [FIFO_PTR_WIDE - 1 : 0] rd_addr;
    //internal
    wire clk_in;

    assign clk_in = clk && fifo_en;

    ram  #(
    	.FIFO_DEPTH(FIFO_DEPTH),
    	.FIFO_WIDE(FIFO_WIDE),
    	.FIFO_PTR_WIDE(FIFO_PTR_WIDE))
    ram_u (
        .clk(clk_in),
        .rst_n(rst_n),
        .rd_en(fifo_rd_en),
        .wr_en(fifo_wr_en),
        .empty(fifo_empty),
        .full(fifo_full),
        .wr_addr(wr_addr),    
        .rd_addr(rd_addr),    
        .data_in(fifo_data_in),
        .data_out(fifo_data_out));

    wr_addr_gen #(
        .FIFO_PTR_WIDE(FIFO_PTR_WIDE))
    wr_addr_gen_u (
        .clk(clk_in),
        .rst_n(rst_n),
        .full(fifo_full),
        .wr_en(fifo_wr_en),
        .wr_addr(wr_addr));

    rd_addr_gen #(
        .FIFO_PTR_WIDE(FIFO_PTR_WIDE))
    rd_addr_gen_u (
        .clk(clk_in),
        .rst_n(rst_n),
        .empty(fifo_empty),
        .rd_en(fifo_rd_en),
        .rd_addr(rd_addr));

    flag_gen #(
    	.FIFO_PTR_WIDE(FIFO_PTR_WIDE),
    	.MAX_CNT(MAX_CNT))
    flag_gen_u (
    	.clk(clk_in),
    	.rst_n(rst_n),
    	.wr_en(fifo_wr_en),
    	.rd_en(fifo_rd_en),
    	.full(fifo_full),
    	.empty(fifo_empty),
    	.slack(fifo_slack),
        .uplink_ready(fifo_uplink_ready),
        .downlink_ready(fifo_downlink_ready));
endmodule







