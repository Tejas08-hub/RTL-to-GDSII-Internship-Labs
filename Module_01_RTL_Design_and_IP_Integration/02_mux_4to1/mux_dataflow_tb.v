module mux_dataflow_tb;
reg i0,i1,i2,i3,s0,s1;
wire y;
mux_dataflow dut(
	.i0(i0),
	.i1(i1),
	.i2(i2),
	.i3(i3),
	.s0(s0),
	.s1(s1),
	.y(y));
initial begin 
	$dumpfile("mux_dataflow.vcd");
	$dumpvars(0,mux_dataflow_tb);
	$monitor ("s0=%b s1=%b y=%b ",s0,s1,y);
	i0=0;i1=1;i2=0;i3=1;
	s0=0;s1=0;#10;
	s0=1;s1=0;#10;
	s0=0;s1=1;#10;
	s0=1;s1=1;#10;
$finish;
end endmodule
