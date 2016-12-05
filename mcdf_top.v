module mcdf (
    clk,
    rst_n,
    cmd,
    cmd_addr,
    cmd_data_in,
    ch0_valid,
    ch1_valid,
    ch2_valid,
    fmt_grant,
    ch0_data,
    ch1_data,
    ch2_data,
    ch0_ready,
    ch1_ready,
    ch2_ready,
    fmt_chid,
    fmt_length,
    fmt_req,
    fmt_start,
    fmt_end,
    cmd_data_out,
    fmt_data);
    
    parameter DATA_WIDE = 6'b10_0000;
    parameter FIFO_WIDE = 6'b10_0000;
    parameter FIFO_PTR_WIDE = 2'b11;
    parameter CMD_WIDE = 6'b10_0000;
    parameter BL_WIDE = 4'b1000;
    parameter WL_WIDE = 4'b1000;
     
    input clk;
    input rst_n;
    input [1 : 0] cmd;
    input [WL_WIDE - 1 : 0] cmd_addr;
    input [CMD_WIDE - 1 : 0] cmd_data_in;
    input ch0_valid;
    input ch1_valid;
    input ch2_valid;
    input fmt_grant;
    input [DATA_WIDE - 1 : 0] ch0_data;
    input [DATA_WIDE - 1 : 0] ch1_data;
    input [DATA_WIDE - 1 : 0] ch2_data;
    output ch0_ready;
    output ch1_ready;
    output ch2_ready;
    output [1 : 0] fmt_chid;
    output [5 : 0] fmt_length;   
    output fmt_req;
    output fmt_start;
    output fmt_end;
    output [CMD_WIDE - 1  : 0] cmd_data_out;
    output [DATA_WIDE - 1 :0] fmt_data;
    
    wire clk;
    wire rst_n;
    wire [1 : 0] cmd;
    wire [WL_WIDE - 1 : 0] cmd_addr;
    wire [CMD_WIDE - 1 : 0] cmd_data_in;
    wire ch0_valid;
    wire ch1_valid;
    wire ch2_valid;
    wire fmt_grant;
    wire [DATA_WIDE - 1 : 0] ch0_data;
    wire [DATA_WIDE - 1 : 0] ch1_data;
    wire [DATA_WIDE - 1 : 0] ch2_data;
    wire ch0_ready;
    wire ch1_ready;
    wire ch2_ready;
    wire [1 : 0] fmt_chid;
    wire [5 : 0] fmt_length;   
    wire fmt_req;
    wire fmt_start;
    wire fmt_end;
    wire [CMD_WIDE - 1 : 0] cmd_data_out;
    wire [DATA_WIDE - 1 :0] fmt_data;
    //internal signal
    wire [FIFO_PTR_WIDE : 0] cmd_fifo0_slack;
    wire [FIFO_PTR_WIDE : 0] cmd_fifo1_slack;
    wire [FIFO_PTR_WIDE : 0] cmd_fifo2_slack;
    wire cmd_slave0_en;
    wire cmd_slave1_en;
    wire cmd_slave2_en;
    wire [1 : 0] cmd_fifo0_priority;
    wire [1 : 0] cmd_fifo1_priority;
    wire [1 : 0] cmd_fifo2_priority;
    wire [2 : 0] cmd_fifo0_length;
    wire [2 : 0] cmd_fifo1_length;
    wire [2 : 0] cmd_fifo2_length;
    wire arb_uplink_valid0;
    wire arb_uplink_valid1;
    wire arb_uplink_valid2;
    wire arb_downlink_valid;
    wire [FIFO_WIDE - 1 : 0] arb_ch0_data_in;
    wire [FIFO_WIDE - 1 : 0] arb_ch1_data_in;
    wire [FIFO_WIDE - 1 : 0] arb_ch2_data_in;
    wire arb_uplink_ready0;
    wire arb_uplink_ready1;
    wire arb_uplink_ready2;
    wire arb_downlink_ready;
    wire [1 : 0] arb_ch_chosen;
    wire [FIFO_WIDE - 1 : 0] arb_data_out;

register register_u_mcdf (
    .clk(clk),
    .rst_n(rst_n),
    .cmd(cmd),
    .cmd_addr(cmd_addr),
    .cmd_data_in(cmd_data_in),
    .cmd_fifo0_slack(cmd_fifo0_slack),
    .cmd_fifo1_slack(cmd_fifo1_slack),
    .cmd_fifo2_slack(cmd_fifo2_slack),
    .cmd_data_out(cmd_data_out),
    .cmd_slave0_en(cmd_slave0_en),
    .cmd_slave1_en(cmd_slave1_en),
    .cmd_slave2_en(cmd_slave2_en),
    .cmd_fifo0_priority(cmd_fifo0_priority),
    .cmd_fifo1_priority(cmd_fifo1_priority),
    .cmd_fifo2_priority(cmd_fifo2_priority),
    .cmd_fifo0_length(cmd_fifo0_length),
    .cmd_fifo1_length(cmd_fifo1_length),
    .cmd_fifo2_length(cmd_fifo2_length));    
   
fifo fifo_u_mcdf0 (
    .clk(clk),
    .fifo_en(cmd_slave0_en),
    .rst_n(rst_n),
    .fifo_wr_en(ch0_valid),    //uplink control 
    .fifo_rd_en(arb_uplink_ready0),    //uplink control
    .fifo_data_in(ch0_data),
    .fifo_data_out(arb_ch0_data_in),
    .fifo_full(),    
    .fifo_empty(),    
    .fifo_slack(cmd_fifo0_slack),
    .fifo_uplink_ready(ch0_ready),
    .fifo_downlink_ready(arb_uplink_valid0));   

fifo fifo_u_mcdf1 (
    .clk(clk),
    .fifo_en(cmd_slave1_en),
    .rst_n(rst_n),
    .fifo_wr_en(ch1_valid),    //uplink control 
    .fifo_rd_en(arb_uplink_ready1),    //uplink control
    .fifo_data_in(ch1_data),
    .fifo_data_out(arb_ch1_data_in),
    .fifo_full(),    
    .fifo_empty(),    
    .fifo_slack(cmd_fifo1_slack),
    .fifo_uplink_ready(ch1_ready),
    .fifo_downlink_ready(arb_uplink_valid1)); 

fifo fifo_u_mcdf2 (
    .clk(clk),
    .fifo_en(cmd_slave2_en),
    .rst_n(rst_n),
    .fifo_wr_en(ch2_valid),    //uplink control 
    .fifo_rd_en(arb_uplink_ready2),    //uplink control
    .fifo_data_in(ch2_data),
    .fifo_data_out(arb_ch2_data_in),
    .fifo_full(),    
    .fifo_empty(),    
    .fifo_slack(cmd_fifo2_slack),
    .fifo_uplink_ready(ch2_ready),
    .fifo_downlink_ready(arb_uplink_valid2));   

arbiter arbiter_u_mcdf (
    .clk(clk),
    .rst_n(rst_n),
    .arb_ch0_priority(cmd_fifo0_priority),
    .arb_ch1_priority(cmd_fifo1_priority),
    .arb_ch2_priority(cmd_fifo2_priority),
    .arb_uplink_valid0(arb_uplink_valid0),
    .arb_uplink_valid1(arb_uplink_valid1),
    .arb_uplink_valid2(arb_uplink_valid2),
    .arb_downlink_valid(arb_downlink_valid),
    .arb_ch0_data_in(arb_ch0_data_in),
    .arb_ch1_data_in(arb_ch1_data_in),
    .arb_ch2_data_in(arb_ch2_data_in),
    .arb_downlink_ready(arb_downlink_ready),
    .arb_uplink_ready0(arb_uplink_ready0),
    .arb_uplink_ready1(arb_uplink_ready1),
    .arb_uplink_ready2(arb_uplink_ready2),
    .arb_ch_chosen(arb_ch_chosen),
    .arb_data_out(arb_data_out));

    fmt fmt_u_mcdf(
    .clk(clk),
    .rst_n(rst_n),
    .fmt_uplink_chid(arb_ch_chosen),
    .fmt_fifo0_length(cmd_fifo0_length),
    .fmt_fifo1_length(cmd_fifo1_length),
    .fmt_fifo2_length(cmd_fifo2_length),
    .fmt_grant(fmt_grant),
    .fmt_uplink_valid(arb_downlink_ready),   
    .fmt_data_in(arb_data_out),
    .fmt_uplink_ready(arb_downlink_valid),
    .fmt_chid(fmt_chid),
    .fmt_length(fmt_length),
    .fmt_req(fmt_req),
    .fmt_start(fmt_start),
    .fmt_end(fmt_end),
    .fmt_data(fmt_data));

endmodule


    
