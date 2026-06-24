module clk_divider(
	input clk_in,
	input rst,
	output reg clk_out);
reg[1:0] counter;
always@(posedge clk_in or posedge rst)
begin
	if(rst)
	begin
		counter<=2'b00;
		clk_out<=1'b0;
	end
	else begin
		counter<=counter+1'b1;
		if(counter==2'b11)
			clk_out<=~clk_out;
	end
end	
endmodule

