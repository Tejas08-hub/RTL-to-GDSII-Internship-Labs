module metastability_tb;
reg clk=0;
reg asyn_in=0;
wire sampled;
always #5 clk=~clk;
metastability dut(
	.clk(clk),
	.asyn_in(asyn_in),
	.sampled(sampled));
initial begin 
	$dumpfile("dump.vcd");
	$dumpvars(0,metastability_tb);
	#12 asyn_in=1;
	#7 asyn_in=0;
	#6 asyn_in=1;
	#9 asyn_in=0;
	#50 $finish;
end endmodule

