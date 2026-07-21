module tb;
reg clk,rst;
wire[3:0]cnt_async;
wire[3:0]cnt_sync;
wire rst_sync;
initial clk=0;
always #5 clk=~clk;
counter_async     dut1(
.clk(clk),
.rst(rst),
.count(cnt_async));
reset_sync dut2(
	.clk(clk),
	.rst_async(rst),
	.rst_sync(rst_sync));
counter_sync dut3(
	.clk(clk),
	.rst(rst),
	.count(cnt_sync));
initial begin
 $dumpfile("dump.vcd");
 $dumpvars(0, tb);
 // Step 1: Assert reset
 rst = 1;
 #25;
rst = 0;
 #100;
rst = 1;
 #20;
 rst = 0;
 #50;
 $finish;
end
endmodule
 



