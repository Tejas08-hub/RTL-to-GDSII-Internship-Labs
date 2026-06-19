module sync_reset_tb;
reg clk=0,rst=0,d=0;
wire q;
always #5 clk=~clk;
sync_ff dut(
.clk(clk),
.rst(rst),
.d(d),
.q(q));
initial begin
	$dumpfile("dump.vcd");
	$dumpvars(0,sync_reset_tb);
	d=1;#3;
	rst=1;#7;
	rst=0;#20;
	$finish;
end
endmodule



















































































































	 

