// Part 2 skeleton

module fill
	(
		CLOCK_50,						//	On Board 50 MHz
		state,
		command,
		enable,
		qOut,
		xOut,
		yOut

	);

	input			CLOCK_50;				//	50 MHz
	// Declare your inputs and outputs here
	// Do not change the following outputs
	input [1:0] state;
	input [1:0] command;
	input enable;
	output [2:0] qOut;
	output [7:0] xOut;
	output [7:0] yOut;
	
	reg [2:0]q;
	reg [14:0] addr;
	reg [7:0]xc;
	reg [7:0]yc;

	initial xc = 8'b0;

	assign qOut = q;
	assign xOut = xc;
	assign yOut = yc;
	
	wire clk = CLOCK_50;
	wire resetn;
	
	wire [2:0]pressOut, keyOut,clickOut,quitOut;
	
	
	always@(posedge CLOCK_50) begin

		if(!enable || addr==15'd19200) 
		begin
			addr <= 15'd0;
			xc <= 8'd0;
			yc<=8'd0;
		end
		
		else
		begin
					xc 					<= addr % 15'd160;
					yc						<= addr / 15'd160;
					colour_address 	<= addr + 15'd1;
		end


	end
	
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
	
	
	always@(*)
	begin	
	
		if (state == 2'b01)
		begin
			q <= 3'b000;
			//q <= quitOut;
		end
		
		else if (command == 2'b00)
		begin
			q <= 3'b001;
			//q <= pressOut;
		end
		
		else if (command == 2'b01)
		begin
			q <= 3'b010;
			//q <= keyOut;
		end
		
		else if (command == 2'b11)
		begin
			q <= 3'b011;
			//q <= clickOut;
		end
		
		else
			q <= 3'b111;
			//q <=quitOut;
		
		
	end
	
	/*
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
	*/
	/*
	vga_adapter VGA(
			.resetn(1'b1),
			.clock(CLOCK_50),
			.colour(q),
			.x(xc),
			.y(yc),
			.plot(1'b1),
			// Signals for the DAC to drive the monitor. 
			.VGA_R(vga_R),
			.VGA_G(vga_G),
			.VGA_B(vga_B),
			.VGA_HS(vga_HS),
			.VGA_VS(vga_VS),
			.VGA_BLANK(vga_BLANK_N),
			.VGA_SYNC(vga_SYNC_N),
			.VGA_CLK(vga_CLK));
			
		defparam VGA.RESOLUTION = "160x120";
		defparam VGA.MONOCHROME = "FALSE";
		defparam VGA.BITS_PER_COLOUR_CHANNEL = 1;
		defparam VGA.BACKGROUND_IMAGE = "start.mif";
	
	*/
	
endmodule

