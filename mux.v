module mux (
	input [1:0] mux_sel,
	input ser_data,
	input P_bit,
	output reg TX_OUT
);
localparam Start=0;
localparam Stop=1;
always @* begin 
	case (mux_sel)
		0:TX_OUT<=Start;
		1:TX_OUT<=ser_data;
		2:TX_OUT<=P_bit;
		3:TX_OUT<=Stop;
	
		default : TX_OUT<=Stop;
	endcase
end
endmodule 