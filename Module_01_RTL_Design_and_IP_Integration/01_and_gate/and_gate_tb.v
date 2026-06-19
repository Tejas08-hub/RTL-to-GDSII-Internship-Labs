module and_gate_tb;
reg a,b;
wire y;
and_gate dut(
	.a(a),
	.b(b),
	.y(y));
initial begin

$monitor("a=%b b=%b y=%b",a,b,y);	
	#10;a=0;b=0;
	#10;a=1;b=0;
	#10;a=0;b=1;
	#10;a=1;b=1;
	#10;
end 
initial begin 
	$dumpfile("and_gate_dump.vcd");
	$dumpvars();
        end	endmodule
