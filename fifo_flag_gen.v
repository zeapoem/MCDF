module flag_gen (
    clk,
    rst_n,
    wr_en,
    rd_en,
    full,
    empty,
    slack,
    uplink_ready,
    downlink_ready);

    parameter FIFO_PTR_WIDE = 2'b11;    //d3
    parameter MAX_CNT = 4'b1000;    //d8 

    input clk;
    input rst_n;
    input wr_en;
    input rd_en;
    output full;
    output empty;
    output [FIFO_PTR_WIDE : 0] slack; 
    output uplink_ready;
    output downlink_ready;

    wire clk;
    wire rst_n;
    wire wr_en;
    wire rd_en;
    wire full;
    wire empty;
    reg [FIFO_PTR_WIDE : 0] count;   //4bit   
    wire [FIFO_PTR_WIDE : 0] slack;
    wire uplink_ready;
    wire downlink_ready;

    always @ (posedge clk or negedge rst_n) begin
        if (!rst_n) count <= 0;
        else begin
            case ({wr_en , rd_en})
                2'b00 : count <= count;
                2'b01 : begin
                    if (count == 0)
                        count <= count;
                    else count <= count - 1;
                end
                2'b10 : begin
                    if (count == MAX_CNT)
                        count <= count;
                    else count <= count + 1;
                end
                2'b11 : count <= count;
                default count <= 0;
            endcase
         end
    end
    //state signal output
    assign full = (count == MAX_CNT)? 1 : 0;
    assign empty = (count == 0)? 1 : 0;
    assign slack = MAX_CNT - count;
    assign uplink_ready = rst_n && (!full);
    assign downlink_ready = rst_n && (!empty);
endmodule 
