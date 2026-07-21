module metastability(
	input clk,
	input asyn_in,
	output reg sampled);
always@(posedge clk)
begin
	sampled<=asyn_in;
end endmodule
