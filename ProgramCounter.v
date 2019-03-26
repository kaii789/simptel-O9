module ProgramCounter(
	reset,
	clk,
	PC_in,
	PC_out,
	enable
	);

	input reset;
	input clk;
	input enable;
	input [31:0] PC_in;
	output [31:0] PC_out;
	reg [31:0] PC_out;
	
	initial begin
		PC_out = 32'b00000000000000000000000000000000;
	end
	
	always @(posedge clk)
		begin
		if (reset)
			PC_out = 32'b00000000000000000000000000000000;
		else if (enable)
			PC_out = PC_in;
		end
			
			
	// MIGHT NEED TO MODIFY THIS TO ADD AN ENABLE FEATURE. DONE
			
endmodule
