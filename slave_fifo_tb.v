module slave_fifo_tb;
    //modify
    
    parameter FIFO_DEPTH = 4'b1000;    //d8
    parameter FIFO_WIDE = 6'b10_0000;    //d32
    parameter FIFO_PTR_WIDE = 2'b11;
    parameter MAX_CNT = 4'b1000; 

    reg clk;
    reg rst_n;
    reg uplink_valid;
    reg downlink_valid;
    reg [FIFO_WIDE - 1 : 0] data_in;
    wire uplink_ready;
    wire downlink_ready;
    wire [FIFO_PTR_WIDE : 0] fifo_slack;
    wire [FIFO_WIDE - 1 : 0] data_out;

    slave_fifo slave_fifo_u_tb (
        .clk(clk),
        .rst_n(rst_n),
        .uplink_valid(uplink_valid),
        .downlink_valid(downlink_valid),
        .data_in(data_in),
        .uplink_ready(uplink_ready),
        .downlink_ready(downlink_ready),
        .fifo_slack(fifo_slack),
        .data_out(data_out));  
    
    
    
    initial clk = 0;
    always #5 clk = ~clk;

    initial begin 
    {rst_n,uplink_valid,downlink_valid} = 3'b000;
    end
    initial begin 
    #100
    {rst_n ,uplink_valid, downlink_valid} = 3'b110;
    #100 {uplink_valid, downlink_valid }= 2'b11;
    end
    initial data_in = 0;
    always @(posedge clk) data_in = data_in + 1; 

endmodule     

