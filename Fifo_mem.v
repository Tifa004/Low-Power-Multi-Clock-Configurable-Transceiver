module Fifo_mem #(
	parameter Data_Width=8,
	parameter fifo_width=8) (
	input clk,    
	input rst,
	input full,
	input inc, 
	input [Data_Width-1:0] Data,
	input [2:0] w_addr,
	input [2:0] r_addr,
	output reg [Data_Width-1:0] r_data 
	
);
reg [fifo_width-1:0] i;
reg [Data_Width-1:0] mem [fifo_width-1:0];

always @(posedge clk or negedge rst) begin 
	if(~rst) begin
		 for (i = 0; i < fifo_width; i = i + 1) begin
    mem[i] <= 0;
  end
	end else if(inc && ~full) begin
		mem[w_addr] <=Data ;

	end
	end
	
always @* begin
	r_data=mem[r_addr];
end

endmodule 
