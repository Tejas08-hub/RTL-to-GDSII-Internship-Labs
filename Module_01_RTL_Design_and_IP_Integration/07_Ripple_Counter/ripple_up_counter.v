module ripple_up_counter(
    input clk,
    input reset,
    output [3:0] q
);
wire q_out0, q_out1, q_out2, q_out3;
assign q = {q_out3, q_out2, q_out1, q_out0};
tff tff0(.clk(clk),     .reset(reset), .q(q_out0));
tff tff1(.clk(~q_out0), .reset(reset), .q(q_out1));
tff tff2(.clk(~q_out1), .reset(reset), .q(q_out2));
tff tff3(.clk(~q_out2), .reset(reset), .q(q_out3));
endmodule
