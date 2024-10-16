module UART_TOP (
	input RX_IN_S,    
	input TX_CLK,RX_CLK,
	input RST,
	input TX_IN_V,
	input parity_enable,parity_type,
	output TX_OUT_V,TX_OUT_S,
	input [7:0] TX_IN_P,
	//RX
	input [5:0] Prescale,
	output RX_OUT_V,
	output [7:0] RX_OUT_P,
	output parity_error,framing_error
	
);

UART_TX U0(TX_IN_V,TX_CLK,RST,parity_enable,parity_type,TX_IN_P,TX_OUT_S,TX_OUT_V);

UART_RX U1(RX_CLK,RST,RX_IN_S,Prescale,parity_enable,parity_type,RX_OUT_V,RX_OUT_P,framing_error,parity_error);

endmodule 