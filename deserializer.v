module deserializer (

	input clk,

	input enable,    

	input sampled, 

	input rst, 

	output reg [7:0] data 

	

);



reg [3:0] c;



always @(posedge clk or negedge rst) begin 

	if(!rst) begin

		data = 0;

		c = 0;

	end else if(enable) begin



		data[c] = sampled ;



	if (c==7) begin

		c =0;

	end else

		c = c+1;

	end

end 
	

endmodule 