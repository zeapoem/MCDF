module register (
    clk,
    rst_n,
    cmd,
    cmd_addr,
    cmd_data_in,
    cmd_fifo0_slack,
    cmd_fifo1_slack,
    cmd_fifo2_slack,
    cmd_data_out,
    cmd_slave0_en,
    cmd_slave1_en,
    cmd_slave2_en,
    cmd_fifo0_priority,
    cmd_fifo1_priority,
    cmd_fifo2_priority,
    cmd_fifo0_length,
    cmd_fifo1_length,
    cmd_fifo2_length);
    
    parameter FIFO_PTR_WIDE = 2'b11;
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
    
    input clk;
    input rst_n;
    input [1 : 0] cmd;
    input [WL_WIDE - 1: 0] cmd_addr;
    input [CMD_WIDE - 1 : 0] cmd_data_in;
    input [FIFO_PTR_WIDE : 0] cmd_fifo0_slack;
    input [FIFO_PTR_WIDE : 0] cmd_fifo1_slack;
    input [FIFO_PTR_WIDE : 0] cmd_fifo2_slack;
    output [CMD_WIDE - 1 : 0] cmd_data_out;
    output cmd_slave0_en;
    output cmd_slave1_en;
    output cmd_slave2_en;
    output [1 : 0] cmd_fifo0_priority;
    output [1 : 0] cmd_fifo1_priority;
    output [1 : 0] cmd_fifo2_priority;
    output [2 : 0] cmd_fifo0_length;
    output [2 : 0] cmd_fifo1_length;
    output [2 : 0] cmd_fifo2_length;

    wire clk;
    wire rst_n;
    wire [1 : 0] cmd;
    wire [WL_WIDE - 1: 0] cmd_addr;
    wire [CMD_WIDE - 1 : 0] cmd_data_in;
    wire [FIFO_PTR_WIDE : 0] cmd_fifo0_slack;
    wire [FIFO_PTR_WIDE : 0] cmd_fifo1_slack;
    wire [FIFO_PTR_WIDE : 0] cmd_fifo2_slack;
    reg [CMD_WIDE - 1 : 0] cmd_data_out;
    wire cmd_slave0_en;
    wire cmd_slave1_en;
    wire cmd_slave2_en;
    wire [1 : 0] cmd_fifo0_priority;
    wire [1 : 0] cmd_fifo1_priority;
    wire [1 : 0] cmd_fifo2_priority;
    wire [2 : 0] cmd_fifo0_length;
    wire [2 : 0] cmd_fifo1_length;
    wire [2 : 0] cmd_fifo2_length;
    //internal signal
    wire [BL_WIDE - 1 : 0] ch0_ctr_signal;
    wire [BL_WIDE - 1 : 0] ch1_ctr_signal;
    wire [BL_WIDE - 1 : 0] ch2_ctr_signal;
    wire [BL_WIDE - 1 : 0] reg_fifo0_slack;
    wire [BL_WIDE - 1 : 0] reg_fifo1_slack;
    wire [BL_WIDE - 1 : 0] reg_fifo2_slack;
    
    //setup a memory to store cmd
    reg [BL_WIDE - 1 : 0] reg_ram [31 : 0];
    
    //use onehot key FSM to reset & wr & idle & rd
    reg [4 : 0] current_state;
    reg [4 : 0] next_state;
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) current_state <= CMD_RST;
        else current_state <= next_state;
    end
    //states transfer judge
    //CMD_RST can only be started when !rst_n  verifies current_state    
    always @(current_state or cmd) begin
        case (current_state)
        CMD_STATE_IDLE : begin 
            case (cmd)
            IDLE : next_state = CMD_STATE_IDLE;
            WR : next_state = CMD_STATE_WR;
            RD : next_state = CMD_STATE_RD_PRE;
            default : next_state = CMD_STATE_IDLE;
            endcase
        end
        CMD_STATE_WR : begin 
            case (cmd)
            IDLE : next_state = CMD_STATE_IDLE;
            WR : next_state = CMD_STATE_WR;
            RD : next_state = CMD_STATE_RD_PRE;
            default : next_state = CMD_STATE_IDLE;
            endcase
        end
        CMD_STATE_RD_PRE : next_state = CMD_STATE_RD;
        CMD_STATE_RD : begin 
            case (cmd)
            IDLE : next_state = CMD_STATE_IDLE;
            WR : next_state = CMD_STATE_WR;
            RD : next_state = CMD_STATE_RD_PRE;
            default : next_state = CMD_STATE_IDLE;
            endcase
        end
        CMD_RST : begin 
            case (cmd)
            IDLE : next_state = CMD_STATE_IDLE;
            WR : next_state = CMD_STATE_WR;
            RD : next_state = CMD_STATE_RD_PRE;
            default : next_state = CMD_STATE_IDLE;
            endcase
        end
        default : next_state = CMD_RST;
        endcase
    end
    //cmd ram wr & rd
    always @(current_state or cmd) begin
        case (current_state)
        CMD_STATE_IDLE : cmd_data_out <= 0;
        CMD_STATE_WR : begin
            //control register wr 
            case (cmd_addr) 
            8'h00 : reg_ram [8'h00] <= cmd_data_in & 8'b0011_1111;
            8'h04 : reg_ram [8'h04] <= cmd_data_in & 8'b0011_1111;
            8'h08 : reg_ram [8'h08] <= cmd_data_in & 8'b0011_1111;
            endcase
        end
        CMD_STATE_RD_PRE : cmd_data_out <= 0;
        CMD_STATE_RD : cmd_data_out <= reg_ram[cmd_addr];
        CMD_RST : begin
            //control register wr
            //0x00 channel
            reg_ram [8'h00] <= 8'b0000_0111;
            reg_ram [8'h01] <= 8'b0000_0000;
            reg_ram [8'h02] <= 8'b0000_0000;
            reg_ram [8'h03] <= 8'b0000_0000;  
            //0x04 channel
            reg_ram [8'h04] <= 8'b0000_0111;
            reg_ram [8'h05] <= 8'b0000_0000;
            reg_ram [8'h06] <= 8'b0000_0000;
            reg_ram [8'h07] <= 8'b0000_0000;  
            //0x08 channel
            reg_ram [8'h08] <= 8'b0000_0111;
            reg_ram [8'h09] <= 8'b0000_0000;
            reg_ram [8'h0A] <= 8'b0000_0000;
            reg_ram [8'h0B] <= 8'b0000_0000;
        end // CMD_RST :
        default : cmd_data_out <= 0;
        endcase        
    end
    //register control signal output
 
    //state regiser wr
    assign reg_fifo0_slack[FIFO_PTR_WIDE : 0] = cmd_fifo0_slack;
    assign reg_fifo1_slack[FIFO_PTR_WIDE : 0] = cmd_fifo1_slack;
    assign reg_fifo2_slack[FIFO_PTR_WIDE : 0] = cmd_fifo2_slack;

    always @(posedge clk or negedge rst_n) begin 
        if (!rst_n) begin
            //bit [7:0] FIFOx_depth
            reg_ram [8'h10] <= FIFO0_DEPTH;
            reg_ram [8'h11] <= 8'b0000_0000;
            reg_ram [8'h12] <= 8'b0000_0000;
            reg_ram [8'h13] <= 8'b0000_0000;
            //0x14 channel
            reg_ram [8'h14] <= FIFO1_DEPTH;
            reg_ram [8'h15] <= 8'b0000_0000;
            reg_ram [8'h16] <= 8'b0000_0000;
            reg_ram [8'h17] <= 8'b0000_0000;
            //0x18 channel
            reg_ram [8'h18] <= FIFO2_DEPTH;
            reg_ram [8'h19] <= 8'b0000_0000;
            reg_ram [8'h1A] <= 8'b0000_0000;
            reg_ram [8'h1B] <= 8'b0000_0000;
        end
        else begin
            reg_ram [8'h10] <= reg_fifo0_slack;
            reg_ram [8'h14] <= reg_fifo1_slack;
            reg_ram [8'h18] <= reg_fifo2_slack;
        end
    end
    //fifo priority output
    assign cmd_fifo0_priority = ch0_ctr_signal[2 : 1];
    assign cmd_fifo1_priority = ch1_ctr_signal[2 : 1];
    assign cmd_fifo2_priority = ch2_ctr_signal[2 : 1];
    //setup variables to keep control info byte in the ram
    assign ch0_ctr_signal = reg_ram [8'h00];
    assign ch1_ctr_signal = reg_ram [8'h04];
    assign ch2_ctr_signal = reg_ram [8'h08];
    //slave enable output
    assign cmd_slave0_en = rst_n && ch0_ctr_signal[0];
    assign cmd_slave1_en = rst_n && ch1_ctr_signal[0];
    assign cmd_slave2_en = rst_n && ch2_ctr_signal[0];
    //fifo_length output
    assign cmd_fifo0_length = ch0_ctr_signal[5 : 3];
    assign cmd_fifo1_length = ch1_ctr_signal[5 : 3];
    assign cmd_fifo2_length = ch2_ctr_signal[5 : 3];
endmodule // register

    

