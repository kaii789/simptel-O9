module SignExtend(to_extend, extended);
	
	input [15:0] to_extend;
	output [31:0] extended;

	assign extended[31:0] = { {8{to_extend[15]}}, to_extend[15:0] };
	
endmodule