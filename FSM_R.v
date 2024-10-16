module FSM_R (
	input clk,rst,
	input IN,
	input[3:0] bit_cnt,
	input P_EN,
	input P_error,
	input strt_glitch,
	input stp_error,
	input [5:0] prescale,
	input [5:0] edge_cnt,
	output reg smpl_en,
	output reg edge_en,
	output reg deserializer_en,
	output reg P_check_en,
	output reg strt_en,
	output reg stp_en,
	output reg Valid,
	output reg stop
);

	reg [2:0]Current_state;
	reg [2:0] Next_state;
	reg S;

	localparam[2:0] IDLE=3'b000,
	 Start=3'b001,
	 Data=3'b010,
	 Parity=3'b011,
	 Stop=3'b100,
	 Done=3'b101;

	always @(posedge clk or negedge rst ) begin
		if(!rst) begin
			Current_state<= IDLE;

		end
		else if(~IN && ~S )begin
			Current_state<=Start ;
		end
		else begin
			Current_state<=Next_state;
		end
	end

	always @* begin
		smpl_en=0;
		edge_en=0;
		deserializer_en=0;
		P_check_en=0;
		strt_en=0;
		stp_en=0;
		Valid=0;
		S=0;
		stop=0;
		case (Current_state)

			Start: begin
				S=1;
				deserializer_en=0;
				P_check_en=0;
				stp_en=0;
				Valid=0;
				stop=0;
				edge_en=1;
				smpl_en=1;
				strt_en=1;
				Next_state=bit_cnt?Data:Start;
			end

			Data: begin
				if(strt_glitch) begin
					S=1;
					deserializer_en=0;
					P_check_en=0;
					stp_en=0;
					Valid=0;
					stop=0;
					edge_en=1;
					smpl_en=1;
					strt_en=1;
					Next_state=IDLE;
				end else begin
					S=1;
					P_check_en=0;
					stp_en=0;
					Valid=0;
					stop=0;
					edge_en=1;
					smpl_en=1;
					strt_en=0;
					deserializer_en=edge_cnt==prescale/2 +2?1'b1:1'b0;
					Next_state=bit_cnt==9?(P_EN?Parity:Stop):Data;
				end
			end

			Parity: begin
				S=1;
				stp_en=0;
				Valid=0;
				stop=0;
				edge_en=1;
				smpl_en=1;
				strt_en=0;
				deserializer_en=0;
				P_check_en=edge_cnt==prescale/2 +2?1'b1:1'b0;
				Next_state=bit_cnt==10?Stop:Parity;
			end

			Stop: begin
				S=1;
				Valid=0;
				edge_en=1;
				smpl_en=1;
				strt_en=0;
				deserializer_en=0;
				stop=1;
				P_check_en=0;
				stp_en=edge_cnt==prescale/2 +2?1'b1:1'b0;
				if(~stp_error && ~P_error)
					Valid=~bit_cnt?1'b1:1'b0;
				Next_state=~bit_cnt?IDLE:Stop;

			end

			// Done: begin
			// 	   smpl_en=0;
			// 	   edge_en=0;
			// 	   stp_en=0;
			// 	   Valid=1;
			// 	   Next_state=IDLE;
			// 	   S=0;
			// 	end

			IDLE: begin
				smpl_en=0;
				edge_en=0;
				deserializer_en=0;
				P_check_en=0;
				strt_en=0;
				stp_en=0;
				Valid=0;
				Next_state=IDLE;
				S=0;
				stop=0;
			end
			default: begin
				smpl_en=0;
				edge_en=0;
				deserializer_en=0;
				P_check_en=0;
				strt_en=0;
				stp_en=0;
				Valid=0;
				Next_state=IDLE;
				S=0;
				stop=0;

			end

		endcase
	end
endmodule
