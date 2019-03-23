module ALU(
	input clk,
	input [31:0] src_A,
	input [31:0] src_B,
	input [3:0] ALU_control,
	output zero,
	output reg [31:0] ALU_result
	);
	
	always @(*)
	begin
		case (ALU_control)
		4'b1000: ALU_result = src_A & src_B; // and
		4'b1001: ALU_result = src_A | src_B; // or
		4'b1011: ALU_result = ~(src_A | src_B); // nor
		4'b1010: ALU_result = A ^ B; // xor
		4'b0100: ALU_result = A << 1; // shift left
		4'b0101: ALU_result = A >> 1; // shift right
		4'b0000: ALU_result = src_A + src_B; // add
		4'b0001: ALU_result = src_A - src_B; // subtract
		4'b0010: ALU_result = src_A * src_B; // multiplication
		4'b0011: ALU_result = src_A / src_B; // division
		4'b1110: begin if (a > b) ALU_result = 32'd1; // set on less than
								else ALU_result = 32'd0;
								end
		4'b1111: begin if (a == b) ALU_result = 32'd1; // set on equal
								else ALU_result = 32'd0;
								end
		default: ALU_result = src_A + src_B; // add
		endcase
	end
	
	assign zero = (ALU_result == 32'd0) ? 1'b1 : 1'b0; // set zero to be 0 if result is 0.
	
endmodule
