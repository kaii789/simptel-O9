module ShiftLeft(to_shift, shifted);
	input [31:0] to_shift;
	output [31:0] shifted;
	wire [31:0] shifted
	
	assign shifted = to_shifter << to_shift;

endmodule