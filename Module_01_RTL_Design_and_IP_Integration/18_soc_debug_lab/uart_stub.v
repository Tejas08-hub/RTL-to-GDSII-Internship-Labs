module uart_stub(
    input clk,
    input rst_n,
    input tx_en,
    input [7:0] tx_data,
    output reg tx_done
);

always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
        tx_done <= 0;
    else if(tx_en)
        tx_done <= 1;
    else
        tx_done <= 0;
end

endmodule
