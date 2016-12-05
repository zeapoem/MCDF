module fifo_tb ;
    parameter FIFO_DEPTH = 4'b1000;    //depth is 8
    parameter FIFO_WIDE = 6'b10_0000;    //data wide is 32
    parameter FIFO_PTR_WIDE = 2'b11;
    parameter MAX_CNT = 4'b1000;    //d8 

    reg clk;
    reg rst_n;
    reg fifo_wr_en;
    reg fifo_rd_en;
    reg [FIFO_WIDE-1 : 0] fifo_data_in;
    wire [FIFO_WIDE-1 : 0] fifo_data_out;
    wire fifo_full;
    wire fifo_empty;
    wire [FIFO_PTR_WIDE : 0] fifo_slack;
    wire fifo_uplink_ready;
    wire fifo_downlink_ready;
    wire fifo_en;

    fifo #( 
        .FIFO_DEPTH(FIFO_DEPTH),
        .FIFO_WIDE(FIFO_WIDE),
        .FIFO_PTR_WIDE(FIFO_PTR_WIDE),
        .MAX_CNT(MAX_CNT))
    fifo_u_test (
        .clk(clk),
        .rst_n(rst_n),
        .fifo_en(fifo_en),
        .fifo_wr_en(fifo_wr_en),
        .fifo_rd_en(fifo_rd_en),
        .fifo_data_in(fifo_data_in),
        .fifo_data_out(fifo_data_out),
        .fifo_full(fifo_full),
        .fifo_empty(fifo_empty),
        .fifo_slack(fifo_slack),
        .fifo_uplink_ready(fifo_uplink_ready),
        .fifo_downlink_ready(fifo_downlink_ready));  



    reg [4 : 0] count;
    assign fifo_en = 1;
    initial clk = 0;
    always #5 clk = ~clk;
    
    initial fifo_data_in = 0; 
    always @ (posedge clk) fifo_data_in <= fifo_data_in + 1;

    initial  begin 
        rst_n = 0;
        fifo_wr_en = 0;
        fifo_rd_en = 0;
    end // initial
    initial count = 0;
    always @(posedge clk)
        count = count + 1;
    always @(count) begin
        if (count == 5'b11111)
            {rst_n, fifo_wr_en, fifo_rd_en}  =  {rst_n, fifo_wr_en, fifo_rd_en} + 1;
        else 
            {rst_n, fifo_wr_en, fifo_rd_en}  =  {rst_n, fifo_wr_en, fifo_rd_en};
    end


endmodule

    

