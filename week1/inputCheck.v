/*
	-Give each input type its own hot signal
	-Every clock cycle, look through all signals too see if any of them are hot.
	-Assuming that at a single clock cycle only one signal will be hot check too see if it is the correct signal
	-This checking is done in a time window between enable signals
	-Game ends immediately if incorrect command in inputted
*/



module inputCheck (
A,				//key[1]
B,				//key[2]
C,				//key[3]
command,
clk,
enable,
state,
start

);

		input A,B,C;
		input [1:0] command;
		input clk;
		input enable;
		input start;
		output [2:0]state;
		
		reg [2:0]currState,nextState;
		reg right;
		reg wrong;
		assign state = currState;
		
		
		

		

		
		
	always@(*)
	begin		
			case(command)
			2'b00:
			begin
				right <= A&(~B)&(~C);
				wrong <= (~A)&(B|C);
			end
			
			2'b01:
			begin
				right <= B&(~A)&(~C);
				wrong <= (~B)&(A|C);
			end
			
			2'b11:
			begin
				right <= C&(~B)&(~A);
				wrong <= (~C)&(B|A);
			end		
			
			endcase
			
			if (enable)
			begin
			right <= 1'b0;
			wrong <= 1'b0;
			end
			
	end
		
		
	always@(*)
	begin
			case(currState) 
			2'b00: //check state
				begin
					if (wrong == 1'b1)
						nextState = 2'b01;
					else if(~start)
						nextState = 2'b10;
					else if(enable == 1'b1)
						nextState = 2'b01;
					else if (right == 1'b1)
						nextState = 2'b11;
					else if (enable == 1'b0)
						nextState = 2'b00;
					else
						nextState = 2'b00;
				end
			2'b01: //quit state
				if (~start)
					nextState = 2'b10;
				else
					nextState = 2'b01;
									
			2'b10: //start state
			begin
				if (start)
					nextState = 3'b111;
				else
					nextState = 2'b10;
			end
			2'b11:
				begin
					if (enable == 1'b1)
							nextState = 2'b00;
					else if (wrong == 1'b1)
							nextState = 2'b01;
					
					else if (enable == 1'b0)
						nextState = 2'b11;
					else
						nextState = 2'b00;
				end	
				
			3'b101: //check-wait
			begin
			
				if(start)
					nextState = 2'b00;
				else
					nextState = 3'b101;
			
			end
			
			3'b111:  //start-wait
			begin
				if (~start)
					nextState = 3'b101;
				else
					nextState = 3'b111;
			end
			default:
			begin
				currState = 2'b00;
				nextState = 2'b00;
				end
		endcase
	end

	always@(posedge clk)
  
		begin: state_FFs
     
			//if(!resetn)       
			//	currState <= 2'b01; 
 	   
			            
				currState <= nextState;
				
		end 



endmodule
