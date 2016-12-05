module fmt_tb;
    parameter DATA_WIDE = 6'b10_0000;

    reg clk;
    reg rst_n;
    reg [1 : 0] fmt_uplink_chid;
    reg [2 : 0] fmt_fifo0_length;
    reg [2 : 0] fmt_fifo1_length;
    reg [2 : 0] fmt_fifo2_length;
    reg fmt_grant;
    reg fmt_uplink_valid;
    reg [31 : 0] fmt_data_in;
    
    wire [1 : 0] fmt_chid;
    wire [5 : 0] fmt_length;
    wire fmt_uplink_ready;
    wire fmt_req;
    wire fmt_start;
    wire fmt_end;
    wire [DATA_WIDE - 1 : 0] fmt_data;

fmt fmt_u_tb(
    .clk(clk),
    .rst_n(rst_n),
    .fmt_uplink_chid(fmt_uplink_chid),
    .fmt_fifo0_length(fmt_fifo0_length),
    .fmt_fifo1_length(fmt_fifo1_length),
    .fmt_fifo2_length(fmt_fifo2_length),
    .fmt_grant(fmt_grant),
    .fmt_uplink_valid(fmt_uplink_valid),   
    .fmt_data_in(fmt_data_in),
    .fmt_uplink_ready(fmt_uplink_ready),
    .fmt_chid(fmt_chid),
    .fmt_length(fmt_length),
    .fmt_req(fmt_req),
    .fmt_start(fmt_start),
    .fmt_end(fmt_end),
    .fmt_data(fmt_data));
    


 /*   parameter DATA_WIDE = 6'b10_0000;
    parameter CACHE_PTR_WIDE = 3'b110;
    parameter FMT_CACHE_DEPTH = 7'b100_0000;  
    parameter CHECK = 6'b00_0001;
    parameter HAND_SHAKE = 6'b00_0010;
    parameter SENT_START = 6'b00_0100; 
    parameter DATA_SENT = 6'b00_1000;
    parameter SENT_END = 6'b01_0000;
    parameter FLAG_CLR = 6'b10_0000; 
    parameter DATA_WIDE = 6'b10_0000;
    parameter CACHE_PTR_WIDE = 3'b110;
    parameter FMT_CACHE_DEPTH = 7'b100_0000;  
    parameter CHECK = 6'b00_0001;
    parameter HAND_SHAKE = 6'b00_0010;
    parameter SENT_START = 6'b00_0100; 
    parameter DATA_SENT = 6'b00_1000;
    parameter SENT_END = 6'b01_0000;
    parameter FLAG_CLR = 6'b10_0000;

    input clk;
    input rst_n;
    input fmt_uplink_chid;
    input fmt_grant;
    input fmt_uplink_valid;
    input fmt_data_in;

    output fmt_uplink_ready;
    output fmt_chid;
    output fmt_length;
    output fmt_req; 
    output fmt_start;
    output fmt_end;
    output fmt_data;
*/
   
    
   
    initial clk = 0;
    always #5 clk = ~clk;

    initial rst_n = 0;
    initial #50 rst_n = 1;
    
    initial fmt_data_in = 0;
    always @(posedge clk) fmt_data_in = fmt_data_in + 1;
    
    initial fmt_fifo0_length = 3'b011;
    initial fmt_fifo1_length = 3'b011;
    initial fmt_fifo2_length = 3'b011;
    initial begin
        fmt_uplink_chid = 2'b01;
        fmt_uplink_valid = 1;
        fmt_grant = 1;

        #500 fmt_uplink_chid = 2'b10;
     

        #500 fmt_uplink_chid = 2'b11;

        #5000 rst_n = 0;
    end

endmodule


