/**
 *
 * 
 * 
 */
 
 `define length 6
 
 module lab8(input clk,
            input reset,
            input give_valid,
            input [7:0]dataX,
            input [7:0]dataY,
            output reg [7:0]ansX,
            output reg [7:0]ansY,
            output reg out_valid);
				
integer i;
reg [3:0]count[0:`length-1];
reg [3:0]work_state;

// input
reg [7:0]inX[0:`length-1];
reg [7:0]inY[0:`length-1];

// vector
reg signed [7:0]vector_X[0:`length-1];
reg signed [7:0]vector_Y[0:`length-1];

//output
reg [7:0]negitive_num[0:`length-1];
reg [4:0]result[0:`length-1];

// temp
reg [7:0]ix;
reg [7:0]jx;
reg [7:0]kx;
reg [7:0]mx;
reg [7:0]nx;
reg [7:0]rx;


//vcd
initial begin
    $dumpfile("Lab.vcd");
    $dumpvars(0, lab8tb);
    for(i = 0; i < `length; i = i+1)
        $dumpvars(1, inX[i], inY[i], vector_X[i], vector_Y[i], count[i]);
end


always@(posedge clk or posedge reset)
begin

	// reset
	if(reset)
	begin
	
		for(i = 0; i < 6; i = i + 1)
		begin
			inX[i] <= 0;
			inY[i] <= 0;
			vector_X[i] <= 0;
			vector_Y[i] <= 0;
			if(i != 0)
			begin
				negitive_num[i] <= 1;
			end
			result[i] <= 0;
			count[i] <= 0;
		end
		work_state <= 1;
		ix <= 0;
		jx <= 1;
		kx <= 1;
		mx <= 0;
		nx <= 0;
		rx <= 0;
		negitive_num[0] <= 0;
		out_valid <= 0;
	
	end
	// initial
	else if(work_state == 0)
	begin
	
		for(i = 0; i < 6; i = i + 1)
		begin
			inX[i] <= 0;
			inY[i] <= 0;
			vector_X[i] <= 0;
			vector_Y[i] <= 0;
			if(i != 0)
			begin
				negitive_num[i] <= 1;
			end
			result[i] <= 0;
			count[i] <= 0;
		end
		work_state <= 1;
		ix <= 0;
		jx <= 1;
		kx <= 1;
		mx <= 0;
		nx <= 0;
		rx <= 0;
		negitive_num[0] <= 0;
		out_valid <= 0;
		ansX <= 0;
		ansY <= 0;
	
	end
	// input
	else if(work_state == 1)
	begin
	
		if(ix == 6)
			work_state <= 2;
		else if(give_valid)
		begin
			inX[ix] <= dataX;
			inY[ix] <= dataY;
			ix <= ix + 1;
		end
	
	end
	// vector
	else if(work_state == 2)
	begin
	
		vector_X[1] = inX[1] - inX[0];
		vector_Y[1] = inY[1] - inY[0];
		vector_X[2] = inX[2] - inX[0];
		vector_Y[2] = inY[2] - inY[0];
		vector_X[3] = inX[3] - inX[0];
		vector_Y[3] = inY[3] - inY[0];
		vector_X[4] = inX[4] - inX[0];
		vector_Y[4] = inY[4] - inY[0];
		vector_X[5] = inX[5] - inX[0];
		vector_Y[5] = inY[5] - inY[0];
		work_state <= 3;
	
	end
	// product
	else if(work_state == 3)
	begin
		if(jx == 6)
			work_state <= 4;
		else
		begin
		
			if(kx == 6)
			begin
				jx <= jx + 1;
				kx <= 1;
			end
			else
			begin
			
				if(jx != kx && vector_X[jx]*vector_Y[kx]-vector_Y[jx]*vector_X[kx] < 0)
					negitive_num[jx] = negitive_num[jx] + 1;
				else if(jx != kx && vector_X[jx]*vector_Y[kx]-vector_Y[jx]*vector_X[kx] == 0)
				begin
					if(vector_X[jx]*vector_X[jx] + vector_Y[jx]*vector_Y[jx] > vector_X[kx]*vector_X[kx] + vector_Y[kx]*vector_Y[kx])
						negitive_num[jx] = negitive_num[jx] + 1;
				end
				
				kx <= kx + 1;
				
			end

		end
	end
	// sort
	else if(work_state == 4)
	begin
		
		if(mx == 6)
		begin
			work_state <= 5;
		end
		else
		begin
		
			if(nx == 6)
			begin
				mx <= mx + 1;
				nx <= 0;
			end
			else
			begin
			
				if(mx == negitive_num[nx])
				begin
					result[mx] <= nx;
				end
				nx <= nx + 1;
			end
		
		 end
	
	end
	//output
	else if(work_state == 5)
	begin
		
		if(rx == 6)
		begin
			work_state <= 0;
			ansX <= 0;
			ansY <= 0;
			out_valid <= 0;
		end
		else 
		begin
			out_valid <= 1;
			ansX <= inX[result[rx]];
			ansY <= inY[result[rx]];
			rx <= rx + 1;
	
		end
	end

end
endmodule
