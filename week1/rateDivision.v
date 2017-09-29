`timescale 1ns/1ns

module rateDivision (CLOCK_50, enabler, reset, HEX0, HEX1, state, blackDone);

	input CLOCK_50;
	input reset;
	input [2:0] state;
	output enabler;
	output [6:0] HEX0, HEX1;
	wire enable;
	output blackDone;
	reg [27:0]count1;
	reg [7:0]count2;
	reg [27:0]RateDivider;
	
	//initial count1 = 28'd0;
	//initial count2 = 8'd0;
	//initial RateDivider = 28'd100000000;

	
	assign enable = (count1 >= RateDivider)?1'b1:1'b0;
	assign blackDone = (count1 >= 27'd5000000)?1'b1:1'b0;
	
	assign enabler = enable;
	
	displayHEX h0(count2[3:0], HEX0);
	displayHEX h1(count2[7:4], HEX1);
	
	
	always@(posedge CLOCK_50)
	begin
		if (~reset || state == 3'b111 || state == 2'b01)
			begin
			count1 <= 28'd0;
			count2 <= 8'd0;
			end
		else if (enable)
		begin
			count1 <= 28'd0;
			count2 <= count2 + 1'b1;
		end
		else
			count1 <= count1 + 1'b1;

	end


	
	always@(posedge CLOCK_50)
	begin
	
		if (count2 < 8'd5)
			RateDivider <= 27'd100000000;
		else if (count2 < 8'd10)
			RateDivider <= 26'd50000000;
		else if (count2 < 8'd15)
			RateDivider <= 27'd37500000;
		else if (count2 <8'd20)
			RateDivider <= 28'd25000000;
		else RateDivider <= 27'd100000000;
	end
	
	
	//MODELSIM RATEDIVIDER
	/*
	always@(posedge CLOCK_50)
	begin
	
		if (count2 < 8'd5)
			RateDivider <= 27'd5;
		else if (count2 < 8'd10)
			RateDivider <= 26'd3;
		else if(count2 < 8'd15)
			RateDivider <= 27'd1;
		else 
			RateDivider <= 8'd5;

	end
	
	*/
endmodule


module displayHEX (s,h);                                                                           

input[3:0] s;
output[6:0] h;

//Lights, the Not is for the purpose of the keys since 0 represents pressed
assign h[0] = ~((s[3]|s[2]|s[1]|~s[0])&(s[3]|~s[2]|s[1]|s[0])&(~s[3]|s[2]|~s[1]|~s[0])&(~s[3]|~s[2]|s[1]|~s[0]));
assign h[1] = ~((s[3]|~s[2]|s[1]|~s[0])&(s[3]|~s[2]|~s[1]|s[0])&(~s[3]|s[2]|~s[1]|~s[0])&(~s[3]|~s[2]|s[1]|s[0])&(~s[3]|~s[2]|~s[1]|s[0])&(~s[3]|~s[2]|~s[1]|~s[0]));
assign h[2] = ~((s[3]|s[2]|~s[1]|s[0])&(~s[3]|~s[2]|s[1]|s[0])&(~s[3]|~s[2]|~s[1]|s[0])&(~s[3]|~s[2]|~s[1]|~s[0]));
assign h[3] = ~((s[3]|s[2]|s[1]|~s[0])&(s[3]|~s[2]|s[1]|s[0])&(s[3]|~s[2]|~s[1]|~s[0])&(~s[3]|s[2]|s[1]|~s[0])&(~s[3]|~s[2]|~s[1]|~s[0])&(~s[3]|s[2]|~s[1]|s[0]));
assign h[4] = ~((s[3]|s[2]|s[1]|~s[0])&(s[3]|s[2]|~s[1]|~s[0])&(s[3]|~s[2]|s[1]|s[0])&(s[3]|~s[2]|s[1]|~s[0])&(s[3]|~s[2]|~s[1]|~s[0])&(~s[3]|s[2]|s[1]|~s[0]));
assign h[5] = ~((s[3]|s[2]|s[1]|~s[0])&(s[3]|s[2]|~s[1]|s[0])&(s[3]|s[2]|~s[1]|~s[0])&(s[3]|~s[2]|~s[1]|~s[0])&(~s[3]|~s[2]|s[1]|~s[0]));
assign h[6] = ~((s[3]|s[2]|s[1]|s[0])&(s[3]|s[2]|s[1]|~s[0])&(s[3]|~s[2]|~s[1]|~s[0])&(~s[3]|~s[2]|s[1]|s[0]));

endmodule