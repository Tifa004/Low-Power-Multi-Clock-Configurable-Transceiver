module UART_TX (
	input Data_VLD,clk,rst,
	input P_EN,
	input P_type,
	input [7:0] Data,
	output TX_OUT,busy
);
wire ser_en;
wire ser_done;
wire ser_data;
wire [1:0] mux_sel;
wire P_bit;
wire [7:0] Data2Ser;


serializer U0(Data2Ser,ser_en,clk,rst,ser_done,ser_data);
FSM U1(clk,rst,ser_done,P_EN,Data_VLD,Data,mux_sel,ser_en,busy,Data2Ser);
Parity U2(Data2Ser,P_type,P_bit);
mux U3(mux_sel,ser_data,P_bit,TX_OUT);






endmodule 