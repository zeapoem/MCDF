//wr_addr & rd_addr ponit to the same addr when empty or full
//module flag_gen produce full and empty flag

module rd_addr_gen (
	clk,
	rst_n,
	empty,
	rd_en,
	rd_addr);

    parameter FIFO_PTR_WIDE = 2'b11;   //d3 can point to 8bit  

    input clk;
    input rst_n;
    input empty;
    input rd_en;
    output [FIFO_PTR_WIDE - 1 : 0] rd_addr;
    
    wire clk;
    wire rst_n;
    wire rd_en;
    reg [FIFO_PTR_WIDE - 1 : 0] rd_addr;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) rd_addr <= 0;
        else begin 
            if (rd_en && !empty) rd_addr <= rd_addr + 1;
            else rd_addr <= rd_addr;
        end
    end

endmodule
