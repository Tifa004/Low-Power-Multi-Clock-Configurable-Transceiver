module edge_counter (
	input clk,
	input rst,
	input enable, 
	input stop,
	input [5:0] prescale,   
	output reg [3:0] bit_cnt, 
	output reg [5:0] edge_cnt 
	
);

always @(posedge clk or negedge rst) begin 
	if(~rst) begin
		 edge_cnt <= 0;
		 bit_cnt  <= 0;
	end else if (enable) begin
		if (edge_cnt== prescale-1) begin
			bit_cnt <= bit_cnt + 1;
			edge_cnt <= 0;
	end else
			edge_cnt <= edge_cnt + 1;
		end
	else if (stop && edge_cnt==0)
		bit_cnt=0;
	else begin
		edge_cnt<=0;
		bit_cnt<=0;
	end
	
end
endmodule 