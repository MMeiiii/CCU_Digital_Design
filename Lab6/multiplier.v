module multiplier(clk, rst, A, B, Y);
input	 clk;
input	 rst;
input	 [3:0]A;
input  [2:0]B;
output [7:0]Y;
reg    [10:0]mul[3];
reg    [7:0]sum;
assign Y = sum;

always@(posedge clk or negedge rst)
begin  
	//initial
	if(!rst)
	begin
	
	mul[0][0] <= 0;
	mul[0][1] <= 0;
	mul[0][2] <= 0;
	mul[0][3] <= 0;
	mul[1][0] <= 0;
	mul[1][1] <= 0;
	mul[1][2] <= 0;
	mul[1][3] <= 0;
	mul[2][0] <= 0;
	mul[2][1] <= 0;
	mul[2][2] <= 0;
	mul[2][3] <= 0;
	sum <= 0;
	
	end
	else
	begin
	
	mul[0][0] = A[0] & B[0];
	mul[0][1] = A[1] & B[0];
	mul[0][2] = A[2] & B[0];
	mul[0][3] = A[3] & B[0];
	mul[1][0] = A[0] & B[1];
	mul[1][1] = A[1] & B[1];
	mul[1][2] = A[2] & B[1];
	mul[1][3] = A[3] & B[1];
	mul[2][0] = A[0] & B[2];
	mul[2][1] = A[1] & B[2];
	mul[2][2] = A[2] & B[2];
	mul[2][3] = A[3] & B[2];
	
	sum <= {4'b0000, mul[0][3:0]} + (mul[1][3:0] << 1) + {2'b00, mul[2][3:0], 2'b00}; 
	
	
	
	end
end


endmodule 