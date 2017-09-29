// Part 2 skeleton

module test
	(
		CLOCK_50,						//	On Board 50 MHz
		// Your inputs and outputs here
		// The ports below are for the VGA output.  Do not change.
		KEY,
		SW,
		LEDR,
		
		VGA_CLK,   						//	VGA Clock
		VGA_HS,							//	VGA H_SYNC
		VGA_VS,							//	VGA V_SYNC
		VGA_BLANK_N,						//	VGA BLANK
		VGA_SYNC_N,						//	VGA SYNC
		VGA_R,   						//	VGA Red[9:0]
		VGA_G,	 						//	VGA Green[9:0]
		VGA_B   						//	VGA Blue[9:0]
	);

	input			CLOCK_50;				//	50 MHz
	// Declare your inputs and outputs here
	// Do not change the following outputs
	input [9:0] SW;
	input [3:0] KEY;
	
	output [9:0] LEDR;
	assign LEDR[0] = writeEn;
	
	assign LEDR[1] = SW[1];
	
	output			VGA_CLK;   				//	VGA Clock
	output			VGA_HS;					//	VGA H_SYNC
	output			VGA_VS;					//	VGA V_SYNC
	output			VGA_BLANK_N;				//	VGA BLANK
	output			VGA_SYNC_N;				//	VGA SYNC
	output	[9:0]	VGA_R;   				//	VGA Red[9:0]
	output	[9:0]	VGA_G;	 				//	VGA Green[9:0]
	output	[9:0]	VGA_B;   				//	VGA Blue[9:0]
	
	wire resetn;
	assign resetn = KEY[0];
	
	// Create the colour, x, y and writeEn wires that are inputs to the controller.

	wire [2:0] colour;
	wire [7:0] x;
	wire [6:0] y;
	wire writeEn;
	
	wire title_go;
	assign title_go = ~KEY[1];

	wire load_done;
	assign load_done = ~KEY[2];
	
	wire side_view;
	assign side_view = ~KEY[3]; 
	
	wire [14:0] colour_address;
	
	wire [2:0] load_colour;
	wire [2:0] case_colour;
	wire [2:0] side_colour;
	
	wire ld_title, ld_load, ld_case, ld_side_case;

	// Create an Instance of a VGA controller - there can be only one!
	// Define the number of colours as well as the initial background
	// image file (.MIF) for the controller.
	vga_adapter VGA(
			.resetn(resetn),
			.clock(CLOCK_50),
			.colour(colour),
			.x(x),
			.y(y),
			.plot(writeEn),
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
		defparam VGA.BACKGROUND_IMAGE = "titlescreen.mif";
			
	// Put your code here. Your code should produce signals x,y,colour and writeEn
	// for the VGA controller, in addition to any other functionality your design may require.
	
	ram load_screen (
	.address(colour_address),
	.clock(CLOCK_50),
	.data(3'b000),
	.wren(1'b0),
	.q(load_colour));
	
	caseram case_screen (
	.address(colour_address),
	.clock(CLOCK_50),
	.data(3'b000),
	.wren(1'b0),
	.q(case_colour));
	
	sideram side_screen (
	.address(colour_address),
	.clock(CLOCK_50),
	.data(3'b000),
	.wren(1'b0),
	.q(side_colour));
	
	control c0 (
	.clk(CLOCK_50),
	.resetn(resetn),

	.title_go(title_go),
	.load_done(load_done), // to signify load is done and to go to game
	.side_view(side_view),
	
	.ld_title(ld_title),
	.ld_load(ld_load),
	.ld_case(ld_case),
	.ld_side_case(ld_side_case),
	.writeEn(writeEn)
	);
	
	data d0 (
	.clk(CLOCK_50),
	.resetn(resetn),
	
	.ld_title(ld_title),
	.ld_load(ld_load),
	.ld_case(ld_case),
	.ld_side_case(ld_side_case),
	
	.load_colour(load_colour),
	.case_colour(case_colour),
	.side_colour(side_colour),
	
	.colour_address(colour_address),
	.x(x),
	.y(y),
	.colour(colour)
	);
endmodule

module control (
	input clk,
	input resetn,

	input title_go,
	input load_done, // to signify load is done and to go to game
	input side_view,
	
	output reg ld_title,
	output reg ld_load,
	output reg ld_case,
	output reg ld_side_case,
	output reg writeEn
);

	// game loading and finishing
	reg [2:0] current_state_load;
	reg [2:0] next_state_load;
	
	localparam		S_LOAD_TITLE			= 3'd0,
					S_LOAD_LOAD_WAIT		= 3'd1,
					S_LOAD_LOAD				= 3'd2, // get good to go command from other fsm
					S_LOAD_CASE				= 3'd3,
					S_LOAD_SIDE				= 3'd4;
					
	// game playing
	reg [2:0] current_state_play;
	reg [2:0] next_state_play;
	
	localparam		S_PLAY_WAIT				= 3'd0,
					S_PLAY_CASE				= 3'd1;

	always@(*)
	begin: load_states
		case (current_state_load)
			S_LOAD_TITLE:
				next_state_load = title_go ? S_LOAD_LOAD_WAIT : S_LOAD_TITLE;
			S_LOAD_LOAD_WAIT:
				next_state_load = title_go ? S_LOAD_LOAD_WAIT : S_LOAD_LOAD;
			S_LOAD_LOAD:
				next_state_load = load_done ? S_LOAD_CASE : S_LOAD_LOAD;
			S_LOAD_CASE:
				next_state_load = side_view ? S_LOAD_SIDE : S_LOAD_CASE;
			S_LOAD_SIDE:
				next_state_load = side_view ? S_LOAD_SIDE : S_LOAD_CASE;
			default: next_state_load = S_LOAD_TITLE;
		endcase
	end
	
	always@(*)
	begin: play_states
		case (current_state_play)
			S_PLAY_WAIT: 
				next_state_play = (current_state_load == S_LOAD_CASE) ? S_PLAY_CASE : S_PLAY_WAIT;
			default: next_state_play = S_PLAY_WAIT;
		endcase
	end
	
	always@(*)
	begin: load_signals
		ld_title 		= 1'd0;
		ld_load 		= 1'd0;
		ld_case			= 1'd0;
		ld_side_case	= 1'd0;
		writeEn			= 1'd0;
		
		case (current_state_load)
			S_LOAD_TITLE:
				ld_title 		= 1'b1;
			S_LOAD_LOAD: begin
				ld_load 			= 1'b1;
				writeEn			= 1'b1;
				end
			S_LOAD_CASE: begin
				ld_case 			= 1'b1;
				writeEn			= 1'b1;
				end
			S_LOAD_SIDE: begin
				ld_side_case	= 1'd1; 
				writeEn			= 1'd1;
				end
		endcase
	end
	
	always@(*)
	begin: play_signals
	end
	
	always@(posedge clk)
	begin: reset_state
		if (!resetn) begin
			current_state_load 	<= S_LOAD_TITLE;
			current_state_play 	<= S_PLAY_WAIT;
		end
		else begin
			current_state_load 	<= next_state_load;
			current_state_play 	<= next_state_play;
		end
	end
endmodule

module data (
	input clk,
	input resetn,
	
	input ld_title,
	input ld_load,
	input ld_case,
	input ld_side_case,
	
	input [2:0] load_colour,
	input [2:0] case_colour,
	input [2:0] side_colour,
	
	output reg [14:0] colour_address,
	output reg [7:0] x,
	output reg [6:0] y,
	output reg [2:0] colour
);

	reg done_load;
	reg done_case;
	reg done_side;

	always@(posedge clk)
	begin: load_data
		if (!resetn) begin
			colour_address 	<= 15'd0;
			x 						<= 8'd0; 
			y						<= 7'd0;
			colour				<= 3'd0;
			done_load			<= 1'b0;
			done_case			<= 1'b0;
			done_side			<= 1'b0;
		end
		else begin
			if (ld_title) begin
			end
			
			if (ld_load) begin
				// parameters for future
				done_case		<= 1'b0;
				done_side		<= 1'b0;
			
				if (colour_address < 15'd19200 && !done_load) begin
					// parameters to draw
					colour 				<= load_colour;
					x 						<= colour_address % 15'd160;
					y						<= colour_address / 15'd160;
					colour_address 	<= colour_address + 15'd1;
					end
				else begin
					colour_address 	<= 15'd0;
					done_load			<= 1'b1;		// prevents before happening
				end
			end
			
			if (ld_case) begin
				// parameters for future
				done_load		<= 1'b0;
				done_side		<= 1'b0;
				
				if (colour_address < 15'd19200 && !done_case) begin
					// parameters to draw
					colour 				<= case_colour;
					x 						<= colour_address % 15'd160;
					y						<= colour_address / 15'd160;
					colour_address 	<= colour_address + 15'd1;
					end
				else begin
					colour_address 	<= 15'd0;
					done_case			<= 1'b1;		// prevents before happening
				end
			end
			
			if (ld_side_case) begin
				// parameters for future
				done_case		<= 1'b0;
				done_load		<= 1'b0;
				
				if (colour_address < 15'd19200 && !done_side) begin
					// parameters to draw
					colour 				<= side_colour;
					x 						<= colour_address % 15'd160;
					y						<= colour_address / 15'd160;
					colour_address 	<= colour_address + 15'd1;
					end
				else begin
					colour_address 	<= 15'd0;
					done_side			<= 1'b1;		// prevents before happening
				end
			end
			
		end
	end
endmodule