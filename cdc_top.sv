`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/05/2022 10:58:49 AM
// Design Name: 
// Module Name: cdc_top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module cdc_top(

    );

logic clk_src = 0, clk_dest = 0, valid_src = 0;
logic [31:0] data_src = 0;
    
cdc#(32)
uut(
    .clk_src     (clk_src),   
    .valid_src   (valid_src),
    .data_src    (data_src),   
    .clk_dest    (clk_dest),
    .valid_dest  (),
    .data_dest   ()
);


initial begin
    #($urandom_range(1, 5))
   forever #(2ns) clk_src = ~clk_src;
end
initial begin
   #($urandom_range(6, 10))
   forever #(5ns) clk_dest = ~clk_dest;
end

initial begin
    #($urandom_range(40, 80));
    repeat(20) begin
        @(posedge clk_src);
        valid_src   = 1;
        data_src    = $random();
//        @(posedge clk_src);
//        valid_src   = 0;
//        data_src    = 0;
//        repeat(4) @(posedge clk_src);
    end
end

endmodule
