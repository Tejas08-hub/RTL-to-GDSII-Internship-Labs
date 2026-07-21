module pos_latch_gating(
	input clk,
	input en,
	input rst,
	output reg[3:0]count,
	output gated_clk);
reg en_latch;
always@(posedge clk or en)begin
	if(clk)
		en_latch=en;
end
assign gated_clk=clk & en_latch;
always@(posedge gated_clk or posedge rst)begin
	if(rst)
		count<=4'b000;
	else
		count<=count+1;
end
endmodule
