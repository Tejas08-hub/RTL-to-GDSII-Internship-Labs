module shift_register (
    input wire clk,
    input wire rst,
    input wire [7:0] data_in,
    output reg [7:0] q
);
always @(posedge clk or posedge rst) begin
    if (rst)
        q <= 8'b00000000;
    else
        q <= {q[6:0], data_in[7]};
end
endmodule
