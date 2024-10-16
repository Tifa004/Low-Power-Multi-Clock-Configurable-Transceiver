module Fifo_write (
	input clk, 
	input rst,
	input inc,
	input [3:0] sync_rptr,
	output reg full,
	output [2:0] waddr,
	output reg [3:0] gray_w_ptr   
	
);
reg [3:0] w_ptr;

always @(posedge clk or negedge rst)
 begin
  if(!rst)
   begin
    w_ptr<= 0 ;
   end
 else if (!full && inc)
    w_ptr <= w_ptr + 1 ;
 end

assign waddr=w_ptr[2:0];

always @(posedge clk or negedge rst)
 begin
  if(!rst)
   begin
    gray_w_ptr <= 0 ;
   end
 else
  begin
  gray_w_ptr<={w_ptr[3],w_ptr[3]^w_ptr[2],w_ptr[1]^w_ptr[2],w_ptr[0]^w_ptr[1]};
  end
 end

always @* begin
	full= ((sync_rptr[3]!=gray_w_ptr[3])&&(sync_rptr[2]!=gray_w_ptr[2])&&( sync_rptr[1:0]==gray_w_ptr[1:0]));
end
endmodule 