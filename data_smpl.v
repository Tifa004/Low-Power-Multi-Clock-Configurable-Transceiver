module data_smpl (
	input clk,

	input rst,

	input enable,    

	input [5:0] edge_cnt, 

	input IN, 

	input [5:0] prescale,

	output reg sampled 

	

);



reg [1:0] count_ones;

reg [1:0] count_zeros;


always @(posedge clk or negedge rst) begin 

	if(!rst) begin

		count_ones<=0;

		count_zeros<=0;

	end

	else if(edge_cnt==prescale/2 | edge_cnt== prescale/2 +1 | edge_cnt==prescale/2 -1) begin

		if(IN)

			count_ones<=count_ones+1;

		else

			count_zeros<=count_zeros+1;

		end else if (edge_cnt== prescale/2 +2) begin
			count_ones<=0;
			count_zeros<=0;
end



end

always @(posedge clk ) begin 

	if(count_ones>count_zeros && (edge_cnt== prescale/2 +1)) begin

		sampled<=1;

	end

	else if (count_ones<count_zeros && (edge_cnt== prescale/2 +1))begin

		sampled<=0;

	end

end

endmodule 