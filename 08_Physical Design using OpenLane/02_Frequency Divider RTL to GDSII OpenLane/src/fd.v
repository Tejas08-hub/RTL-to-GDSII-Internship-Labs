module fd(
input clk,
input reset,
output reg clk_out);
reg [1:0]pos_cnt;
reg[1:0]neg_cnt;
always@(posedge clk)begin
  if(reset)
    pos_cnt<=0;
  else if(pos_cnt==2)
    pos_cnt<=0;
  else
    pos_cnt<=pos_cnt+1'b1;
end
always@(negedge clk)begin
  if(reset)
    neg_cnt<=0;
  else if(neg_cnt==2)
    neg_cnt<= 0;
  else
    neg__cnt<=neg_cnt+1'b1;
end
assign clk_out=((pos_cnt==2)|(neg_cnt==2));
endmodule
