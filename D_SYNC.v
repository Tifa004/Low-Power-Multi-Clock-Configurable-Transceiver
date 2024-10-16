module D_SYNC #(
	parameter Bus_Width=8,
	Stages=5
	) (
	input clk,rst,bus_enable,
	input [Bus_Width-1:0] Data,
	output reg [Bus_Width-1:0] sync_bus,
	output reg enable  
	
);

wire enable_multi;
wire enable_multi_1;
wire en;
BIT_SYNC #(.NUM_STAGES(Stages)) U0(clk,rst,bus_enable,enable_multi);
pulse_gen U1(enable_multi,clk,rst,en);

always @(posedge clk or negedge rst) begin
	if(~rst) begin
		 sync_bus<= 0;
		 enable  <=0;
	end else begin
		if(en) 
			sync_bus <= Data ;
		else
			sync_bus <= sync_bus;
		enable <= en;
		
	end
end
endmodule 