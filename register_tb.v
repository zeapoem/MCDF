module register_tb;

    parameter FIFO_PTR_WIDE = 6'b10_0000;
    parameter CMD_WIDE = 6'b10_0000;
    parameter BL_WIDE = 4'b1000;
    parameter WL_WIDE = 4'b1000;
    parameter CMD_STATE_IDLE = 5'b0_0001;
    parameter CMD_STATE_WR = 5'b0_0010;
    parameter CMD_STATE_RD_PRE = 5'b0_0100;
    parameter CMD_STATE_RD = 5'b0_1000;
    parameter CMD_RST = 5'b1_0000;
    parameter IDLE = 2'b00;
    parameter WR = 2'b01;
    parameter RD = 2'b11;
    parameter FIFO0_DEPTH = 8'b000_1000;
    parameter FIFO1_DEPTH = 8'b000_1000;
    parameter FIFO2_DEPTH = 8'b000_1000;

    reg clk;
    reg rst_n;
    reg [1 : 0] cmd;
    reg [WL_WIDE - 1 : 0] cmd_addr;
    reg [CMD_WIDE - 1 : 0] cmd_data_in;
    reg [FIFO_PTR_WIDE : 0] cmd_fifo0_slack;
    reg [FIFO_PTR_WIDE : 0] cmd_fifo1_slack;
    reg [FIFO_PTR_WIDE : 0] cmd_fifo2_slack;
    wire [CMD_WIDE - 1  : 0] cmd_data_out;
    wire cmd_slave0_en;
    wire cmd_slave1_en;
    wire cmd_slave2_en;
    wire [1 : 0] cmd_fifo0_priority;
    wire [1 : 0] cmd_fifo1_priority;
    wire [1 : 0] cmd_fifo2_priority;
    wire [2 : 0] cmd_fifo0_length;
    wire [2 : 0] cmd_fifo1_length;
    wire [2 : 0] cmd_fifo2_length;
    
    register register_u_tb(
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

    initial clk = 0;
    always #5 clk = ~clk;

    initial rst_n = 0;
    initial #50 rst_n = 1;
      
    initial begin
        cmd_addr = 8'b0000_0000;
        cmd = 2'b01;
        cmd_data_in = 8'h00;
        cmd_fifo0_slack = 3'b111;
        cmd_fifo1_slack = 3'b011;
        cmd_fifo2_slack = 3'b000;
        
        #100 cmd_data_in = 8'b1111_1111;
       

        #500 cmd = 2'b11;
        #500 cmd = 2'b00;

        #500 rst_n =0;
    end
endmodule
