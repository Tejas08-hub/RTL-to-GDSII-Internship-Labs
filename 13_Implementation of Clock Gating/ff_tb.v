module ff_tb;
reg clk=0,rst=0,d=0,enable=0;
wire q_nogate,q_gate;
always #5 clk=~clk;
ff_no_gating f1(.clk(clk),.rst(rst),.d(d),.q(q_nogate));
ff_with_gating f2(.clk(clk),.rst(rst),.d(d),.enable(enable),.q(q_gate));
initial begin 
	$dumpfile("dump.vcd");
	$dumpvars(0,ff_tb);
	rst=1;d=0;
	enable=0;
	#10;rst=0;
	d=1;#20;
	enable=1;#30;
	enable=0;d=0;#30;
	$finish;
end 
endmodule
