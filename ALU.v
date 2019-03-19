module ALU(
	input clk,
	input [31:0] src_A,
	input [31:0] src_B,
	input [2:0] ALU_control,
	output zero,
	output reg [31:0] ALU_result
	);
	
	always @(*)
	begin
		case (ALU_control)
		3'b000: ALU_result = src_A & src_B; // and
		3'b001: ALU_result = src_A | src_A; // or
		3'b010: ALU_result = a + b; // add
		3'b110: ALU_result = a - b; // subtract
		3'b111: begin if (a < b) ALU_result = 32'd1; // set on less than
								else result = 32'd0;
								end
		default: result = a + b; // add
		endcase
	end
	
	assign zero = (ALU_result == 32'd0) ? 1'b1 : 1'b0; // set zero to be 0 if result is 0.
	
endmodule
