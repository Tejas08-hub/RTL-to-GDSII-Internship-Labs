module asyn_reset_tb;
reg clk =0,rst_n=1,d=0;
wire q;
always #5 clk=~clk;
asyn_reset_ff dut(
	.clk(clk),
	.rst_n(rst_n),
	.d(d),
	.q(q));
initial begin
	$dumpfile("dump.vcd");
	$dumpvars(0,asyn_reset_tb);
	d=1;#8;
	rst_n=0;
	#4;
        rst_n=1;
	#20;
	$finish;
end
endmodule

