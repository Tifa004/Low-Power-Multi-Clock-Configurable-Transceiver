module FIFO #( parameter Data_Width=16) (
	input w_clk,w_rst,w_inc,
	input r_clk,r_rst,r_inc,
	input [Data_Width-1:0] w_data,
	output full,empty,
	output [Data_Width-1:0] r_data
);

wire [2:0] waddr,raddr;
wire [3:0] rptr,wptr;
wire [3:0] sync_rptr,sync_wptr;

Fifo_mem #(.Data_Width(Data_Width)) U0(w_clk,w_rst,full,w_inc,w_data,waddr,raddr,r_data);
BIT_SYNC #(.NUM_STAGES(2),.BUS_WIDTH(4)) U1(w_clk,w_rst,rptr,sync_rptr);
BIT_SYNC #(.NUM_STAGES(2),.BUS_WIDTH(4)) U2(r_clk,r_rst,wptr,sync_wptr);
Fifo_read U3(r_clk,r_rst,r_inc,sync_wptr,raddr,empty,rptr);
Fifo_write U4(w_clk,w_rst,w_inc,sync_rptr,full,waddr,wptr);
endmodule 