module cdc_synchronizer(
	input clk,
	input async_in,
	output reg synced);
reg stage1;
always@(posedge clk)
begin
	stage1<=async_in;
	synced<=stage1;
end
endmodule
