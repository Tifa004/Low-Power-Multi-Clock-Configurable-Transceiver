module Parity (
	input [7:0] Data,
	input P_type,
	output reg P_bit
	
);
always @* begin 
	if(P_type) begin
		P_bit = ~^Data;
	end else begin
		P_bit = ^Data ;
	end
end

endmodule 