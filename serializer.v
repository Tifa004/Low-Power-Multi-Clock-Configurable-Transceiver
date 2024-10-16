module serializer (
	input [7:0] Data,
	input ser_en,
	input clk,rst,
	output reg ser_done,
	output reg ser_data
	
);
integer C;
reg [7:0] DATA;
always @(posedge clk or negedge rst) begin 
	if(~rst)begin
		C<=0;
		DATA<=0;
	end
	else if (ser_en) begin
    DATA<=DATA>>1;
    C <= C + 1;
  end else begin
  	C<=0;
  	DATA<=Data;
  end
end

 always @* begin
 	ser_done=C==7?1'b1:1'b0;
 	ser_data=ser_en?DATA[0]:0;
 end
endmodule 
