module datapath(
	PCWriteCond,
	PCWrite,
	IorD,
	MemRead,
	MemWrite,
	MemtoReg,
	IRWrite,
	PCSource,
	ALUOp,
	ALUSrcB,
	ALUSrcA,
	RegWrite,
	RegDst,
	clk,
	reset
);


	input PCWriteCond, PCWrite, IorD, MemRead, MemWrite, MemtoReg, IRWrite, ALUOp, ALUSrcB, ALUSrcA, RegWrite, RegDst, clk, reset;
	input [1:0] PCSource;
	output [5:0] opCode;
	
	wire [31:0] ALU_Out_Bus;
	wire [31:0] instr_shifted;
	wire [31:0] mux_F_out;
	wire [31:0] PC_Out_Bus;
	wire [31:0] mux_A_out;
	wire 
	
	three_to_one_mux mux_F(
		.sel(PCSource[1:0]),
		.in_0(ALU_Out_Bus), // something weird here
		.in_1(ALU_Out_Bus),
		.in_2(instr_shifted),
		.q(mux_F_out)
	);
	
	ProgramCounter program_counter(
		.reset(reset),
		.clk(clk),
		.PC_in(mux_F_out),
		.PC_out(PC_Out_Bus)
	);
	
	two_two_one_mux mux_A(
		.sel(IorD),
		.in_0(PC_Out_Bus),
		.in_1(ALU_Out_Bus),
		.q(mux_A_out)
	);
	
	ram32x8 Memory(
		.address(mux_A_out),
		.clock(clk),
		.data(),
	);
	

endmodule

module and(in_0, in_1, q);
	input in_0, in_1;
	output q;
	
	assign q = in_0 & in_1;
endmodule

module or(in_0, in_1, q);
	input in_0, in_1, q;
	output q;
	
	assign q = in_0 | in_1;
endmodule

module two_to_one_mux(in_0, in_1, sel, q);
	input [31:0] in_0, in_1;
	input sel;
	output [31:0] q;
	reg [31:0] q;
	
	always @(in_0 or in_1 or sel)
		if (sel == 1'b0)
			q = in_0;
		else
			q = in_1;
		
endmodule

module three_to_one_mux(in_0, in_1, in_2, sel, q);
	input [31:0] in_0, in_1, in_2;
	input [1:0] sel;
	output [31:0] q;
	reg [31:0] q;
	
	always @(in_0 or in_1 or in_2 or sel)
		if (sel == 1'b0)
			q = in_0;
		else if (sel == 1'b1)
			q = in_1;
		else
			q = in_2;
		
endmodule
