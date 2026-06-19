module up_counter_tb;
reg clk;
reg reset;
wire [3:0] count;
initial clk=1'b0;
always #5 clk<=~clk;
up_counter_4bit dut(
.clk(clk),
.reset(reset),
.count(count));
initial begin
	$monitor("clk=%b reset=%b count=%b ",clk,reset,count);
	$dumpfile("up_counter_4bit.vcd");
	$dumpvars();
	reset=1'b1;#10;
	reset=1'b0;#200;
	$finish;
end endmodule
