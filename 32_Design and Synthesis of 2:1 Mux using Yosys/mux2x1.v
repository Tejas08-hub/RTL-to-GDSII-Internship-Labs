module mux2x1(
	input a,
	input b,
	input sel,
	output out);
assign out=sel?b:a;
endmodule
