module flag_tb;
    parameter PTR_WIDE = 2'b11;    //d3
    parameter MAX_CNT = 4'b1000;  
    
   
    reg clk;
    reg rst_n;
    reg rd_en;
    reg wr_en;
    wire empty;
    wire full;
    wire [PTR_WIDE : 0 ] slack;
    
    flag_gen #(
        .PTR_WIDE(PTR_WIDE),
        .MAX_CNT(MAX_CNT))
    flag_gen_u_tb (
        .clk(clk),
        .rst_n(rst_n),
        .wr_en(wr_en),
        .rd_en(rd_en),
        .full(full),
        .empty(empty),
        .slack(slack));

   // reg [3 : 0]count;
    
    
    
    initial clk = 0;
    always #5 clk = ~clk;

    initial {rst_n, wr_en, rd_en} = 0;
/*    initial count = 0;
    always @(posedge clk) count = count + 1;
    
    
    always @(negedge clk) begin
        if (count == 4'b1111) begin
            {rst_n, wr_en, rd_en} = {rst_n, wr_en, rd_en} + 1;
            
        end
        else begin
            
            {rst_n, wr_en, rd_en} = {rst_n, wr_en, rd_en};
        end
    end
*/
    initial  begin 
        #200 rst_n = 1;
             wr_en = 1;
             rd_en = 0;

        #100 wr_en = 0;
             rd_en = 1;
    end



endmodule     
