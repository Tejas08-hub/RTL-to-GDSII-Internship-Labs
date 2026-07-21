module counter_pwr_gate(
	input wire clk,
	input wire reset,
	input wire power_on,
	output reg[3:0]count);
always@(posedge clk or posedge reset)
begin
	if(reset)
		count<=4'b0000;
	else if(power_on)
		count<=count+1'b1;
end 
endmodule
