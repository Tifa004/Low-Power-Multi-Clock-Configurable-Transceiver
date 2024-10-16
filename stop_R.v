module stop_R (

	input enable,    

	input stop_bit, 

	output reg error  

);



always @* begin 

	if(enable) begin

		error=stop_bit==1?1'b0:1'b1;

	end

	else 

		error=1'b0;

end

endmodule 