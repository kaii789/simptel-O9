module ALU_Decoder(Function_code, ALU_optcode, ALU_control);
	input [5:0] Function_code;
	input ALU_optcode;
	output reg [3:0] ALU_control;
	
	always @(*)
		begin
			if (ALU_optcode)
				ALU_control = 4'b0000; // add
			else  
				begin
					case(Function_code)
						6'b100000: ALU_control = 4'b0000; // add
						6'b011010: ALU_control = 4'b0011; // div
						6'b011000: ALU_control = 4'b0010; // mult
						6'b100010: ALU_control = 4'b0001; // sub
						6'b100100: ALU_control = 4'b1000; // and
						6'b100111: ALU_control = 4'b1011; // nor
						6'b100101: ALU_control = 4'b1001; // or
						6'b100110: ALU_control = 4'b1010; // xor
						6'b000000: ALU_control = 4'b0100; // logical left shift
						6'b000010: ALU_control = 4'b0101; // logical right shift
					endcase

				end	
			
		end 
		

endmodule
