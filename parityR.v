module parity_R (

	input P_type,  

	input enable,

	input P_bit,

	input [7:0] data,

	output reg error

	

);



always @* begin

	if(enable && ~P_type) begin

	 error=^data==P_bit?1'b0:1'b1;

	end else if (enable && P_type) begin

		error=~^data==P_bit?1'b0:1'b1;

	end

	else 

		error=1'b0;

end

endmodule