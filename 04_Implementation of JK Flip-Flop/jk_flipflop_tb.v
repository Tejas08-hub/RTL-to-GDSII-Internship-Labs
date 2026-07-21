module jk_flipflop_tb;
reg preset;
reg j,k,clk;
wire q,qb;
jk_flipflop dut(
	.preset(preset),
	.j(j),
	.k(k),
	.clk(clk),
	.q(q),
	.qb(qb));
always #5 clk=~clk;
initial begin 
	$dumpfile("jk_flipflop.vcd");
	$dumpvars(0,jk_flipflop_tb);
	$monitor("preset =%b j=%b k=%b clk=%b q=%b qb=%b",preset,j,k,clk,q,qb);
end
initial begin 
	clk=0;preset=1;j=0;k=0;
	#7;
	preset =0;
	#10;j=0;k=0;
	#10;j=0;k=1;
	#10;j=1;k=0;
	#10;j=1;k=1;
	#3;preset=1;
	#10;preset=0;
	#20; $finish;
end endmodule
