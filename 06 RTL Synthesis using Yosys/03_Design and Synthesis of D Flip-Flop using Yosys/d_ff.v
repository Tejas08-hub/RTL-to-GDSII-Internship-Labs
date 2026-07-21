module d_ff(
	input clk,
	input rst,
	input din,
	output reg q);
always@(posedge clk or posedge rst)begin
	if(rst)
		q<=0;
	else
		q<=din;
end
endmodule
