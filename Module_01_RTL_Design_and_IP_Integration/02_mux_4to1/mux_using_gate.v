module mux_using_gate(i0,i1,i2,i3,s0,s1,y);
input i0,i1,i2,i3;
input s0,s1;
output y;
wire s0n,s1n;
wire w1,w2,w3,w4;
not (s0n,s0);
not (s1n,s1);
and (w1,i0,s0n,s1n);
and (w2,i1,s0n,s1);
and (w3,i2,s0,s1n);
and (w4,i3,s0,s1);
or (y,w1,w2,w3,w4);
endmodule

