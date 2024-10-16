module strt (
	input rst,clk,

	input enable,    

	input start_bit,

	output reg glitch 

	

);

always @(posedge clk or negedge rst) begin
	if(~rst)
		glitch<=0;

	else if(enable) begin

		glitch<=start_bit;

	end 

end



endmodule 