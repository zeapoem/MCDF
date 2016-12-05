module wr_addr_gen(
	clk,
	rst_n,
	full,
	wr_en,
	wr_addr
	);
    
    parameter FIFO_PTR_WIDE = 2'b11;
       
    input clk;
    input rst_n;
    input full;
    input wr_en;
    output [FIFO_PTR_WIDE - 1 : 0] wr_addr;

    wire clk;
    wire rst_n;
    wire full;
    wire wr_en;
    reg [FIFO_PTR_WIDE - 1 : 0] wr_addr;

    always @(posedge clk or negedge rst_n) begin
    	if (!rst_n) wr_addr <= 0;    	
    	else if (!full && wr_en) wr_addr <= wr_addr + 1;
        else wr_addr <= wr_addr;
    end
endmodule

