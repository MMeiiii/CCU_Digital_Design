/*
 *
 * @author : 409410029
 * 
 */
 
module JAM (
input CLK,
input RST,
output reg [2:0] W,
output reg [2:0] J,
input [6:0] Cost,
output reg [3:0] MatchCount,
output reg [9:0] MinCost,
output reg Valid );

integer i;
initial begin
    $dumpfile("JAM.vcd");
    $dumpvars(0, testfixture);
    for(i = 0; i < 8; i = i+1)
        $dumpvars(1, num[i]);
end

reg [5:0]state;
reg [2:0]num[0:7];
reg [4:0]ix;
reg [9:0]tempCost;
reg [4:0]changePoint;
reg [4:0]n;
reg [4:0]max_min_pos;
reg [4:0]max_min_value;
always @(posedge CLK or posedge RST) 
begin
    if(RST)
    begin
		  W <= 0;
		  J <= 0;
		  num[0] <= 0;
		  num[1] <= 1;
		  num[2] <= 2;
		  num[3] <= 3;
		  num[4] <= 4;
		  num[5] <= 5;
		  num[6] <= 6;
		  num[7] <= 7;
		  state <= 0;
		  ix <= 1;
		  tempCost <= 0;
		  MatchCount <= 0;
		  MinCost <= 1023;
		  changePoint <= 0;
		  n <= 10;
		  max_min_pos <= 0;
		  max_min_value <= 10;
    end
    else 
    begin
	 
		case(state)
			5'd0:
			begin
				if(ix > 8)
				begin
					if(tempCost < MinCost)
					begin
						MatchCount <= 1;
						MinCost <= tempCost;
					end
					else if(tempCost == MinCost)
					begin
						MatchCount <= MatchCount + 1;
					end
					ix <= 1;
					tempCost <= 0;
					state <= 1;
				end
				else if(ix == 8)
				begin
					tempCost <= tempCost + Cost;
					ix <= ix + 1;
				end
				else
				begin
					tempCost <= tempCost + Cost;
					W <= ix;
					J <= num[ix];
					ix <= ix + 1;
				end
			end
			5'd1:
			begin
				if(num[7] > num[6])
				begin
					num[6] <= num[7];
					num[7] <= num[6];
					state <= 0;
					W <= 0;
					J <= num[0];
				end
				else if(num[6] > num[5])
				begin
					 if(num[7] > num[5] && num[7] < num[6])
					 begin
						num[7] <= num[6];
						num[5] <= num[7];
						num[6] <= num[5];
						state <= 0;
						W <= 0;
						J <= num[0];
					 end
					 else
					 begin
						num[5] <= num[6];
						num[6] <= num[7];
						num[7] <= num[5];
						state <= 0;
						W <= 0;
						J <= num[0];
					 end
				end
				else if(num[5] > num[4])
				begin
						// 5
						if(num[6] < num[4] && ((num[7] < num[4]) || num[5] < num[7]) )
						begin
							num[4] <= num[5];
							num[5] <= num[7];
							num[7] <= num[4];
						end
						// 6
						else if(num[6] > num[4] && num[5] > num[6] && num[7] < num[4])
						begin
							num[4] <= num[6];
							num[5] <= num[7];
							num[6] <= num[4];
							num[7] <= num[5];
						end
						// 7
						else if(num[7] > num[4] && num[7] < num[6] && num[7] < num[5])
						begin
							num[4] <= num[7];
							num[5] <= num[4];
							num[7] <= num[5];
						end
						state <= 0;
						W <= 0;
						J <= num[0];
				end
				else if(num[4] > num[3])
				begin
					changePoint <= 3;
					state <= 2;
					n <= 4;
				end
				else if(num[3] > num[2])
				begin
					changePoint <= 2;
					state <= 2;
					n <= 3;
				end
				else if(num[2] > num[1])
				begin
					changePoint <= 1;
					state <= 2;
					n <= 2;
				end
				else if(num[1] > num[0])
				begin
					changePoint <= 0;
					state <= 2;
					n <= 1;
				end
				else
					state <= 4;
			end
			5'd2:
			begin
				if(n >= 8)
				begin
					num[changePoint] <= num[max_min_pos];
					num[max_min_pos] <= num[changePoint];
					state <= 3;
					max_min_value <= 10;
				end
				else
				begin
					if(num[n] > num[changePoint] && num[n] < max_min_value)
					begin
						max_min_pos <= n;
						max_min_value <= num[n];
					end
					n <= n + 1;
				end
				
			end
			5'd3:
			begin
				if(changePoint == 4)
				begin
					num[5] <= num[7];
					num[7] <= num[5];
				end
				else if(changePoint == 3)
				begin
					num[4] <= num[7];
					num[5] <= num[6];
					num[6] <= num[5];
					num[7] <= num[4];
				end
				else if(changePoint == 2)
				begin
					num[3] <= num[7];
					num[4] <= num[6];
					num[6] <= num[4];
					num[7] <= num[3];
				end
				else if(changePoint == 1)
				begin
					num[2] <= num[7];
					num[3] <= num[6];
					num[4] <= num[5];
					num[5] <= num[4];
					num[6] <= num[3];
					num[7] <= num[2];
				end
				else if(changePoint == 0)
				begin
					num[1] <= num[7];
					num[2] <= num[6];
					num[3] <= num[5];
					num[5] <= num[3];
					num[6] <= num[2];
					num[7] <= num[1];
				end
					state <= 0;
					W <= 0;
					J <= num[0];
			end
			5'd4:
			begin
				Valid <= 1;
			end
			
		endcase
    end
end

endmodule