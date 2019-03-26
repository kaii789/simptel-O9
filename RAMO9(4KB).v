module RAMO9(input [15:0] address,
	input clock,
	input [31:0] data,
	input wren,
	output [31:0] q); 

	reg  [31:0] memory[1023:0];
	
	// initialize our RAM 
	initial
	begin
		$readmemb("C:\\DESL\\Quartus18\\Projects\\Simptel-O9-master\\simp_prog.mem", memory, 0, 2);	
	end

	always @(posedge clock) begin 
		if (wren)
			memory[address] <= data;
	end
	assign q = memory[address];  

endmodule
