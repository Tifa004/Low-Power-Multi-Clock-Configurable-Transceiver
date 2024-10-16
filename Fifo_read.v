module Fifo_read (
	input clk,
	input rst,
	input inc,
	input [3:0] sync_wptr,
	output [2:0] raddr,
	output reg empty,
	output reg [3:0] gray_r_ptr
	
);

reg [3:0] r_ptr;

always @(posedge clk or negedge rst)
 begin
  if(!rst)
   begin
    r_ptr<= 0 ;
   end
 else if (!empty && inc)
   r_ptr <= r_ptr + 1 ;
 end

assign raddr=r_ptr[2:0];

always @(posedge clk or negedge rst) begin
 if(!rst)
   begin
    gray_r_ptr <= 0 ;
   end
 else 
  begin
    gray_r_ptr<={r_ptr[3],r_ptr[3]^r_ptr[2],r_ptr[1]^r_ptr[2],r_ptr[0]^r_ptr[1]};
  end
 end

always @* begin
empty= sync_wptr==gray_r_ptr;	
end

endmodule 