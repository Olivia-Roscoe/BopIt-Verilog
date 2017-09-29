

module ProjectWeek1  (

KEY,
SW,
HEX0,
HEX1,
CLOCK_50,
LEDR,
VGA_CLK,   						//	VGA Clock
VGA_HS,							//	VGA H_SYNC
VGA_VS,							//	VGA V_SYNC
VGA_BLANK_N,						//	VGA BLANK
VGA_SYNC_N,						//	VGA SYNC
VGA_R,   						//	VGA Red[9:0]
VGA_G,	 						//	VGA Green[9:0]
VGA_B, 

);

	input [3:0]KEY;
	input [9:0]SW;
	input CLOCK_50;
	output [6:0] HEX0, HEX1;
	output [9:0]LEDR;
	output			VGA_CLK;   				//	VGA Clock
	output			VGA_HS;					//	VGA H_SYNC
	output			VGA_VS;					//	VGA V_SYNC
	output			VGA_BLANK_N;				//	VGA BLANK
	output			VGA_SYNC_N;				//	VGA SYNC
	output	[9:0]	VGA_R;   				//	VGA Red[9:0]
	output	[9:0]	VGA_G;	 				//	VGA Green[9:0]
	output	[9:0]	VGA_B;   				//	VGA Blue[9:0]

	wire [7:0]num;
	
	wire [7:0] x;
	wire [7:0] y;
	wire [2:0] q;
	
	wire blkDone;
	wire [7:0] score, newHiScore, newCurrScore;

	reg [9:0] lights;

	
	wire [2:0]state;
	
	always@(*)
	begin
		if (state == 2'b01)
			lights <= 10'b1111111111;
		else if (state == 3'b111)
			lights <= 10'b0001110000;
		else if (state == 2'b00)
			lights <= 10'b1110000000;
		else if (~KEY[0])
			lights <= 10'd0;
		else 
			lights <= 10'd0;
	end
	
	
	wire Enable;

	
	
	lfsr r1(SW[7:0],num,CLOCK_50,KEY[0],Enable);

	reg [1:0]command;
	
	assign LEDR[1:0] = command[1:0];
	
	assign LEDR[9:2] = lights[9:2];

	
	always@(*)
	begin
		
		if (num < 8'd85)
			command[1:0] = 2'b00;
		else if (num < 8'd170)
			command[1:0] = 2'b01;
		else
			command[1:0] = 2'b11;
	end
	
	
	inputCheck i1(~KEY[1],~KEY[2],~KEY[3], command,CLOCK_50,Enable,state,KEY[0]);
	
	rateDivision d1(CLOCK_50, Enable, KEY[0], HEX0, HEX1, state, blkDone);
	
	
	
	fill f1(
		CLOCK_50,	
		state,
		command,
		Enable,
		q,
		x,
		y,
		KEY[0],
		blkDone
	);
	
	

	//SCORE KEEPING
	
	always @(posedge Enable)
	begin
		
		if (state == 2'b01)
			begin
			
			end
	
	
	
	
	end
	
	
	
	vga_adapter VGA(
			.resetn(1'b1),
			.clock(CLOCK_50),
			.colour(q),
			.x(x),
			.y(y),
			.plot(1'b1),
			/* Signals for the DAC to drive the monitor. */
			.VGA_R(VGA_R),
			.VGA_G(VGA_G),
			.VGA_B(VGA_B),
			.VGA_HS(VGA_HS),
			.VGA_VS(VGA_VS),
			.VGA_BLANK(VGA_BLANK_N),
			.VGA_SYNC(VGA_SYNC_N),
			.VGA_CLK(VGA_CLK));
		defparam VGA.RESOLUTION = "160x120";
		defparam VGA.MONOCHROME = "FALSE";
		defparam VGA.BITS_PER_COLOUR_CHANNEL = 1;
		defparam VGA.BACKGROUND_IMAGE = "Start.mif";



endmodule 


module lfsr(
seed,
randomNum,
clk,
reset,
enable

);

	input [7:0] seed;
	input clk, reset, enable;
	output [7:0] randomNum;
	
	wire feedback1,feedback2,feedback3,feedback4;
	
	reg [7:0]out;
	
	assign randomNum = out;
	
	assign feedback1 =  (out[7] ^ out[1]);
	assign feedback2 =  (out[7] ^ out[2]);
	assign feedback3 =  (out[7] ^ out[3]);
	assign feedback4 =  (out[7] ^ out[5]);


	 always @(posedge clk) 
	 if (!reset) 
	 begin 
	 out <= seed;
	 end
	 
	 else if (enable)
	 begin
	
		out <= {out[6],feedback4,out[4],feedback3,feedback2,feedback1,out[0],out[7]};
	 
	end 



endmodule