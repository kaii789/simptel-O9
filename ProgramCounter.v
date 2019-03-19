module ProgramCounter(
	input reset,
	input clk,
	input [31:0] PC_in,
	output [31:0] PC_out,
	reg [31:0] PC_out
	);

	always @(posedge clk)
		if (reset)
			PC_out = 32'b00000000000000000000000000000000;
		else
			PC_out = PC_in;
			
endmodule