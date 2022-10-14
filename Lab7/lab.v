 module lab(
	input  CLOCK_50,
	input  [1:0] KEY,
	input  [9:0] SW,
	output [9:0] LEDR,
	output [7:0] HEX0,
	output [7:0] HEX1,
	output [7:0] HEX2,
	output [7:0] HEX3,
	output [7:0] HEX4,
	output [7:0] HEX5
);

	//		declaration 
	wire press;
	wire rst;
	integer temp;
	wire [8:0] bright;
	reg  [3:0] state;
	reg  [3:0] nstate;
	reg  [3:0] counter;
	reg  [4:0] num[0:5];
	//		end of declaration
	
	//		assignment 		//dont touch
	assign bright = SW[9:1];
	assign clk = CLOCK_50;
	assign {rst, press} = KEY;
	//		end of assignment
	
	//		sample
	assign LEDR[0] = state[0] & state[1];
	//
	
	
	
	always @(posedge clk_1hz or negedge rst) begin
		if (!rst)
			state <= 0;
		else
			state <= nstate;
	end
	
	// input change FSM
	always @(negedge press or negedge rst) begin
		if (!rst)
			nstate <= 0;
		else begin
			case (state)
				4'h0: nstate <= (SW[0]) ? 4'h1 : 4'h0;
				4'h1: nstate <= (SW[0]) ? 4'h1 : 4'h2;
				4'h2: nstate <= (SW[0]) ? 4'h3 : 4'h0;
				4'h3: nstate <= (SW[0]) ? 4'h1 : 4'h4;
				4'h4: nstate <= (SW[0]) ? 4'h3 : 4'h5;
				4'h5: nstate <= (SW[0]) ? 4'h6 : 4'h0;
				4'h6: nstate <= (SW[0]) ? 4'h1 : 4'h7;
				4'h7: nstate <= (SW[0]) ? 4'h3 : 4'h0;
				default: nstate <= nstate;
			endcase
		end
	end
	
	always @(posedge clk or negedge rst) begin
	
		if (!rst)begin
			counter <= 0;
			temp <= 1;
		end
		else begin
			temp <= temp + 1;
			if(SW[9]==1)begin //10
			
				if (temp%10 < 9) //0000000001
					counter <= 0;
				else begin
					counter <= 1;		
				end
				
				//temp <= temp + 1;
				
			end
			else if(SW[8]==1)begin //20
			
				if (temp%10 < 8) //0000000011
					counter <= 0;
				else begin
					counter <= 1;
					//temp <= temp + 1;
				end
				//temp <= temp + 1;
				
			end
			else if(SW[7]==1)begin //30
			
				if (temp%10 < 7)	//0000000111
					counter <= 0;
				else begin
					counter <= 1;
					//temp <= temp + 1;
				end
				
			end
			else if(SW[6]==1)begin	//40
			
				if (temp%10 < 6)	//0000001111
					counter <= 0;
				else begin
					counter <= 1;
					//temp <= temp + 1;		
				end
				
			end
			else if(SW[5]==1)begin
			
				if (temp%10 < 5)
					counter <= 0;
				else begin
					counter <= 1;
					//temp <= temp + 1;		
				end	
				
			end
			else if(SW[4]==1)begin
			
				if (temp%10 < 4)
					counter <= 0;
				else begin
					counter <= 1;
					//temp <= temp + 1;		
				end	
				
			end
			else if(SW[3]==1)begin
			
				if (temp%10 < 3)
					counter <= 0;
				else begin
					counter <= 1;
					//temp <= temp + 1;		
				end	
				
			end
			else if(SW[2]==1)begin
			
				if (temp%10 < 2)
					counter <= 0;
				else begin
					counter <= 1;
					//temp <= temp + 1;		
				end	
				
			end
			else if(SW[1]==1)begin //90
			
				if (temp%10 < 1)
					counter <= 0;
				else begin
					counter <= 1;
					//temp <= temp + 1;		
				end	
				
			end
			else counter <= 1;
			
		end
		
	end

	always @(posedge clk or negedge rst) begin
		if (!rst) begin
			num[0] <= 0;
			num[1] <= 10;
			num[2] <= 10;
			num[3] <= 10;
			num[4] <= 10;
			num[5] <= 10;
		end 
		else if(counter != 0)begin
			num[0] <= state;
			if(state == 7)begin
				num[2] <= 11;
				num[3] <= 12;
				num[4] <= 13;
				num[5] <= 14;
			end
			else begin
			num[2] <= 10;
			num[3] <= 10;
			num[4] <= 10;
			num[5] <= 10;
			end
		end 
		else begin
			num[0] <= 10;
			num[2] <= 10;
			num[3] <= 10;
			num[4] <= 10;
			num[5] <= 10;
		end
		end
	
	//		clock divider				//	dont touch
	div_clk		xc0(.clk(clk), .rst(rst), .clk_1hz(clk_1hz));
		
	//		seven segment decoder	//	dont touch
	seven_seg 	xs0(.clk(clk), .seg_number(num[0]), .seg_data(HEX0));
	seven_seg 	xs1(.clk(clk), .seg_number(num[1]), .seg_data(HEX1));
	seven_seg 	xs2(.clk(clk), .seg_number(num[2]), .seg_data(HEX2));
	seven_seg 	xs3(.clk(clk), .seg_number(num[3]), .seg_data(HEX3));
	seven_seg 	xs4(.clk(clk), .seg_number(num[4]), .seg_data(HEX4));
	seven_seg 	xs5(.clk(clk), .seg_number(num[5]), .seg_data(HEX5));
	
endmodule

// o 8'b1010_0011 11
// P 8'b1000_1100	12
// E 8'b1000_0110	13
// n 8'b1010_1011	14
