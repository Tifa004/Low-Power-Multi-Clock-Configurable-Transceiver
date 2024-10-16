
module SYS_TOP # ( parameter DATA_WIDTH = 8 ,  RF_ADDR = 4 )

(
 input   wire                          RST_N,
 input   wire                          UART_CLK,
 input   wire                          REF_CLK,
 input   wire                          UART_RX_IN,
 output  wire                          UART_TX_O,
 output  wire                          parity_error,
 output  wire                          framing_error
);


wire                                   SYNC_UART_RST,
                                       SYNC_REF_RST;
									   
wire					               UART_TX_CLK;
wire					               UART_RX_CLK;


wire      [DATA_WIDTH-1:0]             Operand_A,
                                       Operand_B,
									   UART_Config,
									   DIV_RATIO;
									   
wire      [DATA_WIDTH-1:0]             DIV_RATIO_RX;
									   
wire      [DATA_WIDTH-1:0]             UART_RX_OUT;
wire         						   UART_RX_V_OUT;
wire      [DATA_WIDTH-1:0]			   UART_RX_SYNC;
wire                                   UART_RX_V_SYNC;

wire      [DATA_WIDTH-1:0]             UART_TX_IN;
wire        						   UART_TX_VLD;
wire      [DATA_WIDTH-1:0]             UART_TX_SYNC;
wire        						   UART_TX_V_SYNC;

wire                                   UART_TX_Busy;	
wire                                   UART_TX_Busy_PULSE;	
									   
wire                                   RF_WrEn;
wire                                   RF_RdEn;
wire      [RF_ADDR-1:0]                RF_Address;
wire      [DATA_WIDTH-1:0]             RF_WrData;
wire      [DATA_WIDTH-1:0]             RF_RdData;
wire                                   RF_RdData_VLD;									   

wire                                   CLKG_EN;
wire                                   ALU_EN;
wire      [3:0]                        ALU_FUN; 
wire      [DATA_WIDTH*2-1:0]           ALU_OUT;
wire                                   ALU_OUT_VLD; 
									   
wire                                   ALU_CLK ;								   

wire                                   FIFO_FULL ;
	
wire                                   CLKDIV_EN ;
								   
///********************************************************///
//////////////////// Reset synchronizers /////////////////////
///********************************************************///

rst_sync # (.NUM_STAGES(2)) U0_RST_SYNC (
.rst(RST_N),
.clk(UART_CLK),
.synced_rst(SYNC_UART_RST)
);

rst_sync # (.NUM_STAGES(2)) U1_RST_SYNC (
.rst(RST_N),
.clk(REF_CLK),
.synced_rst(SYNC_REF_RST)
);

///********************************************************///
////////////////////// Data Synchronizer /////////////////////
///********************************************************///

D_SYNC # (.Stages(2) , .Bus_Width(8)) U0_ref_sync (
.clk(REF_CLK),
.rst(SYNC_REF_RST),
.Data(UART_RX_OUT),
.bus_enable(UART_RX_V_OUT),
.sync_bus(UART_RX_SYNC),
.enable(UART_RX_V_SYNC)
);

///********************************************************///
///////////////////////// Async FIFO /////////////////////////
///********************************************************///

FIFO #(.Data_Width(DATA_WIDTH) ) U0_UART_FIFO (
.w_clk(REF_CLK),
.w_rst(SYNC_REF_RST),  
.w_inc(UART_TX_VLD),
.w_data(UART_TX_IN),             
.r_clk(UART_TX_CLK),              
.r_rst(SYNC_UART_RST),              
.r_inc(UART_TX_Busy_PULSE),              
.r_data(UART_TX_SYNC),             
.full(FIFO_FULL),               
.empty(UART_TX_V_SYNC)               
);

///********************************************************///
//////////////////////// Pulse Generator /////////////////////
///********************************************************///

pulse_gen U0_PULSE_GEN (
.clk(UART_TX_CLK),
.rst(SYNC_UART_RST),
.bus_enable(UART_TX_Busy),
.enable(UART_TX_Busy_PULSE)
);

///********************************************************///
//////////// Clock Divider for UART_TX Clock /////////////////
///********************************************************///

clk_div U0_ClkDiv (
.clk(UART_CLK),             
.rst_n(SYNC_UART_RST),                 
.enable(CLKDIV_EN),               
.div(DIV_RATIO),           
.clk_new(UART_TX_CLK)             
);

///********************************************************///
//////////// Custom Mux Clock /////////////////
///********************************************************///

CLKDIV_MUX U0_CLKDIV_MUX (
.IN(UART_Config[7:2]),
.OUT(DIV_RATIO_RX)
);

///********************************************************///
//////////// Clock Divider for UART_RX Clock /////////////////
///********************************************************///

clk_div U1_ClkDiv (
.clk(UART_CLK),             
.rst_n(SYNC_UART_RST),                 
.enable(CLKDIV_EN),               
.div(DIV_RATIO_RX),           
.clk_new(UART_RX_CLK)             
);

///********************************************************///
/////////////////////////// UART /////////////////////////////
///********************************************************///

UART_TOP  U0_UART (
.RST(SYNC_UART_RST),
.TX_CLK(UART_TX_CLK),
.RX_CLK(UART_RX_CLK),
.parity_enable(UART_Config[0]),
.parity_type(UART_Config[1]),
.Prescale(UART_Config[7:2]),
.RX_IN_S(UART_RX_IN),
.RX_OUT_P(UART_RX_OUT),                      
.RX_OUT_V(UART_RX_V_OUT),                      
.TX_IN_P(UART_TX_SYNC), 
.TX_IN_V(!UART_TX_V_SYNC), 
.TX_OUT_S(UART_TX_O),
.TX_OUT_V(UART_TX_Busy),
.parity_error(parity_error),
.framing_error(framing_error)                  
);

///********************************************************///
//////////////////// System Controller ///////////////////////
///********************************************************///

SYS_CTRL U0_SYS_CTRL (
.clk(REF_CLK),
.rst(SYNC_REF_RST),
.REG_Read_Data(RF_RdData),
.REG_VLD(RF_RdData_VLD),
.W_EN(RF_WrEn),
.R_EN(RF_RdEn),
.REG_ADD(RF_Address),
.REG_W_Data(RF_WrData),
.ALU_EN(ALU_EN),
.OP_CODE(ALU_FUN), 
.ALU_OUT(ALU_OUT),
.ALU_VLD(ALU_OUT_VLD),  
.Gate_EN(CLKG_EN), 
.CLKDIV_EN(CLKDIV_EN),   
.FIFO_FULL(FIFO_FULL),
.RX_DATA(UART_RX_SYNC), 
.RX_VLD(UART_RX_V_SYNC),
.FIFO_W_Data(UART_TX_IN), 
.W_inc(UART_TX_VLD)
);

///********************************************************///
/////////////////////// Register File ////////////////////////
///********************************************************///

RegFile U0_RegFile (
.CLK(REF_CLK),
.RST(SYNC_REF_RST),
.WrEn(RF_WrEn),
.RdEn(RF_RdEn),
.Address(RF_Address),
.WrData(RF_WrData),
.RdData(RF_RdData),
.RdData_VLD(RF_RdData_VLD),
.REG0(Operand_A),
.REG1(Operand_B),
.REG2(UART_Config),
.REG3(DIV_RATIO)
);

///********************************************************///
//////////////////////////// ALU /////////////////////////////
///********************************************************///
 
ALU U0_ALU (
.CLK(ALU_CLK),
.RST(SYNC_REF_RST),  
.A(Operand_A), 
.B(Operand_B),
.EN(ALU_EN),
.ALU_FUN(ALU_FUN),
.ALU_OUT(ALU_OUT),
.OUT_VALID(ALU_OUT_VLD)
);

///********************************************************///
///////////////////////// Clock Gating ///////////////////////
///********************************************************///

CLK_GATE U0_CLK_GATE (
.CLK_EN(CLKG_EN),
.CLK(REF_CLK),
.GATED_CLK(ALU_CLK)
);


endmodule
 