module FSM (
	input clk,rst,
	input ser_done,
	input P_EN,
	input Data_Vld,
	input [7:0] DataIN,
	output reg [1:0] mux_sel,
	output reg ser_en,
	output reg busy,
	output reg [7:0] Data2Ser
);

reg [2:0]Current_state;
reg [2:0] Next_state;

localparam IDLE=0;
localparam Start=1;
localparam Data=2;
localparam Parity=3;
localparam Stop=4;

always @(posedge clk or negedge rst) begin 
	if(~rst) begin

		 Current_state<= IDLE;
		 Data2Ser<=0;

	end else if(Data_Vld && ~busy)begin
		 Current_state<=Start ;
		 Data2Ser<=DataIN;

	end
	else 
		Current_state<=Next_state;
end

always @* begin 
	case (Current_state)
		Start:  begin
					 mux_sel=0;
					 busy=1;
					 Next_state=Data;
				end	
		Data:   begin
					mux_sel=1;
					ser_en=1;
					busy=1;
					if(ser_done && P_EN)
						Next_state=Parity;
					else if (ser_done && ~P_EN)
						Next_state=Stop;
					else
						Next_state=Data;
				end
		Parity: begin
					mux_sel=2;
					ser_en=0;
					busy=1;
					Next_state=Stop;
				end
		Stop:   begin
					 mux_sel=3;
					 ser_en=0;
					 busy=1;
					 Next_state=IDLE;
			    end
		IDLE:   begin
					 mux_sel=3;
					 ser_en=0;
					 busy=0;
					 Next_state=IDLE;
			    end
		default :   begin 
						Next_state=IDLE;
						mux_sel=3;
						ser_en=0;
						busy=0;
					end
	endcase
end
endmodule 