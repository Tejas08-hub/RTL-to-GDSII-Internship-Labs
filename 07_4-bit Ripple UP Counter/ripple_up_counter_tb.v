module ripple_up_counter_tb;
reg clk;
reg reset;
wire [3:0] q;
initial clk=1'b0;
always #5 clk=~clk;
ripple_up_counter dut(
.clk(clk),
.reset(reset),
.q(q));
initial begin 
	$monitor("clk=%b reset=%b q=%b ",clk,reset,q);
	$dumpfile("ripple_up_counter.vcd");
	$dumpvars();
	reset=1'b1;#10;
	reset=1'b0;#200;
	reset=1'b1;#20;
	$finish;
end endmodule
