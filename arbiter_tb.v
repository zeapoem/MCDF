module arbiter_tb;
    
    parameter FIFO_WIDE = 6'b10_0000;    //32bit 
    reg clk;
    reg rst_n;
    reg arbiter_en;
    reg [1 : 0] ch0_priority;
    reg [1 : 0] ch1_priority;
    reg [1 : 0] ch2_priority;
    reg arb_uplink_valid;
    reg arb_downlink_valid;
    reg [FIFO_WIDE - 1 : 0] arb_ch0_data_in;
    reg [FIFO_WIDE - 1 : 0] arb_ch1_data_in;
    reg [FIFO_WIDE - 1 : 0] arb_ch2_data_in;
    
    wire arb_uplink_ready0;
    wire arb_uplink_ready1;
    wire arb_uplink_ready2;
    wire arb_downlink_ready;
    wire [1 : 0] ch_chosen_out;
    wire [FIFO_WIDE - 1 : 0] data_out;
    reg [2 : 0] count;
    reg arb_uplink_valid0;
    reg arb_uplink_valid1;
    reg arb_uplink_valid2;
   
    arbiter #(
        .FIFO_WIDE(FIFO_WIDE))
    aribiter_u_tb(
        .clk(clk),
        .rst_n(rst_n),
        .arb_ch0_priority(ch0_priority),
        .arb_ch1_priority(ch1_priority),
        .arb_ch2_priority(ch2_priority),
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
        .arb_ch_chosen(ch_chosen_out),
        .arb_data_out(data_out));

    
    
    initial clk = 0;
    always #5 clk = ~clk;

    initial arb_ch0_data_in = 0; 
    always @ (posedge clk) arb_ch0_data_in <= arb_ch0_data_in + 1;

    initial arb_ch1_data_in = 13; 
    always @ (posedge clk) arb_ch1_data_in <= arb_ch1_data_in + 1;

    initial arb_ch2_data_in = 37; 
    always @ (posedge clk) arb_ch2_data_in <= arb_ch2_data_in + 1;

    

    
    initial begin  
        rst_n = 0;
        arb_downlink_valid = 0;
        arb_uplink_valid0 = 0;
        arb_uplink_valid1 = 0;
        arb_uplink_valid2 = 0;
        arbiter_en = 0;
        #100 rst_n = 1;
        #100 arbiter_en = 1;
        #100 arb_uplink_valid0 = 1;
        #100 arb_uplink_valid1 = 1;
        #100 arb_uplink_valid2 = 1;
        #100 arb_downlink_valid = 1;
    end

    initial count = 0;
    always @(posedge clk)  count = count + 1;
    initial {ch0_priority,
             ch1_priority,
             ch2_priority} =  0;
    always @(count) begin
        if (count ==  3'b111)
            {ch0_priority,
             ch1_priority,
             ch2_priority} =  

            {ch0_priority,
             ch1_priority,
             ch2_priority}  + 1;     
        else 
            {ch0_priority,
             ch1_priority,
             ch2_priority} =  

            {ch0_priority,
             ch1_priority,
             ch2_priority} ;
    end
/*
    initial begin
        arbiter_en = 0;
        ch0_priority = 2'b00;
        ch1_priority = 2'b00;
        ch2_priority = 2'b00;
        arb_uplink_valid = 0;
        rst_n = 0;
        arb_downlink_valid = 0;

        #100 rst_n = 1;
        #100 arbiter_en = 1;
        #100 arb_uplink_valid = 1;
        #100 arb_downlink_valid = 1;

        #100 ch0_priority = 2'b01;
        #100 ch1_priority = 2'b01;
        #100 ch2_priority = 2'b01;
        #100 ch2_priority = 2'b11;
        #100 ch1_priority = 2'b11;

        #100 arbiter_en = 0;
    end

*/

endmodule
            
