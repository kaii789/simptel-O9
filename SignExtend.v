module SignExtend(to_extend, extended);
	
	input [15:0] to_extend;
	output [31:0] extended;

	assign extended[31:0] = { {16{to_extend[15]}}, to_extend[15:0] };
	
endmodule

module SignExtend_26_bit(to_extend, extended);

	input [25:0] to_extend;
	output [31:0] extended;
	
	assign extended[31:0] = { {6{to_extend[25]}}, to_extend[25:0]  };
endmodule