module UART_RX (

	input clk,    // Clock

	input rst,

	input IN,

	input [5:0]prescale,

	input P_EN,

	input P_type,

	output Valid,

	output [7:0] Data,

	output framing_error,

	output parity_error

);



wire smpl_en,edge_en,sampled,deser_en,

stp_err,stp_en,strt_glitch,strt_en,P_err,P_check_en,stop;

wire [5:0] edge_cnt;

wire [3:0] bit_cnt;

assign parity_error=P_err;

assign framing_error=stp_err;



FSM_R U0(clk,rst,IN,bit_cnt,P_EN,P_err,strt_glitch,stp_err,prescale,edge_cnt,smpl_en,edge_en,deser_en,P_check_en,strt_en,stp_en,Valid,stop);

edge_counter U1(clk,rst,edge_en,stop,prescale,bit_cnt,edge_cnt);

data_smpl U2(clk,rst,smpl_en,edge_cnt,IN,prescale,sampled);

deserializer U3(clk,deser_en,sampled,rst,Data);

stop_R U4(stp_en,sampled,stp_err);

strt U5(rst,clk,strt_en,sampled,strt_glitch);

parity_R U6(P_type,P_check_en,sampled,Data,P_err);



endmodule 