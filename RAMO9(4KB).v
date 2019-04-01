module RAMO9(input [15:0] address,
	input clock,
	input [31:0] data,
	input wren,
	output [31:0] q); 

	reg  [31:0] memory[1023:0];
	
	// initialize our RAM 
	initial
	begin
		$readmemb("/h/u7/c7/04/fanyao2/Simptel-O9/fib.mem", memory, 0, 12); // TODO: edit with program changes
	end

	always @(posedge clock) begin 
		if (wren)
			memory[address] <= data;
	end
	assign q = memory[address];  

endmodule
