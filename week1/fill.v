// Part 2 skeleton

module fill
	(
		CLOCK_50,						//	On Board 50 MHz
		state,
		command,
		enable,
		qOut,
		xOut,
		yOut,
		reset,
		blackDone
	);

	input			CLOCK_50;	
	input [2:0] state;
	input [1:0] command;
	input enable;
	input reset;
	input blackDone;
	output [2:0] qOut;
	output [7:0] xOut;
	output [7:0] yOut;
	
	reg [2:0]q;
	reg [14:0] addr;
	reg [7:0]xc;
	reg [7:0]yc;

	assign qOut = q;
	assign xOut = xc;
	assign yOut = yc;
	
	wire clk = CLOCK_50;
	
	wire [2:0]pressOut, keyOut,clickOut,quitOut,startOut,blackOut;
	
	
	always@(posedge CLOCK_50) begin

		if(enable || addr>=15'd19200 || ~reset) 
		begin
			addr <= 15'd0;
			xc <= 8'd0;
			yc<=8'd0;
		end
		
					
		else if (xc >= 8'd160) begin
			yc <= yc+ 1'd1;
			xc <= 8'd0;
		end
		
		else if(addr<15'd19200) begin 
		xc <= xc+8'd1;
		addr <= addr+15'd1;
		end


		else
			xc <= xc+ 1'd1;

	end
	
	
	always@(*)
	begin	
	
		if (state == 2'b01)
		begin
			q <= quitOut;
		end
		
		else if (state == 3'b111)
			q <= startOut;
		
		else
		begin
			
			if (!blackDone)
			begin
				q <= blackOut;
			end
			else if (command == 2'b00)
			begin
				q <= pressOut;
			end
		
			else if (command == 2'b01)
			begin
				q <= keyOut;
			end
			
			else if (command == 2'b11)
			begin
				q <= clickOut;
			end
			
			else
				q <=quitOut;
			
		end
		
		
	end
	
	
	pressitRam r1(
	addr,
	CLOCK_50,
	3'b0,
	1'b0,
	pressOut);

	keyItRam r2(
	addr,
	CLOCK_50,
	3'b0,
	1'b0,
	keyOut);
	
	clickItRam r3(
	addr,
	CLOCK_50,
	3'b0,
	1'b0,
	clickOut);
	
	quitRam r4(
	addr,
	CLOCK_50,
	3'b0,
	1'b0,
	quitOut);
	
	startRam r5(
	addr,
	CLOCK_50,
	3'b0,
	1'b0,
	startOut);
	
	blackRam r6(
	addr,
	CLOCK_50,
	3'b0,
	1'b0,
	blackOut);
	
	
endmodule


