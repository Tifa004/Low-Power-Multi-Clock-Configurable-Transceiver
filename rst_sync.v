module rst_sync #(

    parameter NUM_STAGES = 1

    ) (

    input clk,          

    input rst,             

    output synced_rst

);





reg   [NUM_STAGES-1:0]    sync_reg;
        

//double flop synchronizer
always @(posedge clk or negedge rst)
 begin
  if(!rst)      // active low
   begin
    sync_reg <= 'b0 ;
   end
  else
   begin
    sync_reg <= {sync_reg[NUM_STAGES-2:0],1'b1} ;
   end  
 end
 
 
assign  synced_rst = sync_reg[NUM_STAGES-1] ;



endmodule

