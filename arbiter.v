module arbiter (
    clk,
    rst_n,
    arb_ch0_priority,
    arb_ch1_priority,
    arb_ch2_priority,
    arb_uplink_valid0,
    arb_uplink_valid1,
    arb_uplink_valid2,
    arb_downlink_valid,
    arb_ch0_data_in,
    arb_ch1_data_in,
    arb_ch2_data_in,
    arb_downlink_ready,
    arb_uplink_ready0,
    arb_uplink_ready1,
    arb_uplink_ready2,
    arb_ch_chosen,
    arb_data_out);

    parameter FIFO_WIDE = 6'b10_0000;    //32bit 
    parameter CH0 = 2'b00;
    parameter CH1 = 2'b01;
    parameter CH2 = 2'b10;

    input clk;
    input rst_n;
    input [1 : 0] arb_ch0_priority;
    input [1 : 0] arb_ch1_priority;
    input [1 : 0] arb_ch2_priority;
    input arb_uplink_valid0;
    input arb_uplink_valid1;
    input arb_uplink_valid2;
    input arb_downlink_valid;
    input [FIFO_WIDE - 1 : 0] arb_ch0_data_in;
    input [FIFO_WIDE - 1 : 0] arb_ch1_data_in;
    input [FIFO_WIDE - 1 : 0] arb_ch2_data_in;
    output arb_uplink_ready0;
    output arb_uplink_ready1;
    output arb_uplink_ready2;
    output arb_downlink_ready;
    output [1 : 0] arb_ch_chosen;
    output [FIFO_WIDE - 1 : 0] arb_data_out;

    wire clk;
    wire rst_n;
    wire [1 : 0] arb_ch0_priority;
    wire [1 : 0] arb_ch1_priority;
    wire [1 : 0] arb_ch2_priority;
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
    reg [1 : 0] arb_ch_chosen;
    wire [FIFO_WIDE - 1 : 0] arb_data_out;
    
    //priority
    always @(rst_n or arb_uplink_valid2 or arb_uplink_valid1 or arb_uplink_valid0 or
        arb_ch2_priority or arb_ch1_priority or arb_ch0_priority) begin
        if (!rst_n) arb_ch_chosen = 2'b11;
        else 
        case ({arb_uplink_valid2, arb_uplink_valid1, arb_uplink_valid0})
            3'b001 : arb_ch_chosen = CH0;
            3'b010 : arb_ch_chosen = CH1;
            3'b100 : arb_ch_chosen = CH2;
            3'b011 : if(arb_ch1_priority >= arb_ch0_priority) arb_ch_chosen = CH0;
                     else arb_ch_chosen = CH1;
            3'b101 : if(arb_ch0_priority >= arb_ch2_priority) arb_ch_chosen = CH2;
                     else arb_ch_chosen = CH0;
            3'b110 : if(arb_ch2_priority >= arb_ch1_priority) arb_ch_chosen = CH1; 
                     else arb_ch_chosen = CH2;
            3'b111: begin
                if (arb_ch2_priority >= arb_ch0_priority) begin
                    if(arb_ch1_priority >= arb_ch0_priority) arb_ch_chosen = CH0;
                    else arb_ch_chosen = CH1;
                end
                else if (arb_ch1_priority >= arb_ch2_priority) begin
                    if(arb_ch0_priority >= arb_ch2_priority) arb_ch_chosen = CH2;
                    else arb_ch_chosen = CH0;
                end
                else if (arb_ch0_priority >= arb_ch1_priority) begin
                    if(arb_ch2_priority >= arb_ch1_priority) arb_ch_chosen = CH1; 
                    else arb_ch_chosen = CH2;
                end
            end
            default : arb_ch_chosen = 2'b11;
        endcase
    end
    //hankshake port    
    assign arb_downlink_ready = ((arb_ch_chosen ==2'b11)? 0 : 1);
    assign arb_uplink_ready0 = arb_downlink_valid && (arb_ch_chosen==CH0);
    assign arb_uplink_ready1 = arb_downlink_valid && (arb_ch_chosen==CH1);
    assign arb_uplink_ready2 = arb_downlink_valid && (arb_ch_chosen==CH2);
    //arb data outputs
    assign arb_data_out = (arb_ch_chosen == CH0)? arb_ch0_data_in :
                          (arb_ch_chosen == CH1)? arb_ch1_data_in :
                          (arb_ch_chosen == CH2)? arb_ch2_data_in : 0;
   endmodule