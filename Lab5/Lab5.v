module Lab5(clk, rst, seg);
input	 clk;
input	 rst;
output [7:0]seg;
integer temp;

always@(posedge clk_1hz or negedge rst)
begin
  if(!rst)
  begin
	temp <= 0;
  end
  else if(temp == 7)
  begin
  temp <=0;
  end
  else
  begin
  temp<=temp+1;
  end
end
div_clk		(.clk(clk), .rst(rst), .clk_1hz(clk_1hz));
seven_seg 	(.clk(clk), .seg_number(temp), .seg_data(seg)); // 
endmodule 