module tff(
	input clk,
	input reset,
	output reg q);
always@(posedge clk or posedge reset)
begin 
if(reset)
	q<=1'b0;
else 
	q<=~q;
end endmodule
//ripple up counter 


