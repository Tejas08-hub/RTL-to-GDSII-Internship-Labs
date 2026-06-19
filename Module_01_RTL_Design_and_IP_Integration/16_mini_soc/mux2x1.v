`timescale 1ns/1ps
module mux2x1(
	input[1:0]in1,
	input[1:0]in2,
	input sel,
	output[1:0]out);
assign out=sel ? in1 : in2;
endmodule
