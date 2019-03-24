module control_unit(input[5:0] opCode, 
			  input clk, reset,
                          output reg[3:0] ALUOp, output reg[1:0] PCWriteCond, ALUSrcB, PCSource,
                          output reg PCWrite, IorD, MemRead, MemWrite, MemtoReg, IRWrite, ALUSrcA, RegWrite, RegDst);
    
//    always @(*)
//        begin
//            if (reset) 
//                begin
//                    ALUOp = 4'b0000; 
//		    PCWriteCond = 2'b00;
//                    PCWrite = 1'b0;
//		    IorD = 1'b0;
//		    MemRead = 1'b0;
//		    MemWrite = 1'b0;
//		    MemtoReg = 1'b0;
//		    IRWrite = 1'b0;
//		    ALUSrcB = 1'b0;
//		    ALUSrcA = 1'b0;
//		    RegWrite = 1'b0; 
//		    RegDst = 1'b0;
//                end
//        end
	
	// states
     localparam FETCH    = 3'd0,
                DECODE   = 3'd1,
                EXECUTE = 3'd2,
						INCREMENT_PC = 3'd3,
						INCREMENT_PC_EXECUTE = 3'd4;
	
	// opcodes
	localparam 
                R_TYPE = 6'b000000,
                ADDI   = 6'b001000,
              
					BEQ   = 6'b000100,
					BGTZ   = 6'b000111,
					BLEZ   = 6'b000110,  
					BNE   = 6'b000101,
					J   = 6'b000010,
					JAL   = 6'b000011,
					LW   = 6'b100011,
					SW   = 6'b101011;	
	// ALUOps
	localparam 
                R_OP = 1'b0,
		ADD = 1'b1;

	reg [4:0] current_state, next_state; 	

	always@(*)
    	begin // state_table 
            case (current_state)
                FETCH: next_state = DECODE;
					 DECODE: next_state = EXECUTE;	
					 EXECUTE: begin
						case (opCode)
							J: next_state = FETCH;
							JAL: next_state = FETCH;
							default: next_state = INCREMENT_PC;
							endcase
					end		
					 INCREMENT_PC: next_state = INCREMENT_PC_EXECUTE;	
					 default: next_state = FETCH;
        endcase
    end 

   // assign output based on current state
always @(*)
    begin: enable_signals
        // By default make all our signals 0
        	    ALUOp = 4'b0000; 
		    PCWriteCond = 2'b00;
           	    PCWrite = 1'b0;
		    IorD = 1'b0;
		    MemRead = 1'b0;
		    MemWrite = 1'b0;
		    MemtoReg = 1'b0;
		    IRWrite = 1'b0;
		    ALUSrcB = 2'b0;
		    ALUSrcA = 1'b0;
		    RegWrite = 1'b0; 
		    RegDst = 1'b0;
 case (current_state)
            FETCH: begin  // get the instruction into the IR
                IRWrite = 1'b1;
		MemRead = 1'b1;
                end
            DECODE: begin // decode the instruction and prepare the values
           
					case(opCode)
						R_TYPE: begin 
							ALUSrcA = 1'b1;
							ALUSrcB = 2'b00;
							RegDst = 1'b0;
							ALUOp = R_OP;
						end
						ADDI: begin 
							ALUSrcA = 1'b1;
							ALUSrcB = 2'b11;
							RegDst = 1'b0;
							ALUOp = ADD;
						end
						BEQ: begin 
							
						end
						BGTZ: begin 
							
						end
						BLEZ: begin 
							
						end
						BNE: begin 
							
						end
						J: begin 
							PCSource = 2'b10;
						end
						JAL: begin 
							
						end
						LW: begin 
							
						end
						SW: begin 
							
						end	
					endcase
				end 
	    EXECUTE: begin // get the values to where they belong, ie. their correct registers
			case(opCode)
					R_TYPE: begin 
						ALUSrcA = 1'b1;
						ALUSrcB = 2'b00;
						RegDst = 1'b0;
						ALUOp = R_OP;
						RegWrite = 1'b1;
					end
               				ADDI: begin 
						ALUSrcA = 1'b1;
						ALUSrcB = 2'b11;
						RegDst = 1'b0;
						ALUOp = ADD;
						RegWrite = 1'b1;
					end
					BEQ: begin 
						
					end
					BGTZ: begin 
						
					end
					BLEZ: begin 
						
					end
					BNE: begin 
						
					end
					J: begin 
						PCSource = 2'b10;
						PCWrite = 1'b1;
					end
					JAL: begin 
						
					end
					LW: begin 
						
					end
					SW: begin 
						
					end	
				endcase
		end
	INCREMENT_PC: begin
		ALUSrcA = 1'b0;
		ALUSrcB = 2'b01;
	end
	INCREMENT_PC_EXECUTE: begin
		ALUSrcA = 1'b0;
		ALUSrcB = 2'b01;
		PCWrite = 1'b1;
	end
                

        // default:    // don't need default since we already made sure all of our outputs were assigned a value at the start of the always block
        endcase
	end
                                
                                
endmodule 


// still need to account for branching and loading to and from memory
