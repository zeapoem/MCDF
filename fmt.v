module fmt(
    clk,
    rst_n,
    fmt_uplink_chid,
    fmt_fifo0_length,
    fmt_fifo1_length,
    fmt_fifo2_length,
    fmt_grant,
    fmt_uplink_valid,   
    fmt_data_in,
    fmt_uplink_ready,
    fmt_chid,
    fmt_length,
    fmt_req,
    fmt_start,
    fmt_end,
    fmt_data);
    
    parameter CH0 = 2'b00;
    parameter CH1 = 2'b01;
    parameter CH2 = 2'b10;
    parameter DATA_WIDE = 6'b10_0000;
    parameter CACHE_PTR_WIDE = 3'b110;
    parameter FMT_CACHE_DEPTH = 7'b100_0000;  
    parameter RESET = 7'b000_0001;    //7'h01;
    parameter CHECK = 7'b000_0010;    //7'h02;
    parameter HAND_SHAKE = 7'b000_0100;    //7'h04
    parameter SEND_START = 7'b000_1000;    //7'h08
    parameter DATA_SEND1 = 7'b001_0000;    //7'h10 
    parameter DATA_SEND2 = 7'b010_0000;   //7'h20    
    parameter SEND_END = 7'b100_0000;    //7'h40
    

    input clk;
    input rst_n;
    input [1 : 0] fmt_uplink_chid;
    input [2 : 0] fmt_fifo0_length;
    input [2 : 0] fmt_fifo1_length;
    input [2 : 0] fmt_fifo2_length;
    input fmt_grant;
    input fmt_uplink_valid;
    input [DATA_WIDE - 1 : 0] fmt_data_in;

    output fmt_uplink_ready;
    output [1 : 0] fmt_chid;
    output [5 : 0] fmt_length;    
    output fmt_req; 
    output fmt_start;
    output fmt_end;
    output [DATA_WIDE - 1 :0] fmt_data;

    wire clk;
    wire rst_n;
    wire [1 : 0] fmt_uplink_chid;
    wire [2 : 0] fmt_fifo0_length;
    wire [2 : 0] fmt_fifo1_length;
    wire [2 : 0] fmt_fifo2_length;
    wire fmt_grant;
    wire [31 : 0] fmt_data_in;

    wire fmt_uplink_ready;
    reg [1 : 0] fmt_chid;
    reg [5 : 0] fmt_length;
    reg fmt_req;
    reg fmt_start;
    reg fmt_end;
    reg [DATA_WIDE - 1 : 0] fmt_data;
    reg [1 : 0] flag_chid;
    
    wire fifo_en;
    wire cache0_wr_en;   
    reg cache0_rd_en;    
    wire [DATA_WIDE - 1 : 0] cache0_data_out;
    wire cache0_full;    
    wire cache0_empty;    
    wire [CACHE_PTR_WIDE : 0] cache0_slack;

    wire cache1_wr_en;   
    reg cache1_rd_en;    
    wire [DATA_WIDE - 1 : 0] cache1_data_out;
    wire cache1_full;    
    wire cache1_empty;    
    wire [CACHE_PTR_WIDE : 0] cache1_slack;

    wire cache2_wr_en;   
    reg cache2_rd_en;    
    wire [DATA_WIDE - 1 : 0] cache2_data_out;
    wire cache2_full;    
    wire cache2_empty;    
    wire [CACHE_PTR_WIDE : 0] cache2_slack;

    wire [CACHE_PTR_WIDE : 0] cache0_data_avi;
    wire [CACHE_PTR_WIDE : 0] cache1_data_avi;
    wire [CACHE_PTR_WIDE : 0] cache2_data_avi; 
    
    wire [5 : 0] CH0_length_decode;
    wire [5 : 0] CH1_length_decode;
    wire [5 : 0] CH2_length_decode;
    wire [5 : 0] length_chosen;
    reg [5 : 0] flag_length;
    wire flag_output_ready;
    reg [5 : 0] volum_unsenddata; 
    
    //instantiate 3 * FIFO 32wide*64depth
    assign fifo_en = 1;
    fifo #(    
        .FIFO_DEPTH(FMT_CACHE_DEPTH),    
        .FIFO_WIDE(DATA_WIDE),   
        .FIFO_PTR_WIDE(CACHE_PTR_WIDE),
        .MAX_CNT(FMT_CACHE_DEPTH))
    fmt_cache0 ( 
        .clk(clk),
        .fifo_en(fifo_en),
        .rst_n(rst_n),
        .fifo_wr_en(cache0_wr_en),    
        .fifo_rd_en(cache0_rd_en),    
        .fifo_data_in(fmt_data_in),
        .fifo_data_out(cache0_data_out),
        .fifo_full(cache0_full),    
        .fifo_empty(cache0_empty),    
        .fifo_slack(cache0_slack),
        .fifo_uplink_ready(),
        .fifo_downlink_ready());
        
    fifo #(    
        .FIFO_DEPTH(FMT_CACHE_DEPTH),    
        .FIFO_WIDE(DATA_WIDE),   
        .FIFO_PTR_WIDE(CACHE_PTR_WIDE),
        .MAX_CNT(FMT_CACHE_DEPTH))
    fmt_cache1 ( 
        .clk(clk),
        .fifo_en(fifo_en),
        .rst_n(rst_n),
        .fifo_wr_en(cache1_wr_en),    
        .fifo_rd_en(cache1_rd_en),    
        .fifo_data_in(fmt_data_in),
        .fifo_data_out(cache1_data_out),
        .fifo_full(cache1_full),    
        .fifo_empty(cache1_empty),    
        .fifo_slack(cache1_slack),
        .fifo_uplink_ready(),
        .fifo_downlink_ready());
    
    fifo #(    
        .FIFO_DEPTH(FMT_CACHE_DEPTH),    
        .FIFO_WIDE(DATA_WIDE),   
        .FIFO_PTR_WIDE(CACHE_PTR_WIDE),
        .MAX_CNT(FMT_CACHE_DEPTH))
    fmt_cache2 ( 
        .clk(clk),
        .fifo_en(fifo_en),
        .rst_n(rst_n),
        .fifo_wr_en(cache2_wr_en),    
        .fifo_rd_en(cache2_rd_en),    
        .fifo_data_in(fmt_data_in),
        .fifo_data_out(cache2_data_out),
        .fifo_full(cache2_full),    
        .fifo_empty(cache2_empty),    
        .fifo_slack(cache2_slack),
        .fifo_uplink_ready(),
        .fifo_downlink_ready());
    
    //fmt_uplink handshake   
    assign cache0_wr_en = (rst_n) && ((fmt_uplink_chid == CH0)? ((cache0_full)? 0 : 1) : 0);
    assign cache1_wr_en = (rst_n) && ((fmt_uplink_chid == CH1)? ((cache1_full)? 0 : 1) : 0);
    assign cache2_wr_en = (rst_n) && ((fmt_uplink_chid == CH2)? ((cache2_full)? 0 : 1) : 0);
    assign fmt_uplink_ready = rst_n && (cache0_wr_en || cache1_wr_en || cache2_wr_en); 
    //downlink
    //decoded fifox_length to interal signal chx_length_decode
    assign CH0_length_decode = (fmt_fifo0_length == 3'b000)? 6'b00_0100 :
                               (fmt_fifo0_length == 3'b001)? 6'b00_1000 :
                               (fmt_fifo0_length == 3'b010)? 6'b01_0000 :
                               (fmt_fifo0_length >= 3'b011)? 6'b10_0000 : 0;
    assign CH1_length_decode = (fmt_fifo1_length == 3'b000)? 6'b00_0100 :
                               (fmt_fifo1_length == 3'b001)? 6'b00_1000 :
                               (fmt_fifo1_length == 3'b010)? 6'b01_0000 :
                               (fmt_fifo1_length >= 3'b011)? 6'b10_0000 : 0;
    assign CH2_length_decode = (fmt_fifo2_length == 3'b000)? 6'b00_0100 :
                               (fmt_fifo2_length == 3'b001)? 6'b00_1000 :
                               (fmt_fifo2_length == 3'b010)? 6'b01_0000 :
                               (fmt_fifo2_length >= 3'b011)? 6'b10_0000 : 0;
    //cache_chosen illustrate which channel will be send 
    assign cache0_data_avi = FMT_CACHE_DEPTH - cache0_slack;
    assign cache1_data_avi = FMT_CACHE_DEPTH - cache1_slack;
    assign cache2_data_avi = FMT_CACHE_DEPTH - cache2_slack;
    assign cache_chosen = (cache0_data_avi >= (CH0_length_decode ))? CH0 :
                          (cache1_data_avi >= (CH1_length_decode ))? CH1 :
                          (cache2_data_avi >= (CH2_length_decode ))? CH2 : 2'b11;
    //flag_output_ready indicates whether the cache has stored a packet of data
    assign flag_output_ready = (cache_chosen != 2'b11)? 1'b1 : 1'b0; 
   
    assign length_chosen = (cache_chosen == CH0)? CH0_length_decode :
                           (cache_chosen == CH1)? CH1_length_decode :
                           (cache_chosen == CH2)? CH2_length_decode : 0;    
    //fmt downlink FSM, onehot code
    reg [6 : 0] current_state;
    reg [6 : 0] next_state;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) current_state <= RESET;
        else current_state <= next_state;
    end 
    //set volum_unsenddata to control state DATA_OUT repeat times 
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            volum_unsenddata <= 0;
        else if (fmt_req) volum_unsenddata <= flag_length - 1;
        else if (fmt_data != 0) volum_unsenddata <= volum_unsenddata - 1;
        else  volum_unsenddata <= volum_unsenddata;
    end 
    //states transfer judge
    always @(current_state or 
             flag_output_ready or 
             fmt_grant or 
             volum_unsenddata or 
             flag_length) begin
        case (current_state)
        RESET : next_state = CHECK;
        CHECK : begin 
            if (flag_output_ready) next_state = HAND_SHAKE;
            else next_state = CHECK;
        end
        HAND_SHAKE : begin
            if (fmt_grant) next_state = SEND_START;
            else next_state = HAND_SHAKE;
        end
        SEND_START : next_state = DATA_SEND1;
        //DATA_SEND state repeats (volum_unsenddata - 1)
        //because we use combinational logic output
        DATA_SEND1 : begin
            if (volum_unsenddata != 5'b0_0001) next_state = DATA_SEND2;
            else next_state = SEND_END;
        end
        DATA_SEND2 : begin
            if (volum_unsenddata != 5'b0_0001) next_state = DATA_SEND1;
            else next_state = SEND_END;
        end
        SEND_END : next_state = RESET;
        default : next_state = RESET;      
        endcase
    end
    //combinational logic output and inter states flag varify
    always @(current_state or flag_chid or length_chosen) begin
        case(current_state)
        RESET : begin
            fmt_chid <= 0;
            fmt_length <= 0;
            fmt_req <= 0;
            fmt_start <= 0;
            fmt_end <= 0;
            fmt_data <= 0;
            flag_length <= 0;
            flag_chid <= 0;
            cache0_rd_en <= 0;
            cache1_rd_en <= 0;
            cache2_rd_en <= 0;            
        end
        CHECK : begin
            //recode which cache satisfies length requirement
            flag_chid <= cache_chosen;
            flag_length <= length_chosen;
        end
        HAND_SHAKE : begin
            fmt_chid <= flag_chid;
            fmt_length <= flag_length;
            fmt_req <= 1;
            //verifies cache rd_en and wr_en for next_state SEND_START
            case (flag_chid)
            CH0 : cache0_rd_en <= 1;
            CH1 : cache1_rd_en <= 1;
            CH2 : cache2_rd_en <= 1;
            default : begin
                cache0_rd_en <= 0;
                cache1_rd_en <= 0;
                cache2_rd_en <= 0;
            end
            endcase
        end
        //send the 1st data of a packet stored in the cache
        SEND_START : begin
            fmt_req <= 0;
            fmt_start <= 1;
            case (flag_chid)
            CH0 : fmt_data <= cache0_data_out;
            CH1 : fmt_data <= cache1_data_out;
            CH2 : fmt_data <= cache2_data_out;
            default : fmt_data <= 0;
            endcase
        end
        //send data of a packet stored in the cache except the 1st and the last
        DATA_SEND1 : begin
            fmt_start <= 0;
            case (flag_chid)
            CH0 : fmt_data <= cache0_data_out;
            CH1 : fmt_data <= cache1_data_out;
            CH2 : fmt_data <= cache2_data_out;
            default : fmt_data <= 0;
            endcase
        end
        DATA_SEND2 : begin
            case (flag_chid)
            CH0 : fmt_data <= cache0_data_out;
            CH1 : fmt_data <= cache1_data_out;
            CH2 : fmt_data <= cache2_data_out;
            default : fmt_data <= 0;
            endcase
        end
        //send the last data of a packet stored in the cache
        //overwr caches input signal rd_en
        SEND_END : begin
            fmt_end <= 1;
            case (flag_chid)
            CH0 : fmt_data <= cache0_data_out;
            CH1 : fmt_data <= cache1_data_out;
            CH2 : fmt_data <= cache2_data_out;
            default : fmt_data <= 0;
            endcase
            cache0_rd_en <= 0;
            cache1_rd_en <= 0;
            cache2_rd_en <= 0;
        end
        endcase
    end
endmodule // fmt