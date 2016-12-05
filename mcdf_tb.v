module mcdf_tb;

    parameter DATA_WIDE = 6'b10_0000;
    parameter CMD_WIDE = 6'b10_0000;
    parameter BL_WIDE = 4'b1000;
    parameter WL_WIDE = 4'b1000;
    
    reg clk;
    reg rst_n;
    reg [1 : 0] cmd;
    reg [WL_WIDE - 1 : 0] cmd_addr;
    reg [CMD_WIDE - 1 : 0] cmd_data_in;
    reg ch0_valid;
    reg ch1_valid;
    reg ch2_valid;
    reg fmt_grant;
    reg [DATA_WIDE - 1 : 0] ch0_data;
    reg [DATA_WIDE - 1 : 0] ch1_data;
    reg [DATA_WIDE - 1 : 0] ch2_data;
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


    
mcdf mcdf_u_tb (
    .clk(clk),
    .rst_n(rst_n),
    .cmd(cmd),
    .cmd_addr(cmd_addr),
    .cmd_data_in(cmd_data_in),
    .ch0_valid(ch0_valid),
    .ch1_valid(ch1_valid),
    .ch2_valid(ch2_valid),
    .fmt_grant(fmt_grant),
    .ch0_data(ch0_data),
    .ch1_data(ch1_data),
    .ch2_data(ch2_data),
    .ch0_ready(ch0_ready),
    .ch1_ready(ch1_ready),
    .ch2_ready(ch2_ready),
    .fmt_chid(fmt_chid),
    .fmt_length(fmt_length),
    .fmt_req(fmt_req),
    .fmt_start(fmt_start),
    .fmt_end(fmt_end),
    .cmd_data_out(cmd_data_out),
    .fmt_data(fmt_data));
 
    initial clk = 0;
    always #5 clk = ~clk;

    initial  begin
        ch0_data = 0;
        ch1_data = 10;
        ch2_data = 33;
    end
    always @(posedge clk) begin
        ch0_data = ch0_data + 1;
        ch0_data = ch1_data + 1;
        ch0_data = ch2_data + 1;
    end
    initial begin
         cmd_data_in = 8'b0000_0111;
         rst_n = 0;
         #50 rst_n = 1;
    end

    initial begin
        cmd = 2'b00;
        cmd_addr = 8'b0000_0000;
        cmd = 2'b01;
              
        #500 cmd_addr = 8'h14; 
             cmd = 2'b11;
        #100 cmd_addr = 8'h08;
        #500 cmd = 2'b00;
    end
        
    initial begin
        ch0_valid = 0;
        ch1_valid = 0;
        ch2_valid = 0;
        fmt_grant = 0;  
        #100
        ch0_valid = 1;
        ch1_valid = 1;
        ch2_valid = 1;
        fmt_grant = 1;
    end
endmodule
   
    
