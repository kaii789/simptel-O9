 module control_unit(input[5:0] opCode, 
			  input clk, reset, 
		    	  output reg[1:0] ALUOp, 
				  output reg PCWriteCond,
                          output reg[1:0] ALUSrcB, PCSource,
                          output reg PCWrite, IorD, MemWrite, MemtoReg, IRWrite, ALUSrcA, RegWrite, RegDst);

     // states
     localparam FETCH    = 3'd0,
                DECODE   = 3'd1,
                EXECUTE = 3'd2,
		INCREMENT_PC = 3'd3,
		INCREMENT_PC_EXECUTE = 3'd4,
		BRANCH = 3'd5,
		END_STATE = 3'd6,
		BRANCH_EXECUTE = 3'd7;
	
	// opcodes
	localparam 
		 R_TYPE = 6'b000000,
		 ADDI   = 6'b001000,
		BEQ   = 6'b000100,  
		J   = 6'b000010,
		END = 6'b111111;
	// ALUOps
	localparam 
		R_OP = 2'b0,
      ADD = 2'b01,
		SUB = 2'b10;
		

	reg [4:0] current_state, next_state; 	
	
	initial begin
	current_state = FETCH;
	end
	
	always@(*)
    	begin // state_table 
            case (current_state)
                FETCH: next_state = DECODE;
		DECODE: next_state = EXECUTE;	
		EXECUTE: begin
				case (opCode)
					J: next_state = FETCH;
					BEQ: next_state = BRANCH;
					END: next_state = END_STATE;
					default: next_state = INCREMENT_PC;
				endcase
			end		
		 INCREMENT_PC: next_state = INCREMENT_PC_EXECUTE;	
		 BRANCH: next_state = BRANCH_EXECUTE;
		 BRANCH_EXECUTE: next_state = INCREMENT_PC;    
		 END_STATE: next_state = END_STATE;
		 default: next_state = FETCH;
        endcase
    end 

   // assign output based on current state
always @(*)
    begin: enable_signals
        // By default make all our signals 0
	 ALUOp = 1'b0; 
	 PCWriteCond = 1'b0;
	 PCWrite = 1'b0;
	 IorD = 1'b0;
	 MemWrite = 1'b0;
	 MemtoReg = 1'b0;
	 IRWrite = 1'b0;
	 ALUSrcB = 2'b0;
	 ALUSrcA = 1'b0;
	 RegWrite = 1'b0; 
	 RegDst = 1'b0;
	 PCSource = 2'b00;
 case (current_state)
            FETCH: begin  // get the instruction into the IR
                IRWrite = 1'b1;
		IorD = 1'b0;
                end
            DECODE: begin // decode the instruction and prepare the values

			case(opCode)
				R_TYPE: begin 
					ALUSrcA = 1'b1;
					ALUSrcB = 2'b00;
					RegDst = 1'b1;
					ALUOp = R_OP;
				end
				ADDI: begin 
					ALUSrcA = 1'b1;
					ALUSrcB = 2'b10;
					RegDst = 1'b0;
					ALUOp = ADD;
				end
				BEQ: begin 
					ALUSrcA = 1'b0;
					ALUSrcB = 2'b10;
					ALUOp = ADD;
				end
				J: begin 
					PCSource = 2'b10;
				end
			endcase
		end 
	    EXECUTE: begin // get the values to where they belong, ie. their correct registers
			case(opCode)
					R_TYPE: begin 
						ALUSrcA = 1'b1;
						ALUSrcB = 2'b00;
						RegDst = 1'b1;
						ALUOp = R_OP;
						RegWrite = 1'b1;
					end
               ADDI: begin 
						ALUSrcA = 1'b1;
						ALUSrcB = 2'b10;
						RegDst = 1'b0;
						ALUOp = ADD;
						RegWrite = 1'b1;
					end
					BEQ: begin 
						ALUSrcA = 1'b1;
						ALUSrcB = 2'b00;
						PCSource = 2'b01;
						PCWriteCond = 1'b1;
						ALUOp= SUB;
					end
					J: begin 
						PCSource = 2'b10;
						PCWrite = 1'b1;
					end
				endcase
		end
	INCREMENT_PC: begin
		ALUSrcA = 1'b0;
		ALUSrcB = 2'b01;
		ALUOp = ADD;
	end
	INCREMENT_PC_EXECUTE: begin
		ALUSrcA = 1'b0;
		ALUSrcB = 2'b01;
		ALUOp = ADD;
		PCWrite = 1'b1;
	end
    BRANCH: begin
		ALUSrcA = 1'b1;
		ALUSrcB = 2'b00;
		PCSource = 2'b01;
		ALUOp = SUB;
		PCWriteCond = 1'b1;
	end
		BRANCH_EXECUTE: begin
			ALUSrcA = 1'b1;
			ALUSrcB = 2'b00;
			PCSource = 2'b01;
			PCWrite = 1'b0;
			// PCWriteCond = 1'b1;
			ALUOp = SUB;
	end

        // default:    // don't need default since we already made sure all of our outputs were assigned a value at the start of the always block
        endcase
	end
                                
   
	always @(posedge clk)
	begin
		current_state <= next_state;
	end
	
endmodule 

