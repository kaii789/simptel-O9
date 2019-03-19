module MemoryDataRegister(clk, MDR_in, MDR_out);

	input clk;
	input [31:0] MDR_in;
	output [31:0] MDR_out;
	reg [31:0] MDR_out;
	
	always @(posedge clk)
		MDR_out <= MDR_in;

endmodule