module clk_div (
	input clk,    // Clock
	input enable, // Clock Enable
	input rst_n,  // Asynchronous reset active low
	input [7:0] div,
	output reg clk_new 
	
);

reg clk_div;
reg clk_div_en;
reg flag;
reg [7:0] counter;
reg odd;
reg [5:0] half;

always @(posedge clk or negedge rst_n) begin 

	if(~rst_n) begin
		 clk_div<= 0;
		 flag<=0;
		 counter<=0;

	end 
	else if(clk_div_en) begin
 		if(counter==(div-half) && !flag) begin
		 clk_div<=!clk_div ;
		 counter<=1;
		 if(odd)
		 	flag<=1;

	end else if (flag && counter==half ) begin
		clk_div<=!clk_div;
		counter<=1;
		flag<=0;
	end

	else
		counter<=counter+1;
end
end

always @* begin 
	clk_div_en=enable&&(div!=0)&&(div!=1);
	odd=div[0];
    	half=div>>1;
    	clk_new=clk_div_en?clk_div:clk;
end
endmodule 
