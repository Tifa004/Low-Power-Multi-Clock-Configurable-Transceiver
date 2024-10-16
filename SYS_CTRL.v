module SYS_CTRL (
	input clk,
	input rst,
	input [15:0] ALU_OUT,
	input ALU_VLD,
	input [7:0] REG_Read_Data,
	input REG_VLD,
	input FIFO_FULL,
	input RX_VLD,
	input [7:0] RX_DATA,
	output reg W_inc,
	output reg [7:0] FIFO_W_Data,
	output reg [3:0] OP_CODE,
	output reg ALU_EN,
	output reg W_EN,
	output reg R_EN,
	output reg [7:0] REG_W_Data,
	output reg [3:0] REG_ADD,
	output reg Gate_EN,
	output reg CLKDIV_EN
);
	reg SAVE_ADDRESS;
	reg [3:0] REG_ADD_SAVE;
	reg i;
	reg [3:0] Current_state,Next_state;

	localparam[3:0] IDLE = 4'b0000,
START = 4'b0001,
R_ADDRESS = 4'b0010,
REG_WRITE = 4'b0011,
R_R_ADDRESS = 4'b0100,
REG_READ = 4'b0101,
ALU_OP_A = 4'b0110,
ALU_OP_B = 4'b0111,
ALU_FUN = 4'b1000,
ALU_READ = 4'b1001,
ALU_READ2 = 4'b1010;


	always @(posedge clk or negedge rst) begin
		if(~rst) begin
			Current_state <= IDLE;
		end else if(RX_VLD && i==0)begin

			Current_state <= START;
		end
		else
			Current_state<=Next_state;



		end
always @(posedge clk or negedge rst) begin
		if(~rst) begin
			REG_ADD_SAVE<=0;
		end else if(SAVE_ADDRESS) 
			REG_ADD_SAVE<=RX_DATA;

		end
	always @* begin
		case (Current_state)

			START:begin
				W_inc=0;
				FIFO_W_Data=0;
				OP_CODE=0;
				ALU_EN=0;
				REG_ADD=0;
				W_EN=0;
				R_EN=0;
				REG_W_Data=0;
				SAVE_ADDRESS=0;
				Gate_EN=0;
				i=1;
				CLKDIV_EN=1;
				case (RX_DATA)

					8'hAA: Next_state= R_ADDRESS;

					8'hBB: Next_state= R_R_ADDRESS;

					8'hCC: Next_state= ALU_OP_A;

					8'hDD: Next_state= ALU_FUN;

					default : Next_state=IDLE;
				endcase
			end

			R_ADDRESS: begin
				W_inc=0;
				FIFO_W_Data=0;
				OP_CODE=0;
				ALU_EN=0;
				REG_ADD=0;
				W_EN=0;
				R_EN=0;
				REG_W_Data=0;
				SAVE_ADDRESS=1;
				Gate_EN=ALU_VLD?1'b1:1'b0;
				i=1;
				CLKDIV_EN=1;
				Next_state = RX_VLD? REG_WRITE:R_ADDRESS;
			end

			REG_WRITE: begin
				SAVE_ADDRESS=0;
				W_inc=0;
				FIFO_W_Data=0;
				OP_CODE=0;
				ALU_EN=0;
				R_EN=0;
				REG_W_Data=0;
				Gate_EN=ALU_VLD?1'b1:1'b0;
				i=1;
				CLKDIV_EN=1;
				REG_ADD=REG_ADD_SAVE;
				REG_W_Data = RX_DATA;
				if(RX_VLD) begin
					W_EN=1;
					Next_state=IDLE;
				end else begin 
					W_EN=0;
					Next_state=REG_WRITE;
				end
			end

			R_R_ADDRESS: begin
				W_inc=0;
				FIFO_W_Data=0;
				OP_CODE=0;
				ALU_EN=0;
				W_EN=0;
				R_EN=1;
				REG_W_Data=0;
				SAVE_ADDRESS=0;
				Gate_EN=ALU_VLD?1'b1:1'b0;
				i=1;
				CLKDIV_EN=1;
				REG_ADD = RX_DATA;
				Next_state = RX_VLD? REG_READ:R_R_ADDRESS;
			end

			REG_READ: begin
				W_inc=0;
				FIFO_W_Data=0;
				OP_CODE=0;
				ALU_EN=0;
				W_EN=0;
				R_EN=0;
				REG_W_Data=0;
				SAVE_ADDRESS=0;
				Gate_EN=ALU_VLD?1'b1:1'b0;
				i=1;
				CLKDIV_EN=1;
				REG_ADD = RX_DATA;
				R_EN=1;
				if(REG_VLD) begin
					W_inc=REG_VLD;
					FIFO_W_Data=REG_Read_Data;
					Next_state=FIFO_FULL==1?REG_READ:IDLE;
				end else Next_state=REG_READ;
			end

			ALU_OP_A: begin
				W_inc=0;
				FIFO_W_Data=0;
				OP_CODE=0;
				ALU_EN=0;
				W_EN=0;
				R_EN=0;
				REG_W_Data=0;
				SAVE_ADDRESS=0;
				REG_ADD=0;
				Gate_EN=0;
				i=1;
				CLKDIV_EN=1;
				if(RX_VLD) begin
					W_EN=1;
					REG_ADD=0;
					REG_W_Data = RX_DATA;
					Next_state=ALU_OP_B;
				end else Next_state=ALU_OP_A;
			end

			ALU_OP_B: begin
				W_inc=0;
				FIFO_W_Data=0;
				OP_CODE=0;
				ALU_EN=0;
				W_EN=0;
				R_EN=0;
				REG_W_Data=0;
				SAVE_ADDRESS=0;
				REG_ADD=0;
				Gate_EN=0;
				i=1;
				CLKDIV_EN=1;
				if(RX_VLD) begin
					W_EN=1;
					REG_ADD=1;
					REG_W_Data = RX_DATA;
					Next_state=ALU_FUN;
				end else Next_state=ALU_OP_B;
			end

			ALU_FUN: begin
				W_inc=0;
				FIFO_W_Data=0;
				SAVE_ADDRESS=0;
				OP_CODE=0;
				ALU_EN=0;
				W_EN=0;
				R_EN=0;
				REG_W_Data=0;
				REG_ADD=0;
				Gate_EN=0;
				i=1;
				CLKDIV_EN=1;
				if(RX_VLD) begin
					Gate_EN=1;
					OP_CODE=RX_DATA[3:0];
					ALU_EN=1;
				end
				Next_state=ALU_VLD==1?ALU_READ:ALU_FUN;
			end

			ALU_READ: begin
				ALU_EN=1;
				W_inc=0;
				FIFO_W_Data=0;
				SAVE_ADDRESS=0;
				OP_CODE=0;
				W_EN=0;
				R_EN=0;
				REG_W_Data=0;
				REG_ADD=0;
				Gate_EN=1;
				i=1;
				CLKDIV_EN=1;
				W_inc=1;
				FIFO_W_Data=ALU_OUT[7:0];
				Next_state=ALU_READ2;
			end

			ALU_READ2: begin
				ALU_EN=1;
				W_inc=1;
				FIFO_W_Data=0;
				SAVE_ADDRESS=0;
				OP_CODE=0;
				W_EN=0;
				R_EN=0;
				REG_W_Data=0;
				REG_ADD=0;
				Gate_EN=1;
				i=1;
				CLKDIV_EN=1;
				FIFO_W_Data=ALU_OUT[15:8];
				Next_state=IDLE;
			end

			IDLE: begin
				SAVE_ADDRESS=0;
				W_inc=0;
				FIFO_W_Data=0;
				OP_CODE=0;
				ALU_EN=0;
				W_EN=0;
				R_EN=0;
				REG_W_Data=0;
				REG_ADD=0;
				Gate_EN=ALU_VLD?1'b1:1'b0;
				i=0;
				CLKDIV_EN=1;
				Next_state=IDLE;
			end

			default : begin
				SAVE_ADDRESS=0;
				W_inc=0;
				FIFO_W_Data=0;
				OP_CODE=0;
				ALU_EN=0;
				W_EN=0;
				R_EN=0;
				REG_W_Data=0;
				REG_ADD=0;
				Gate_EN=ALU_VLD?1'b1:1'b0;
				i=0;
				CLKDIV_EN=1;
				Next_state=IDLE;
			end
		endcase
	end
endmodule
