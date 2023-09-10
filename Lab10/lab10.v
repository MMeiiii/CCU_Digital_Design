/**
 *
 * @author : 
 * @latest changed : 
 */

module lab10(input clk,
			input reset,
			input [3:0]code_pos,
			input [2:0]code_len,
			input [7:0]chardata,
			output reg finish,
			output reg [7:0]char_nxt);

initial begin
    $dumpfile("Lab.vcd");
    $dumpvars(0, lab10tb);
end

reg [2:0]state;
reg [7:0]window[0:8];
reg [2:0]len;


always@(posedge clk or posedge reset) // spin window
begin
	if(reset)
	begin	
		window[8] <= 0;
		window[7] <= 0;
		window[6] <= 0;
		window[5] <= 0;
		window[4] <= 0;
		window[3] <= 0;
		window[2] <= 0;
		window[1] <= 0;
	end
	else
	begin
		window[8] <= window[7];
		window[7] <= window[6];
		window[6] <= window[5];
		window[5] <= window[4];
		window[4] <= window[3];
		window[3] <= window[2];
		window[2] <= window[1];
		window[1] <= window[0];
	end
end
always@(posedge clk or posedge reset) // output & state control
begin
	if(reset)
	begin
		state <= 0;
		len <= 0;
		finish <= 0;
	end
	else
	begin
		case(state)
			3'd0:
			begin
				// $
				if((code_len == 0 && chardata == 36) || (len == code_len && chardata ==36))
				begin
					char_nxt <= chardata;
					state <= 1;
				end
				else if(code_len == len)
				begin
					len <= 0;
					char_nxt <= chardata;
					window[0] <= chardata;
				end
				else
				begin
					len = len + 1;
					char_nxt <= window[code_pos];
					window[0] <= window[code_pos];
				end
			end
			3'd1:
			begin
				finish <= 1;
			end
		endcase
	end
end

endmodule
