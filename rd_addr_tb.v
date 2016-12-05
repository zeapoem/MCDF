module rd_addr_tb;
    reg clk;
    reg rst_n;
    reg empty;
    reg rd_en;
    wire [2 : 0] rd_addr;
    reg [3 : 0]Count;
    
    rd_addr_gen  #(
        .FIFO_PTR_WIDE ( 2'b11))
    rd_addr_gen_u (
        .clk(clk),
        .rst_n(rst_n),
        .empty(empty),
        .rd_en(rd_en),
        .rd_addr(rd_addr));
    
    initial clk = 0;
    always #5 clk = ~clk;

    initial {rst_n, empty, rd_en} = 0;
    initial Count = 0;
    always @(posedge clk) Count = Count + 1;
    
    
    always @(negedge clk) begin
        if (Count == 4'b1111) begin
            {rst_n, empty, rd_en} = {rst_n, empty, rd_en} + 1;
            
        end
        else begin
            
            {rst_n, empty, rd_en} = {rst_n, empty, rd_en};
        end
    end
endmodule     
