module ram (
	clk,
    rst_n,
	rd_en,
	wr_en,
    empty,
    full,
	wr_addr,    //write pointer
	rd_addr,    //read  pointer
	data_in,
	data_out);
    
    parameter FIFO_DEPTH = 4'b1000;    //depth is 8
    parameter FIFO_WIDE = 6'b10_0000;    //data wide is 32
    parameter FIFO_PTR_WIDE = 2'b11;
    
    input clk; 
    input rst_n;   
    input rd_en;
    input wr_en;    //fifo_flag_gen
    input full;     //fifo_flag_gen
    input empty;    
    input [FIFO_PTR_WIDE - 1 : 0] wr_addr;    
    input [FIFO_PTR_WIDE - 1 : 0] rd_addr;    
    input [FIFO_WIDE - 1 : 0] data_in;
    output [FIFO_WIDE - 1 : 0] data_out;
    
    wire clk; 
    wire rst_n;   
    wire rd_en;
    wire wr_en;    //fifo_flag_gen
    wire full;     //fifo_flag_gen
    wire empty; 
    wire [FIFO_WIDE - 1 : 0] data_in;
    reg [FIFO_WIDE - 1 : 0] data_out;    
    
    //defin fifo_ram 32*8
    reg [FIFO_WIDE - 1 : 0] fifo_ram [FIFO_DEPTH - 1 : 0];    
    //read prosess
    always @(posedge clk or rst_n) begin
        if(!rst_n) data_out <= 0;
    	else if (rd_en && (!empty)) data_out <= fifo_ram[rd_addr];
        else data_out <= 0;
    end
    //write prosess
    always @(posedge clk) begin    
    	if (wr_en && (!full)) fifo_ram[wr_addr] <= data_in;    		
    end
endmodule